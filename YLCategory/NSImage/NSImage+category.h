//
//  NSImage+category.h
//  Paste
//
//  Created by 魏宇龙 on 2022/5/1.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSImage (category)

/// 更改图片的颜色
- (NSImage *)renderWithColor:(NSColor *)color;

/// 更改图片的大小
/// @param size 更改后的大小
- (NSImage *)resize:(NSSize)size;

@end

NS_ASSUME_NONNULL_END
