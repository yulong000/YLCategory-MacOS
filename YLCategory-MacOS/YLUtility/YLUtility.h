//
//  YLUtility.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/4/8.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import <Carbon/Carbon.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLUtility : NSObject

// 常用的block, 等同于 dispatch_block_t
typedef void (^VoidBlock)(void);

// 延时操作
void dispatchAfterDelay(NSTimeInterval delay, dispatch_block_t block);
// 本地化
NSString * Localize(NSString *key);

#pragma mark - 修饰键判断

BOOL IsModifierFlags(NSEventModifierFlags flags);
BOOL IsControlModifierFlags(NSEventModifierFlags flags);
BOOL IsShiftModifierFlags(NSEventModifierFlags flags);
BOOL IsCommandModifierFlags(NSEventModifierFlags flags);
BOOL IsOptionModifierFlags(NSEventModifierFlags flags);
BOOL ModifierFlagsEqual(NSEventModifierFlags flags, NSEventModifierFlags anotherFlags);
BOOL ModifierFlagsContain(NSEventModifierFlags flags, NSEventModifierFlags containedFlags);

#pragma mark 修饰键根据按键值判断

BOOL IsControlKeyCode(CGKeyCode keyCode);
BOOL IsShiftKeyCode(CGKeyCode keyCode);
BOOL IsCommandKeyCode(CGKeyCode keyCode);
BOOL IsOptionKeyCode(CGKeyCode keyCode);

#pragma mark CGEventFlags 和 NSEventModifierFlags 转换

/// 将 CGEventFlags 转成 NSEventModifierFlags
NSEventModifierFlags NSEventModifierFlagsFromCGEventFlags(CGEventFlags cgFlags);
/// 比较 CGEventFlags 和 NSEventModifierFlags 是否相同
BOOL CGEventFlagsEqualToModifierFlags(CGEventFlags cgFlags, NSEventModifierFlags nsFlags);
/// 事件的修饰键 == nsFlags
BOOL CGEventMatchesModifierFlags(CGEventRef event, NSEventModifierFlags nsFlags);

@end

NS_ASSUME_NONNULL_END
