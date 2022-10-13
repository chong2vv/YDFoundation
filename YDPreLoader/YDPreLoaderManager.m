//
//  YDPreLoaderManager.m
//  YDPreLoader
//
//  Created by 王远东 on 2022/8/22.
//  Copyright © 2022 10387577. All rights reserved.
//

#import "YDPreLoaderManager.h"
#import <KTVHTTPCache/KTVHTTPCache.h>

@interface YDPreLoaderManager () <KTVHCDataLoaderDelegate>

@property (nonatomic, strong) NSMutableArray<YDPreLoaderModel *> *preloadArr;

@property (nonatomic, assign) double preloadPrecent;

@property (nonatomic, strong) NSMutableArray *preloadStr;

@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, strong) NSMutableDictionary *downloaders;

@property (nonatomic, copy) NSArray *allPreloadList;

@property (nonatomic, weak)id<YDPreLoaderDelegate> delegate;

@end

@implementation YDPreLoaderManager

+ (instancetype)sharedInstance {
    static YDPreLoaderManager *mediator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[[self class] alloc] init];
    });
    return mediator;
}

- (instancetype)init {
    if (self=[super init]) {
        self.preloadPrecent = 1.0;
    }
    return self;
}

+ (void)startProxy {
    NSError *error = [[NSError alloc] init];
    [KTVHTTPCache proxyStart:&error];
    [KTVHTTPCache downloadSetTimeoutInterval:8.0];
}

+ (long long)cacheTotalCacheLength {
    return [KTVHTTPCache cacheTotalCacheLength];
}

+ (void)cacheDeleteAllCaches {
    [KTVHTTPCache cacheDeleteAllCaches];
}

+ (void)preDownLoadData:(NSArray <NSString *> *) preloadArr delegate:( id<YDPreLoaderDelegate>)delegate{
    
    if (delegate) {
        [YDPreLoaderManager sharedInstance].delegate = delegate;
    }
    
    if ([YDPreLoaderManager sharedInstance].preloadStr) {
        [[YDPreLoaderManager sharedInstance].preloadStr removeAllObjects];
    }
    
    if ([YDPreLoaderManager sharedInstance].downloaders) {
        [[YDPreLoaderManager sharedInstance].downloaders removeAllObjects];
    }
    
    if ([YDPreLoaderManager sharedInstance].allPreloadList) {
        [YDPreLoaderManager sharedInstance].allPreloadList = nil;
    }
    
    [YDPreLoaderManager sharedInstance].preloadStr = [NSMutableArray array];
    [YDPreLoaderManager sharedInstance].downloaders = [NSMutableDictionary new];
    [YDPreLoaderManager sharedInstance].allPreloadList = [NSArray arrayWithArray:preloadArr];
    [YDPreLoaderManager sharedInstance].totalCount = preloadArr.count;

    for (NSString *url in preloadArr) {
        [[YDPreLoaderManager sharedInstance].preloadStr addObject:url];
    }
    
    [[YDPreLoaderManager sharedInstance] dc_preDownloadData];
}

- (NSURL *)getProxyURLWithOriginaURL:(NSURL *) originaUrl {
    NSURL * url = [KTVHTTPCache proxyURLWithOriginalURL:originaUrl];
    NSURL *poxURL = [KTVHTTPCache cacheCompleteFileURLWithURL:originaUrl];
    if (poxURL) {
        return poxURL;
    }else{
        return url;
    }
}

// MARK: - Preload
/// 根据传入的模型，预加载上几个，下几个的视频
- (void)dc_preDownloadData
{
    for (NSInteger i = 0; i < self.preloadStr.count; i++)
    {

        NSString *str = [self.preloadStr objectAtIndex:i];
        YDPreLoaderModel *preModel = [self getPreloadModel:str];
//        [preModel.loader prepare];
        if (preModel) {
            [self.preloadArr addObject: preModel];
        }
        
    }
    
    [self processLoader];
}

+ (NSArray<NSString *> *)getAllPreloadList:(NSArray<NSString *> *)preloadArr {
    return [YDPreLoaderManager sharedInstance].allPreloadList;
}

/// 取消所有的预加载
- (void)cancelAllPreload
{
    @synchronized (self.preloadArr) {
        if (self.preloadArr.count == 0)
        {
            return;
        }
        [self.preloadArr enumerateObjectsUsingBlock:^(YDPreLoaderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj.loader close];
        }];
        [self.preloadArr removeAllObjects];
    }
}

- (NSMutableArray<YDPreLoaderModel *> *)preloadArr
{
    if (_preloadArr == nil)
    {
        _preloadArr = [NSMutableArray array];
    }
    return _preloadArr;
}

- (YDPreLoaderModel *)getPreloadModel: (NSString *)urlStr
{
    if (!urlStr)
        return nil;
    // 判断是否已在队列中
    __block Boolean res = NO;
    @synchronized (self.preloadArr) {
        [self.preloadArr enumerateObjectsUsingBlock:^(YDPreLoaderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.url isEqualToString:urlStr])
            {
                res = YES;
                *stop = YES;
            }
        }];
    }
    if (res)
        return nil;
    NSURL *proxyUrl = [KTVHTTPCache proxyURLWithOriginalURL: [NSURL URLWithString:urlStr]];
    KTVHCDataCacheItem *item = [KTVHTTPCache cacheCacheItemWithURL:proxyUrl];
    double cachePrecent = 1.0 * item.cacheLength / item.totalLength;
    // 判断缓存已经超过10%了
//    if (cachePrecent >= self.preloadPrecent)
//        return nil;

//    NSDictionary * headers = KTVHCRangeFillToRequestHeaders(KTVHCMakeRange(0, 1024 * 1024 * 0.1), @{});

    KTVHCDataRequest *req = [[KTVHCDataRequest alloc] initWithURL:proxyUrl headers:nil];
    KTVHCDataLoader *loader = [KTVHTTPCache cacheLoaderWithRequest:req];
    YDPreLoaderModel *preModel = [[YDPreLoaderModel alloc] initWithURL:urlStr loader:loader];
    return preModel;
}

+ (void)cancelAllDownLoad {
    [[YDPreLoaderManager sharedInstance] cancelAllPreload];
}

+ (CGFloat)getCachePrecentWithURL:(NSURL *)originaUrl {
    NSURL *proxyUrl = [KTVHTTPCache proxyURLWithOriginalURL: originaUrl];
    KTVHCDataCacheItem *item = [KTVHTTPCache cacheCacheItemWithURL:proxyUrl];
    if (item.totalLength == 0) {
        return 0;
    }
    CGFloat cachePrecent = 1.0 * item.cacheLength / item.totalLength;
    return cachePrecent;
}

+ (NSURL *)getProxyURLWithOriginaURL:(NSURL *)originaUrl {
    NSURL * url = [KTVHTTPCache proxyURLWithOriginalURL:originaUrl];
    NSURL *poxURL = [KTVHTTPCache cacheCompleteFileURLWithURL:originaUrl];
    if (poxURL) {
        return poxURL;
    }else{
        return url;
    }
}

- (void)processLoader
{
    @synchronized (self.preloadArr) {
        if (self.preloadArr.count == 0)
            return;
        YDPreLoaderModel *model = self.preloadArr.firstObject;
        model.loader.delegate = self;
        [model.loader prepare];
    }
}

/// 根据loader，移除预加载任务
- (void)removePreloadTask: (KTVHCDataLoader *)loader
{
    @synchronized (self.preloadArr) {
        YDPreLoaderModel *target = nil;
        for (YDPreLoaderModel *model in self.preloadArr) {
            if ([model.loader isEqual:loader])
            {
                target = model;
                break;
            }
        }
        if (target)
            [self.preloadArr removeObject:target];
        
        if ([self.delegate respondsToSelector:@selector(ydLoaderDownLoadPercent:)]) {
            CGFloat value = 1.00 * (self.totalCount - self.preloadArr.count)/self.totalCount;
            [self.delegate ydLoaderDownLoadPercent:value];
        }
        if (self.preloadArr.count == 0) {
            if ([self.delegate respondsToSelector:@selector(ydLoaderDownLoadTaskFinish:)]) {
                [self.delegate ydLoaderDownLoadTaskFinish:self.preloadPrecent];
            }
        }
    }
}

+ (void)setPrecentCacheValue:(CGFloat)value {
    [YDPreLoaderManager sharedInstance].preloadPrecent = value;
}

// MARK: - KTVHCDataLoaderDelegate
- (void)ktv_loaderDidFinish:(KTVHCDataLoader *)loader
{
    NSLog(@"ktv_loaderDidFinish");
    if ([self.delegate respondsToSelector:@selector(ydLoaderDidFinish:)]) {
        [self.delegate ydLoaderDidFinish:loader.request.URL];
    }
}

- (void)ktv_loader:(KTVHCDataLoader *)loader didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
    if ([self.delegate respondsToSelector:@selector(ydLoader:didFailWithError:)]) {
        [self.delegate ydLoader:loader.request.URL didFailWithError:error];
    }
    // 若预加载失败的话，就直接移除任务，开始下一个预加载任务
    [self removePreloadTask:loader];
    [self processLoader];
}

- (void)ktv_loader:(KTVHCDataLoader *)loader didChangeProgress:(double)progress
{
    NSLog(@"ktv_loader progress:%f",progress);
    if ([self.delegate respondsToSelector:@selector(ydloader:didChangeProgress:)]) {
        [self.delegate ydloader:loader.request.URL didChangeProgress:progress];
    }
    if (progress >= self.preloadPrecent)
    {
        [loader close];
        [self removePreloadTask:loader];
        [self processLoader];
    }
}

@end
