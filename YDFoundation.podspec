#
# Be sure to run `pod lib lint YDFoundation.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#YDFoundation

Pod::Spec.new do |s|YDFoundation
  s.name             = 'YDFoundation'
  s.version          = '0.1.0'
  s.platform         = :ios, "9.0"
  s.summary          = 'A short description of YDFoundation.'


  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/chong2vv/YDFoundation'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wangyuandong' => 'chong2vv@163.com' }
  s.source           = { :git => 'https://github.com/chong2vv/YDFoundation.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.frameworks = 'UIKit', 'Foundation', 'CoreGraphics'
  s.xcconfig = {
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
    'HEADER_SEARCH_PATHS'   => '$(SDKROOT)/usr/include/libxml2',
    'OTHER_LDFLAGS'         => '-ObjC -lxml2'
  }

  # _ 为单个自己 ，__ 为 组合 但是有自己的东西，___ 没有自己的代码文件夹下的纯组合
  
  # YDRouter
  _YDRouter      = { :spec_name => "YDRouter", :source_files => ['YDRouter/**/*.{h,m}']}

  #YDWebp
  _YDWebp      = { :spec_name => "YDWebp", :source_files => ['YDWebp/**/*.{h,m}'], :dependency => [{:name => "libwebp", :version => "1.2.3"}]}
  
  all_subspec = [_YDRouter, _YDWebp]
 

  all_subspec.each do |spec|

    s.subspec spec[:spec_name] do |ss|

      specname = spec[:spec_name]

      if spec[:ios_deployment_target]
        ss.ios.deployment_target = spec[:ios_deployment_target]
      end

      if spec[:source_files]
        ss.source_files = spec[:source_files]
      end

      if spec[:sub_dependency]
        spec[:sub_dependency].each do |dep|
          ss.dependency "ArtFoundation/#{dep[:spec_name]}"
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
