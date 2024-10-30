//
//  YLPermissionViewController.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import "YLPermissionViewController.h"
#import "YLPermissionManager.h"
#import "YLPermissionItem.h"

#define kPermissionItemHeight        50
#define kPermissionItemGap           25

#pragma mark - flip view

@interface YLPermissionView : NSView

@end

@implementation YLPermissionView

- (BOOL)isFlipped {
    return YES;
}

@end

#pragma mark - 自定义box

@interface YLPermissionBoxView : NSBox

@end

@implementation YLPermissionBoxView

- (instancetype)initWithFrame:(NSRect)frameRect {
    if(self = [super initWithFrame:frameRect]) {
        self.boxType = NSBoxCustom;
        self.titlePosition = NSNoTitle;
        self.cornerRadius = 15;
        self.borderWidth = 0;
        self.contentViewMargins = NSZeroSize;
        [self setBgColor];
        [NSApp addObserver:self forKeyPath:@"effectiveAppearance" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc {
    [NSApp removeObserver:self forKeyPath:@"effectiveAppearance" context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if([keyPath isEqualToString:@"effectiveAppearance"]) {
        [self setBgColor];
    }
}

- (void)setBgColor {
    if([NSApp.effectiveAppearance bestMatchFromAppearancesWithNames:@[NSAppearanceNameDarkAqua, NSAppearanceNameAqua]] == NSAppearanceNameDarkAqua) {
        // 暗黑模式
        self.fillColor = [NSColor colorWithWhite:0 alpha:0.15];
    } else {
        self.fillColor = [NSColor colorWithWhite:1 alpha:0.4];
    }
}

@end

#pragma mark - 权限设置控制器

@interface YLPermissionViewController ()

@property (nonatomic, strong) NSVisualEffectView *effectView;
@property (nonatomic, strong) NSTextField *titleLabel;
@property (nonatomic, strong) YLPermissionBoxView *box;
@property (nonatomic, strong) NSButton *lookBtn;
@property (nonatomic, strong) NSButton *quitBtn;
@property (nonatomic, strong) NSButton *skipBtn;

@end

@implementation YLPermissionViewController

- (void)loadView {
    self.view = [[YLPermissionView alloc] initWithFrame:NSMakeRect(0, 0, 600, 300)];
    [self.view addSubview:self.effectView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.box];
    [self.view addSubview:self.lookBtn];
    [self.view addSubview:self.quitBtn];
    [self.view addSubview:self.skipBtn];
}

- (void)viewDidLayout {
    [super viewDidLayout];
    self.effectView.frame = self.view.bounds;
    
    [self.titleLabel sizeToFit];
    NSPoint titleOrigin = NSMakePoint(self.view.frame.size.width / 2 - self.titleLabel.frame.size.width / 2, 60);
    self.titleLabel.frame = (NSRect){titleOrigin, self.titleLabel.frame.size};
    
    self.box.frame = NSMakeRect(40, CGRectGetMaxY(self.titleLabel.frame) + 20, self.view.frame.size.width - 80, self.authTypes.count * kPermissionItemHeight + (self.authTypes.count + 1) * kPermissionItemGap);

    CGFloat top = kPermissionItemGap;
    for (YLPermissionItem *item in [self.box.contentView.subviews reverseObjectEnumerator].allObjects) {
        if([item isKindOfClass:[YLPermissionItem class]]) {
            item.frame = NSMakeRect(30, top, self.box.contentView.frame.size.width - 60, kPermissionItemHeight);
            top = CGRectGetMaxY(item.frame) + kPermissionItemGap;
        }
    }
    
    [self.lookBtn sizeToFit];
    [self.quitBtn sizeToFit];
    [self.skipBtn sizeToFit];
    
    NSPoint lookOrigin = NSMakePoint(self.box.frame.origin.x, CGRectGetMaxY(self.box.frame) + 10);
    self.lookBtn.frame = (NSRect){lookOrigin, self.lookBtn.frame.size};
    
    NSPoint skipOrigin = NSMakePoint(CGRectGetMaxX(self.box.frame) - self.skipBtn.frame.size.width, lookOrigin.y);
    self.skipBtn.frame = (NSRect){skipOrigin, self.skipBtn.frame.size};
    
    NSPoint quitOrigin = NSMakePoint(skipOrigin.x - self.quitBtn.frame.size.width - 10, lookOrigin.y);
    self.quitBtn.frame = (NSRect){quitOrigin, self.quitBtn.frame.size};
}

#pragma mark - 设置授权类型
- (void)setAuthTypes:(NSArray<YLPermissionModel *> *)authTypes {
    _authTypes = authTypes;
    for (NSView *sub in self.box.contentView.subviews) {
        if([sub isKindOfClass:[YLPermissionItem class]]) {
            [sub removeFromSuperview];
        }
    }
    for (YLPermissionModel *model in authTypes) {
        YLPermissionItem *item = [YLPermissionItem itemWithModel:model];
        [self.box.contentView addSubview:item];
    }
    
    NSRect frame = self.view.window.frame;
    frame.size.height = authTypes.count * kPermissionItemHeight + (authTypes.count + 1) * kPermissionItemGap + 180;
    [self.view.window setFrame:frame display:YES];
    [self.view setNeedsLayout:YES];
}

#pragma mark 刷新所有的授权状态
- (void)refreshAllAuthState {
    BOOL all = YES;
    for (YLPermissionItem *item in self.box.contentView.subviews) {
        if([item isKindOfClass:[YLPermissionItem class]]) {
            all = [item refreshStatus] && all;
        }
    }
    if(all) {
        // 所有权限已开启
        if(self.allAuthPassedHandler) {
            self.allAuthPassedHandler();
        }
    }
}

#pragma mark - 退出app
- (void)quitApp {
    [NSApp terminate:nil];
}

#pragma mark 忽略
- (void)skip {
    if(self.skipHandler) {
        self.skipHandler();
    }
}

#pragma mark 观看权限设置教学
- (void)lookTutorailVideo {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[YLPermissionManager share].tutorialLink]];
}

#pragma mark - lazy load

- (NSVisualEffectView *)effectView {
    if(_effectView == nil) {
        _effectView = [[NSVisualEffectView alloc] init];
        _effectView.blendingMode = NSVisualEffectBlendingModeBehindWindow;
    }
    return _effectView;
}

- (NSTextField *)titleLabel {
    if(_titleLabel == nil) {
        _titleLabel = [NSTextField labelWithString:[NSString stringWithFormat:YLPermissionManagerLocalizeString(@"Permission sub Title"), kAppName]];
        _titleLabel.font = [NSFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (YLPermissionBoxView *)box {
    if(_box == nil) {
        _box = [[YLPermissionBoxView alloc] init];
    }
    return _box;
}

- (NSButton *)lookBtn {
    if(_lookBtn == nil) {
        _lookBtn = [NSButton buttonWithTitle:YLPermissionManagerLocalizeString(@"View permission setting tutorail") target:self action:@selector(lookTutorailVideo)];
        _lookBtn.bezelColor = [NSColor controlAccentColor];
        _lookBtn.hidden = [YLPermissionManager share].tutorialLink.length == 0;
    }
    return _lookBtn;
}

- (NSButton *)quitBtn {
    if(_quitBtn == nil) {
        _quitBtn = [NSButton buttonWithTitle:YLPermissionManagerLocalizeString(@"Quit App") target:self action:@selector(quitApp)];
    }
    return _quitBtn;
}

- (NSButton *)skipBtn {
    if(_skipBtn == nil) {
        _skipBtn = [NSButton buttonWithTitle:YLPermissionManagerLocalizeString(@"Skip") target:self action:@selector(skip)];
    }
    return _skipBtn;
}

@end

