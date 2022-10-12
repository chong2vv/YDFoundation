//
//  UIViewController+Toast.m
//  YDProgressHUD
//
//  Created by 王远东 on 2022/8/19.
//  Copyright © 2022 wangyuandong. All rights reserved.
//

#import "UIViewController+Toast.h"
#import <YYImage/YYImage.h>
#import "YDProgressHUD.h"
#import "YDProgressHUDConfig.h"

@implementation UIViewController (Toast)

- (void)showText:(NSString *)aText
{
    [YDProgressHUD setDefaultStyle:YDProgressHUDStyleToast];
    [YDProgressHUD showInfoWithStatus:aText];
}
- (void)showCustomImage:(UIImage *)image withStatus:(NSString *)status {
    [YDProgressHUD showImage:image status:status duration:DISPATCH_TIME_FOREVER];
}
- (void)showCustomImage:(NSString *)imageName status:(NSString *)status {
    [YDProgressHUD showImage:[YYImage imageNamed:imageName] status:status duration:DISPATCH_TIME_FOREVER];
}

+ (void)showText:(NSString *)aText {
    [YDProgressHUD setDefaultStyle:YDProgressHUDStyleToast];
    [YDProgressHUD showInfoWithStatus:aText];
}

+ (void)showLoading {
    [YDProgressHUD setDefaultStyle:YDProgressHUDStyleLoading];
    if ([YDProgressHUDConfig loadingImageType] == YDProgressHUDLoadingTypeGif) {
            [YDProgressHUD showImage:[YDProgressHUDConfig loadingImage] status:nil duration:DISPATCH_TIME_FOREVER];
    } else {
        [self showLottieLoading];
    }
}
+ (void)showLottieLoading {
    [YDProgressHUD setDefaultStyle:YDProgressHUDStyleLoading];
    [YDProgressHUD showLottieView:[YDProgressHUDConfig lottieLoadingPath] bgImage:[YDProgressHUDConfig lottieLoadingBGImage] status:nil];
}

+ (void)dismissLoading {
    [YDProgressHUD dismiss];
}

+ (void)showErrorText:(NSString *)aText {
    [YDProgressHUD showErrorWithStatus:aText];
}

- (void)showLoading {
    [YDProgressHUD setDefaultStyle:YDProgressHUDStyleLoading];
    //    [YDProgressHUD showLoadingBlockOperation:YES];
    if ([YDProgressHUDConfig loadingImageType] == YDProgressHUDLoadingTypeGif) {
            [self showCustomImage:[YDProgressHUDConfig loadingImage] withStatus:nil];
    } else {
        [self showLottieLoading];
    }
}
- (void)showLottieLoading {
    [YDProgressHUD setDefaultStyle:YDProgressHUDStyleLoading];
    [YDProgressHUD showLottieView:[YDProgressHUDConfig lottieLoadingPath] bgImage:[YDProgressHUDConfig lottieLoadingBGImage] status:nil];
}


- (void)showLoadingCancelBlock:(void (^)(void))cancelBlock
{
    [YDProgressHUD setDefaultStyle:YDProgressHUDStyleLoading];
    [YDProgressHUD showLoadingBlockOperation:NO cancelBlock:cancelBlock];
}

- (void)showSuccessText:(NSString *)aText
{
    [YDProgressHUD showSuccessWithStatus:aText];
}

- (void)showErrorText:(NSString *)aText {
    [YDProgressHUD showErrorWithStatus:aText];
}

- (void)dismissLoading {
    [YDProgressHUD dismiss];
}

- (void)dismissLoadingMessage:(NSString *)message delay:(CGFloat)delay completion:(dispatch_block_t)handler {
    [YDProgressHUD dismiss];
    [YDProgressHUD showSuccessWithStatus:message];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [YDProgressHUD dismiss];
        if (handler)
            handler();
    });
}

- (void)showText:(NSString *)aText orientation:(UIInterfaceOrientation)orientation
{
    [YDProgressHUD showText:aText orientation:orientation];
}


@end
