//
//  NSAlert+category.h
//  iCopy
//
//  Created by 魏宇龙 on 2022/11/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAlert (category)

+ (void)showForModalWindow:(NSWindow *)window
                 withTitle:(NSString *)title
                   buttons:(NSArray <NSString *> *)buttons
         completionHandler:(void (^ _Nullable)(NSInteger index))completionHandler;

+ (void)showForModalWindow:(NSWindow *)window
                 withTitle:(NSString * _Nullable)title
                   message:(NSString * _Nullable)message
                   buttons:(NSArray <NSString *> *)buttons
         completionHandler:(void (^ _Nullable)(NSInteger index))completionHandler;

@end

NS_ASSUME_NONNULL_END
