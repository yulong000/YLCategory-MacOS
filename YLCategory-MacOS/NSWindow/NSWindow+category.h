//
//  NSWindow+category.h
//  Paste
//
//  Created by 魏宇龙 on 2022/5/9.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSWindow (category)

/// 创建一个背景透明，隐藏3个btn，可全面拖动的window
+ (instancetype)windowWithClearBackground;

@end

NS_ASSUME_NONNULL_END
