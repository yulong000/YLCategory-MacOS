//
//  YLWeakTimer.m
//  YLTools
//
//  Created by weiyulong on 2020/4/17.
//  Copyright © 2020 weiyulong. All rights reserved.
//

#import "YLWeakTimer.h"

@interface YLWeakTimerTarget : NSObject

@property (nonatomic, copy)   YLTimerRepeatBlock handler;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak)   id target;

@end

@implementation YLWeakTimerTarget

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
