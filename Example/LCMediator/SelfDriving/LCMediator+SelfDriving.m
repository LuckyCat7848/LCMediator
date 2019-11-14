//
//  LCMediator+SelfDriving.m
//  LCMediatorDemo
//
//  Created by LuckyCat on 2019/2/27.
//  Copyright © 2019年 LuckyCat. All rights reserved.
//

#import "LCMediator+SelfDriving.h"

NSString * const kLCMediatorSelfDriving = @"selfDriving";

NSString * const kLCMediatorSelfDrivingStep1 = @"step1";

@implementation LCMediator (SelfDriving)

+ (void)selfDriving_step1:(NSInteger)sourceType orderId:(NSString *)orderId image:(UIImage *)image {
    [LCMediator openTarget:kLCMediatorSelfDriving action:kLCMediatorSelfDrivingStep1
                     params:@{@"sourceType" : @(sourceType),
                              @"orderId" : orderId,
                              @"image" : image}
                 completion:nil];
}

@end
