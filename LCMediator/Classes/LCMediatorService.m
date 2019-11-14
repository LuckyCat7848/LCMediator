//
//  LCMediatorService.m
//  LCMediatorDemo
//
//  Created by LuckyCat on 2019/3/14.
//  Copyright © 2019年 LuckyCat. All rights reserved.
//

#import "LCMediatorService.h"
#import "LCNavigator.h"
#import <WebKit/WebKit.h>
#import "LCMediator.h"

@implementation LCMediatorService

/** 拦截url处理：返回是否继续处理 */
- (BOOL)lcMediator_checkURL:(NSDictionary *)params {
    NSURL *url = params[@"URL"];
    NSString *urlString = [[url.absoluteString stringByRemovingPercentEncoding] lowercaseString];
    
    NSError *error;
    BOOL isContinue = NO;
    if ([urlString hasPrefix:@"lc://"]) {
        isContinue = YES;
        
    } else if ([urlString hasPrefix:@"tel://"]) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10){
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                NSLog(@"phone success");
            }];
        } else {
            WKWebView *phoneCallWebView = [[WKWebView alloc] initWithFrame:CGRectZero];
            [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:url]];
            [[UIApplication sharedApplication].delegate.window addSubview:phoneCallWebView];
        }
    } else if ([urlString hasPrefix:@"http://"] || [urlString hasPrefix:@"https://"]) {
        UIViewController *viewController = [[UIViewController alloc] init];
        viewController.title = @"H5";
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        [viewController.view addSubview:webView];
        [LCNavigator push:viewController];
        
    } else {
        error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCannotFindHost userInfo:@{@"errorInfo" : @"全局——检查未通过：不是本APP提供的服务"}];
        [LCNavigator push:@"LCNoServiceViewController"];
    }
    BOOL result = (error == nil);
    kLCMediatorFinalCompletion(params, @(result), error);
    
    return isContinue;
}

/** 没有找到处理目标 */
- (void)lcMediator_noResponse:(NSDictionary *)params {
    [LCNavigator push:@"LCNoServiceViewController"];
    
    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:@{@"errorInfo" : @"全局——没有找到指定的服务"}];
    kLCMediatorNoResponseCompletion(params, nil, error);
}

/** 没有找到处理目标上报bugly或其他,统一处理 */
- (void)lcMediator_failedReport:(NSDictionary *)params {
    NSLog(@"统一处理所有失败情况：%@", params);
}

@end
