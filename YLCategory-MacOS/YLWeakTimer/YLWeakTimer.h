//
//  YLWeakTimer.h
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macro.h"

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


/// 防抖，在延时时间内，重复调用，不会重复响应
/// @param delay 延时响应 （秒）
/// @param action 延时结束后回调
+ (VoidBlock)debounceActionWithTimeInterval:(CGFloat)delay
                                     action:(VoidBlock)action;


@end

NS_ASSUME_NONNULL_END
