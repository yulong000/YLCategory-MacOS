//
//  YLLanguageModel.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import "YLLanguageModel.h"
#import "YLLanguage.h"

@implementation YLLanguageModel

+ (instancetype)languageWithType:(AppLanguageType)type {
    YLLanguageModel *model = [[YLLanguageModel alloc] init];
    model.type = type;
    return model;
}

- (void)setType:(AppLanguageType)type {
    _type = type;
    switch (type) {
        case AppLanguageTypeSystem:
            self.code = @"";
            self.title = YLLanguageLocalizeString(@"Follow The System");
            break;
        case AppLanguageTypeChineseSimplified:
            self.code = @"zh-Hans";
            self.title = @"简体中文";
            break;
        case AppLanguageTypeChineseTraditional:
            self.code = @"zh-Hant";
            self.title = @"繁體中文";
            break;
        case AppLanguageTypeEnglish:
            self.code = @"en";
            self.title = @"English";
            break;
        case AppLanguageTypeJapanese:
            self.code = @"ja";
            self.title = @"日本語";
            break;
        case AppLanguageTypeKorean:
            self.code = @"ko";
            self.title = @"한국어";
            break;
        case AppLanguageTypeFrench:
            self.code = @"fr";
            self.title = @"Français";
            break;
        case AppLanguageTypeSpanish:
            self.code = @"es";
            self.title = @"Español";
            break;
        case AppLanguageTypePortuguese:
            self.code = @"pt-PT";
            self.title = @"Português";
            break;
        case AppLanguageTypeGerman:
            self.code = @"de";
            self.title = @"Deutsch";
            break;
        default:
            self.code = @"";
            self.title = YLLanguageLocalizeString(@"Unknown");
            break;
    }
}

@end
