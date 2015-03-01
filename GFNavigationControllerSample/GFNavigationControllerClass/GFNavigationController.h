//
//  GFNavigationController.h
//  GFNavigationControllerSample
//
//  Created by MeTao on 15/3/1.
//  Copyright (c) 2015年 kid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFNavigationController : UINavigationController

@property (nonatomic, assign) BOOL dragEnable;

@property (nonatomic, assign) NSTimeInterval animationDuration;

@property (nonatomic, assign) CGFloat startX;

@property (nonatomic, assign, getter = isTransitionInProcess) BOOL transitionInProcess;

@end
