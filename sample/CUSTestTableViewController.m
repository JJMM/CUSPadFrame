//
//  CUSTestTableViewController.m
//  CUSPadFrameSample
//
//  Created by zhangyu on 13-4-3.
//  Copyright (c) 2013年 zhangyu. All rights reserved.
//

#import "CUSTestTableViewController.h"

@interface CUSTestTableViewController ()

@end

@implementation CUSTestTableViewController

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.view viewWithTag:1].frame = self.view.bounds;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.tag = 1;
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [self.view addSubview:tableView];
    [tableView release];
    CUSPadNavigationController *padNavigationController = [CUSPadNavigationController sharedtInstance];
    self.title = [NSString stringWithFormat:@"title%i",[padNavigationController.array count]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text=[NSString stringWithFormat:@"row%i",indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CUSTestTableViewController *testController = [[CUSTestTableViewController alloc]init];
    UINavigationControllerHelper *navController = [[UINavigationControllerHelper alloc]initWithRootViewController:testController];
    navController.padFrameDelegate = self;
    [testController release];
    
    CUSPadNavigationController *padNavigationController = [CUSPadNavigationController sharedtInstance];
    [padNavigationController popToViewController:self.navigationController animated:YES];
    
    [padNavigationController pushViewController:navController animated:YES];
}

#pragma mark - PadFrame
-(void)padNavigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSLog(@"PadFrame:willShowViewController");
}
-(void)padNavigationController:(CUSPadNavigationController *)navigationController didPopViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSLog(@"PadFrame:didPopViewController");
}

//-(BOOL)padNavigationController:(CUSPadNavigationController *)navigationController autoDragCloseViewController:(UIViewController *)viewController{
//    return YES;
//}
@end


