//
//  YLPermissionItem.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import "YLPermissionItem.h"
#import "YLPermissionManager.h"

@interface YLPermissionItem ()

@property (nonatomic, strong) NSImageView *iconView;
@property (nonatomic, strong) NSButton *checkBtn;
@property (nonatomic, strong) NSTextField *infoLabel;
@property (nonatomic, strong) NSButton *authBtn;

@property (nonatomic, strong) YLPermissionModel *model;

@end

@implementation YLPermissionItem

+ (instancetype)itemWithModel:(YLPermissionModel *)model {
    YLPermissionItem *item = [[YLPermissionItem alloc] init];
    item.model = model;
    return item;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.iconView];
        [self addSubview:self.checkBtn];
        [self addSubview:self.infoLabel];
        [self addSubview:self.authBtn];
    }
    return self;
}

- (BOOL)isFlipped {
    return YES;
}

- (void)layout {
    [super layout];
    
    NSRect iconFrame = NSMakeRect(0, 0, 20, 20);
    iconFrame.origin.y = self.frame.size.height / 2 - 25;
    self.iconView.frame = iconFrame;
    
    [self.checkBtn sizeToFit];
    NSPoint checkOrigin = NSMakePoint(CGRectGetMaxX(iconFrame) + 10, CGRectGetMidY(iconFrame) - self.checkBtn.frame.size.height / 2);
    self.checkBtn.frame = (NSRect){checkOrigin, self.checkBtn.frame.size};
    
    [self.infoLabel sizeToFit];
    NSPoint infoOrigin = NSMakePoint(checkOrigin.x, self.frame.size.height / 2 + 5);
    self.infoLabel.frame = (NSRect){infoOrigin, self.infoLabel.frame.size};
    
    [self.authBtn sizeToFit];
    NSPoint authOrigin = NSMakePoint(self.frame.size.width - self.authBtn.frame.size.width, self.frame.size.height / 2 - self.authBtn.frame.size.height / 2);
    self.authBtn.frame = (NSRect){authOrigin, self.authBtn.frame.size};
}

- (void)setModel:(YLPermissionModel *)model {
    _model = model;
    switch (model.authType) {
        case YLPermissionAuthTypeAccessibility: {
            // 辅助功能
            self.iconView.image = [self bundleImage:@"Accessbility@2x.png"];
            self.checkBtn.title = YLPermissionManagerLocalizeString(@"Accessibility permission authorization");
        }
            break;
        case YLPermissionAuthTypeScreenCapture: {
            // 录屏
            self.iconView.image = [self bundleImage:@"ScreenRecording@2x.png"];
            self.checkBtn.title = YLPermissionManagerLocalizeString(@"Screen recording permission authorization");
        }
            break;
        case YLPermissionAuthTypeFullDisk: {
            // 完全磁盘
            self.iconView.image = [self bundleImage:@"Folder@2x.png"];
            self.checkBtn.title = YLPermissionManagerLocalizeString(@"Full disk access authorization");
        }
            break;
        default:
            break;
    }
    self.infoLabel.stringValue = [NSString stringWithFormat:@"*%@", model.desc];
    [self refreshStatus];
}

- (void)authBtnClick {
    // 打开授权
    switch (self.model.authType) {
        case YLPermissionAuthTypeAccessibility: {
            // 辅助功能
            [[YLPermissionManager share] openPrivacyAccessibilitySetting];
        }
            break;
        case YLPermissionAuthTypeScreenCapture: {
            // 录屏
            [[YLPermissionManager share] openScreenCaptureSetting];
        }
            break;
        case YLPermissionAuthTypeFullDisk: {
            // 完全磁盘
            [[YLPermissionManager share] openFullDiskAccessSetting];
        }
            break;
        default:
            break;
    }
}

#pragma mark check box 点击
- (void)checkBtnClick {
    self.checkBtn.state = !self.checkBtn.state;
    [self authBtnClick];
}

#pragma mark 授权按钮点击
- (BOOL)refreshStatus {
    BOOL flag = NO;
    switch (self.model.authType) {
        case YLPermissionAuthTypeAccessibility: {
            // 辅助功能
            flag = [[YLPermissionManager share] getPrivacyAccessibilityIsEnabled];
        }
            break;
        case YLPermissionAuthTypeScreenCapture: {
            // 录屏
            flag = [[YLPermissionManager share] getScreenCaptureIsEnabled];
        }
            break;
        case YLPermissionAuthTypeFullDisk: {
            // 完全磁盘
            flag = [[YLPermissionManager share] getFullDiskAccessIsEnabled];
        }
            break;
        default:
            break;
    }
    if(flag) {
        self.checkBtn.state = NSControlStateValueOn;
        self.authBtn.hidden = YES;
    } else {
        self.checkBtn.state = NSControlStateValueOff;
        self.authBtn.hidden = NO;
    }
    return flag;
}

#pragma mark - 获取bundle里的图片
- (NSImage *)bundleImage:(NSString *)icon {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"YLPermissionManager" withExtension:@"bundle"];
    if(url == nil) {
        url = [[[[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil] URLByAppendingPathComponent:@"YLCategory"] URLByAppendingPathExtension:@"framework"];
        NSBundle *bundle = [NSBundle bundleWithURL:url];
        url = [bundle URLForResource:@"YLPermissionManager" withExtension:@"bundle"];
    }
    NSString *path = [[NSBundle bundleWithURL:url].bundlePath stringByAppendingPathComponent:icon];
    return [[NSImage alloc] initWithContentsOfFile:path];
}

#pragma mark - lazy load

- (NSImageView *)iconView {
    if(_iconView == nil) {
        _iconView = [[NSImageView alloc] init];
        _iconView.imageScaling = NSImageScaleProportionallyUpOrDown;
    }
    return _iconView;
}

- (NSButton *)checkBtn {
    if(_checkBtn == nil) {
        _checkBtn = [NSButton checkboxWithTitle:@"" target:self action:@selector(checkBtnClick)];
    }
    return _checkBtn;
}

- (NSTextField *)infoLabel {
    if(_infoLabel == nil) {
        _infoLabel = [NSTextField labelWithString:@""];
        _infoLabel.font = [NSFont systemFontOfSize:10];
        _infoLabel.textColor = [NSColor lightGrayColor];
    }
    return _infoLabel;
}

- (NSButton *)authBtn {
    if(_authBtn == nil) {
        _authBtn = [NSButton buttonWithTitle:YLPermissionManagerLocalizeString(@"Authorize") target:self action:@selector(authBtnClick)];
        _authBtn.bezelColor = [NSColor controlAccentColor];
    }
    return _authBtn;
}

@end
