//
//  NSString+category.m
//  QQ
//
//  Created by 魏宇龙 on 2022/4/15.
//

#import "NSString+category.h"

@implementation NSString (category)

#pragma mark 去掉首部的字符集合
- (NSString *)stringByTrimmingPrefixCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger index = 0;
    unichar charBuffer[self.length];
    [self getCharacters:charBuffer];
    for (NSInteger i = 0; i < self.length; i ++) {
        if([characterSet characterIsMember:charBuffer[i]] == NO) {
            index = i;
            break;
        }
    }
    return [self substringFromIndex:index];
}
#pragma mark 去掉尾部的字符集合
- (NSString *)stringByTrimmingSuffixCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger index = 0;
    unichar charBuffer[self.length];
    [self getCharacters:charBuffer];
    for (NSUInteger i = self.length; i > 0; i --) {
        if([characterSet characterIsMember:charBuffer[i - 1]] == NO) {
            index = i;
            break;
        }
    }
    return [self substringToIndex:index];
}

#pragma mark 去掉首部的空格
- (NSString *)stringByTrimmingPrefixWhitespace {
    return [self stringByTrimmingPrefixCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
#pragma mark 去掉尾部的空格
- (NSString *)stringByTrimmingSuffixWhitespace {
    return [self stringByTrimmingSuffixCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
#pragma mark 去掉尾部的空格和换行
- (NSString *)stringByTrimmingSuffixWhitespaceAndNewline {
    return [self stringByTrimmingSuffixCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


#pragma mark 获取传入字符串的范围
- (NSArray<NSValue *> *)rangesOfString:(NSString *)string {
    return [self matchWithRegular:string options:NSRegularExpressionIgnoreMetacharacters];
}

- (NSArray<NSValue *> *)matchWithRegular:(NSString *)regular options:(NSRegularExpressionOptions)options {
    if(self == nil || regular == nil) return @[];
    NSError *error = nil;
    NSRegularExpression *exp = [NSRegularExpression regularExpressionWithPattern:regular options:options error:&error];
    if(error) {
        return @[];
    }
    NSArray *resultArr = [exp matchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length)];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSTextCheckingResult *result in resultArr) {
        for (int i = 0; i < result.numberOfRanges; i ++) {
            NSRange range = [result rangeAtIndex:i];
            if(range.location != NSNotFound && range.length > 0) {
                [arr addObject:[NSValue valueWithRange:range]];
            }
        }
    }
    return arr;
}

@end
