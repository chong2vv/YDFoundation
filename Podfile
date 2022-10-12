
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

abstract_target 'Demo' do
  
  target 'YDFoundationDemo' do
    pod 'YDFoundation', :path => '.'
  end
  
  target 'YDFoundation' do
    
  end
  
  target 'YDRouter' do
    
  end
  
  target 'YDWebp' do
    pod 'libwebp', '~> 1.2.3'
  end
  
  target 'YDUtilKit' do
    pod 'AFNetworking', '~> 4.0.1'
  end
  
  target 'YDSVProgressHUD' do
    pod 'lottie-ios', '~> 2.5.3'
    pod 'SVProgressHUD', '~> 2.2.5'
    pod 'YYImage', '~> 1.0.4'
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
