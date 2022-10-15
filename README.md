# ``YDFoundation``

> `写在前面的话`
> YDFoundation

## YDFoundation 组件库介绍

YDFoundation 主要由以下组件库组成：

### 线程组件

- YDSafeThread
- YDTimer

### 日志组件

- [YDLogger](YDFoundationReadMe/YDLogger.md)
- [YDLoggerUI](YDFoundationReadMe/YDLogger.md#YDLoggerUI)
  -[YDLogger](YDFoundationReadMe/YDLogger.md)

### 防崩溃组件

- [YDAvoidCrashKit](YDFoundationReadMe/YDAvoidCrash.md)
  - [YDAvoidCrash](YDFoundationReadMe/YDAvoidCrash.md)
  - [YDSafeThread](YDFoundationReadMe/YDSafeThread.md)
  - [YDLogger](YDFoundationReadMe/YDLogger.md)
  - [YDLoggerUI](YDFoundationReadMe/YDLogger.md#YDLoggerUI)

### 基本工具组件

- [YDUtilKit](YDFoundationReadMe/YDUtilKit.md)
  - [YDFuncKit](YDFoundationReadMe/YDFuncKit.md)
  - [YDBaseUI](YDFoundationReadMe/YDBaseUI.md)
  - [YDUIKit](YDFoundationReadMe/YDUIKit.md)
  - [YDTools](YDFoundationReadMe/YDTools.md)
- [YDImageService](YDFoundationReadMe/YDImageService.md)
- [YDNetworkManager](YDFoundationReadMe/YDNetworkManager.md)
- [YDJPush](YDFoundationReadMe/YDJPush.md)
- [YDBlockKit](YDFoundationReadMe/YDBlockKit.md)
- [YDAuthorizationUtil](YDFoundationReadMe/YDAuthorizationUtil.md)
- [YDEmptyView](YDFoundationReadMe/YDEmptyView.md)
- [YDPreLoader](YDFoundationReadMe/YDPreLoader.md)
- [YDSVProgressHUD](YDFoundationReadMe/YDSVProgressHUD.md)
- [YDFileManager](YDFoundationReadMe/YDFileManager.md)
- [YDMonitor](YDFoundationReadMe/YDMonitor.md)
- [YDAlertAction](YDFoundationReadMe/YDAlertAction.md)
- [YDMediato](YDFoundationReadMe/YDMediator.md)
- [YDClearCacheService](YDFoundationReadMe/YDClearCacheService.md)
- [YDRouter](YDFoundationReadMe/YDRouter.md)
- [YDWebp](YDFoundationReadMe/YDWebp.md)

相较于原库，YDAvoidCrash新增了以下功能及优化：

## 安装及使用方式

### 使用CocoaPods导入

使用时可以全量导入

``` cocoapods
pod 'YDFoundation'
```

也可以按需导入避免冗余组件过多，例如：

``` cocoapods
pod 'YDFoundation/YDSafeThread'
```

## 更新

#### v0.1.2

1. 新增YDTimer计时器

## 写在最后的话

一个人的精力是有限的，如果您在YDFoundation组件使用过程中发现BUG或者有更好的解决方法欢迎你能issue，我将万分感谢！
