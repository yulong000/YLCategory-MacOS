//
//  YLShortcutConfig.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YLShortcutViewStyle) {
    YLShortcutViewStyleSystem = 1,
    YLShortcutViewStyleNormal,
    YLShortcutViewStyleDark,
};

/// 全局配置，需要在组件未创建之前设置，优先级低于控件单独设置的值
@interface YLShortcutConfig : NSObject

/// 单例
+ (instancetype)share;

/// 主题样式
@property (nonatomic, assign) YLShortcutViewStyle style;
/// 没有快捷键时显示的标题
@property (nonatomic, copy, nullable) NSString *titleForHasNotShortcut;
/// 没有快捷键时编辑状态显示的标题
@property (nonatomic, copy, nullable) NSString *titleForHasNotShortcutAndEditing;

@end

NS_ASSUME_NONNULL_END
