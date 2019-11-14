//
//  LCSelfDrivingService.h
//  LCMediatorDemo
//
//  Created by LuckyCat on 2019/2/26.
//  Copyright © 2019年 LuckyCat. All rights reserved.
//
//  自驾服务——通过中间件
//

#import <Foundation/Foundation.h>
#import "LCSelfStep1View.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCSelfDrivingService : NSObject

- (void)lcMediator_step1:(NSDictionary *)params;

- (LCSelfStep1View *)lcMediator_step1View:(NSDictionary *)params;

/** 没有找到处理目标 */
- (void)lcMediator_noResponse:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
