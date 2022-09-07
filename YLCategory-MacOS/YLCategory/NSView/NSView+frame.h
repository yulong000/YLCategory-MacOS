//
//  NSView+frame.h
//  QQ
//
//  Created by 魏宇龙 on 2022/4/15.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSView * _Nonnull (^YLSingleValueIs)(CGFloat value);
typedef NSView * _Nonnull (^YLDoubleValueIs)(CGFloat value1, CGFloat value2);
typedef NSView * _Nonnull (^YLFrameIs)(CGFloat x, CGFloat y, CGFloat width, CGFloat height);
typedef NSView * _Nonnull (^YLEqualToView)(NSView *otherView);
typedef NSView * _Nonnull (^YLEqualToViewWithOffset)(NSView *otherView, CGFloat offset);
typedef NSView * _Nonnull (^YLSpaceToView)(NSView *otherView, CGFloat space);
typedef NSView * _Nonnull (^YLEqualToSuperView)(void);
typedef NSView * _Nonnull (^YLSpaceToSuperView)(CGFloat space);
typedef NSView * _Nonnull (^YLEdgeToSuperView)(NSEdgeInsets insets);
typedef NSView * _Nonnull (^YLOffset)(CGFloat offset);

@interface NSView (frame)

/* ------- 连续布局，一行代码设置frame -------
 
************************************
注意：
 1.非自动布局，所有传入otherView或superView的布局，都以该view当前的frame作为参考值，不会根据其frame的变化而变化
 2.相对布局的otherView, 指的是同一个父视图下的同级子视图
************************************
 
*/

/// 设置x值
@property (nonatomic, copy, readonly) YLSingleValueIs x_is;
/// 设置y值
@property (nonatomic, copy, readonly) YLSingleValueIs y_is;
/// 设置宽度
@property (nonatomic, copy, readonly) YLSingleValueIs width_is;
/// 设置高度
@property (nonatomic, copy, readonly) YLSingleValueIs height_is;

/// 设置顶部位置
@property (nonatomic, copy, readonly) YLSingleValueIs top_is;
/// 设置左侧位置
@property (nonatomic, copy, readonly) YLSingleValueIs left_is;
/// 设置底部位置
@property (nonatomic, copy, readonly) YLSingleValueIs bottom_is;
/// 设置右侧位置
@property (nonatomic, copy, readonly) YLSingleValueIs right_is;

/// 设置中心位置x
@property (nonatomic, copy, readonly) YLSingleValueIs centerX_is;
/// 设置中心位置y
@property (nonatomic, copy, readonly) YLSingleValueIs centerY_is;

/// 设置origin
@property (nonatomic, copy, readonly) YLDoubleValueIs origin_is;
/// 设置大小
@property (nonatomic, copy, readonly) YLDoubleValueIs size_is;
/// 设置中心位置
@property (nonatomic, copy, readonly) YLDoubleValueIs center_is;

/// 设置frame
@property (nonatomic, copy, readonly) YLFrameIs frame_is;
/// 设置偏移量，x会增加offset
@property (nonatomic, copy, readonly) YLOffset offsetX_is;
/// 设置偏移量，y会增加offset
@property (nonatomic, copy, readonly) YLOffset offsetY_is;

/// 设置x等于另一个view
@property (nonatomic, copy, readonly) YLEqualToView x_equalTo;
/// 设置y等于另一个view
@property (nonatomic, copy, readonly) YLEqualToView y_equalTo;
/// 设置origin等于另一个view
@property (nonatomic, copy, readonly) YLEqualToView origin_equalTo;

/// 设置顶部等于另一个view
@property (nonatomic, copy, readonly) YLEqualToView top_equalTo;
/// 设置左侧等于另一个view
@property (nonatomic, copy, readonly) YLEqualToView left_equalTo;
/// 设置底部等于另一个view
@property (nonatomic, copy, readonly) YLEqualToView bottom_equalTo;
/// 设置右侧等于另一个view
@property (nonatomic, copy, readonly) YLEqualToView right_equalTo;

/// 设置宽度等于另一个view
@property (nonatomic, copy, readonly) YLEqualToView width_equalTo;
/// 设置高度等于另一个view
@property (nonatomic, copy, readonly) YLEqualToView height_equalTo;
/// 设置大小等于另一个view
@property (nonatomic, copy, readonly) YLEqualToView size_equalTo;

/// 设置中心位置x等于另一个view
@property (nonatomic, copy, readonly) YLEqualToView centerX_equalTo;
/// 设置中心位置y等于另一个view
@property (nonatomic, copy, readonly) YLEqualToView centerY_equalTo;
/// 设置中心位置等于另一个view
@property (nonatomic, copy, readonly) YLEqualToView center_equalTo;

/// 设置x等于另一个view的x，并增加偏移量offset
@property (nonatomic, copy, readonly) YLEqualToViewWithOffset x_equalWithOffset;
/// 设置y等于另一个view的y，并增加偏移量offset
@property (nonatomic, copy, readonly) YLEqualToViewWithOffset y_equalWithOffset;

/// 设置顶部对齐另一个view的顶部增加偏移量offset
@property (nonatomic, copy, readonly) YLEqualToViewWithOffset top_equalWithOffset;
/// 设置左侧对齐另一个view的左侧，并增加偏移量offset
@property (nonatomic, copy, readonly) YLEqualToViewWithOffset left_equalWithOffset;
/// 设置底部对齐另一个view的底部，并增加偏移量offset
@property (nonatomic, copy, readonly) YLEqualToViewWithOffset bottom_equalWithOffset;
/// 设置右侧对齐另一个view的右侧，并增加偏移量offset
@property (nonatomic, copy, readonly) YLEqualToViewWithOffset right_equalWithOffset;

/// 设置中心位置x对齐另一个view的中心位置x，并增加偏移量offset
@property (nonatomic, copy, readonly) YLEqualToViewWithOffset centerX_equalWithOffset;
/// 设置中心位置y对齐另一个view的中心位置y，并增加偏移量offset
@property (nonatomic, copy, readonly) YLEqualToViewWithOffset centerY_equalWithOffset;

/// 设置右侧对齐父视图右侧
@property (nonatomic, copy, readonly) YLEqualToSuperView right_equalToSuper;
/// 设置底部对齐父视图底部
@property (nonatomic, copy, readonly) YLEqualToSuperView bottom_equalToSuper;
/// 设置居中
@property (nonatomic, copy, readonly) YLEqualToSuperView center_equalToSuper;
/// 设置水平居中
@property (nonatomic, copy, readonly) YLEqualToSuperView centerX_equalToSuper;
/// 设置垂直居中
@property (nonatomic, copy, readonly) YLEqualToSuperView centerY_equalToSuper;

/// 设置右侧与父视图右侧的间距space
@property (nonatomic, copy, readonly) YLSpaceToSuperView right_spaceToSuper;
/// 设置顶部与父视图底部的间距space
@property (nonatomic, copy, readonly) YLSpaceToSuperView top_spaceToSuper;

/// 设置顶部与另一个view的底部的间距
@property (nonatomic, copy, readonly) YLSpaceToView top_spaceTo;
/// 设置左侧与另一个view的右侧的间距
@property (nonatomic, copy, readonly) YLSpaceToView left_spaceTo;
/// 设置底部与另一个view的顶部的间距
@property (nonatomic, copy, readonly) YLSpaceToView bottom_spaceTo;
/// 设置右侧与另一个view的左侧的间距
@property (nonatomic, copy, readonly) YLSpaceToView right_spaceTo;

/// 设置在父视图中上下左右的间距
@property (nonatomic, copy, readonly) YLEdgeToSuperView edgeToSuper;

@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) NSSize  size;
@property (assign, nonatomic) NSPoint origin;
@property (assign, nonatomic) NSPoint center;
@property (assign, nonatomic) CGFloat centerX;
@property (assign, nonatomic) CGFloat centerY;

@property (assign, nonatomic) CGFloat top;
@property (assign, nonatomic) CGFloat left;
@property (assign, nonatomic) CGFloat bottom;
@property (assign, nonatomic) CGFloat right;

@property (assign, readonly, nonatomic) CGFloat maxX;
@property (assign, readonly, nonatomic) CGFloat maxY;
@property (assign, readonly, nonatomic) NSPoint centerPoint;

@end

NS_ASSUME_NONNULL_END
