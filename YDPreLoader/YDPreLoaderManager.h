//
//  YDPreLoaderManager.h
//  YDPreLoader
//
//  Created by 王远东 on 2022/8/22.
//  Copyright © 2022 10387577. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDPreLoaderModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YDPreLoaderDelegate <NSObject>

//下载失败
- (void)ydLoader:(NSURL *)loadUrl didFailWithError:(NSError *)error;
//下载完成，返回URL
- (void)ydLoaderDidFinish:(NSURL *)loadUrl;
// 进度回调
- (void)ydloader:(NSURL *)loadUrl didChangeProgress:(double)progress;
//本轮下载完成
- (void)ydLoaderDownLoadTaskFinish:(CGFloat )value;
//当前完成任务百分比回调
- (void)ydLoaderDownLoadPercent:(CGFloat) Percent;
@end

@interface YDPreLoaderManager : NSObject

//开启本地代理
+ (void)startProxy;

//设置下载百分比
+ (void)setPrecentCacheValue:(CGFloat) value;

//预下载
+ (void)preDownLoadData:(NSArray <NSString *> *) preloadArr delegate:(id<YDPreLoaderDelegate>) delegate;

//取消所有下载任务
+ (void)cancelAllDownLoad;

//清除本地所有缓存
+ (void)cacheDeleteAllCaches;

//获取本地缓存大小
+ (long long)cacheTotalCacheLength;

//获取本地ProxyService预下载后的URL
+ (NSURL *)getProxyURLWithOriginaURL:(NSURL *) originaUrl;

//获取当前url本地缓存百分比
+ (CGFloat)getCachePrecentWithURL:(NSURL *) originaUrl;

//获取当前全部预下载URL的列表
+ (NSArray <NSString *>*)getAllPreloadList:(NSArray <NSString *> *)preloadArr;


@end

NS_ASSUME_NONNULL_END
