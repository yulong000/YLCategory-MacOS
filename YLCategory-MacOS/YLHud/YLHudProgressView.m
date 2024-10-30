//
//  YLHudProgressView.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import "YLHudProgressView.h"

@implementation YLHudProgressView

- (void)setProgress:(CGFloat)progress {
    _progress = MIN(1, MAX(0, progress));;
    self.progressText = [NSString stringWithFormat:@"%d%%", (int)(_progress * 100)];
    [self setNeedsDisplay:YES];
}

- (BOOL)isFlipped {
    return YES;
}

- (void)setStyle:(YLHudStyle)style {
    _style = style;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    CGContextRef ctx = [NSGraphicsContext currentContext].CGContext;
    CGContextSetLineWidth(ctx, 2);
    if(self.style == YLHudStyleBlack) {
        [[NSColor whiteColor] set];
    } else {
        [[NSColor blackColor] set];
    }
    
    CGFloat centerX = NSMidX(self.bounds);
    CGFloat centerY = NSMidY(self.bounds);
    CGFloat radius1 = self.bounds.size.height / 2 - 2;
    CGFloat radius2 = radius1 - 3;
    
    // 外层的圆
    CGContextAddArc(ctx, centerX, centerY, radius1, 0, M_PI * 2, 0);
    CGContextStrokePath(ctx);
    
    // 内部的进度
    CGFloat end = M_PI * 2 * self.progress - M_PI_2;
    CGContextAddArc(ctx, centerX, centerY, radius2, - M_PI_2, end, 0);
    CGContextAddLineToPoint(ctx, centerX, centerY);
    CGContextAddLineToPoint(ctx, centerX, centerY - radius2);
    CGContextFillPath(ctx);
}


@end
