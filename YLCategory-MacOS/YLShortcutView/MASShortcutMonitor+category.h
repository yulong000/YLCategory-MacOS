//
//  MASShortcutMonitor+category.h
//  Paste
//
//  Created by 魏宇龙 on 2022/7/9.
//

#import "MASShortcutMonitor.h"

NS_ASSUME_NONNULL_BEGIN

@interface MASShortcutMonitor (category)

/// 暂停监控快捷键
- (void)pauseMonitorShortcuts:(NSArray <MASShortcut *> *)shortcuts;
/// 继续监听快捷键
- (void)continueMonitorShortcut:(MASShortcut *)shortcut;
/// 继续监听所有的快捷键
- (void)continueMonitorAllShortcuts;

@end

NS_ASSUME_NONNULL_END
