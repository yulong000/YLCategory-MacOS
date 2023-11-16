//
//  YLAppleScript.h
//  Test
//
//  Created by 魏宇龙 on 2023/11/16.
//
    

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLCFNotificationManager : NSObject

+ (instancetype)share;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;


/// 添加通知对象
/// - Parameter observer: 监听的对象
/// - Parameter selector: 回调方法
/// - Parameter name: 通知名称
- (void)addObserver:(nonnull id)observer selector:(nonnull SEL)selector name:(NSNotificationName)name;


/// 发送通知
/// - Parameter name: 通知名称
- (void)postCFNotificationWithName:(NSNotificationName)name;

/// 发送通知
/// - Parameter name: 通知名称
/// - Parameter userInfo: 传递参数
- (void)postCFNotificationWithName:(NSNotificationName)name userInfo:(NSDictionary * _Nullable)userInfo;


/// 移除通知
/// - Parameter observer: 监听对象
/// - Parameter name: 通知名称
- (void)removeObserver:(nonnull id)observer name:(NSNotificationName)name;

/// 移除某个监听对象的所有通知
/// - Parameter observer: 监听对象
- (void)removeObserver:(nonnull id)observer;

/// 移除所有通知
- (void)removeAllObservers;

@end

NS_ASSUME_NONNULL_END
