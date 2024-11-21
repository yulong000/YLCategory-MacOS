//
//  YLShortcutManager.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/11/1.
//

#import "YLShortcutManager.h"

@interface YLShortcutManager ()

@property (nonatomic, strong) MASShortcutMonitor *shortcutMonitor;
@property (nonatomic, strong) MASShortcutValidator *shortcutValidator;

@end

@implementation YLShortcutManager

+ (instancetype)share {
    static YLShortcutManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YLShortcutManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if(self = [super init]) {
        self.shortcutMonitor = [MASShortcutMonitor sharedMonitor];
        self.shortcutValidator = [MASShortcutValidator sharedValidator];
    }
    return self;
}

#pragma mark - 注册快捷键
- (BOOL)registerShortcut:(MASShortcut *)shortcut withAction:(dispatch_block_t)action {
    return [self.shortcutMonitor registerShortcut:shortcut withAction:action];
}

#pragma mark 快捷键是否已注册
- (BOOL)isShortcutRegistered:(MASShortcut *)shortcut {
    return [self.shortcutMonitor isShortcutRegistered:shortcut];
}

#pragma mark 取消注册快捷键
- (void)unregisterShortcut:(MASShortcut *)shortcut {
    [self.shortcutMonitor unregisterShortcut:shortcut];
}
#pragma mark 取消注册所有快捷键
- (void)unregisterAllShortcuts {
    [self.shortcutMonitor unregisterAllShortcuts];
}

#pragma mark - 暂停监控某个快捷键
- (void)pauseMonitorShortcut:(MASShortcut *)shortcut {
    [self.shortcutMonitor pauseMonitorShortcut:shortcut];
}

#pragma mark 继续监听某个快捷键
- (void)continueMonitorShortcut:(MASShortcut *)shortcut {
    [self.shortcutMonitor continueMonitorShortcut:shortcut];
}

#pragma mark 暂停监控多个快捷键
- (void)pauseMonitorShortcuts:(NSArray <MASShortcut *> *)shortcuts {
    [self.shortcutMonitor pauseMonitorShortcuts:shortcuts];
}

#pragma mark 继续监听所有的快捷键
- (void)continueMonitorAllShortcuts {
    [self.shortcutMonitor continueMonitorAllShortcuts];
}

#pragma mark - 单个快捷键是否包含Option键，且可以正常使用
- (BOOL)isShortcutValidWithOptionModifier:(MASShortcut *)shortcut {
    return [self.shortcutValidator isShortcutValidWithOptionModifier:shortcut];
}

#pragma mark 多个快捷键是否包含Option键，且都可以正常使用
- (BOOL)isShortcutsValidWithOptionModifier:(NSArray <MASShortcut *> *)shortcuts {
    return [self.shortcutValidator isShortcutsValidWithOptionModifier:shortcuts];
}

#pragma mark - 是否是有效的快捷键
- (BOOL)isShortcutValid:(MASShortcut *)shortcut {
    return [self.shortcutValidator isShortcutValid:shortcut];
}

#pragma mark 快捷键是否被菜单栏占用
- (BOOL)isShortcut:(MASShortcut *)shortcut alreadyTakenInMenu:(NSMenu *) menu explanation:(NSString * _Nullable * _Nullable)explanation {
    return [self.shortcutValidator isShortcut:shortcut alreadyTakenInMenu:menu explanation:explanation];
}

#pragma mark 快捷键是否被系统占用，包含了菜单栏
- (BOOL)isShortcutAlreadyTakenBySystem:(MASShortcut *)shortcut explanation:(NSString * _Nullable * _Nullable)explanation {
    return [self.shortcutValidator isShortcutAlreadyTakenBySystem:shortcut explanation:explanation];
}

#pragma mark 弹窗请求辅助功能
- (void)showAuthAccessbilityAlertForOptionModifierWithClearHandler:(dispatch_block_t)clearHandler {
    NSAlert *alert = [[NSAlert alloc] init];
    alert.alertStyle = NSAlertStyleWarning;
    alert.messageText = YLShortcutLocalizeString(@"Kind tips", @"");
    alert.informativeText = YLShortcutLocalizeString(@"Option Modifier Tips", @"");
    [alert addButtonWithTitle:YLShortcutLocalizeString(@"Auth Accessibility", @"")];
    [alert addButtonWithTitle:YLShortcutLocalizeString(@"Clear Option Shortcuts", @"")];
    NSModalResponse returnCode = [alert runModal];
    if(returnCode == NSAlertFirstButtonReturn) {
        // 关闭app，打开辅助功能授权
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [NSApp terminate:nil];
        });
        // 模拟鼠标抬起，请求辅助功能权限
        CGEventRef eventRef = CGEventCreate(NULL);
        if(eventRef == NULL) {
            return;
        }
        NSPoint point = CGEventGetLocation(eventRef);
        CFRelease(eventRef);
        CGEventRef mouseEventRef = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseUp, point, kCGMouseButtonLeft);
        if(mouseEventRef == NULL) {
            return;
        }
        CGEventPost(kCGHIDEventTap, mouseEventRef);
        CFRelease(mouseEventRef);
        
        NSString *setting = @"x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility";
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:setting]];
    } else if (returnCode == NSAlertSecondButtonReturn) {
        if(clearHandler) {
            clearHandler();
        }
    }
}

@end


NSString *YLShortcutLocalizeString(NSString *key, NSString *comment) {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle bundleForClass:NSClassFromString(@"YLShortcutView")];
    });
    return [bundle localizedStringForKey:key value:@"" table:@"YLShortcutView"];
}
