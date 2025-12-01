//
//  YLUpdateViewController.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLUpdateViewController : NSViewController

/// 更新内容
@property (nonatomic, copy)   NSString *info;
/// 新的版本号
@property (nonatomic, copy)   NSString *lastVersion;
/// 显示跳过按钮
@property (nonatomic, assign) BOOL showSkipButton;

@end

NS_ASSUME_NONNULL_END
