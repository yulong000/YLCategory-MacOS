//
//  NSImageView+category.m
//  Paste
//
//  Created by 魏宇龙 on 2022/5/24.
//

#import "NSImageView+category.h"

@implementation NSImageView (category)

- (void)aspectFill {
    CGFloat imageWidth = self.image.size.width;
    CGFloat imageHeight = self.image.size.height;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    if(self.image == nil || imageWidth == 0 || imageHeight == 0)   return;
    if(width == 0 || height == 0)   return;
    
    NSRect rect = NSZeroRect;
    if(imageWidth / imageHeight > width / height) {
        // 图片比较宽，需要左右裁切
        rect.size.height = imageHeight;
        rect.size.width = width / height * imageHeight;
    } else {
        // 上下裁切
        rect.size.width = imageWidth;
        rect.size.height = height / width * imageWidth;
    }
    rect.origin.x = (imageWidth - rect.size.width) / 2;
    rect.origin.y = (imageHeight - rect.size.height) / 2;
    
    NSImage *resultImage = [[NSImage alloc] initWithSize:self.frame.size];
    [resultImage lockFocus];
    [self.image drawInRect:NSMakeRect(0, 0, width, height) fromRect:rect operation:NSCompositingOperationCopy fraction:1.0 respectFlipped:YES hints:nil];
    [resultImage unlockFocus];
    self.image = resultImage;
}

@end
