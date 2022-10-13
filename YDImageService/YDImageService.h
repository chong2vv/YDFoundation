//
//  YDImageService.h
//  YDImageService
//
//  Created by 王远东 on 2022/8/18.
//  Copyright © 2022 wangyuandong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YDImageConfigProtocol.h"

typedef void(^DownloadCompleted)(UIImage *image,NSError *error);


@interface YDImageService : NSObject

+ (instancetype)shared;

/**
 设置配置项

 @param config 详细见 YDImageConfigProtocol 协议
 */
- (void)resetConfig:(id<YDImageConfigProtocol>)config;

/**
 图片下载

 *  @param aURLString 图片的URL
 *  @param aCompleted 图片下载完成的block
 */
- (void)downloadImageWithURL:(NSString *)aURLString
                   completed:(DownloadCompleted)aCompleted;

/**
 图片下载

 @param aURLString 图片的URL
 @param aProgress 下载进度
 @param aCompleted 图片下载完成的block
 */
- (void)downloadImageWithURL:(NSString *)aURLString
                    progress:(void(^)(CGFloat))aProgress
                   completed:(DownloadCompleted)aCompleted;

/**
 保存到相册 (该方法保存的图片会是实际大小)

 @param aURLString 图片地址
 @param completionBlock 完成的block
 */
- (void)saveImageWithURL:(NSString *)aURLString toAlbumWithCompletionBlock:(void(^)(NSURL *assetURL, NSError *error))completionBlock;

/**
 保存到相册 (该方法保存的图片会是实际大小)

 @param data 图片data
 @param completionBlock 完成的block
 */
- (void)saveImageData:(NSData *)data toAlbumWithCompletionBlock:(void(^)(NSURL *assetURL, NSError *error))completionBlock;

/**
 图片是否缓存
 
 @param aURLString 图片地址
 @return bool 是否存在
 */
- (BOOL)containsImageForURLString:(NSString *)aURLString;

/**
 根据URL获取图片
 
 *  @param aURLString 图片的URL
 *  @return UIImage 图片
 */
- (UIImage *)imageForURLString:(NSString *)aURLString;

/**
 将图片放入缓存

 @param image 图片
 @param aURLString 图片地址(存取的key)
 */
- (void)setImage:(UIImage *)image forImageURLString:(NSString *)aURLString;

/**
 获取图片大小

 @param aURLString 图片地址
 @return fileSize
 */
- (NSString *)fileSizeForURLString:(NSString *)aURLString;

/**
 获取缓存的所有文件的个数和总共大小
 
 @param calculateSizeBlock 计算完成回调
 */
- (void)calculateSizeWithCompletionBlock:(void(^)(NSUInteger fileCount, NSUInteger totalSize))calculateSizeBlock;


/**
 异步清空磁盘

 @param clearBlock 清空完成回调
 */
- (void)clearAllImageDiskOnCompletion:(void(^)(void))clearBlock;


#pragma mark - YDClearCacheProtocol
// 异步清空缓存
- (void)clearDiskOnCompletion:(void(^)(void))clearBlock;

// 磁盘缓存大小
- (CGFloat)diskCacheTotalCost;

@end

