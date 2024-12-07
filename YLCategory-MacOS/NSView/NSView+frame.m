//
//  NSView+frame.m
//  QQ
//
//  Created by 魏宇龙 on 2022/4/15.
//

#import "NSView+frame.h"

@implementation NSView (frame)

- (YLSingleValueIs)x_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat value) {
        weakSelf.x = value;
        return weakSelf;
    };
}

- (YLSingleValueIs)y_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat value) {
        weakSelf.y = value;
        return weakSelf;
    };
}

- (YLSingleValueIs)width_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat value) {
        weakSelf.width = value;
        return weakSelf;
    };
}

- (YLSingleValueIs)height_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat value) {
        weakSelf.height = value;
        return weakSelf;
    };
}

- (YLSingleValueIs)top_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat value) {
        weakSelf.top = value;
        return weakSelf;
    };
}

- (YLSingleValueIs)left_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat value) {
        weakSelf.left = value;
        return weakSelf;
    };
}

- (YLSingleValueIs)bottom_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat value) {
        weakSelf.bottom = value;
        return weakSelf;
    };
}

- (YLSingleValueIs)right_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat value) {
        weakSelf.right = value;
        return weakSelf;
    };
}

- (YLSingleValueIs)centerX_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat value) {
        weakSelf.centerX = value;
        return weakSelf;
    };
}

- (YLSingleValueIs)centerY_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat value) {
        weakSelf.centerY = value;
        return weakSelf;
    };
}

- (YLDoubleValueIs)origin_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat value1, CGFloat value2) {
        weakSelf.origin = CGPointMake(value1, value2);
        return weakSelf;
    };
}

- (YLDoubleValueIs)size_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat value1, CGFloat value2) {
        weakSelf.size = CGSizeMake(value1, value2);
        return weakSelf;
    };
}

- (YLDoubleValueIs)center_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat value1, CGFloat value2) {
        weakSelf.center = CGPointMake(value1, value2);
        return weakSelf;
    };
}

- (YLFrameIs)frame_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat x, CGFloat y, CGFloat width, CGFloat height) {
        weakSelf.frame = CGRectMake(x, y, width, height);
        return weakSelf;
    };
}

- (YLOffset)offsetX_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat x) {
        weakSelf.x += x;
        return weakSelf;
    };
}

- (YLOffset)offsetY_is {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat y) {
        weakSelf.y += y;
        return weakSelf;
    };
}

- (YLEqualToView)x_equalTo {
    __weak typeof(self) weakSelf = self;
    return ^ (NSView *otherView) {
        weakSelf.x = otherView.x;
        return weakSelf;
    };
}

- (YLEqualToView)y_equalTo {
    __weak typeof(self) weakSelf = self;
    return ^ (NSView *otherView) {
        weakSelf.y = otherView.y;
        return weakSelf;
    };
}

- (YLEqualToView)origin_equalTo {
    __weak typeof(self) weakSelf = self;
    return ^ (NSView *otherView) {
        weakSelf.origin = otherView.origin;
        return weakSelf;
    };
}

- (YLEqualToView)top_equalTo {
    __weak typeof(self) weakSelf = self;
    return ^ (NSView *otherView) {
        weakSelf.top = otherView.top;
        return weakSelf;
    };
}

- (YLEqualToView)left_equalTo {
    __weak typeof(self) weakSelf = self;
    return ^ (NSView *otherView) {
        weakSelf.left = otherView.left;
        return weakSelf;
    };
}

- (YLEqualToView)bottom_equalTo {
    __weak typeof(self) weakSelf = self;
    return ^ (NSView *otherView) {
        weakSelf.bottom = otherView.bottom;
        return weakSelf;
    };
}

- (YLEqualToView)right_equalTo {
    __weak typeof(self) weakSelf = self;
    return ^ (NSView *otherView) {
        weakSelf.right = otherView.right;
        return weakSelf;
    };
}

- (YLEqualToView)width_equalTo {
    __weak typeof(self) weakSelf = self;
    return ^ (NSView *otherView) {
        weakSelf.width = otherView.width;
        return weakSelf;
    };
}

- (YLEqualToView)height_equalTo {
    __weak typeof(self) weakSelf = self;
    return ^ (NSView *otherView) {
        weakSelf.height = otherView.height;
        return weakSelf;
    };
}

- (YLEqualToView)size_equalTo {
    __weak typeof(self) weakSelf = self;
    return ^ (NSView *otherView) {
        weakSelf.size = otherView.size;
        return weakSelf;
    };
}

- (YLEqualToView)centerX_equalTo {
    __weak typeof(self) weakSelf = self;
    return ^ (NSView *otherView) {
        weakSelf.centerX = otherView.centerX;
        return weakSelf;
    };
}

- (YLEqualToView)centerY_equalTo {
    __weak typeof(self) weakSelf = self;
    return ^ (NSView *otherView) {
        weakSelf.centerY = otherView.centerY;
        return weakSelf;
    };
}

- (YLEqualToView)center_equalTo {
    __weak typeof(self) weakSelf = self;
    return ^ (NSView *otherView) {
        weakSelf.center = otherView.center;
        return weakSelf;
    };
}

- (YLEqualToViewWithOffset)x_equalWithOffset {
    __weak typeof(self) weakSelf = self;
    return ^ (NSView *otherView, CGFloat offset) {
        weakSelf.x = otherView.x + offset;
        return weakSelf;
    };
}

- (YLEqualToViewWithOffset)y_equalWithOffset {
    __weak typeof(self) weakSelf = self;
    return ^ (NSView *otherView, CGFloat offset) {
        weakSelf.y = otherView.y + offset;
        return weakSelf;
    };
}

- (YLEqualToViewWithOffset)top_equalWithOffset {
    __weak typeof(self) weakSelf = self;
    return ^ (NSView *otherView, CGFloat offset) {
        weakSelf.top = otherView.top + offset;
        return weakSelf;
    };
}

- (YLEqualToViewWithOffset)left_equalWithOffset {
    __weak typeof(self) weakSelf = self;
    return ^ (NSView *otherView, CGFloat offset) {
        weakSelf.left = otherView.left + offset;
        return weakSelf;
    };
}

- (YLEqualToViewWithOffset)bottom_equalWithOffset {
    __weak typeof(self) weakSelf = self;
    return ^ (NSView *otherView, CGFloat offset) {
        weakSelf.bottom = otherView.bottom + offset;
        return weakSelf;
    };
}

- (YLEqualToViewWithOffset)right_equalWithOffset {
    __weak typeof(self) weakSelf = self;
    return ^ (NSView *otherView, CGFloat offset) {
        weakSelf.right = otherView.right + offset;
        return weakSelf;
    };
}

- (YLEqualToViewWithOffset)centerX_equalWithOffset {
    __weak typeof(self) weakSelf = self;
    return ^ (NSView *otherView, CGFloat offset) {
        weakSelf.centerX = otherView.centerX + offset;
        return weakSelf;
    };
}

- (YLEqualToViewWithOffset)centerY_equalWithOffset {
    __weak typeof(self) weakSelf = self;
    return ^ (NSView *otherView, CGFloat offset) {
        weakSelf.centerY = otherView.centerY + offset;
        return weakSelf;
    };
}

- (YLEqualToSuperView)right_equalToSuper {
    __weak typeof(self) weakSelf = self;
    return ^ {
        weakSelf.right = weakSelf.superview.width;
        return weakSelf;
    };
}

- (YLEqualToSuperView)bottom_equalToSuper {
    __weak typeof(self) weakSelf = self;
    return ^ {
        weakSelf.bottom = weakSelf.superview.height;
        return weakSelf;
    };
}

- (YLEqualToSuperView)center_equalToSuper {
    __weak typeof(self) weakSelf = self;
    return ^ {
        weakSelf.center = weakSelf.superview.centerPoint;
        return weakSelf;
    };
}

- (YLEqualToSuperView)centerX_equalToSuper {
    __weak typeof(self) weakSelf = self;
    return ^ {
        weakSelf.centerX = weakSelf.superview.width / 2;
        return weakSelf;
    };
}

- (YLEqualToSuperView)centerY_equalToSuper {
    __weak typeof(self) weakSelf = self;
    return ^ {
        weakSelf.centerY = weakSelf.superview.height / 2;
        return weakSelf;
    };
}

- (YLSpaceToSuperView)top_spaceToSuper {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat space) {
        weakSelf.top = space;
        return weakSelf;
    };
}

- (YLSpaceToSuperView)left_spaceToSuper {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat space) {
        weakSelf.x = space;
        return weakSelf;
    };
}

- (YLSpaceToSuperView)bottom_spaceToSuper {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat space) {
        weakSelf.bottom = weakSelf.superview.height - space;
        return weakSelf;
    };
}

- (YLSpaceToSuperView)right_spaceToSuper {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat space) {
        weakSelf.right = weakSelf.superview.width - space;
        return weakSelf;
    };
}


- (YLSpaceToView)top_spaceTo {
    __weak typeof(self) weakSelf = self;
    return ^ (NSView *otherView, CGFloat space) {
        weakSelf.top = otherView.bottom + space;
        return weakSelf;
    };
}

- (YLSpaceToView)left_spaceTo {
    __weak typeof(self) weakSelf = self;
    return ^ (NSView *otherView, CGFloat space) {
        weakSelf.left = otherView.right + space;
        return weakSelf;
    };
}

- (YLSpaceToView)bottom_spaceTo {
    __weak typeof(self) weakSelf = self;
    return ^ (NSView *otherView, CGFloat space) {
        weakSelf.bottom = otherView.top - space;
        return weakSelf;
    };
}

- (YLSpaceToView)right_spaceTo {
    __weak typeof(self) weakSelf = self;
    return ^ (NSView *otherView, CGFloat space) {
        weakSelf.right = otherView.left - space;
        return weakSelf;
    };
}

- (YLEdgeToSuperView)edgeToSuper {
    __weak typeof(self) weakSelf = self;
    return ^ (CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
        NSRect frame = NSZeroRect;
        frame.size = NSMakeSize(weakSelf.superview.width - left - right, weakSelf.superview.height - top - bottom);
        frame.origin.x = left;
        frame.origin.y = top;
        weakSelf.frame = frame;
        return weakSelf;
    };
}



- (void)setX:(CGFloat)x {
    NSRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    NSRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width {
    NSRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    NSRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size {
    NSRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigin:(NSPoint)origin {
    NSRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (NSPoint)origin {
    return self.frame.origin;
}

- (void)setCenter:(NSPoint)center {
    NSRect frame = self.frame;
    frame.origin = NSMakePoint(center.x - self.frame.size.width / 2, center.y - self.frame.size.height / 2);
    self.frame = frame;
}

- (NSPoint)center {
    return NSMakePoint(self.frame.origin.x + self.frame.size.width / 2, self.frame.origin.y + self.frame.size.height / 2);
}

- (CGFloat)centerX {
    return NSMidX(self.frame);
}

- (void)setCenterX:(CGFloat)centerX {
    CGFloat centerY = self.center.y;
    self.center = NSMakePoint(centerX, centerY);
}

- (CGFloat)centerY {
    return NSMidY(self.frame);
}

- (void)setCenterY:(CGFloat)centerY {
    CGFloat centerX = self.center.x;
    self.center = NSMakePoint(centerX, centerY);
}

- (CGFloat)maxX {
    return NSMaxX(self.frame);
}

- (CGFloat)maxY {
    return NSMaxY(self.frame);
}

- (CGFloat)top {
    return self.y;
}

- (void)setTop:(CGFloat)top {
    self.y = top;
}

- (CGFloat)left {
    return self.x;
}

- (void)setLeft:(CGFloat)left {
    self.x = left;
}

- (CGFloat)bottom {
    return self.y + self.height;
}

- (void)setBottom:(CGFloat)bottom {
    self.y = bottom - self.height;
}

- (CGFloat)right {
    return self.maxX;
}

- (void)setRight:(CGFloat)right {
    NSRect frame = self.frame;
    frame.origin.x = right - self.width;
    self.frame = frame;
}

- (NSPoint)centerPoint {
    return NSMakePoint(self.width * 0.5, self.height * 0.5);
}

@end
