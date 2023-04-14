
#import "NSString+bounds.h"

@implementation NSString (bounds)

- (NSSize)sizeWithMaxWidth:(CGFloat)maxWidth font:(NSFont *)font {
    return [self boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName : font}
                              context:nil].size;
}

@end
