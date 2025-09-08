//
//  NSButton+category.m
//  QQ
//
//  Created by 魏宇龙 on 2022/4/15.
//

#import "NSButton+category.h"

@implementation NSButton (category)

+ (instancetype)buttonWithImage:(NSImage *)image handler:(NSControlClickedHandler)handler {
    NSButton *btn = [self buttonWithImage:image target:nil action:nil];
    btn.bordered = NO;
    btn.clickedHandler = handler;
    return btn;
}

+ (instancetype)buttonWithTitle:(NSString *)title handler:(NSControlClickedHandler)handler {
    NSButton *btn = [self buttonWithTitle:title target:nil action:nil];
    btn.bordered = NO;
    btn.clickedHandler = handler;
    return btn;
}

+ (instancetype)buttonWithTitle:(NSString *)title
                           font:(NSFont * _Nullable)font
                      textColor:(NSColor * _Nullable)textColor
                        handler:(NSControlClickedHandler _Nullable)handler {
    return [self buttonWithImage:nil imagePosition:NSNoImage title:title font:font textColor:textColor handler:handler];
}

+ (instancetype)buttonWithImage:(NSImage *)image
                  imagePosition:(NSCellImagePosition)imagePosition
                          title:(NSString * _Nullable)title
                           font:(NSFont * _Nullable)font
                      textColor:(NSColor * _Nullable)textColor
                        handler:(NSControlClickedHandler _Nullable)handler {
    NSButton *btn = [[self alloc] init];
    btn.bordered = NO;
    btn.title = title ?: @"";
    btn.font = font;
    btn.contentTintColor = textColor;
    if(image) {
        btn.image = image;
        btn.imageScaling = NSImageScaleProportionallyUpOrDown;
        btn.imagePosition = imagePosition;
    }
    btn.clickedHandler = handler;
    return btn;
}

@end
