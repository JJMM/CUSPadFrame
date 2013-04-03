//
//  CUSMainViewController.m
//  CUSPadFrameSample
//
//  Created by zhangyu on 13-4-3.
//  Copyright (c) 2013年 zhangyu. All rights reserved.
//

#import "CUSMainViewController.h"

@interface CUSMainViewController ()

@end

@implementation CUSMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    CUSPadNavigationController *padNavigationController = [CUSPadNavigationController sharedtInstance];
    CGRect frame = self.view.bounds;
    padNavigationController.view.frame = frame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	CUSPadNavigationController *padNavigationController = [CUSPadNavigationController sharedtInstance];
    [self.view addSubview:padNavigationController.view];
    
    
    CUSTestTableViewController *testController = [[CUSTestTableViewController alloc]init];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:testController];
    [testController release];
    [padNavigationController pushViewController:navController animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
