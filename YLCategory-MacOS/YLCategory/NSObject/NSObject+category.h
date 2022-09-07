#import <Foundation/Foundation.h>

@interface NSObject (category)

/**  长度不为0的字符串  */
- (BOOL)isValidString;

/// 发送通知
- (void)postNotificationName:(NSString *)name;
- (void)postNotificationName:(NSString *)name userInfo:(NSDictionary *)userInfo;

@end
