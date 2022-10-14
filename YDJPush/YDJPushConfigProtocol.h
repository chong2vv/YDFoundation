//
// Created by 王远东 on 2022/9/1.
//

#import <Foundation/Foundation.h>

@protocol YDJPushConfigProtocol <NSObject>
/** 极光注册的appkey 需要外部区分scheme */
@property (nonatomic, copy)NSString *appKey;
/** 是否生产环境. 如果为开发状态,设置为 NO; 如果为生产状态,应改为 YES */
@property (nonatomic, assign)BOOL isProduction;

/** 添加的tags 例如:tags = [NSSet setWithObjects:@"VERSION1_2_0",@"VERSION1_4_0", nil]; */
@property (nonatomic, copy)NSSet *tags;
/** 当前登录状态下的uid */
@property (nonatomic, copy)NSString *uid;

/** 登录通知 */
@property (nonatomic, copy)NSString *loginNotificationName;
/** 登出通知 */
@property (nonatomic, copy)NSString *logoutNotificationName;

@end