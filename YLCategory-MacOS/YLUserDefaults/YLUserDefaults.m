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
@property (nonatomic, strong) NSUserDefaults *groupDefaults;

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
    }
    return self;
}

- (void)setGroupName:(NSString *)groupName {
    self.groupDefaults = [[NSUserDefaults alloc] initWithSuiteName:groupName];
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

@end
