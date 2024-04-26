//
//  YLUtility.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/4/8.
//

#import "YLUtility.h"

@implementation YLUtility

// 延时操作
void dispatchAfterDelay(NSTimeInterval delay, dispatch_block_t block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

@end
