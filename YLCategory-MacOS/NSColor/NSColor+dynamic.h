//
//  NSColor+dynamic.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2023/5/8.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSColor (dynamic)

+ (NSColor *)light:(NSColor *)light dark:(NSColor *)dark;

@end

NS_ASSUME_NONNULL_END
