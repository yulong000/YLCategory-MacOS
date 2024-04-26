#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

/// 通知回调
typedef void (^YLNotificationHandler)(NSNotification * _Nonnull note);

@interface NSObject (category)

/**  长度不为0的字符串  */
- (BOOL)isValidString;

/// 发送通知
- (void)postNotificationWithName:(NSString * _Nonnull)name;
- (void)postNotificationWithName:(NSString * _Nonnull)name userInfo:(NSDictionary * _Nullable)userInfo;
/// 监听通知
- (void)addNotificationName:(NSString * _Nonnull)name handler:(YLNotificationHandler _Nullable)handler;
/// 移除所有监听通知
- (void)removeAllNotifications;
/// 移除某个监听通知
- (void)removeNotificationName:(NSString * _Nonnull)name;

/// 发送分布式通知
- (void)postDistributedNotificationWithName:(NSString * _Nonnull)name;
- (void)postDistributedNotificationWithName:(NSString * _Nonnull)name userInfo:(NSDictionary * _Nullable)userInfo;
/// 监听分布式通知
- (void)addDistributedNotificationName:(NSString * _Nonnull)name handler:(YLNotificationHandler _Nullable)handler;
/// 移除所有分布式监听通知
- (void)removeAllDistributedNotifications;
/// 移除某个分布式监听通知
- (void)removeDistributedNotificationName:(NSString * _Nonnull)name;

/// 发送系统通知
- (void)postWorkspaceNotificationWithName:(NSString * _Nonnull)name;
- (void)postWorkspaceNotificationWithName:(NSString * _Nonnull)name userInfo:(NSDictionary * _Nullable)userInfo;
/// 监听系统通知
- (void)addWorkspaceNotificationName:(NSString * _Nonnull)name handler:(YLNotificationHandler _Nullable)handler;
/// 移除所有系统监听通知
- (void)removeAllWorkspaceNotifications;
/// 移除某个系统监听通知
- (void)removeWorkspaceNotificationName:(NSString * _Nonnull)name;


/// 添加事件监听, 自动调用 addMonitor:
- (void)addGlobalEventMonitor:(NSEventMask)mask handler:(void (^ _Nullable)(NSEvent * _Nonnull event))block;
- (void)addLocalEventMonitor:(NSEventMask)mask handler:(NSEvent * _Nullable (^ _Nullable)(NSEvent * _Nonnull event))block;

/// 同时添加 global & local 事件监听，自动调用 addMonitor:
- (void)addEventMonitor:(NSEventMask)mask handler:(NSEvent * _Nullable (^ _Nullable)(NSEvent * _Nonnull event))block;

/// 添加其他监听事件对象
- (void)addMonitor:(id _Nonnull)monitor;
- (void)addMonitors:(NSArray * _Nonnull)monitors;

/// 移除所有的监听, 只有通过上面的方法添加的，才能移除
- (void)removeAllMonitors;
/// 移除某个监听
- (void)removeMonitor:(id _Nonnull)monitor;

@end
