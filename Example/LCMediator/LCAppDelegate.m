//
//  LCAppDelegate.m
//  LCMediator
//
//  Created by LuckyCat7848 on 11/14/2019.
//  Copyright (c) 2019 LuckyCat7848. All rights reserved.
//

#import "LCAppDelegate.h"
#import "LCViewController.h"
#import "LCMediator.h"

@implementation LCAppDelegate
    
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    LCViewController *vc = [[LCViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    
    return YES;
}
    
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // 其他APP使用url
    if ([url.scheme.lowercaseString isEqualToString:@"lc"]) {
        [LCMediator openURL:url.absoluteString completion:nil];
        return YES;
    }
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
    
@end
