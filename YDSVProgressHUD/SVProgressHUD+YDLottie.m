//
//  SVProgressHUD+YDLottie.m
//  YDProgressHUD
//
//  Created by 王远东 on 2022/8/18.
//  Copyright © 2022 wangyuandong. All rights reserved.
//

#import "SVProgressHUD+YDLottie.h"
#import <objc/runtime.h>


static NSString *lottieBgviewKey = @"lottieBgviewKey";
static NSString *lottieViewKey = @"lottieViewKey";
static NSString *stringLabelKey = @"stringLabelKey";

@interface SVProgressHUD ()

//Lot背景view
@property (nonatomic, strong) UIView *lottieBgview;
//提示文字
@property (nonatomic, strong) UILabel *stringLabel;

@property (nonatomic, readwrite) CGFloat progress;
@property (nonatomic, readwrite) CGFloat dissmissing;

@end

@implementation SVProgressHUD (YDLottie)

//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [self exchangeClassMethod:[self class] method1Sel:@selector(swizzle_sharedView) method2Sel:@selector(sharedView)];
//    });
//}

//+ (SVProgressHUD*)swizzle_sharedView {
//    static dispatch_once_t once;
//
//    static SVProgressHUD *sharedView;
//#if !defined(SV_APP_EXTENSIONS)
//    dispatch_once(&once, ^{ sharedView = [[self alloc] initWithFrame:[[[UIApplication sharedApplication] delegate] window].bounds]; });
//#else
//    dispatch_once(&once, ^{ sharedView = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; });
//#endif
//    return sharedView;
//}

+ (void)exchangeClassMethod:(Class)anClass method1Sel:(SEL)method1Sel method2Sel:(SEL)method2Sel {
    Method method1 = class_getClassMethod(anClass, method1Sel);
    Method method2 = class_getClassMethod(anClass, method2Sel);
    method_exchangeImplementations(method1, method2);
}

- (UIView *)lottieBgview {
    return objc_getAssociatedObject(self, &lottieBgviewKey);
}

- (void)setLottieBgview:(UIView *)lottieBgview {
    objc_setAssociatedObject(self, &lottieBgviewKey, lottieBgview, OBJC_ASSOCIATION_COPY);
}

- (UILabel *)stringLabel {
    return objc_getAssociatedObject(self, &stringLabelKey);
}

- (void)setStringLabel:(UILabel *)stringLabel {
    objc_setAssociatedObject(self, &stringLabelKey, stringLabel, OBJC_ASSOCIATION_COPY);
}
@end
