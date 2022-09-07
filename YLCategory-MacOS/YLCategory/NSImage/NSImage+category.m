//
//  NSImage+category.m
//  Paste
//
//  Created by 魏宇龙 on 2022/5/1.
//

#import "NSImage+category.h"

@implementation NSImage (category)

- (NSImage *)renderWithColor:(NSColor *)color {
    NSImage *img = [self copy];
    [img lockFocus];
    [color set];
    NSRect rect = NSMakeRect(0, 0, self.size.width, self.size.height);
    NSRectFillUsingOperation(rect, NSCompositingOperationSourceAtop);
    [img unlockFocus];
    return img;
}

- (NSImage *)resize:(NSSize)size {
    CGSize originSize = self.size;
    if(originSize.width == 0 || originSize.height == 0) {
        return [[NSImage alloc] initWithSize:size];
    }
    NSRect rect = NSMakeRect(0, 0, size.width, size.height);
    NSImage *image = [[NSImage alloc] initWithSize:rect.size];
    [image lockFocus];
    if(@available(macOS 10.15.0, *)){} else {
        NSAffineTransform *transform = [NSAffineTransform transform];
        [transform scaleXBy:1.0 yBy:-1.0];
        [transform translateXBy:0 yBy:-size.height];
        [transform concat];
    }
    [self drawInRect:rect fromRect:NSZeroRect operation:NSCompositingOperationCopy fraction:1.0];
    [image unlockFocus];
    return image;
}

@end
