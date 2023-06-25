//
//  NSImageView+category.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2023/5/9.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSImageView (category)

/// 图片按比例缩放，填充最短边，裁剪并显示中间部分
- (void)aspectFill;

@end

NS_ASSUME_NONNULL_END
