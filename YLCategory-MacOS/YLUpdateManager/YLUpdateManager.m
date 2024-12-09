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

#if OFFLINE
#import <Sparkle/Sparkle.h>

@interface YLUpdateManager () <SPUUpdaterDelegate, SPUStandardUserDriverDelegate>

@property (nonatomic, strong) SPUStandardUpdaterController *updateController;

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

- (instancetype)init {
    if(self = [super init]) {
        self.updateController = [[SPUStandardUpdaterController alloc] initWithStartingUpdater:YES updaterDelegate:self userDriverDelegate:self];
        self.updateController.updater.automaticallyChecksForUpdates = YES;
    }
    return self;
}

- (void)checkForUpdatesInBackground {
    [self.updateController.updater checkForUpdatesInBackground];
}

- (IBAction)checkForUpdates:(nullable id)sender {
    [self.updateController checkForUpdates:sender];
}

#pragma mark - 根据日期和系统版本判断试用到期
- (void)judgeAppExpireWithDate:(NSString *)dateString andOSVersion:(NSString *)osVersion {
    if([self judgeAppExpireWithDate:dateString] == NO) {
        [self judgeAppExpireWithOSVersion:osVersion];
    }
}

#pragma mark  根据日期判断试用到期
- (BOOL)judgeAppExpireWithDate:(NSString *)dateString {
    if([YLUpdateManager share].offlineDownloadUrl == nil) {
        return NO;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:dateString];
    if([[NSDate date] timeIntervalSinceDate:date] > 0) {
        // 过期了
        [NSApp activateIgnoringOtherApps:YES];
        NSAlert *alert = [[NSAlert alloc] init];
        alert.alertStyle = NSAlertStyleWarning;
        alert.messageText = YLUpdateManagerLocalizeString(@"Kind tips");
        alert.informativeText = [NSString stringWithFormat:YLUpdateManagerLocalizeString(@"Expire Tips"), kAPP_Name];
        [alert addButtonWithTitle:YLUpdateManagerLocalizeString(@"Click to download")];
        NSModalResponse returnCode = [alert runModal];
        if(returnCode == NSAlertFirstButtonReturn) {
            [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[YLUpdateManager share].offlineDownloadUrl]];
            [NSApp terminate:nil];
        }
        return YES;
    }
    return NO;
}

#pragma mark 根据系统版本判断试用到期
- (BOOL)judgeAppExpireWithOSVersion:(NSString *)osVersion {
    if([YLUpdateManager share].offlineDownloadUrl == nil) {
        return NO;
    }
    NSOperatingSystemVersion sv = [NSProcessInfo processInfo].operatingSystemVersion;
    NSString *sysVersion = [NSString stringWithFormat:@"%ld.%ld.%ld", sv.majorVersion, sv.minorVersion, sv.patchVersion];
    if([sysVersion compare:osVersion options:NSNumericSearch] != NSOrderedAscending) {
        // 大于等于设置的系统版本
        [NSApp activateIgnoringOtherApps:YES];
        NSAlert *alert = [[NSAlert alloc] init];
        alert.alertStyle = NSAlertStyleWarning;
        alert.messageText = YLUpdateManagerLocalizeString(@"Kind tips");
        alert.informativeText = [NSString stringWithFormat:YLUpdateManagerLocalizeString(@"OS Expire Tips"), kAPP_Name];
        [alert addButtonWithTitle:YLUpdateManagerLocalizeString(@"Click to update")];
        NSModalResponse returnCode = [alert runModal];
        if(returnCode == NSAlertFirstButtonReturn) {
            [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[YLUpdateManager share].offlineDownloadUrl]];
            [NSApp terminate:nil];
        }
        return YES;
    }
    return NO;
}

#pragma mark - delegate

- (void)updater:(SPUUpdater *)updater didFinishLoadingAppcast:(SUAppcast *)appcast {
    NSLog(@"%s 获取xml文件成功: %@", __FUNCTION__, [appcast.items.firstObject propertiesDictionary]);
}

- (void)updaterDidNotFindUpdate:(SPUUpdater *)updater {
    NSLog(@"%s 暂无更新", __FUNCTION__);
}

- (void)updater:(SPUUpdater *)updater didFindValidUpdate:(nonnull SUAppcastItem *)item {
    NSLog(@"%s 有可用升级: \nVersion: %@ \nBuild number: %@ \nUrl:%@ \nNote:%@", __FUNCTION__, item.displayVersionString, item.versionString, item.fileURL.absoluteString, item.itemDescription);
}

- (void)updater:(SPUUpdater *)updater userDidMakeChoice:(SPUUserUpdateChoice)choice forUpdate:(SUAppcastItem *)updateItem state:(SPUUserUpdateState *)state {
    switch (choice) {
        case SPUUserUpdateChoiceSkip: {
            // 跳过
            NSLog(@"%s 用户点击 跳过这个版本", __FUNCTION__);
        }
            break;
        case SPUUserUpdateChoiceInstall: {
            // 安装
            NSLog(@"%s 用户点击 安装更新", __FUNCTION__);
        }
            break;
        case SPUUserUpdateChoiceDismiss: {
            // 稍后提醒
            NSLog(@"%s 用户点击 稍后提醒", __FUNCTION__);
        }
            break;
        default:
            break;
    }
}

@end

#else

#pragma mark - xml解析

@interface YLUpdateModel : NSObject

/// app名字
@property (nonatomic, copy)   NSString *Name;
/// app的bundle ID
@property (nonatomic, copy)   NSString *BundleId;
/// 支持最小版本号，小于该版本号的，强制升级
@property (nonatomic, copy)   NSString *MiniVersion;
/// 有新版本，就强制升级
@property (nonatomic, assign) BOOL ForceUpdateToTheLastest;

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
    } else if ([self.currentElement isEqualToString:@"ForceUpdateToTheLastest"]) {
        self.update.ForceUpdateToTheLastest = [string boolValue];
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
                    NSString *version = resp[@"results"][0][@"version"]; //线上最新版本
                    NSString *info = resp[@"results"][0][@"releaseNotes"]; // 升级内容
                    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if([version compare:appVersion options:NSNumericSearch] == NSOrderedDescending) {
                            // 有新版本
                            if(self.forceUpdateUrl && self.forceUpdateUrl.length > 0) {
                                // 有强制更新的链接
                                NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:self.forceUpdateUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        if(data && !error) {
                                            // 解析xml
                                            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
                                            parser.delegate = self.xmlDelegate;
                                            [parser parse];
                                            YLUpdateModel *update = self.xmlDelegate.update;
                                            if(update) {
                                                if([update.BundleId isEqualToString:[NSBundle mainBundle].bundleIdentifier]) {
                                                    if(update.ForceUpdateToTheLastest || [update.MiniVersion compare:appVersion options:NSNumericSearch] == NSOrderedDescending) {
                                                        // 强制升级到最新版
                                                        [NSApp activateIgnoringOtherApps:YES];
                                                        NSAlert *alert = [[NSAlert alloc] init];
                                                        alert.alertStyle = NSAlertStyleWarning;
                                                        alert.messageText = YLUpdateManagerLocalizeString(@"Kind tips");
                                                        alert.informativeText = YLUpdateManagerLocalizeString(@"Force Update Tips");
                                                        [alert addButtonWithTitle:YLUpdateManagerLocalizeString(@"Click to update")];
                                                        [alert addButtonWithTitle:YLUpdateManagerLocalizeString(@"Quit")];
                                                        NSModalResponse response = [alert runModal];
                                                        if(response == NSAlertFirstButtonReturn) {
                                                            // 升级
                                                            [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:self.appStoreUrl]];
                                                        }
                                                        // 退出
                                                        [NSApp terminate:nil];
                                                        return;
                                                    }
                                                }
                                            }
                                        }
                                        YLUpdateWindowController *wc = [[YLUpdateWindowController alloc] init];
                                        [wc showNewVersion:version info:info];
                                        [wc.window makeKeyAndOrderFront:nil];
                                        [NSApp activateIgnoringOtherApps:YES];
                                    });
                                }];
                                [dataTask resume];
                            } else {
                                YLUpdateWindowController *wc = [[YLUpdateWindowController alloc] init];
                                [wc showNewVersion:version info:info];
                                [wc.window makeKeyAndOrderFront:nil];
                                [NSApp activateIgnoringOtherApps:YES];
                            }
                        } else {
                            // 已是最新
                            if(show) {
                                [NSApp activateIgnoringOtherApps:YES];
                                NSAlert *alert = [[NSAlert alloc] init];
                                alert.alertStyle = NSAlertStyleWarning;
                                alert.messageText = YLUpdateManagerLocalizeString(@"Kind tips");
                                alert.informativeText = YLUpdateManagerLocalizeString(@"Latest version");
                                [alert addButtonWithTitle:YLUpdateManagerLocalizeString(@"Sure")];
                                [alert runModal];
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

#pragma mark - 根据日期和系统版本判断试用到期
- (void)judgeAppExpireWithDate:(NSString *)dateString andOSVersion:(NSString *)osVersion {
    if([self judgeAppExpireWithDate:dateString] == NO) {
        [self judgeAppExpireWithOSVersion:osVersion];
    }
}

#pragma mark 根据日期判断试用到期
- (BOOL)judgeAppExpireWithDate:(NSString *)dateString {
    if(self.appID == nil) return NO;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:dateString];
    if([[NSDate date] timeIntervalSinceDate:date] > 0) {
        // 过期了
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
        return YES;
    }
    return NO;
}

#pragma mark 根据系统版本判断试用到期
- (BOOL)judgeAppExpireWithOSVersion:(NSString *)osVersion {
    if(self.appID == nil)  return NO;
    NSOperatingSystemVersion sv = [NSProcessInfo processInfo].operatingSystemVersion;
    NSString *sysVersion = [NSString stringWithFormat:@"%ld.%ld.%ld", sv.majorVersion, sv.minorVersion, sv.patchVersion];
    if([sysVersion compare:osVersion options:NSNumericSearch] != NSOrderedAscending) {
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
        return YES;
    }
    return NO;
}

#pragma mark - lazy load

- (YLXMLParserDelegate *)xmlDelegate {
   if(_xmlDelegate == nil) {
       _xmlDelegate = [[YLXMLParserDelegate alloc] init];
   }
   return _xmlDelegate;
}

@end

#endif
