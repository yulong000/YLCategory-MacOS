#import "NSObject+category.h"
#import <objc/runtime.h>
#import <AppKit/AppKit.h>

static const char YLNotificationDictionaryKey = '\0';
static const char YLDistributedNotificationDictionaryKey = '\0';
static const char YLMonitorArrayKey = '\0';

@interface NSObject ()

@property (nonatomic, strong) NSMutableArray *yl_monitorArray;
@property (nonatomic, strong) NSMutableDictionary *yl_noteDict;
@property (nonatomic, strong) NSMutableDictionary *yl_distributedNoteDict;

@end

@implementation NSObject (category)

#pragma mark 是否是长度不为0的字符串
- (BOOL)isValidString {
    if([self isKindOfClass:[NSString class]]) {
        NSString *str = (NSString *)self;
        return str.length > 0;
    }
    return NO;
}

#pragma mark - 监听事件

- (void)addGlobalEventMonitor:(NSEventMask)mask handler:(void (^)(NSEvent * _Nonnull))block {
    id monitor = [NSEvent addGlobalMonitorForEventsMatchingMask:mask handler:block];
    [self addMonitor:monitor];
}

- (void)addLocalEventMonitor:(NSEventMask)mask handler:(NSEvent * _Nullable (^)(NSEvent * _Nonnull))block {
    id monitor = [NSEvent addLocalMonitorForEventsMatchingMask:mask handler:block];
    [self addMonitor:monitor];
}

- (void)addEventMonitor:(NSEventMask)mask handler:(NSEvent * _Nullable (^)(NSEvent * _Nonnull))block {
    id monitor1 = [NSEvent addGlobalMonitorForEventsMatchingMask:mask handler:^(NSEvent * _Nonnull event) {
        if(block) {
            block(event);
        }
    }];
    id monitor2 = [NSEvent addLocalMonitorForEventsMatchingMask:mask handler:block];
    [self addMonitors:@[monitor1, monitor2]];
}

- (void)addMonitor:(id)monitor {
    if(monitor) {
        [self addMonitors:@[monitor]];
    }
}

- (void)addMonitors:(NSArray *)monitors {
    if(monitors.count == 0) return;
    if(self.yl_monitorArray == nil) {
        self.yl_monitorArray = [NSMutableArray array];
    }
    [self.yl_monitorArray addObjectsFromArray:monitors];
}

- (void)removeAllMonitors {
    // 移除事件监听
    for (id monitor in self.yl_monitorArray) {
        [NSEvent removeMonitor:monitor];
    }
}

- (void)removeMonitor:(id)monitor {
    if(monitor) {
        [NSEvent removeMonitor:monitor];
    }
}

- (NSMutableArray *)yl_monitorArray {
    return objc_getAssociatedObject(self, &YLMonitorArrayKey);
}

- (void)setYl_monitorArray:(NSMutableArray *)yl_monitorArray {
    [self willChangeValueForKey:@"yl_monitorArray"];
    objc_setAssociatedObject(self, &YLMonitorArrayKey, yl_monitorArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"yl_monitorArray"];
}


#pragma mark - 通知事件

- (void)postNotificationWithName:(NSString *)name {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
}

- (void)postNotificationWithName:(NSString *)name userInfo:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:userInfo];
}

- (void)addNotificationName:(NSString *)name handler:(YLNotificationHandler)handler {
    if(name.isValidString == NO || handler == nil)  return;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yl_notificationMsg:) name:name object:nil];
    if(self.yl_noteDict == nil) {
        self.yl_noteDict = [NSMutableDictionary dictionary];
    }
    self.yl_noteDict[name] = handler;
}

- (void)yl_notificationMsg:(NSNotification *)note {
    YLNotificationHandler handler = [self.yl_noteDict objectForKey:note.name];
    if(handler) {
        handler(note);
    }
}

- (void)removeNotificationName:(NSString *)name {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
    [self.yl_noteDict removeObjectForKey:name];
}

- (void)removeAllNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.yl_noteDict removeAllObjects];
}

- (NSMutableDictionary *)yl_noteDict {
    return objc_getAssociatedObject(self, &YLNotificationDictionaryKey);
}

- (void)setYl_noteDict:(NSMutableDictionary *)yl_noteDict {
    [self willChangeValueForKey:@"yl_noteDict"];
    objc_setAssociatedObject(self, &YLNotificationDictionaryKey, yl_noteDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"yl_noteDict"];
}

#pragma mark - 分布式通知事件

- (void)postDistributedNotificationWithName:(NSString *)name {
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:name object:nil];
}

- (void)postDistributedNotificationWithName:(NSString *)name userInfo:(NSDictionary *)userInfo {
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:userInfo];
}

- (void)addDistributedNotificationName:(NSString *)name handler:(YLNotificationHandler)handler {
    if(name.isValidString == NO || handler == nil)  return;
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(yl_DistributedNotificationMsg:) name:name object:nil];
    if(self.yl_distributedNoteDict == nil) {
        self.yl_distributedNoteDict = [NSMutableDictionary dictionary];
    }
    self.yl_distributedNoteDict[name] = handler;
}

- (void)yl_DistributedNotificationMsg:(NSNotification *)note {
    YLNotificationHandler handler = [self.yl_distributedNoteDict objectForKey:note.name];
    if(handler) {
        handler(note);
    }
}

- (void)removeDistributedNotificationName:(NSString *)name {
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
    [self.yl_distributedNoteDict removeObjectForKey:name];
}

- (void)removeAllDistributedNotifications {
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
    [self.yl_distributedNoteDict removeAllObjects];
}

- (NSMutableDictionary *)yl_distributedNoteDict {
    return objc_getAssociatedObject(self, &YLDistributedNotificationDictionaryKey);
}

- (void)setYl_distributedNoteDict:(NSMutableDictionary *)yl_distributedNoteDict {
    [self willChangeValueForKey:@"yl_distributedNoteDict"];
    objc_setAssociatedObject(self, &YLDistributedNotificationDictionaryKey, yl_distributedNoteDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"yl_distributedNoteDict"];
}

@end
