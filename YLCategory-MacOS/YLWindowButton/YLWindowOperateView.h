//
//  YLWindowOperateView.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import <Cocoa/Cocoa.h>
#import "YLWindowButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLWindowOperateView : NSView

/// 构造方法，会根据传入的按钮个数，自动计算size，只需设置origin即可
- (instancetype)initWithButtonTypes:(NSArray <YLWindowButtonOperateType> *)buttonTypes;
+ (instancetype)opreateViewWithButtonTypes:(NSArray <YLWindowButtonOperateType> *)buttonTypes;

/// 点击按钮回调，一般情况下无需调用，内部已实现窗口对应的操作
@property (nonatomic, copy)   void (^clickHandler)(YLWindowButtonType buttonType);
/// 传入的按钮类型
@property (readonly) NSArray <YLWindowButtonOperateType> *buttonTypes;

/// 获取对应的按钮
/// - Parameter buttonType: 按钮类型
- (nullable YLWindowButton *)buttonWithType:(YLWindowButtonType)buttonType;

@end

NS_ASSUME_NONNULL_END
