//
//  ViewController.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2022/9/7.
//

#import "ViewController.h"
#import "YLCategory.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}


- (void)mouseDown:(NSEvent *)event {
    [super mouseDown:event];
    [NSAlert showWithTitle:@"弹窗" buttons:@[@"确定", @"取消"] completionHandler:^(NSInteger index) {
        YLLog(@"index : %d", index);
    }];
}

@end
