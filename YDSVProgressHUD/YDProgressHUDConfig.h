//
//  YDProgressHUDConfig.h
//  YDProgressHUD
//
//  Created by 王远东 on 2022/8/18.
//  Copyright © 2022 wangyuandong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    YDProgressHUDLoadingTypeLottie = 0,
    YDProgressHUDLoadingTypeGif = 1,
} YDProgressHUDLoadingType;

@interface YDProgressHUDConfig : NSObject

+ (UIImage *)loadingImage;

+ (NSString *)lottieLoadingPath;

+ (UIImage *)lottieLoadingBGImage;

+ (UIImage *)infoImage;

+ (UIImage *)successImage;

+ (UIImage *)errorImage;

// gif动图显示大小
+ (CGSize)gifImageViewSize;

// 自定义文字颜色
+ (UIColor *)foregroundColor;

// 自定义指示器背景颜色
+ (UIColor *)hudBackgroundColor;

+ (UIColor *)hudLoadingBackgroundColor;

// 背景大小
+ (CGSize)hudBackgroundSize;

// 毛玻璃背景 默认开启
+ (BOOL)addBlurEffect;

+ (YDProgressHUDLoadingType)loadingImageType;

@end

NS_ASSUME_NONNULL_END
