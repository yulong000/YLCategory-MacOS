//
//  YLUserDefaults.m
//  iTab
//
//  Created by 魏宇龙 on 2023/8/29.
//
//  Copyright Ningbo Shangguan Technology Co.,Ltd. All Rights Reserved.
//  宁波上官科技有限公司版权所有，保留一切权利。
//
    

#import "YLUserDefaults.h"

@interface YLUserDefaults ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;
/// 只有一个group
@property (nonatomic, strong) NSUserDefaults *groupDefaults;
/// 多个group
@property (nonatomic, strong) NSMutableDictionary *groupDefaultsDict;

@end

@implementation YLUserDefaults

+ (instancetype)share {
    static YLUserDefaults *userDefaults;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userDefaults = [[self alloc] init];
    });
    return userDefaults;
}

- (instancetype)init {
    if(self = [super init]) {
        self.userDefaults = [NSUserDefaults standardUserDefaults];
        self.groupDefaultsDict = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - app

- (void)setObject:(nullable id)obj forKey:(NSString *)key {
    [self.userDefaults setObject:obj forKey:key];
    [self.userDefaults synchronize];
}

- (nullable id)objectForKey:(NSString *)key {
    return [self.userDefaults objectForKey:key];
}

- (void)removeObjectForKey:(NSString *)key {
    [self.userDefaults removeObjectForKey:key];
    [self.userDefaults synchronize];
}

- (nullable NSString *)stringForKey:(NSString *)key {
    return [self.userDefaults stringForKey:key];
}

- (nullable NSArray *)arrayForKey:(NSString *)key {
    return [self.userDefaults arrayForKey:key];
}

- (nullable NSDictionary *)dictionaryForKey:(NSString *)key {
    return [self.userDefaults dictionaryForKey:key];
}

- (nullable NSData *)dataForKey:(NSString *)key {
    return [self.userDefaults dataForKey:key];
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)key {
    [self.userDefaults setInteger:value forKey:key];
    [self.userDefaults synchronize];
}

- (NSInteger)integerForKey:(NSString *)key {
    return [self.userDefaults integerForKey:key];
}

- (void)setFloat:(float)value forKey:(NSString *)key {
    [self.userDefaults setFloat:value forKey:key];
    [self.userDefaults synchronize];
}

- (float)floatForKey:(NSString *)key {
    return [self.userDefaults floatForKey:key];
}

- (void)setDouble:(double)value forKey:(NSString *)key {
    [self.userDefaults setDouble:value forKey:key];
    [self.userDefaults synchronize];
}

- (double)doubleForKey:(NSString *)key {
    return [self.userDefaults doubleForKey:key];
}

- (void)setBool:(BOOL)value forKey:(NSString *)key {
    [self.userDefaults setBool:value forKey:key];
    [self.userDefaults synchronize];
}
- (BOOL)boolForKey:(NSString *)key {
    return [self.userDefaults boolForKey:key];
}

- (void)setURL:(nullable NSURL *)url forKey:(NSString *)key {
    [self.userDefaults setURL:url forKey:key];
    [self.userDefaults synchronize];
}
- (nullable NSURL *)URLForKey:(NSString *)key {
    return [self.userDefaults URLForKey:key];
}

- (void)setObjectsWithKeys:(NSDictionary <NSString *, id> *)keyValues {
    for (NSString *key in keyValues) {
        [self.userDefaults setObject:keyValues[key] forKey:key];
    }
    [self.userDefaults synchronize];
}

#pragma mark - group

- (void)setGroupName:(NSString *)groupName {
    if(groupName == nil || groupName.length == 0) return;
    self.groupDefaults = [[NSUserDefaults alloc] initWithSuiteName:groupName];
    self.groupDefaultsDict[groupName] = self.groupDefaults;
}

- (void)setObject:(nullable id)obj forGroupKey:(nonnull NSString *)key {
    [self.groupDefaults setObject:obj forKey:key];
    [self.groupDefaults synchronize];
}

- (nullable id)objectForGroupKey:(NSString *)key {
    return [self.groupDefaults objectForKey:key];
}

- (void)removeObjectForGroupKey:(NSString *)key {
    [self.groupDefaults removeObjectForKey:key];
    [self.groupDefaults synchronize];
}

- (nullable NSString *)stringForGroupKey:(NSString *)key {
    return [self.groupDefaults stringForKey:key];
}

- (nullable NSArray *)arrayForGroupKey:(NSString *)key {
    return [self.groupDefaults arrayForKey:key];
}

- (nullable NSDictionary *)dictionaryForGroupKey:(NSString *)key {
    return [self.groupDefaults dictionaryForKey:key];
}

- (nullable NSData *)dataForGroupKey:(NSString *)key {
    return [self.groupDefaults dataForKey:key];
}

- (void)setInteger:(NSInteger)value forGroupKey:(nonnull NSString *)key {
    [self.groupDefaults setInteger:value forKey:key];
    [self.groupDefaults synchronize];
}

- (NSInteger)integerForGroupKey:(NSString *)key {
    return [self.groupDefaults integerForKey:key];
}

- (void)setFloat:(float)value forGroupKey:(nonnull NSString *)key {
    [self.groupDefaults setFloat:value forKey:key];
    [self.groupDefaults synchronize];
}

- (float)floatForGroupKey:(NSString *)key {
    return [self.groupDefaults floatForKey:key];
}

- (void)setDouble:(double)value forGroupKey:(nonnull NSString *)key {
    [self.groupDefaults setDouble:value forKey:key];
    [self.groupDefaults synchronize];
}

- (double)doubleForGroupKey:(NSString *)key {
    return [self.groupDefaults doubleForKey:key];
}

- (void)setBool:(BOOL)value forGroupKey:(nonnull NSString *)key {
    [self.groupDefaults setBool:value forKey:key];
    [self.groupDefaults synchronize];
}
- (BOOL)boolForGroupKey:(NSString *)key {
    return [self.groupDefaults boolForKey:key];
}

- (void)setURL:(nullable NSURL *)url forGroupKey:(nonnull NSString *)key {
    [self.groupDefaults setURL:url forKey:key];
    [self.groupDefaults synchronize];
}
- (nullable NSURL *)URLForGroupKey:(NSString *)key {
    return [self.groupDefaults URLForKey:key];
}

- (void)setObjectsWithGroupKeys:(NSDictionary<NSString *,id> *)keyValues {
    for (NSString *key in keyValues) {
        [self.groupDefaults setObject:keyValues[key] forKey:key];
    }
    [self.groupDefaults synchronize];
}


#pragma mark - groups

- (NSUserDefaults *)addGroupWithName:(NSString *)groupName {
    if(groupName == nil || groupName.length == 0) return nil;
    NSUserDefaults *defaults = [self.groupDefaultsDict objectForKey:groupName];
    if(defaults != nil) {
        // 已经存在了，不需要再次添加
        return defaults;
    }
    NSUserDefaults *group = [[NSUserDefaults alloc] initWithSuiteName:groupName];
    self.groupDefaultsDict[groupName] = group;
    return group;
}

- (void)removeGroupWithName:(NSString *)groupName {
    NSUserDefaults *group = [self.groupDefaultsDict objectForKey:groupName];
    if(group == nil) {
        return;
    }
    [self.groupDefaultsDict removeObjectForKey:groupName];
    if(group == self.groupDefaults) {
        self.groupDefaults = nil;
    }
}

- (NSUserDefaults *)getGroupDefaultsWithName:(NSString *)groupName {
    return [self.groupDefaultsDict objectForKey:groupName];
}

- (void)setObject:(nullable id)obj forGroup:(nonnull NSString *)groupName key:(nonnull NSString *)key {
    NSUserDefaults *defaults = [self getGroupDefaultsWithName:groupName];
    [defaults setObject:obj forKey:key];
    [defaults synchronize];
}

- (nullable id)objectForGroup:(NSString *)groupName key:(NSString *)key {
    NSUserDefaults *defaults = [self getGroupDefaultsWithName:groupName];
    return [defaults objectForKey:key];
}

- (void)removeObjectForGroup:(NSString *)groupName key:(NSString *)key {
    NSUserDefaults *defaults = [self getGroupDefaultsWithName:groupName];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

- (nullable NSString *)stringForGroup:(NSString *)groupName key:(NSString *)key {
    NSUserDefaults *defaults = [self getGroupDefaultsWithName:groupName];
    return [defaults stringForKey:key];
}

- (nullable NSArray *)arrayForGroup:(NSString *)groupName key:(NSString *)key {
    NSUserDefaults *defaults = [self getGroupDefaultsWithName:groupName];
    return [defaults arrayForKey:key];
}

- (nullable NSDictionary *)dictionaryForGroup:(NSString *)groupName key:(NSString *)key {
    NSUserDefaults *defaults = [self getGroupDefaultsWithName:groupName];
    return [defaults dictionaryForKey:key];
}

- (nullable NSData *)dataForGroup:(NSString *)groupName key:(NSString *)key {
    NSUserDefaults *defaults = [self getGroupDefaultsWithName:groupName];
    return [defaults dataForKey:key];
}

- (void)setInteger:(NSInteger)value forGroup:(nonnull NSString *)groupName key:(nonnull NSString *)key {
    NSUserDefaults *defaults = [self getGroupDefaultsWithName:groupName];
    [defaults setInteger:value forKey:key];
    [defaults synchronize];
}

- (NSInteger)integerForGroup:(NSString *)groupName key:(NSString *)key {
    NSUserDefaults *defaults = [self getGroupDefaultsWithName:groupName];
    return [defaults integerForKey:key];
}

- (void)setFloat:(float)value forGroup:(nonnull NSString *)groupName key:(nonnull NSString *)key {
    NSUserDefaults *defaults = [self getGroupDefaultsWithName:groupName];
    [defaults setFloat:value forKey:key];
    [defaults synchronize];
}

- (float)floatForGroup:(NSString *)groupName key:(NSString *)key {
    NSUserDefaults *defaults = [self getGroupDefaultsWithName:groupName];
    return [defaults floatForKey:key];
}

- (void)setDouble:(double)value forGroup:(nonnull NSString *)groupName key:(nonnull NSString *)key {
    NSUserDefaults *defaults = [self getGroupDefaultsWithName:groupName];
    [defaults setDouble:value forKey:key];
    [defaults synchronize];
}

- (double)doubleForGroup:(NSString *)groupName key:(NSString *)key {
    NSUserDefaults *defaults = [self getGroupDefaultsWithName:groupName];
    return [defaults doubleForKey:key];
}

- (void)setBool:(BOOL)value forGroup:(nonnull NSString *)groupName key:(nonnull NSString *)key {
    NSUserDefaults *defaults = [self getGroupDefaultsWithName:groupName];
    [defaults setBool:value forKey:key];
    [defaults synchronize];
}
- (BOOL)boolForGroup:(NSString *)groupName key:(NSString *)key {
    NSUserDefaults *defaults = [self getGroupDefaultsWithName:groupName];
    return [defaults boolForKey:key];
}

- (void)setURL:(nullable NSURL *)url forGroup:(nonnull NSString *)groupName key:(nonnull NSString *)key {
    NSUserDefaults *defaults = [self getGroupDefaultsWithName:groupName];
    [defaults setURL:url forKey:key];
    [defaults synchronize];
}
- (nullable NSURL *)URLForGroup:(NSString *)groupName key:(NSString *)key {
    NSUserDefaults *defaults = [self getGroupDefaultsWithName:groupName];
    return [defaults URLForKey:key];
}

- (void)setObjectsWithGroup:(NSString *)groupName keys:(NSDictionary<NSString *,id> *)keyValues {
    NSUserDefaults *defaults = [self getGroupDefaultsWithName:groupName];
    for (NSString *key in keyValues) {
        [defaults setObject:keyValues[key] forKey:key];
    }
    [defaults synchronize];
}

@end
