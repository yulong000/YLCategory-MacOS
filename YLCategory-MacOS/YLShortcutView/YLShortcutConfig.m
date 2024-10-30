//
//  YLShortcutConfig.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/28.
//

#import "YLShortcutConfig.h"

@implementation YLShortcutConfig

+ (instancetype)share {
    static YLShortcutConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[YLShortcutConfig alloc] init];
        config.style = YLShortcutViewStyleSystem;
    });
    return config;
}

@end
