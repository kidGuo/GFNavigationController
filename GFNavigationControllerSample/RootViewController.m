//
//  RootViewController.m
//  GFNavigationControllerSample
//
//  Created by MeTao on 15/3/1.
//  Copyright (c) 2015年 kid. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"


@interface RootViewController ()

@end

@implementation RootViewController

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
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.title = @"首页";
    
    
    UIButton *pushBtn = [[UIButton alloc] init];
    pushBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [pushBtn setTitle:@"PushViewController" forState:UIControlStateNormal];
    [pushBtn addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushBtn];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:pushBtn attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:pushBtn attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
 
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"go" style:UIBarButtonItemStylePlain target:self action:@selector(doStart:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    
    //push
    
//    UIViewController *controller = [[UIViewController alloc] init];
//    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action

- (void)pushAction:(id)sender {
    
    DetailViewController *vc = [[DetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)doStart:(id)sender
{
    int r = (int)time(0);
    
    for (NSInteger i = 0; i < 300; ++i) {
        srand(r);
        r = rand();
        int x = r % 10;
        if (x == 3) {
            NSLog(@"popToRoot");
            [self popToRoot];
        }
        else if (x == 4) {
            NSLog(@"popTo");
            [self popTo];
        }
        else
        if (x == 5 || x == 8) {
            NSLog(@"pop");
            [self pop];
        }
        else {
            NSLog(@"push");
            [self push];
        }
    }
    [self performSelector:@selector(doStart:) withObject:nil afterDelay:2];
}

- (void)push
{
    static int i = 0;
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    vc.title = [NSString stringWithFormat:@"Index %i", i++];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popTo
{
    srand((unsigned int)time(0));
    NSUInteger index = abs(rand()) % self.navigationController.viewControllers.count;
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index] animated:YES];
}

- (void)popToRoot
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (UIImage *)imageWithColor:(UIColor *)color {

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1.0, 1.0)];
    view.backgroundColor = color;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1.0, 1.0), YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
