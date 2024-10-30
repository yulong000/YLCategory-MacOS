//
//  YLAppRating.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLAppRating : NSObject

/// 执行弹窗代码，默认参数
/// - Parameter appID: app注册时的 ID
///   - minExecCount: 10
///   - daysSinceFirstLaunch: 3
///   - daysSinceLastPrompt: 365
///   - delayInSeconds: 10
+ (void)showWithAppID:(NSString *)appID;


/// 执行弹窗代码，可传入自定义参数
/// - Parameters:
///   - appID: app注册时的 ID
///   - minExecCount: 最小执行次数，超过这个值，才会真正执行评分弹窗代码
///   - daysSinceFirstLaunch: 从第一次启动，到执行弹窗，最少间隔的天数，防止一上来就弹窗，需与minExecCount同时满足
///   - daysSinceLastPrompt: 从上次一执行弹窗代码，到下一次执行弹窗代码，中间最少间隔的天数，需与minExecCount同时满足
///   - delayInSeconds: 执行弹窗代码的延时操作，防止一打开app就弹窗
+ (void)showWithAppID:(NSString *)appID
         minExecCount:(NSInteger)minExecCount
 daysSinceFirstLaunch:(NSInteger)daysSinceFirstLaunch
  daysSinceLastPrompt:(NSInteger)daysSinceLastPrompt
       delayInSeconds:(NSInteger)delayInSeconds;


@end

NS_ASSUME_NONNULL_END
