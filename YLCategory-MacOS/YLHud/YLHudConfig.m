//
//  YLHudConfig.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import "YLHudConfig.h"

@implementation YLHudConfig

+ (instancetype)share {
    static YLHudConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[YLHudConfig alloc] init];
        config.style = YLHudStyleAuto;
        config.movable = YES;
    });
    return config;
}

@end
