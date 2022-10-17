//
//  YDProgressHUD.h
//  YDProgressHUD
//
//  Created by 王远东 on 2022/8/18.
//  Copyright © 2022 wangyuandong. All rights reserved.
//

#import "YDOverWriteSVProgressHUD.h"
#import "YDProgressHUDConfig.h"
#import "UIViewController+Toast.h"
#import "SVProgressHUD+YDLottie.h"

@interface YDProgressHUD : YDOverWriteSVProgressHUD

+ (void)customInitialize;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
/**
 blockOperation YES 阻塞操作 需要手动调用dismiss NO 不阻塞 点击屏幕即可让loading消失
 cancelBlock 取消后的回调
 */
+ (void)showLoadingBlockOperation:(BOOL)isBlockOperation;

+ (void)showLoadingBlockOperation:(BOOL)isBlockOperation cancelBlock:(void(^)())cancelBlock;

+ (void)showWithStatus:(NSString*)status blockOperation:(BOOL)isBlockOperation;

+ (void)showWithStatus:(NSString*)status blockOperation:(BOOL)isBlockOperation cancelBlock:(void(^)())cancelBlock;

+(void)showProgress:(NSInteger)progress;

+(void)showText:(NSString *)aText orientation:(UIInterfaceOrientation)orientation;

+(void)showImage:(UIImage *)image status:(NSString *)status duration:(NSTimeInterval)duration;

+(void)showLottieView:(NSString *)jsonPath bgImage:(UIImage *)image status:(NSString *)status;
#pragma clang diagnostic pop

@end

