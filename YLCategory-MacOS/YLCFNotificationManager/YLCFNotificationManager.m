//
//  YLAppleScript.h
//  Test
//
//  Created by 魏宇龙 on 2023/11/16.
//

#import "YLCFNotificationManager.h"

#pragma mark - 监听对象

@interface YLCFNotificationObserver : NSObject

@property (nonatomic, weak) id observer;
@property (nullable) SEL selector;

@end

@implementation YLCFNotificationObserver

@end

#pragma mark - CF 通知管理

@interface YLCFNotificationManager ()

/// 存放所有的监听对象
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableArray <YLCFNotificationObserver *> *> *observerDict;
/// 是否是沙盒模式
@property (nonatomic, assign) BOOL isSandbox;

@end

@implementation YLCFNotificationManager

+ (instancetype)share {
    static YLCFNotificationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YLCFNotificationManager alloc] init];
        manager.isSandbox = nil != [[[NSProcessInfo processInfo] environment] objectForKey:@"APP_SANDBOX_CONTAINER_ID"];
        manager.observerDict = [NSMutableDictionary dictionary];
    });
    return manager;
}

- (void)dealloc {
    [[YLCFNotificationManager share] removeAllObservers];
}

#pragma mark - 通知回调
static void YLCFNotificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    NSDictionary *dict = (__bridge NSDictionary *)userInfo;
    NSMutableArray *arr = [[YLCFNotificationManager share].observerDict objectForKey:(__bridge NSString *)name];
    for (YLCFNotificationObserver *obj in arr) {
        if(obj.observer && obj.selector) {
            dispatch_async(dispatch_get_main_queue(), ^{
                IMP imp = [obj.observer methodForSelector:obj.selector];
                void (*func)(id, SEL, NSDictionary *) = (void *)imp;
                func(obj.observer, obj.selector, dict);
            });
        }
    }
}


#pragma mark 添加通知
- (void)addObserver:(id)observer selector:(SEL)selector name:(NSNotificationName)name {
    if(name.length > 0) {
        BOOL containName = NO;
        for (NSString *notiName in self.observerDict.allKeys) {
            if([notiName isEqualToString:name]) {
                containName = YES;
                break;
            }
        }
        if(containName == NO) {
            // 未注册过，注册一下
            CFNotificationCenterAddObserver(self.isSandbox ? CFNotificationCenterGetDistributedCenter() : CFNotificationCenterGetDarwinNotifyCenter(),
                                            (__bridge const void *)(self),
                                            YLCFNotificationCallback,
                                            (__bridge CFStringRef)name,
                                            NULL,
                                            CFNotificationSuspensionBehaviorDeliverImmediately);
        }
        NSMutableDictionary *dict = self.observerDict;
        NSMutableArray *arr = [dict valueForKey:name];
        if(arr == nil) {
            arr = [NSMutableArray array];
            [dict setValue:arr forKey:name];
        }
        BOOL containObj = NO;
        for (YLCFNotificationObserver *obj in arr) {
            if(obj.observer == observer) {
                // 已经存在, 将selector添加进去
                obj.selector = selector;
                containObj = YES;
                break;
            }
        }
        if(containObj == NO) {
            // 不存在，添加
            YLCFNotificationObserver *obj = [[YLCFNotificationObserver alloc] init];
            obj.selector = selector;
            obj.observer = observer;
            [arr addObject:obj];
        }
    }
}

#pragma mark - 移除某个通知
- (void)removeObserver:(nonnull id)observer name:(NSNotificationName)name {
    NSMutableArray *arr = [self.observerDict valueForKey:name];
    NSMutableArray *deleteArr = [NSMutableArray array];
    for (YLCFNotificationObserver *obj in arr) {
        if(obj.observer == observer || obj.observer == nil) {
            [deleteArr addObject:obj];
        }
    }
    [arr removeObjectsInArray:deleteArr];
    self.observerDict[name] = arr;
    if(arr.count == 0) {
        // 已经移除了所有的监听对象, 从通知中心移除监听
        CFNotificationCenterRemoveObserver(self.isSandbox ? CFNotificationCenterGetDistributedCenter() : CFNotificationCenterGetDarwinNotifyCenter(), (__bridge const void *)self, (__bridge CFNotificationName)name, NULL);
        [self.observerDict removeObjectForKey:name];
    }
}

#pragma mark 移除某个监听对象的所有通知
- (void)removeObserver:(nonnull id)observer {
    NSArray *allKeys = self.observerDict.allKeys;
    for(int i = 0; i < allKeys.count; i ++) {
        [self removeObserver:observer name:allKeys[i]];
    }
}

#pragma mark 移除所有通知
- (void)removeAllObservers {
    NSArray *allKeys = self.observerDict.allKeys;
    for (NSString *name in allKeys) {
        CFNotificationCenterRemoveObserver(self.isSandbox ? CFNotificationCenterGetDistributedCenter() : CFNotificationCenterGetDarwinNotifyCenter(), (__bridge const void *)self, (__bridge CFNotificationName)name, NULL);
    }
    [self.observerDict removeAllObjects];
}

#pragma mark - 发送通知
- (void)postCFNotificationWithName:(NSNotificationName)name {
    [self postCFNotificationWithName:name userInfo:nil];
}

#pragma mark 发送通知, 传递内容
- (void)postCFNotificationWithName:(NSNotificationName)name userInfo:(NSDictionary * _Nullable)userInfo {
    CFNotificationCenterPostNotificationWithOptions(self.isSandbox ? CFNotificationCenterGetDarwinNotifyCenter() : CFNotificationCenterGetDistributedCenter(), (CFStringRef)name, NULL, (CFDictionaryRef)userInfo, kCFNotificationDeliverImmediately | kCFNotificationPostToAllSessions);
}

@end
