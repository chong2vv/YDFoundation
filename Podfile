
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

abstract_target 'Demo' do
  
  target 'YDFoundationDemo' do
    pod 'YDFoundation', :path => '.'
  end
  
  target 'YDFoundationSDK' do
    
  end
  
  target 'YDRouter' do
    
  end
  
  target 'YDWebp' do
    pod 'libwebp', '~> 1.2.3'
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
  
  target 'YDSafeThread' do
    
  end
  
  target 'YDEmptyView' do
    
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
  
  target 'YDNetwrokManager' do
    pod 'YTKNetwork', '~> 3.0.6'
  end

end


post_install do |installer|
  shell_path = "#{Dir.pwd}/hook_pod.sh"
  system("sh #{shell_path}")
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CLANG_ENABLE_OBJC_WEAK'] ||= 'NO'
      if config.name.include?("Debug")
        config.build_settings['ONLY_ACTIVE_ARCH'] ||= 'YES'
        else
        config.build_settings['ONLY_ACTIVE_ARCH'] ||= 'NO'
      end
    end
  end
end
