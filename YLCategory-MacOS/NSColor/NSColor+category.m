//
//  NSColor+category.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2023/9/5.
//

#import "NSColor+category.h"

@implementation NSColor (category)

+ (NSColor *)light:(NSColor *)light dark:(NSColor *)dark {
    if(@available(macOS 10.15, *)) {
        return [NSColor colorWithName:nil dynamicProvider:^NSColor * _Nonnull(NSAppearance * _Nonnull appearance) {
            if(appearance.name == NSAppearanceNameDarkAqua || appearance.name == NSAppearanceNameVibrantDark) {
                // 暗黑模式
                return dark ?: light;
            }
            return light;
        }];
    }
    return light;
}

- (NSColorAlphaHanlder)alpha {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat alpha) {
        return [weakSelf colorWithAlphaComponent:alpha];
    };
}

- (NSString *)hexString {
    unsigned r = (unsigned)(self.redComponent * 255);
    unsigned g = (unsigned)(self.greenComponent * 255);
    unsigned b = (unsigned)(self.blueComponent * 255);
    unsigned a = (unsigned)(self.alphaComponent * 255);
    if(a == 255) {
        return [NSString stringWithFormat:@"#%02X%02X%02X", r, g, b];
    }
    return [NSString stringWithFormat:@"#%02X%02X%02X%02X", r, g, b, a];
}

- (NSString *)hexStringWithAlpha {
    unsigned r = (unsigned)(self.redComponent * 255);
    unsigned g = (unsigned)(self.greenComponent * 255);
    unsigned b = (unsigned)(self.blueComponent * 255);
    unsigned a = (unsigned)(self.alphaComponent * 255);
    return [NSString stringWithFormat:@"#%02X%02X%02X%02X", r, g, b, a];
}

- (NSString *)hexStringWithoutAlpha {
    unsigned r = (unsigned)(self.redComponent * 255);
    unsigned g = (unsigned)(self.greenComponent * 255);
    unsigned b = (unsigned)(self.blueComponent * 255);
    return [NSString stringWithFormat:@"#%02X%02X%02X", r, g, b];
}

+ (NSColor *)colorWithHexString:(NSString *)hexStr {
    if([hexStr isKindOfClass:[NSString class]] == NO || hexStr.length < 3 || hexStr.length > 9) {
        NSLog(@"%s 传入的字符串格式不正确", __FUNCTION__);
        return nil;
    }
    if([hexStr hasPrefix:@"#"]) {
        hexStr = [hexStr substringFromIndex:1];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES '^[0-9a-fA-F]+$'"];
    if([predicate evaluateWithObject:hexStr] == NO) {
        // 格式不正确
        NSLog(@"%s 传入的字符串格式不正确", __FUNCTION__);
        return nil;
    }
    NSString *RR = @"";
    NSString *GG = @"";
    NSString *BB = @"";
    NSString *AA = @"";
    switch (hexStr.length) {
        case 3: {
            NSString *R = [hexStr substringWithRange:NSMakeRange(0, 1)];
            NSString *G = [hexStr substringWithRange:NSMakeRange(1, 1)];
            NSString *B = [hexStr substringWithRange:NSMakeRange(2, 1)];
            RR = [NSString stringWithFormat:@"%@%@", R, R];
            GG = [NSString stringWithFormat:@"%@%@", G, G];
            BB = [NSString stringWithFormat:@"%@%@", B, B];
            AA = @"FF";
        }
            break;
        case 4: {
            NSString *R = [hexStr substringWithRange:NSMakeRange(0, 1)];
            NSString *G = [hexStr substringWithRange:NSMakeRange(1, 1)];
            NSString *B = [hexStr substringWithRange:NSMakeRange(2, 1)];
            NSString *A = [hexStr substringWithRange:NSMakeRange(3, 1)];
            RR = [NSString stringWithFormat:@"%@%@", R, R];
            GG = [NSString stringWithFormat:@"%@%@", G, G];
            BB = [NSString stringWithFormat:@"%@%@", B, B];
            AA = [NSString stringWithFormat:@"%@%@", A, A];
        }
            break;
        case 6: {
            RR = [hexStr substringWithRange:NSMakeRange(0, 2)];
            GG = [hexStr substringWithRange:NSMakeRange(2, 2)];
            BB = [hexStr substringWithRange:NSMakeRange(4, 2)];
            AA = @"FF";
        }
            break;
        case 8: {
            RR = [hexStr substringWithRange:NSMakeRange(0, 2)];
            GG = [hexStr substringWithRange:NSMakeRange(2, 2)];
            BB = [hexStr substringWithRange:NSMakeRange(4, 2)];
            AA = [hexStr substringWithRange:NSMakeRange(6, 2)];
        }
            break;
        default:
            NSLog(@"%s 传入的字符串格式不正确", __FUNCTION__);
            return nil;
            break;
    }
    
    unsigned r = 0, g = 0, b = 0, a = 0;
    NSScanner *scanner = [NSScanner scannerWithString:RR];
    [scanner scanHexInt:&r];
    
    scanner = [NSScanner scannerWithString:GG];
    [scanner scanHexInt:&g];
    
    scanner = [NSScanner scannerWithString:BB];
    [scanner scanHexInt:&b];
    
    scanner = [NSScanner scannerWithString:AA];
    [scanner scanHexInt:&a];
    
    return [NSColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a / 255.0];
}

@end
