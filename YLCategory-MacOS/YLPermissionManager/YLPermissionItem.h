//
//  YLPermissionItem.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import <Cocoa/Cocoa.h>
#import "YLPermissionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLPermissionItem : NSView

/// 创建item
+ (instancetype)itemWithModel:(YLPermissionModel *)model;
/// 刷新状态
- (BOOL)refreshStatus;

@end

NS_ASSUME_NONNULL_END
