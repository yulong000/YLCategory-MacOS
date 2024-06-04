//
//  YLProgressHUD.m
//  iCopy
//
//  Created by 魏宇龙 on 2022/11/29.
//

#import "YLProgressHUD.h"
#import <QuartzCore/CAMediaTimingFunction.h>
#import <CoreImage/CIFilter.h>
#import "Macro.h"

#define kHUDHideDefaultSecond   1.0         // 默认延迟隐藏的秒数
#define kHUDMaxWidth            300         // 最大的宽度，超过宽度换行

#pragma mark - 显示进度

@interface YLProgressDisplayView : NSView

@property (nonatomic, assign) YLProgressHUDStyle style;
@property (nonatomic, assign) CGFloat progress;
/// 将progress转换成百分比字符串
@property (nonatomic, copy)   NSString *progressText;

@end

@implementation YLProgressDisplayView

- (void)setProgress:(CGFloat)progress {
    _progress = MIN(1, MAX(0, progress));;
    self.progressText = [NSString stringWithFormat:@"%d%%", (int)(_progress * 100)];
    [self setNeedsDisplay:YES];
}

- (BOOL)isFlipped {
    return YES;
}

- (void)setStyle:(YLProgressHUDStyle)style {
    _style = style;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    CGContextRef ctx = [NSGraphicsContext currentContext].CGContext;
    CGContextSetLineWidth(ctx, 2);
    if(self.style == YLProgressHUDStyleBlack) {
        [[NSColor whiteColor] set];
    } else {
        [[NSColor blackColor] set];
    }
    
    CGFloat centerX = NSMidX(self.bounds);
    CGFloat centerY = NSMidY(self.bounds);
    CGFloat radius1 = self.bounds.size.height / 2 - 2;
    CGFloat radius2 = radius1 - 3;
    
    // 外层的圆
    CGContextAddArc(ctx, centerX, centerY, radius1, 0, M_PI * 2, 0);
    CGContextStrokePath(ctx);
    
    // 内部的进度
    CGFloat end = M_PI * 2 * self.progress - M_PI_2;
    CGContextAddArc(ctx, centerX, centerY, radius2, - M_PI_2, end, 0);
    CGContextAddLineToPoint(ctx, centerX, centerY);
    CGContextAddLineToPoint(ctx, centerX, centerY - radius2);
    CGContextFillPath(ctx);
}

@end

#pragma mark - hud显示区域

@interface YLProgressHUDView : NSView

@property (nonatomic, assign) YLProgressHUDStyle style;

@end

@implementation YLProgressHUDView

- (instancetype)initWithFrame:(NSRect)frameRect {
    if(self = [super initWithFrame:frameRect]) {
        self.wantsLayer = YES;
        self.layer.cornerRadius = 10;
        self.style = YLProgressHUDStyleBlack;
    }
    return self;
}

- (void)resetShadow {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 3;
    if(self.style == YLProgressHUDStyleBlack) {
        self.layer.backgroundColor = [NSColor colorWithRed:0 green:0 blue:0 alpha:0.9].CGColor;
        shadow.shadowColor = [NSColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    } else {
        self.layer.backgroundColor = [NSColor colorWithRed:1 green:1 blue:1 alpha:0.9].CGColor;
        shadow.shadowColor = [NSColor colorWithRed:1 green:1 blue:1 alpha:0.4];
    }
    self.shadow = shadow;
}

- (BOOL)isFlipped {
    return YES;
}

- (void)setStyle:(YLProgressHUDStyle)style {
    _style = style;
    [self resetShadow];
}

@end

#pragma mark - hud窗口

@interface YLProgressHUD ()

@property (nonatomic, strong) YLProgressHUDView *hudView;
@property (nonatomic, strong, nullable) NSView *customView;
@property (nonatomic, strong) NSTextField *textLabel;
/// 隐藏后的回调
@property (nonatomic, copy)   YLProgressHUDCompletionHandler completionHandler;

@property (nonatomic, strong) id monitor;

@end

@implementation YLProgressHUD

- (instancetype)init {
    if (self = [super init]) {
        
        self.backgroundColor = [NSColor clearColor];
        self.level = NSPopUpMenuWindowLevel;
        self.styleMask = NSWindowStyleMaskBorderless;
        self.releasedWhenClosed = NO;

        self.hudView = [[YLProgressHUDView alloc] init];
        [self.contentView addSubview:self.hudView];
        
        self.textLabel = [NSTextField labelWithString:@""];
        self.textLabel.font = YLProgressHUDConfig.share.textFont ?: [NSFont systemFontOfSize:16];
        self.textLabel.maximumNumberOfLines = 10;
        self.textLabel.preferredMaxLayoutWidth = kHUDMaxWidth - 40;
        self.textLabel.cell.wraps = YES;
        self.textLabel.textColor = [NSColor whiteColor];
        [self.hudView addSubview:self.textLabel];
        
        self.style = [YLProgressHUDConfig share].style;
        
        if([YLProgressHUDConfig share].movable) {
            __weak typeof(self) weakSelf = self;
            self.monitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskLeftMouseDragged handler:^NSEvent * _Nullable(NSEvent * _Nonnull event) {
                if(event.window == weakSelf.parentWindow || event.window == weakSelf) {
                    // 让窗口响应鼠标的拖动
                    NSPoint parentWindowOrigin = weakSelf.parentWindow.parentWindow.frame.origin;
                    [weakSelf.parentWindow.parentWindow setFrameOrigin:NSMakePoint(parentWindowOrigin.x + event.deltaX, parentWindowOrigin.y - event.deltaY)];
                }
                return event;
            }];
        }
    }
    return self;
}

- (void)setStyle:(YLProgressHUDStyle)style {
    if(style == YLProgressHUDStyleAuto) {
        _style = kAppIsDarkTheme ? YLProgressHUDStyleWhite : YLProgressHUDStyleBlack;
    } else {
        _style = style;
    }
    self.hudView.style = _style;
    self.textLabel.textColor = _style == YLProgressHUDStyleBlack ? [NSColor whiteColor] : [NSColor blackColor];
}

- (void)dealloc {
    if(self.monitor) {
        [NSEvent removeMonitor:self.monitor];
    }
}

- (void)layoutUI {
    // 上下左右留白 20， text customView 间距 20
    if(self.textLabel.stringValue.length > 0) {
        [self.textLabel setFrameSize:[self.textLabel sizeThatFits:NSMakeSize(kHUDMaxWidth - 40, MAXFLOAT)]];
    } else {
        [self.textLabel setFrameSize:NSZeroSize];
    }
    CGFloat windowWidth = self.parentWindow.frame.size.width;
    CGFloat windowHeight = self.parentWindow.frame.size.height;
    CGFloat windowX = self.parentWindow.frame.origin.x;
    CGFloat windowY = self.parentWindow.frame.origin.y;
    CGFloat textLabelWidth = self.textLabel.frame.size.width;
    CGFloat textLabelHeight = self.textLabel.frame.size.height;
    CGFloat customViewWidth = self.customView.frame.size.width;
    CGFloat customViewHeight = self.customView.frame.size.height;
    CGFloat hudWidth = 0;
    CGFloat hudHeight = 0;
    if(self.customView) {
        hudWidth = MAX(textLabelWidth, customViewWidth) + 40;
        hudHeight = (textLabelHeight > 0 ? (textLabelHeight + 20) : 0) + customViewHeight + 40;
        hudWidth = MAX(hudWidth, hudHeight);
        [self.hudView setFrameSize:NSMakeSize(hudWidth, hudHeight)];
        [self.customView setFrameOrigin:NSMakePoint((hudWidth - customViewWidth) / 2, 20)];
        [self.textLabel setFrameOrigin:NSMakePoint((hudWidth - textLabelWidth) / 2, 20 + customViewHeight + 20)];
    } else {
        hudWidth = textLabelWidth + 40;
        hudHeight = textLabelHeight + 40;
        hudWidth = MAX(hudWidth, hudHeight);
        [self.hudView setFrameSize:NSMakeSize(hudWidth, hudHeight)];
        [self.textLabel setFrameOrigin:NSMakePoint(20, 20)];
    }
    // 扩大window的size，给阴影留些显示的空间
    hudWidth += 10;
    hudHeight += 10;
    NSRect frame = NSMakeRect((windowWidth - hudWidth) / 2 + windowX, (windowHeight - hudHeight) / 2 + windowY, hudWidth, hudHeight);
    [self setFrame:frame display:YES];
    // hud居中
    [self.hudView setFrameOrigin:NSMakePoint(5, 5)];
}

#pragma mark - 显示成功

+ (instancetype)showSuccess:(NSString *)success toWindow:(NSWindow *)window {
    return [YLProgressHUD showSuccess:success toWindow:window completionHandler:nil];
}

+ (instancetype)showSuccess:(NSString *)success toWindow:(NSWindow *)window hideAfterDelay:(CGFloat)second {
    return [YLProgressHUD showSuccess:success toWindow:window hideAfterDelay:second completionHandler:nil];
}

+ (instancetype)showSuccess:(NSString *)success toWindow:(NSWindow *)window completionHandler:(YLProgressHUDCompletionHandler _Nullable)completionHandler {
    return [YLProgressHUD showSuccess:success toWindow:window hideAfterDelay:kHUDHideDefaultSecond completionHandler:completionHandler];
}

+ (instancetype)showSuccess:(NSString *)success toWindow:(NSWindow *)window hideAfterDelay:(CGFloat)second completionHandler:(YLProgressHUDCompletionHandler)completionHandler {
    NSImageView *successView = [YLProgressHUD createSuccessViewWithStyle:YLProgressHUDConfig.share.style];
    return [YLProgressHUD showCustomView:successView text:success toWindow:window hideAfterDelay:second completionHandler:completionHandler];
}

#pragma mark - 显示错误

+ (instancetype)showError:(NSString *)error toWindow:(NSWindow *)window {
    return [YLProgressHUD showError:error toWindow:window completionHandler:nil];
}

+ (instancetype)showError:(NSString *)error toWindow:(NSWindow *)window hideAfterDelay:(CGFloat)second {
    return [YLProgressHUD showError:error toWindow:window hideAfterDelay:second completionHandler:nil];
}

+ (instancetype)showError:(NSString *)error toWindow:(NSWindow *)window completionHandler:(YLProgressHUDCompletionHandler _Nullable)completionHandler {
    return [YLProgressHUD showError:error toWindow:window hideAfterDelay:kHUDHideDefaultSecond completionHandler:completionHandler];
}

+ (instancetype)showError:(NSString *)error toWindow:(NSWindow *)window hideAfterDelay:(CGFloat)second completionHandler:(YLProgressHUDCompletionHandler)completionHandler {
    NSImageView *errorView = [YLProgressHUD createErrorViewWithStyle:YLProgressHUDConfig.share.style];
    return [YLProgressHUD showCustomView:errorView text:error toWindow:window hideAfterDelay:second completionHandler:completionHandler];
}

#pragma mark - 显示文字

+ (instancetype)showText:(NSString *)text toWindow:(NSWindow *)window {
    return [YLProgressHUD showText:text toWindow:window completionHandler:nil];
}

+ (instancetype)showText:(NSString *)text toWindow:(NSWindow *)window hideAfterDelay:(CGFloat)second {
    return [YLProgressHUD showText:text toWindow:window hideAfterDelay:second completionHandler:nil];
}

+ (instancetype)showText:(NSString *)text toWindow:(NSWindow *)window completionHandler:(YLProgressHUDCompletionHandler _Nullable)completionHandler {
    return [YLProgressHUD showText:text toWindow:window hideAfterDelay:kHUDHideDefaultSecond completionHandler:completionHandler];
}

+ (instancetype)showText:(NSString *)text toWindow:(NSWindow *)window hideAfterDelay:(CGFloat)second completionHandler:(YLProgressHUDCompletionHandler)completionHandler {
    return [YLProgressHUD showCustomView:nil text:text toWindow:window hideAfterDelay:second completionHandler:completionHandler];
}

#pragma mark - 显示加载中

+ (instancetype)showLoading:(NSString *)loadingText toWindow:(NSWindow *)window {
    NSProgressIndicator *indicator = [YLProgressHUD createLoadingIndicator];
    return [YLProgressHUD showCustomView:indicator text:loadingText toWindow:window hideAfterDelay:-1 completionHandler:nil];
}

#pragma mark - 显示进度

+ (instancetype)showProgress:(CGFloat)progress toWindow:(NSWindow *)window {
    return [YLProgressHUD showProgress:progress text:nil toWindow:window];
}

+ (instancetype)showProgress:(CGFloat)progress text:(NSString * _Nullable)text toWindow:(nonnull NSWindow *)window {
    YLProgressDisplayView *progressView = [YLProgressHUD createProgressViewWithStyle:YLProgressHUDConfig.share.style];
    progressView.progress = progress;
    return [YLProgressHUD showCustomView:progressView text:text ?: progressView.progressText toWindow:window hideAfterDelay:-1 completionHandler:nil];
}

#pragma mark - 显示自定义view和文字
+ (instancetype)showCustomView:(NSView * _Nullable)customView text:(NSString *)text toWindow:(NSWindow *)window hideAfterDelay:(CGFloat)second completionHandler:(YLProgressHUDCompletionHandler _Nullable)completionHandler {
    if(window == nil) {
        window = NSApp.windows.lastObject;
    }
    // 增加一个全覆盖的window，禁用点击其他地方，如果设置为[NSColor clearColor]，鼠标是可以穿透的，所以必须得有个色值
    // Q：为啥不直接设置hud为全覆盖呢？
    // A：因为半透明的window，对其上面的view做动画或者frame更改的时候，会有残影，应该是系统bug，所以简单粗暴，直接再套一层
    NSWindow *parentWindow = [[NSWindow alloc] init];
    parentWindow.backgroundColor = [NSColor colorWithWhite:0 alpha:0.001];
    parentWindow.level = NSPopUpMenuWindowLevel;
    parentWindow.styleMask = NSWindowStyleMaskBorderless;
    [parentWindow setFrame:window.frame display:YES];
    parentWindow.movable = NO;
    parentWindow.releasedWhenClosed = NO;
    [window addChildWindow:parentWindow ordered:NSWindowAbove];
    
    // 这个是要显示的小窗口
    YLProgressHUD *hud = [[YLProgressHUD alloc] init];
    [parentWindow addChildWindow:hud ordered:NSWindowAbove];
    hud.textLabel.stringValue = text ?: @"";
    hud.completionHandler = completionHandler;
    if(customView) {
        hud.customView = customView;
        [hud.hudView addSubview:customView];
    }
    [hud layoutUI];
    if(second >= 0) {
        // 自动隐藏
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [YLProgressHUD hideHUD:hud];
        });
    }
    return hud;
}

#pragma mark - 隐藏

+ (void)hideHUD:(YLProgressHUD *)hud {
    if(hud.completionHandler) {
        hud.completionHandler();
    }
    [hud.parentWindow.parentWindow removeChildWindow:hud.parentWindow];
    [hud.parentWindow close];
    [hud.parentWindow removeChildWindow:hud];
    [hud close];
}

+ (void)hideHUDForWindow:(NSWindow *)window {
    for (NSWindow *child in window.childWindows) {
        if([child isKindOfClass:[YLProgressHUD class]]) {
            [YLProgressHUD hideHUD:(YLProgressHUD *)child];
        } else {
            [YLProgressHUD hideHUDForWindow:child];
        }
    }
}

#pragma mark - 切换显示

- (void)hide {
    [self hideWithCompletionHandler:nil];
}

- (void)hideWithCompletionHandler:(YLProgressHUDCompletionHandler)completionHandler {
    [self hideAfterDelay:kHUDHideDefaultSecond completionHandler:completionHandler];
}

- (void)hideAfterDelay:(CGFloat)second completionHandler:(YLProgressHUDCompletionHandler)completionHandler {
    self.completionHandler = completionHandler;
    if(second > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [YLProgressHUD hideHUD:self];
        });
    }
}

- (void)showLoading:(NSString *)loading {
    self.textLabel.stringValue = loading ?: @"";
    [self layoutUI];
}

#pragma mark 文字

- (void)showText:(NSString *)text {
    [self showText:text completionHandler:nil];
}

- (void)showText:(NSString *)text hideAfterDelay:(CGFloat)second {
    [self showText:text hideAfterDelay:second completionHandler:nil];
}

- (void)showText:(NSString *)text completionHandler:(YLProgressHUDCompletionHandler)completionHandler {
    [self showText:text hideAfterDelay:kHUDHideDefaultSecond completionHandler:completionHandler];
}

- (void)showText:(NSString *)text hideAfterDelay:(CGFloat)second completionHandler:(YLProgressHUDCompletionHandler)completionHandler {
    [self.customView removeFromSuperview];
    self.customView = nil;
    self.textLabel.stringValue = text ?: @"";
    self.completionHandler = completionHandler;
    [self layoutUI];
    if(second >= 0) {
        // 自动隐藏
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [YLProgressHUD hideHUD:self];
        });
    }
}

#pragma mark 成功

- (void)showSuccess:(NSString *)success {
    [self showSuccess:success completionHandler:nil];
}

- (void)showSuccess:(NSString *)success hideAfterDelay:(CGFloat)second {
    [self showSuccess:success hideAfterDelay:second completionHandler:nil];
}

- (void)showSuccess:(NSString *)success completionHandler:(YLProgressHUDCompletionHandler)completionHandler {
    [self showSuccess:success hideAfterDelay:kHUDHideDefaultSecond completionHandler:completionHandler];
}

- (void)showSuccess:(NSString *)success hideAfterDelay:(CGFloat)second completionHandler:(YLProgressHUDCompletionHandler)completionHandler {
    [self.customView removeFromSuperview];
    self.customView = [YLProgressHUD createSuccessViewWithStyle:self.style];
    [self.hudView addSubview:self.customView];
    self.textLabel.stringValue = success ?: @"";
    self.completionHandler = completionHandler;
    [self layoutUI];
    if(second >= 0) {
        // 自动隐藏
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [YLProgressHUD hideHUD:self];
        });
    }
}

#pragma mark 错误

- (void)showError:(NSString *)error {
    [self showError:error completionHandler:nil];
}

- (void)showError:(NSString *)error hideAfterDelay:(CGFloat)second {
    [self showError:error hideAfterDelay:second completionHandler:nil];
}

- (void)showError:(NSString *)error completionHandler:(YLProgressHUDCompletionHandler)completionHandler {
    [self showError:error hideAfterDelay:kHUDHideDefaultSecond completionHandler:completionHandler];
}

- (void)showError:(NSString *)error hideAfterDelay:(CGFloat)second completionHandler:(YLProgressHUDCompletionHandler)completionHandler {
    [self.customView removeFromSuperview];
    self.customView = [YLProgressHUD createErrorViewWithStyle:self.style];
    [self.hudView addSubview:self.customView];
    self.textLabel.stringValue = error ?: @"";
    self.completionHandler = completionHandler;
    [self layoutUI];
    if(second >= 0) {
        // 自动隐藏
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [YLProgressHUD hideHUD:self];
        });
    }
}

#pragma mark 进度

- (void)showProgress:(CGFloat)progress {
    [self showProgress:progress text:nil];
}

- (void)showProgress:(CGFloat)progress text:(NSString * _Nullable)text {
    if([self.customView isKindOfClass:[YLProgressDisplayView class]]) {
        YLProgressDisplayView *progressView = (YLProgressDisplayView *)(self.customView);
        progressView.progress = progress;
        self.textLabel.stringValue = text ?: progressView.progressText;
    } else {
        [self.customView removeFromSuperview];
        YLProgressDisplayView *progressView = [YLProgressHUD createProgressViewWithStyle:self.style];
        progressView.progress = progress;
        self.customView = progressView;
        [self.hudView addSubview:self.customView];
        self.textLabel.stringValue = text ?: progressView.progressText;
    }
    [self layoutUI];
}

#pragma mark 获取view的截图
- (NSImage *)getThumbImageFromView:(NSView *)view {
    NSBitmapImageRep *rep = [view bitmapImageRepForCachingDisplayInRect:view.bounds];
    [view cacheDisplayInRect:view.bounds toBitmapImageRep:rep];
    NSImage *image = [[NSImage alloc] initWithSize:view.bounds.size];
    [image addRepresentation:rep];
    return image;
}

#pragma mark -

#pragma mark 获取成功的view
+ (NSImageView *)createSuccessViewWithStyle:(YLProgressHUDStyle)style {
    NSImageView *successView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 40, 40)];
    successView.tag = 10000;
    [YLProgressHUD setImageView:successView withStyle:style];
    return successView;
}

#pragma mark 获取失败的view
+ (NSImageView *)createErrorViewWithStyle:(YLProgressHUDStyle)style {
    NSImageView *errorView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 40, 40)];
    errorView.tag = 20000;
    [YLProgressHUD setImageView:errorView withStyle:style];
    return errorView;
}

+ (void)setImageView:(NSImageView *)imageView withStyle:(YLProgressHUDStyle)style {
    if(style == YLProgressHUDStyleAuto) {
        style = kAppIsDarkTheme ? YLProgressHUDStyleWhite : YLProgressHUDStyleBlack;
    }
    if(imageView.tag == 10000) {
        // 成功
        if(style == YLProgressHUDStyleBlack) {
            imageView.image = [YLProgressHUD bundleImage:@"success_white@2x.png"];
        } else {
            imageView.image = [YLProgressHUD bundleImage:@"success_black@2x.png"];
        }
    } else if(imageView.tag == 20000) {
        // 失败
        if(style == YLProgressHUDStyleBlack) {
            imageView.image = [YLProgressHUD bundleImage:@"error_white@2x.png"];
        } else {
            imageView.image = [YLProgressHUD bundleImage:@"error_black@2x.png"];
        }
    }
}

#pragma mark 获取加载中的view
+ (NSProgressIndicator *)createLoadingIndicator {
    NSProgressIndicator *indicator = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(0, 0, 40, 40)];
    indicator.style = NSProgressIndicatorStyleSpinning;
    indicator.contentFilters = @[[YLProgressHUD createColorFilterWithStyle:YLProgressHUDConfig.share.style]];
    [indicator startAnimation:nil];
    return indicator;
}

+ (CIFilter *)createColorFilterWithStyle:(YLProgressHUDStyle)style {
    if(style == YLProgressHUDStyleAuto) {
        style = kAppIsDarkTheme ? YLProgressHUDStyleWhite : YLProgressHUDStyleBlack;
    }
    NSColor *color;
    if(style == YLProgressHUDStyleWhite) {
        color = [[NSColor blackColor] colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
    } else {
        color = [[NSColor whiteColor] colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
    }
    CIVector *min = [CIVector vectorWithX:color.redComponent Y:color.greenComponent Z:color.blueComponent W:0];
    CIVector *max = [CIVector vectorWithX:color.redComponent Y:color.greenComponent Z:color.blueComponent W:1.0];
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIColorClamp"];
    [colorFilter setDefaults];
    [colorFilter setValue:min forKey:@"inputMinComponents"];
    [colorFilter setValue:max forKey:@"inputMaxComponents"];
    return colorFilter;
}

#pragma mark 获取进度的view
+ (YLProgressDisplayView *)createProgressViewWithStyle:(YLProgressHUDStyle)style {
    if(style == YLProgressHUDStyleAuto) {
        style = kAppIsDarkTheme ? YLProgressHUDStyleWhite : YLProgressHUDStyleBlack;
    }
    YLProgressDisplayView *progressView = [[YLProgressDisplayView alloc] initWithFrame:NSMakeRect(0, 0, 40, 40)];
    progressView.style = style;
    return progressView;
}

#pragma mark 获取bundle里的图片
+ (NSImage *)bundleImage:(NSString *)icon {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"YLProgressHUD" withExtension:@"bundle"];
    if(url == nil) {
        url = [[[[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil] URLByAppendingPathComponent:@"YLCategory"] URLByAppendingPathExtension:@"framework"];
        NSBundle *bundle = [NSBundle bundleWithURL:url];
        url = [bundle URLForResource:@"YLProgressHUD" withExtension:@"bundle"];
    }
    NSString *path = [[NSBundle bundleWithURL:url].bundlePath stringByAppendingPathComponent:icon];
    return [[NSImage alloc] initWithContentsOfFile:path];
}

@end

#pragma mark - 配置信息

@implementation YLProgressHUDConfig

+ (instancetype)share {
    static dispatch_once_t onceToken = '\0';
    static YLProgressHUDConfig *config = nil;
    dispatch_once(&onceToken, ^{
        config = [[YLProgressHUDConfig alloc] init];
        config.style = YLProgressHUDStyleAuto;
        config.movable = YES;
    });
    return config;
}

@end
