//
//  NSView+category.m
//  QQ
//
//  Created by 魏宇龙 on 2022/4/15.
//

#import "NSView+category.h"
#import <objc/runtime.h>

@implementation NSView (category)

- (void)setBackgroundColor:(NSColor *)backgroundColor {
    if(backgroundColor == nil) {
        self.wantsLayer = NO;
        self.layer.backgroundColor = nil;
    } else {
        self.wantsLayer = YES;
        self.layer.backgroundColor = backgroundColor.CGColor;
    }
}

- (NSColor *)backgroundColor {
    if(self.layer.backgroundColor) {
        return [NSColor colorWithCGColor:self.layer.backgroundColor];
    }
    return nil;
}

#pragma mark 移除所有子控件
- (void)removeAllSubviews {
    if([self isKindOfClass:[NSView class]] == NO)   return;
    for (NSView *sub in [NSArray arrayWithArray:self.subviews]) {
        [sub removeFromSuperview];
    }
}

#pragma mark 移除某一类子控件
- (void)removeSubviewsWithClass:(Class)classRemove {
    if([self isKindOfClass:[NSView class]] == NO)   return;
    if(classRemove == nil)  return;
    for (NSView *sub in [NSArray arrayWithArray:self.subviews]) {
        if([sub isKindOfClass:classRemove]) {
            [sub removeFromSuperview];
        }
    }
}

#pragma mark 添加一组子控件
- (void)addSubViewsFromArray:(NSArray *)subViews {
    [subViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[NSView class]]) {
            [self addSubview:obj];
        }
    }];
}

#pragma mark 监听鼠标的划入｜划出
- (NSTrackingArea *)addMouseTrackingAreaWithRect:(NSRect)rect owner:(id)owner {
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:rect options:NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited owner:owner userInfo:nil];
    [self addTrackingArea:trackingArea];
    return trackingArea;
}

#pragma mark 监听鼠标的划入｜划出整个区域
- (NSTrackingArea *)addMouseTracking {
    return [self addMouseTrackingAreaWithRect:self.bounds owner:self];
}

#pragma mark 移除所有的跟踪区域
- (void)removeAllTrackingArea {
    for (NSTrackingArea *area in self.trackingAreas) {
        [self removeTrackingArea:area];
    }
}

#pragma mark 设置边框
- (void)setBorderColor:(NSColor *)borderColor borderWidth:(CGFloat)borderWidth {
    self.wantsLayer = YES;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}

#pragma mark 设置圆角
- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.wantsLayer = YES;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}

#pragma mark 设置边框宽度
- (void)setBorderWidth:(CGFloat)borderWidth {
    self.wantsLayer = YES;
    self.layer.borderWidth = borderWidth;
}

#pragma mark 设置边框颜色
- (void)setBorderColor:(NSColor *)borderColor {
    self.wantsLayer = YES;
    self.layer.borderColor = borderColor.CGColor;
}

#pragma mark 设置边框和圆角
- (void)setBorderColor:(NSColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius {
    [self setBorderColor:borderColor borderWidth:borderWidth];
    [self setCornerRadius:cornerRadius];
}

#pragma mark 设置指定位置的圆角
- (void)setCornerRadius:(CGFloat)cornerRadius mask:(CACornerMask)mask {
    self.wantsLayer = YES;
    self.layer.masksToBounds = YES;
    self.layer.maskedCorners = mask;
    self.layer.cornerRadius = cornerRadius;
}

+ (instancetype)viewWithColor:(NSColor *)backgroundColor {
    NSView *view = [[self alloc] init];
    view.wantsLayer = YES;
    view.layer.backgroundColor = backgroundColor.CGColor;
    return view;
}

#pragma mark 截图
- (NSImage *)thumbImage {
    NSBitmapImageRep *rep = [self bitmapImageRepForCachingDisplayInRect:self.bounds];
    [self cacheDisplayInRect:self.bounds toBitmapImageRep:rep];
    NSImage *image = [[NSImage alloc] initWithSize:self.bounds.size];
    [image addRepresentation:rep];
    return image;
}

#pragma mark 视图控制器
- (NSViewController *)vc {
    return self.window.contentViewController;
}
#pragma mark 窗口控制器
- (NSWindowController *)wc {
    return self.window.windowController;
}
#pragma mark 屏幕
- (NSScreen *)screen {
    return self.window.screen;
}

@end
