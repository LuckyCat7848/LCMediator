//
//  LCChauffeurService.m
//  LCMediatorDemo
//
//  Created by 张猫猫 on 2019/8/28.
//  Copyright © 2019 LuckyCat. All rights reserved.
//

#import "LCChauffeurService.h"
#import "LCNavigator.h"

@implementation LCChauffeurService

/** step1 */
- (void)lcMediator_step1 {
    [LCNavigator push:@"LCChauffeurStep1ViewController"];
}

@end
