Pod::Spec.new do |s|
  s.name             = 'YDFoundation'
  s.version          = '0.1.5'
  s.platform         = :ios, "9.0"
  s.summary          = 'A short description of YDFoundation.'


  s.description      = <<-DESC
  YDFoundation 组件库
                       DESC

  s.homepage         = 'https://github.com/chong2vv/YDFoundation'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wangyuandong' => 'chong2vv@163.com' }
  s.source           = { :git => 'https://github.com/chong2vv/YDFoundation.git', :tag => s.version.to_s }
  s.frameworks = 'UIKit', 'Foundation', 'CoreGraphics'
  s.xcconfig = {
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
    'HEADER_SEARCH_PATHS'   => '$(SDKROOT)/usr/include/libxml2',
    'OTHER_LDFLAGS'         => '-ObjC -lxml2'
  }

  # 基础组件， 其他组件库的内部组件、也可以单独使用
  #YDUtilKit
  _YDFuncKit         = { :spec_name => "YDFuncKit", :source_files => ['YDFuncKit/**/*.{h,m}'] }
  _YDBaseUI          = { :spec_name => "YDBaseUI", :source_files => ['YDBaseUI/**/*.{h,m}'] }
  _YDUIKit           = { :spec_name => "YDUIKit", :source_files => ['YDUIKit/**/*.{h,m}'], :sub_dependency => [_YDFuncKit, _YDBaseUI] }
  _YDTools           = { :spec_name => "YDTools", :source_files => ['YDTools/**/*.{h,m}'], :sub_dependency => [_YDFuncKit] }

  #YDAvoidCrashKit
  _YDSafeThread      = { :spec_name => "YDSafeThread", :source_files => ['YDSafeThread/**/*.{h,m}'] }
  _YDLogger          = { :spec_name => "YDLogger", :source_files => ['YDLogger/**/*.{h,m,mm,cpp}'], :libraries => 'c++' }
  _YDAvoidCrash      = { :spec_name => "YDAvoidCrash", :source_files => ['YDAvoidCrash/**/*.{h,m}'], :sub_dependency => [_YDSafeThread, _YDLogger] }
  # YDLoggerUI
  _YDLoggerUI        = { :spec_name => "YDLoggerUI", :source_files => ['YDLoggerUI/**/*.{h,m}'], :sub_dependency => [_YDLogger] }

  #YDAlertAction
  _YDActionAlert     = { :spec_name => "YDActionAlert", :source_files => ['YDActionAlert/**/*.{h,m}'] }
  _YDActionSheet     = { :spec_name => "YDActionSheet", :source_files => ['YDActionSheet/**/*.{h,m}'], :dependency => [{:name => "Masonry", :version => "1.1.0"}] }

  
  # Foundation Components
  # YDRouter
  _YDRouter          = { :spec_name => "YDRouter", :source_files => ['YDRouter/**/*.{h,m}'] }

  _YDClearCacheService = { :spec_name => "YDClearCacheService", :source_files => ['YDClearCacheService/**/*.{h,m}'] }

  # YDMediato
  _YDMediator        = { :spec_name => "YDMediator", :source_files => ['YDMediator/**/*.{h,m}'], :sub_dependency => [_YDClearCacheService, _YDSafeThread] }

  # YDWebp
  _YDWebp            = { :spec_name => "YDWebp", :source_files => ['YDWebp/**/*.{h,m}'], :dependency => [{:name => "libwebp", :version => "1.2.3"}] }

  # YDUtilKit
  _YDUtilKit         = { :spec_name => "YDUtilKit", :dependency => [{:name => "AFNetworking", :version => "4.0.1"}], :sub_dependency => [_YDFuncKit, _YDBaseUI, _YDUIKit, _YDTools] }

  # YDAvoidCrashKit
  _YDAvoidCrashKit   = { :spec_name => "YDAvoidCrashKit", :sub_dependency => [_YDAvoidCrash, _YDLogger, _YDSafeThread, _YDLoggerUI] }

  # YDAlertAction
  _YDAlertAction     = { :spec_name => "YDAvoidCrashKit", :dependency => [{:name => "Masonry", :version => "1.1.0"}], :sub_dependency => [_YDActionAlert, _YDActionSheet] }


  # YDMonitor
  _YDMonitor         = { :spec_name => "YDMonitor", :source_files => ['YDMonitor/**/*.{h,m}'], :sub_dependency => [_YDLogger] }

  # YDTimer
  _YDTimer           = { :spec_name => "YDTimer", :source_files => ['YDTimer/**/*.{h,m}'], :sub_dependency => [_YDSafeThread] }

  # YDFileManager
  _YDFileManager     = { :spec_name => "YDFileManager", :source_files => ['YDFileManager/**/*.{h,m}'] }

  # YDSVProgressHUD
  _YDSVProgressHUD   = { :spec_name => "YDSVProgressHUD", :source_files => ['YDSVProgressHUD/**/*.{h,m}'], :resource_bundles => {:bundle => "YDSVProgressHUD", :resources => "YDSVProgressHUD/Assets/*"}, :dependency => [{:name => "lottie-ios", :version => "2.5.3"}, {:name => "SVProgressHUD", :version => "2.2.5"}, {:name => "YYImage", :version => "1.0.4"}] }

  # YDPreLoader
  _YDPreLoader       = { :spec_name => "YDPreLoader", :source_files => ['YDPreLoader/**/*.{h,m}'], :dependency => [{:name => "KTVHTTPCache", :version => "2.0.1"}] }

  # YDImageService
  _YDImageService    = { :spec_name => "YDImageService", :source_files => ['YDImageService/**/*.{h,m}'], :dependency => [{:name => "YYImage", :version => "1.0.4"}, {:name => "YYWebImage", :version => "1.0.5"}], :sub_dependency => [_YDSafeThread] }

  # YDEmptyView
  _YDEmptyView       = { :spec_name => "YDEmptyView", :source_files => ['YDEmptyView/**/*.{h,m}'], :dependency => [{:name => "Masonry", :version => "1.1.0"}] }

  # YDBlockKit
  _YDBlockKit        = { :spec_name => "YDBlockKit", :source_files => ['YDBlockKit/**/*.{h,m}'] }

  # YDAuthorizationUtil
  _YDAuthorizationUtil = { :spec_name => "YDAuthorizationUtil", :source_files => ['YDAuthorizationUtil/**/*.{h,m}'] }

  # YDJPush
  _YDJPush = { :spec_name => "YDJPush", :source_files => ['YDJPush/**/*.{h,m}'], :dependency => [{:name => "JPush", :version => "3.2.4"}] }

  # YDNetworkManager
  _YDNetworkManager = { :spec_name => "YDNetworkManager", :source_files => ['YDNetworkManager/**/*.{h,m}'], :dependency => [{:name => "YTKNetwork", :version => "3.0.6"}] }

  all_subspec = [ _YDRouter, _YDWebp, _YDUtilKit, _YDFuncKit, _YDBaseUI, _YDUIKit, _YDTools, _YDSVProgressHUD, _YDAvoidCrashKit, _YDSafeThread, _YDLogger, _YDLoggerUI, _YDAvoidCrash, _YDMonitor, _YDTimer, _YDAlertAction, _YDActionSheet, _YDActionAlert, _YDFileManager,
                 _YDPreLoader, _YDMediator, _YDClearCacheService, _YDImageService, _YDEmptyView, _YDBlockKit, _YDAuthorizationUtil, _YDJPush, _YDNetworkManager ]
 

  all_subspec.each do |spec|

    s.subspec spec[:spec_name] do |ss|

      specname = spec[:spec_name]

      if spec[:ios_deployment_target]
        ss.ios.deployment_target = spec[:ios_deployment_target]
      end

      if spec[:source_files]
        ss.source_files = spec[:source_files]
      end

      if spec[:libraries]
        ss.libraries = spec[:libraries]
      end

      if spec[:sub_dependency]
        spec[:sub_dependency].each do |dep|
          ss.dependency "YDFoundation/#{dep[:spec_name]}"
        end
      end

      if spec[:dependency]
        spec[:dependency].each do |dep|
          ss.dependency dep[:name], dep[:version]
        end
      end

      if spec[:resource_bundles]
          ss.resource_bundles = {spec[:resource_bundles][:bundle] => spec[:resource_bundles][:resources]}
      end

      if spec[:pod_target_xcconfig]
        ss.pod_target_xcconfig = spec[:pod_target_xcconfig]
      end

      if spec[:user_target_xcconfig]
        ss.user_target_xcconfig = spec[:user_target_xcconfig]
      end

      if spec[:vendored_frameworks]
        ss.vendored_frameworks = spec[:vendored_frameworks]
      end

    end
  end
end
