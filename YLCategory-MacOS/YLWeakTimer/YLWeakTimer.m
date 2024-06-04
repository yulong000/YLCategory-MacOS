//
//  YLWeakTimer.m
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import "YLWeakTimer.h"
#import <AppKit/AppKit.h>

@interface YLWeakTimerTarget : NSObject

@property (nonatomic, copy)   YLTimerRepeatBlock handler;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak)   id target;
/// 监听系统从休眠中恢复
@property (nonatomic, strong) id observer;

@end

@implementation YLWeakTimerTarget

- (instancetype)init {
    if(self = [super init]) {
        __weak typeof(self) weakSelf = self;
        self.observer = [[NSWorkspace sharedWorkspace].notificationCenter addObserverForName:NSWorkspaceDidWakeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull notification) {
            // 从休眠中恢复，防止定时器失效，重新设置下时间
            // 系统休眠时，偶尔会出现bug，定时器无法正常运行，不知道是定时器从循环中退出了，还是被系统设置了fireDate = [NSDate distantFuture]
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:weakSelf.timer.timeInterval]];
            });
        }];
    }
    return self;
}

- (void)fire {
    if(self.target == nil) {
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    if(self.handler) {
        self.handler(self.timer);
    }
}

- (void)dealloc {
    NSLog(@"timer dealloc");
    [[NSWorkspace sharedWorkspace].notificationCenter removeObserver:self.observer];
}

@end

@implementation YLWeakTimer

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)interval
                            target:(id)target
                     repeatHandler:(YLTimerRepeatBlock)handler {
    YLWeakTimerTarget *timerTarget = [[YLWeakTimerTarget alloc] init];
    timerTarget.handler = handler;
    timerTarget.target = target;
    timerTarget.timer = [NSTimer timerWithTimeInterval:interval target:timerTarget selector:@selector(fire) userInfo:nil repeats:YES];
    return timerTarget.timer;
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)interval
                            target:(id)target
                           handler:(YLTimerRepeatBlock)handler {
    YLWeakTimerTarget *timerTarget = [[YLWeakTimerTarget alloc] init];
    timerTarget.handler = handler;
    timerTarget.target = target;
    timerTarget.timer = [NSTimer timerWithTimeInterval:interval target:timerTarget selector:@selector(fire) userInfo:nil repeats:NO];
    return timerTarget.timer;
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)interval
                            target:(id)target
                          userInfo:(nullable id)userInfo
                     repeatHandler:(YLTimerRepeatBlock)handler {
    YLWeakTimerTarget *timerTarget = [[YLWeakTimerTarget alloc] init];
    timerTarget.handler = handler;
    timerTarget.target = target;
    timerTarget.timer = [NSTimer timerWithTimeInterval:interval target:timerTarget selector:@selector(fire) userInfo:userInfo repeats:YES];
    return timerTarget.timer;
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)interval
                            target:(id)target
                          userInfo:(nullable id)userInfo
                           handler:(YLTimerRepeatBlock)handler {
    YLWeakTimerTarget *timerTarget = [[YLWeakTimerTarget alloc] init];
    timerTarget.handler = handler;
    timerTarget.target = target;
    timerTarget.timer = [NSTimer timerWithTimeInterval:interval target:timerTarget selector:@selector(fire) userInfo:userInfo repeats:NO];
    return timerTarget.timer;
}

+ (dispatch_block_t)debounceActionWithTimeInterval:(CGFloat)delay action:(dispatch_block_t)action {
    __block NSInteger index = 0;
    return ^ {
        NSInteger tmpIndex = ++ index;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(tmpIndex == index) {
                if(action) {
                    action();
                }
                index = 0;
            }
        });
    };
}

+ (dispatch_block_t)onceActionWithTimeInterval:(CGFloat)interval action:(dispatch_block_t)action {
    __block NSInteger index = 0;
    return ^ {
        if(index == 0 && action) {
            action();
        }
        NSInteger tmpIndex = ++ index;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(tmpIndex == index) {
                index = 0;
            }
        });
    };
}

@end
