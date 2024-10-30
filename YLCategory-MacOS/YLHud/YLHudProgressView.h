//
//  YLHudProgressView.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import <Cocoa/Cocoa.h>
#import "YLHudConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLHudProgressView : NSView

@property (nonatomic, assign) YLHudStyle style;
@property (nonatomic, assign) CGFloat progress;
/// 将progress转换成百分比字符串
@property (nonatomic, copy)   NSString *progressText;

@end

NS_ASSUME_NONNULL_END
