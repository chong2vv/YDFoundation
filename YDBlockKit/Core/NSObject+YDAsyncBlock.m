//
//  NSObject+YDAsyncBlock.m
//  YDBlockKit
//
//  Created by 王远东 on 2022/9/9.
//  Copyright © 2022 10387577. All rights reserved.
//

#import "NSObject+YDAsyncBlock.h"
#import <pthread.h>

@interface _YDAsyncBlockMap : NSObject
@property (nonatomic, assign) BOOL isNeedRemove;
@property (nonatomic, copy) void (^execBlock)(void);
@end

static pthread_mutex_t kGlobalAsyncLock;
static NSMutableDictionary* kGlobalExcuteBlockMap;

@implementation NSObject (YDAsyncBlock)
+ (void)yd_asyncBlock:(void (^)(void))block onQueue:(dispatch_queue_t)queue afterSecond:(double)second forKey:(NSString*)key
{
    if (block == nil) {
        return;
    }

    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC));

    ///不可取消
    if (key == nil) {
        dispatch_after(delayTime, queue, block);
        return;
    }

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pthread_mutex_init(&kGlobalAsyncLock, NULL);
        kGlobalExcuteBlockMap = [NSMutableDictionary dictionary];
    });

    _YDAsyncBlockMap* blockMap = [_YDAsyncBlockMap new];
    blockMap.execBlock = block;

    pthread_mutex_lock(&kGlobalAsyncLock);
    _YDAsyncBlockMap* removeObject = [kGlobalExcuteBlockMap objectForKey:key];
    if (removeObject) {
        removeObject.isNeedRemove = YES;
        removeObject.execBlock = nil;
    }
    [kGlobalExcuteBlockMap setObject:blockMap forKey:key];
    pthread_mutex_unlock(&kGlobalAsyncLock);

    __weak _YDAsyncBlockMap* weakBlockMap = blockMap;
    dispatch_after(delayTime, queue, ^{
        void (^doExecBlock)(void) = nil;
        pthread_mutex_lock(&kGlobalAsyncLock);
        if (weakBlockMap && weakBlockMap.isNeedRemove == NO) {
            weakBlockMap.isNeedRemove = YES;
            doExecBlock = weakBlockMap.execBlock;
            [kGlobalExcuteBlockMap removeObjectForKey:key];
        }
        pthread_mutex_unlock(&kGlobalAsyncLock);
        if (doExecBlock) {
            doExecBlock();
        }
    });
}
+ (void)yd_cancelBlockForKey:(NSString*)key
{
    if (key == nil) {
        return;
    }
    pthread_mutex_lock(&kGlobalAsyncLock);
    _YDAsyncBlockMap* blockMap = [kGlobalExcuteBlockMap objectForKey:key];
    if (blockMap) {
        blockMap.isNeedRemove = YES;
        blockMap.execBlock = nil;
        [kGlobalExcuteBlockMap removeObjectForKey:key];
    }
    pthread_mutex_unlock(&kGlobalAsyncLock);
}
+ (BOOL)yd_hasAsyncBlockForKey:(NSString*)key
{
    if (key == nil) {
        return NO;
    }
    pthread_mutex_lock(&kGlobalAsyncLock);
    BOOL hasContain = NO;
    _YDAsyncBlockMap* blockMap = [kGlobalExcuteBlockMap objectForKey:key];
    if (blockMap) {
        hasContain = YES;
    }
    pthread_mutex_unlock(&kGlobalAsyncLock);
    return hasContain;
}
@end

@implementation _YDAsyncBlockMap
+ (NSMutableDictionary*)globalExcuteBlockMap
{
    return kGlobalExcuteBlockMap;
}
+ (pthread_mutex_t)globalAsyncLock
{
    return kGlobalAsyncLock;
}
@end

