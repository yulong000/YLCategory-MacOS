//
//  NSScreen+category.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2023/11/16.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSScreen (category)

@property (readonly, nonatomic, assign) CGFloat x;
@property (readonly, nonatomic, assign) CGFloat y;
@property (readonly, nonatomic, assign) CGFloat width;
@property (readonly, nonatomic, assign) CGFloat height;
@property (readonly, nonatomic, assign) NSSize  size;
@property (readonly, nonatomic, assign) NSPoint origin;
@property (readonly, nonatomic, assign) CGFloat centerX;
@property (readonly, nonatomic, assign) CGFloat centerY;
@property (readonly, nonatomic, assign) NSPoint center;

@property (readonly, nonatomic, assign) CGFloat maxX;
@property (readonly, nonatomic, assign) CGFloat maxY;

@property (readonly, nonatomic, assign) BOOL isBuiltin;
@property (class, nullable, readonly, nonatomic) NSScreen *builtinScreen;

@end

NS_ASSUME_NONNULL_END
