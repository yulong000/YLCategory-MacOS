
#import <AppKit/AppKit.h>

@interface NSString (bounds)

/**
 获取string的size

 @param maxWidth 最大的宽度
 @param font 字体
 */
- (NSSize)sizeWithMaxWidth:(CGFloat)maxWidth font:(NSFont *)font;

@end
