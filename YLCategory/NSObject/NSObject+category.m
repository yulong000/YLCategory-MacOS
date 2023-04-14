#import "NSObject+category.h"
#import <sys/utsname.h>

@implementation NSObject (category)

#pragma mark 是否是长度不为0的字符串
- (BOOL)isValidString {
    if([self isKindOfClass:[NSString class]]) {
        NSString *str = (NSString *)self;
        return str.length > 0;
    }
    return NO;
}

- (void)postNotificationName:(NSString *)name {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:nil];
}

- (void)postNotificationName:(NSString *)name userInfo:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:userInfo];
}

@end
