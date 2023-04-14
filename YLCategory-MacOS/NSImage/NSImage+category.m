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
    if(originSize.width == 0 || originSize.height == 0 || size.width == 0 || size.height == 0) {
        return [[NSImage alloc] initWithSize:size];
    }
    NSImage *image = nil;
    NSRect rect = NSMakeRect(0, 0, size.width * [NSScreen mainScreen].backingScaleFactor, size.height * [NSScreen mainScreen].backingScaleFactor);
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge  CFDataRef)self.TIFFRepresentation, NULL);
    if(source == nil) {
        return [[NSImage alloc] initWithSize:size];
    }
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
    CFRelease(source);
    CGContextRef context = CGBitmapContextCreate(NULL, rect.size.width, rect.size.height, 8, 0, [NSColorSpace genericRGBColorSpace].CGColorSpace, kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, rect, imageRef);
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    image = [[NSImage alloc] initWithCGImage:cgImage size:rect.size];
    CGImageRelease(cgImage);
    CGImageRelease(imageRef);
    return image;
}

@end
