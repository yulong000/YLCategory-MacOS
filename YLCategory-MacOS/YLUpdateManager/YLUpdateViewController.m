//
//  YLUpdateViewController.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import "YLUpdateViewController.h"
#import "YLUpdateManager.h"

@interface YLUpdateViewController ()

@property (nonatomic, strong) NSVisualEffectView *effectView;
@property (nonatomic, strong) NSTextField *infoLabel;
@property (nonatomic, strong) NSButton *skipBtn;
@property (nonatomic, strong) NSButton *updateBtn;

@end

@implementation YLUpdateViewController

- (void)loadView {
    self.view = [[NSView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.effectView];
    [self.view addSubview:self.infoLabel];
    [self.view addSubview:self.skipBtn];
    [self.view addSubview:self.updateBtn];
}

- (void)viewDidLayout {
    [super viewDidLayout];
    self.effectView.frame = self.view.bounds;
    [self.updateBtn sizeToFit];
    [self.skipBtn sizeToFit];
    
    NSRect updateFrame = self.updateBtn.frame;
    updateFrame.origin = NSMakePoint(self.view.frame.size.width - 20 - updateFrame.size.width, 10);
    self.updateBtn.frame = updateFrame;
    
    NSRect skipFrame = self.skipBtn.frame;
    skipFrame.origin = NSMakePoint(CGRectGetMinX(updateFrame) - skipFrame.size.width, 10);
    self.skipBtn.frame = skipFrame;
    
    CGFloat infoY = CGRectGetMaxY(updateFrame) + 10;
    self.infoLabel.frame = NSMakeRect(20, infoY, self.view.frame.size.width - 40, self.view.frame.size.height - infoY - 40);
}

- (void)setInfo:(NSString *)info {
    _info = [info copy] ?: @"";
    self.infoLabel.stringValue = _info;
    CGFloat height = [_info boundingRectWithSize:NSMakeSize(460, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.infoLabel.font}].size.height + 100;
    [self.view.window setFrame:NSMakeRect(0, 0, 500, height) display:YES];
    [self.view.window center];
}

- (void)skip:(NSButton *)btn {
    [self.view.window close];
}

- (void)update:(NSButton *)btn {
    if([YLUpdateManager share].appStoreUrl) {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[YLUpdateManager share].appStoreUrl]];
    }
    [self.view.window close];
}

#pragma mark - lazy load

- (NSVisualEffectView *)effectView {
    if(_effectView == nil) {
        _effectView = [[NSVisualEffectView alloc] init];
        _effectView.blendingMode = NSVisualEffectBlendingModeBehindWindow;
    }
    return _effectView;
}

- (NSTextField *)infoLabel {
    if(_infoLabel == nil) {
        _infoLabel = [NSTextField wrappingLabelWithString:@""];
        _infoLabel.editable = NO;
        _infoLabel.bordered = NO;
        _infoLabel.controlSize = NSControlSizeRegular;
    }
    return _infoLabel;
}

- (NSButton *)skipBtn {
    if(_skipBtn == nil) {
        _skipBtn = [NSButton buttonWithTitle:YLUpdateManagerLocalizeString(@"Skip") target:self action:@selector(skip:)];
    }
    return _skipBtn;
}

- (NSButton *)updateBtn {
    if(_updateBtn == nil) {
        _updateBtn = [NSButton buttonWithTitle:YLUpdateManagerLocalizeString(@"Update") target:self action:@selector(update:)];
        _updateBtn.bezelColor = NSColor.controlAccentColor;
    }
    return _updateBtn;
}

@end
