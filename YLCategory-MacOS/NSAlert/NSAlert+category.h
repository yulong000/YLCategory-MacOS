//
//  NSAlert+category.h
//  iCopy
//
//  Created by 魏宇龙 on 2022/11/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAlert (category)

/// 显示alert
/// - Parameters:
///   - window: 要显示到的窗口
///   - title: 标题
///   - buttons: 按钮，最多3个
///   - completionHandler: 点击按钮后的回调
+ (void)showForModalWindow:(NSWindow *)window
                 withTitle:(NSString *)title
                   buttons:(NSArray <NSString *> *)buttons
         completionHandler:(void (^ _Nullable)(NSInteger index))completionHandler;

/// 显示alert
/// - Parameters:
///   - title: 标题
///   - message: 显示内容
///   - buttons: 按钮，最多3个
///   - completionHandler: 点击按钮后的回调
+ (void)showWithTitle:(NSString * _Nullable)title
              message:(NSString * _Nullable)message
              buttons:(NSArray <NSString *> *)buttons
    completionHandler:(void (^ _Nullable)(NSInteger index))completionHandler;


/// 显示alert
/// - Parameters:
///   - title: 标题
///   - buttons: 按钮，最多3个
///   - completionHandler: 点击按钮后的回调
+ (void)showWithTitle:(NSString * _Nullable)title
              buttons:(NSArray <NSString *> *)buttons
    completionHandler:(void (^ _Nullable)(NSInteger index))completionHandler;


/// 显示alert
/// - Parameters:
///   - window: 要显示到的窗口
///   - title: 标题
///   - message: 显示内容
///   - buttons: 按钮，最多3个
///   - completionHandler: 点击按钮后的回调
+ (void)showForModalWindow:(NSWindow * _Nullable)window
                 withTitle:(NSString * _Nullable)title
                   message:(NSString * _Nullable)message
                   buttons:(NSArray <NSString *> *)buttons
         completionHandler:(void (^ _Nullable)(NSInteger index))completionHandler;

@end

NS_ASSUME_NONNULL_END
