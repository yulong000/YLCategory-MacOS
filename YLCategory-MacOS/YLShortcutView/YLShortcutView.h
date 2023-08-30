//
//  YLShortcutView.h
//  Test
//
//  Created by 魏宇龙 on 2022/7/6.
//

#import <Cocoa/Cocoa.h>
#import <Shortcut.h>

typedef NS_ENUM(NSInteger, YLShortcutViewStyle) {
    YLShortcutViewStyleSystem = 1,
    YLShortcutViewStyleNormal,
    YLShortcutViewStyleDark,
};

NS_ASSUME_NONNULL_BEGIN

/// 快捷键设置
@interface YLShortcutView : NSView

/// 快捷键的值
@property (nonatomic, strong, nullable) MASShortcut *shortcut;
/// 快捷键发生变化
@property (nonatomic, copy)   void (^changedHandler)(YLShortcutView *sender, MASShortcut * _Nullable shortcut);

/// 主题样式
@property (nonatomic, assign) YLShortcutViewStyle style;
/// 字体 default ： system font 13
@property (nonatomic, strong) NSFont *titleFont;
/// 没有快捷键时显示的标题
@property (nonatomic, copy, nullable) IBInspectable NSString *titleForHasNotShortcut;
/// 没有快捷键时编辑状态显示的标题
@property (nonatomic, copy, nullable) IBInspectable NSString *titleForHasNotShortcutAndEditing;

@end


/// 全局配置，需要在组件未创建之前设置，优先级低于控件单独设置的值
@interface YLShortcutConfig : NSObject

+ (void)setThemeStyle:(YLShortcutViewStyle)style;
+ (void)setTitleForHasNotShortcut:(NSString *)title;
+ (void)setTitleForHasNotShortcutAndEditing:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
