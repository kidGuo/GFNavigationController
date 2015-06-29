//
//  UIViewController+GFNavigationController.m
//  GFNavigationControllerSample
//
//  Created by MeTao on 15/6/24.
//  Copyright (c) 2015年 kid. All rights reserved.
//

#import "UIViewController+GFNavigationController.h"
#import "GFNavigationController.h"
#import <objc/runtime.h>

@implementation UIViewController (GFNavigationController)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method method1;
        Method method2;
        
        method1 = class_getInstanceMethod([self class], @selector(gf_viewDidAppear:));
        method2 = class_getInstanceMethod([self class], @selector(viewDidAppear:));
        method_exchangeImplementations(method1, method2);
    });
}

- (void)gf_viewDidAppear:(BOOL)animated {
    ((GFNavigationController *)self.navigationController).transitionInProcess = NO;
    [self gf_viewDidAppear:animated];
}

@end
