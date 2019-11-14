//
//  LCLoginViewController.m
//  LCMediatorDemo
//
//  Created by LuckyCat on 2019/2/26.
//  Copyright © 2019年 LuckyCat. All rights reserved.
//

#import "LCLoginViewController.h"

@interface LCLoginViewController ()

@end

@implementation LCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"登录";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 150, 100);
    button.center = self.view.center;
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)dealloc {
    if (self.loginResult) {
        self.loginResult(YES);
    }
}

- (void)loginAction {
    NSLog(@"登录成功,pop,回调");

    [self.navigationController popViewControllerAnimated:NO];
}

@end
