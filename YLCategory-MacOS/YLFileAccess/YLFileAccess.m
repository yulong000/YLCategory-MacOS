//
//  YLFileAccess.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/31.
//

#import "YLFileAccess.h"

#ifndef kAPP_Name
#define kAPP_Name                       ([[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"] ?: [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleName"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"])
#endif

NSString *YLFileAccessLocalizeString(NSString *key){
   static NSBundle *bundle = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
       bundle = [NSBundle bundleForClass:[YLFileAccess class]];
   });
   return [bundle localizedStringForKey:key value:@"" table:@"YLFileAccess"];
}

@interface YLFileAccess ()

@property (nonatomic, strong) AppSandboxFileAccess *fileAccess;

@end

@implementation YLFileAccess

+ (instancetype)share {
    static YLFileAccess *fileAccess;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fileAccess = [[YLFileAccess alloc] init];
    });
    return fileAccess;
}

- (instancetype)init {
    if(self = [super init]) {
        self.fileAccess = [AppSandboxFileAccess fileAccess];
        self.fileAccess.title = YLFileAccessLocalizeString(@"File access title");
        self.fileAccess.message = [NSString stringWithFormat:YLFileAccessLocalizeString(@"File access message"), kAPP_Name];
        self.fileAccess.prompt = YLFileAccessLocalizeString(@"File access prompt");
    }
    return self;
}

#pragma mark - 检查授权

- (BOOL)checkAccessWithFileUrl:(NSURL *)fileUrl {
    if(fileUrl == nil || ![fileUrl isKindOfClass:[NSURL class]] || fileUrl.path.length == 0) {
        NSLog(@"%s 传入的路径不正确", __FUNCTION__);
        return NO;
    }
    NSURL *fileURL = [[fileUrl URLByStandardizingPath] URLByResolvingSymlinksInPath];
    NSData *bookmarkData = [self.fileAccess.bookmarkPersistanceDelegate bookmarkDataForURL:fileURL];
    if (bookmarkData) {
        BOOL bookmarkDataIsStale;
        NSURL *allowedURL = [NSURL URLByResolvingBookmarkData:bookmarkData options:NSURLBookmarkResolutionWithSecurityScope|NSURLBookmarkResolutionWithoutUI relativeToURL:nil bookmarkDataIsStale:&bookmarkDataIsStale error:NULL];
        if(allowedURL == nil) {
            NSLog(@"%s 该路径未授权: %@", __FUNCTION__, fileUrl.path);
            return NO;
        }
        if (bookmarkDataIsStale) {
            // 过期
            [self.fileAccess.bookmarkPersistanceDelegate clearBookmarkDataForURL:fileURL];
            NSLog(@"%s 授权已过期：%@", __FUNCTION__, fileUrl.path);
            return NO;
        }
        [allowedURL startAccessingSecurityScopedResource];
        return YES;
    }
    return NO;
}

- (BOOL)checkAccessWithFilePath:(NSString *)filePath {
    if(filePath == nil || ![filePath isKindOfClass:[NSString class]] || filePath.length == 0) {
        NSLog(@"%s 传入的路径不正确", __FUNCTION__);
        return NO;
    }
    return [self checkAccessWithFileUrl:[NSURL fileURLWithPath:filePath]];
}

#pragma mark - 请求授权

- (void)accessFilePath:(NSString *)filePath withHandler:(YLFileAccessHandler)handler {
    if(filePath == nil || ![filePath isKindOfClass:[NSString class]] || filePath.length == 0) {
        NSLog(@"%s 传入的路径不正确", __FUNCTION__);
        return;
    }
    [self accessFileUrl:[NSURL fileURLWithPath:filePath] withHandler:handler];
}

- (void)accessFilePath:(NSString *)filePath onceWithHandler:(YLFileAccessHandler)handler {
    if(filePath == nil || ![filePath isKindOfClass:[NSString class]] || filePath.length == 0) {
        NSLog(@"%s 传入的路径不正确", __FUNCTION__);
        return;
    }
    [self accessFileUrl:[NSURL fileURLWithPath:filePath] onceWithHandler:handler];
}

- (void)accessFileUrl:(NSURL *)fileUrl withHandler:(YLFileAccessHandler)handler {
    [self accessFileUrl:fileUrl persistPermission:YES withHandler:handler];
}

- (void)accessFileUrl:(NSURL *)fileUrl onceWithHandler:(YLFileAccessHandler)handler {
    [self accessFileUrl:fileUrl persistPermission:NO withHandler:handler];
}

- (void)accessFileUrl:(NSURL *)fileUrl persistPermission:(BOOL)persist withHandler:(YLFileAccessHandler)handler {
    if(fileUrl == nil || ![fileUrl isKindOfClass:[NSURL class]] || fileUrl.path.length == 0) {
        NSLog(@"%s 传入的路径不正确", __FUNCTION__);
        return;
    }
    BOOL success = [self.fileAccess accessFileURL:fileUrl persistPermission:persist withBlock:^{
        NSLog(@"%s 已获得该路径权限: %@", __FUNCTION__, fileUrl.path);
    }];
    NSLog(@"%@ 授权访问 %@", fileUrl.path, success ? @"成功" : @"失败");
    if(handler) {
        handler(success);
    }
}

#pragma mark - 取消授权

- (void)cancelAccessFilePath:(NSString *)filePath {
    if(filePath == nil || ![filePath isKindOfClass:[NSString class]] || filePath.length == 0) {
        NSLog(@"%s 传入的路径不正确", __FUNCTION__);
        return;
    }
    [self cancelAccessFileUrl:[NSURL fileURLWithPath:filePath]];
}

- (void)cancelAccessFileUrl:(NSURL *)fileUrl {
    if(fileUrl == nil || ![fileUrl isKindOfClass:[NSURL class]] || fileUrl.path.length == 0) {
        NSLog(@"%s 传入的路径不正确", __FUNCTION__);
        return;
    }
    NSURL *fileURL = [[fileUrl URLByStandardizingPath] URLByResolvingSymlinksInPath];
    [self.fileAccess.bookmarkPersistanceDelegate clearBookmarkDataForURL:fileURL];
}

@end
