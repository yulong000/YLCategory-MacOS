//
//  YLWindowOperateView.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import "YLWindowOperateView.h"

#define kYLWindowButtonWH       13.0

@interface YLWindowOperateView ()

@property (nonatomic, strong) NSArray <YLWindowButtonOperateType> *buttonTypes;

@end

@implementation YLWindowOperateView

+ (instancetype)opreateViewWithButtonTypes:(NSArray<YLWindowButtonOperateType> *)buttonTypes {
    return [[self alloc] initWithButtonTypes:buttonTypes];
}

- (instancetype)initWithButtonTypes:(NSArray<YLWindowButtonOperateType> *)buttonTypes {
    if(self = [super init]) {
        self.buttonTypes = buttonTypes;
        for (int i = 0; i < buttonTypes.count; i ++) {
            YLWindowButtonType buttonType = [buttonTypes[i] integerValue];
            if(buttonType == YLWindowButtonTypeExitFullScreen) {
                // 退出全屏
                continue;
            }
            YLWindowButton *btn = [YLWindowButton buttonWithType:buttonType];
            btn.ignoreMouseHover = YES;
            btn.target = self;
            btn.action = @selector(operateButtonClicked:);
            [self addSubview:btn];
        }
        self.frame = NSMakeRect(0, 0, self.subviews.count * (kYLWindowButtonWH + 7.5) - 7.5, 15);
    }
    return self;
}

- (BOOL)isFlipped {
    return YES;
}

- (void)layout {
    [super layout];
    CGFloat left = 0;
    NSRect frame = NSMakeRect(0, 0, kYLWindowButtonWH, kYLWindowButtonWH);
    frame.origin.y = (self.bounds.size.height - kYLWindowButtonWH) / 2;
    for (YLWindowButton *sub in self.subviews) {
        if([sub isKindOfClass:[YLWindowButton class]]) {
            frame.origin.x = left;
            sub.frame = frame;
            left = CGRectGetMaxX(frame) + 7.5;
        }
    }
}

#pragma mark - 鼠标滑入｜滑出

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    // 先移除
    for (NSTrackingArea *area in self.trackingAreas) {
        [self removeTrackingArea:area];
    }
    // 再添加
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
}

- (void)mouseEntered:(NSEvent *)event {
    for (YLWindowButton *sub in self.subviews) {
        if([sub isKindOfClass:[YLWindowButton class]]) {
            sub.hover = YES;
        }
    }
}

- (void)mouseExited:(NSEvent *)event {
    for (YLWindowButton *sub in self.subviews) {
        if([sub isKindOfClass:[YLWindowButton class]]) {
            sub.hover = NO;
        }
    }
}

#pragma mark - 按钮的点击
- (void)operateButtonClicked:(YLWindowButton *)btn {
    switch (btn.buttonType) {
        case YLWindowButtonTypeClose:{
            [self.window performClose:btn];
        }
            break;
        case YLWindowButtonTypeMini: {
            [self.window performMiniaturize:btn];
        }
            break;
        case YLWindowButtonTypeFullScreen: {
            [self.window toggleFullScreen:btn];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                btn.buttonType = YLWindowButtonTypeExitFullScreen;
            });
        }
            break;
        case YLWindowButtonTypeExitFullScreen: {
            [self.window toggleFullScreen:btn];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                btn.buttonType = YLWindowButtonTypeFullScreen;
            });
        }
            break;
        default:
            break;
    }
    for (YLWindowButton *sub in self.subviews) {
        if([sub isKindOfClass:[YLWindowButton class]]) {
            sub.hover = NO;
        }
    }
    if(self.clickHandler) {
        self.clickHandler(btn.buttonType);
    }
}

- (YLWindowButton *)buttonWithType:(YLWindowButtonType)buttonType {
    for (YLWindowButton *sub in self.subviews) {
        if([sub isKindOfClass:[YLWindowButton class]]) {
            if(sub.buttonType == buttonType) {
                return sub;
            }
        }
    }
    return nil;
}

@end
