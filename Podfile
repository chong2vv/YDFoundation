
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

abstract_target 'Demo' do
  
  target 'YDFoundationDemo' do
    pod 'YDFoundation', :path => '.'
  end
  
  target 'YDFoundationSDK' do
    pod 'lottie-ios', '~> 2.5.3'
    pod 'SVProgressHUD', '~> 2.2.5'
    pod 'AFNetworking', '~> 4.0.1'
    pod 'YYImage', '~> 1.0.4'
    pod 'libwebp', '~> 1.2.3'
    pod 'KTVHTTPCache', '~> 2.0.1'
    pod 'JPush' , '~> 3.2.4'
    pod 'YYWebImage', '~> 1.0.5'
    pod 'Masonry', '~> 1.1.0'
    pod 'YTKNetwork', '~> 3.0.6'
  end
  
  target 'YDRouter' do
    
  end
  
  target 'YDUtilKit' do
    pod 'AFNetworking', '~> 4.0.1'
  end
  
  target 'YDAvoidCrashKit' do
    
  end
  
  target 'YDTimer' do
    pod 'YDFoundation/YDSafeThread', :path => '.'
  end
  
  target 'YDSVProgressHUD' do
    pod 'lottie-ios', '~> 2.5.3'
    pod 'SVProgressHUD', '~> 2.2.5'
    pod 'YYImage', '~> 1.0.4'
  end
  
  target 'YDAlertAction' do
    pod 'Masonry', '~> 1.1.0'
  end
  
  target 'YDFileManager' do
    
  end
  
  target 'YDPreLoader' do
    pod 'KTVHTTPCache', '~> 2.0.1'
  end
  
  target 'YDMediator' do
    
  end
  
  target 'YDClearCacheService' do
    
  end
  
  target 'YDEmptyView' do
    pod 'Masonry', '~> 1.1.0'
  end

  target 'YDBlockKit' do
  
  end
  
  target 'YDAuthorizationUtil' do
  
  end
  
  target 'YDJPush' do
    pod 'JPush' , '~> 3.2.4'
  end
  
  target 'YDImageService' do
    pod 'YYWebImage', '~> 1.0.5'
    pod 'YYImage', '~> 1.0.4'
    pod 'YDFoundation/YDSafeThread', :path => '.'
  end
  
  target 'YDNetworkManager' do
    pod 'YTKNetwork', '~> 3.0.6'
  end

end


post_install do |installer|
  shell_path = "#{Dir.pwd}/hook_pod.sh"
  system("sh #{shell_path}")
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CLANG_ENABLE_OBJC_WEAK'] ||= 'NO'
      config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = ""
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
      config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
      config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
       # Compiling for iOS 9.0, but module 'xxx' has a minimum deployment target of iOS 10.0
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < VERSION.to_f
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = VERSION
      end
       # Include of non-modular header inside framework module
       config.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'
      if config.name.include?("Debug")
        config.build_settings['ONLY_ACTIVE_ARCH'] ||= 'YES'
        else
        config.build_settings['ONLY_ACTIVE_ARCH'] ||= 'NO'
      end
    end
  end
end
