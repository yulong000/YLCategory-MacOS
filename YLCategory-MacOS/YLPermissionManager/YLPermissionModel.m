//
//  YLPermissionModel.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import "YLPermissionModel.h"

@implementation YLPermissionModel

+ (instancetype)modelWithAuthType:(YLPermissionAuthType)authType desc:(NSString *)desc {
    return [[self alloc] initWithAuthType:authType desc:desc];
}

- (instancetype)initWithAuthType:(YLPermissionAuthType)authType desc:(NSString *)desc {
    if(self = [super init]) {
        self.authType = authType;
        self.desc = desc;
    }
    return self;
}

@end
