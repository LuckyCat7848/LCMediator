//
//  LCMediatorService.h
//  LCMediatorDemo
//
//  Created by LuckyCat on 2019/3/14.
//  Copyright © 2019年 LuckyCat. All rights reserved.
//
//  中间件拦截器，对一些情况的统一处理
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCMediatorService : NSObject

/** 拦截url处理：返回是否继续处理 */
- (BOOL)lcMediator_checkURL:(NSDictionary *)params;

/** 没有找到处理目标 */
- (void)lcMediator_noResponse:(NSDictionary *)params;

/** 没有找到处理目标上报bugly或其他,统一处理 */
- (void)lcMediator_failedReport:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
