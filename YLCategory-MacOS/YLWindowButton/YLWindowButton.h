//
//  YLWindowButton.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YLWindowButtonType) {
    YLWindowButtonTypeClose,                    // 关闭
    YLWindowButtonTypeMini,                     // 最小化
    YLWindowButtonTypeFullScreen,               // 全屏
    YLWindowButtonTypeExitFullScreen,           // 退出全屏
};
typedef NSNumber *YLWindowButtonOperateType;

@interface YLWindowButton : NSControl

/// 按钮类型
@property (nonatomic, assign) IBInspectable YLWindowButtonType buttonType;
/// 忽略自己的鼠标滑入, default = NO
@property (nonatomic, assign) IBInspectable BOOL ignoreMouseHover;
/// 是否激活状态
@property (nonatomic, assign, getter=isActive) BOOL active;
/// 是否选中状态
@property (nonatomic, assign, getter=isHover) BOOL hover;

+ (instancetype)buttonWithType:(YLWindowButtonType)buttonType;
- (instancetype)initWithType:(YLWindowButtonType)buttonType;

@end

NS_ASSUME_NONNULL_END
