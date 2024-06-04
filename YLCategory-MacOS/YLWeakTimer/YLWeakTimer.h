//
//  YLWeakTimer.h
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^YLTimerRepeatBlock)(NSTimer *timer);

@interface YLWeakTimer : NSObject

/**
 构造一个循环的定时器

 @param interval 重复调用的时间间隔
 @param target 监听者
 @param handler 每次重复的回调
 @return 定时器
 */
+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)interval
                            target:(id)target
                     repeatHandler:(YLTimerRepeatBlock)handler;
/**
 构造一个一次性的定时器

 @param interval 调用的时间间隔
 @param target 监听者
 @param handler 回调
 @return 定时器
 */
+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)interval
                            target:(id)target
                           handler:(YLTimerRepeatBlock)handler;

/**
 构造一个循环的定时器

 @param interval 重复调用的时间间隔
 @param target 监听者
 @param userInfo 自定义信息
 @param handler 每次重复的回调
 @return 定时器
 */
+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)interval
                            target:(id)target
                          userInfo:(nullable id)userInfo
                     repeatHandler:(YLTimerRepeatBlock)handler;
/**
 构造一个一次性的定时器

 @param interval 调用的时间间隔
 @param target 监听者
 @param userInfo 自定义信息
 @param handler 回调
 @return 定时器
 */
+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)interval
                            target:(id)target
                          userInfo:(nullable id)userInfo
                           handler:(YLTimerRepeatBlock)handler;


/// 防抖，在延时时间内，重复调用，只会在最后一次响应
/// @param delay 延时响应 （秒）
/// @param action 延时结束后回调
+ (dispatch_block_t)debounceActionWithTimeInterval:(CGFloat)delay
                                     action:(dispatch_block_t)action;


/// 防抖，在一定时间内，重复调用，只会在第一次时响应
/// @param interval  时间间隔（秒）
/// @param action 回调
+ (dispatch_block_t)onceActionWithTimeInterval:(CGFloat)interval
                                 action:(dispatch_block_t)action;


@end

NS_ASSUME_NONNULL_END
