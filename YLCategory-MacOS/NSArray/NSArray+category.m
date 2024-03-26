//
//  NSArray+category.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/3/25.
//

#import "NSArray+category.h"

@implementation NSArray (category)

- (BOOL)containsObjectUsingBlock:(void (^)(id _Nonnull, NSUInteger, BOOL * _Nonnull))block {
    BOOL contain = NO;
    if(block == nil) {
        return contain;
    }
    NSArray *copyArr = [self copy];
    for (NSUInteger i = 0; i < copyArr.count; i ++) {
        block(copyArr[i], i, &contain);
        if(contain == YES) {
            break;
        }
    }
    return contain;
}

- (NSMutableArray *)containsObjectsUsingBlock:(BOOL (^)(id _Nonnull, NSUInteger, BOOL * _Nonnull))block {
    if(block == nil) {
        return nil;
    }
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *copyArr = [self copy];
    BOOL stop = NO;
    for (NSUInteger i = 0; i < copyArr.count; i ++) {
        id obj = copyArr[i];
        if(block(obj, i, &stop) == YES) {
            [arr addObject:obj];
        }
        if(stop == YES) {
            return arr;
        }
    }
    if(arr.count > 0) {
        return arr;
    }
    return nil;
}

@end

@implementation NSMutableArray (category)

- (void)removeObjectsUsingBlock:(BOOL (^)(id _Nonnull, NSUInteger, BOOL * _Nonnull))block {
    if(block == nil)    return;
    NSArray *copyArr = [self copy];
    BOOL stop = NO;
    for (NSUInteger i = 0; i < copyArr.count; i ++) {
        id obj = copyArr[i];
        BOOL remove = block(obj, i, &stop);
        if(remove) {
            [self removeObject:obj];
        }
        if(stop) {
            break;
        }
    }
}

@end
