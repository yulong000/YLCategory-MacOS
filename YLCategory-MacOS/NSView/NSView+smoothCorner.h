//
//  NSView+smoothCorner.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2025/9/6.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSView (smoothCorner)

/// 设置平滑圆角
- (void)setSmoothCorner:(CGFloat)corner;

/// 设置4个角的平滑圆角
- (void)setSmoothCornerWithTopLeft:(CGFloat)topLeft
                          topRight:(CGFloat)topRight
                       bottomRight:(CGFloat)bottomRight
                        bottomLeft:(CGFloat)bottomLeft;

/// 设置平滑圆角的边框颜色和宽度
- (void)setSmoothCornerBorderColor:(NSColor *)borderColor borderWidth:(CGFloat)borderWidth;

@end

NS_ASSUME_NONNULL_END
