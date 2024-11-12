//
//  YLPermissionManager.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import "YLPermissionManager.h"
#import <pwd.h>
#import "YLPermissionWindowController.h"

@interface YLPermissionManager ()

@property (nonatomic, strong) YLPermissionWindowController *permissionWC;
@property (nonatomic, strong) NSArray <YLPermissionModel *> *authTypes;
@property (nonatomic, strong) NSTimer *monitorTimer;
@property (nonatomic, assign) BOOL skipped;

@end


@implementation YLPermissionManager

+ (instancetype)share {
    static YLPermissionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YLPermissionManager alloc] init];
    });
    return manager;
}

#pragma mark - 定时监听权限
- (void)monitorPermissionAuthTypes:(NSArray<YLPermissionModel *> *)authTypes repeat:(NSInteger)repeatSeconds {
    __weak typeof(self) weakSelf = self;
    self.authTypes = authTypes;
    [self.monitorTimer invalidate];
    self.monitorTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if(repeatSeconds <= 0) {
            // 不需要循环监测
            if([weakSelf allAuthPassed]) {
                [weakSelf.monitorTimer invalidate];
                weakSelf.monitorTimer = nil;
                if(weakSelf.permissionWC) {
                    [weakSelf passAuth];
                }
                return;
            }
            // 有权限未授权，弹出授权窗口
            if(weakSelf.permissionWC == nil) {
                weakSelf.permissionWC = [[YLPermissionWindowController alloc] init];
                weakSelf.permissionWC.permissionVc.allAuthPassedHandler = ^{
                    [weakSelf.monitorTimer invalidate];
                    weakSelf.monitorTimer = nil;
                    [weakSelf passAuth];
                };
                weakSelf.permissionWC.permissionVc.skipHandler = ^{
                    [weakSelf skipAuth];
                };
                weakSelf.permissionWC.permissionVc.authTypes = authTypes;
            } else {
                [weakSelf.permissionWC.permissionVc refreshAllAuthState];
            }
            [weakSelf.permissionWC.window orderFrontRegardless];
        } else {
            static int second = 0;
            if(++second >= repeatSeconds) {
                // 达到了设置的间隔秒数
                if([weakSelf allAuthPassed] == NO) {
                    // 有权限未授权，弹出授权窗口
                    if(weakSelf.permissionWC == nil) {
                        weakSelf.permissionWC = [[YLPermissionWindowController alloc] init];
                        weakSelf.permissionWC.permissionVc.allAuthPassedHandler = ^{
                            [weakSelf passAuth];
                        };
                        weakSelf.permissionWC.permissionVc.skipHandler = ^{
                            [weakSelf skipAuth];
                        };
                        weakSelf.permissionWC.permissionVc.authTypes = authTypes;
                    }
                    [weakSelf.permissionWC.window orderFrontRegardless];
                    second = 0;
                } else {
                    // 都已授权
                    if(weakSelf.permissionWC) {
                        [weakSelf passAuth];
                    }
                }
            } else if (weakSelf.permissionWC) {
                // 如果授权窗口在，每秒刷新一次状态
                [weakSelf.permissionWC.permissionVc refreshAllAuthState];
            }
        }
    }];
}

- (void)monitorPermissionAuthTypes:(NSArray<YLPermissionModel *> *)authTypes {
    [self monitorPermissionAuthTypes:authTypes repeat:0];
}

#pragma mark 权限都已通过
- (void)passAuth {
    // 所有权限已授权,关闭控制器，释放内存
    [self.permissionWC close];
    self.permissionWC = nil;
    if(self.allAuthPassedHandler) {
        self.allAuthPassedHandler();
    }
}

#pragma mark 跳过授权
- (void)skipAuth {
    // 跳过授权
    [self.permissionWC close];
    self.permissionWC = nil;
    // 不再需要定时器了，释放
    [self.monitorTimer invalidate];
    self.monitorTimer = nil;
    self.skipped = YES;
}

#pragma mark - 检查某个权限是否开启
- (BOOL)checkPermissionAuthType:(YLPermissionAuthType)authType {
    BOOL flag = YES;
    NSString *tips = @"";
    SEL sel = NULL;
    switch (authType) {
        case YLPermissionAuthTypeAccessibility:
            flag = [[YLPermissionManager share] getPrivacyAccessibilityIsEnabled];
            tips = @"Accessibility Tips";
            sel = @selector(openPrivacyAccessibilitySetting);
            break;
        case YLPermissionAuthTypeScreenCapture:
            flag = [[YLPermissionManager share] getScreenCaptureIsEnabled];
            tips = @"ScreenCapture Tips";
            sel = @selector(openScreenCaptureSetting);
            break;
        case YLPermissionAuthTypeFullDisk:
            flag = [[YLPermissionManager share] getFullDiskAccessIsEnabled];
            tips = @"Full disk access Tips";
            sel = @selector(openFullDiskAccessSetting);
            break;
        default:
            break;
    }
    if(flag == NO) {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.alertStyle = NSAlertStyleWarning;
        alert.messageText = YLPermissionManagerLocalizeString(@"Kind tips");
        alert.informativeText = [NSString stringWithFormat:YLPermissionManagerLocalizeString(tips), kAppName];
        [alert addButtonWithTitle:YLPermissionManagerLocalizeString(@"To Authorize")];
        [alert addButtonWithTitle:YLPermissionManagerLocalizeString(@"Cancel")];
        NSModalResponse returnCode = [alert runModal];
        if(returnCode == NSAlertFirstButtonReturn) {
            if(sel && [self respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self performSelector:sel];
#pragma clang diagnostic pop
            }
        }
    }
    return flag;
}

#pragma mark 获取所有权限是否已授权
- (BOOL)allAuthPassed {
    BOOL flag = YES;
    for (YLPermissionModel *model in self.authTypes) {
        switch (model.authType) {
            case YLPermissionAuthTypeAccessibility: {
                // 辅助功能
                if([[YLPermissionManager share] getPrivacyAccessibilityIsEnabled] == NO) {
                    flag = NO;
                }
            }
                break;
            case YLPermissionAuthTypeScreenCapture: {
                // 录屏
                if([[YLPermissionManager share] getScreenCaptureIsEnabled] == NO) {
                    flag = NO;
                }
            }
                break;
            case YLPermissionAuthTypeFullDisk: {
                // 完全磁盘
                if([[YLPermissionManager share] getFullDiskAccessIsEnabled] == NO) {
                    flag = NO;
                }
            }
                break;
            default:
                break;
        }
    }
    return flag;
}

#pragma mark 获取辅助功能权限状态
- (BOOL)getPrivacyAccessibilityIsEnabled {
    return AXIsProcessTrusted();
}

#pragma mark 打开辅助功能权限设置窗口
- (void)openPrivacyAccessibilitySetting {
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
}

#pragma mark 获取录屏权限状态
- (BOOL)getScreenCaptureIsEnabled {
    if(@available(macOS 10.15, *)) {
        BOOL enable = NO;
        pid_t currentPid = [NSRunningApplication currentApplication].processIdentifier;
        CFArrayRef windowList = CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly, kCGNullWindowID);
        if(windowList == nil) {
            return NO;
        }
        NSUInteger numberOfWindows = CFArrayGetCount(windowList);
        for (int idx = 0; idx < numberOfWindows; idx++) {
            NSDictionary *windowInfo = (NSDictionary *)CFArrayGetValueAtIndex(windowList, idx);
            NSString *windowName = windowInfo[(id)kCGWindowName];
            pid_t pid = [windowInfo[(id)kCGWindowOwnerPID] intValue];
            if(pid != currentPid) {
                NSRunningApplication *windowRunningApp = [NSRunningApplication runningApplicationWithProcessIdentifier:pid];
                if(windowRunningApp) {
                    NSString *windowExecutableName = windowRunningApp.executableURL.lastPathComponent;
                    // ignore the Dock, which provides the desktop picture
                    if(windowName.length > 0 && [windowExecutableName isEqualToString:@"Dock"] == NO) {
                        enable = YES;
                        break;
                    }
                }
            }
        }
        CFRelease(windowList);
        return enable;
    }
    return YES;
}

#pragma mark 打开录屏权限设置窗口
- (void)openScreenCaptureSetting {
    CGImageRef imageRef = CGWindowListCreateImage(CGRectMake(0, 0, 1, 1), kCGWindowListOptionOnScreenOnly, kCGNullWindowID, kCGWindowImageDefault);
    if(imageRef) {
        CFRelease(imageRef);
    }
    NSString *urlString = @"x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture";
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:urlString]];
}

#pragma mark 获取完全磁盘权限状态
- (BOOL)getFullDiskAccessIsEnabled {
    if(@available(macOS 10.14, *)) {
        BOOL isSandbox = (nil != NSProcessInfo.processInfo.environment[@"APP_SANDBOX_CONTAINER_ID"]);
        NSString *userHomePath;
        if(isSandbox) {
            struct passwd *pw = getpwuid(getuid());
            assert(pw);
            userHomePath = [NSString stringWithUTF8String:pw->pw_dir];
        } else {
            userHomePath = NSHomeDirectory();
        }
        NSArray<NSString *> *testFiles = @[
            [userHomePath stringByAppendingPathComponent:@"Library/Safari/CloudTabs.db"],
            [userHomePath stringByAppendingPathComponent:@"Library/Safari/Bookmarks.plist"],
            @"/Library/Application Support/com.apple.TCC/TCC.db",
            @"/Library/Preferences/com.apple.TimeMachine.plist",
        ];
        
        for (NSString *file in testFiles) {
            int fd = open([file cStringUsingEncoding:NSUTF8StringEncoding], O_RDONLY);
            if(fd != -1) {
                close(fd);
                return YES;
            }
        }
        return NO;
    }
    return YES;
}

#pragma mark 打开完全磁盘权限设置窗口
- (void)openFullDiskAccessSetting {
    NSString *urlString = @"x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles";
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:urlString]];
}

@end


NSString *YLPermissionManagerLocalizeString(NSString *key) {
   static NSBundle *bundle = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
       bundle = [NSBundle bundleForClass:[YLPermissionManager class]];
   });
   return [bundle localizedStringForKey:key value:@"" table:@"YLPermissionManager"];
}

