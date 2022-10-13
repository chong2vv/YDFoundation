//
//  YDPreLoaderModel.h
//  YDPreLoader
//
//  Created by 王远东 on 2022/8/22.
//  Copyright © 2022 10387577. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KTVHTTPCache/KTVHTTPCache.h>

NS_ASSUME_NONNULL_BEGIN


@interface YDPreLoaderModel : NSObject

/// 加载的URL
@property (nonatomic, copy, readonly) NSString *url;
/// 请求URL的Loader
@property (nonatomic, strong, readonly) KTVHCDataLoader *loader;

- (instancetype)initWithURL: (NSString *)url loader: (KTVHCDataLoader *)loader;


@end

NS_ASSUME_NONNULL_END
