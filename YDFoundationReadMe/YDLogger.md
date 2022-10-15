
# YDLogger 日志库使用

如果想使用YDLogger日志收集系统，可在本地开启日志（YDAvoidCrash becomeAllEffectiveWithLogger:YES]）后使用：

``` Objective-C
/**
 日志记录宏，只记录到本地，使用方法和NSLog相同，引用当前文件后可直接使用
 根据日志level的不同，记录的日志不同
 当调用setLogLevel:设置需要记录的日志level为YDLogDebug时，那么YDLogDebug等级以下的等级（含YDLogDebug）都会被记录
 默认设置为YDLogDetail
 
 YDLogError()   记录错误信息，适用于线上/线下环境，格式：@"Erro timeStamp error"
 YDLogInfo()    记录极简信息，适用于线上/线下环境，格式：@"Info timeStamp info"
 YDLogDetail()  记录详细信息，适用于线上/线下环境，格式：@"Deta timeStamp [thread] func str"
 YDLogDebug()   记录开发信息，适用于Debug环境，格式：@"Dbug timeStamp str"
 YDLogVerbose() 记录复杂信息，适用于Debug环境，格式：@"Verb timeStamp [thread] func in file:line desc"
 详细使用可参考具体宏定义
 */
```

同时，为了方便快速查看日志，可以用YDLogger自带的YDLoggerUI：

<span id="YDLoggerUI"></span>

## YDLoggerUI

``` Objective-C
 YDLogListViewController *vc = [[YDLogListViewController alloc] init];
 [self.navigationController pushViewController:vc animated:YES];
```
