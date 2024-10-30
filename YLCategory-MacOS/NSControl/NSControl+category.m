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

+ (void)load {
    Class clazz = [self class];
    Method originalSetStringValue = class_getInstanceMethod(clazz, @selector(setStringValue:));
    Method swizzledSetStringValue = class_getInstanceMethod(clazz, @selector(yl_setStringValue:));
    method_exchangeImplementations(originalSetStringValue, swizzledSetStringValue);
    
    Method originalAttributedStringValue = class_getInstanceMethod(clazz, @selector(setAttributedStringValue:));
    Method swizzledAttributedStringValue = class_getInstanceMethod(clazz, @selector(yl_setAttributedStringValue:));
    method_exchangeImplementations(originalAttributedStringValue, swizzledAttributedStringValue);
}

- (void)yl_setStringValue:(NSString *)stringValue {
    [self yl_setStringValue:stringValue ?: @""];
}

- (void)yl_setAttributedStringValue:(NSAttributedString *)attributedStringValue {
    [self yl_setAttributedStringValue:attributedStringValue ?: [[NSAttributedString alloc] init]];
}

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

@end
