//
//  NSView+category.h
//  QQ
//
//  Created by 魏宇龙 on 2022/4/15.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSView (category)

@property (nonatomic, strong, nullable) NSColor *backgroundColor;

/**  移除所有的子控件  */
- (void)removeAllSubviews;

/// 移除某一类子控件
- (void)removeSubviewsWithClass:(Class)classRemove;

/**  添加一组子控件  */
- (void)addSubViewsFromArray:(NSArray *)subViews;

/// 监听鼠标 划入｜划出
/// @param rect 区域
/// @param owner 回调者
- (NSTrackingArea *)addMouseTrackingAreaWithRect:(NSRect)rect owner:(id)owner;
/// 监听鼠标 划入｜划出 整个区域
- (NSTrackingArea *)addMouseTracking;

/// 移除所有的跟踪区域
- (void)removeAllTrackingArea;

/**  设置边框宽度 */
- (void)setBorderWidth:(CGFloat)borderWidth;

/**  设置边框颜色 */
- (void)setBorderColor:(NSColor *)borderColor;

/**  设置圆角  */
- (void)setCornerRadius:(CGFloat)cornerRadius;

/** 设置指定位置的圆角 */
- (void)setCornerRadius:(CGFloat)cornerRadius mask:(CACornerMask)mask;

/**  设置边框  */
- (void)setBorderColor:(NSColor *)borderColor borderWidth:(CGFloat)borderWidth;

/**  设置边框和圆角  */
- (void)setBorderColor:(NSColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius;

/// 构造方法，创建带背景色的view
+ (instancetype)viewWithColor:(NSColor *)backgroundColor;

/// 获取缩略图
- (NSImage *)thumbImage;

/// 视图控制器
- (NSViewController *)vc;
/// 窗口控制器
- (NSWindowController *)wc;
/// 所在的屏幕
- (NSScreen *)screen;

@end

NS_ASSUME_NONNULL_END
