//
//  YLUpdateWindowController.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import "YLUpdateWindowController.h"
#import "YLUpdateViewController.h"
#import "YLUpdateManager.h"

@interface YLUpdateWindowController ()

@property (nonatomic, strong) YLUpdateViewController *vc;

@end

@implementation YLUpdateWindowController

- (instancetype)init {
    if(self = [super init]) {
        self.window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 500, 300) styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskClosable backing:NSBackingStoreBuffered defer:YES];
        self.window.titlebarAppearsTransparent = YES;
        [self.window standardWindowButton:NSWindowZoomButton].hidden = YES;
        self.window.opaque = NO;
        self.window.movableByWindowBackground = YES;
        self.window.contentViewController = self.vc;
        [self.window center];
    }
    return self;
}

- (YLUpdateViewController *)vc {
    if(_vc == nil) {
        _vc = [[YLUpdateViewController alloc] init];
    }
    return _vc;
}

- (void)showNewVersion:(NSString *)newVersion info:(NSString *)info {
    self.window.title = [NSString stringWithFormat:@"%@ : %@", YLUpdateManagerLocalizeString(@"New version found"), newVersion];
    self.vc.info = info;
}

@end
