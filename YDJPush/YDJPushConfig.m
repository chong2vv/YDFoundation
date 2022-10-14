//
//  YDJPushConfig.m
//  YDJPush
//
//  Created by 王远东 on 2022/9/1.
//  Copyright © 2022 wangyuandong. All rights reserved.
//

#import "YDJPushConfig.h"

@implementation YDJPushConfig
@synthesize appKey                 = _appKey;
@synthesize isProduction           = _isProduction;
@synthesize uid                    = _uid;
@synthesize tags                   = _tags;
@synthesize loginNotificationName  = _loginNotificationName;
@synthesize logoutNotificationName = _logoutNotificationName;

- (instancetype)init {
    if (self = [super init]){
        [self configParams];
    }
    return self;
}

- (void)configParams {

}

@end
