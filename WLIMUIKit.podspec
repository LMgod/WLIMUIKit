#
#  Be sure to run `pod spec lint WLIMUIKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "WLIMUIKit"
  spec.version      = "0.0.1"
  spec.summary      = "WL消息库"
  spec.description      = <<-DESC
基于云信UI组件2.12.8版本封装的IM组件库
                       DESC
  spec.homepage     = "https://github.com/LMgod/WLIMUIKit"
  spec.license      = "MIT "
  spec.author             = "WL"
  spec.platform     = :ios, "9.0"
  spec.frameworks = 'CoreText', 'SystemConfiguration', 'AVFoundation', 'CoreTelephony', 'AudioToolbox', 'CoreMedia' , 'VideoToolbox'
  spec.libraries  = 'sqlite3.0', 'z', 'c++'
  spec.source       = { :git => "https://github.com/LMgod/WLIMUIKit.git", :tag => spec.version }
  spec.source_files  = 'NIMKit/NIMKit/Classes/**/*.{h,m}'
  spec.resources = "NIMKit/Resources/*"
  spec.dependency "NIMSDK_LITE", '~> 7.6.0'
  spec.dependency "Toast", "~> 3.0"
  spec.dependency "HXPhotoPicker", "~> 2.3.8"
  spec.dependency "M80AttributedLabel", "~> 1.9.9"
  spec.dependency "YYImage", "~>  1.0.4"
  spec.dependency "YYImage/WebP", "~>  1.0.4"
  spec.dependency 'YYWebImage', '~> 1.0.5'
  spec.dependency "DongtuStore", "~>  3.2.6"
end
