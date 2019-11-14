//
//  LCSelfStep1ViewController.h
//  LCMediatorDemo
//
//  Created by LuckyCat on 2019/2/26.
//  Copyright © 2019年 LuckyCat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCSelfStep1ViewController : UIViewController

/** 来源 */
@property (nonatomic, assign) NSInteger sourceType;

/** 订单id(修改订单) */
@property (nonatomic, copy) NSString *orderId;

/** 图片 */
@property (nonatomic, strong) UIImage *image;

@end

NS_ASSUME_NONNULL_END
