//
// Created by 王远东 on 2022/9/1.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YDJPushConfigProtocol.h"

typedef void (^AuthorizationStatusDenied)(void);
typedef void (^YDMessageInfo)(NSDictionary* userInfo);

@interface YDJPushManager : NSObject
@property (nonatomic, copy, readonly)NSString *registrationID;

/**
 单例初始化(推荐)

 @return YDJPushManager
 */
+ (instancetype)shared;

/**
 单例初始化

 @param config 配置项
 @return JPushManager
 */
+ (instancetype)shareWithConfig:(id<YDJPushConfigProtocol>)config;


/**
 启动SDK

 @param launchOptions 启动参数
 @param notiBlock apns消息回调
 @param msgBlock 极光消息回调
 */
- (void)configJPush:(NSDictionary *)launchOptions didReceiveNotification:(YDMessageInfo)notiBlock didReceiveMessage:(YDMessageInfo)msgBlock;


/// 启动SDK
/// @param launchOptions 启动参数
/// @param registSuccessBlock 极光注册成功回调register id
/// @param notiBlock apns消息回调
/// @param msgBlock 极光消息回调
- (void)configJPush:(NSDictionary *)launchOptions didRegistSuccess:(void(^)(NSString *registerID))registSuccessBlock didReceiveNotification:(YDMessageInfo)notiBlock didReceiveMessage:(YDMessageInfo)msgBlock;

+ (void)registerForRemoteNotificationTypes;
+ (void)registerDeviceToken:(NSData *)deviceToken;
+ (void)setUserAlias:(NSString *)alias;
+ (void)handleRemoteNotification:(NSDictionary *)userInfo;
+ (void)resetBadge;

/**
 通知权限判断

 @param deniedBlock 无权限回调
 */
+ (void)checkNotiDeniedStatus:(AuthorizationStatusDenied)deniedBlock;
@end
