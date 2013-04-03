//
//  UINavigationControllerExt.h
//  CUSPadFrameSample
//
//  Created by zhangyu on 13-4-3.
//  Copyright (c) 2013年 zhangyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUSPadNavigationController.h"
@interface UINavigationControllerHelper : UINavigationController<CUSPadNavigationControllerDelegate>
@property(nonatomic,assign) id<CUSPadNavigationControllerDelegate> padFrameDelegate;
@end
