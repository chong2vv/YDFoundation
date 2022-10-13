//
//  YDPreLoaderModel.m
//  YDPreLoader
//
//  Created by 王远东 on 2022/8/22.
//  Copyright © 2022 10387577. All rights reserved.
//

#import "YDPreLoaderModel.h"

@implementation YDPreLoaderModel

- (instancetype)initWithURL:(NSString *)url loader:(KTVHCDataLoader *)loader {
    if (self = [super init])
    {
        _url = url;
        _loader = loader;
    }
    return self;
}

@end
