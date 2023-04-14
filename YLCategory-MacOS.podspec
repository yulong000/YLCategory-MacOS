#
#  Be sure to run `pod spec lint YLCategory-MacOS.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

s.name                  = "YLCategory-MacOS"
s.version               = "0.0.3"
s.summary               = "macos app开发常用分类"
s.homepage              = "https://github.com/yulong000/YLCategory-MacOS"
s.license               = { :type => 'MIT', :file => 'LICENSE'}
s.author                = { "魏宇龙" => "weiyulong1987@163.com" }
s.platform              = :macos, "10.13"
s.source                = { :git => "https://github.com/yulong000/YLCategory-MacOS.git", :tag => "#{s.version}" }
s.source_files          = "YLCategory/YLCategory.h"
s.requires_arc          = true

s.subspec 'Other' do |ss|
ss.source_files  =   'YLCategory/Other/*.{h,m}'
end

s.subspec 'NSWindow' do |ss|
ss.source_files  =    'YLCategory/NSWindow/*.{h,m}'
end

s.subspec 'NSViewController' do |ss|
ss.source_files  =    'YLCategory/NSViewController/*.{h,m}'
end

s.subspec 'NSView' do |ss|
ss.source_files  =    'YLCategory/NSView/*.{h,m}'
end

s.subspec 'NSTextField' do |ss|
ss.source_files  =    'YLCategory/NSTextField/*.{h,m}'
end

s.subspec 'NSString' do |ss|
ss.source_files  =   'YLCategory/NSString/*.{h,m}'
end

s.subspec 'NSObject' do |ss|
ss.source_files  =   'YLCategory/NSObject/*.{h,m}'
end

s.subspec 'NSImageView' do |ss|
ss.source_files  =   'YLCategory/NSImageView/*.{h,m}'
end

s.subspec 'NSImage' do |ss|
ss.source_files  =   'YLCategory/NSImage/*.{h,m}'
end

s.subspec 'NSDate' do |ss|
ss.source_files  =   'YLCategory/NSDate/*.{h,m}'
end

s.subspec 'NSControl' do |ss|
ss.source_files  =   'YLCategory/NSControl/*.{h,m}'
end

s.subspec 'NSButton' do |ss|
ss.source_files  =   'YLCategory/NSButton/*.{h,m}'
ss.dependency         'YLCategory/NSControl'
end

s.subspec 'NSAlert' do |ss|
ss.source_files  =   'YLCategory/NSAlert/*.{h,m}'
end
  
end


# 升级时  1.add tag
#        2.push tag
#        3.pod trunk push YLCategory-MacOS.podspec --allow-warnings
