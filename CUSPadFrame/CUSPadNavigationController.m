//
//  UIPadNavigationController.m
//  GMC_iPad
//
//  Created by zhangyu on 13-1-14.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CUSPadNavigationController.h"
#import <QuartzCore/CALayer.h>


static CUSPadNavigationController *CUSPadNavigationControllerInstance = nil;

@interface FrameObject : NSObject
@property(nonatomic,assign) CGRect rect;
- (id)initWithRect:(CGRect)_rect;
- (CGRect)createCopyRect;
+ (id)createFrame:(CGRect)_rect;
@end
@implementation FrameObject
@synthesize rect;
- (id)initWithRect:(CGRect)_rect
{
    self = [super init];
    if (self) {
        self.rect = _rect;
    }
    return self;
}

- (CGRect)createCopyRect{
    CGRect frame = CGRectMake(self.rect.origin.x, self.rect.origin.y, self.rect.size.width, self.rect.size.height);
    return frame;
}

+ (id)createFrame:(CGRect)_rect{
    id obj = [[[FrameObject alloc]initWithRect:_rect]autorelease];
    return obj;
}
@end

@implementation CUSPadNavigationController{
    CGRect bakTopFrame;
    BOOL firstFoldFlag;
    NSInteger currentIndex;
    BOOL layouting;
}
@synthesize array;
@synthesize padLetWidth0;
@synthesize padLetWidth1;
@synthesize padMiddelWidth;

+(id)sharedtInstance{
    @synchronized(self){
        if(CUSPadNavigationControllerInstance == nil){
            CUSPadNavigationControllerInstance = [[CUSPadNavigationController alloc]init];
        }
        return CUSPadNavigationControllerInstance;
    }
}
- (id)init {
    self = [super init];
    if (self) {
        self.array = [NSMutableArray array];
        self.padLetWidth0 = 178.0;
        self.padLetWidth1 = 64.0;
        self.padMiddelWidth = 480.0;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    self.view.clipsToBounds = YES;
    
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handelPan:)];
    [self.view addGestureRecognizer:gestureRecognizer];
    [gestureRecognizer release];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self resetSubViewLayout:YES];
    
    self.padMiddelWidth = (self.view.frame.size.width - self.padLetWidth1)/2;
}


//0:进入 1:移出
-(void)playAnimated:(NSInteger)direction{
    
}

-(void) doResetSubViewLayout{
    if([self.array count] == 0){
        return;
    }
    UIView *leftView = ((UIViewController *)[self.array objectAtIndex:0]).view;
    UIView *middleView = nil;
    CGFloat x ;
    if (firstFoldFlag) {
        x = self.padLetWidth1;
    }else{
        x = self.padLetWidth0;
    }
    leftView.frame = CGRectMake(0.0, 0.0, self.padLetWidth0, self.view.frame.size.height);
    if([self.array count] == 2){
        middleView = ((UIViewController *)[self.array objectAtIndex:1]).view;
        middleView.frame = CGRectMake(x, 0.0, self.padMiddelWidth, self.view.frame.size.height);
    }else if([self.array count] >= 3){
        NSInteger realIndex = currentIndex;
  
        for (int i = 1; i < realIndex && i < [self.array count]; i++) {
            UIView *otherView = ((UIViewController *)[self.array objectAtIndex:i]).view;
            otherView.frame = CGRectMake(x, 0.0, self.padMiddelWidth, self.view.frame.size.height);
        }

        for (int i = realIndex; i < [self.array count]; i++) {
            NSInteger relativeIndex = i - realIndex;
            CGFloat extendX = x + (relativeIndex + 1) * self.padMiddelWidth;
            UIView *otherView = ((UIViewController *)[self.array objectAtIndex:i]).view;
            otherView.frame = CGRectMake(extendX, 0.0, self.padMiddelWidth, self.view.frame.size.height);
        }
    }
}

-(void)layouPrepare{
    for (int i = currentIndex; i < [self.array count]; i++) {
        UIViewController *viewController = [self.array objectAtIndex:i];
        if ([viewController respondsToSelector:@selector(padNavigationController:autoDragCloseViewController:)]) {
            int ret = (int)[viewController performSelector:@selector(padNavigationController:autoDragCloseViewController:)];
            BOOL flag = [[NSNumber numberWithInt:ret] boolValue];
            if(flag){
                UIViewController *realViewController = [self.array objectAtIndex:i];
                if(realViewController.view.frame.origin.x > self.view.frame.size.width + 100){
                    [self popViewController:viewController animated:NO];
                }
            }
        }
    }
}
-(void) delayDoSubViewLayout:(NSNumber *)animated{
    [self layouPrepare];
    if([animated boolValue]){
        
        [UIView animateWithDuration:0.35 animations:^{
            [self doResetSubViewLayout];
        }];
    }else{
        [self doResetSubViewLayout];
        
    }
    layouting = NO;
}
-(void) resetSubViewLayout:(BOOL)animated{
    if(layouting){
        return;
    }
    layouting = YES;
    [self performSelector:@selector(delayDoSubViewLayout:) withObject:[NSNumber numberWithBool:animated] afterDelay:0.05];
    
}

-(void)handelPan:(UIPanGestureRecognizer *)gestureRecognizer{
    if([self.array count] <=1){
        return;
    }
    CGPoint translatedPoint = [gestureRecognizer translationInView:self.view];
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
        UIView *topView = ((UIViewController *)[self.array lastObject]).view;
        bakTopFrame =  topView.frame;
        
    }else if(gestureRecognizer.state == UIGestureRecognizerStateChanged){
        UIView *topView = ((UIViewController *)[self.array lastObject]).view;
        CGRect frame = CGRectMake(bakTopFrame.origin.x + translatedPoint.x, bakTopFrame.origin.y, bakTopFrame.size.width, bakTopFrame.size.height);
        topView.frame = frame;
        if([self.array count] >= 3){
            CGFloat lastX = frame.origin.x;
            
            for (int i = [self.array count] - 2; i > 0; i--) {
                //处理后的index，联动拉的效果
                //原理是，拉动最上层的View，下一层的View根据上层的View位置变化
                UIView *view = ((UIViewController *)[self.array objectAtIndex:i]).view;
                CGRect frame = view.frame;
                lastX -= self.padMiddelWidth;
                frame.origin.x = lastX;
                
                if(frame.origin.x < self.padLetWidth1){
                    frame.origin.x = self.padLetWidth1;
                }
                view.frame = frame;
            }
        }
    }else{
        if([self.array count] > 2){
            //计算currentIndex
            if(translatedPoint.x > 0){
                NSInteger scrollNum = translatedPoint.x / self.padMiddelWidth;
                if(((int)translatedPoint.x % (int)(self.padMiddelWidth)) > (self.padMiddelWidth / 2)){
                    scrollNum++;
                }
                currentIndex = currentIndex - scrollNum;
            }else{
                NSInteger scrollNum = (-translatedPoint.x) / self.padMiddelWidth;
                
                if(((int)(-translatedPoint.x) % (int)(self.padMiddelWidth)) > (self.padMiddelWidth / 2)){
                    scrollNum++;
                }
                currentIndex = currentIndex + scrollNum;
            }
            
            if(currentIndex > [self.array count] - 1){
                currentIndex = [self.array count] - 1;
            }
            
            if(currentIndex < 2){
                currentIndex = 2;
            }
            
            //计算firstFoldFlag
            UIView *secondView = ((UIViewController *)[self.array objectAtIndex:1]).view;
            CGFloat secondViewX = secondView.frame.origin.x;
            if(secondViewX > (self.padLetWidth0 + self.padLetWidth1) / 2){
                firstFoldFlag = NO;
            }else{
                firstFoldFlag = YES;
            }
        }
        
        [self resetSubViewLayout:YES];
    }
}

-(void)viewControllerChanged:(BOOL)animated addtion:(BOOL)add{
    if(add){
        if([self.array count] >= 3){
            firstFoldFlag = YES;
        }else {
            firstFoldFlag = NO;
        }
    }else{
        if([self.array count] <= 2){
            firstFoldFlag = NO;
        }
    }

    currentIndex = [self.array count] - 1;
    [self resetSubViewLayout:animated];
    [self playAnimated:1];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (!viewController) {
        return;
    }
    UIViewController *realController = viewController; 
    realController.view.frame = CGRectMake(self.view.frame.size
                                           .width, 0.0, self.padMiddelWidth, self.view.frame.size.height);
    id <CUSPadNavigationControllerDelegate> padFrameDelegate = (id <CUSPadNavigationControllerDelegate>)viewController;
    if([padFrameDelegate respondsToSelector:@selector(padNavigationController:willShowViewController:animated:)]){
        [padFrameDelegate padNavigationController:self willShowViewController:viewController animated:animated];
    }
    
    [self.view addSubview:realController.view];
    CALayer *la = realController.view.layer;
    la.shadowColor = [UIColor blackColor].CGColor;
    la.shadowOffset = CGSizeMake(-5.0f, 3.0f);
    la.shadowOpacity= 0.15;
    
    [la setShadowPath:[UIBezierPath bezierPathWithRoundedRect:(CGRect){0, 0, 10,self.view.frame.size.height} cornerRadius:0].CGPath];

    [self.array addObject:realController];
    
    
    [self viewControllerChanged:animated addtion:YES];
    
    
    if([padFrameDelegate respondsToSelector:@selector(padNavigationController:didShowViewController:animated:)]){
        [padFrameDelegate padNavigationController:self didShowViewController:viewController animated:animated];
    }
}

-(BOOL)handelPadNavigationController:(CUSPadNavigationController*)navigationController willPopViewController:(UIViewController*)viewController animated:(BOOL)animated{
    id <CUSPadNavigationControllerDelegate> padFrameDelegate = (id <CUSPadNavigationControllerDelegate>)viewController;
    if([padFrameDelegate respondsToSelector:@selector(padNavigationController:willPopViewController:animated:)]){
        return [padFrameDelegate padNavigationController:self willPopViewController:viewController animated:animated];
    }
    return YES;
}

-(void)handelPadNavigationController:(CUSPadNavigationController*)navigationController didPopViewController:(UIViewController*)viewController animated:(BOOL)animated{
    id <CUSPadNavigationControllerDelegate> padFrameDelegate = (id <CUSPadNavigationControllerDelegate>)viewController;
    if([padFrameDelegate respondsToSelector:@selector(padNavigationController:didPopViewController:animated:)]){
        [padFrameDelegate padNavigationController:self didPopViewController:viewController animated:animated];
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    if([self.array count] == 0){
        return nil;
    }
    UIViewController *viewController = [self.array lastObject];
    if(!viewController){
        return nil;
    }
    BOOL flag = [self handelPadNavigationController:self willPopViewController:viewController animated:animated];
    if(!flag){
        return nil;
    }
    [viewController.view removeFromSuperview];
    
    [self.array removeLastObject];
   
    [self handelPadNavigationController:self didPopViewController:viewController animated:animated];
    [self viewControllerChanged:animated addtion:NO];
    
    return viewController;
}

- (UIViewController *)popViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if([self.array count] == 0){
        return nil;
    }
    NSInteger index = [self.array indexOfObject:viewController];
    if(index < 0){
        return nil;
    }
    UIViewController *controller = [self.array objectAtIndex:index];
    BOOL flag = [self handelPadNavigationController:self willPopViewController:viewController animated:animated];
    if(!flag){
        return nil;
    }
    [controller.view removeFromSuperview];
    [self.array removeObjectAtIndex:index];
    [self handelPadNavigationController:self didPopViewController:viewController animated:animated];
    [self viewControllerChanged:animated addtion:NO];
    return controller;
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if([self.array count] == 0){
        return nil;
    }
    
    NSInteger index = [self.array indexOfObject:viewController];
    if(index < 0){
        return nil;
    }
    
    NSMutableArray *retArray = [NSMutableArray array];

    NSInteger counter = [self.array count];
    for (int i = counter - 1; i >= index + 1; i--) {
        UIViewController *controller = [self popViewControllerAnimated:animated];
        if (controller) {
            [retArray addObject:controller];
        }
    }
//    for (int i = index + 1; i < [self.array count]; i++) {
//        UIViewController *controller = [self.array objectAtIndex:i];
//        [retArray addObject:controller];
//    }
//    
//    for (int i = 0; i < [retArray count]; i++) {
//        UIView *view = ((UIViewController *)[retArray objectAtIndex:i]).view;
//        [view removeFromSuperview];
//    }
//    [self.array removeObjectsInArray:retArray];
//    
// 
//    [self viewControllerChanged:animated addtion:NO];
    return retArray;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated{
    if([self.array count] == 0){
        return nil;
    }
    UIViewController *controller = [self.array objectAtIndex:0];
    return [self popToViewController:controller animated:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{  
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight ||toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft);  
}

-(void)clearAll{
    [self.array removeAllObjects];
    
    for (UIView *subView in self.view.subviews) {
        [subView removeFromSuperview];
    }
    firstFoldFlag = NO;
    layouting =NO;
}
- (void)dealloc
{
    self.array = nil;
    [super dealloc];
}
@end
