//
//  LCUserService.h
//  LCMediatorDemo
//
//  Created by LuckyCat on 2019/2/26.
//  Copyright © 2019年 LuckyCat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCUserService : NSObject

/** 会员中心 */
- (void)lcMediator_memberCenter:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
