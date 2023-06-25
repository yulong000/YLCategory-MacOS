//
//  NSColor+dynamic.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2023/5/8.
//

#import "NSColor+dynamic.h"

@implementation NSColor (dynamic)

+ (NSColor *)light:(NSColor *)light dark:(NSColor *)dark {
    if(@available(macOS 10.15, *)) {
        return [NSColor colorWithName:nil dynamicProvider:^NSColor * _Nonnull(NSAppearance * _Nonnull appearance) {
            if(appearance.name == NSAppearanceNameDarkAqua || appearance.name == NSAppearanceNameVibrantDark) {
                // 暗黑模式
                return dark ?: light;
            }
            return light;
        }];
    }
    return light;
}

@end
