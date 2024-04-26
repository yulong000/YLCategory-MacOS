//
//  YLControl.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2023/12/19.
//

#import "YLControl.h"

@implementation YLControl

// 自定义NSControl时，为了响应点击事件，需要实现下面的方法
- (void)mouseDown:(NSEvent *)event {
    if(self.enabled) {
        [self.window makeFirstResponder:self];
    }
    [super mouseDown:event];
}

- (void)mouseUp:(NSEvent *)event {
    if(self.enabled) {
        [NSApp sendAction:self.action to:self.target from:self];
    }
    [super mouseUp:event];
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    return YES;
}

- (BOOL)isFlipped {
    return YES;
}

@end
