# ``YDAvoidCrashKit`` 防崩溃库使用

按需安装pod库：

``` cocoapods
pod 'YDFoundation/YDAvoidCrashKit'
```

完整的YDAvoidCrashKit处自身和必要的YDLogger库、YDSafeThread库外还包含了YDLoggerUI库以方便查看日志，使用时引入头文件：

``` Objective-C
#import "YDAvoidCrashKit.h"
```

之后在AppDelegate的didFinishLaunchingWithOptions方法中的最初始位置添加如下代码，让YDAvoidCrash生效

``` Objective-C
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置允许防崩溃类前缀
    [YDAvoidCrash setAvoidCrashEnableMethodPrefixList:@[@"NS",@"YD"]];
    
    //接收异常的回调处理，可以用来上报等
    [YDAvoidCrash setupBlock:^(NSException *exception, NSString *defaultToDo, BOOL upload) {
            
    }];
    //开启全部类拦截，同时开启日志收集（日志默认保存10天，可以在开启前通过[[YDLogService shared] clearLogWithDayTime:5]设置）
    [YDAvoidCrash becomeAllEffectiveWithLogger:YES];
    
    return YES;
}
```

如果不需要YDLoggerUI库查看日志则可选择使用**YDAvoidCrash**库:

``` cocoapods
pod 'YDFoundation/YDAvoidCrash'
```
