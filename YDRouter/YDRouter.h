//
//  YDRouter.h
//  YDRouter
//
//  Created by 王远东 on 2022/8/18.
//  Copyright © 2022 wangyuandong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDURLHelper.h"

@interface YDRouter : NSObject

/**
 * URL注册映射表plist文件说明
 *
 * desc       描述
 * host       URL的host
 * class      跳转的类(__kindof UIViewController)
 * params     参数映射表
 *            {key:value}, key为class的属性名/关联对象名, value为String类型的URL
 *                         参数名并支持透传和直接赋值
 *            (透传userInfo:~, userInfo为AMURL的params+AMURLHandler的userInfo+
 *                             block回调finishHandler, 例如:
 *                             关联对象dict透传userInfo, 则为
 *                             <key>dict</key>
 *                             <string>~</string>)
 *            (直接赋值:~<data>, <data>为需要赋的值, 例如:
 *                              属性age赋值18, 则为
 *                              <key>age</key>
 *                              <string>~18</string>)
 */


+ (void)setup;
+ (instancetype)sharedInstance;

- (void)configSetScheme:(NSString *)scheme;
// 自定义添加的跳转注册（非plist文件管理）
/**
 *  pattern不能包含大写字母
 */
+ (void)customResigtWithRouter:(YDRouter *)router;

+ (void)openURL:(YDURLHelper *)URL;
+ (void)openURL:(YDURLHelper *)URL withUserInfo:(NSDictionary *)userInfo;
+ (void)openURL:(YDURLHelper *)URL withUserInfo:(NSDictionary *)userInfo finish:(void (^)(id result))finishHandler;

- (void)registerURLPattern:(NSString *)URLPattern toHandler:(void (^)(NSDictionary *userInfo))handler;

@property (nonatomic, copy, readonly) NSString *schemeUrl;

@end

@interface UIViewController (YDRouter)

@property (nonatomic, copy) NSString *routerURL;


@end
