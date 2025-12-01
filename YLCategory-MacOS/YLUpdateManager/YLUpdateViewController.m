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
@property (nonatomic, strong) NSScrollView *scrollView;
@property (nonatomic, strong) NSTextView *infoView;
@property (nonatomic, strong) NSButton *cancelBtn;
@property (nonatomic, strong) NSButton *updateBtn;
@property (nonatomic, strong) NSButton *skipBtn;

@end

@implementation YLUpdateViewController

- (void)loadView {
    self.view = [[NSView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.effectView];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.skipBtn];
    [self.view addSubview:self.updateBtn];
    [self.view addSubview:self.cancelBtn];
}

- (void)viewDidLayout {
    [super viewDidLayout];
    self.effectView.frame = self.view.bounds;
    [self.updateBtn sizeToFit];
    [self.skipBtn sizeToFit];
    [self.cancelBtn sizeToFit];
    
    NSRect updateFrame = self.updateBtn.frame;
    updateFrame.origin = NSMakePoint(self.view.frame.size.width - 20 - updateFrame.size.width, 10);
    self.updateBtn.frame = updateFrame;
    
    NSRect cancelFrame = self.cancelBtn.frame;
    cancelFrame.origin = NSMakePoint(CGRectGetMinX(updateFrame) - cancelFrame.size.width - 5, 10);
    self.cancelBtn.frame = cancelFrame;
    
    NSRect skipFrame = self.skipBtn.frame;
    skipFrame.origin = NSMakePoint(20, 10);
    self.skipBtn.frame = skipFrame;
    
    CGFloat scrollY = CGRectGetMaxY(updateFrame) + 10;
    self.scrollView.frame = NSMakeRect(20, scrollY, self.view.frame.size.width - 40, self.view.frame.size.height - scrollY - 40);
}

- (void)setInfo:(NSString *)info {
    _info = [info copy] ?: @"";
    self.infoView.string = _info;
    CGFloat height = [_info boundingRectWithSize:NSMakeSize(460, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.infoView.font}].size.height;
    if (@available(macOS 26.0, *)) {
        height += 85;
    } else {
        height += 100;
    }
    [self.view.window setFrame:NSMakeRect(0, 0, 500, height) display:YES];
    [self.view setNeedsLayout:YES];
    [self.view.window center];
}

- (void)setShowSkipButton:(BOOL)showSkipButton {
    self.skipBtn.hidden = !showSkipButton;
}

#pragma mark 跳过该版本
- (void)skip:(NSButton *)btn {
    [self.view.window close];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:self.lastVersion forKey:@"YLUpdateSkipVersion"];
    [userDefaults synchronize];
}

#pragma mark 升级
- (void)update:(NSButton *)btn {
    if([YLUpdateManager share].appStoreUrl) {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[YLUpdateManager share].appStoreUrl]];
    }
    [self.view.window close];
}

#pragma mark 取消更新
- (void)cancel:(NSButton *)btn {
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

- (NSScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[NSScrollView alloc] init];
        _scrollView.hasHorizontalScroller = NO;
        _scrollView.hasVerticalScroller = NO;
        _scrollView.drawsBackground = NO;
        _scrollView.contentInsets = NSEdgeInsetsZero;
        _scrollView.documentView = self.infoView;
    }
    return _scrollView;
}

- (NSTextView *)infoView {
    if (_infoView == nil) {
        _infoView = [[NSTextView alloc] init];
        _infoView.font = [NSFont systemFontOfSize:13];
        _infoView.editable = NO;
        _infoView.drawsBackground = NO;
    }
    return _infoView;
}

- (NSButton *)skipBtn {
    if(_skipBtn == nil) {
        _skipBtn = [NSButton buttonWithTitle:YLUpdateManagerLocalizeString(@"Skip This Version") target:self action:@selector(skip:)];
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

- (NSButton *)cancelBtn {
    if(_cancelBtn == nil) {
        _cancelBtn = [NSButton buttonWithTitle:YLUpdateManagerLocalizeString(@"Cancel") target:self action:@selector(cancel:)];
    }
    return _cancelBtn;
}

@end
