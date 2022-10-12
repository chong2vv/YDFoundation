//
//  YDProgressHUD.m
//  YDProgressHUD
//
//  Created by 王远东 on 2022/8/18.
//  Copyright © 2022 wangyuandong. All rights reserved.
//

#import "YDProgressHUD.h"
#import <objc/runtime.h> // toBeRemoved
#import "YDProgressHUDConfig.h"

@interface YDProgressHUD ()

@end

@implementation YDProgressHUD

// Customization
+ (void)initialize
{
    UIImage *infoImage = [YDProgressHUDConfig infoImage];
    UIImage *successImage = [YDProgressHUDConfig successImage];
    UIImage *errorImage = [YDProgressHUDConfig errorImage];
    [self setSuccessImage:successImage];
    [self setInfoImage:infoImage];
    [self setErrorImage:errorImage];
    
    [self setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [self setDefaultStyle:YDProgressHUDStyleDark];
    [self setCornerRadius:12.0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissAction:) name:SVProgressHUDDidReceiveTouchEventNotification object:nil];
    [self customInitialize];
}

+ (void)customInitialize {
    NSLog(@"%s",__func__);
}

+ (void)showLoadingBlockOperation:(BOOL)isBlockOperation
{
    [self showLoadingBlockOperation:isBlockOperation cancelBlock:nil];
}

+ (void)showLoadingCancelBlock:(void(^)(void))cancelBlock {
    if (cancelBlock) {
        [self showLoadingBlockOperation:NO cancelBlock:cancelBlock];
    } else {
        [self showLoadingBlockOperation:YES cancelBlock:nil];
    }
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
+ (void)showLoadingBlockOperation:(BOOL)isBlockOperation cancelBlock:(void(^)())cancelBlock {
//    [ArtProgressHUD setHideCloseBtn:isBlockOperation];
    objc_setAssociatedObject(self, "kBlockOperation", @(isBlockOperation), OBJC_ASSOCIATION_RETAIN);
    if (cancelBlock) {
        objc_setAssociatedObject(self, "kCancelBlock", cancelBlock, OBJC_ASSOCIATION_RETAIN);
    }
    [self show];
}

+ (void)showWithStatus:(NSString*)status blockOperation:(BOOL)isBlockOperation
{
    [self showWithStatus:status blockOperation:isBlockOperation cancelBlock:nil];
}

+ (void)showWithStatus:(NSString*)status blockOperation:(BOOL)isBlockOperation cancelBlock:(void(^)())cancelBlock
{
//    [ArtProgressHUD setHideCloseBtn:isBlockOperation];
    objc_setAssociatedObject(self, "kBlockOperation", @(isBlockOperation), OBJC_ASSOCIATION_RETAIN);
    if (cancelBlock) {
        objc_setAssociatedObject(self, "kCancelBlock", cancelBlock, OBJC_ASSOCIATION_RETAIN);
    }
    [self showWithStatus:status];
}


+ (void)dismissAction:(id)notify
{
     NSNumber *isBlock = objc_getAssociatedObject(self, "kBlockOperation");
    if([isBlock boolValue]) {return;}
    void(^cancelBlock)() = objc_getAssociatedObject(self, "kCancelBlock");
    [YDProgressHUD dismiss];
    if (cancelBlock) {
        cancelBlock();
    }
    objc_removeAssociatedObjects(self);
}

// 根据 提示文字字数，判断 HUD 显示时间
- (NSTimeInterval)displayDurationForString:(NSString*)string
{
    return MIN((float)string.length*0.06 + 0.5, 2.0);
}

// 修改 HUD 颜色，需要取消混合效果(使`backgroundColroForStyle`方法有效)
- (void)updateBlurBounds{
}

- (UIColor*)foregroundColorForStyle{
    return [YDProgressHUDConfig foregroundColor];
}

//加载显示百分比
// progress：百分百值 0-100
+(void)showProgress:(NSInteger)progress
{
  [YDOverWriteSVProgressHUD showProgress:progress/100.0 status:[NSString stringWithFormat:@"%li%%",(long)progress]];
}

+ (void)showText:(NSString *)aText orientation:(UIInterfaceOrientation)orientation
{
  [YDOverWriteSVProgressHUD changeOrientation:orientation];
  [YDOverWriteSVProgressHUD showInfoWithStatus:aText];
}

+ (void)showImage:(UIImage *)image status:(NSString *)status duration:(NSTimeInterval)duration {
    objc_setAssociatedObject(self, "kBlockOperation", @(YES), OBJC_ASSOCIATION_RETAIN);
    [YDOverWriteSVProgressHUD showImage:image status:status duration:duration];
}
+(void)showLottieView:(NSString *)jsonPath bgImage:(UIImage *)image status:(NSString *)status {
    objc_setAssociatedObject(self, "kBlockOperation", @(YES), OBJC_ASSOCIATION_RETAIN);
    [YDOverWriteSVProgressHUD showLottieView:jsonPath bgImage:image status:status];
}
#pragma clang diagnostic pop

@end
