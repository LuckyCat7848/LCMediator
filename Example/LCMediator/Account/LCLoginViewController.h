//
//  LCLoginViewController.h
//  LCMediatorDemo
//
//  Created by LuckyCat on 2019/2/26.
//  Copyright © 2019年 LuckyCat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCLoginViewController : UIViewController

@property (nonatomic, copy) void (^loginResult)(BOOL isSuccessed);

@end

NS_ASSUME_NONNULL_END
