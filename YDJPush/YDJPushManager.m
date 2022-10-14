//
// Created by 王远东 on 2022/9/1.
//

#import "YDJPushManager.h"
#import "JPUSHService.h"
#import "YDJPushConfig.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface YDJPushManager()<JPUSHRegisterDelegate>

@property (nonatomic, copy)YDMessageInfo messageBlock;
@property (nonatomic, copy)YDMessageInfo notiBlock;
@property (nonatomic, strong)id<YDJPushConfigProtocol> config;

@end

@implementation YDJPushManager
static YDJPushManager *_instance;

+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initWithConfig:[YDJPushConfig new]];
    });
    return _instance;
}

+ (instancetype)shareWithConfig:(id<YDJPushConfigProtocol>)config
{
    [YDJPushManager shared].config = config;
    return [YDJPushManager shared];
}

- (instancetype)initWithConfig:(id<YDJPushConfigProtocol>)config{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
        self.config = config;
    }
    return self;
}


+ (NSInteger)getJPushSeq {
    static NSInteger seq = 0;
    return seq ++;
}

+ (void)resetBadge {
    [JPUSHService resetBadge];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

//收到消息(非APNS)
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSLog(@"message : %@",userInfo);
    if (userInfo[@"extras"]) {
        if (self.messageBlock) {
            self.messageBlock(userInfo);
        }
    }
}

- (void)configJPush:(NSDictionary *)launchOptions didReceiveNotification:(YDMessageInfo)notiBlock didReceiveMessage:(YDMessageInfo)msgBlock{

    self.notiBlock = notiBlock;
    self.messageBlock = msgBlock;

    [JPUSHService setupWithOption:launchOptions appKey:self.config.appKey channel:nil apsForProduction:self.config.isProduction];

    [YDJPushManager registerForRemoteNotificationTypes];

    [self registrationJPushID:nil];
}

- (void)configJPush:(NSDictionary *)launchOptions didRegistSuccess:(void(^)(NSString *registerID))registSuccessBlock didReceiveNotification:(YDMessageInfo)notiBlock didReceiveMessage:(YDMessageInfo)msgBlock {
    self.notiBlock = notiBlock;
    self.messageBlock = msgBlock;

    [JPUSHService setupWithOption:launchOptions appKey:self.config.appKey channel:nil apsForProduction:self.config.isProduction];

    [YDJPushManager registerForRemoteNotificationTypes];

    [self registrationJPushID:registSuccessBlock];
}

- (void)registrationJPushID:(void(^)(NSString * registerID))registSuccessBlock {
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            [self configJPushAlias:self.config.uid];
            NSLog(@"registrationID获取成功：%@",registrationID);
            if (registSuccessBlock) {
                registSuccessBlock(registrationID);
            }
        }
        else{
            if (resCode == 1011) {
                NSLog(@"模拟器 registrationID获取失败，code：%d",resCode);
                return;
            }
            NSLog(@"registrationID获取失败，code：%d",resCode);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self registrationJPushID:registSuccessBlock];
            });
        }
    }];
}

//使用uid
- (void)configJPushAlias:(NSString *)uid{

    NSString *alias = uid.length > 0 ? uid : self.registrationID;

    [[self class] setUserAlias:alias];
    [self setJPUSHUserTag];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginIn:) name:self.config.loginNotificationName object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:self.config.logoutNotificationName object:nil];
}

//登录
- (void)loginIn:(NSNotification *)noti{
    [[self class] setUserAlias:self.config.uid];
    [self setJPUSHUserTag];
}

//登出
- (void)logout:(NSNotification *)noti{
    [[self class] setUserAlias:self.registrationID];
    [self setJPUSHUserTag];
}

- (void)setJPUSHUserTag {
    if (self.config.tags.count) {
        //存在自定义tag
        [JPUSHService setTags:self.config.tags completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
            if (iResCode != 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self setJPUSHUserTag];
                });
            }
        } seq:[[self class] getJPushSeq]];
    }
}

- (NSString *)registrationID
{
    return [JPUSHService registrationID];
}

+ (void)registerDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}

+ (void)registerForRemoteNotificationTypes
{
    //Required
    if (@available(iOS 10.0, *)) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types =
                (UNAuthorizationOptionAlert|
                        UNAuthorizationOptionBadge|
                        UNAuthorizationOptionSound);
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:_instance];
    } else {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge|       UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    }
}

+ (void)setUserAlias:(NSString *)alias{
    [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSLog(@"rescode: %tu, \niAlias: %@, \nseq: %zd\n", iResCode, iAlias , seq);
        if (iResCode == 0) {
            //同步极光别名注册信息
        }else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[self class] setUserAlias:alias];
            });
        }
    } seq:[self getJPushSeq]];
}

+ (void)handleRemoteNotification: (NSDictionary *) userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
}

+ (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}


#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support 在ios10之前如果当前应用在前台 不会弹系统通知 在ios10 以后实现该方法会在应用在前台的时候弹系统通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary *userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    NSLog(@"userInfo : %@",userInfo);
    if (self.messageBlock) {
        self.messageBlock(userInfo);
    }

//    NSInteger pushtype = [[userInfo objectForKey:@"pushtype"] integerValue];

    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置


}

// iOS 10 Support 点通知中心的消息进入应用时 会调用该方法
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSLog(@"userInfo : %@",userInfo);

    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    if (self.messageBlock) {
        self.messageBlock(userInfo);
    }
    if(self.notiBlock) {
        self.notiBlock(userInfo);
    }
    completionHandler(); //系统要求执行这个方法
}

+ (void)checkNotiDeniedStatus:(AuthorizationStatusDenied)deniedBlock{
    if (@available(iOS 10,*)) {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
                //没权限
                if (deniedBlock) deniedBlock();
            }
        }];
    }
    else {
        UIUserNotificationSettings * setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (setting.types == UIUserNotificationTypeNone) {
            //没权限
            if (deniedBlock) deniedBlock();
        }
    }
}

@end