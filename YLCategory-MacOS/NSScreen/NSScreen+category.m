//
//  NSScreen+category.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2023/11/16.
//

#import "NSScreen+category.h"

@implementation NSScreen (category)

- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (NSSize)size {
    return self.frame.size;
}

- (NSPoint)origin {
    return self.frame.origin;
}

- (CGFloat)centerX {
    return CGRectGetMidX(self.frame);
}

- (CGFloat)centerY {
    return CGRectGetMidY(self.frame);
}

- (CGFloat)maxX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)maxY {
    return CGRectGetMaxY(self.frame);
}

- (NSPoint)center {
    return NSMakePoint(self.centerX, self.centerY);
}

- (BOOL)isBuiltin {
    CGDirectDisplayID ID = [self.deviceDescription[@"NSScreenNumber"] intValue];
    return CGDisplayIsBuiltin(ID);
}

+ (NSScreen *)builtinScreen {
    for (NSScreen *screen in [NSScreen screens]) {
        if(screen.isBuiltin) {
            return screen;
        }
    }
    return nil;
}

@end
