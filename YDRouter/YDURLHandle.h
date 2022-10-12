//
//  YDURLHandle.h
//  YDRouter
//
//  Created by 王远东 on 2022/8/18.
//  Copyright © 2022 wangyuandong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define THEYDURLHandler [YDURLHandle sharedManager]


@interface YDURLHandle : NSObject

+ (instancetype)sharedManager;

- (BOOL)handleURLStr:(NSString *)urlStr;

- (BOOL)handleURLStr:(NSString *)urlStr finish:(void (^)(id result))finishHandler;

- (BOOL)handleURLStr:(NSString *)urlStr userInfo:(NSDictionary *)userInfo;

- (BOOL)handleURLStr:(NSString *)urlStr userInfo:(NSDictionary *)userInfo finish:(void (^)(id result))finishHandler;

- (BOOL)handleWebURLStr:(NSString *)urlStr;


@end

