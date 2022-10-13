//
//  YDImageDefaultConfig.m
//  YDImageService
//
//  Created by 王远东 on 2022/8/18.
//  Copyright © 2022 wangyuandong. All rights reserved.
//

#import "YDImageDefaultConfig.h"

@implementation YDImageDefaultConfig

- (NSTimeInterval)ageLimit {
    return 7 * 24 * 60 * 60;
}

- (NSUInteger)freeDiskSpaceLimit {
    return 100 * 1024 * 1024;
}

- (BOOL)imagePrioritizationLIFO {
    return YES;
}

- (NSInteger)maxConcurrentOperationCount{
    return 3;
}


@end
