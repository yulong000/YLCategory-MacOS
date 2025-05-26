//
//  YLUpdateManager.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import "YLUpdateManager.h"
#import "YLUpdateWindowController.h"

#ifndef kAPP_Name
#define kAPP_Name                       ([[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"] ?: [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleName"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"])
#endif

NSString *YLUpdateManagerLocalizeString(NSString *key){
   static NSBundle *bundle = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
       bundle = [NSBundle bundleForClass:[YLUpdateManager class]];
   });
   return [bundle localizedStringForKey:key value:@"" table:@"YLUpdateManager"];
}

#pragma mark - xml解析

@interface YLUpdateModel : NSObject

/// app名字
@property (nonatomic, copy)   NSString *Name;
/// app的bundle ID
@property (nonatomic, copy)   NSString *BundleId;
/// 支持最小版本号，小于该版本号的，强制升级
@property (nonatomic, copy)   NSString *MiniVersion;
/// 有新版本，就强制升级
@property (nonatomic, assign) BOOL ForceUpdateToTheLatest;
/// 过期时间
@property (nonatomic, copy)   NSString *ExpiredDate;
/// 过期的系统版本号
@property (nonatomic, copy)   NSString *ExpiredOSVersion;

@end

@implementation YLUpdateModel

@end

@interface YLXMLParserDelegate : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong) YLUpdateModel *update;
@property (nonatomic, copy)   NSString *currentElement;

@end

@implementation YLXMLParserDelegate

#pragma mark 开始解析某个元素
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    self.currentElement = elementName;
}

#pragma mark 读取元素内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if([self.currentElement isEqualToString:@"Name"]) {
        self.update.Name = string;
    } else if ([self.currentElement isEqualToString:@"BundleId"]) {
        self.update.BundleId = string;
    } else if ([self.currentElement isEqualToString:@"MiniVersion"]) {
        self.update.MiniVersion = string;
    } else if ([self.currentElement isEqualToString:@"ForceUpdateToTheLatest"]) {
        self.update.ForceUpdateToTheLatest = [string boolValue];
    } else if ([self.currentElement isEqualToString:@"ExpiredDate"]) {
        self.update.ExpiredDate = string;
    } else if ([self.currentElement isEqualToString:@"ExpiredOSVersion"]) {
        self.update.ExpiredOSVersion = string;
    }
}

#pragma mark 结束某个元素的解析
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    self.currentElement = nil;
}

#pragma mark 解析完成
- (void)parserDidEndDocument:(NSXMLParser *)parser {}

#pragma mark 解析失败
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    self.update = nil;
}

#pragma mark lazy load

- (YLUpdateModel *)update {
    if(_update == nil) {
        _update = [[YLUpdateModel alloc] init];
    }
    return _update;
}

@end

@interface YLUpdateManager ()

/// app应用商店地址
@property (nonatomic, copy)   NSString *appStoreUrl;
/// app更新地址
@property (nonatomic, copy)   NSString *appUpdateUrl;
/// app介绍
@property (nonatomic, copy)   NSString *appIntroduceUrl;
/// xml解析
@property (nonatomic, strong) YLXMLParserDelegate *xmlDelegate;

@end

@implementation YLUpdateManager

+ (instancetype)share {
    static YLUpdateManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YLUpdateManager alloc] init];
    });
    return manager;
}

- (void)setAppID:(NSString *)appID {
    _appID = [appID copy];
    NSString *countryCode = [[NSLocale currentLocale].countryCode lowercaseString] ?: @"";
    [YLUpdateManager share].appStoreUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@", appID];
    [YLUpdateManager share].appUpdateUrl = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@&country=%@", appID, countryCode];
    [YLUpdateManager share].appIntroduceUrl = [NSString stringWithFormat:@"https://apps.apple.com/cn/app/id%@", appID];
}

- (void)checkForUpdatesInBackground {
    [self checkForUpdatesWithPrompt:NO];
}

- (IBAction)checkForUpdates:(nullable id)sender {
    [self checkForUpdatesWithPrompt:YES];
}

- (void)checkForUpdatesWithPrompt:(BOOL)show {
    if(self.appID == nil) return;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:self.appUpdateUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(data) {
            NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if(resp) {
                int resultCount = [resp[@"resultCount"] intValue];
                if(resultCount > 0) {
                    NSString *latestVersion = resp[@"results"][0][@"version"]; //线上最新版本
                    NSString *info = resp[@"results"][0][@"releaseNotes"]; // 升级内容
                    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if([latestVersion compare:appVersion options:NSNumericSearch] == NSOrderedDescending) {
                            // 有新版本
                            if(self.forceUpdateUrl && self.forceUpdateUrl.length > 0) {
                                // 有强制更新的链接
                                [self requestServerForUpdateWayWithUrl:[NSURL URLWithString:self.forceUpdateUrl] currentVersion:appVersion appStoreVersion:latestVersion updateInfo:info];
                            } else {
                                [self showNewVersion:latestVersion info:info];
                            }
                        } else {
                            // 已是最新
                            if(show) {
                                [self showCurrentVersionIsLatestAlert];
                            }
                        }
                    });
                }
            }
        } else if (error) {
            NSLog(@"check new version error : %@", error);
        }
    }];
    [task resume];
}

#pragma mark 请求服务器，判断如何升级
- (void)requestServerForUpdateWayWithUrl:(NSURL *)url currentVersion:(NSString *)currentVersion appStoreVersion:(NSString *)appStoreVersion updateInfo:(NSString *)updateInfo {
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(data && !error) {
                // 解析xml
                NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
                parser.delegate = self.xmlDelegate;
                [parser parse];
                YLUpdateModel *update = self.xmlDelegate.update;
                if (update && [update.BundleId isEqualToString:[NSBundle mainBundle].bundleIdentifier]) {
                    if(update.ForceUpdateToTheLatest) {
                        // 强制升级到最新版
                        [self showForceUpdateAlert];
                        return;
                    }
                    if (update.MiniVersion && update.MiniVersion.length > 0 && [update.MiniVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending) {
                        // 低于最小版本号
                        [self showForceUpdateAlert];
                        return;
                    }
                    if (update.ExpiredDate && update.ExpiredDate.length > 0) {
                        // 设置了过期时间
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US_POSIX"];
                        formatter.dateFormat = @"yyyy-MM-dd";
                        formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
                        NSDate *date = [formatter dateFromString:update.ExpiredDate];
                        if ([[NSDate date] timeIntervalSinceDate:date] > 0) {
                            [self showDateExpiredAlert];
                            return;
                        }
                    }
                    if (update.ExpiredOSVersion && update.ExpiredOSVersion.length > 0) {
                        // 设置了过期系统版本
                        NSOperatingSystemVersion sv = [[NSProcessInfo processInfo] operatingSystemVersion];
                        NSString *sysVersion = [NSString stringWithFormat:@"%ld.%ld.%ld", sv.majorVersion, sv.minorVersion, sv.patchVersion];
                        if ([sysVersion compare:update.ExpiredOSVersion options:NSNumericSearch] != NSOrderedAscending) {
                            [self showOSVersionExpiredAlert];
                            return;
                        }
                    }
                }
            }
            [self showNewVersion:appStoreVersion info:updateInfo];
        });
    }];
    [dataTask resume];
}

#pragma mark 显示有新版本提示
- (void)showNewVersion:(NSString *)version info:(NSString *)info {
    YLUpdateWindowController *wc = [[YLUpdateWindowController alloc] init];
    [wc showNewVersion:version info:info];
    [wc.window center];
    [wc.window makeKeyAndOrderFront:nil];
    [NSApp activateIgnoringOtherApps:YES];
}

#pragma mark 显示当前是最新版本
- (void)showCurrentVersionIsLatestAlert {
    [NSApp activateIgnoringOtherApps:YES];
    NSAlert *alert = [[NSAlert alloc] init];
    alert.alertStyle = NSAlertStyleWarning;
    alert.messageText = YLUpdateManagerLocalizeString(@"Kind tips");
    NSString *appVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    if ([appVersion isKindOfClass:[NSString class]] && appVersion.length > 0) {
        alert.informativeText = [NSString stringWithFormat:@"%@ %@", appVersion, YLUpdateManagerLocalizeString(@"Latest version")];
    } else {
        alert.informativeText = YLUpdateManagerLocalizeString(@"Latest version");
    }
    [alert addButtonWithTitle:YLUpdateManagerLocalizeString(@"Sure")];
    [alert runModal];
}

#pragma mark 显示强制升级
- (void)showForceUpdateAlert {
    [NSApp activateIgnoringOtherApps:YES];
    NSAlert *alert = [[NSAlert alloc] init];
    alert.alertStyle = NSAlertStyleWarning;
    alert.messageText = YLUpdateManagerLocalizeString(@"Kind tips");
    alert.informativeText = YLUpdateManagerLocalizeString(@"Force Update Tips");
    [alert addButtonWithTitle:YLUpdateManagerLocalizeString(@"Click to update")];
    [alert addButtonWithTitle:YLUpdateManagerLocalizeString(@"Quit")];
    NSModalResponse returnCode = [alert runModal];
    if(returnCode == NSAlertFirstButtonReturn) {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:self.appStoreUrl]];
    }
    [NSApp terminate:nil];
}

#pragma mark 显示日期过期的alert弹窗
- (void)showDateExpiredAlert {
    [NSApp activateIgnoringOtherApps:YES];
    NSAlert *alert = [[NSAlert alloc] init];
    alert.alertStyle = NSAlertStyleWarning;
    alert.messageText = YLUpdateManagerLocalizeString(@"Kind tips");
    alert.informativeText = [NSString stringWithFormat:YLUpdateManagerLocalizeString(@"Expire Tips"), kAPP_Name];
    [alert addButtonWithTitle:YLUpdateManagerLocalizeString(@"Click to download")];
    [alert addButtonWithTitle:YLUpdateManagerLocalizeString(@"Quit")];
    NSModalResponse returnCode = [alert runModal];
    if(returnCode == NSAlertFirstButtonReturn) {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:self.appStoreUrl]];
    }
    [NSApp terminate:nil];
}

#pragma mark 显示系统版本过期的alert弹窗
- (void)showOSVersionExpiredAlert {
    // 大于等于设置的系统版本
    [NSApp activateIgnoringOtherApps:YES];
    NSAlert *alert = [[NSAlert alloc] init];
    alert.alertStyle = NSAlertStyleWarning;
    alert.messageText = YLUpdateManagerLocalizeString(@"Kind tips");
    alert.informativeText = [NSString stringWithFormat:YLUpdateManagerLocalizeString(@"OS Expire Tips"), kAPP_Name];
    [alert addButtonWithTitle:YLUpdateManagerLocalizeString(@"Click to update")];
    [alert addButtonWithTitle:YLUpdateManagerLocalizeString(@"Quit")];
    NSModalResponse returnCode = [alert runModal];
    if(returnCode == NSAlertFirstButtonReturn) {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:self.appStoreUrl]];
    }
    [NSApp terminate:nil];
}

#pragma mark - lazy load

- (YLXMLParserDelegate *)xmlDelegate {
   if(_xmlDelegate == nil) {
       _xmlDelegate = [[YLXMLParserDelegate alloc] init];
   }
   return _xmlDelegate;
}

@end
