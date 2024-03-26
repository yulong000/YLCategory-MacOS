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
    
    YLShortcutView *shortcutView = [[YLShortcutView alloc] initWithFrame:NSMakeRect(20, 50, 120, 22)];
    [self.view addSubview:shortcutView];

}

- (void)mouseDown:(NSEvent *)event {
    [super mouseDown:event];

//    [YLProgressHUD showLoading:@"加载中..." toWindow:self.view.window];
//    [YLProgressHUD showSuccess:@"加载成功" toWindow:self.view.window];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [YLProgressHUD hideHUDForWindow:self.view.window];
//    });
}

@end
