//
//  GFNavigationController.h
//  GFNavigationControllerSample
//
//  Created by MeTao on 15/3/1.
//  Copyright (c) 2015年 kid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFNavigationController : UINavigationController

//defaul YES
@property (nonatomic, assign) BOOL dragEnable;

//default is 0.3
@property (nonatomic, assign) NSTimeInterval animationDuration;

@property (nonatomic, assign) CGFloat startX;

@property (nonatomic, assign, getter = isTransitionInProcess) BOOL transitionInProcess;

//default NO (>= iOS7)
@property (nonatomic, assign) BOOL interactivePopGestureRecognizerEnabled;

@end
