//
//  YLUtility.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/4/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLUtility : NSObject

// 常用的block, 等同于 dispatch_block_t
typedef void (^VoidBlock)(void);

// 延时操作
void dispatchAfterDelay(NSTimeInterval delay, dispatch_block_t block);

@end

NS_ASSUME_NONNULL_END
