//
//  YDOverWriteSVProgressHUD.h
//  YDProgressHUD
//
//  Created by 王远东 on 2022/8/19.
//  Copyright © 2022 wangyuandong. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import <AvailabilityMacros.h>


typedef NS_ENUM(NSInteger, YDProgressHUDStyle) {
    YDProgressHUDStyleLight,        // default style, white HUD with black text, HUD background will be blurred on iOS 8 and above
    YDProgressHUDStyleDark,         // black HUD and white text, HUD background will be blurred on iOS 8 and above
    YDProgressHUDStyleCustom,        // uses the fore- and background color properties
    
    YDProgressHUDStyleLoading,
    
    YDProgressHUDStyleToast,
};

@interface YDOverWriteSVProgressHUD : UIView

#pragma mark - Customization

+ (void)setDefaultStyle:(YDProgressHUDStyle)style;                  // default is YDProgressHUDStyleLight
+ (void)setDefaultMaskType:(SVProgressHUDMaskType)maskType;         // default is SVProgressHUDMaskTypeNone
+ (void)setDefaultAnimationType:(SVProgressHUDAnimationType)type;   // default is SVProgressHUDAnimationTypeFlat
+ (void)setRingThickness:(CGFloat)width;                            // default is 2 pt
+ (void)setCornerRadius:(CGFloat)cornerRadius;                      // default is 14 pt
+ (void)setFont:(UIFont*)font;                                      // default is [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]
+ (void)setForegroundColor:(UIColor*)color;                         // default is [UIColor blackColor], only used for YDProgressHUDStyleCustom
+ (void)setBackgroundColor:(UIColor*)color;                         // default is [UIColor whiteColor], only used for YDProgressHUDStyleCustom
+ (void)setInfoImage:(UIImage*)image;                               // default is the bundled info image provided by Freepik
+ (void)setSuccessImage:(UIImage*)image;                            // default is the bundled success image provided by Freepik
+ (void)setErrorImage:(UIImage*)image;                              // default is the bundled error image provided by Freepik
+ (void)setViewForExtension:(UIView*)view;                          // default is nil, only used if #define SV_APP_EXTENSIONS is set
//+ (void)setHideCloseBtn:(BOOL)hideCloseBtn;


#pragma mark - Show Methods

+ (void)show;
+ (void)showWithMaskType:(SVProgressHUDMaskType)maskType __attribute__((deprecated("Use show and setDefaultMaskType: instead.")));;
+ (void)showWithStatus:(NSString*)status;
+ (void)showWithStatus:(NSString*)status maskType:(SVProgressHUDMaskType)maskType __attribute__((deprecated("Use showWithStatus: and setDefaultMaskType: instead.")));

+ (void)showProgress:(float)progress;
+ (void)showProgress:(float)progress maskType:(SVProgressHUDMaskType)maskType __attribute__((deprecated("Use showProgress: and setDefaultMaskType: instead.")));
+ (void)showProgress:(float)progress status:(NSString*)status;
+ (void)showProgress:(float)progress status:(NSString*)status maskType:(SVProgressHUDMaskType)maskType __attribute__((deprecated("Use showProgress: and setDefaultMaskType: instead.")));

+ (void)setStatus:(NSString*)status; // change the HUD loading status while it's showing

// stops the activity indicator, shows a glyph + status, and dismisses the HUD a little bit later
+ (void)showInfoWithStatus:(NSString*)status;
+ (void)showInfoWithStatus:(NSString*)status maskType:(SVProgressHUDMaskType)maskType __attribute__((deprecated("Use showInfoWithStatus: and setDefaultMaskType: instead.")));
+ (void)showSuccessWithStatus:(NSString*)status;
+ (void)showSuccessWithStatus:(NSString*)status maskType:(SVProgressHUDMaskType)maskType __attribute__((deprecated("Use showSuccessWithStatus: and setDefaultMaskType: instead.")));
+ (void)showErrorWithStatus:(NSString*)status;
+ (void)showErrorWithStatus:(NSString*)status maskType:(SVProgressHUDMaskType)maskType __attribute__((deprecated("Use showErrorWithStatus: and setDefaultMaskType: instead.")));

// shows a image + status, use 28x28 white PNGs
+ (void)showImage:(UIImage*)image status:(NSString*)status;
+ (void)showImage:(UIImage*)image status:(NSString*)status maskType:(SVProgressHUDMaskType)maskType __attribute__((deprecated("Use showImage: and setDefaultMaskType: instead.")));
// shows a image + status, use 50x50 images
+ (void)showImage:(UIImage*)image status:(NSString*)status duration:(NSTimeInterval)duration;

#warning 如果要更新SVProgressHUD,或者替换为pod管理, 注意这里的修改, 更新后可能无法使用该方法
/// 扩展支持lottie动画
/// @param jsonPath 资源路径
/// @param status 状态
+ (void)showLottieView:(NSString *)jsonPath bgImage:(UIImage *)image status:(NSString *)status;

+ (void)setOffsetFromCenter:(UIOffset)offset;
+ (void)resetOffsetFromCenter;

+ (void)popActivity; // decrease activity count, if activity count == 0 the HUD is dismissed
+ (void)dismiss;
+ (void)dismissWithDelay:(NSTimeInterval)delay; // delayes the dismissal

+ (BOOL)isVisible;

+ (void)changeOrientation:(UIInterfaceOrientation)orientation;
@end

