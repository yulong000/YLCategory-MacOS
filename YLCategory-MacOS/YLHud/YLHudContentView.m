//
//  YLHudContentView.m
//  YLCategory-MacOS
//
//  Created by 魏宇龙 on 2024/10/30.
//

#import "YLHudContentView.h"

@interface YLHudContentView ()

@property (nonatomic, strong) NSVisualEffectView *visualEffectView;

@end

@implementation YLHudContentView

- (instancetype)initWithFrame:(NSRect)frameRect {
    if(self = [super initWithFrame:frameRect]) {
        self.wantsLayer = YES;
        self.layer.cornerRadius = 10;
        
        self.visualEffectView = [[NSVisualEffectView alloc] init];
        self.visualEffectView.state = NSVisualEffectStateActive;
        self.visualEffectView.blendingMode = NSVisualEffectBlendingModeWithinWindow;
        [self addSubview:self.visualEffectView];
        
        self.style = YLHudStyleBlack;
    }
    return self;
}

- (void)layout {
    [super layout];
    self.visualEffectView.frame = self.bounds;
}

- (BOOL)isFlipped {
    return YES;
}

- (void)setStyle:(YLHudStyle)style {
    _style = style;
    self.visualEffectView.appearance = [NSAppearance appearanceNamed:style == YLHudStyleBlack ? NSAppearanceNameVibrantDark : NSAppearanceNameVibrantLight];
}

@end
