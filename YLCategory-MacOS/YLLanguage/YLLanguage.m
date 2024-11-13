//
//  YLLanguage.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import "YLLanguage.h"
#import <AppKit/AppKit.h>

@implementation YLLanguage

+ (NSArray<YLLanguageModel *> *)allLanguages {
    return @[
        [YLLanguageModel languageWithType:AppLanguageTypeSystem],
        [YLLanguageModel languageWithType:AppLanguageTypeChineseSimplified],
        [YLLanguageModel languageWithType:AppLanguageTypeChineseTraditional],
        [YLLanguageModel languageWithType:AppLanguageTypeEnglish],
        [YLLanguageModel languageWithType:AppLanguageTypeJapanese],
        [YLLanguageModel languageWithType:AppLanguageTypeKorean],
        [YLLanguageModel languageWithType:AppLanguageTypeFrench],
        [YLLanguageModel languageWithType:AppLanguageTypeSpanish],
        [YLLanguageModel languageWithType:AppLanguageTypePortuguese],
        [YLLanguageModel languageWithType:AppLanguageTypeGerman],
    ];
}

+ (AppLanguageType)getCurrentLanguageType {
    AppLanguageType languageType = AppLanguageTypeSystem;
    NSString *currentLanguage = [[NSBundle mainBundle] preferredLocalizations].firstObject;
    for (YLLanguageModel *model in [YLLanguage allLanguages]) {
        if([model.code isEqualToString:currentLanguage]) {
            languageType = model.type;
            break;
        }
    }
    return languageType;
}

+ (void)setAppLanguage:(YLLanguageModel *)language fromLanguageType:(AppLanguageType)languageType completionHandler:(void (^)(void))completionHandler  {
    if(language.type == languageType) {
        return;
    }
    if(language.type == AppLanguageTypeSystem) {
        // 跟随系统
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"AppleLanguages"];
    } else {
        // 指定语言
        [[NSUserDefaults standardUserDefaults] setObject:@[language.code] forKey:@"AppleLanguages"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    if(completionHandler) {
        completionHandler();
    }
    [self restartApp];
}

+ (void)setAppLanguageWithType:(AppLanguageType)languageType showRestartAlert:(BOOL)restartAlert {
    YLLanguageModel *language = [YLLanguageModel languageWithType:languageType];
    if(language.type == AppLanguageTypeSystem) {
        // 跟随系统
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"AppleLanguages"];
    } else {
        // 指定语言
        [[NSUserDefaults standardUserDefaults] setObject:@[language.code] forKey:@"AppleLanguages"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    if(restartAlert) {
        [self restartApp];
    }
}

#pragma mark 重启app
+ (void)restartApp {
    NSAlert *alert = [[NSAlert alloc] init];
    alert.alertStyle = NSAlertStyleWarning;
    alert.messageText = YLLanguageLocalizeString(@"Kind tips");
    alert.informativeText = YLLanguageLocalizeString(@"Restart app tips");
    [alert addButtonWithTitle:YLLanguageLocalizeString(@"Restart")];
    [alert addButtonWithTitle:YLLanguageLocalizeString(@"Cancel")];
    NSModalResponse returnCode = [alert runModal];
    if(returnCode == NSAlertFirstButtonReturn) {
        // 重启app
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        NSTask *task = [[NSTask alloc] init];
        task.launchPath = @"/usr/bin/open";
        task.arguments = @[@"-n", bundlePath];
        [task launch];
        [NSApplication.sharedApplication terminate:nil];
    }
}

@end


NSString *YLLanguageLocalizeString(NSString *key){
   static NSBundle *bundle = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
       bundle = [NSBundle bundleForClass:[YLLanguage class]];
   });
   return [bundle localizedStringForKey:key value:@"" table:@"YLLanguage"];
}
