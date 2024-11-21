//
//  YLShortcutView.m
//  Test
//
//  Created by 魏宇龙 on 2022/7/6.
//

#import "YLShortcutView.h"
#import "YLHud.h"

@interface YLShortcutView ()

@property (nonatomic, strong) NSButton *shortcutBtn;
@property (nonatomic, strong) NSButton *recoverBtn;
@property (nonatomic, strong) NSButton *clearBtn;

/// 要显示的文字
@property (nonatomic, copy)   NSString *titleString;
/// 监听器
@property (nonatomic, strong) NSMutableArray *monitorArr;
/// 是否正在编辑中
@property (nonatomic, assign, getter=isRecording) BOOL recording;

@end

@implementation YLShortcutView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    [self addSubview:self.shortcutBtn];
    [self addSubview:self.recoverBtn];
    [self addSubview:self.clearBtn];
    [self addObserver:self forKeyPath:@"titleString" options:NSKeyValueObservingOptionNew context:nil];
    [NSApp addObserver:self forKeyPath:@"effectiveAppearance" options:NSKeyValueObservingOptionNew context:nil];
    self.titleFont = [NSFont systemFontOfSize:13];
    [self setBtnsImage];
    self.recording = NO;
}

- (void)layout {
    [super layout];
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    NSSize btnSize = NSMakeSize(12, 15);
    NSRect clearFrame = NSZeroRect;
    clearFrame.size = btnSize;
    clearFrame.origin.y = (height - btnSize.height) / 2;
    clearFrame.origin.x = width - btnSize.width - 3;
    NSRect recoverFrame = clearFrame;
    recoverFrame.origin.x = clearFrame.origin.x - btnSize.width;
    self.recoverBtn.frame = recoverFrame;
    self.clearBtn.frame = clearFrame;
    // NSButton 高度固定 32
    self.shortcutBtn.frame = NSMakeRect(-6, (height - self.shortcutBtn.frame.size.height) / 2, width + 12, self.shortcutBtn.frame.size.height);
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"titleString"];
    [NSApp removeObserver:self forKeyPath:@"effectiveAppearance"];
    [self removeMonitor];
}

#pragma mark 设置快捷键
- (void)setShortcut:(MASShortcut *)shortcut {
    _shortcut = shortcut;
    [self resetTitle];
}

#pragma mark  更新标题
- (void)resetTitle {
    if(self.isRecording) {
        self.titleString = [self titleStringForRecording];
    } else {
        self.titleString = [self titleStringForNormal];
    }
}

#pragma mark 记录时显示的标题
- (NSString *)titleStringForRecording {
    if(self.shortcut == nil) {
        return self.titleForHasNotShortcutAndEditing ?: [YLShortcutConfig share].titleForHasNotShortcutAndEditing ?: YLShortcutLocalizeString(@"Begin record shortcut", @"");
    } else {
        return [NSString stringWithFormat:@"%@%@", self.shortcut.modifierFlagsString, self.shortcut.keyCodeString];
    }
}

#pragma mark 正常时显示的标题
- (NSString *)titleStringForNormal {
    if(self.shortcut == nil) {
        return self.titleForHasNotShortcut ?: [YLShortcutConfig share].titleForHasNotShortcut ?: YLShortcutLocalizeString(@"Click to record shortcut", @"");
    } else {
        return [NSString stringWithFormat:@"%@%@", self.shortcut.modifierFlagsString, self.shortcut.keyCodeString];
    }
}

#pragma mark 设置标题的字体
- (void)setTitleFont:(NSFont *)titleFont {
    if(titleFont) {
        _titleFont = titleFont;
    }
}

#pragma mark 设置没有快捷键时显示的文字
- (void)setTitleForHasNotShortcut:(NSString *)titleForHasNotShortcut {
    _titleForHasNotShortcut = [titleForHasNotShortcut copy];
    [self resetTitle];
}

- (void)setTitleForHasNotShortcutAndEditing:(NSString *)titleForHasNotShortcutAndEditing {
    _titleForHasNotShortcutAndEditing = [titleForHasNotShortcutAndEditing copy];
    [self resetTitle];
}

#pragma mark 监听标题内容的变化，设置标题颜色
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if([keyPath isEqualToString:@"titleString"]) {
        [self setAttrTitle];
    } else if ([keyPath isEqualToString:@"effectiveAppearance"]) {
        // 主题色发生变化
        [self setBtnsImage];
    }
}

#pragma mark 设置显示的文字
- (void)setAttrTitle {
    if(self.isRecording) {
        self.shortcutBtn.attributedTitle = [[NSAttributedString alloc] initWithString:self.titleString attributes:@{NSForegroundColorAttributeName : [NSColor placeholderTextColor], NSFontAttributeName : self.titleFont}];
    } else {
        self.shortcutBtn.attributedTitle = [[NSAttributedString alloc] initWithString:self.titleString attributes:@{NSForegroundColorAttributeName : [NSColor labelColor], NSFontAttributeName : self.titleFont}];
    }
}

#pragma mark - 添加键盘｜鼠标监控
- (void)addMonitor {
    __weak typeof(self) weakSelf = self;
    id keyMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskFlagsChanged | NSEventMaskKeyDown handler:^NSEvent * _Nullable(NSEvent * _Nonnull event) {
        // 控制键按下
        if(weakSelf.isRecording) {
            MASShortcut *shortcut = [MASShortcut shortcutWithEvent:event];
            // tab键
//            if(shortcut.keyCode == kVK_Tab) {
//                return event;
//            }
            if(shortcut.modifierFlags) {
                // 按下了控制键
                if(shortcut.keyCode == kVK_Delete || shortcut.keyCode == kVK_ForwardDelete) {
                    // 删除键，删除快捷键
                    [weakSelf clearShortcut];
                    event = nil;
                } else if (shortcut.keyCode == kVK_Escape) {
                    // esc 退出编辑
                    [weakSelf recoverShortcut];
                    event = nil;
                } else if(shortcut.modifierFlags == NSEventModifierFlagCommand && (shortcut.keyCode == kVK_ANSI_W || shortcut.keyCode == kVK_ANSI_Q)) {
                    // cmd + w || cmd + q
                    [weakSelf recoverShortcut];
                } else if(shortcut.keyCodeString.length > 0) {
                    // 字母键已按下
                    if([YLShortcutManager.share isShortcutValid:shortcut]) {
                        // 有效
                        NSString *explanation = nil;
                        if([YLShortcutManager.share isShortcutAlreadyTakenBySystem:shortcut explanation:&explanation]) {
                            // 已经注册过了
                            NSBeep();
                            NSLog(@"%@", explanation);
                            [YLHud showError:YLShortcutLocalizeString(@"Shortcut has been registered by system", @"") toWindow:weakSelf.window];
                        } else if ([YLShortcutManager.share isShortcutValidWithOptionModifier:shortcut] == NO) {
                            // 含有Option,且在当前系统无效，需要打开辅助功能权限
                            event = nil;
                            weakSelf.recording = NO;
                            [NSApp activateIgnoringOtherApps:YES];
                            NSAlert *alert = [[NSAlert alloc] init];
                            alert.alertStyle = NSAlertStyleWarning;
                            alert.messageText = MASLocalizedString(@"Kind tips", @"");
                            alert.informativeText = MASLocalizedString(@"Accessibility Tips", @"");
                            [alert addButtonWithTitle:MASLocalizedString(@"To Authorize", @"")];
                            [alert addButtonWithTitle:MASLocalizedString(@"Cancel", @"")];
                            if([alert runModal] == NSAlertFirstButtonReturn) {
                                // 模拟鼠标抬起，请求辅助功能权限
                                CGEventRef eventRef = CGEventCreate(NULL);
                                NSPoint point = CGEventGetLocation(eventRef);
                                CFRelease(eventRef);
                                CGEventRef mouseEventRef = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseUp, point, kCGMouseButtonLeft);
                                CGEventPost(kCGHIDEventTap, mouseEventRef);
                                CFRelease(mouseEventRef);
                                
                                // 打开辅助功能权限设置页面
                                NSString *setting = @"x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility";
                                [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:setting]];
                            }
                        } else {
                            event = nil;
                            weakSelf.shortcut = shortcut;
                            weakSelf.recording = NO;
                            if(weakSelf.changedHandler) {
                                weakSelf.changedHandler(weakSelf, shortcut);
                            }
                        }
                    } else {
                        // 控制键不可用
                        NSBeep();
                        [YLHud showError:YLShortcutLocalizeString(@"Control keys are unavailable", @"") toWindow:weakSelf.window];
                    }
                } else {
                    // 字母键未按下
                    weakSelf.titleString = shortcut.modifierFlagsString;
                }
            } else {
                // 未按下控制键
                weakSelf.titleString = [weakSelf titleStringForRecording];
            }
        }
        return event;
    }];
    id mouseMouseMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskLeftMouseDown handler:^NSEvent * _Nullable(NSEvent * _Nonnull event) {
        // 鼠标左键点击
        if(NSPointInRect([event locationInWindow], [weakSelf convertRect:weakSelf.bounds toView:nil]) == NO) {
            [weakSelf recoverShortcut];
        }
        return event;
    }];
    id globalMouseMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskLeftMouseDown handler:^(NSEvent * _Nonnull event) {
        // 鼠标左键点击
        [weakSelf recoverShortcut];
    }];
    [self.monitorArr addObject:keyMonitor];
    [self.monitorArr addObject:mouseMouseMonitor];
    [self.monitorArr addObject:globalMouseMonitor];
    if(self.shortcut) {
        [YLShortcutManager.share pauseMonitorShortcuts:@[self.shortcut]];
    }
}

#pragma mark 移除键盘｜鼠标监控
- (void)removeMonitor {
    [self.monitorArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [NSEvent removeMonitor:obj];
    }];
    [self.monitorArr removeAllObjects];
    if(self.shortcut) {
        [YLShortcutManager.share continueMonitorAllShortcuts];
    }
}

#pragma mark - 设置不同状态下的显示内容
- (void)setRecording:(BOOL)recording {
    _recording = recording;
    if(recording) {
        self.shortcutBtn.state = NSControlStateValueOn;
        self.shortcutBtn.toolTip = YLShortcutLocalizeString(@"Record Shortcut", @"");
        self.clearBtn.hidden = self.recoverBtn.hidden = NO;
        [self.window makeFirstResponder:self.shortcutBtn];
        [self addMonitor];
    } else {
        self.shortcutBtn.state = NSControlStateValueOff;
        self.shortcutBtn.toolTip = YLShortcutLocalizeString(@"Click to begin editing", @"");
        self.clearBtn.hidden = self.recoverBtn.hidden = YES;
        [self.window makeFirstResponder:nil];
        [self removeMonitor];
    }
    [self resetTitle];
}

#pragma mark 开始编辑
- (void)beginEdit:(NSButton *)btn {
    self.recording = !self.recording;
}

#pragma mark 恢复到原来的快捷键
- (void)recoverShortcut {
    self.recording = NO;
}

#pragma mark 清空快捷键
- (void)clearShortcut {
    self.shortcut = nil;
    self.recording = NO;
    if(self.changedHandler) {
        self.changedHandler(self, self.shortcut);
    }
}

#pragma mark 设置按钮的图片
- (void)setBtnsImage {
    BOOL isDark = NO;
    YLShortcutViewStyle style = self.style ?: [YLShortcutConfig share].style;
    switch (style) {
        case YLShortcutViewStyleNormal: {
            isDark = NO;
        }
            break;
        case YLShortcutViewStyleDark: {
            isDark = YES;
        }
            break;
        default: {
            isDark = [NSApp.effectiveAppearance bestMatchFromAppearancesWithNames:@[NSAppearanceNameDarkAqua, NSAppearanceNameAqua]] == NSAppearanceNameDarkAqua;
        }
            break;
    }
    if (isDark) {
        self.recoverBtn.image = [YLShortcutView bundleImage:@"shortcut_recover_white_icon@2x.png"];
        self.clearBtn.image = [YLShortcutView bundleImage:@"shortcut_close_white_icon@2x.png"];
    } else {
        self.recoverBtn.image = [YLShortcutView bundleImage:@"shortcut_recover_black_icon@2x.png"];
        self.clearBtn.image = [YLShortcutView bundleImage:@"shortcut_close_black_icon@2x.png"];
    }
}

#pragma mark 获取bundle里的图片
+ (NSImage *)bundleImage:(NSString *)icon {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"YLShortcutView" withExtension:@"bundle"];
    if(url == nil) {
        url = [[[[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil] URLByAppendingPathComponent:@"YLCategory"] URLByAppendingPathExtension:@"framework"];
        NSBundle *bundle = [NSBundle bundleWithURL:url];
        url = [bundle URLForResource:@"YLShortcutView" withExtension:@"bundle"];
    }
    NSString *path = [[NSBundle bundleWithURL:url].bundlePath stringByAppendingPathComponent:icon];
    return [[NSImage alloc] initWithContentsOfFile:path];
}

#pragma mark - lazy load

- (NSButton *)shortcutBtn {
    if(_shortcutBtn == nil) {
        _shortcutBtn = [NSButton buttonWithTitle:@"" target:self action:@selector(beginEdit:)];
    }
    return _shortcutBtn;
}

- (NSButton *)recoverBtn {
    if(_recoverBtn == nil) {
        _recoverBtn = [NSButton buttonWithImage:[YLShortcutView bundleImage:@"shortcut_recover_white_icon@2x.png"] target:self action:@selector(recoverShortcut)];
        _recoverBtn.bordered = NO;
        _recoverBtn.hidden = YES;
        _recoverBtn.toolTip = YLShortcutLocalizeString(@"End editing", @"");
    }
    return _recoverBtn;
}

- (NSButton *)clearBtn {
    if(_clearBtn == nil) {
        _clearBtn = [NSButton buttonWithImage:[YLShortcutView bundleImage:@"shortcut_close_white_icon@2x.png"] target:self action:@selector(clearShortcut)];
        _clearBtn.bordered = NO;
        _clearBtn.hidden = YES;
        _clearBtn.toolTip = YLShortcutLocalizeString(@"Delete shortcut", @"");
    }
    return _clearBtn;
}

- (NSMutableArray *)monitorArr {
    if(_monitorArr == nil) {
        _monitorArr = [NSMutableArray array];
    }
    return _monitorArr;
}

@end
