//
//  YDImageService.m
//  YDImageService
//
//  Created by 王远东 on 2022/8/18.
//  Copyright © 2022 wangyuandong. All rights reserved.
//

#import "YDImageService.h"
#import "YDImageConfigProtocol.h"
#import "YDImageDefaultConfig.h"
#import <YYWebImage/YYWebImage.h>
#import <pthread.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CommonCrypto/CommonDigest.h>
#import "YDWebImageManager.h"

@interface YDImageService ()

@property (nonatomic, strong)id<YDImageConfigProtocol> config;

@end

@implementation YDImageService

+ (instancetype)shared{
    static dispatch_once_t onceToken;
    static id manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

- (instancetype)init{
    if (self = [super init]) {
        if (!self.config) {
            self.config = [YDImageDefaultConfig new];
        }
        [self configYYImage];
    }
    return self;
}

- (void)resetConfig:(id <YDImageConfigProtocol>)config{
    if (config) {
        self.config = config;
    }
}

//配置YYImage
- (void)configYYImage {
    [self configImageCacheKey];
    YDWebImageManager *manager = [YDWebImageManager sharedManager];
    // 将 queue 清空，内部修改了代码使用数组维护了 一个后进先出
    if (self.config.imagePrioritizationLIFO) {
        manager.queue = nil;
        manager.maxConcurrent = self.config.maxConcurrentOperationCount;
    }else {
        // 使用系统的 NSOperationQueue 将最大线程数设置为 5
        manager.queue.maxConcurrentOperationCount = 5;
    }
    [self configImageCache];
}

// 缓存清理设置
- (void)configImageCache {
    YYImageCache *cache = [YDWebImageManager sharedManager].cache;
    cache.diskCache.ageLimit = self.config.ageLimit;
    cache.diskCache.freeDiskSpaceLimit = self.config.freeDiskSpaceLimit;
    cache.diskCache.costLimit = NSUIntegerMax;
    cache.diskCache.countLimit = NSUIntegerMax;
}

//设置图片缓存的key为图片地址的URL进行MD5
- (void)configImageCacheKey
{
    YDWebImageManager *manager = [YDWebImageManager sharedManager];
    manager.cacheKeyFilter = ^ NSString *(NSURL *url){
        return [self _stringToMD5String:url.absoluteString];
    };
}

//YY 默认是用URL.absoluteString作为缓存的标志
- (BOOL)containsImageForURLString:(NSString *)aURLString {
    if (aURLString.length <= 0) return NO;
    aURLString = [self convertURLString:aURLString];
    YYImageCache *cache = [YDWebImageManager sharedManager].cache;
    return [cache containsImageForKey:[self _stringToMD5String:aURLString]];
}

- (UIImage *)imageForURLString:(NSString *)aURLString{
    aURLString = [aURLString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (aURLString.length <= 0) {return nil;}
    aURLString = [self convertURLString:aURLString];
    YYImageCache *cache = [YDWebImageManager sharedManager].cache;
    return [cache getImageForKey:[self _stringToMD5String:aURLString]];
}

- (void)setImage:(UIImage *)image forImageURLString:(NSString *)aURLString{
    NSAssert(image, @"图片不能为空");
    aURLString = [self convertURLString:aURLString];
    YYImageCache *cache = [YDWebImageManager sharedManager].cache;
    [cache setImage:image forKey:[self _stringToMD5String:aURLString]];
}

//图片下载
- (void)downloadImageWithURL:(NSString *)aURLString
                   completed:(DownloadCompleted)aCompleted;
{
    [self downloadImageWithURL:aURLString progress:nil completed:aCompleted];
}

- (void)downloadImageWithURL:(NSString *)aURLString
                    progress:(void(^)(CGFloat))aProgress
                   completed:(DownloadCompleted)aCompleted;
{
#pragma mark - 每次清理下缓存保证不会因AFN缓存出现致命问题
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    if (aURLString.length == 0) {
        NSError *error = [NSError errorWithDomain:@"链接不能为空" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"链接不能为空"}];
        if (aCompleted) {
            aCompleted(nil,error);
        }
        return;
    }
    aURLString = [self convertURLString:aURLString];
    
    // YYWebImageOptionIgnoreAnimatedImage |  YYWebImageOptionIgnoreImageDecoding
    YYWebImageProgressBlock progress = nil;
    if (aProgress) {
        progress = ^(NSInteger receivedSize, NSInteger expectedSize){
            dispatch_async(dispatch_get_main_queue(), ^{
                aProgress(receivedSize / (CGFloat)expectedSize);
            });
        };
    }
    
    [[YDWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:aURLString] options:YYWebImageOptionIgnoreImageDecoding | YYWebImageOptionAllowBackgroundTask | YYWebImageOptionShowNetworkActivity progress:progress transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (stage != YYWebImageStageFinished) return;//未完成
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error != nil) {
                if (aCompleted) {
                    aCompleted(nil,error);
                }
                return;
            }
            if (aCompleted) {
                aCompleted(image,nil);
            }
        });
    }];
}

//获取相册授权信息
+ (void)photoAuthorizeWithCompletion:(void(^)(BOOL authorized))completion
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusAuthorized:
        {
            if (completion) {
                completion(YES);
            }
        }
            break;
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:
        {
            if (completion) {
                completion(NO);
            }
        }
            break;
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(status == PHAuthorizationStatusAuthorized);
                    });
                }
            }];
        }
            break;
        default:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(NO);
                }
            });
        }
            break;
    }
}

// 下载保存到 相册
- (void)saveImageWithURL:(NSString *)aURLString toAlbumWithCompletionBlock:(void(^)(NSURL *assetURL, NSError *error))completionBlock {
    __block NSString *urlString = aURLString;
    [YDImageService photoAuthorizeWithCompletion:^(BOOL authorized) {
        __weak __typeof(&*self)weakSelf = self;
        if (authorized) {
            urlString = [self convertURLString:urlString];
            NSString *urlMD5 = [self _stringToMD5String:aURLString];
            YYImageCache *cache = [YDWebImageManager sharedManager].cache;
            [cache getImageDataForKey:urlMD5 withBlock:^(NSData * _Nullable imageData) {
                if (imageData) {
                    [weakSelf saveImageData:imageData toAlbumWithCompletionBlock:completionBlock];
                    return;
                }
                [weakSelf downloadImageWithURL:aURLString completed:^(UIImage *image, NSError *aError) {
                    NSData *imageData = [cache getImageDataForKey:urlMD5];
                    if (imageData) {
                        [weakSelf saveImageData:imageData toAlbumWithCompletionBlock:completionBlock];
                        return;
                    }
                    [self _saveImage:image toAlbumWithCompletionBlock:^(BOOL success, NSError *error) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                             if (completionBlock) completionBlock(nil,error);
                        });
                    }];
                }];
            }];
        } else {
            NSError *error = [NSError errorWithDomain:@"com.yd.app" code:-1000 userInfo:@{NSLocalizedDescriptionKey:@"相册权限不被允许"}];
            completionBlock(nil,error);
        }
    }];
}

- (void)_saveImage:(UIImage *)image toAlbumWithCompletionBlock:(void (^)(BOOL success, NSError *error))completionBlock{
    //异步保存
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } completionHandler:completionBlock];
}

- (void)saveImageData:(NSData *)data toAlbumWithCompletionBlock:(void(^)(NSURL *assetURL, NSError *error))completionBlock {
    [self _saveImage:[UIImage imageWithData:data] toAlbumWithCompletionBlock:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"保存成功");
        }else{
            NSLog(@"保存失败");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) completionBlock(nil,error);
        });
    }];
}

- (NSString *)convertURLString:(NSString *)aURLString {
    aURLString = [aURLString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // 不要使用 stringByAddingPercentEscapesUsingEncoding 会对部分字符串做处理
    NSString *charactersToEscape = @"";//@"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodedUrl = [aURLString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return encodedUrl;
}

#pragma mark - 缓存相关

- (NSString *)fileSizeForURLString:(NSString *)aURLString
{
    if (aURLString.length > 0 && [[YDImageService shared] containsImageForURLString:aURLString]) {
        UIImage *image = [[YDImageService shared] imageForURLString:aURLString];
//        NSUInteger size = [image imageCost];
        NSUInteger size = [self imageCost:image];
        return [self fileSizeString:size];
    }
    NSLog(@"图片未下载无法获取图片大小");
    return @"0";
}

- (NSUInteger)imageCost:(UIImage *)image {
    CGImageRef cgImage = image.CGImage;
    if (!cgImage) return 1;
    CGFloat height = CGImageGetHeight(cgImage);
    size_t bytesPerRow = CGImageGetBytesPerRow(cgImage);
    NSUInteger cost = bytesPerRow * height;
    if (cost == 0) cost = 1;
    return cost;
}

- (void)calculateSizeWithCompletionBlock:(void (^)(NSUInteger, NSUInteger))calculateSizeBlock
{
    YYImageCache *cache = [YDWebImageManager sharedManager].cache;
    // 数量以及成本
    if (calculateSizeBlock) {
        calculateSizeBlock(cache.memoryCache.totalCount + cache.diskCache.totalCount,cache.memoryCache.totalCost + cache.diskCache.totalCost);
    }
}

// 异步清空所有
- (void)clearAllImageDiskOnCompletion:(void(^)(void))clearBlock {
    // 缓存清理设置
    YYImageCache *cache = [YDWebImageManager sharedManager].cache;
    cache.diskCache.ageLimit = 1.;
    cache.diskCache.freeDiskSpaceLimit = 0.;
    cache.diskCache.costLimit = 1.;
    cache.diskCache.countLimit = 1.;
    
    [cache.diskCache removeAllObjectsWithProgressBlock:^(int removedCount, int totalCount) {
        //
    } endBlock:^(BOOL error) {
        [self configImageCache];
        if (clearBlock) {
            clearBlock();
        }
    }];
}

- (void)clearDiskOnCompletion:(void (^)(void))clearBlock
{
    YYImageCache *cache = [YDWebImageManager sharedManager].cache;
    [cache.diskCache removeAllObjectsWithProgressBlock:^(int removedCount, int totalCount) {
        
    } endBlock:^(BOOL error) {
        if (clearBlock) {
            clearBlock();
        }
    }];
}

- (CGFloat)diskCacheTotalCost{
    return [YDWebImageManager sharedManager].cache.diskCache.totalCost;
}

- (NSString *)fileSizeString:(NSUInteger)btye {
    CGFloat kb = btye / 1024.;
    if (kb < 1024) {
        return [NSString stringWithFormat:@"%.2f KB",kb];
    }
    CGFloat mb = kb / 1024.;
    return [NSString stringWithFormat:@"%.2f MB",mb];;
}

//string进行MD5
- (NSString *)_stringToMD5String:(NSString *)string
{
    if([string length] == 0)
        return nil;
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++) {
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return [NSString stringWithString:outputString];
}
@end
