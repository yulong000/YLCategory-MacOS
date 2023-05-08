//
//  NSTextField+category.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2023/5/8.
//

#import "NSTextField+category.h"

@implementation NSTextField (category)

- (NSSize)sizeWithMaxWidth:(CGFloat)width {
    NSSize size = [self sizeThatFits:NSMakeSize(width, MAXFLOAT)];
    NSRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
    return size;
}

@end
