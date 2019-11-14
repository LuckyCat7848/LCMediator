//
//  LCAccountService.m
//  LCMediatorDemo
//
//  Created by LuckyCat on 2019/2/26.
//  Copyright © 2019年 LuckyCat. All rights reserved.
//

#import "LCAccountService.h"
#import "LCNavigator.h"
#import "LCMediator.h"

@implementation LCAccountService

/** 登录 */
- (void)lcMediator_login:(NSDictionary *)params {
    void(^loginCompletion)(BOOL isSuccessed) = ^(BOOL isSuccessed) {
        if (isSuccessed) {
            kLCMediatorFinalCompletion(params, @(isSuccessed), nil);
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{@"errorInfo" : @"登录失败"}];
            kLCMediatorFinalCompletion(params, @(isSuccessed), error);
        }
    };
    [LCNavigator push:@"LCLoginViewController" extraParams:@{@"loginResult" : loginCompletion}];
    NSLog(@"去登录界面");
}

@end
