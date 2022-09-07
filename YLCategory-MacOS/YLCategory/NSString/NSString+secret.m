//
//  NSString+secret.m
//  YLCategory
//
//  Created by weiyulong on 2018/10/29.
//  Copyright © 2018 WYL. All rights reserved.
//

#import "NSString+secret.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (secret)
#pragma mark MD5 小写 加密
- (NSString *)MD5_lower {
    //要进行UTF8的转码
    const char* input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    return [NSString stringWithString:digest];
}

#pragma mark MD5 大写 加密
- (NSString *)MD5_upper {
    //要进行UTF8的转码
    const char* input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    return [NSString stringWithString:digest];
}

#pragma mark base 64 编码
- (NSString *)base64Encode {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

#pragma mark base 64 解码
- (NSString *)base64Decode {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
