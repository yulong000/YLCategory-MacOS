//
//  NSWindow+frame.m
//  Paste
//
//  Created by 魏宇龙 on 2022/5/9.
//

#import "NSWindow+frame.h"

@implementation NSWindow (frame)

- (void)setX:(CGFloat)x {
    NSRect frame = self.frame;
    frame.origin.x = x;
    [self setFrame:frame display:YES];
}

- (CGFloat)x {
    return NSMinX(self.frame);
}

- (void)setY:(CGFloat)y {
    NSRect frame = self.frame;
    frame.origin.y = y;
    [self setFrame:frame display:YES];
}

- (CGFloat)y {
    return NSMinY(self.frame);
}

- (void)setWidth:(CGFloat)width {
    NSRect frame = self.frame;
    frame.size.width = width;
    [self setFrame:frame display:YES];
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    NSRect frame = self.frame;
    frame.size.height = height;
    [self setFrame:frame display:YES];
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size {
    NSRect frame = self.frame;
    frame.size = size;
    [self setFrame:frame display:YES];
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigin:(NSPoint)origin {
    [self setFrameOrigin:origin];
}

- (NSPoint)origin {
    return self.frame.origin;
}

- (void)setBounds:(NSRect)bounds {
    self.size = bounds.size;
}

- (NSRect)bounds {
    return NSMakeRect(0, 0, self.width, self.height);
}

- (CGFloat)centerX {
    return NSMidX(self.frame);
}

- (void)setCenterX:(CGFloat)centerX {
    self.x = centerX - self.width / 2;
}

- (CGFloat)centerY {
    return NSMidY(self.frame);
}

- (void)setCenterY:(CGFloat)centerY {
    self.y = centerY - self.height / 2;
}

- (CGFloat)maxX {
    return NSMaxX(self.frame);
}

- (CGFloat)maxY {
    return NSMaxY(self.frame);
}

- (CGFloat)top {
    return self.maxY;
}

- (void)setTop:(CGFloat)top {
    NSRect frame = self.frame;
    frame.origin.y = top - frame.size.height;
    [self setFrame:frame display:YES];
}

- (CGFloat)left {
    return self.x;
}

- (void)setLeft:(CGFloat)left {
    self.x = left;
}

- (CGFloat)bottom {
    return self.y;
}

- (void)setBottom:(CGFloat)bottom {
    self.y = bottom;
}

- (CGFloat)right {
    return self.maxX;
}

- (void)setRight:(CGFloat)right {
    NSRect frame = self.frame;
    frame.origin.x = right - self.width;
    [self setFrame:frame display:YES];
}

- (NSPoint)centerPoint {
    return NSMakePoint(self.width * 0.5, self.height * 0.5);
}

@end
