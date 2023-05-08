//
//  NSResponder+category.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2023/5/8.
//

#import "NSResponder+category.h"
#import <objc/runtime.h>

static const char YLSystemThemeChangedHandlerKey = '\0';

@implementation NSResponder (category)

- (YLSystemThemeChangedHandler)themeChangedHandler {
    return objc_getAssociatedObject(self, &YLSystemThemeChangedHandlerKey);
}

- (void)setThemeChangedHandler:(YLSystemThemeChangedHandler)themeChangedHandler {
    [self willChangeValueForKey:@"themeChangedHandler"];
    objc_setAssociatedObject(self, &YLSystemThemeChangedHandlerKey, themeChangedHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"themeChangedHandler"];
    if(themeChangedHandler) {
        [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(yl_systemThemeChanged) name:@"AppleInterfaceThemeChangedNotification" object:nil];
    } else {
        [[NSDistributedNotificationCenter defaultCenter] removeObserver:self name:@"AppleInterfaceThemeChangedNotification" object:nil];
    }
}

- (void)yl_systemThemeChanged {
    if (self.themeChangedHandler) {
        self.themeChangedHandler(self);
    }
}

- (void)dealloc {
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self name:@"AppleInterfaceThemeChangedNotification" object:nil];
}

@end
