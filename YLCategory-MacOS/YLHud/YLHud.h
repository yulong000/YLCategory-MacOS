//
//  YLHud.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import <Cocoa/Cocoa.h>
#import "YLHudConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLHud : NSWindow

/// 显示的样式
@property (nonatomic, assign) YLHudStyle style;

#pragma mark - 成功 （自动隐藏）

+ (instancetype)showSuccess:(NSString *)success
                   toWindow:(NSWindow *)window;
+ (instancetype)showSuccess:(NSString *)success
                   toWindow:(NSWindow *)window
             hideAfterDelay:(CGFloat)second;
+ (instancetype)showSuccess:(NSString *)success
                   toWindow:(NSWindow *)window
          completionHandler:(YLHudCompletionHandler _Nullable)completionHandler;
+ (instancetype)showSuccess:(NSString *)success
                   toWindow:(NSWindow *)window
             hideAfterDelay:(CGFloat)second
          completionHandler:(YLHudCompletionHandler _Nullable)completionHandler;

#pragma mark - 错误 （自动隐藏）

+ (instancetype)showError:(NSString *)error
                 toWindow:(NSWindow *)window;
+ (instancetype)showError:(NSString *)error
                 toWindow:(NSWindow *)window
           hideAfterDelay:(CGFloat)second;
+ (instancetype)showError:(NSString *)error
                 toWindow:(NSWindow *)window
        completionHandler:(YLHudCompletionHandler _Nullable)completionHandler;
+ (instancetype)showError:(NSString *)error
                 toWindow:(NSWindow *)window
           hideAfterDelay:(CGFloat)second
        completionHandler:(YLHudCompletionHandler _Nullable)completionHandler;

#pragma mark - 文本 （自动隐藏）

+ (instancetype)showText:(NSString *)text
                toWindow:(NSWindow *)window;
+ (instancetype)showText:(NSString *)text
                toWindow:(NSWindow *)window
          hideAfterDelay:(CGFloat)second;
+ (instancetype)showText:(NSString *)text
                toWindow:(NSWindow *)window
       completionHandler:(YLHudCompletionHandler _Nullable)completionHandler;
+ (instancetype)showText:(NSString *)text
                toWindow:(NSWindow *)window
          hideAfterDelay:(CGFloat)second
       completionHandler:(YLHudCompletionHandler _Nullable)completionHandler;


#pragma mark - 加载中 （需手动隐藏）

+ (instancetype)showLoading:(NSString *)loadingText
                   toWindow:(NSWindow *)window;


#pragma mark - 进度 (0.00 - 1) 默认显示百分比 30%, 传入text则显示text

+ (instancetype)showProgress:(CGFloat)progress
                    toWindow:(NSWindow *)window;
+ (instancetype)showProgress:(CGFloat)progress
                        text:(NSString * _Nullable)text
                    toWindow:(NSWindow *)window;


#pragma mark - 显示自定义内容

/// 显示自己想要展示的内容
/// - Parameters:
///   - customView: 显示在上部的自定义view，需设置宽高，会自动置顶居中， 传空时只显示文字
///   - text: 显示在下部的文字
///   - window: 显示到哪个window上，居中显示
///   - second: 多少秒后自动隐藏，小于0 则不隐藏
///   - completionHandler: 隐藏后的回调
+ (instancetype)showCustomView:(NSView * _Nullable)customView
                          text:(NSString *)text
                      toWindow:(NSWindow *)window
                hideAfterDelay:(CGFloat)second
             completionHandler:(YLHudCompletionHandler _Nullable)completionHandler;

#pragma mark - 隐藏HUD

+ (void)hideHUDForWindow:(NSWindow *)window;
+ (void)hideHUD:(YLHud *)hud;

#pragma mark - 加载中 切换显示其他状态

- (void)hide;
- (void)hideWithCompletionHandler:(YLHudCompletionHandler _Nullable)completionHandler;
- (void)hideAfterDelay:(CGFloat)second completionHandler:(YLHudCompletionHandler _Nullable)completionHandler;

- (void)showLoading:(NSString *)loading;

- (void)showText:(NSString *)text;
- (void)showText:(NSString *)text hideAfterDelay:(CGFloat)second;
- (void)showText:(NSString *)text completionHandler:(YLHudCompletionHandler _Nullable)completionHandler;
- (void)showText:(NSString *)text hideAfterDelay:(CGFloat)second completionHandler:(YLHudCompletionHandler _Nullable)completionHandler;

- (void)showSuccess:(NSString *)success;
- (void)showSuccess:(NSString *)success hideAfterDelay:(CGFloat)second;
- (void)showSuccess:(NSString *)success completionHandler:(YLHudCompletionHandler _Nullable)completionHandler;
- (void)showSuccess:(NSString *)success hideAfterDelay:(CGFloat)second completionHandler:(YLHudCompletionHandler _Nullable)completionHandler;

- (void)showError:(NSString *)error;
- (void)showError:(NSString *)error hideAfterDelay:(CGFloat)second;
- (void)showError:(NSString *)error completionHandler:(YLHudCompletionHandler _Nullable)completionHandler;
- (void)showError:(NSString *)error hideAfterDelay:(CGFloat)second completionHandler:(YLHudCompletionHandler _Nullable)completionHandler;

- (void)showProgress:(CGFloat)progress;
- (void)showProgress:(CGFloat)progress text:(NSString * _Nullable)text;


@end

NS_ASSUME_NONNULL_END
