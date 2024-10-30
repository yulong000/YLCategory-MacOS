//
//  YLHudConfig.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,YLHudStyle) {
    YLHudStyleAuto,
    YLHudStyleBlack,
    YLHudStyleWhite,
};

typedef void (^YLHudCompletionHandler)(void);

@interface YLHudConfig : NSObject

/// 显示的样式
@property (nonatomic, assign) YLHudStyle style;
/// 显示的文字的字体
@property (nonatomic, strong, nullable) NSFont *textFont;
/// 是否可以通过拖动移动背后的window， default = yes
@property (nonatomic, assign) BOOL movable;

+ (instancetype)share;

@end

NS_ASSUME_NONNULL_END
