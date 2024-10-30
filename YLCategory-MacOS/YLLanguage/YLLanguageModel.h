//
//  YLLanguageModel.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AppLanguageType) {
    AppLanguageTypeSystem,                      // 跟随系统
    AppLanguageTypeChineseSimplified,           // 简体中文
    AppLanguageTypeChineseTraditional,          // 繁体中文
    AppLanguageTypeEnglish,                     // 英语
    AppLanguageTypeJapanese,                    // 日语
    AppLanguageTypeKorean,                      // 韩语
    AppLanguageTypeFrench,                      // 法语
    AppLanguageTypeSpanish,                     // 西班牙语
    AppLanguageTypePortuguese,                  // 葡萄牙语
    AppLanguageTypeGerman,                      // 德语
};

@interface YLLanguageModel : NSObject

/// 语言类型
@property (nonatomic, assign) AppLanguageType type;
/// 对应的字符
@property (nonatomic, copy)   NSString *code;
/// 显示的标题
@property (nonatomic, copy)   NSString *title;

+ (instancetype)languageWithType:(AppLanguageType)type;


@end

NS_ASSUME_NONNULL_END
