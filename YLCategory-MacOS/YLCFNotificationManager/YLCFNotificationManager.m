//
//  YLAppleScript.h
//  Test
//
//  Created by 魏宇龙 on 2023/11/16.
//

#import "YLCFNotificationManager.h"

#define kYLCFNotificationCallbackNameSuffix           @"__YL__callback"

#pragma mark - 监听对象

@interface YLCFNotificationObserver : NSObject

@property (nonatomic, weak) id observer;
@property (nullable)        SEL selector;
@property (nonatomic, copy) YLCFNotificationReceiveHandler receiveHandler;
@property (nonatomic, copy) YLCFNotificationCallbackHandler callbackHandler;

@end

@implementation YLCFNotificationObserver

@end

#pragma mark - CF 通知管理

@interface YLCFNotificationManager ()

/// 存放所有的监听对象
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableArray <YLCFNotificationObserver *> *> *observerDict;

@property (nonatomic, assign) BOOL isSandbox;

@end

@implementation YLCFNotificationManager

+ (instancetype)share {
    static YLCFNotificationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YLCFNotificationManager alloc] init];
        manager.observerDict = [NSMutableDictionary dictionary];
        manager.isSandbox = [[[NSProcessInfo processInfo] environment] objectForKey:@"APP_SANDBOX_CONTAINER_ID"] != nil;
    });
    return manager;
}

- (void)dealloc {
    [[YLCFNotificationManager share] removeAllObservers];
}

#pragma mark - 通知回调
static void YLCFNotificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    NSDictionary *dict = (__bridge NSDictionary *)userInfo;
    NSString *notiName = (__bridge NSString *)name;
    NSMutableArray *arr = [[YLCFNotificationManager share].observerDict objectForKey:notiName];
    for (YLCFNotificationObserver *obj in arr) {
        if(obj.observer != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(obj.selector != nil) {
                    // 传入的是SEL
                    IMP imp = [obj.observer methodForSelector:obj.selector];
                    void (*func)(id, SEL, NSDictionary *) = (void *)imp;
                    if(func != nil) {
                        func(obj.observer, obj.selector, dict);
                    }
                } else if (obj.receiveHandler) {
                    obj.receiveHandler(dict);
                } else if (obj.callbackHandler) {
                    // 传入的回调函数
                    obj.callbackHandler(dict, ^(NSDictionary * _Nullable info) {
                        if([notiName hasSuffix:kYLCFNotificationCallbackNameSuffix] == NO) {
                            [[YLCFNotificationManager share] postCFNotificationWithName:[NSString stringWithFormat:@"%@%@", notiName, kYLCFNotificationCallbackNameSuffix] userInfo:info];
                        }
                    });
                }
            });
        }
    }
}


#pragma mark 添加通知
- (void)addObserver:(id)observer name:(NSNotificationName)name selector:(SEL)selector {
    [self addObserver:observer selector:selector receiveHandler:nil callbackHandler:nil name:name];
}

- (void)addObserver:(id)observer selector:(SEL)selector name:(NSNotificationName)name {
    [self addObserver:observer selector:selector receiveHandler:nil callbackHandler:nil name:name];
}

- (void)addObserver:(id)observer name:(NSNotificationName)name receiveHandler:(YLCFNotificationReceiveHandler)receiveHandler {
    [self addObserver:observer selector:nil receiveHandler:receiveHandler callbackHandler:nil name:name];
}

- (void)addObserver:(id)observer name:(NSNotificationName)name callbackHandler:(YLCFNotificationCallbackHandler)callbackHandler {
    [self addObserver:observer selector:nil receiveHandler:nil callbackHandler:callbackHandler name:name];
}

- (void)addObserver:(id)observer selector:(SEL)selector receiveHandler:(YLCFNotificationReceiveHandler)receiveHandler callbackHandler:(YLCFNotificationCallbackHandler)callbackHandler name:(NSNotificationName)name {
    if(name.length > 0) {
        BOOL containName = [[YLCFNotificationManager share].observerDict objectForKey:name] != nil;
        if(containName == NO) {
            // 未注册过，注册一下
            CFNotificationCenterAddObserver(CFNotificationCenterGetDistributedCenter(),
                                            (__bridge const void *)([YLCFNotificationManager share]),
                                            YLCFNotificationCallback,
                                            (__bridge CFStringRef)name,
                                            NULL,
                                            CFNotificationSuspensionBehaviorDeliverImmediately);
        }
        NSMutableDictionary *dict = [YLCFNotificationManager share].observerDict;
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
                obj.receiveHandler = receiveHandler;
                obj.callbackHandler = callbackHandler;
                containObj = YES;
                break;
            }
        }
        if(containObj == NO) {
            // 不存在，添加
            YLCFNotificationObserver *obj = [[YLCFNotificationObserver alloc] init];
            obj.selector = selector;
            obj.observer = observer;
            obj.receiveHandler = receiveHandler;
            obj.callbackHandler = callbackHandler;
            [arr addObject:obj];
        }
    }
}

#pragma mark - 发送通知
- (void)postCFNotificationWithName:(NSNotificationName)name {
    [[YLCFNotificationManager share] postCFNotificationWithName:name userInfo:nil];
}

#pragma mark 发送通知, 传递内容
- (void)postCFNotificationWithName:(NSNotificationName)name userInfo:(NSDictionary * _Nullable)userInfo {
    [[YLCFNotificationManager share] postCFNotificationWithName:name userInfo:userInfo observer:nil responseHandler:nil];
}

#pragma mark 发送通知，接收回调
- (void)postCFNotificationWithName:(NSNotificationName)name observer:(id)observer responseHandler:(YLCFNotificationResponseHandler)responseHandler {
    [[YLCFNotificationManager share] postCFNotificationWithName:name userInfo:nil observer:observer responseHandler:responseHandler];
}

#pragma mark 发送通知，传递内容，并接收回调
- (void)postCFNotificationWithName:(NSNotificationName)name userInfo:(NSDictionary *)userInfo observer:(id)observer responseHandler:(YLCFNotificationResponseHandler)responseHandler {
    if(YLCFNotificationManager.share.isSandbox) {
        // 沙盒下传递userInfo该通知会收不到
        CFNotificationCenterPostNotificationWithOptions(CFNotificationCenterGetDistributedCenter(), (CFStringRef)name, NULL, NULL, kCFNotificationDeliverImmediately | kCFNotificationPostToAllSessions);
    } else {
        CFNotificationCenterPostNotificationWithOptions(CFNotificationCenterGetDistributedCenter(), (CFStringRef)name, NULL, (CFDictionaryRef)userInfo, kCFNotificationDeliverImmediately | kCFNotificationPostToAllSessions);
    }
    if(observer) {
        [[YLCFNotificationManager share] addObserver:observer name:[NSString stringWithFormat:@"%@%@", name, kYLCFNotificationCallbackNameSuffix] callbackHandler:^(NSDictionary * _Nullable info, YLCFNotificationResponseHandler _Nullable handler) {
            if(responseHandler) {
                responseHandler(info);
            }
        }];
    }
}

#pragma mark - 移除某个通知
- (void)removeObserver:(nonnull id)observer name:(NSNotificationName)name {
    NSMutableArray *arr = [[YLCFNotificationManager share].observerDict valueForKey:name];
    NSMutableArray *deleteArr = [NSMutableArray array];
    for (YLCFNotificationObserver *obj in arr) {
        if(obj.observer == observer || obj.observer == nil) {
            [deleteArr addObject:obj];
        }
    }
    [arr removeObjectsInArray:deleteArr];
    [YLCFNotificationManager share].observerDict[name] = arr;
    if(arr.count == 0) {
        // 已经移除了所有的监听对象, 从通知中心移除监听
        CFNotificationCenterRemoveObserver(CFNotificationCenterGetDistributedCenter(), (__bridge const void *)[YLCFNotificationManager share], (__bridge CFNotificationName)name, NULL);
        [[YLCFNotificationManager share].observerDict removeObjectForKey:name];
    }
}

#pragma mark 移除某个监听对象的所有通知
- (void)removeObserver:(nonnull id)observer {
    NSArray *allKeys = [YLCFNotificationManager share].observerDict.allKeys;
    for(int i = 0; i < allKeys.count; i ++) {
        [[YLCFNotificationManager share] removeObserver:observer name:allKeys[i]];
    }
}

#pragma mark 移除所有通知
- (void)removeAllObservers {
    NSArray *allKeys = [YLCFNotificationManager share].observerDict.allKeys;
    for (NSString *name in allKeys) {
        CFNotificationCenterRemoveObserver(CFNotificationCenterGetDistributedCenter(), (__bridge const void *)[YLCFNotificationManager share], (__bridge CFNotificationName)name, NULL);
    }
    [[YLCFNotificationManager share].observerDict removeAllObjects];
}

@end
