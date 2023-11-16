#
#  Be sure to run `pod spec lint YLCategory-MacOS.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

s.name                  = "YLCategory-MacOS"
s.version               = "1.0.5"
s.summary               = "macos app开发常用分类"
s.homepage              = "https://github.com/yulong000/YLCategory-MacOS"
s.license               = { :type => 'MIT', :file => 'LICENSE'}
s.author                = { "魏宇龙" => "weiyulong1987@163.com" }
s.platform              = :macos, "10.14"
s.source                = { :git => "https://github.com/yulong000/YLCategory-MacOS.git", :tag => "#{s.version}" }
s.source_files          = "YLCategory-MacOS/YLCategory.h"
s.requires_arc          = true

s.subspec 'Other' do |ss|
ss.source_files  =   'YLCategory-MacOS/Other/*.{h,m}'
end

s.subspec 'NSWindow' do |ss|
ss.source_files  =    'YLCategory-MacOS/NSWindow/*.{h,m}'
end

s.subspec 'NSScreen' do |ss|
ss.source_files  =   'YLCategory-MacOS/NSScreen/*.{h,m}'
end

s.subspec 'NSView' do |ss|
ss.source_files  =    'YLCategory-MacOS/NSView/*.{h,m}'
end

s.subspec 'NSTextField' do |ss|
ss.source_files  =    'YLCategory-MacOS/NSTextField/*.{h,m}'
end

s.subspec 'NSString' do |ss|
ss.source_files  =   'YLCategory-MacOS/NSString/*.{h,m}'
end

s.subspec 'NSObject' do |ss|
ss.source_files  =   'YLCategory-MacOS/NSObject/*.{h,m}'
end

s.subspec 'NSImage' do |ss|
ss.source_files  =   'YLCategory-MacOS/NSImage/*.{h,m}'
end

s.subspec 'NSDate' do |ss|
ss.source_files  =   'YLCategory-MacOS/NSDate/*.{h,m}'
end

s.subspec 'NSControl' do |ss|
ss.source_files  =   'YLCategory-MacOS/NSControl/*.{h,m}'
end

s.subspec 'NSButton' do |ss|
ss.source_files  =   'YLCategory-MacOS/NSButton/*.{h,m}'
ss.dependency        'YLCategory-MacOS/NSControl'
end

s.subspec 'NSAlert' do |ss|
ss.source_files  =   'YLCategory-MacOS/NSAlert/*.{h,m}'
end

s.subspec 'NSResponder' do |ss|
ss.source_files  =   'YLCategory-MacOS/NSResponder/*.{h,m}'
ss.dependency        'YLCategory-MacOS/Other'
end

s.subspec 'NSColor' do |ss|
ss.source_files  =   'YLCategory-MacOS/NSColor/*.{h,m}'
end

s.subspec 'NSImageView' do |ss|
ss.source_files  =   'YLCategory-MacOS/NSImageView/*.{h,m}'
end

s.subspec 'YLProgressHUD' do |ss|
ss.source_files  =   'YLCategory-MacOS/YLProgressHUD/*.{h,m}'
ss.resource      =   'YLCategory-MacOS/YLProgressHUD/YLProgressHUD.bundle'
ss.dependency        'YLCategory-MacOS/Other'
end

s.subspec 'YLShortcutView' do |ss|
ss.source_files  =   'YLCategory-MacOS/YLShortcutView/*.{h,m}'
ss.resource      =   'YLCategory-MacOS/YLShortcutView/Resources/*'
ss.dependency        'YLCategory-MacOS/YLProgressHUD'
ss.dependency        'MASShortcut', '~>2.4.0'
end

s.subspec 'YLUserDefaults' do |ss|
ss.source_files  =   'YLCategory-MacOS/YLUserDefaults/*.{h,m}'
end

s.subspec 'YLWeakTimer' do |ss|
ss.source_files  =   'YLCategory-MacOS/YLWeakTimer/*.{h,m}'
ss.dependency        'YLCategory-MacOS/Other'
end

s.subspec 'YLCollectionView' do |ss|
ss.source_files  =   'YLCategory-MacOS/YLCollectionView/*.{h,m}'
end

s.subspec 'YLAppleScript' do |ss|
ss.source_files  =   'YLCategory-MacOS/YLAppleScript/*.{h,m}'
ss.resource      =   'YLCategory-MacOS/YLAppleScript/Resource/*'
ss.dependency        'YLCategory-MacOS/YLProgressHUD'
end

s.subspec 'YLFlipView' do |ss|
ss.source_files  =   'YLCategory-MacOS/YLFlipView/*.{h,m}'
end

s.subspec 'YLCFNotificationManager' do |ss|
ss.source_files  =   'YLCategory-MacOS/YLCFNotificationManager/*.{h,m}'
end
  
end


# 升级时  1.add tag
#        2.push tag
#        3.pod trunk push YLCategory-MacOS.podspec --allow-warnings --use-libraries

#        pod spec lint YLCategory-MacOS.podspec --use-libraries  验证podspec文件
#        --use-libraries 有第三方库依赖，添加该参数
