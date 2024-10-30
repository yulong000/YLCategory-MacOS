//
//  YLAppleScript.h
//  Test
//
//  Created by 魏宇龙 on 2023/11/16.
//
    

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 接收通知
typedef void (^YLCFNotificationReceiveHandler)(NSDictionary * _Nullable userInfo);
/// 响应通知
typedef void (^YLCFNotificationResponseHandler)(NSDictionary * _Nullable userInfo);
/// 收到后回调
typedef void (^YLCFNotificationCallbackHandler)(NSDictionary * _Nullable userInfo, YLCFNotificationResponseHandler _Nullable handler);

@interface YLCFNotificationManager : NSObject

+ (instancetype)share;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

#pragma mark - 单向发送


/// 添加通知对象
/// - Parameter observer: 监听的对象
/// - Parameter selector: 回调方法
/// - Parameter name: 通知名称
- (void)addObserver:(nonnull id)observer name:(NSNotificationName)name selector:(nonnull SEL)selector;

/// 添加通知对象
/// - Parameter observer: 监听的对象
/// - Parameter name: 通知名称
/// - Parameter receiveHandler: 回调方法
- (void)addObserver:(nonnull id)observer name:(NSNotificationName)name receiveHandler:(YLCFNotificationReceiveHandler _Nullable)receiveHandler;

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


#pragma mark - 发送 + 回调

/// 添加通知对象，接收通知
/// - Parameters:
///   - observer: 监听的对象
///   - name: 通知名称
///   - callbackHandler: 收到通知后并回调
- (void)addObserver:(nonnull id)observer name:(NSNotificationName)name callbackHandler:(YLCFNotificationCallbackHandler)callbackHandler;

/// 发送通知，接收回调。   与 addObserver: name: callbackHandler: 配合使用，   ⚠️ 需要调用removeObserver：移除通知
/// - Parameters:
///   - name: 通知名称
///   - observer: 回调接收对象
///   - responseHandler: 对方收到通知后的回调
- (void)postCFNotificationWithName:(NSNotificationName)name observer:(id)observer responseHandler:(YLCFNotificationResponseHandler _Nullable)responseHandler;

/// 发送通知，接收回调。   与 addObserver: name: callbackHandler: 配合使用，   ⚠️ 需要调用removeObserver：移除通知
/// - Parameters:
///   - name: 通知名称
///   - userInfo: 传递参数   
///   - observer: 回调接收对象, 传nil则不会回调
///   - responseHandler: 对方收到通知后的回调
- (void)postCFNotificationWithName:(NSNotificationName)name userInfo:(NSDictionary * _Nullable)userInfo observer:(id _Nullable)observer responseHandler:(YLCFNotificationResponseHandler _Nullable)responseHandler;


#pragma mark - 移除通知

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
