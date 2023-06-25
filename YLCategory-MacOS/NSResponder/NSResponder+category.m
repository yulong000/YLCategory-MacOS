//
//  NSResponder+category.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2023/5/8.
//

#import "NSResponder+category.h"
#import <objc/runtime.h>

@implementation NSResponder (category)

- (YLSystemThemeChangedHandler)themeChangedHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setThemeChangedHandler:(YLSystemThemeChangedHandler)themeChangedHandler {
    objc_setAssociatedObject(self, @selector(themeChangedHandler), themeChangedHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
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
