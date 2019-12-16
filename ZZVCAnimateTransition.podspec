#
#  Be sure to run `pod spec lint ZZVCAnimateTransition.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#


Pod::Spec.new do |s|
  s.name             = "ZZVCAnimateTransition"
  s.version          = "1.0.1"
  s.summary          = "Elegant transition library for iOS"

  s.description      = <<-DESC
                        ZZVCAnimateTransition is a library for building iOS view controller transitions. 
                       DESC

  s.homepage         = "https://github.com/ZeusZZ/ZZVCAnimateTransition"
  
  s.license          = 'MIT'
  s.author           = { "ZeusZZ" => "497091448@qq.com" }

  s.source           = { :git => "https://github.com/ZeusZZ/ZZVCAnimateTransition.git", :tag => s.version.to_s }
  
  s.ios.deployment_target  = '11.0'

  s.ios.frameworks         = 'UIKit', 'Foundation'

  s.source_files = "ZZVCAnimateTransition/*.swift"
end

