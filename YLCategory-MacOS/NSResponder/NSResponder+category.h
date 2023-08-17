//
//  NSResponder+category.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2023/5/8.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^YLThemeChangedHandler)(id responder, BOOL dark);

@interface NSResponder (category)

/// 系统主题变更回调,  设置为nil， 移除监听
@property (nonatomic, copy, nullable)  YLThemeChangedHandler systemThemeChangedHandler;
/// app主题变更回调，设置为nil，移除监听。
/// 注意：该方法实现原理为KVO，如果子类也有KVO监听，observeValueForKeyPath: ofObject:(id)object change: context: 该方法需要先调用 super
@property (nonatomic, copy, nullable)  YLThemeChangedHandler appThemeChangedHandler;

@end

NS_ASSUME_NONNULL_END
