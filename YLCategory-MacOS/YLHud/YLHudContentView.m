//
//  YLHudContentView.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import "YLHudContentView.h"

@implementation YLHudContentView

- (instancetype)initWithFrame:(NSRect)frameRect {
    if(self = [super initWithFrame:frameRect]) {
        self.wantsLayer = YES;
        self.layer.cornerRadius = 10;
        self.style = YLHudStyleBlack;
    }
    return self;
}

- (void)resetShadow {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 3;
    if(self.style == YLHudStyleBlack) {
        self.layer.backgroundColor = [NSColor colorWithRed:0 green:0 blue:0 alpha:0.9].CGColor;
        shadow.shadowColor = [NSColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    } else {
        self.layer.backgroundColor = [NSColor colorWithRed:1 green:1 blue:1 alpha:0.9].CGColor;
        shadow.shadowColor = [NSColor colorWithRed:1 green:1 blue:1 alpha:0.4];
    }
    self.shadow = shadow;
}

- (BOOL)isFlipped {
    return YES;
}

- (void)setStyle:(YLHudStyle)style {
    _style = style;
    [self resetShadow];
}

@end
