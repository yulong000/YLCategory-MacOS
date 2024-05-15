#import "NSObject+category.h"
#import <objc/runtime.h>
#import <AppKit/AppKit.h>


@interface NSObject ()

@property (nonatomic, strong) NSMutableArray *yl_monitorArray;
@property (nonatomic, strong) NSMutableDictionary *yl_noteDict;
@property (nonatomic, strong) NSMutableDictionary *yl_distributedNoteDict;
@property (nonatomic, strong) NSMutableDictionary *yl_workspaceNoteDict;

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
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setYl_monitorArray:(NSMutableArray *)yl_monitorArray {
    objc_setAssociatedObject(self, @selector(yl_monitorArray), yl_monitorArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setYl_noteDict:(NSMutableDictionary *)yl_noteDict {
    objc_setAssociatedObject(self, @selector(yl_noteDict), yl_noteDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 分布式通知事件

- (void)postDistributedNotificationWithName:(NSString *)name {
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:nil deliverImmediately:YES];
}

- (void)postDistributedNotificationWithName:(NSString *)name userInfo:(NSDictionary *)userInfo {
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:userInfo deliverImmediately:YES];
}

- (void)addDistributedNotificationName:(NSString *)name handler:(YLNotificationHandler)handler {
    if(name.isValidString == NO || handler == nil)  return;
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(yl_DistributedNotificationMsg:) name:name object:nil suspensionBehavior:NSNotificationSuspensionBehaviorDeliverImmediately];
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
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setYl_distributedNoteDict:(NSMutableDictionary *)yl_distributedNoteDict {
    objc_setAssociatedObject(self, @selector(yl_distributedNoteDict), yl_distributedNoteDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - 系统通知
- (void)postWorkspaceNotificationWithName:(NSString * _Nonnull)name {
    [[NSWorkspace sharedWorkspace].notificationCenter postNotificationName:name object:nil];
}

- (void)postWorkspaceNotificationWithName:(NSString * _Nonnull)name userInfo:(NSDictionary * _Nullable)userInfo {
    [[NSWorkspace sharedWorkspace].notificationCenter postNotificationName:name object:nil userInfo:userInfo];
}

- (void)addWorkspaceNotificationName:(NSString * _Nonnull)name handler:(YLNotificationHandler _Nullable)handler {
    if(name.isValidString == NO || handler == nil)  return;
    [[NSWorkspace sharedWorkspace].notificationCenter addObserver:self selector:@selector(yl_workspaceNotificationMsg:) name:name object:nil];
    if(self.yl_workspaceNoteDict == nil) {
        self.yl_workspaceNoteDict = [NSMutableDictionary dictionary];
    }
    self.yl_workspaceNoteDict[name] = handler;
}

- (void)yl_workspaceNotificationMsg:(NSNotification *)note {
    YLNotificationHandler handler = [self.yl_workspaceNoteDict objectForKey:note.name];
    if(handler) {
        handler(note);
    }
}

- (void)removeAllWorkspaceNotifications {
    [[NSWorkspace sharedWorkspace].notificationCenter removeObserver:self];
    [self.yl_workspaceNoteDict removeAllObjects];
}

- (void)removeWorkspaceNotificationName:(NSString * _Nonnull)name {
    [[NSWorkspace sharedWorkspace].notificationCenter removeObserver:self name:name object:nil];
    [self.yl_workspaceNoteDict removeObjectForKey:name];
}

- (NSMutableDictionary *)yl_workspaceNoteDict {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setYl_workspaceNoteDict:(NSMutableDictionary *)yl_workspaceNoteDict {
    objc_setAssociatedObject(self, @selector(yl_workspaceNoteDict), yl_workspaceNoteDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
