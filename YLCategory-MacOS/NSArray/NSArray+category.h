//
//  NSArray+category.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/3/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (category)


/// 数组中是否包含某个对象
/// 遍历数组，直到*contain的值为YES或者遍历结束
/// - Parameter block: 判断是否包含，如果包含，设置 *contain = YES
- (BOOL)containsObjectUsingBlock:(void (^) (id obj, NSUInteger idx, BOOL *contain))block;


/// 返回数组中符合条件的对象
/// - Parameter block: 判断条件，返回为 ‘YES’为符合，‘NO’为不符合，如果需要停止，*stop = YES，会返回判断过的符合条件的对象
- (nullable NSMutableArray *)containsObjectsUsingBlock:(BOOL (^) (id obj, NSUInteger idx, BOOL *stop))block;

@end

@interface NSMutableArray (category)

/// 移除数组中的多个对象
/// 遍历数组，将block返回为YES的对象都删除
/// - Parameter block: 需要移除的，返回 'YES', 不需要移除的，返回 'NO'。如果需要停止，*stop = YES
- (void)removeObjectsUsingBlock:(BOOL (^) (id obj, NSUInteger idx, BOOL *stop))block;

@end

NS_ASSUME_NONNULL_END
