//
//  ViewController.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2022/9/7.
//

#import "ViewController.h"
#import "YLCategory.h"
#import "SecondViewController.h"

@interface ViewController ()


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    YLShortcutView *shortcutView = [[YLShortcutView alloc] initWithFrame:NSMakeRect(20, 50, 150, 30)];
    shortcutView.changedHandler = ^(YLShortcutView * _Nonnull sender, MASShortcut * _Nullable shortcut) {
        [[MASShortcutMonitor sharedMonitor] unregisterAllShortcuts];
        BOOL success =[[MASShortcutMonitor sharedMonitor] registerShortcut:shortcut withAction:^{
            [YLHud showText:@"成功" toWindow:self.view.window];
        }];
        if(success == NO) {
            sender.shortcut = nil;
        }
    };
    [self.view addSubview:shortcutView];
}

- (void)mouseDown:(NSEvent *)event {
    [super mouseDown:event];

}

@end
