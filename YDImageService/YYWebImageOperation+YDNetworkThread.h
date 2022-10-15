//
//  YYWebImageOperation+YDNetworkThread.h
//  YDImageService
//
//  Created by 王远东 on 2022/8/18.
//  Copyright © 2022 wangyuandong. All rights reserved.
//

#import <YYWebImage/YYWebImageOperation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYWebImageOperation (YDNetworkThread)

+ (NSThread *)networkThread;

@end

NS_ASSUME_NONNULL_END
