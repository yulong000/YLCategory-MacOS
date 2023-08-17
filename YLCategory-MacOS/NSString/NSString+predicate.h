
#import <Foundation/Foundation.h>

@interface NSString (predicate)


/// 匹配正则表达式
/// @param regex 正则
- (BOOL)isValidateByRegex:(NSString *)regex;

/**
 *  手机号有效性，11位
 *   ^(\\+?0?86\\-?)?1[3-9][0-9]\\d{8}$         // +86开头的手机号
 */
- (BOOL)isMobileNumber;

/**
 *  邮箱的有效性
 */
- (BOOL)isEmailAddress;

/**
 *  简单的身份证有效性
 *
 */
- (BOOL)isIdentityCardNumForHazy;

/**
 *  精确的身份证号码有效性检测
 *
 */
- (BOOL)isIdentityCardNum;

/**
 *  车牌号的有效性
 */
- (BOOL)isCarNumber;

/**
 *  银行卡的有效性
 */
- (BOOL)bankCardluhmCheck;

/**
 纯数字
 */
- (BOOL)isNumberText;

/**
  价格字符串, 保留2位小数
 */
- (BOOL)isPriceText;


/// 只包含字母和数字
- (BOOL)isNumberOrChar;


/// 密码校验  (数字和字母组合)
/// @param minLength 最小长度
/// @param maxLength 最大长度
- (BOOL)isPasswordWithMinLength:(NSUInteger)minLength maxLength:(NSUInteger)maxLength;


///密码校验 6-20位数字字母组合
- (BOOL)isPassword;

@end
