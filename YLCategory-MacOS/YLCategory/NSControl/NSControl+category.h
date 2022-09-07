//
//  NSControl+category.h
//  QQ
//
//  Created by 魏宇龙 on 2022/4/15.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^NSControlClickedHandler)(id control);

@interface NSControl (category)

@property (nonatomic, copy)   NSControlClickedHandler clickedHandler;

@end

NS_ASSUME_NONNULL_END
