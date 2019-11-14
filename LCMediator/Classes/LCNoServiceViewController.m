//
//  LCNoServiceViewController.m
//  LCMediatorDemo
//
//  Created by 张猫猫 on 2019/8/24.
//  Copyright © 2019 LuckyCat. All rights reserved.
//

#import "LCNoServiceViewController.h"
#import "YYKit.h"
#import "LCNavigator.h"

@interface LCNoServiceViewController ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *noServiceImageView;
@property (nonatomic, strong) YYLabel *tipLabel;

@end

@implementation LCNoServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"无服务";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
    
    [attrStr appendAttributedString:
     [[NSAttributedString alloc] initWithString:@"抱歉，您访问的服务无法找到\n"
                                     attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                                  NSForegroundColorAttributeName : [UIColor blackColor]}]];
    
    [attrStr appendAttributedString:
     [[NSAttributedString alloc] initWithString:@"请尝试："
                                     attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],
                                                  NSForegroundColorAttributeName : [UIColor grayColor]}]];
    
    NSMutableAttributedString *tapAttr = [[NSMutableAttributedString alloc] initWithString:@"回到首页"
                                                                                attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],
                                                                                             NSForegroundColorAttributeName : [UIColor orangeColor]}];

    [tapAttr setTextHighlightRange:tapAttr.rangeOfAll
                             color:[UIColor orangeColor]
                   backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                       [LCNavigator popToRoot];
                   }];
    [attrStr appendAttributedString:tapAttr];

    attrStr.lineSpacing = 15;

    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(self.view.width - 30, MAXFLOAT) text:attrStr];
    self.tipLabel.attributedText = attrStr;
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.frame = CGRectMake((self.view.width - layout.textBoundingSize.width) / 2, self.noServiceImageView.bottom + 24, layout.textBoundingSize.width, layout.textBoundingSize.height);
    
    NSLog(@"%@", self.logoImageView);
}

#pragma mark - Getter

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 121, 32)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"mediator_logo"];
        imageView.bottom = self.noServiceImageView.top - 72;
        imageView.centerX = self.view.centerX;
        
        [self.view addSubview:imageView];
        _logoImageView = imageView;
    }
    return _logoImageView;
}

- (UIImageView *)noServiceImageView {
    if (!_noServiceImageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 139)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"mediator_noService"];
        imageView.center = CGPointMake(self.view.width / 2, self.view.height / 2 - 100);
        
        [self.view addSubview:imageView];
        _noServiceImageView = imageView;
    }
    return _noServiceImageView;
}

- (YYLabel *)tipLabel {
    if (!_tipLabel) {
        YYLabel *label = [[YYLabel alloc] init];
        label.numberOfLines = 0;
        label.userInteractionEnabled = YES;
        
        [self.view addSubview:label];
        _tipLabel = label;
    }
    return _tipLabel;
}

@end
