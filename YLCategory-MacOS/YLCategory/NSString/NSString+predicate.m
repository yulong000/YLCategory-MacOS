
#import "NSString+predicate.h"

@implementation NSString (predicate)

#pragma mark - 正则相关
- (BOOL)isValidateByRegex:(NSString *)regex {
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}

#pragma mark 手机号有效性
- (BOOL)isMobileNumber {
    return [self isValidateByRegex:@"^(1[3-9][0-9])\\d{8}$"];
}

#pragma mark 邮箱
- (BOOL)isEmailAddress {
    return [self isValidateByRegex:@"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}

#pragma mark 身份证号模糊匹配
- (BOOL)isIdentityCardNumForHazy {
    return [self isValidateByRegex:@"^\\d{17}(\\d|[xX])$"];
}

#pragma mark 车牌
- (BOOL)isCarNumber {
    //车牌号:湘K-DE829 香港车牌号码:粤Z-J499港
    return [self isValidateByRegex:@"^[\u4e00-\u9fff]{1}[a-zA-Z]{1}[-][a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fff]$"];
}

#pragma mark 精确的身份证号码有效性检测
- (BOOL)isIdentityCardNum {
    if([self isIdentityCardNumForHazy] == NO)   return NO;
    // 匹配省份
    NSString *province = [self substringToIndex:2];
    NSArray *povinceArray = @[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    BOOL flag = NO;
    for (NSString *p in povinceArray) {
        if ([p isEqualToString:province]) {
            flag = YES;
            break;
        }
    }
    if (!flag) {
        return NO;
    }
    
    // 匹配年份
    NSString *yearString = [self substringWithRange:NSMakeRange(6, 4)];
    if([yearString isValidateByRegex:@"^(18|19|20)[0-9]{2}$"] == NO) return NO;
    // 匹配日月
    NSString *dayString = [self substringWithRange:NSMakeRange(10, 4)];
    if([[dayString substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"02"]) {
        // 2月份
        int year = yearString.intValue;
        if (year % 4 == 0 || (year % 100 == 0 && year % 4 == 0)) {
            // 闰年， 29天
            if([dayString isValidateByRegex:@"^02(0[1-9]|[1-2][0-9])$"] == NO) return NO;
        }else {
            // 非闰年, 28天
            if([dayString isValidateByRegex:@"^02(0[1-9]|1[0-9]|2[0-8])$"] == NO) return NO;
        }
    } else {
        // 其他月
        if([dayString isValidateByRegex:@"(01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)"] == NO) return NO;
    }
    
    // 校验位
    NSString *last = [[self substringWithRange:NSMakeRange(17, 1)] uppercaseString];
    int num[] = {7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2};
    int sum = 0;
    for (int i = 0; i < 17; i ++) {
        sum += [[self substringWithRange:NSMakeRange(i, 1)] intValue] * num[i];
    }
    return [[@"10X98765432" substringWithRange:NSMakeRange(sum % 11, 1)] isEqualToString:last];
}

#pragma mark 银行卡号
/** 银行卡号有效性问题Luhn算法
 *  现行 16 位银联卡现行卡号开头 6 位是 622126～622925 之间的，7 到 15 位是银行自定义的，
 *  可能是发卡分行，发卡网点，发卡序号，第 16 位是校验码。
 *  16 位卡号校验位采用 Luhm 校验方法计算：
 *  1，将未带校验位的 15 位卡号从右依次编号 1 到 15，位于奇数位号上的数字乘以 2
 *  2，将奇位乘积的个十位全部相加，再加上所有偶数位上的数字
 *  3，将加法和加上校验位能被 10 整除。
 */
- (BOOL)bankCardluhmCheck {
    NSString * lastNum = [[self substringFromIndex:(self.length-1)] copy];//取出最后一位
    NSString * forwardNum = [[self substringToIndex:(self.length -1)] copy];//前15或18位
    
    NSMutableArray * forwardArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<forwardNum.length; i++) {
        NSString * subStr = [forwardNum substringWithRange:NSMakeRange(i, 1)];
        [forwardArr addObject:subStr];
    }
    
    NSMutableArray * forwardDescArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = (int)(forwardArr.count-1); i> -1; i--) {//前15位或者前18位倒序存进数组
        [forwardDescArr addObject:forwardArr[i]];
    }
    
    NSMutableArray * arrOddNum = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 < 9
    NSMutableArray * arrOddNum2 = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 > 9
    NSMutableArray * arrEvenNum = [[NSMutableArray alloc] initWithCapacity:0];//偶数位数组
    
    for (int i=0; i< forwardDescArr.count; i++) {
        NSInteger num = [forwardDescArr[i] intValue];
        if (i%2) {//偶数位
            [arrEvenNum addObject:[NSNumber numberWithInteger:num]];
        }else{//奇数位
            if (num * 2 < 9) {
                [arrOddNum addObject:[NSNumber numberWithInteger:num * 2]];
            }else{
                NSInteger decadeNum = (num * 2) / 10;
                NSInteger unitNum = (num * 2) % 10;
                [arrOddNum2 addObject:[NSNumber numberWithInteger:unitNum]];
                [arrOddNum2 addObject:[NSNumber numberWithInteger:decadeNum]];
            }
        }
    }
    
    __block  NSInteger sumOddNumTotal = 0;
    [arrOddNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNumTotal += [obj integerValue];
    }];
    
    __block NSInteger sumOddNum2Total = 0;
    [arrOddNum2 enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNum2Total += [obj integerValue];
    }];
    
    __block NSInteger sumEvenNumTotal =0 ;
    [arrEvenNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumEvenNumTotal += [obj integerValue];
    }];
    
    NSInteger lastNumber = [lastNum integerValue];
    
    NSInteger luhmTotal = lastNumber + sumEvenNumTotal + sumOddNum2Total + sumOddNumTotal;
    
    return (luhmTotal%10 ==0)?YES:NO;
}

#pragma mark 纯数字校验
- (BOOL)isNumberText {
    return [self isValidateByRegex:@"[0-9]*"];
}

#pragma mark 价格校验
- (BOOL)isPriceText {
    return [self isValidateByRegex:@"((^[1-9]\\d*)|^0)(\\.\\d{0,2}){0,1}$"];
}

#pragma mark 数字或字母
- (BOOL)isNumberOrChar {
    return [self isValidateByRegex:@"^[A-Za-z0-9]+$"];
}

#pragma mark 密码校验
- (BOOL)isPasswordWithMinLength:(NSUInteger)minLength maxLength:(NSUInteger)maxLength {
    return [self isValidateByRegex:[NSString stringWithFormat:@"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{%lu,%lu}", minLength, maxLength]];
}
- (BOOL)isPassword {
    return [self isPasswordWithMinLength:6 maxLength:20];
}

@end
