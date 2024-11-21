#import "MASShortcutMonitor.h"
#import "MASHotKey.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MASLocalization.h"

static OSStatus MASCarbonEventCallback(EventHandlerCallRef, EventRef, void*);
static CGEventRef MASKeyDownEventCallBack(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon);

// CGEventFlags 转换成 NSEventModifierFlags
NSEventModifierFlags MASNSEventModifierFlagsFromCGEventFlags(CGEventFlags cgFlags);
// 比较 CGEventFlags 和 NSEventModifierFlags 是否相同
BOOL MASModifierFlagsEqual(CGEventFlags cgFlags, NSEventModifierFlags nsFlags);

// 提示音音量
static CGFloat volumeValue = 0;
// 是否更改了提示音音量
static BOOL volumeChanged = NO;
// 获取系统提示音音量
float system_volume_get(void);
// 设置系统提示音音量
void system_volume_set(Float32 volume);

@interface MASShortcutMonitor ()

@property(assign) EventHandlerRef eventHandlerRef;
@property(strong) NSMutableDictionary *hotKeys;

// 暂时忽略的快捷键
@property (nonatomic, strong) NSMutableArray *ignoreHotKeyArr;

// macos 15 处理option快捷键
@property(assign) CFRunLoopSourceRef runloopSourceRef;
@property(assign) CFMachPortRef tap;

/// 监听辅助功能权限
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation MASShortcutMonitor

#pragma mark Initialization

- (instancetype) init
{
    self = [super init];
    [self setHotKeys:[NSMutableDictionary dictionary]];
    self.ignoreHotKeyArr = [NSMutableArray array];
    EventTypeSpec hotKeyPressedSpec = { .eventClass = kEventClassKeyboard, .eventKind = kEventHotKeyPressed };
    OSStatus status = InstallEventHandler(GetEventDispatcherTarget(), MASCarbonEventCallback,
        1, &hotKeyPressedSpec, (__bridge void*)self, &_eventHandlerRef);
    if (status != noErr) {
        return nil;
    }
    // 监听辅助功能权限
    [self monitorAccessibilityPermissionDidChanged];
    // 监听错误提示音播放
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(systemBeepNotification) name:@"com.apple.systemBeep" object:nil];
    
    return self;
}

- (void) dealloc
{
    if (_eventHandlerRef) {
        RemoveEventHandler(_eventHandlerRef);
        _eventHandlerRef = NULL;
    }
    
    if(_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    
    [self unregisterKeyDownSourceRef];
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype) sharedMonitor
{
    static dispatch_once_t once;
    static MASShortcutMonitor *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark 监听辅助功能权限的变化
- (void)monitorAccessibilityPermissionDidChanged {
    if(@available(macOS 15.0, *)) {
        if(_timer == nil) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 0), 1 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
            dispatch_source_set_event_handler(_timer, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    BOOL trusted = AXIsProcessTrusted();
                    if(trusted == NO) {
                        // 辅助功能已关闭，注销keydown监听，防止卡系统
                        [self unregisterKeyDownSourceRef];
                    } else {
                        [self registerKeyDownSourceRef];
                    }
                });
            });
            dispatch_resume(_timer);
        }
    }
}

- (BOOL)registerKeyDownSourceRef {
    if(_runloopSourceRef == nil) {
        _tap = CGEventTapCreate(kCGHIDEventTap, kCGHeadInsertEventTap, kCGEventTapOptionDefault, CGEventMaskBit(kCGEventKeyDown), MASKeyDownEventCallBack, (__bridge void*)self);
        if(_tap == nil) {
            return NO;
        }
        _runloopSourceRef = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, _tap, 0);
        if(_runloopSourceRef == nil) {
            return NO;
        }
        CFRunLoopAddSource(CFRunLoopGetCurrent(), _runloopSourceRef, kCFRunLoopCommonModes);
    }
    return YES;
}

- (void)unregisterKeyDownSourceRef {
    if (_runloopSourceRef) {
        CFRunLoopRemoveSource(CFRunLoopGetCurrent(), _runloopSourceRef, kCFRunLoopCommonModes);
        CFRelease(_runloopSourceRef);
        _runloopSourceRef = NULL;
    }
    
    if(_tap) {
        CFRelease(_tap);
        _tap = nil;
    }
}

#pragma mark Registration

- (BOOL) registerShortcut: (MASShortcut*) shortcut withAction: (dispatch_block_t) action
{
    MASHotKey *hotKey = [MASHotKey registeredHotKeyWithShortcut:shortcut];
    if (hotKey) {
        [hotKey setAction:action];
        [_hotKeys setObject:hotKey forKey:shortcut];
        return YES;
    } else {
        if((shortcut.modifierFlags & NSEventModifierFlagDeviceIndependentFlagsMask) == NSEventModifierFlagOption ||
           (shortcut.modifierFlags & NSEventModifierFlagDeviceIndependentFlagsMask) == (NSEventModifierFlagOption | NSEventModifierFlagShift)) {
            // 设置的是option + key, 在macos15上失效
            if(@available(macOS 15.0, *)) {
                // 请求辅助功能权限
                if(AXIsProcessTrusted()) {
                    if([self registerKeyDownSourceRef] == NO) {
                        return NO;
                    }
                    hotKey = [MASHotKey registeredOptionHotKeyWithShortcut:shortcut];
                    [hotKey setAction:action];
                    [_hotKeys setObject:hotKey forKey:shortcut];
                    return YES;
                } else {
                    // 未授权，弹窗提醒
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
                }
            }
        }
        return NO;
    }
}

- (void) unregisterShortcut: (MASShortcut*) shortcut
{
    if (shortcut) {
        for (MASShortcut *obj in _hotKeys.allKeys) {
            if(obj.carbonFlags == shortcut.carbonFlags && obj.carbonKeyCode == shortcut.carbonKeyCode) {
                [_hotKeys removeObjectForKey:obj];
                return;
            }
        }
    }
}

- (void) unregisterAllShortcuts
{
    [_hotKeys removeAllObjects];
}

- (BOOL) isShortcutRegistered: (MASShortcut*) shortcut
{
    for (MASShortcut *obj in _hotKeys.allKeys) {
        if(obj.carbonFlags == shortcut.carbonFlags && obj.carbonKeyCode == shortcut.carbonKeyCode) {
            return YES;
        }
    }
    return NO;
}


- (void)pauseMonitorShortcut:(MASShortcut *)shortcut {
    BOOL flag = NO;
    for (MASShortcut *obj in _ignoreHotKeyArr) {
        if(obj.carbonFlags == shortcut.carbonFlags && obj.carbonKeyCode == shortcut.carbonKeyCode) {
            flag = YES;
            break;
        }
    }
    if(flag == NO) {
        [_ignoreHotKeyArr addObject:shortcut];
    }
}

- (void)pauseMonitorShortcuts:(NSArray<MASShortcut *> *)shortcuts {
    for (MASShortcut *obj in shortcuts) {
        [self pauseMonitorShortcut:obj];
    }
}

- (void)continueMonitorShortcut:(MASShortcut *)shortcut {
    for (MASShortcut *obj in _ignoreHotKeyArr) {
        if(obj.carbonFlags == shortcut.carbonFlags && obj.carbonKeyCode == shortcut.carbonKeyCode) {
            [_ignoreHotKeyArr removeObject:obj];
            return;
        }
    }
}

- (void)continueMonitorAllShortcuts {
    [_ignoreHotKeyArr removeAllObjects];
}

#pragma mark Event Handling

- (void) handleEvent: (EventRef) event
{
    if (GetEventClass(event) != kEventClassKeyboard) {
        return;
    }

    EventHotKeyID hotKeyID;
    OSStatus status = GetEventParameter(event, kEventParamDirectObject, typeEventHotKeyID, NULL, sizeof(hotKeyID), NULL, &hotKeyID);
    if (status != noErr || hotKeyID.signature != MASHotKeySignature) {
        return;
    }

    [_hotKeys enumerateKeysAndObjectsUsingBlock:^(MASShortcut *shortcut, MASHotKey *hotKey, BOOL *stop) {
        BOOL flag = NO;
        for (MASShortcut *obj in _ignoreHotKeyArr) {
            if(obj.carbonFlags == shortcut.carbonFlags && obj.carbonKeyCode == shortcut.carbonKeyCode) {
                flag = YES;
                break;
            }
        }
        if (flag == NO && hotKeyID.id == [hotKey carbonID]) {
            if ([hotKey action]) {
                dispatch_async(dispatch_get_main_queue(), [hotKey action]);
            }
            *stop = YES;
        }
    }];
}

- (BOOL) handleOptionFlags:(CGEventFlags)flags withKeyCode:(CGKeyCode)keyCode {
    __block BOOL valid = NO;
    [_hotKeys enumerateKeysAndObjectsUsingBlock:^(MASShortcut *shortcut, MASHotKey *hotKey, BOOL *stop) {
        if (keyCode == shortcut.keyCode) {
            if(MASModifierFlagsEqual(flags, shortcut.modifierFlags)) {
                BOOL flag = NO;
                for (MASShortcut *obj in _ignoreHotKeyArr) {
                    if(obj.carbonFlags == shortcut.carbonFlags && obj.carbonKeyCode == shortcut.carbonKeyCode) {
                        flag = YES;
                        break;
                    }
                }
                if (flag == NO && [hotKey action]) {
                    // 关闭提示音
                    if(volumeChanged == NO) {
                        volumeValue = system_volume_get();
                        if(volumeValue > 0) {
                            system_volume_set(0);
                            volumeChanged = YES;
                        }
                    }
                    valid = YES;
                    dispatch_async(dispatch_get_main_queue(), [hotKey action]);
                }
                *stop = YES;
            }
        }
    }];
    return valid;
}

#pragma mark - 警告音
- (void)systemBeepNotification {
    // 播放完毕后，更改回原来的音量大小
    if(volumeChanged) {
        system_volume_set(volumeValue);
        volumeChanged = NO;
    }
}

@end

static OSStatus MASCarbonEventCallback(EventHandlerCallRef _, EventRef event, void *context)
{
    MASShortcutMonitor *dispatcher = (__bridge id)context;
    [dispatcher handleEvent:event];
    return noErr;
}

static CGEventRef MASKeyDownEventCallBack(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
    MASShortcutMonitor *dispatcher = (__bridge id)refcon;
    switch (type) {
        case kCGEventKeyDown: {
            CGEventFlags flags = CGEventGetFlags(event) & ~(kCGEventFlagMaskNonCoalesced | 0x20);
            CGKeyCode keyCode = (CGKeyCode)CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode);
            if((flags & kCGEventFlagMaskAlternate) == kCGEventFlagMaskAlternate ) {
                // 按下了 Option + keyCode
                if([dispatcher handleOptionFlags:flags withKeyCode:keyCode]) {
                    // 有快捷键响应，忽略事件
                    return nil;
                }
            } else if ((flags & (kCGEventFlagMaskAlternate | kCGEventFlagMaskShift)) ==
                       (kCGEventFlagMaskAlternate | kCGEventFlagMaskShift)) {
                // 按下了Option + Shift + keyCode
                if([dispatcher handleOptionFlags:flags withKeyCode:keyCode]) {
                    // 有快捷键响应，忽略事件
                    return nil;
                }
            }
        }
            break;
        default:
            break;
    }
    return event;
}

NSEventModifierFlags MASNSEventModifierFlagsFromCGEventFlags(CGEventFlags cgFlags) {
    NSEventModifierFlags nsFlags = 0;
    
    if (cgFlags & kCGEventFlagMaskShift) {
        nsFlags |= NSEventModifierFlagShift;
    }
    if (cgFlags & kCGEventFlagMaskControl) {
        nsFlags |= NSEventModifierFlagControl;
    }
    if (cgFlags & kCGEventFlagMaskAlternate) {
        nsFlags |= NSEventModifierFlagOption;
    }
    if (cgFlags & kCGEventFlagMaskCommand) {
        nsFlags |= NSEventModifierFlagCommand;
    }
    return nsFlags;
}

// 比较 CGEventFlags 和 NSEventModifierFlags 是否相同
BOOL MASModifierFlagsEqual(CGEventFlags cgFlags, NSEventModifierFlags nsFlags) {
    // 将 CGEventFlags 转换为 NSEventModifierFlags
    NSEventModifierFlags convertedNSFlags = MASNSEventModifierFlagsFromCGEventFlags(cgFlags);
    // 比较转换后的 NSEventModifierFlags 是否与原始的 NSEventModifierFlags 相等
    return convertedNSFlags == nsFlags;
}


#define FourCharCodeFromString(str) (UInt32)((str[0] << 24) | (str[1] << 16) | (str[2] << 8) | str[3])
static const AudioServicesPropertyID kAudioServicesPropertySystemAlertVolume = FourCharCodeFromString("ssvl");

float system_volume_get(void) {
    float volume = 0;
    UInt32 volSize = sizeof(volume);
    OSStatus err = AudioServicesGetProperty(kAudioServicesPropertySystemAlertVolume, 0, NULL, &volSize, &volume);
    if( err ) {
        NSLog( @"Getting alert volume got error %d", err );
        return NAN;
    }
    return volume;

}

void system_volume_set(Float32 volume) {
    AudioServicesSetProperty(kAudioServicesPropertySystemAlertVolume, 0, NULL, sizeof(volume), &volume);
}
