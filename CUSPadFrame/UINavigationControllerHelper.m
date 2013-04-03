//
//  UINavigationControllerExt.m
//  CUSPadFrameSample
//
//  Created by zhangyu on 13-4-3.
//  Copyright (c) 2013年 zhangyu. All rights reserved.
//

#import "UINavigationControllerHelper.h"

@implementation UINavigationControllerHelper
@synthesize padFrameDelegate;

 
- (void)padNavigationController:(CUSPadNavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(padFrameDelegate == nil){
        return;
    }
    
    if([padFrameDelegate respondsToSelector:@selector(padNavigationController:willShowViewController:animated:)]){
        [padFrameDelegate padNavigationController:navigationController willShowViewController:viewController animated:animated];
    }
}

- (void)padNavigationController:(CUSPadNavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(padFrameDelegate == nil){
        return;
    }
    
    if([padFrameDelegate respondsToSelector:@selector(padNavigationController:didShowViewController:animated:)]){
        [padFrameDelegate padNavigationController:navigationController didShowViewController:viewController animated:animated];
    }
}

-(BOOL)padNavigationController:(CUSPadNavigationController*)navigationController autoDragCloseViewController:(UIViewController*)viewController{
    if(padFrameDelegate == nil){
        return NO;
    }
    
    if([padFrameDelegate respondsToSelector:@selector(padNavigationController:autoDragCloseViewController:)]){
        return [padFrameDelegate padNavigationController:navigationController autoDragCloseViewController:viewController];
    }
    return NO;
}

-(BOOL)padNavigationController:(CUSPadNavigationController*)navigationController willPopViewController:(UIViewController*)viewController animated:(BOOL)animated{
    if(padFrameDelegate == nil){
        return YES;
    }
    
    if([padFrameDelegate respondsToSelector:@selector(padNavigationController:willPopViewController:animated:)]){
        return [padFrameDelegate padNavigationController:navigationController willPopViewController:viewController animated:animated];
    }
    return YES;
}

-(void)padNavigationController:(CUSPadNavigationController*)navigationController didPopViewController:(UIViewController*)viewController animated:(BOOL)animated{
    if(padFrameDelegate == nil){
        return;
    }
    
    if([padFrameDelegate respondsToSelector:@selector(padNavigationController:didPopViewController:animated:)]){
        [padFrameDelegate padNavigationController:navigationController didPopViewController:viewController animated:animated];
    }
}
@end
