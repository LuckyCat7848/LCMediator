//
//  LCSelfDrivingService.m
//  LCMediatorDemo
//
//  Created by LuckyCat on 2019/2/26.
//  Copyright © 2019年 LuckyCat. All rights reserved.
//

#import "LCSelfDrivingService.h"
#import "LCNavigator.h"
#import "LCMediator.h"

@implementation LCSelfDrivingService

- (void)lcMediator_step1:(NSDictionary *)params {
    [LCNavigator push:@"LCSelfStep1ViewController" extraParams:params];
    
    kLCMediatorFinalCompletion(params, @(YES), nil);
}

- (LCSelfStep1View *)lcMediator_step1View:(NSDictionary *)params {
    LCSelfStep1View *view = [[LCSelfStep1View alloc] init];
    view.cityName = params[@"cityName"];

    kLCMediatorFinalCompletion(params, view, nil);

    return view;
}

/** 没有找到处理目标 */
- (void)lcMediator_noResponse:(NSDictionary *)params {
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.title = @"异常处理";
    viewController.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    label.numberOfLines = 0;
    [viewController.view addSubview:label];
    
    NSMutableString *string = [@"   自驾——没有找到指定的服务\n\n" mutableCopy];
    for (NSString *key in params.allKeys) {
        [string appendFormat:@"\n      %@：%@\n", key, params[key]];
    }
    label.text = string;
    
    [LCNavigator push:viewController];
    
    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:@{@"errorInfo" : @"自驾——没有找到指定的服务"}];
    kLCMediatorNoResponseCompletion(params, nil, error);
}

@end
