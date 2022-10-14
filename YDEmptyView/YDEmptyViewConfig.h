//
//  YDEmptyViewConfig.h
//  YDEmptyView
//
//  Created by 王远东 on 2022/8/22.
//  Copyright © 2022 wangyuandong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EmptyNoDataImage           @"noDataImage"
#define EmptyNetworkExceptionImage @"networkExceptionImage"
#define EmptyRequestExceptionImage @"requestExceptionImage"

#define EmptyButtonNormalImage      @"buttonNormalImage"
#define EmptyButtonHighlightedImage @"buttonHighlightedImage"
#define EmptyButtonDisabledImage    @"buttonDisabledImage"

NS_ASSUME_NONNULL_BEGIN

///工程使用的时候用分类覆盖即可
@interface YDEmptyViewConfig : NSObject

+ (NSDictionary<NSString *, UIImage *> *)emptyImage;

+ (UIImage *)defaultEmptyImage;

+ (NSDictionary<NSString *, UIImage *> *)buttonBackgroundImage;

+ (UIColor *)subButtonTitleColor;

+ (UIColor *)tipTextColor;
// tipBtn 圆角
+ (CGFloat)tipBtnCornerRadius;
// 可选  重新覆盖tipBtn
+ (UIButton *)resetTipBtn;
// 可选  重新覆盖subTipBtn
+ (UIButton *)resetSubTipBtn;

@end

NS_ASSUME_NONNULL_END
