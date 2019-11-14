//
//  LCUserService.m
//  LCMediatorDemo
//
//  Created by LuckyCat on 2019/2/26.
//  Copyright © 2019年 LuckyCat. All rights reserved.
//

#import "LCUserService.h"
#import "LCNavigator.h"
#import "LCAccountService.h"
#import "LCMediator.h"

@implementation LCUserService

/** 会员中心 */
- (void)lcMediator_memberCenter:(NSDictionary *)params {
    [LCMediator openTarget:@"account" action:@"login" params:params completion:^(id result, NSError *error) {
        if ([result boolValue]) {
            NSLog(@"登录成功,去会员中心");
            [LCNavigator push:@"LCMemberViewController"];
        } else {
            NSLog(@"登录失败,进入”会员中心服务“失败");
        }
        kLCMediatorFinalCompletion(params, result, error);
    }];
}

@end
