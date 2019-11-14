//
//  LCSelfStep1View.m
//  LCMediatorDemo
//
//  Created by LuckyCat on 2019/2/26.
//  Copyright © 2019年 LuckyCat. All rights reserved.
//

#import "LCSelfStep1View.h"

@interface LCSelfStep1View ()

@property (nonatomic, strong) UILabel *cityLabel;

@end

@implementation LCSelfStep1View

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

#pragma mark - Setter

- (void)setCityName:(NSString *)cityName {
    _cityName = cityName;
    
    self.cityLabel.text = [NSString stringWithFormat:@"%@\n\n（点我消失）", cityName];
}

#pragma mark - Action

- (void)hide {
    [self removeFromSuperview];
}

#pragma mark - UI

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.cityLabel sizeToFit];
    self.cityLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
}

#pragma mark - Getter

- (UILabel *)cityLabel {
    if (!_cityLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        
        [self addSubview:label];
        _cityLabel = label;
    }
    return _cityLabel;
}

@end
