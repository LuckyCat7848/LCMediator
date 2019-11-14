//
//  LCMediator+SelfDriving.h
//  LCMediatorDemo
//
//  Created by LuckyCat on 2019/2/27.
//  Copyright © 2019年 LuckyCat. All rights reserved.
//
//  自驾——中间件——协议
//

#import "LCMediator.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCMediator (SelfDriving)

+ (void)selfDriving_step1:(NSInteger)sourceType orderId:(NSString *)orderId image:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
