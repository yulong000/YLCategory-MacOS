//
//  NSWindow+frame.h
//  Paste
//
//  Created by 魏宇龙 on 2022/5/9.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSWindow (frame)

@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) NSSize  size;
@property (assign, nonatomic) NSPoint origin;
@property (assign, nonatomic) NSRect  bounds;
@property (assign, nonatomic) CGFloat centerX;
@property (assign, nonatomic) CGFloat centerY;

@property (assign, nonatomic) CGFloat top;
@property (assign, nonatomic) CGFloat left;
@property (assign, nonatomic) CGFloat bottom;
@property (assign, nonatomic) CGFloat right;

@property (assign, readonly, nonatomic) CGFloat maxX;
@property (assign, readonly, nonatomic) CGFloat maxY;
@property (assign, readonly, nonatomic) NSPoint centerPoint;

@end

NS_ASSUME_NONNULL_END
