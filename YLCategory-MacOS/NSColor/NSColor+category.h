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

/// 转成16进制字符串 #FFFFFF或者#FFFFFFAA
- (NSString *)hexString;
- (NSString *)hexStringWithAlpha;
- (NSString *)hexStringWithoutAlpha;

/// 将16进制字符串转换成NSColor
/// - Parameter hexStr: 16进制字符串，适配 
/// 1. #FFF
/// 2. #FFFA
/// 3. #FFFFFF
/// 4. #FFFFFFAA
/// 5. FFF
/// 6. FFFA
/// 7. FFFFFF
/// 8. FFFFFFAA
+ (nullable NSColor *)colorWithHexString:(NSString *)hexStr;

@end

NS_ASSUME_NONNULL_END
