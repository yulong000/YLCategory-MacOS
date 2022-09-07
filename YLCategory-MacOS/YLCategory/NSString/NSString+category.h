//
//  NSString+category.h
//  QQ
//
//  Created by 魏宇龙 on 2022/4/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (category)

/// 去掉首部的字符集合
- (NSString *)stringByTrimmingPrefixCharactersInSet:(NSCharacterSet *)characterSet;
/// 去掉尾部的字符集合
- (NSString *)stringByTrimmingSuffixCharactersInSet:(NSCharacterSet *)characterSet;

/// 去掉首部的空格
- (NSString *)stringByTrimmingPrefixWhitespace;
/// 去掉尾部的空格
- (NSString *)stringByTrimmingSuffixWhitespace;
/// 去掉尾部的空格和换行
- (NSString *)stringByTrimmingSuffixWhitespaceAndNewline;

/*
   //忽略大小写 "AA"相当于"aa"
   NSRegularExpressionCaseInsensitive             = 1 << 0,
   //忽略空格和#后面的注释 "A B#AA"相当于"AB"
   NSRegularExpressionAllowCommentsAndWhitespace  = 1 << 1,
   //将整个模式视为文字字符串 "AA\\b"其中的\\b不会当成匹配边界，而是字符串
   NSRegularExpressionIgnoreMetacharacters        = 1 << 2,
   //允许.匹配任何字符，包括行分隔符。"a.b"可以匹配"a\nb"
   NSRegularExpressionDotMatchesLineSeparators    = 1 << 3,
   //允许^和$匹配行的开头和结尾(这个好像是一直生效的)
   NSRegularExpressionAnchorsMatchLines           = 1 << 4,
   //仅将\n视为行分隔符，否则，将使用所有标准行分隔符
   NSRegularExpressionUseUnixLineSeparators       = 1 << 5,
   //使用Unicode TR#29指定单词边界，否则，使用传统的正则表达式单词边界
   NSRegularExpressionUseUnicodeWordBoundaries    = 1 << 6
*/

/// 正则匹配
/// @param regular 正则表达式
/// @param options 匹配选项
- (NSArray <NSValue *> *)matchWithRegular:(NSString *)regular options:(NSRegularExpressionOptions)options;
/// 获取传入字符串的范围
- (NSArray <NSValue *> *)rangesOfString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
