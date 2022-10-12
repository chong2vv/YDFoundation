//
//  YDNumberSender.m
//  YDUtilKit
//
//  Created by 王远东 on 2022/8/17.
//

#import "YDNumberSender.h"

@interface YDNumberSender ()

@property (class, nonatomic, assign) NSInteger upNumber;

@end

static NSInteger _upNumber = 0;

@implementation YDNumberSender

+ (NSString *)getSenderNumber {
    
    NSString *numberStr = @"";
    numberStr = [numberStr stringByAppendingFormat:@"%@", [YDNumberSender getNowTimeTimestamp]];
    numberStr = [numberStr stringByAppendingFormat:@"%ld", (long)YDNumberSender.upNumber];
    int randomNumber = (arc4random() % 10);
    numberStr = [numberStr stringByAppendingFormat:@"%ld", (long)randomNumber];
    YDNumberSender.upNumber ++;
    if (YDNumberSender.upNumber == 9) {
        YDNumberSender.upNumber = 0;
    }
    
    return numberStr;
}

+ (NSInteger)upNumber {
    return _upNumber;
}

+ (void)setUpNumber:(NSInteger)upNumber {
    if (upNumber != _upNumber) {
        _upNumber = upNumber;
    }
}

+ (NSString *)getNowTimeTimestamp {
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    return timeString;
}

@end
