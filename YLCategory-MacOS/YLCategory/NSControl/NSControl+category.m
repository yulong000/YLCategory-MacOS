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
    self.action = @selector(controlClicked);
    [self willChangeValueForKey:@"clickedHandler"];
    objc_setAssociatedObject(self, &NSControlClickedHandlerKey, clickedHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"clickedHandler"];
}

- (void)controlClicked {
    if (self.clickedHandler) {
        self.clickedHandler(self);
    }
}

@end
