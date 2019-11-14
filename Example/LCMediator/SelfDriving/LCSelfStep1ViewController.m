//
//  LCSelfStep1ViewController.m
//  LCMediatorDemo
//
//  Created by LuckyCat on 2019/2/26.
//  Copyright © 2019年 LuckyCat. All rights reserved.
//

#import "LCSelfStep1ViewController.h"

@interface LCSelfStep1ViewController ()

@end

@implementation LCSelfStep1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"自驾-step1";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    label.numberOfLines = 0;
    label.text = [NSString stringWithFormat:@"%@：\n\n\n\tsourceType = %@\n\n\torderId = %@\n\n\timage = %@\n\n\n\n\n\n\n", self.class, @(self.sourceType), self.orderId, self.image];
    [label sizeToFit];
    label.center = self.view.center;
    [self.view addSubview:label];
}

@end
