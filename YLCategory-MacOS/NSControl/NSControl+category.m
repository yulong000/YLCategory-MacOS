//
//  NSControl+category.m
//  QQ
//
//  Created by 魏宇龙 on 2022/4/15.
//

#import "NSControl+category.h"
#import <objc/runtime.h>

static const char NSControlClickedHandlerKey = '\0';

@implementation NSControl (category)

- (NSControlClickedHandler)clickedHandler {
    return objc_getAssociatedObject(self, &NSControlClickedHandlerKey);
}

- (void)setClickedHandler:(NSControlClickedHandler)clickedHandler {
    self.target = self;
    self.action = @selector(yl_controlClicked);
    [self willChangeValueForKey:@"clickedHandler"];
    objc_setAssociatedObject(self, &NSControlClickedHandlerKey, clickedHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"clickedHandler"];
}

- (void)yl_controlClicked {
    if (self.clickedHandler) {
        self.clickedHandler(self);
    }
}

// 自定义NSControl时，为了响应点击事件，需要实现下面的方法

- (void)mouseDown:(NSEvent *)event {
    [self.window makeFirstResponder:self];
}

- (void)mouseUp:(NSEvent *)event {
    [NSApp sendAction:self.action to:self.target from:self];
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    return YES;
}

@end
