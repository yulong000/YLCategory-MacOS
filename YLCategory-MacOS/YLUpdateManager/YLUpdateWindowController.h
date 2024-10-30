//
//  YLUpdateWindowController.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLUpdateWindowController : NSWindowController

- (void)showNewVersion:(NSString *)newVersion info:(NSString *)info;

@end

NS_ASSUME_NONNULL_END
