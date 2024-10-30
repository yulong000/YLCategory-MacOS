//
//  YLPermissionWindowController.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import "YLPermissionWindowController.h"
#import "YLPermissionManager.h"

@interface YLPermissionWindowController ()

@property (nonatomic, strong) YLPermissionViewController *permissionVc;

@end

@implementation YLPermissionWindowController


- (instancetype)init {
    if(self = [super init]) {
        self.window = [[NSWindow alloc] initWithContentRect:NSZeroRect styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable backing:NSBackingStoreBuffered defer:YES];
        self.window.titlebarAppearsTransparent = YES;
        self.window.title = [NSString stringWithFormat:YLPermissionManagerLocalizeString(@"Permission Title"), kAppName];
        [self.window standardWindowButton:NSWindowZoomButton].hidden = YES;
        self.window.opaque = NO;
        self.window.movableByWindowBackground = YES;
        self.window.contentViewController = self.permissionVc;
        [self.window center];
    }
    return self;
}

- (YLPermissionViewController *)permissionVc {
    if(_permissionVc == nil) {
        _permissionVc = [[YLPermissionViewController alloc] init];
    }
    return _permissionVc;
}

@end
