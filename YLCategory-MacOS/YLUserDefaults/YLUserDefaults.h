//
//  YLUserDefaults.h
//  iTab
//
//  Created by 魏宇龙 on 2023/8/29.
//
//  Copyright Ningbo Shangguan Technology Co.,Ltd. All Rights Reserved.
//  宁波上官科技有限公司版权所有，保留一切权利。
//
    

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLUserDefaults : NSObject

@property (readonly) NSUserDefaults *userDefaults;
@property (readonly, nullable) NSUserDefaults *groupDefaults;

+ (instancetype)share;

/// 设置 app group
/// - Parameter groupName: name
- (void)setGroupName:(NSString *)groupName;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

#pragma mark - app

- (void)setObject:(nullable id)obj forKey:(NSString *)key;
- (nullable id)objectForKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;

- (nullable NSString *)stringForKey:(NSString *)key;
- (nullable NSArray *)arrayForKey:(NSString *)key;
- (nullable NSDictionary *)dictionaryForKey:(NSString *)key;
- (nullable NSData *)dataForKey:(NSString *)key;

- (void)setInteger:(NSInteger)value forKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key;

- (void)setFloat:(float)value forKey:(NSString *)key;
- (float)floatForKey:(NSString *)key;

- (void)setDouble:(double)value forKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;

- (void)setBool:(BOOL)value forKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key;

- (void)setURL:(nullable NSURL *)url forKey:(NSString *)key;
- (nullable NSURL *)URLForKey:(NSString *)key;

- (void)setObjectsWithKeys:(NSDictionary <NSString *, id> *)keyValues;

#pragma mark - group

- (void)setObject:(nullable id)obj forGroupKey:(NSString *)key;
- (nullable id)objectForGroupKey:(NSString *)key;
- (void)removeObjectForGroupKey:(NSString *)key;

- (nullable NSString *)stringForGroupKey:(NSString *)key;
- (nullable NSArray *)arrayForGroupKey:(NSString *)key;
- (nullable NSDictionary *)dictionaryForGroupKey:(NSString *)key;
- (nullable NSData *)dataForGroupKey:(NSString *)key;

- (void)setInteger:(NSInteger)value forGroupKey:(NSString *)key;
- (NSInteger)integerForGroupKey:(NSString *)key;

- (void)setFloat:(float)value forGroupKey:(NSString *)key;
- (float)floatForGroupKey:(NSString *)key;

- (void)setDouble:(double)value forGroupKey:(NSString *)key;
- (double)doubleForGroupKey:(NSString *)key;

- (void)setBool:(BOOL)value forGroupKey:(NSString *)key;
- (BOOL)boolForGroupKey:(NSString *)key;

- (void)setURL:(nullable NSURL *)url forGroupKey:(NSString *)key;
- (nullable NSURL *)URLForGroupKey:(NSString *)key;

- (void)setObjectsWithGroupKeys:(NSDictionary<NSString *,id> *)keyValues;

@end

NS_ASSUME_NONNULL_END
