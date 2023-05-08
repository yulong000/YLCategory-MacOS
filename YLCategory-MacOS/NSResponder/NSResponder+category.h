//
//  NSResponder+category.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2023/5/8.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^YLSystemThemeChangedHandler)(id responder);

@interface NSResponder (category)

/// 系统主题变更回调,  设置为nil， 移除监听
@property (nonatomic, copy, nullable)  YLSystemThemeChangedHandler themeChangedHandler;

@end

NS_ASSUME_NONNULL_END
