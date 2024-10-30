//
//  YLPermissionViewController.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import <Cocoa/Cocoa.h>
#import "YLPermissionItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLPermissionViewController : NSViewController

/// 请求权限的类型，传入 YLPermissionAuthType 的数组
@property (nonatomic, strong) NSArray <YLPermissionModel *> *authTypes;
/// 所有权限都已开启
@property (nonatomic, copy)   void (^allAuthPassedHandler)(void);
/// 跳过回调
@property (nonatomic, copy)   void (^skipHandler)(void);

/// 刷新所有的授权状态
- (void)refreshAllAuthState;

@end

NS_ASSUME_NONNULL_END
