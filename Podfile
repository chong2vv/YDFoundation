
platform :ios, '9.0'

abstract_target 'Demo' do
  
  target 'YDFoundationDemo' do
    pod 'YDFoundation', :path => '.'
  end
  
  target 'YDRouter' do
    
  end
  
  target 'YDWebp' do
    
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
