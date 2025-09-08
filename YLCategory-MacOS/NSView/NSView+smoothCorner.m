//
//  NSView+smoothCorner.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2025/9/6.
//

#import "NSView+smoothCorner.h"
#import <objc/runtime.h>
#import <Quartz/Quartz.h>

#pragma mark - 四个角的半径

@interface NSViewMaskCorner : NSObject

@property (nonatomic, assign) CGFloat topLeft;
@property (nonatomic, assign) CGFloat topRight;
@property (nonatomic, assign) CGFloat bottomRight;
@property (nonatomic, assign) CGFloat bottomLeft;

- (instancetype)initWithValue:(CGFloat)value;
- (instancetype)initWithTopLeft:(CGFloat)topLeft
                       topRight:(CGFloat)topRight
                    bottomRight:(CGFloat)bottomRight
                     bottomLeft:(CGFloat)bottomLeft;

@end

@implementation NSViewMaskCorner

- (instancetype)initWithValue:(CGFloat)value {
    if (self = [super init]) {
        _topLeft = value;
        _topRight = value;
        _bottomRight = value;
        _bottomLeft = value;
    }
    return self;
}

- (instancetype)initWithTopLeft:(CGFloat)topLeft
                       topRight:(CGFloat)topRight
                    bottomRight:(CGFloat)bottomRight
                     bottomLeft:(CGFloat)bottomLeft {
    if (self = [super init]) {
        _topLeft = topLeft;
        _topRight = topRight;
        _bottomRight = bottomRight;
        _bottomLeft = bottomLeft;
    }
    return self;
}

@end

#pragma mark - 平滑圆角曲线

@interface NSViewCornerBezierPath : NSBezierPath

- (instancetype)initWithRect:(NSRect)rect corner:(NSViewMaskCorner *)corner;

/// 兼容旧系统，获取 CGPath
- (CGPathRef)cgPath;

@end

@implementation NSViewCornerBezierPath

- (instancetype)initWithRect:(NSRect)rect corner:(NSViewMaskCorner *)corner {
    self = [super init];
    if (self) {
        CGFloat coeff = 1.28195;
        NSPoint last = NSMakePoint(NSMaxX(rect), rect.origin.y);
        
        [self moveToPoint:NSMakePoint(rect.origin.x + corner.topLeft * coeff, last.y)];
        
        // top
        [self lineToPoint:NSMakePoint(last.x - corner.topRight * coeff, last.y)];
        
        // top right c1
        last = NSMakePoint(last.x - corner.topRight * coeff, last.y);
        [self curveToPoint:NSMakePoint(last.x + corner.topRight * 0.77037, last.y + corner.topRight * 0.13357)
             controlPoint1:NSMakePoint(last.x + corner.topRight * 0.44576, last.y)
             controlPoint2:NSMakePoint(last.x + corner.topRight * 0.6074, last.y + corner.topRight * 0.04641)];
        
        // top right c2
        last = NSMakePoint(last.x + corner.topRight * 0.77037, last.y + corner.topRight * 0.13357);
        [self curveToPoint:NSMakePoint(last.x + corner.topRight * 0.37801, last.y + corner.topRight * 0.37801)
             controlPoint1:NSMakePoint(last.x + corner.topRight * 0.16296, last.y + corner.topRight * 0.08715)
             controlPoint2:NSMakePoint(last.x + corner.topRight * 0.290086, last.y + corner.topRight * 0.2150)];
        
        // top right c3
        last = NSMakePoint(last.x + corner.topRight * 0.37801, last.y + corner.topRight * 0.37801);
        [self curveToPoint:NSMakePoint(last.x + corner.topRight * 0.13357, last.y + corner.topRight * 0.77037)
             controlPoint1:NSMakePoint(last.x + corner.topRight * 0.08715, last.y + corner.topRight * 0.16296)
             controlPoint2:NSMakePoint(last.x + corner.topRight * 0.13357, last.y + corner.topRight * 0.32461)];
        
        // right
        last = NSMakePoint(NSMaxX(rect), NSMaxY(rect));
        [self lineToPoint:NSMakePoint(last.x, last.y - corner.bottomRight * coeff)];
        
        // bottom right c1
        last = NSMakePoint(last.x, last.y - corner.bottomRight * coeff);
        [self curveToPoint:NSMakePoint(last.x - corner.bottomRight * 0.13357, last.y + corner.bottomRight * 0.77037)
             controlPoint1:NSMakePoint(last.x, last.y + corner.bottomRight * 0.44576)
             controlPoint2:NSMakePoint(last.x - corner.bottomRight * 0.04641, last.y + corner.bottomRight * 0.6074)];
        
        // bottom right c2
        last = NSMakePoint(last.x - corner.bottomRight * 0.13357, last.y + corner.bottomRight * 0.77037);
        [self curveToPoint:NSMakePoint(last.x - corner.bottomRight * 0.37801, last.y + corner.bottomRight * 0.37801)
             controlPoint1:NSMakePoint(last.x - corner.bottomRight * 0.08715, last.y + corner.bottomRight * 0.16296)
             controlPoint2:NSMakePoint(last.x - corner.bottomRight * 0.21505, last.y + corner.bottomRight * 0.290086)];
        
        // bottom right c3
        last = NSMakePoint(last.x - corner.bottomRight * 0.37801, last.y + corner.bottomRight * 0.37801);
        [self curveToPoint:NSMakePoint(last.x - corner.bottomRight * 0.77037, last.y + corner.bottomRight * 0.13357)
             controlPoint1:NSMakePoint(last.x - corner.bottomRight * 0.16296, last.y + corner.bottomRight * 0.08715)
             controlPoint2:NSMakePoint(last.x - corner.bottomRight * 0.32461, last.y + corner.bottomRight * 0.13357)];
        
        // bottom
        last = NSMakePoint(rect.origin.x, NSMaxY(rect));
        [self lineToPoint:NSMakePoint(last.x + corner.bottomLeft * coeff, last.y)];
        
        // bottom left c1
        last = NSMakePoint(last.x + corner.bottomLeft * coeff, last.y);
        [self curveToPoint:NSMakePoint(last.x - corner.bottomLeft * 0.77037, last.y - corner.bottomLeft * 0.13357)
             controlPoint1:NSMakePoint(last.x - corner.bottomLeft * 0.44576, last.y)
             controlPoint2:NSMakePoint(last.x - corner.bottomLeft * 0.6074, last.y - corner.bottomLeft * 0.04641)];
        
        // bottom left c2
        last = NSMakePoint(last.x - corner.bottomLeft * 0.77037, last.y - corner.bottomLeft * 0.13357);
        [self curveToPoint:NSMakePoint(last.x - corner.bottomLeft * 0.37801, last.y - corner.bottomLeft * 0.37801)
             controlPoint1:NSMakePoint(last.x - corner.bottomLeft * 0.16296, last.y - corner.bottomLeft * 0.08715)
             controlPoint2:NSMakePoint(last.x - corner.bottomLeft * 0.290086, last.y - corner.bottomLeft * 0.2150)];
        
        // bottom left c3
        last = NSMakePoint(last.x - corner.bottomLeft * 0.37801, last.y - corner.bottomLeft * 0.37801);
        [self curveToPoint:NSMakePoint(last.x - corner.bottomLeft * 0.13357, last.y - corner.bottomLeft * 0.77037)
             controlPoint1:NSMakePoint(last.x - corner.bottomLeft * 0.08715, last.y - corner.bottomLeft * 0.16296)
             controlPoint2:NSMakePoint(last.x - corner.bottomLeft * 0.13357, last.y - corner.bottomLeft * 0.32461)];
        
        // left
        [self lineToPoint:NSMakePoint(rect.origin.x, rect.origin.y + corner.topLeft * coeff)];
        
        // top left c1
        last = NSMakePoint(rect.origin.x, rect.origin.y + corner.topLeft * coeff);
        [self curveToPoint:NSMakePoint(last.x + corner.topLeft * 0.13357, last.y - corner.topLeft * 0.77037)
             controlPoint1:NSMakePoint(last.x, last.y - corner.topLeft * 0.44576)
             controlPoint2:NSMakePoint(last.x + corner.topLeft * 0.04641, last.y - corner.topLeft * 0.6074)];
        
        // top left c2
        last = NSMakePoint(last.x + corner.topLeft * 0.13357, last.y - corner.topLeft * 0.77037);
        [self curveToPoint:NSMakePoint(last.x + corner.topLeft * 0.37801, last.y - corner.topLeft * 0.37801)
             controlPoint1:NSMakePoint(last.x + corner.topLeft * 0.08715, last.y - corner.topLeft * 0.16296)
             controlPoint2:NSMakePoint(last.x + corner.topLeft * 0.21505, last.y - corner.topLeft * 0.290086)];
        
        // top left c3
        last = NSMakePoint(last.x + corner.topLeft * 0.37801, last.y - corner.topLeft * 0.37801);
        [self curveToPoint:NSMakePoint(last.x + corner.topLeft * 0.77037, last.y - corner.topLeft * 0.13357)
             controlPoint1:NSMakePoint(last.x + corner.topLeft * 0.16296, last.y - corner.topLeft * 0.08715)
             controlPoint2:NSMakePoint(last.x + corner.topLeft * 0.32461, last.y - corner.topLeft * 0.13357)];
        
        [self closePath];
    }
    return self;
}

- (CGPathRef)cgPath {
    NSInteger count = self.elementCount;
    CGMutablePathRef path = CGPathCreateMutable();
    NSPoint points[3];
    for (NSInteger i = 0; i < count; i++) {
        switch ([self elementAtIndex:i associatedPoints:points]) {
            case NSMoveToBezierPathElement:
                CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);
                break;
            case NSLineToBezierPathElement:
                CGPathAddLineToPoint(path, NULL, points[0].x, points[0].y);
                break;
            case NSCurveToBezierPathElement:
                CGPathAddCurveToPoint(path, NULL,
                                      points[0].x, points[0].y,
                                      points[1].x, points[1].y,
                                      points[2].x, points[2].y);
                break;
            case NSClosePathBezierPathElement:
                CGPathCloseSubpath(path);
                break;
            default:
                break;
        }
    }
    return path;
}

@end


#pragma mark - 平滑圆角

static const char kMaskLayerKey = '\0';
static const char kMaskCornerKey = '\0';
static const char kBorderLayerKey = '\0';

@implementation NSView (smoothCorner)

#pragma mark - Public

#pragma mark 同时设置4个平滑圆角
- (void)setSmoothCorner:(CGFloat)value {
    [self setSmoothCornerWithTopLeft:value topRight:value bottomRight:value bottomLeft:value];
}

#pragma mark 分别设置4个平滑圆角
- (void)setSmoothCornerWithTopLeft:(CGFloat)topLeft
                          topRight:(CGFloat)topRight
                       bottomRight:(CGFloat)bottomRight
                        bottomLeft:(CGFloat)bottomLeft {
    if (topLeft > 0 || topRight > 0 || bottomRight > 0 || bottomLeft > 0) {
        [self.class swizzleLayout];
        self.smoothCornerMaskCorner = [[NSViewMaskCorner alloc] initWithTopLeft:topLeft topRight:topRight bottomRight:bottomRight bottomLeft:bottomLeft];
        self.smoothCornerMaskLayer = [CAShapeLayer layer];
        self.wantsLayer = YES;
    } else {
        self.smoothCornerMaskCorner = nil;
        self.smoothCornerMaskLayer = nil;
        self.layer.mask = nil;
    }
    self.needsLayout = YES;
}

#pragma mark 设置平滑圆角边框的线宽和颜色
- (void)setSmoothCornerBorderColor:(NSColor *)borderColor borderWidth:(CGFloat)borderWidth {
    if (borderWidth > 0) {
        [self.class swizzleLayout];
        if (self.smoothCornerBorderLayer == nil) {
            self.smoothCornerBorderLayer = [CAShapeLayer layer];
            self.wantsLayer = YES;
            [self.layer insertSublayer:self.smoothCornerBorderLayer atIndex:0];
        }
        self.smoothCornerBorderLayer.lineWidth = borderWidth * 2;
        self.smoothCornerBorderLayer.strokeColor = [borderColor CGColor];
    } else {
        [self.smoothCornerBorderLayer removeFromSuperlayer];
        self.smoothCornerBorderLayer = nil;
    }
    self.needsLayout = YES;
}

#pragma mark - Drawing

- (void)drawSmoothCorner {
    CALayer *layer = self.layer;
    CAShapeLayer *maskLayer = self.smoothCornerMaskLayer;
    NSViewMaskCorner *corner = self.smoothCornerMaskCorner;
    if (!layer || !maskLayer || !corner) return;
    
    maskLayer.frame = layer.bounds;
    NSViewCornerBezierPath *bezierPath = [[NSViewCornerBezierPath alloc] initWithRect:maskLayer.bounds corner:corner];
    if (@available(macOS 14.0, *)) {
        maskLayer.path = bezierPath.CGPath;
    } else {
        maskLayer.path = bezierPath.cgPath;
    }
    layer.mask = maskLayer;
    
    if (self.smoothCornerBorderLayer) {
        self.smoothCornerBorderLayer.frame = layer.bounds;
        self.smoothCornerBorderLayer.fillColor = NSColor.clearColor.CGColor;
        self.smoothCornerBorderLayer.path = maskLayer.path;
        [self.layer insertSublayer:self.smoothCornerBorderLayer atIndex:0];
    }
}

#pragma mark - Swizzling

static BOOL smoothCornerLayoutDidSwizzle = NO;
+ (void)swizzleLayout {
    if (smoothCornerLayoutDidSwizzle)   return;
    Method originalLayout = class_getInstanceMethod(self, @selector(layout));
    Method swizzledLayout = class_getInstanceMethod(self, @selector(smoothCorner_layout));
    if (originalLayout && swizzledLayout) {
        method_exchangeImplementations(originalLayout, swizzledLayout);
        smoothCornerLayoutDidSwizzle = YES;
    }
}

- (void)smoothCorner_layout {
    [self smoothCorner_layout];
    [self drawSmoothCorner];
}

#pragma mark - Associated Objects

- (CAShapeLayer *)smoothCornerMaskLayer {
    return objc_getAssociatedObject(self, &kMaskLayerKey);
}
- (void)setSmoothCornerMaskLayer:(CAShapeLayer *)layer {
    objc_setAssociatedObject(self, &kMaskLayerKey, layer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSViewMaskCorner *)smoothCornerMaskCorner {
    return objc_getAssociatedObject(self, &kMaskCornerKey);
}
- (void)setSmoothCornerMaskCorner:(NSViewMaskCorner *)corner {
    objc_setAssociatedObject(self, &kMaskCornerKey, corner, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)smoothCornerBorderLayer {
    return objc_getAssociatedObject(self, &kBorderLayerKey);
}
- (void)setSmoothCornerBorderLayer:(CAShapeLayer *)layer {
    objc_setAssociatedObject(self, &kBorderLayerKey, layer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end


