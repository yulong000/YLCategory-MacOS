//
//  NSButton+category.m
//  QQ
//
//  Created by 魏宇龙 on 2022/4/15.
//

#import "NSButton+category.h"

@implementation NSButton (category)

+ (instancetype)buttonWithImage:(NSImage *)image handler:(NSControlClickedHandler)handler {
    return [self buttonWithImage:image imagePosition:NSImageOnly title:nil font:nil textColor:nil handler:handler];
}

+ (instancetype)buttonWithTitle:(NSString *)title handler:(NSControlClickedHandler)handler {
    return [self buttonWithTitle:title font:nil textColor:nil handler:handler];
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
    NSButton *btn = [[super alloc] init];
    btn.bordered = NO;
    if(title) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if(font) {
            params[NSFontAttributeName] = font;
        }
        if(textColor) {
            params[NSForegroundColorAttributeName] = textColor;
        }
        if(params.allKeys.count > 0) {
            btn.attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:params];
        } else {
            btn.title = title;
        }
    }
    if(image) {
        btn.image = image;
        btn.imageScaling = NSImageScaleProportionallyUpOrDown;
        btn.imagePosition = imagePosition;
    }
    btn.clickedHandler = handler;
    return btn;
}

@end
