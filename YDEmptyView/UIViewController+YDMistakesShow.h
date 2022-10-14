//
//  UIViewController+YDMistakesShow.h
//  YDEmptyView
//
//  Created by 王远东 on 2022/8/22.
//  Copyright © 2022 wangyuandong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDEmptyView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (YDMistakesShow)

@property (nonatomic, copy) void(^retryBlock)(void);
@property (nonatomic, strong, readonly) YDEmptyView *emptyView;

- (void)hideRetryView;
    
// 显示隐藏 RetryView
- (void)showEmptyViewType:(EYDEmptyType)aEmptyType;

/**
 * 显示自定义的retryView
 *  @param aTitle    黑色字体
 *
 */
- (void)showEmptyView:(NSString *)aImageString title:(NSString *)aTitle tipBtnTitle:(NSString *)tipBtnTitle subTipBtnTitle:(NSString *)subTipBtnTitle;

/**
 * 显示自定义的retryView
 *  @param aTitle    黑色字体
 *
 */
- (void)showEmptyView:(NSString *)aImageString title:(NSString *)aTitle tipBtnTitle:(NSString *)tipBtnTitle subTipBtnTitle:(NSString *)subTipBtnTitle isRetryTap:(BOOL)isRetryTap;

/// 展示自定义的emptyView
/// @param aImageString image
/// @param aTitle title
/// @param tipBtnTitle button title
/// @param subTipBtnTitle sub tip button title
/// @param isrefresh reload emptyView
- (void)showEmptyView:(NSString *)aImageString title:(NSString *)aTitle tipBtnTitle:(NSString *)tipBtnTitle subTipBtnTitle:(NSString *)subTipBtnTitle refresh:(BOOL)isrefresh;

// 重写该方法，该方法在被点击时执行
- (void)handleRetry;
- (void)handleEmptyTipBtn:(id)sender;
- (void)handleEmptySubTipBtn:(id)sender;

#pragma mark - UI处理 kRACUINoData  kRACUIError
/**
 * 只支持 kRACUINoData  kRACUIError 的显示
 *  @param aHiddenBlock      要将self 上的部分view 显示隐藏
 *  @param ashowErrorBlock   错误判断 是否在界面上显示错误信息
 */
- (void)sendNext:(NSDictionary *)aDic hiddenUI:(void(^)(BOOL hidden))aHiddenBlock showError:(BOOL (^)(NSError *error))ashowErrorBlock ;
/**
 * 只支持 kRACUINoData  kRACUIError 的显示
 *  @param aHiddenBlock      要将self 上的部分view 显示隐藏
 *  @param isRefresh         是否重新加载控件
 *  @param ashowErrorBlock   错误判断 是否在界面上显示错误信息
 */
- (void)sendNext:(NSDictionary *)aDic hiddenUI:(void(^)(BOOL hidden))aHiddenBlock refresh:(BOOL)isRefresh showError:(BOOL (^)(NSError *error))ashowErrorBlock;

// SplitViewController
- (void)sendSplitViewControllerNext:(NSDictionary *)aDic showError:(BOOL (^)(NSError *error))ashowErrorBlock;

@end

NS_ASSUME_NONNULL_END
