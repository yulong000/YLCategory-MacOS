//
//  YLPermissionManager.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import <Foundation/Foundation.h>
#import "YLPermissionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLPermissionManager : NSObject

+ (instancetype)share;

#pragma mark - 多个权限

/// 是否所有权限都已授权
@property (readonly) BOOL allAuthPassed;

/// 教学视频链接，不设置则不显示 观看权限设置教学>> 按钮
@property (nonatomic, copy, nullable)   NSString *tutorialLink;
/// 所有权限都已授权后的回调
@property (nonatomic, copy)   void (^allAuthPassedHandler)(void);

/// 一次性监听所有权限，如果有没有授权的权限，则显示授权窗口，当所有权限都授权时，则自动隐藏
/// - Parameters:
///   - types: 需要授权的权限
///   - repeatSeconds: 定时器，定时监测，一旦某个权限有变化，就会更新显示；如果传入0， 则只监测一次，所有权限授权完成，退出监测
- (void)monitorPermissionAuthTypes:(NSArray <YLPermissionModel *> *)authTypes repeat:(NSInteger)repeatSeconds;

/// 一次性监听所有权限，如果有没有授权的权限，则显示授权窗口，当所有权限都授权时，则自动隐藏
/// 等同于 - (void)monitorPermissionAuthTypes: repeat: 中  repeatSeconds 传入0
/// - Parameter authTypes: 需要授权的权限
- (void)monitorPermissionAuthTypes:(NSArray <YLPermissionModel *> *)authTypes;

#pragma mark - 单个权限

/// 检查某个权限是否开启，如果未开启，则会弹出Alert，请求打开权限
- (BOOL)checkPermissionAuthType:(YLPermissionAuthType)authType;

/// 获取辅助功能权限状态
- (BOOL)getPrivacyAccessibilityIsEnabled;
/// 获取录屏权限状态
- (BOOL)getScreenCaptureIsEnabled;
/// 获取完全磁盘权限状态
- (BOOL)getFullDiskAccessIsEnabled;

/// 打开辅助功能权限设置窗口
- (void)openPrivacyAccessibilitySetting;
/// 打开录屏权限设置窗口
- (void)openScreenCaptureSetting;
/// 打开完全磁盘权限设置窗口
- (void)openFullDiskAccessSetting;

@end

/// 国际化
NSString *YLPermissionManagerLocalizeString(NSString *key);

#ifndef kAppName
#define kAppName   ([[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"] ?: [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleName"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"])
#endif

NS_ASSUME_NONNULL_END
