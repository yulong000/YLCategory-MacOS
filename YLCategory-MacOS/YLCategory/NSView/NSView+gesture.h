//
//  NSView+gesture.h
//  iCopy
//
//  Created by 魏宇龙 on 2022/8/31.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

// 手势回调
typedef void (^NSViewClickGestureHandler)(id view, NSClickGestureRecognizer *click);
typedef void (^NSViewPanGestureHandler)(id view, NSPanGestureRecognizer *pan);
typedef void (^NSViewPressGestureHandler)(id view, NSPressGestureRecognizer *press);

@interface NSView (gesture)

- (void)addClickGestureWithHandler:(NSViewClickGestureHandler)handler;
- (void)addPanGestureWithHandler:(NSViewPanGestureHandler)handler;
- (void)addPressGestureWithHandler:(NSViewPressGestureHandler)handler;

- (void)addClickGestureWithDelegate:(id _Nullable)delegate handler:(NSViewClickGestureHandler)handler;
- (void)addPanGestureWithDelegate:(id _Nullable)delegate handler:(NSViewPanGestureHandler)handler;
- (void)addPressGestureWithDelegate:(id _Nullable)delegate handler:(NSViewPressGestureHandler)handler;

@end

NS_ASSUME_NONNULL_END
