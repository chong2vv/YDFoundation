//
//  YDEmptyViewConfig.m
//  YDEmptyView
//
//  Created by 王远东 on 2022/8/22.
//  Copyright © 2022 wangyuandong. All rights reserved.
//

#import "YDEmptyViewConfig.h"

@implementation YDEmptyViewConfig

+ (NSDictionary<NSString *,UIImage *> *)emptyImage {
    return [NSDictionary new];
}

+ (UIImage *)defaultEmptyImage {
    return [UIImage new];
}

+ (NSDictionary<NSString *, UIImage *> *)buttonBackgroundImage {
    return [NSDictionary new];
}

+ (UIColor *)subButtonTitleColor {
    return [UIColor blueColor];
}

+ (UIColor *)tipTextColor {
    return [UIColor grayColor];
}

// tipBtn 圆角
+ (CGFloat)tipBtnCornerRadius{
    return 20.f;
}

+ (UIButton *)resetTipBtn
{
    return nil;
}

+ (UIButton *)resetSubTipBtn
{
    return nil;
}


@end
