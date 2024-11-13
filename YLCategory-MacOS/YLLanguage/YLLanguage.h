//
//  YLLanguage.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import <Foundation/Foundation.h>
#import "YLLanguageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLLanguage : NSObject

/// 所有的语言
+ (NSArray <YLLanguageModel *> *)allLanguages;

/// 获取app当前的语言
+ (AppLanguageType)getCurrentLanguageType;

/// 设置app的语言
/// - Parameters:
///   - language: 目标语言
///   - languageType: 当前的语言类型
///   - completionHandler: 设置完成后，重启app前，回调，可以在这里处理一些其他事件
+ (void)setAppLanguage:(YLLanguageModel *)language
      fromLanguageType:(AppLanguageType)languageType
     completionHandler:(void (^ _Nullable)(void))completionHandler;

/// 设置app的语言类型
/// - Parameters:
///   - languageType: 目标语言类型
///   - restartAlert: 是否提示重启app
+ (void)setAppLanguageWithType:(AppLanguageType)languageType showRestartAlert:(BOOL)restartAlert;

@end

/// 国际化
NSString *YLLanguageLocalizeString(NSString *key);

NS_ASSUME_NONNULL_END
