//
//  NSColor+category.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2023/9/5.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSColor * _Nonnull (^NSColorAlphaHanlder)(CGFloat alpha);

@interface NSColor (category)

/// 返回带透明度的color,  等同于  colorWithAlphaComponent:
@property (nonatomic, readonly) NSColorAlphaHanlder alpha;

/// 适配暗色｜亮色主题
/// macOS 10.15有效，10.15之前只显示亮色
/// - Parameters:
///   - light: 亮色
///   - dark: 暗色
+ (NSColor *)light:(NSColor *)light dark:(NSColor *)dark;

@end

NS_ASSUME_NONNULL_END
