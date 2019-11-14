//
//  LCClientDelegate.m
//  LCMediatorDemo
//
//  Created by LuckyCat on 2019/3/26.
//  Copyright © 2019年 LuckyCat. All rights reserved.
//

#import "LCClientDelegate.h"

@interface LCClientDelegate ()

@property (nonatomic, copy) NSArray<id<UIApplicationDelegate>> *modules;

@end

@implementation LCClientDelegate

#pragma mark - 必须实现的方法(不确定是否包含全部,已实现的无法转发，只能这样操作)

/** 9.0以上 */
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    for (id<UIApplicationDelegate> module in self.modules) {
        if ([module respondsToSelector:@selector(application:openURL:options:)]) {
            [module application:app openURL:url options:options];
        }
    }
    return NO;
}

/** 2_0, 9_0 */
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    for (id<UIApplicationDelegate> module in self.modules) {
        if ([module respondsToSelector:@selector(application:handleOpenURL:)]) {
            [module application:application handleOpenURL:url];
        }
    }
    return NO;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    for (id<UIApplicationDelegate> module in self.modules) {
        if ([module respondsToSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)]) {
            [module application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
        }
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    for (id<UIApplicationDelegate> module in self.modules) {
        if ([module respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)]) {
            [module application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
        }
    }
}

#pragma mark - forwarding methods

- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL superResponds = [super respondsToSelector:aSelector];
    for (id<UIApplicationDelegate> module in self.modules) {
        if ([module respondsToSelector:aSelector]) {
            if (superResponds) {
                NSLog(@"%s 需要默认实现的方法:%@", __PRETTY_FUNCTION__, NSStringFromSelector(aSelector));
            }
            return YES;
        }
    }
    return superResponds;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature;
    for (id<UIApplicationDelegate> module in self.modules) {
        if ([module respondsToSelector:aSelector]) {
            signature = [(NSObject *)module methodSignatureForSelector:aSelector];
            break;
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    for (id<UIApplicationDelegate> module in self.modules) {
        if ([module respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:module];
        }
    }
}

#pragma mark - Getter

- (NSArray<id<UIApplicationDelegate>> *)modules {
    if (!_modules) {
        NSMutableArray *tmp = [@[] mutableCopy];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"LCClientConfig" ofType:@"plist"];
        NSArray<NSString *> *moduleNames = [NSArray arrayWithContentsOfFile:plistPath];
        for (NSString *moduleName in moduleNames) {
            id<UIApplicationDelegate> module = [[NSClassFromString(moduleName) alloc] init];
            [tmp addObject:module];
        }
        _modules = tmp;
    }
    return _modules;
}

@end
