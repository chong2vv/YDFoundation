//
//  UIViewController+Toast.h
//  YDProgressHUD
//
//  Created by 王远东 on 2022/8/19.
//  Copyright © 2022 wangyuandong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#if DEBUG
#define DeBugShow(error)      [YDProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"测试弹窗 勿提Bug-------%@",error]];
#else
#define DeBugShow(error)
#endif

@interface UIViewController (Toast)

- (void)showText:(NSString *)aText;

- (void)showCustomImage:(NSString *)imageName status:(NSString *)status;

- (void)showErrorText:(NSString *)aText;
- (void)showSuccessText:(NSString *)aText;
//阻塞式的loading
- (void)showLoading;
- (void)showLottieLoading;
//非阻塞loading 点击屏幕即可让loading消失
- (void)showLoadingCancelBlock:(void(^)(void))cancelBlock;

- (void)dismissLoading;
- (void)dismissLoadingMessage:(NSString *)      message
                        delay:(CGFloat)         delay
                   completion:(dispatch_block_t)handler;

+ (void)showText:(NSString *)aText;
+ (void)showLoading;
+ (void)showLottieLoading;
+ (void)dismissLoading;
+ (void)showErrorText:(NSString *)aText;

@end

NS_ASSUME_NONNULL_END
