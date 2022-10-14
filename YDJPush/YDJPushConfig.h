//
//  YDJPushConfig.h
//  YDJPush
//
//  Created by 王远东 on 2022/9/1.
//  Copyright © 2022 wangyuandong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDJPushConfigProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface YDJPushConfig : NSObject<YDJPushConfigProtocol>

- (void)configParams;
@end

NS_ASSUME_NONNULL_END
