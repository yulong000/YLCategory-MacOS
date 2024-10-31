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
        self.layer.masksToBounds = NO;
        self.style = YLHudStyleBlack;
    }
    return self;
}

- (BOOL)isFlipped {
    return YES;
}

- (void)setStyle:(YLHudStyle)style {
    _style = style;
    if(self.style == YLHudStyleBlack) {
        self.layer.backgroundColor = [NSColor colorWithRed:0 green:0 blue:0 alpha:0.8].CGColor;
    } else {
        self.layer.backgroundColor = [NSColor colorWithRed:1 green:1 blue:1 alpha:0.8].CGColor;
    }
}

@end
