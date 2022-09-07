//
//  NSButton+category.h
//  QQ
//
//  Created by 魏宇龙 on 2022/4/15.
//

#import <Cocoa/Cocoa.h>
#import "NSControl+category.h"

NS_ASSUME_NONNULL_BEGIN


@interface NSButton (category)

+ (instancetype)buttonWithImage:(NSImage *)image
                        handler:(NSControlClickedHandler _Nullable)handler;

+ (instancetype)buttonWithTitle:(NSString *)title
                        handler:(NSControlClickedHandler _Nullable)handler;

+ (instancetype)buttonWithTitle:(NSString *)title
                           font:(NSFont *_Nullable)font
                      textColor:(NSColor *_Nullable)textColor
                        handler:(NSControlClickedHandler _Nullable)handler;

+ (instancetype)buttonWithImage:(NSImage *_Nullable)image
                  imagePosition:(NSCellImagePosition)imagePosition
                          title:(NSString *_Nullable)title
                           font:(NSFont *_Nullable)font
                      textColor:(NSColor *_Nullable)textColor
                        handler:(NSControlClickedHandler _Nullable)handler;



@end

NS_ASSUME_NONNULL_END
