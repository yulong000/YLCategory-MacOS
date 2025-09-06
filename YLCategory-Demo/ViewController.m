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

@property (nonatomic, strong) NSView *sub;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    YLShortcutView *shortcutView = [[YLShortcutView alloc] initWithFrame:NSMakeRect(20, 50, 150, 30)];
    shortcutView.changedHandler = ^(YLShortcutView * _Nonnull sender, MASShortcut * _Nullable shortcut) {
        [[YLShortcutManager share] unregisterAllShortcuts];
        BOOL success = [[YLShortcutManager share] registerShortcut:shortcut withAction:^{
            [YLHud showText:@"成功" toWindow:self.view.window];
        }];
        if(success == NO) {
            sender.shortcut = nil;
        }
    };
    [self.view addSubview:shortcutView];
    
    NSView *sub = [[NSView alloc] initWithFrame:NSMakeRect(20, 200, 100, 100)];
    [sub setSmoothCornerWithTopLeft:20 topRight:30 bottomRight:40 bottomLeft:10];
    sub.backgroundColor = GreenColor;
    [self.view addSubview:sub];
    self.sub = sub;
}

- (void)mouseDown:(NSEvent *)event {
    [super mouseDown:event];
    [self.sub setSmoothCorner:20];
    [self.sub setSmoothCornerBorderColor:RedColor borderWidth:2];
    self.sub.backgroundColor = BlueColor;
}

@end
