//
//  LCMediator.m
//  LCMediatorDemo
//
//  Created by LuckyCat on 2019/2/27.
//  Copyright © 2019年 LuckyCat. All rights reserved.
//

#import "LCMediator.h"
#import <objc/runtime.h>

#pragma mark - 配置 命名规则 和 拦截器规则
/** target前缀 */
static NSString *const kTargetPrefix = @"LC";
/** target后缀 */
static NSString *const kTargetSuffix = @"Service";
/** action前缀 */
static NSString *const kActionPrefix = @"lcMediator_";

/** 无服务action名 */
static NSString *const kNoResponseName = @"noResponse";

/** 拦截器名 */
static NSString *const kInterceptorClass = @"Mediator";
/** 拦截器检查方法名 */
static NSString *const kCheckURLAction = @"checkURL";
/** 拦截器失败上报方法名 */
static NSString *const kFailedReportAction = @"failedReport";


#pragma mark - 中间件

@interface LCMediator ()
/** 存储target缓存 */
@property (nonatomic, strong) NSMutableDictionary *cachedTarget;
@end

static LCMediator *_instance = nil;
@implementation LCMediator

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}

+ (instancetype)sharedInstance {
    return [[self alloc] init];
}

#pragma mark - 主要方法

/** 远程App调用入口 */
+ (void)openURL:(NSString *)urlString {
    [self openURL:urlString completion:nil];
}

+ (void)openURL:(NSString *)urlString completion:(void(^)(id result, NSError *error))completion {
    // 处理中文、转成url方便取数据
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 拦截检查
    id target = [[self sharedInstance] _targetWithName:kInterceptorClass];
    SEL action = [[self sharedInstance] _actionWithName:kCheckURLAction];
    if ([target respondsToSelector:action]) {
        // 获取服务的检查结果回调,统一处理错误上报
        __block NSError *checkError = nil;
        void(^reformCompletion)(id result, NSError *error) = ^(id result, NSError *error) {
            if (error) {
                checkError = error;
                NSDictionary *failedParams = @{@"target" : NSStringFromClass([target class]),
                                               @"action" : NSStringFromSelector(action),
                                               @"originParams" : @{@"URL" :url},
                                               @"error" : error};
                [[self sharedInstance] _failedReport:failedParams];
            }
        };
        // 使用服务检查
        NSMutableDictionary *params = [@{@"URL" :url, @"completionBlock" : reformCompletion} mutableCopy];
        BOOL isContinue = [[[self sharedInstance] _safePerformTarget:target action:action params:params] boolValue];
        if (!isContinue) {
            if (completion) {
                if (!checkError) {
                    checkError = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:@{@"errorInfo" : @"已拦截做处理"}];
                }
                completion(nil, checkError);
            }
            return;
        }
    }
    
    NSString *actionName = [[url.path stringByRemovingPercentEncoding] stringByReplacingOccurrencesOfString:@"/" withString:@""];
    // 参数转字典
    NSMutableDictionary *params = [@{} mutableCopy];
    NSString *queryString = [url.query stringByRemovingPercentEncoding];
    for (NSString *param in [queryString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if ([elts count] < 2) continue;
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    
    [self openTarget:url.host action:actionName params:params completion:completion];
}

/** 本地组件调用入口, 默认缓存target */
+ (void)openTarget:(NSString *)targetName
            action:(NSString *)actionName
            params:(NSDictionary *)params {
    [self openTarget:targetName action:actionName params:params completion:nil];
}

/** 本地组件调用入口 */
+ (void)openTarget:(NSString *)targetName
            action:(NSString *)actionName
            params:(NSDictionary *)params
        completion:(void(^)(id result, NSError *error))completion {
    NSDictionary *compParams = params;
    if (completion) {
        NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithDictionary:params];
        tmp[@"completionBlock"] = ^(id result, NSError *error) {
            // 获取调用结果回调,统一处理错误上报
            if (completion) {
                completion(result, error);
            }
            if (error) {
                NSMutableDictionary *failedParams = [@{@"target" : targetName,
                                                       @"action" : actionName,
                                                       @"error" : error} mutableCopy];
                if (params) {
                    failedParams[@"originParams"] = params;
                }
                [[self sharedInstance] _failedReport:failedParams];
            }
        };
        compParams = tmp;
    }
    
    // 生成target/action
    NSObject *target = [[self sharedInstance] _targetWithName:targetName];
    SEL action = [[self sharedInstance] _actionWithName:actionName];
    
    NSString *notFoundSelName = kNoResponseName;
    if (target == nil) {
        // 无target 全局统一处理
        [[self sharedInstance] _noTargetActionResponseWithTargetName:kInterceptorClass actionName:notFoundSelName originTargetName:targetName originActionName:actionName originParams:compParams];
        return ;
    }
    // 缓存target
    [[self sharedInstance] cachedTarget][targetName] = target;
    
    if ([target respondsToSelector:action]) {
        // 直接找到对应方法,直接调用,结束后直接回调
        id object = [[self sharedInstance] _safePerformTarget:target action:action params:compParams];
        if (completion) {
            if (object) {
                completion(object, nil);
            } else {
                completion(@(YES), nil);
            }
        }
    } else {
        SEL noParamsAction = [[self sharedInstance] _noParamsActionWithName:actionName];
        if ([target respondsToSelector:noParamsAction]) {
            // 尝试调用对应action无参数方法,结束后直接回调
            id object = [[self sharedInstance] _safePerformTarget:target action:noParamsAction params:params];
            if (completion) {
                if (object) {
                    completion(object, nil);
                } else {
                    completion(@(YES), nil);
                }
            }
        } else if ([target respondsToSelector:[[self sharedInstance] _actionWithName:notFoundSelName]]) {
            // 尝试调用对应target的notFound方法统一处理
            [[self sharedInstance] _noTargetActionResponseWithTargetName:targetName actionName:notFoundSelName originTargetName:targetName originActionName:actionName originParams:compParams];
            
        } else {
            // 全局统一处理无响应情况
            [[self sharedInstance] _noTargetActionResponseWithTargetName:kInterceptorClass actionName:notFoundSelName originTargetName:targetName originActionName:actionName originParams:compParams];
        }
    }
}

/** 释放target */
+ (void)releaseCachedTarget:(NSString *)targetName {
    [[[self sharedInstance] cachedTarget] removeObjectForKey:targetName];
}

#pragma mark - target & action 按缓存或规则获取

- (id)_targetWithName:(NSString *)targetName {
    id target = self.cachedTarget[targetName];
    if (!target) {
        NSString *targetClassString = [self _targetClassStringWithName:targetName];
        target = [[NSClassFromString(targetClassString) alloc] init];
    }
    return target;
}

- (SEL)_actionWithName:(NSString *)actionName {
    NSString *actionString = [self _actionStringWithName:actionName hasParams:YES];
    SEL action = NSSelectorFromString(actionString);
    return action;
}

- (SEL)_noParamsActionWithName:(NSString *)actionName {
    NSString *actionString = [self _actionStringWithName:actionName hasParams:NO];
    SEL action = NSSelectorFromString(actionString);
    return action;
}

#pragma mark - target & action 名称规则

- (NSString *)_targetClassStringWithName:(NSString *)targetName {
    NSMutableString *targetClassString = [targetName mutableCopy];
    // 首字母大写
    NSString *first = [[targetClassString substringToIndex:1] uppercaseString];
    [targetClassString replaceCharactersInRange:NSMakeRange(0, 1) withString:first];
    // 加前缀
    if (![targetClassString hasPrefix:kTargetPrefix]) {
        [targetClassString insertString:kTargetPrefix atIndex:0];
    }
    // 加后缀
    if (![targetClassString hasSuffix:kTargetSuffix]) {
        [targetClassString appendString:kTargetSuffix];
    }
    return targetClassString;
}

- (NSString *)_actionStringWithName:(NSString *)actionName hasParams:(BOOL)hasParams {
    // 加前缀
    if ([actionName hasPrefix:kActionPrefix]) {
        return actionName;
    }
    NSMutableString *newName = [NSMutableString stringWithFormat:@"%@%@", kActionPrefix, actionName];
    if (hasParams) {
        [newName appendString:@":"];
    }
    return newName;
}

#pragma mark - private methods

- (void)_noTargetActionResponseWithTargetName:(NSString *)targetName
                                   actionName:(NSString *)actionName
                             originTargetName:(NSString *)originTargetName
                             originActionName:(NSString *)originActionName
                                 originParams:(NSDictionary *)originParams {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"target"] = targetName;
    params[@"action"] = actionName;
    params[@"originTarget"] = originTargetName;
    params[@"originAction"] = originActionName;
    if (originParams) {
        params[@"originParams"] = originParams;
    }
    
    id target = [self _targetWithName:targetName];
    SEL action = [self _actionWithName:actionName];
    [self _safePerformTarget:target action:action params:params];
}

/** 失败上报 */
- (void)_failedReport:(NSDictionary *)params {
    id failedTarget = [self _targetWithName:kInterceptorClass];
    SEL failedAction = [self _actionWithName:kFailedReportAction];
    if ([failedTarget respondsToSelector:failedAction]) {
        [self _safePerformTarget:failedTarget action:failedAction params:params];
    }
}

- (id)_safePerformTarget:(NSObject *)target action:(SEL)action params:(NSDictionary *)params {
    NSMethodSignature *methodSig = [target methodSignatureForSelector:action];
    if (methodSig == nil) {
        return nil;
    }
    // do method
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    if (params && methodSig.numberOfArguments > 2) {
        [invocation setArgument:&params atIndex:2];
    }
    [invocation setSelector:action];
    [invocation setTarget:target];
    [invocation invoke];
    
    const char *retType = [methodSig methodReturnType];
    if (strcmp(retType, @encode(void)) == 0) {
        return nil;
    }
    
    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(BOOL)) == 0) {
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(CGFloat)) == 0) {
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    // id类型特殊处理,否则crash
    id __unsafe_unretained tmp;
    [invocation getReturnValue:&tmp];
    id result = tmp;
    return result;
}

#pragma mark - Getters

- (NSMutableDictionary *)cachedTarget {
    if (!_cachedTarget) {
        _cachedTarget = [@{} mutableCopy];
        
        // 缓存处理全局的服务类
        NSObject *target = [self _targetWithName:kInterceptorClass];
        if (target) {
            _cachedTarget[kInterceptorClass] = target;
        }
    }
    return _cachedTarget;
}

@end
