//
//  YLAppRating.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import "YLAppRating.h"
#import <AppKit/AppKit.h>
#import <StoreKit/StoreKit.h>

#define kAppRateFirstLaunchTime                     @"AppRateFirstLaunchTime"
#define kAppRateExecCount                           @"AppRateExecCount"
#define kAppRateLastShowTime                        @"AppRateLastShowTime"

@implementation YLAppRating

+ (void)showWithAppID:(NSString *)appID {
    [self showWithAppID:appID minExecCount:10 daysSinceFirstLaunch:3 daysSinceLastPrompt:365 delayInSeconds:10];
}

+ (void)showWithAppID:(NSString *)appID
         minExecCount:(NSInteger)minExecCount
 daysSinceFirstLaunch:(NSInteger)daysSinceFirstLaunch
  daysSinceLastPrompt:(NSInteger)daysSinceLastPrompt
       delayInSeconds:(NSInteger)delayInSeconds {
    
    // 不是从app store下载的app不弹窗
    NSURL *receiptURL = [NSBundle mainBundle].appStoreReceiptURL;
    if(receiptURL == nil || [[NSFileManager defaultManager] fileExistsAtPath:receiptURL.path] == NO) {
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 第一次执行的时间
    double first = [userDefaults doubleForKey:kAppRateFirstLaunchTime];
    if(first == 0) {
        first = [[NSDate date] timeIntervalSince1970];
        [userDefaults setDouble:first forKey:kAppRateFirstLaunchTime];
    }
    // 执行的次数，执行到第n次的时候，再执行弹窗代码
    NSInteger count = [userDefaults integerForKey:kAppRateExecCount];
    count ++;
    [userDefaults setInteger:count forKey:kAppRateExecCount];
    if(count < minExecCount) {
        [userDefaults synchronize];
        NSLog(@"app评分 - 当前执行次数：%zd 未达到%zd次, 直接返回", count, minExecCount);
        return;
    }
    NSTimeInterval current = [[NSDate date] timeIntervalSince1970];
    // 从第一次执行，间隔n天，才会真正执行弹窗代码
    if(current - first < 60 * 60 * 24 * daysSinceFirstLaunch) {
        [userDefaults synchronize];
        NSLog(@"app评分 - 从第一次执行至今，已经%.1f天，未超过%zd天，直接返回", (current - first) / (24.0 * 60 * 60), daysSinceFirstLaunch);
        return;
    }
    // 从上一次执行后，间隔n天，执行下一次弹窗代码
    double last = [userDefaults doubleForKey:kAppRateLastShowTime];
    if(last > 0 && current - last < 60 * 60 * 24 * daysSinceLastPrompt) {
        [userDefaults synchronize];
        NSLog(@"app评分 - 从上一次执行评分弹窗至今，已经%.1f天，未超过%zd天，直接返回", (current - last) / (24.0 * 60 * 60), daysSinceLastPrompt);
        return;
    }
    // 开始执行代码
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [userDefaults setDouble:(current + delayInSeconds) forKey:kAppRateLastShowTime];
        [userDefaults setInteger:0 forKey:kAppRateExecCount];
        [userDefaults synchronize];
        if(@available(macOS 15.0, *)) {
            // 15以后，可以输入中文
            [SKStoreReviewController requestReview];
        } else {
            // 跳转app store
            NSString *appStoreReviewPath = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review", appID];
            [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:appStoreReviewPath]];
        }
        NSLog(@"app评分 - 执行了弹窗评分");
    });
}

@end
