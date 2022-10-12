//
//  YDProgressHUDConfig.m
//  YDProgressHUD
//
//  Created by 王远东 on 2022/8/18.
//  Copyright © 2022 wangyuandong. All rights reserved.
//

#import "YDProgressHUDConfig.h"

@implementation YDProgressHUDConfig

+ (YDProgressHUDLoadingType)loadingImageType
{
    return YDProgressHUDLoadingTypeLottie;
}

+ (UIImage *)loadingImage {
    return [UIImage new];
}

+ (NSString *)lottieLoadingPath {
    return @"";
}
+ (UIImage *)lottieLoadingBGImage {
    return [UIImage new];
}

+ (UIImage *)infoImage {
    return [YDProgressHUDConfig _imageWithName:@"HUD_info"];
}

+ (UIImage *)successImage {
    return [YDProgressHUDConfig _imageWithName:@"HUD_success"];
}

+ (UIImage *)errorImage {
    return [YDProgressHUDConfig _imageWithName:@"HUD_error"];
}

+ (CGSize)gifImageViewSize {
    return CGSizeMake(50.0f, 50.0f);
}

// 自定义文字颜色
+ (UIColor *)foregroundColor {
    return nil;
}
// 自定义指示器背景颜色
+ (UIColor *)hudBackgroundColor {
    return nil;
}

// 自定义指示器背景颜色
+ (UIColor *)hudLoadingBackgroundColor {
    return nil;
}

+ (CGSize)hudBackgroundSize
{
    return CGSizeMake(100.f, 100.f);
}

+ (BOOL)addBlurEffect
{
    return YES;
}



#pragma mark - Private methods

+ (UIImage *)_imageWithName:(NSString *)name {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *url = [bundle URLForResource:@"YDProgressHUD" withExtension:@"bundle"];
    NSBundle *imageBundle = [NSBundle bundleWithURL:url];
    
    UIImage *image = [UIImage imageNamed:name inBundle:imageBundle compatibleWithTraitCollection:nil];
    return image;
}
@end
