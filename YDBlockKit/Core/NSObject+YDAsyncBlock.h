//
//  NSObject+YDAsyncBlock.h
//  YDBlockKit
//
//  Created by 王远东 on 2022/9/9.
//  Copyright © 2022 10387577. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (YDAsyncBlock)

+ (void)yd_asyncBlock:(void (^)(void))block onQueue:(dispatch_queue_t)queue afterSecond:(double)second forKey:(NSString*)key;

+ (void)yd_cancelBlockForKey:(NSString*)key;

+ (BOOL)yd_hasAsyncBlockForKey:(NSString*)key;
@end

NS_ASSUME_NONNULL_END
