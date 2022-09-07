//
//  NSView+gesture.m
//  iCopy
//
//  Created by 魏宇龙 on 2022/8/31.
//

#import "NSView+gesture.h"
#import <objc/runtime.h>

static const char NSViewClickGestureHandlerKey = '\0';
static const char NSViewPanGestureHandlerKey = '\0';
static const char NSViewPressGestureHandlerKey = '\0';

@implementation NSView (gesture)

#pragma mark - 点击手势

- (void)setClickGestureHandler:(NSViewClickGestureHandler)clickGestureHandler {
    [self willChangeValueForKey:@"clickGestureHandler"];
    objc_setAssociatedObject(self, &NSViewClickGestureHandlerKey, clickGestureHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"clickGestureHandler"];
}

- (NSViewClickGestureHandler)clickGestureHandler {
    return objc_getAssociatedObject(self, &NSViewClickGestureHandlerKey);
}

- (void)addClickGestureWithDelegate:(id)delegate handler:(NSViewClickGestureHandler)handler {
    self.clickGestureHandler = [handler copy];
    NSClickGestureRecognizer *click = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    if(delegate) click.delegate = delegate;
    [self addGestureRecognizer:click];
}

- (void)addClickGestureWithHandler:(NSViewClickGestureHandler)handler {
    [self addClickGestureWithDelegate:nil handler:handler];
}

- (void)click:(NSClickGestureRecognizer *)click {
    if(self.clickGestureHandler) {
        self.clickGestureHandler(self, click);
    }
}

#pragma mark - 拖动手势

- (void)setPanGestureHandler:(NSViewPanGestureHandler)panGestureHandler {
    [self willChangeValueForKey:@"panGestureHandler"];
    objc_setAssociatedObject(self, &NSViewPanGestureHandlerKey, panGestureHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"panGestureHandler"];
}

- (NSViewPanGestureHandler)panGestureHandler {
    return objc_getAssociatedObject(self, &NSViewPanGestureHandlerKey);
}

- (void)addPanGestureWithDelegate:(id)delegate handler:(NSViewPanGestureHandler)handler {
    self.panGestureHandler = [handler copy];
    NSPanGestureRecognizer *pan = [[NSPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    if(delegate) pan.delegate = delegate;
    [self addGestureRecognizer:pan];
}

- (void)addPanGestureWithHandler:(NSViewPanGestureHandler)handler {
    [self addPanGestureWithDelegate:nil handler:handler];
}

- (void)pan:(NSPanGestureRecognizer *)pan {
    if(self.panGestureHandler) {
        self.panGestureHandler(self, pan);
    }
}

#pragma mark - 长按手势

- (void)setPressGestureHandler:(NSViewPressGestureHandler)pressGestureHandler {
    [self willChangeValueForKey:@"pressGestureHandler"];
    objc_setAssociatedObject(self, &NSViewPressGestureHandlerKey, pressGestureHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"pressGestureHandler"];
}

- (NSViewPressGestureHandler)pressGestureHandler {
    return objc_getAssociatedObject(self, &NSViewPressGestureHandlerKey);
}

- (void)addPressGestureWithDelegate:(id)delegate handler:(NSViewPressGestureHandler)handler {
    self.pressGestureHandler = [handler copy];
    NSPressGestureRecognizer *press = [[NSPressGestureRecognizer alloc] initWithTarget:self action:@selector(press:)];
    if(delegate) press.delegate = delegate;
    [self addGestureRecognizer:press];
}

- (void)addPressGestureWithHandler:(NSViewPressGestureHandler)handler {
    [self addPressGestureWithDelegate:nil handler:handler];
}

- (void)press:(NSPressGestureRecognizer *)press {
    if(self.pressGestureHandler) {
        self.pressGestureHandler(self, press);
    }
}


@end
