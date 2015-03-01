//
//  GFNavigationController.m
//  GFNavigationControllerSample
//
//  Created by MeTao on 15/3/1.
//  Copyright (c) 2015年 kid. All rights reserved.
//

#import "GFNavigationController.h"
#import "NSMutableArray+GFNavigationControlller.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>


#define KEY_WINDOW   [[[UIApplication sharedApplication] delegate] window]
#define SCREEN_SIZE  [[UIScreen mainScreen] bounds].size


typedef void(^PendingBlock)(void);

@interface GFNavigationController ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *lastScreenImageView;


@property (nonatomic, strong) NSMutableArray *screenShots;
@property (nonatomic, assign) CGPoint startTouchPoint;
@property (nonatomic, copy) NSMutableArray *pendingBlocks;

@end

@implementation GFNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    [self __commonInitialization];
    
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Property

- (UIView *)containerView {
    if (nil == _containerView) {
        _containerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    
    return _containerView;
}

- (UIImageView *)lastScreenImageView {
    if (nil == _lastScreenImageView) {
        _lastScreenImageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    
    return _lastScreenImageView;
}

- (NSMutableArray *)screenShots {
    if (nil == _screenShots) {
        _screenShots = [@[] mutableCopy];
    }
    
    return _screenShots;
}

- (NSMutableArray *)pendingBlocks {
    if (nil == _pendingBlocks) {
        _pendingBlocks = [@[] mutableCopy];
    }
    
    return _pendingBlocks;
}

- (void)setTransitionInProcess:(BOOL)transitionInProcess {
    _transitionInProcess = transitionInProcess;
    
    if (!_transitionInProcess && self.pendingBlocks.count) {
        _transitionInProcess = YES;
        [self __runNextTransition];
    }
}


#pragma mark - Private Methods

- (void)__commonInitialization {
    
    self.transitionInProcess = NO;
    
    self.dragEnable = YES;
    
    self.animationDuration = 0.3;
    
    self.startX = -200;
    
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (UIImage *)__captureScreen {

    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)__moveViewWithOffsetX:(CGFloat)x {
    
    x = MAX(MIN(CGRectGetWidth(self.view.frame), x), 0);
 
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    
    CGFloat rate = fabsf(self.startX) / CGRectGetWidth(self.view.frame);
    CGFloat distance = rate * x;
    self.lastScreenImageView.frame = CGRectMake(self.startX + distance, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
}

- (void)__resetOriginalState {
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        
        [self __moveViewWithOffsetX:0];
        
    }completion:^(BOOL finished) {
        
        self.containerView.hidden = YES;
    }];
}

- (void)__addTransitionBlock:(PendingBlock)block {

    if (self.transitionInProcess) {
        [self.pendingBlocks addObject:[block copy]];
    }
    else {
        _transitionInProcess = YES;
        block();
    }
}

- (void)__runNextTransition {
    
    if (self.pendingBlocks.count) {
        PendingBlock block = [self.pendingBlocks lastObject];
        [self.pendingBlocks removeLastObject];
        block();
    }
}


#pragma mark - Action

- (void)handlePanGesture:(UIPanGestureRecognizer *)pan {
    
    if (!self.dragEnable || self.viewControllers.count < 2) {
        return;
    }
    
    
    CGPoint touchPoint = [pan locationInView:KEY_WINDOW];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        self.startTouchPoint = touchPoint;
        
        if (![self.view.superview.subviews containsObject:self.containerView]) {
            [self.view.superview insertSubview:self.containerView belowSubview:self.view];
        }
        
        
        if (![self.containerView.subviews containsObject:self.lastScreenImageView]) {
            [self.containerView addSubview:self.lastScreenImageView];
        }
    
        
        self.lastScreenImageView.image = [self.screenShots lastObject];
        CGRect frame = self.lastScreenImageView.frame;
        frame.origin.x = self.startX;
        frame.size = [[UIScreen mainScreen] bounds].size;
        self.lastScreenImageView.frame = frame;
        
        
        self.containerView.hidden = NO;
    }
    else if (pan.state == UIGestureRecognizerStateEnded) {
     
        if (touchPoint.x - self.startTouchPoint.x > CGRectGetWidth(self.view.frame) / 3.0) {
            
            [UIView animateWithDuration:self.animationDuration animations:^{
                
                [self __moveViewWithOffsetX:CGRectGetWidth(self.view.frame)];
                
            }completion:^(BOOL finished) {
                
                [self popViewControllerAnimated:NO];
                
                CGRect frame = self.view.frame;
                frame.origin = CGPointZero;
                self.view.frame = frame;
                
                self.containerView.hidden = YES;
            }];
        }
        else {
            
            [UIView animateWithDuration:self.animationDuration animations:^{
               
                [self __moveViewWithOffsetX:0];
                
            }completion:^(BOOL finished) {
                
                self.containerView.hidden = YES;
            }];
        }
        
        return;
    }
    else if (pan.state == UIGestureRecognizerStateCancelled) {
        
        [self __resetOriginalState];
        
        return;
    }
    
 
    [self __moveViewWithOffsetX:touchPoint.x - self.startTouchPoint.x];
}


#pragma makr - Public Methods

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    __weak typeof(self) weakSelf = self;
    
    [self __addTransitionBlock:^{
        
        [weakSelf.screenShots addObject:[weakSelf __captureScreen]];
        
        [super pushViewController:viewController animated:animated];
    }];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    __weak typeof(self)weakSelf = self;
    
    [self __addTransitionBlock:^{
        
        [weakSelf.screenShots removeLastObject];
        
        UIViewController *viewController = [super popViewControllerAnimated:animated];
        if (viewController == nil) {
            weakSelf.transitionInProcess = NO;
        }
    }];
    
    return nil;
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    __weak typeof(self)weakSelf = self;
    
    [self __addTransitionBlock:^{
        
        if ([weakSelf.viewControllers containsObject:viewController]) {
            
            NSInteger index = [weakSelf.viewControllers indexOfObject:viewController];
            if (weakSelf.viewControllers.count > index) {
                [weakSelf.screenShots gf_removeObjectsFromIndex:index];
            }
            
            
            NSArray *viewControllers = [super popToViewController:viewController animated:animated];
            
            if (viewControllers.count == 0) {
                weakSelf.transitionInProcess = NO;
            }
        }
        else {
            weakSelf.transitionInProcess = NO;
        }
    }];
    
    return nil;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
 
    __weak typeof(self) weakSelf = self;
    
    [self __addTransitionBlock:^{
        
        if (weakSelf.screenShots.count) {
            [weakSelf.screenShots gf_removeObjectsFromIndex:0];
        }
        
        NSArray *viewControllers = [super popToRootViewControllerAnimated:animated];
        
        if (viewControllers.count == 0) {
            weakSelf.transitionInProcess = NO;
        }
    }];
    
    return nil;
}

@end
