//
//  YLPermissionModel.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YLPermissionAuthType) {
    YLPermissionAuthTypeNone,                 // 无
    YLPermissionAuthTypeAccessibility,        // 辅助功能权限
    YLPermissionAuthTypeFullDisk,             // 完全磁盘权限
    YLPermissionAuthTypeScreenCapture,        // 录屏
};

@interface YLPermissionModel : NSObject

/// 授权类型
@property (nonatomic, assign) YLPermissionAuthType authType;
/// 文字描述
@property (nonatomic, copy)   NSString *desc;

+ (instancetype)modelWithAuthType:(YLPermissionAuthType)authType desc:(NSString *)desc;
- (instancetype)initWithAuthType:(YLPermissionAuthType)authType desc:(NSString *)desc;

@end

NS_ASSUME_NONNULL_END
