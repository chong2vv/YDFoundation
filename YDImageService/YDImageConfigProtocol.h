//
//  YDImageConfigProtocol.h
//  YDImageService
//
//  Created by 王远东 on 2022/8/18.
//  Copyright © 2022 wangyuandong. All rights reserved.
//

#ifndef YDImageConfigProtocol_h
#define YDImageConfigProtocol_h

#import <Foundation/Foundation.h>

@protocol YDImageConfigProtocol <NSObject>

/**
  全局的图片加载机制,是否使用后进先出 默认(YES)
 */
- (BOOL)imagePrioritizationLIFO;

/**
  清理缓存周期 默认7天(7 * 24 * 60 * 60)
 */
- (NSTimeInterval)ageLimit;

/**
  磁盘限制大小 默认(100 * 1024 * 1024)
 */
- (NSUInteger)freeDiskSpaceLimit;

/**
 最大并发数(同时下载的图片数,默认是3)
 */
- (NSInteger)maxConcurrentOperationCount;

@end

#endif /* YDImageConfigProtocol_h */
