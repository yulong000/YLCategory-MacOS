//
//  YLPermissionWindowController.h
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import <Cocoa/Cocoa.h>
#import "YLPermissionViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLPermissionWindowController : NSWindowController

@property (nonatomic, readonly) YLPermissionViewController *permissionVc;

@end

NS_ASSUME_NONNULL_END
