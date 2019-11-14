//
//  LCNavigator.m
//  1haiiPhone
//
//  Created by LuckyCat on 2018/4/19.
//  Copyright © 2018年 LuckyCat. All rights reserved.
//

#import "LCNavigator.h"
#import "NSObject+YYModel.h"

typedef enum : NSUInteger {
    LCNavigatorOpenTypePush,
    LCNavigatorOpenTypePresent,
} LCNavigatorOpenType;

@implementation LCNavigator

#pragma mark - Push/Present

+ (void)push:(id)viewController {
    [self push:viewController animated:YES];
}

+ (void)push:(id)viewController animated:(BOOL)animated {
    [self push:viewController extraParams:nil animated:YES];
}

+ (void)push:(id)viewController extraParams:(NSDictionary *)extraParams {
    [self push:viewController extraParams:extraParams animated:YES];
}

+ (void)push:(id)viewController extraParams:(NSDictionary *)extraParams animated:(BOOL)animated {
    [self open:viewController extraParams:extraParams type:LCNavigatorOpenTypePush animated:animated];
}

+ (void)present:(id)viewController {
    [self present:viewController animated:YES];
}

+ (void)present:(id)viewController animated:(BOOL)animated {
    [self present:viewController extraParams:nil animated:YES];
}

+ (void)present:(id)viewController extraParams:(NSDictionary *)extraParams {
    [self present:viewController extraParams:extraParams animated:YES];
}

+ (void)present:(id)viewController extraParams:(NSDictionary *)extraParams animated:(BOOL)animated {
    [self open:viewController extraParams:extraParams type:LCNavigatorOpenTypePresent animated:animated];
}

+ (void)open:(id)viewController
 extraParams:(NSDictionary *)extraParams
        type:(LCNavigatorOpenType)type
    animated:(BOOL)animated {

    UIViewController *controller = [self controllerWith:viewController extraParams:extraParams];
    if (controller) {
        UINavigationController *nav = [self currentNavigationController];
        switch (type) {
            case LCNavigatorOpenTypePush: {
                controller.hidesBottomBarWhenPushed = YES;
                [nav pushViewController:controller animated:animated];
            }
                break;
            case LCNavigatorOpenTypePresent: {
                if ([controller.class isSubclassOfClass:UINavigationController.class]) {
                    controller.modalPresentationStyle = UIModalPresentationFullScreen;
                    [nav presentViewController:controller
                                      animated:animated
                                    completion:nil];
                } else {
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
                    navigationController.modalPresentationStyle = controller.modalPresentationStyle;
                    navigationController.modalTransitionStyle = controller.modalTransitionStyle;
                    [nav presentViewController:navigationController
                                      animated:animated
                                    completion:nil];
                }
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - Pop

+ (void)pop {
    [self pop:YES];
}

+ (void)pop:(BOOL)animated {
    UINavigationController * nav = [self currentNavigationController];
    if (nav.viewControllers.count == 1 && nav.presentingViewController) {
        [nav dismissViewControllerAnimated:animated completion:nil];
    } else {
        [nav popViewControllerAnimated:animated];
    }
}

+ (void)popToRoot {
    [self popToRootAnimated:YES];
}

+ (void)popToRootAnimated:(BOOL)animated {
    [[self currentNavigationController] popToRootViewControllerAnimated:animated];
}

+ (void)popTo:(id)viewController {
    [self popTo:viewController animated:YES];
}

+ (void)popTo:(id)viewController animated:(BOOL)animated {
    NSString *vcString = nil;
    if ([viewController isKindOfClass:[UIViewController class]]) { // 对象
        vcString = NSStringFromClass([viewController class]);
        
    } else if ([viewController isKindOfClass:[NSString class]]) { // string
        vcString = viewController;
    
    } else if ([viewController isSubclassOfClass:[UIViewController class]]) { // class
        vcString = NSStringFromClass(viewController);
    }
    if (!vcString.length) {
        NSLog(@"%s：viewController nil：%@", __PRETTY_FUNCTION__, viewController);
        return;
    }
    UINavigationController * nav = [self currentNavigationController];
    for (UIViewController *tmp in nav.viewControllers) {
        if ([NSStringFromClass([tmp class]) isEqualToString:vcString]) {
            [nav popToViewController:tmp animated:animated];
        }
    }
}

#pragma mark - 获取当前UINavigationController

+ (UINavigationController *)currentNavigationController {
    id<UIApplicationDelegate>  dele = [UIApplication sharedApplication].delegate;
    UIViewController * vc = findBestNav(dele.window.rootViewController);
    NSAssert(vc && [vc isKindOfClass:[UINavigationController class]], @"未找到Nav: %@", vc);
    return (UINavigationController *)vc;
}

UIViewController * findBestNav(UIViewController * vc) {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        if (vc.presentedViewController && [vc.presentedViewController isKindOfClass:[UINavigationController class]]) {
            return findBestNav(vc.presentedViewController);
        } else {
            return vc;
        }
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *sp = (UISplitViewController *)vc;
        return sp.viewControllers.count > 0 ? findBestNav(sp.viewControllers.lastObject) : nil;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *ta = (UITabBarController *)vc;
        return ta.viewControllers.count > 0 ? findBestNav(ta.selectedViewController) : nil;
    }
    return vc.navigationController;
}

#pragma mark - 获取当前UIViewController

+ (UIViewController *)currentViewController {
    id<UIApplicationDelegate>  dele = [UIApplication sharedApplication].delegate;
    UIViewController * vc = [self findBestVC:dele.window.rootViewController];
    NSAssert(vc && [vc isKindOfClass:[UIViewController class]], @"未找到VC: %@", vc);
    return vc;
}

+ (UIViewController *)findBestVC:(UIViewController *)vc {
    if (vc.presentedViewController) {
        return  [self findBestVC:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *sp = (UISplitViewController *)vc;
        return sp.viewControllers.count > 0 ? [self findBestVC:sp.viewControllers.lastObject] : vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        return nav.viewControllers.count > 0 ? [self findBestVC:nav.topViewController] : vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *ta = (UITabBarController *)vc;
        return ta.viewControllers.count > 0 ? [self findBestVC:ta.selectedViewController] : vc;
    }
    return vc;
}

#pragma mark - 获取

/** 获取某个vc */
+ (UIViewController *)controllerWith:(id)viewController {
    return [self controllerWith:viewController extraParams:nil];
}

+ (UIViewController *)controllerWith:(id)viewController extraParams:(NSDictionary *)extraParams {
    UIViewController *controller = nil;
    if ([viewController isKindOfClass:[UIViewController class]]) { // 对象
        controller = viewController;
    
    } else if ([viewController isKindOfClass:[NSString class]]) { // string
        Class openClass = NSClassFromString(viewController);
        controller = [[openClass alloc] init];
        
    } else if ([viewController isSubclassOfClass:[UIViewController class]]) { // class
        controller = [[viewController alloc] init];
    }
    
    if (controller) {
        if (extraParams) {
            [controller modelSetWithDictionary:extraParams];
        }
    } else {
        NSLog(@"%s：viewController nil：%@", __PRETTY_FUNCTION__, viewController);
    }
    return controller;
}

#pragma mark - Method

/** 判断是否是当前vc(只判断是同一个类,不区分是否是同一个对象) */
+ (BOOL)isMemberOfCurrentVC:(id)viewController {
    NSString *vcString = nil;
    if ([viewController isKindOfClass:[UIViewController class]]) { // 对象
        vcString = NSStringFromClass([viewController class]);
        
    } else if ([viewController isKindOfClass:[NSString class]]) { // string
        vcString = viewController;
        
    } else if ([viewController isSubclassOfClass:[UIViewController class]]) { // class
        vcString = NSStringFromClass(viewController);
    }
    if (!vcString.length) {
        NSLog(@"%s：viewController nil：%@", __PRETTY_FUNCTION__, viewController);
        return NO;
    }
    UIViewController *currentVC = [self currentViewController];
    BOOL isCurrent = [NSStringFromClass([currentVC class]) isEqualToString:vcString];
    return isCurrent;
}

@end
