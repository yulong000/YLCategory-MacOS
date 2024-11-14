//
//  YLUtility.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/4/8.
//

#import "YLUtility.h"

@implementation YLUtility

// 延时操作
void dispatchAfterDelay(NSTimeInterval delay, dispatch_block_t block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

NSString * Localize(NSString *key) {
    return NSLocalizedString(key, @"");
}

#pragma mark - 修饰键判断

#define MODIFIER_MASK (NSEventModifierFlagShift | NSEventModifierFlagControl | NSEventModifierFlagOption | NSEventModifierFlagCommand)

BOOL IsModifierFlags(NSEventModifierFlags flags) {
    NSArray *allowedCombinations = @[
        @(NSEventModifierFlagShift),
        @(NSEventModifierFlagOption),
        @(NSEventModifierFlagCommand),
        @(NSEventModifierFlagControl),
        @(NSEventModifierFlagShift | NSEventModifierFlagControl),
        @(NSEventModifierFlagShift | NSEventModifierFlagControl | NSEventModifierFlagOption),
        @(NSEventModifierFlagShift | NSEventModifierFlagControl | NSEventModifierFlagOption | NSEventModifierFlagCommand),
        @(NSEventModifierFlagShift | NSEventModifierFlagControl | NSEventModifierFlagCommand),
        @(NSEventModifierFlagShift | NSEventModifierFlagOption),
        @(NSEventModifierFlagShift | NSEventModifierFlagOption | NSEventModifierFlagCommand),
        @(NSEventModifierFlagShift | NSEventModifierFlagCommand),
        @(NSEventModifierFlagControl | NSEventModifierFlagOption),
        @(NSEventModifierFlagControl | NSEventModifierFlagOption | NSEventModifierFlagCommand),
        @(NSEventModifierFlagControl | NSEventModifierFlagCommand),
        @(NSEventModifierFlagOption | NSEventModifierFlagCommand),
    ];
    for (NSNumber *combo in allowedCombinations) {
        if (ModifierFlagsEqual(flags, combo.unsignedIntegerValue)) {
            return YES;
        }
    }
    return NO;
}
BOOL IsControlModifierFlags(NSEventModifierFlags flags) {
    return (MODIFIER_MASK & flags) == NSEventModifierFlagControl;
}

BOOL IsShiftModifierFlags(NSEventModifierFlags flags) {
    return (MODIFIER_MASK & flags) == NSEventModifierFlagShift;
}

BOOL IsCommandModifierFlags(NSEventModifierFlags flags) {
    return (MODIFIER_MASK & flags) == NSEventModifierFlagCommand;
}

BOOL IsOptionModifierFlags(NSEventModifierFlags flags) {
    return (MODIFIER_MASK & flags) == NSEventModifierFlagOption;
}

BOOL ModifierFlagsEqual(NSEventModifierFlags flags, NSEventModifierFlags anotherFlags) {
    return (MODIFIER_MASK & flags) && (MODIFIER_MASK & anotherFlags) && ((MODIFIER_MASK & flags) == (MODIFIER_MASK & anotherFlags));
}

BOOL ModifierFlagsContain(NSEventModifierFlags flags, NSEventModifierFlags containedFlags) {
    return (flags & containedFlags) == containedFlags;
}


#pragma mark 修饰键根据按键值判断

BOOL IsControlKeyCode(CGKeyCode keyCode) {
    return keyCode == kVK_Control || keyCode == kVK_RightControl;
}

BOOL IsShiftKeyCode(CGKeyCode keyCode) {
    return keyCode == kVK_Command || keyCode == kVK_RightCommand;
}

BOOL IsCommandKeyCode(CGKeyCode keyCode) {
    return keyCode == kVK_Shift || keyCode == kVK_RightShift;
}

BOOL IsOptionKeyCode(CGKeyCode keyCode) {
    return keyCode == kVK_Option || keyCode == kVK_RightOption;
}

#pragma mark CGEventFlags 和 NSEventModifierFlags转换

NSEventModifierFlags NSEventModifierFlagsFromCGEventFlags(CGEventFlags cgFlags) {
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

BOOL CGEventFlagsEqualToModifierFlags(CGEventFlags cgFlags, NSEventModifierFlags nsFlags) {
    return NSEventModifierFlagsFromCGEventFlags(cgFlags) == nsFlags;
}

BOOL CGEventMatchesModifierFlags(CGEventRef event, NSEventModifierFlags nsFlags) {
    return CGEventFlagsEqualToModifierFlags(CGEventGetFlags(event), nsFlags);
}

@end
