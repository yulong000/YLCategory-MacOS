//
//  MASShortcutMonitor+category.m
//  Paste
//
//  Created by 魏宇龙 on 2022/7/9.
//

#import "MASShortcutMonitor+category.h"
#import <objc/runtime.h>
#import "MASHotKey.h"

static const char MASShortcutPauseMonitorShortcutArrKey = '\0';

@implementation MASShortcutMonitor (category)

- (void)pauseMonitorShortcuts:(NSArray<MASShortcut *> *)shortcuts {
    [self willChangeValueForKey:@"pasuMonitiorShortcutArr"];
    NSMutableArray *arr = objc_getAssociatedObject(self, &MASShortcutPauseMonitorShortcutArrKey);
    if(arr == nil) {
        arr = [NSMutableArray array];
    }
    [arr addObjectsFromArray:shortcuts];
    objc_setAssociatedObject(self, &MASShortcutPauseMonitorShortcutArrKey, arr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"pasuMonitiorShortcutArr"];
}

- (void)continueMonitorShortcut:(MASShortcut *)shortcut {
    [self willChangeValueForKey:@"pasuMonitiorShortcutArr"];
    NSMutableArray *arr = objc_getAssociatedObject(self, &MASShortcutPauseMonitorShortcutArrKey);
    for (MASShortcut *obj in arr) {
        if(obj.carbonFlags == shortcut.carbonFlags && obj.carbonKeyCode == shortcut.carbonKeyCode) {
            [arr removeObject:obj];
            break;
        }
    }
    objc_setAssociatedObject(self, &MASShortcutPauseMonitorShortcutArrKey, arr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"pasuMonitiorShortcutArr"];
}

- (void)continueMonitorAllShortcuts {
    [self willChangeValueForKey:@"pasuMonitiorShortcutArr"];
    objc_setAssociatedObject(self, &MASShortcutPauseMonitorShortcutArrKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"pasuMonitiorShortcutArr"];
}

- (void)handleEvent:(EventRef)event {
    if (GetEventClass(event) != kEventClassKeyboard) {
        return;
    }

    EventHotKeyID hotKeyID;
    OSStatus status = GetEventParameter(event, kEventParamDirectObject, typeEventHotKeyID, NULL, sizeof(hotKeyID), NULL, &hotKeyID);
    if (status != noErr || hotKeyID.signature != MASHotKeySignature) {
        return;
    }
    NSMutableArray *shortcuts = objc_getAssociatedObject(self, &MASShortcutPauseMonitorShortcutArrKey);
    NSMutableDictionary *hotKeys = [self valueForKey:@"hotKeys"];
    [hotKeys enumerateKeysAndObjectsUsingBlock:^(MASShortcut *shortcut, MASHotKey *hotKey, BOOL *stop) {
        BOOL flag = NO;
        for (MASShortcut *obj in shortcuts) {
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

@end
