//
//  LCClientDelegate.h
//  LCMediatorDemo
//
//  Created by LuckyCat on 2019/3/26.
//  Copyright © 2019年 LuckyCat. All rights reserved.
//
//  转发各个模块的AppDelegate生命周期方法
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCClientDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@end

NS_ASSUME_NONNULL_END
