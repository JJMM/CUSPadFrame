//
//  UIPadNavigationController.h
//  GMC_iPad
//
//  Created by zhangyu on 13-1-14.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CUSPadNavigationController : UIViewController{

}
@property(nonatomic,retain) NSMutableArray *array;
//第一个View宽度
@property(nonatomic,assign) CGFloat padLetWidth0;
//第一个View折叠后的宽度
@property(nonatomic,assign) CGFloat padLetWidth1;
//其他View宽度
@property(nonatomic,assign) CGFloat padMiddelWidth;
+(id)sharedtInstance;

//simple UINavigationController API
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (UIViewController *)popViewControllerAnimated:(BOOL)animated;
- (UIViewController *)popViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated; 
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated;


-(void)clearAll;
@end

@protocol CUSPadNavigationControllerDelegate <NSObject>
@optional
-(BOOL)CUSPadNavigationAutoDragClose;

//Invoke before show 
- (void)padNavigationController:(CUSPadNavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
//Invoke after show 
- (void)padNavigationController:(CUSPadNavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
//Auto drag close view. Drag view out of screen will auto close by PadFrame
-(BOOL)padNavigationController:(CUSPadNavigationController*)navigationController autoDragCloseViewController:(UIViewController*)viewController;
//Invoke before close,The return value control This view and after Views.When value is "NO",stop close action.Default value:NO
-(BOOL)padNavigationController:(CUSPadNavigationController*)navigationController willPopViewController:(UIViewController*)viewController animated:(BOOL)animated;
//Invoke after close
-(void)padNavigationController:(CUSPadNavigationController*)navigationController didPopViewController:(UIViewController*)viewController animated:(BOOL)animated;
@end