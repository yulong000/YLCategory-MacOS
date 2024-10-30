//
//  YLWindowButton.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import "YLWindowButton.h"
#import <AppKit/AppKit.h>

#ifndef RGBA
#define RGBA(r, g, b, a) [NSColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]
#endif

@interface YLWindowButton ()

/// 窗口全屏
@property (nonatomic, assign, getter=isWindowFullScreen) BOOL windowFullScreen;

@end

@implementation YLWindowButton

+ (instancetype)buttonWithType:(YLWindowButtonType)buttonType {
    return [[self alloc] initWithType:buttonType];
}

- (instancetype)initWithType:(YLWindowButtonType)buttonType {
    if(self = [super init]) {
        self.buttonType = buttonType;
    }
    return self;
}

- (void)setButtonType:(YLWindowButtonType)buttonType {
    _buttonType = buttonType;
    self.hover = NO;
    self.needsDisplay = YES;
}

#pragma mark - 监听窗口的状态变化，更改按钮的状态

- (void)viewDidMoveToWindow {
    [super viewDidMoveToWindow];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidBecomeActive:) name:NSWindowDidBecomeKeyNotification object:self.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResignActive:) name:NSWindowDidResignKeyNotification object:self.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidFullScreen:) name:NSWindowDidEnterFullScreenNotification object:self.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidExiteFullScreen:) name:NSWindowDidExitFullScreenNotification object:self.window];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)windowDidBecomeActive:(NSNotification *)noti {
    self.active = YES;
}

- (void)windowDidResignActive:(NSNotification *)noti {
    self.active = NO;
}

- (void)windowDidFullScreen:(NSNotification *)noti {
    self.windowFullScreen = YES;
}

- (void)windowDidExiteFullScreen:(NSNotification *)noti {
    self.windowFullScreen = NO;
}

- (void)setActive:(BOOL)active {
    _active = active;
    self.needsDisplay = YES;
}

- (void)setWindowFullScreen:(BOOL)windowFullScreen {
    _windowFullScreen = windowFullScreen;
    self.needsDisplay = YES;
}

#pragma mark - 鼠标滑入｜滑出

- (void)setIgnoreMouseHover:(BOOL)ignoreMouseHover {
    _ignoreMouseHover = ignoreMouseHover;
    [self updateTrackingAreas];
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    // 先移除
    for (NSTrackingArea *area in self.trackingAreas) {
        [self removeTrackingArea:area];
    }
    if(self.ignoreMouseHover == NO) {
        // 再添加
        NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited owner:self userInfo:nil];
        [self addTrackingArea:trackingArea];
    }
}

- (void)mouseEntered:(NSEvent *)event {
    self.hover = YES;
}

- (void)mouseExited:(NSEvent *)event {
    self.hover = NO;
}

- (void)setHover:(BOOL)hover {
    _hover = hover;
    self.needsDisplay = YES;
}

#pragma mark - 响应点击事件

- (void)mouseDown:(NSEvent *)event {
    if(self.enabled) {
        [self.window makeFirstResponder:self];
    }
    [super mouseDown:event];
}

- (void)mouseUp:(NSEvent *)event {
    if(self.enabled) {
        [NSApp sendAction:self.action to:self.target from:self];
    }
    [super mouseUp:event];
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    return YES;
}

#pragma mark - 绘制内容

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    NSGradient *bgGradient;
    NSColor *strokeColor;
    NSColor *symbolColor;
    switch (self.buttonType) {
        case YLWindowButtonTypeClose: {
            bgGradient = [[NSGradient alloc] initWithStartingColor:RGBA(255, 95, 86, 1) endingColor:RGBA(255, 99, 91, 1)];
            strokeColor = RGBA(226, 62, 55, 1);
            symbolColor = RGBA(77, 0, 0, 1);
        }
            break;
        case YLWindowButtonTypeMini: {
            bgGradient = [[NSGradient alloc] initWithStartingColor:RGBA(255, 189, 46, 1) endingColor:RGBA(255, 197, 47, 1)];
            strokeColor = RGBA(223, 157, 24, 1);
            symbolColor = RGBA(153, 88, 1, 1);
        }
            break;
        case YLWindowButtonTypeFullScreen:
        case YLWindowButtonTypeExitFullScreen: {
            bgGradient = [[NSGradient alloc] initWithStartingColor:RGBA(39, 201, 63, 1) endingColor:RGBA(39, 208, 65, 1)];
            strokeColor = RGBA(46, 176, 60, 1);
            symbolColor = RGBA(1, 100, 0, 1);
        }
            break;
        default:
            break;
    }
    if(self.isActive == NO && self.isHover == NO) {
        bgGradient = [[NSGradient alloc] initWithStartingColor:RGBA(79, 83, 79, 1) endingColor:RGBA(75, 79, 75, 1)];
        strokeColor = RGBA(65, 65, 65, 1);
    }
    
    if(self.buttonType == YLWindowButtonTypeMini && self.isWindowFullScreen) {
        bgGradient = [[NSGradient alloc] initWithStartingColor:RGBA(94, 98, 94, 1) endingColor:RGBA(90, 94, 90, 1)];
        strokeColor = RGBA(80, 80, 80, 1);
    }
    
    NSBezierPath *path = [[NSBezierPath alloc] init];
    [path appendBezierPathWithOvalInRect:NSMakeRect(0.5, 0.5, width - 1, height - 1)];
    [bgGradient drawInBezierPath:path relativeCenterPosition:NSZeroPoint];
    [strokeColor setStroke];
    path.lineWidth = 0.5;
    [path stroke];
    
    if(self.buttonType == YLWindowButtonTypeMini && self.isWindowFullScreen) {
        return;
    }
    
    if(self.isHover) {
        switch (self.buttonType) {
            case YLWindowButtonTypeClose: {
                NSBezierPath *path = [[NSBezierPath alloc] init];
                [path moveToPoint:NSMakePoint(width * 0.3, height * 0.3)];
                [path lineToPoint:NSMakePoint(width * 0.7, height * 0.7)];
                [path moveToPoint:NSMakePoint(width * 0.7, height * 0.3)];
                [path lineToPoint:NSMakePoint(width * 0.3, height * 0.7)];
                path.lineWidth = 1;
                [symbolColor setStroke];
                [path stroke];
            }
                break;
            case YLWindowButtonTypeMini: {
                [NSGraphicsContext currentContext].shouldAntialias = NO;
                NSBezierPath *path = [[NSBezierPath alloc] init];
                [path moveToPoint:NSMakePoint(width * 0.2, height * 0.5)];
                [path lineToPoint:NSMakePoint(width * 0.8, height * 0.5)];
                path.lineWidth = 2;
                [symbolColor setStroke];
                [path stroke];
                [NSGraphicsContext currentContext].shouldAntialias = YES;
            }
                break;
            case YLWindowButtonTypeFullScreen: {
                NSBezierPath *path = [[NSBezierPath alloc] init];
                [path moveToPoint:NSMakePoint(width * 0.25, height * 0.75)];
                [path lineToPoint:NSMakePoint(width * 0.25, height / 3)];
                [path lineToPoint:NSMakePoint(width * 2 / 3, height * 0.75)];
                [path closePath];
                [symbolColor setFill];
                [path fill];
                [path moveToPoint:NSMakePoint(width * 0.75, height * 0.25)];
                [path lineToPoint:NSMakePoint(width * 0.75, height * 2 / 3)];
                [path lineToPoint:NSMakePoint(width / 3, height * 0.25)];
                [path closePath];
                [symbolColor setFill];
                [path fill];
            }
                break;
            case YLWindowButtonTypeExitFullScreen: {
                NSBezierPath *path = [[NSBezierPath alloc] init];
                [path moveToPoint:NSMakePoint(width * 0.1, height * 0.52)];
                [path lineToPoint:NSMakePoint(width * 0.48, height * 0.52)];
                [path lineToPoint:NSMakePoint(width * 0.48, height * 0.9)];
                [path closePath];
                [symbolColor setFill];
                [path fill];
                [path moveToPoint:NSMakePoint(width * 0.9, height * 0.48)];
                [path lineToPoint:NSMakePoint(width * 0.52, height * 0.48)];
                [path lineToPoint:NSMakePoint(width * 0.52, height * 0.1)];
                [path closePath];
                [symbolColor setFill];
                [path fill];
            }
                break;
            default:
                break;
        }
    }
}

@end
