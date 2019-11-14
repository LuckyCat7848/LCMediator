//
//  LCViewController.m
//  LCMediator
//
//  Created by LuckyCat7848 on 11/14/2019.
//  Copyright (c) 2019 LuckyCat7848. All rights reserved.
//

#import "LCViewController.h"
#import "LCMediator.h"
#import "LCMediator+SelfDriving.h"

@interface LCViewController ()<UITableViewDataSource, UITableViewDelegate>
    
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray<NSArray *> *dataArray;

@end

@implementation LCViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"LCMediator";
    
    [self.tableView reloadData];
}
    
#pragma mark - UITableViewDataSource & UITableViewDelegate
    
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray[section].count;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary *dic = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.text = dic[@"title"];
    return cell;
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = self.dataArray[indexPath.section][indexPath.row];
    SEL selector = NSSelectorFromString(dic[@"action"]);
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:selector];
#pragma clang diagnostic pop
}
    
#pragma mark - Actions
    
#pragma mark - 正常使用 无返回
    
- (void)step1URL {
    NSString *string = @"lc://selfDriving/step1?sourceType=0&orderId=1000";
    [LCMediator openURL:string completion:^(id result, NSError *error) {
        NSLog(@"");
    }];
}
    
- (void)step1Dictionary {
    [LCMediator openTarget:@"SelfDriving" action:@"step1"
                     params:@{@"sourceType" : @1,
                              @"orderId" : @1001,
                              @"image" : [UIImage imageNamed:@"iconImage"]}
                 completion:^(id result, NSError *error) {
                     NSLog(@"");
                 }];
}
    
- (void)step1URLCategory {
    [LCMediator selfDriving_step1:2
                           orderId:@"1002"
                             image:[UIImage imageNamed:@"iconImage"]];
}
    
#pragma mark - 正常使用 有返回
    
- (void)step1ViewURL {
    NSString *string = @"lc://selfDriving/step1View?cityName=上海";
    [LCMediator openURL:string completion:^(id result, NSError *error) {
        UIView *view = result;
        view.frame = CGRectMake(100, 100, 200, 200);
        [self.view addSubview:view];
    }];
}
    
- (void)step1ViewDictionary {
    [LCMediator openTarget:@"selfDriving" action:@"step1View" params:@{@"cityName" : @"上海"} completion:^(id result, NSError *error) {
        UIView *view = result;
        view.frame = CGRectMake(100, 320, 100, 100);
        view.backgroundColor = [UIColor cyanColor];
        [self.view addSubview:view];
    }];
}
    
#pragma mark - 需要先做其他操作
    
- (void)memberCenterNeedLogin {
    [LCMediator openTarget:@"user" action:@"memberCenter" params:nil completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"viewController 去会员中心失败error🌹:%@", error);
        } else {
            NSLog(@"viewController 去会员中心成功");
        }
    }];
    //    [LCMediator openTarget:@"account" action:@"login" params:nil completion:^(id result, NSError *error) {
    //        if ([result boolValue]) {
    //            NSLog(@"登录成功,vc");
    //        } else {
    //            NSLog(@"登录失败,vc");
    //        }
    //    }];
}
    
#pragma mark - 正常使用 异常处理
    
- (void)noTargetService {
    [LCMediator openTarget:@"selfDriving" action:@"step1Vie" params:@{@"cityName" : @"上海"} completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"%s error🌹:%@", __PRETTY_FUNCTION__, error);
        } else {
            UIView *view = result;
            view.frame = CGRectMake(100, 320, 100, 100);
            view.backgroundColor = [UIColor cyanColor];
            [self.view addSubview:view];
        }
    }];
}
    
- (void)noServiceGlobal {
    [LCMediator openTarget:@"user" action:@"step1View" params:@{@"cityName" : @"上海"} completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"%s error🌹:%@", __PRETTY_FUNCTION__, error);
        } else {
            UIView *view = result;
            view.frame = CGRectMake(100, 320, 100, 100);
            view.backgroundColor = [UIColor cyanColor];
            [self.view addSubview:view];
        }
    }];
}
    
#pragma mark - 无参数
    
- (void)chauffeurStep1URL {
    NSString *string = @"lc://chauffeur/step1";
    [LCMediator openURL:string completion:^(id result, NSError *error) {
        NSLog(@"");
    }];
}
    
#pragma mark - 额外功能
    
- (void)callPhone {
    NSString *string = @"tel://17710167359";
    [LCMediator openURL:string completion:^(id result, NSError *error) {
        NSLog(@"");
    }];
}
    
- (void)html5 {
    NSString *string = @"https://www.baidu.com/";
    [LCMediator openURL:string completion:^(id result, NSError *error) {
        NSLog(@"");
    }];
}
    
- (void)noService {
    NSString *string =  @"abc://selfDriving/step1View";
    [LCMediator openURL:string completion:^(id result, NSError *error) {
        NSLog(@"");
    }];
}
    
#pragma mark - Getter
    
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}
    
- (NSArray<NSArray *> *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@[
                           @{@"title" : @"自驾-step1（URL）", @"action" : @"step1URL"},
                           @{@"title" : @"自驾-step1（字典）", @"action" : @"step1Dictionary"},
                           @{@"title" : @"自驾-step1（Category）", @"action" : @"step1URLCategory"},
                           ],
                       
                       @[
                           @{@"title" : @"自驾-step1View（获取对象：URL）", @"action" : @"step1ViewURL"},
                           @{@"title" : @"自驾-step1View（获取对象：字典）", @"action" : @"step1ViewDictionary"},
                           ],
                       
                       @[
                           @{@"title" : @"用户-会员中心（需要先登录，异步回调）", @"action" : @"memberCenterNeedLogin"}
                           ],
                       
                       @[
                           @{@"title" : @"无目标或Action（Service处理）", @"action" : @"noTargetService"},
                           @{@"title" : @"无目标或Action（全局统一处理）", @"action" : @"noServiceGlobal"},
                           ],
                       
                       @[
                           @{@"title" : @"专车-step1（无参数回调!!!常用的🔥）", @"action" : @"chauffeurStep1URL"},
                           ],
                       
                       @[
                           @{@"title" : @"打电话", @"action" : @"callPhone"},
                           @{@"title" : @"H5", @"action" : @"html5"},
                           @{@"title" : @"无服务", @"action" : @"noService"},
                           ],
                       ];
    }
    return _dataArray;
}
    
@end
