//
//  LCMediator.h
//  LCMediatorDemo
//
//  Created by LuckyCat on 2019/2/27.
//  Copyright © 2019年 LuckyCat. All rights reserved.
//
//  中间件（🔥命名规则和拦截器在.m中可配置）
//
//  1. 遵循命名规则
//     (a)target：前缀LC,后缀Service
//     (b)action：前缀lcMediator_
//  2. url检查规则
//     (a)打电话；
//     (b)h5跳转；
//     (c)不是本APP的服务页面；
//     (d)处理本APP的服务。
//  3. 寻找方法规则
//     (a)判断有参数的target，用于需要异步处理的，外部使用kLCMediatorFinalCompletion回调；
//     (b)判断无参数的target，外部不需要处理回调；
//     (c)判断有参数的noResponse，用于需要异步处理的，外部使用kLCMediatorNoResponseCompletion回调；
//     (d)不支持无参数的noResponse，必须有回调，便于统一处理。
//  4. 统一处理规则
//     (a)所有找不到的服务统一到LCMediatorService的noResponse处理；
//     (b)每个模块可以使用自己的noResponse独立处理。
//

#import <UIKit/UIKit.h>

/** 中间件方法结束,有回调 */
static inline void kLCMediatorFinalCompletion(NSDictionary *params, id result, NSError *error) {
    void (^finalCompletion)(id result, NSError *error) = params[@"completionBlock"];
    if (finalCompletion) {
        finalCompletion(result, error);
    }
}

/** 中间件方法结束,有回调 */
static inline void kLCMediatorNoResponseCompletion(NSDictionary *params, id result, NSError *error) {
    void (^finalCompletion)(id result, NSError *error) = params[@"originParams"][@"completionBlock"];
    if (finalCompletion) {
        finalCompletion(result, error);
    }
}

@interface LCMediator : NSObject

/**
 *  远程App调用入口
 
 *  urlString  scheme://[target]/[action]?[params]
 *  example    lc://targetA/actionB?id=1234
 */
+ (void)openURL:(NSString *)urlString;

/** 远程App调用入口（有回调） */
+ (void)openURL:(NSString *)urlString
     completion:(void(^)(id result, NSError *error))completion;

/** 本地组件调用入口 */
+ (void)openTarget:(NSString *)targetName
            action:(NSString *)actionName
            params:(NSDictionary *)params;

/** 本地组件调用入口（有回调） */
+ (void)openTarget:(NSString *)targetName
            action:(NSString *)actionName
            params:(NSDictionary *)params
        completion:(void(^)(id result, NSError *error))completion;

/** 释放target（参数为模块名,如：user/account等） */
+ (void)releaseCachedTarget:(NSString *)targetName;

@end
