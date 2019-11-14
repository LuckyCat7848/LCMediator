//
//  LCAccountService.h
//  LCMediatorDemo
//
//  Created by LuckyCat on 2019/2/26.
//  Copyright © 2019年 LuckyCat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCAccountService : NSObject

/** 登录 */
- (void)lcMediator_login:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
