#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "LCMediator.h"
#import "LCMediatorService.h"
#import "LCNoServiceViewController.h"

FOUNDATION_EXPORT double LCMediatorVersionNumber;
FOUNDATION_EXPORT const unsigned char LCMediatorVersionString[];

