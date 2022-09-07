#
#  Be sure to run `pod spec lint YLCategory-MacOS.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "YLCategory-MacOS"
  spec.version      = "0.0.2"
  spec.summary      = "macos app开发常用分类"
  spec.homepage     = "https://github.com/yulong000/YLCategory-MacOS"
  spec.license      = "MIT"
  spec.author       = { "魏宇龙" => "weiyulong1987@163.com" }
  spec.platform     = :macos, "10.13"
  spec.source       = { :git => "https://github.com/yulong000/YLCategory-MacOS.git", :tag => "#{spec.version}" }
  spec.source_files  = "YLCategory-MacOS/YLCategory/**"
  spec.public_header_files = "YLCategory-MacOS/YLCategory/YLCategory.h"
  spec.requires_arc = true
  
end


# 升级时  1.add tag
#        2.push tag
#        3.pod trunk push YLCategory-MacOS.podspec
