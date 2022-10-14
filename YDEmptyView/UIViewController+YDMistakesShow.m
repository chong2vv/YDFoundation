//
//  UIViewController+YDMistakesShow.m
//  YDEmptyView
//
//  Created by 王远东 on 2022/8/22.
//  Copyright © 2022 wangyuandong. All rights reserved.
//

#import "UIViewController+YDMistakesShow.h"
#import <objc/runtime.h>
#import <Masonry/Masonry.h>

#define kRACUINoData    @"kRACUINoData"    // BOOL 是否 网络请求成功 无数据
#define kRACUIError     @"kRACUIError"     // NSError 网络请求错误进行UI处理
// 发送 kRACUINoData kRACUIError 时可加上 自定义 图片 文字
#define kShowImgeString  @"kShowImgeString"      // NSString 自定义图片
#define kShowTipString @"kShowTipString"         // NSString NSAttributedString 自定义文字 14
#define kShowTipBtnString @"kShowTipBtnString"   // NSString NSAttributedString 自定义文字 14
#define kShowSubTipBtnString @"kShowSubTipBtnString"   // NSString NSAttributedString 自定义文字 12
#define kRACUIIsRetryTap   @"kRACUIIsRetryTap"   // BOOL 是否添加tap手势

@interface UIViewController ()
@property (nonatomic, strong) YDEmptyView *emptyView;
@property (nonatomic, strong) UITapGestureRecognizer *retryTap;
@end

@implementation UIViewController (YDMistakesShow)

- (void)hideRetryView {
    if (self.emptyView) {
        [self.emptyView removeFromSuperview];
        self.emptyView = nil;
    }
    
    if(self.retryTap) {
        [self.view removeGestureRecognizer:self.retryTap];
        self.retryTap = nil;
    }
}
- (void)showEmptyView:(NSString *)aImageString title:(NSString *)aTitle tipBtnTitle:(NSString *)tipBtnTitle subTipBtnTitle:(NSString *)subTipBtnTitle refresh:(BOOL)isrefresh {
    if (isrefresh) {
        if (self.emptyView) {
            [self.emptyView removeFromSuperview];
            self.emptyView = nil;
        }
    }
    [self showEmptyView:aImageString title:aTitle tipBtnTitle:tipBtnTitle subTipBtnTitle:subTipBtnTitle type:EYDEmptyTypeCustom isRetryTap:YES];
}


- (void)showEmptyView:(NSString *)aImageString title:(NSString *)aTitle tipBtnTitle:(NSString *)tipBtnTitle subTipBtnTitle:(NSString *)subTipBtnTitle type:(EYDEmptyType)aEmptyType isRetryTap:(BOOL)isRetryTap
{
    if (self.emptyView) {
        [self.emptyView removeFromSuperview];
        self.emptyView = nil;
    }
    self.emptyView = [[YDEmptyView alloc] init];
    [self.view addSubview:self.emptyView];
    [self.view sendSubviewToBack:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.width.equalTo(self.view);
    }];
    self.emptyView.emptyType = aEmptyType;
    if (aEmptyType == EYDEmptyTypeCustom || aEmptyType == EYDEmptyTypeNetwork) {
        __weak typeof(self) ws = self;
        [self.emptyView configureEmptyView:aImageString title:aTitle tipBtnTitle:tipBtnTitle subTipBtnTitle:subTipBtnTitle handleAction:^(EYDEmptyActionType actionType) {
            switch (actionType) {
                case EYDEmptyActionTypeCustomTip:
                    [ws handleEmptyTipBtn:ws.emptyView.tipBtn];
                    break;
                case EYDEmptyActionTypeCustomSubTip:
                    [ws handleEmptySubTipBtn:ws.emptyView.subTipBtn];
                    break;
                case EYDEmptyActionTypeNetworkRefresh:
                    [ws retry];
                    break;
                case EYDEmptyActionTypeNetworkSet: {
//                        [YDUtil openSystemSetting]; xwx 方法实现
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        //打开该应用的通知设置界面
                        //        NSURL *url = [NSURL URLWithString:@"prefs:root=NOTIFICATIONS_ID&path=com.msb.YDbox"];
                        //打开该应用的设置界面(包含地理位置、通知、隐私...)
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }
                    break;
                default:
                    break;
            }
        }];
    }
    self.emptyView.hidden = NO;
    if (isRetryTap == YES) {
        if (!self.retryTap) {
            self.retryTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(retry)];
            [self.view addGestureRecognizer:self.retryTap];
        }
    }
    
    
}

- (void)showEmptyView:(NSString *)aImageString title:(NSString *)aTitle tipBtnTitle:(NSString *)tipBtnTitle subTipBtnTitle:(NSString *)subTipBtnTitle
{
    [self showEmptyView:aImageString title:aTitle tipBtnTitle:tipBtnTitle subTipBtnTitle:subTipBtnTitle type:EYDEmptyTypeCustom isRetryTap:YES];
}

- (void)showEmptyView:(NSString *)aImageString title:(NSString *)aTitle tipBtnTitle:(NSString *)tipBtnTitle subTipBtnTitle:(NSString *)subTipBtnTitle isRetryTap:(BOOL)isRetryTap
{
    [self showEmptyView:aImageString title:aTitle tipBtnTitle:tipBtnTitle subTipBtnTitle:subTipBtnTitle type:EYDEmptyTypeCustom isRetryTap:isRetryTap];
}

- (void)showEmptyViewType:(EYDEmptyType)aEmptyType {
    [self showEmptyView:nil title:nil tipBtnTitle:nil subTipBtnTitle:nil type:aEmptyType isRetryTap:YES];
}

- (void)retry
{
    //数据为空的情况不需要重新请求
    [self hideRetryView];
    if (self.retryBlock) {
        self.retryBlock();
    }
    [self handleRetry];
}

// 重写该方法，该方法在被点击时执行
- (void)handleRetry {
    
}

// 重写该方法，该方法在被点击时执行
- (void)handleEmptyTipBtn:(id)sender {
    
}

// 重写该方法，该方法在被点击时执行
- (void)handleEmptySubTipBtn:(id)sender {
    
}

// 为普通调用准备
- (void)sendNext:(NSDictionary *)aDic hiddenUI:(void(^)(BOOL hidden))aHiddenBlock showError:(BOOL (^)(NSError *error))ashowErrorBlock {
    
    if (aHiddenBlock) {
        aHiddenBlock(NO);
    }
    
    __weak typeof(self) ws = self;
    self.retryBlock = ^{
        if (aHiddenBlock) {
            aHiddenBlock(NO);
        }
        ws.retryBlock = nil;
    };
    
    if (aDic[kRACUINoData]) {
        if (aHiddenBlock) {
            aHiddenBlock(YES);
        }
        if(aDic[kShowImgeString] || aDic[kShowTipString] || aDic[kShowTipBtnString] || aDic[kShowSubTipBtnString]) {
            [self showEmptyView:aDic[kShowImgeString] title:aDic[kShowTipString] tipBtnTitle:aDic[kShowTipBtnString] subTipBtnTitle:aDic[kShowSubTipBtnString] type:EYDEmptyTypeCustom isRetryTap:aDic[kRACUIIsRetryTap]?[aDic[kRACUIIsRetryTap] boolValue]:YES];
        } else {
            [self showEmptyViewType:EYDEmptyTypeData];
        }
    }
    
    NSError *error = aDic[kRACUIError];
    if (error != nil) {
        NSLog(@"加载错误，进行错误的UI展现处理");
        BOOL showError = NO;
        if (aHiddenBlock) {
            showError = ashowErrorBlock(error);
        }
        if (showError) {
            
            if (aHiddenBlock) {
                aHiddenBlock(YES);
            }
            if(aDic[kShowImgeString] || aDic[kShowTipString] || aDic[kShowTipBtnString] || aDic[kShowSubTipBtnString]) {
                [self showEmptyView:aDic[kShowImgeString] title:aDic[kShowTipString] tipBtnTitle:aDic[kShowTipBtnString] subTipBtnTitle:aDic[kShowSubTipBtnString] type:EYDEmptyTypeCustom isRetryTap:aDic[kRACUIIsRetryTap]?[aDic[kRACUIIsRetryTap] boolValue]:YES];
            } else {
                if(error.code == NSURLErrorNetworkConnectionLost || error.code == NSURLErrorNotConnectedToInternet) {
                    [self showEmptyViewType:EYDEmptyTypeNetwork];
                } else {
                    [self showEmptyViewType:EYDEmptyTypeRequest];
                }
            }
        }
    }
}

- (void)sendNext:(NSDictionary *)aDic hiddenUI:(void (^)(BOOL))aHiddenBlock refresh:(BOOL)isRefresh showError:(BOOL (^)(NSError *))ashowErrorBlock{
    if (aHiddenBlock) {
        aHiddenBlock(NO);
    }
    
    __weak typeof(self) ws = self;
    self.retryBlock = ^{
        if (aHiddenBlock) {
            aHiddenBlock(NO);
        }
        ws.retryBlock = nil;
    };
    
    if (aDic[kRACUINoData]) {
        if (aHiddenBlock) {
            aHiddenBlock(YES);
        }
        if(aDic[kShowImgeString] || aDic[kShowTipString] || aDic[kShowTipBtnString] || aDic[kShowSubTipBtnString]) {
            [self showEmptyView:aDic[kShowImgeString] title:aDic[kShowTipString] tipBtnTitle:aDic[kShowTipBtnString] subTipBtnTitle:aDic[kShowSubTipBtnString] refresh:isRefresh];
        } else {
            [self showEmptyViewType:EYDEmptyTypeData];
        }
    }
    
    NSError *error = aDic[kRACUIError];
    if (error != nil) {
        NSLog(@"加载错误，进行错误的UI展现处理");
        BOOL showError = NO;
        if (aHiddenBlock) {
            showError = ashowErrorBlock(error);
        }
        if (showError) {
            
            if (aHiddenBlock) {
                aHiddenBlock(YES);
            }
            if(aDic[kShowImgeString] || aDic[kShowTipString] || aDic[kShowTipBtnString] || aDic[kShowSubTipBtnString]) {
                [self showEmptyView:aDic[kShowImgeString] title:aDic[kShowTipString] tipBtnTitle:aDic[kShowTipBtnString] subTipBtnTitle:aDic[kShowSubTipBtnString] refresh:isRefresh];
                //[self showEmptyView:aDic[kShowImgeString] title:aDic[kShowTipString] tipBtnTitle:aDic[kShowTipBtnString] subTipBtnTitle:aDic[kShowSubTipBtnString] type:EYDEmptyTypeCustom];
            } else {
                if(error.code == NSURLErrorNetworkConnectionLost || error.code == NSURLErrorNotConnectedToInternet) {
                    [self showEmptyViewType:EYDEmptyTypeNetwork];
                } else {
                    [self showEmptyViewType:EYDEmptyTypeRequest];
                }
            }
        }
    }
}

- (void)sendSplitViewControllerNext:(NSDictionary *)aDic showError:(BOOL (^)(NSError *error))ashowErrorBlock {
    NSAssert(self.splitViewController != nil, @"调用该方法时请保证他有 self.splitViewController");
    __weak typeof(self) ws = self;
    [self.splitViewController sendNext:aDic hiddenUI:^(BOOL hidden) {
        [ws.splitViewController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.view.hidden = hidden;
        }];
    } showError:ashowErrorBlock];
}

#pragma mark - 属性绑定
- (void)setEmptyView:(YDEmptyView *)emptyView
{
    objc_setAssociatedObject(self, @selector(emptyView), emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YDEmptyView *)emptyView
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRetryTap:(UITapGestureRecognizer *)retryTap
{
    objc_setAssociatedObject(self, @selector(retryTap), retryTap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UITapGestureRecognizer *)retryTap
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRetryBlock:(void (^)(void))retryBlock {
    objc_setAssociatedObject(self, @selector(retryBlock), retryBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(void))retryBlock {
    return objc_getAssociatedObject(self, _cmd);
}

@end
