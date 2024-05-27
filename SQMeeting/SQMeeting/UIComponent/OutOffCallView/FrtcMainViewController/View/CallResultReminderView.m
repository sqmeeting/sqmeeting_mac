#import "CallResultReminderView.h"

@implementation CallResultReminderView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    if(self) {
        [self configLayout];
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor colorWithString:@"222222" andAlpha:0.7].CGColor;
        self.layer.cornerRadius = 4.0f;
    }
    
    return self;
}

#pragma mark --layout

- (void)configLayout {
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        //make.width.mas_greaterThanOrEqualTo(0);
        make.width.mas_equalTo(350);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
}

#pragma mark --getter lazy load
- (NSTextField *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[NSTextField alloc] init];
        _tipLabel.editable = NO;
        _tipLabel.bordered = NO;
        _tipLabel.backgroundColor = [NSColor clearColor];
        _tipLabel.alignment = NSTextAlignmentCenter;
        _tipLabel.maximumNumberOfLines = 3;
        //_tipLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _tipLabel.font = [NSFont systemFontOfSize:14.0];
        _tipLabel.stringValue = NSLocalizedString(@"FM_AUDIO_MUTE_REMINDER", @"Your are muted.");
        _tipLabel.textColor = [NSColor colorWithString:@"FFFFFF" andAlpha:1.0];
        
        [self addSubview:_tipLabel];
    }
    
    return _tipLabel;
}

@end
