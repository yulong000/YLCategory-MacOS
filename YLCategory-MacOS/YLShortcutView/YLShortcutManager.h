//
//  YLShortcutManager.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/11/1.
//

#import <Foundation/Foundation.h>
#import "Shortcut.h"

NS_ASSUME_NONNULL_BEGIN

NSString *YLShortcutLocalizeString(NSString *key, NSString *comment);

@interface YLShortcutManager : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

+ (instancetype)share;

@property (readonly) MASShortcutMonitor *shortcutMonitor;
@property (readonly) MASShortcutValidator *shortcutValidator;

/// 注册快捷键
- (BOOL)registerShortcut:(MASShortcut *)shortcut withAction:(dispatch_block_t)action;
/// 快捷键是否已注册
- (BOOL)isShortcutRegistered:(MASShortcut *)shortcut;

/// 取消注册快捷键
- (void)unregisterShortcut:(MASShortcut *)shortcut;
/// 取消注册所有快捷键
- (void)unregisterAllShortcuts;

/// 暂停监控某个快捷键
- (void)pauseMonitorShortcut:(MASShortcut *)shortcut;
/// 继续监听某个快捷键
- (void)continueMonitorShortcut:(MASShortcut *)shortcut;
/// 暂停监控多个快捷键
- (void)pauseMonitorShortcuts:(NSArray <MASShortcut *> *)shortcuts;
/// 继续监听所有的快捷键
- (void)continueMonitorAllShortcuts;

/// 单个快捷键是否包含Option键，且可以正常使用
- (BOOL)isShortcutValidWithOptionModifier:(MASShortcut *)shortcut;
/// 多个快捷键是否包含Option键，且都可以正常使用
- (BOOL)isShortcutsValidWithOptionModifier:(NSArray <MASShortcut *> *)shortcuts;

/// 是否是有效的快捷键
- (BOOL)isShortcutValid:(MASShortcut *)shortcut;
/// 快捷键是否被菜单栏占用
- (BOOL)isShortcut:(MASShortcut *)shortcut alreadyTakenInMenu:(NSMenu *) menu explanation:(NSString * _Nullable * _Nullable)explanation;
/// 快捷键是否被系统占用，包含了菜单栏
- (BOOL)isShortcutAlreadyTakenBySystem:(MASShortcut *)shortcut explanation:(NSString * _Nullable * _Nullable)explanation;

/// 弹窗提醒，因Option无法使用，需授权辅助功能权限，点击授权，会退出app并打开授权页面，点了清空，会回调
- (void)showAuthAccessbilityAlertForOptionModifierWithClearHandler:(dispatch_block_t)clearHandler;

@end

NS_ASSUME_NONNULL_END
