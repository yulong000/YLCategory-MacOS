#import "NSObject+category.h"
#import <objc/runtime.h>
#import <AppKit/AppKit.h>


@interface NSObject ()

@property (nonatomic, strong) NSMutableArray *yl_monitorArray;
@property (nonatomic, strong) NSMutableDictionary *yl_noteDict;
@property (nonatomic, strong) NSMutableDictionary *yl_distributedNoteDict;
@property (nonatomic, strong) NSMutableDictionary *yl_workspaceNoteDict;
@property (nonatomic, copy)   YLPropertyValueChangedHandler yl_propertyValueChangedHandler;

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

- (void)postNotificationWithName:(NSNotificationName)name {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
}

- (void)postNotificationWithName:(NSNotificationName)name userInfo:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:userInfo];
}

- (void)addNotificationName:(NSNotificationName)name handler:(YLNotificationHandler)handler {
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

- (void)removeNotificationName:(NSNotificationName)name {
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

- (void)postDistributedNotificationWithName:(NSNotificationName)name {
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:nil deliverImmediately:YES];
}

- (void)postDistributedNotificationWithName:(NSNotificationName)name userInfo:(NSDictionary *)userInfo {
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:userInfo deliverImmediately:YES];
}

- (void)addDistributedNotificationName:(NSNotificationName)name handler:(YLNotificationHandler)handler {
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

- (void)removeDistributedNotificationName:(NSNotificationName)name {
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
- (void)postWorkspaceNotificationWithName:(NSNotificationName _Nonnull)name {
    [[NSWorkspace sharedWorkspace].notificationCenter postNotificationName:name object:nil];
}

- (void)postWorkspaceNotificationWithName:(NSNotificationName _Nonnull)name userInfo:(NSDictionary * _Nullable)userInfo {
    [[NSWorkspace sharedWorkspace].notificationCenter postNotificationName:name object:nil userInfo:userInfo];
}

- (void)addWorkspaceNotificationName:(NSNotificationName _Nonnull)name handler:(YLNotificationHandler _Nullable)handler {
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

- (void)removeWorkspaceNotificationName:(NSNotificationName _Nonnull)name {
    [[NSWorkspace sharedWorkspace].notificationCenter removeObserver:self name:name object:nil];
    [self.yl_workspaceNoteDict removeObjectForKey:name];
}

- (NSMutableDictionary *)yl_workspaceNoteDict {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setYl_workspaceNoteDict:(NSMutableDictionary *)yl_workspaceNoteDict {
    objc_setAssociatedObject(self, @selector(yl_workspaceNoteDict), yl_workspaceNoteDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 监听属性值变化

- (YLPropertyValueChangedHandler)yl_propertyValueChangedHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setYl_propertyValueChangedHandler:(YLPropertyValueChangedHandler)yl_propertyValueChangedHandler {
    objc_setAssociatedObject(self, @selector(yl_propertyValueChangedHandler), yl_propertyValueChangedHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)startKvoWithHandler:(YLPropertyValueChangedHandler)handler {
    self.yl_propertyValueChangedHandler = handler;
    [self kvo:YES];
}

- (void)stopKvo {
    self.yl_propertyValueChangedHandler = nil;
    [self kvo:NO];
}

- (void)kvo:(BOOL)begin {
    NSArray *allPropertyArr = [self getAllProperty:[self class]];
    for (NSString *property in allPropertyArr) {
        if(begin) {
            [self addObserver:self forKeyPath:property options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        } else {
            [self removeObserver:self forKeyPath:property];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSArray *allPropertyArr = [self getAllProperty:[self class]];
    if([allPropertyArr containsObject:keyPath]) {
        NSLog(@"%@ 属性值 %@ 发生变化：%@ -> %@", NSStringFromClass([self class]), keyPath, change[NSKeyValueChangeOldKey], change[NSKeyValueChangeNewKey]);
        if(self.yl_propertyValueChangedHandler) {
            self.yl_propertyValueChangedHandler(keyPath, change[NSKeyValueChangeNewKey], change[NSKeyValueChangeOldKey]);
        }
    }
}

#pragma mark 获取所有的属性
- (NSArray *)getAllProperty:(Class)class {
    if(class == NSObject.class) {
        return @[];
    }
    NSMutableArray *arr = [NSMutableArray array];
    unsigned int numIvars = 0;
    Ivar *vars = class_copyIvarList(class, &numIvars);
    for (int i = 0; i < numIvars; i ++) {
        Ivar var = vars[i];
        NSString *key = [NSString stringWithUTF8String:ivar_getName(var)];
        if(key.length > 0) {
            key = [key substringFromIndex:1];
        }
        [arr addObject:key];
    }
    free(vars);
    // 查找父类的属性
    [arr addObjectsFromArray:[self getAllProperty:[class superclass]]];
    return arr;
}

@end
