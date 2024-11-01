//
//  YLFileAccess.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/31.
//

#import <Foundation/Foundation.h>
#import "AppSandboxFileAccess.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^YLFileAccessHandler)(BOOL success);

@interface YLFileAccess : NSObject

+ (instancetype)share;

@property (readonly) AppSandboxFileAccess *fileAccess;

#pragma mark - 检查是否授权

/// 是否有授权
- (BOOL)checkAccessWithFileUrl:(NSURL *)fileUrl;
- (BOOL)checkAccessWithFilePath:(NSString *)filePath;

#pragma mark - 请求授权

- (void)accessFilePath:(NSString *)filePath withHandler:(YLFileAccessHandler)handler;
- (void)accessFilePath:(NSString *)filePath onceWithHandler:(YLFileAccessHandler)handler;

- (void)accessFileUrl:(NSURL *)fileUrl withHandler:(YLFileAccessHandler)handler;
- (void)accessFileUrl:(NSURL *)fileUrl onceWithHandler:(YLFileAccessHandler)handler;

#pragma mark - 取消授权

- (void)cancelAccessFilePath:(NSString *)filePath;
- (void)cancelAccessFileUrl:(NSURL *)fileUrl;

@end

NS_ASSUME_NONNULL_END
