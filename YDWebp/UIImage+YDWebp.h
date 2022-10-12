//
//  UIImage+YDWebp.h
//  YDWebp
//
//  Created by 王远东 on 2022/8/22.
//  Copyright © 2022 wangyuandong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <libwebp/decode.h>
#import <libwebp/encode.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (YDWebp)

+ (UIImage*)imageWithWebPData:(NSData*)imgData;

+ (UIImage*)imageWithWebP:(NSString*)filePath;

+ (NSData*)imageToWebP:(UIImage*)image compressionQuality:(CGFloat)quality;

+ (void)imageToWebP:(UIImage*)image
 compressionQuality:(CGFloat)quality
              alpha:(CGFloat)alpha
             preset:(WebPPreset)preset
    completionBlock:(void (^)(NSData* result))completionBlock
       failureBlock:(void (^)(NSError* error))failureBlock;

+ (void)imageToWebP:(UIImage*)image
 compressionQuality:(CGFloat)quality
              alpha:(CGFloat)alpha
             preset:(WebPPreset)preset
        configBlock:(void (^)(WebPConfig* config))configBlock
    completionBlock:(void (^)(NSData* result))completionBlock
       failureBlock:(void (^)(NSError* error))failureBlock;

+ (void)imageWithWebP:(NSString*)filePath
      completionBlock:(void (^)(UIImage* result))completionBlock
         failureBlock:(void (^)(NSError* error))failureBlock;

- (UIImage*)imageByApplyingAlpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
