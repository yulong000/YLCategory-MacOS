//
//  NSWindow+category.m
//  Paste
//
//  Created by 魏宇龙 on 2022/5/9.
//

#import "NSWindow+category.h"

@implementation NSWindow (category)

+ (instancetype)windowWithClearBackground {
    NSWindow *window = [[NSWindow alloc] initWithContentRect:NSZeroRect styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskClosable backing:NSBackingStoreBuffered defer:YES];
    window.titlebarAppearsTransparent = YES;
    [window standardWindowButton:NSWindowMiniaturizeButton].hidden = YES;
    [window standardWindowButton:NSWindowCloseButton].hidden = YES;
    [window standardWindowButton:NSWindowZoomButton].hidden = YES;
    window.backgroundColor = [NSColor clearColor];
    window.opaque = NO;
    window.movableByWindowBackground = YES;
    return window;
}

@end
