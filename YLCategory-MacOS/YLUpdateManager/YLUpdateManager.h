//
//  YLUpdateManager.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLUpdateManager : NSObject

+ (instancetype)share;

/// app ID（app store版）
@property (nonatomic, copy, readwrite)   NSString *appID;
/// 强制更新地址（app store版）
@property (nonatomic, copy, readwrite, nullable)   NSString *forceUpdateUrl;

/// app store 版本，根据app ID生成的链接
/// app应用商店地址
@property (nonatomic, nullable, readonly)   NSString *appStoreUrl;
/// app更新地址
@property (nonatomic, nullable, readonly)   NSString *appUpdateUrl;
/// app介绍
@property (nonatomic, nullable, readonly)   NSString *appIntroduceUrl;

/// 检测新版本
- (void)checkForUpdatesInBackground;
/// 检测新版本（xib连线 ）
- (IBAction)checkForUpdates:(nullable id)sender;

@end

/// 国际化
NSString *YLUpdateManagerLocalizeString(NSString *key);

NS_ASSUME_NONNULL_END
