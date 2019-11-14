//
//  LCChauffeurAppDelegate.m
//  LCMediatorDemo
//
//  Created by 张猫猫 on 2019/8/28.
//  Copyright © 2019 LuckyCat. All rights reserved.
//

#import "LCChauffeurAppDelegate.h"

@implementation LCChauffeurAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - 3DTouch

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
