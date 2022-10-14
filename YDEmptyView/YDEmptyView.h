//
//  YDEmptyView.h
//  YDEmptyView
//
//  Created by 王远东 on 2022/8/22.
//  Copyright © 2022 wangyuandong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EYDEmptyType) {
    EYDEmptyTypeNone,
    EYDEmptyTypeData,    //数据空
    EYDEmptyTypeNetwork, //网络连接出错
    EYDEmptyTypeRequest, //请求失败
    EYDEmptyTypeCustom, //自定义
};
typedef NS_ENUM(NSUInteger, EYDEmptyActionType) {
    EYDEmptyActionTypeNone,
    EYDEmptyActionTypeCustomTip,       //自定义的tipBtn点击
    EYDEmptyActionTypeCustomSubTip,    //自定义的tipSubBtn点击
    EYDEmptyActionTypeNetworkRefresh,  //网络连接出错 刷新
    EYDEmptyActionTypeNetworkSet,      //网络连接出错 打开网络设置
};

@interface YDEmptyView : UIView

@property (nonatomic, assign) EYDEmptyType emptyType;

@property (nonatomic, strong, readonly) UIButton *tipBtn;
@property (nonatomic, strong, readonly) UIButton *subTipBtn;
@property (nonatomic, strong) UILabel *tipLabel;

//不是自定义 设置无效
- (void)configureEmptyView:(NSString *)aImageString title:(id)aTitle tipBtnTitle:(id)tipBtnTitle subTipBtnTitle:(id)subTipBtnTitle handleAction:(void (^)(EYDEmptyActionType actionType))handleActionBlock;

@end

