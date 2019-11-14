//
//  LCMemberViewController.m
//  LCMediatorDemo
//
//  Created by LuckyCat on 2019/2/26.
//  Copyright © 2019年 LuckyCat. All rights reserved.
//

#import "LCMemberViewController.h"

@interface LCMemberViewController ()

@end

@implementation LCMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"会员中心";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    label.numberOfLines = 0;
    label.text = @"这里是会员中心";
    [label sizeToFit];
    label.center = self.view.center;
    [self.view addSubview:label];
}

@end
