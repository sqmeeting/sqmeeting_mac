#import "FrtcMediaStaticsView.h"

@interface FrtcMediaStaticsView() <HoverImageViewDelegate,FrtcHotViewAreaViewDelegate>

@end;

@implementation FrtcMediaStaticsView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if(self = [super initWithFrame:frameRect]) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor colorWithString:@"#F8F9FA" andAlpha:1.0].CGColor;
        
        NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited;
        
        NSRect rect = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height);
        NSTrackingArea *focusTrackingArea = [[NSTrackingArea alloc] initWithRect:rect
                                                                         options:focusTrackingAreaOptions owner:self userInfo:nil];
        [self addTrackingArea:focusTrackingArea];
        
        [self frtcMediaStaticsViewLayout];
    }
    
    return  self;
}

#pragma mark --FrtcMediaStaticsView Layout--
- (void)frtcMediaStaticsViewLayout {
    [self.latencyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(16);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.latencyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.latencyLabel.mas_centerY);
        make.left.mas_equalTo(56);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.latencyLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(16);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.upArrowImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.rateLabel.mas_centerY);
        make.left.mas_equalTo([self distance]);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(12);
    }];
    
    [self.rateTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.rateLabel.mas_centerY);
        make.left.mas_equalTo(self.upArrowImageView1.mas_right).offset(2);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.downArrowImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.rateLabel.mas_centerY);
        make.left.mas_equalTo(162);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(12);
    }];
    
    [self.rateDownTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.rateLabel.mas_centerY);
        make.left.mas_equalTo(self.downArrowImageView1.mas_right).offset(2);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.audioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rateLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(16);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.upArrowImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.audioLabel.mas_centerY);
        make.left.mas_equalTo([self distance]);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(12);
    }];
    
    [self.audioTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.audioLabel.mas_centerY);
        make.left.mas_equalTo(self.upArrowImageView2.mas_right).offset(2);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.downArrowImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.audioLabel.mas_centerY);
        make.left.mas_equalTo(162);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(12);
    }];
    
    [self.audioDownTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.audioLabel.mas_centerY);
        make.left.mas_equalTo(self.downArrowImageView2.mas_right).offset(2);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.videoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.audioLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(16);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.upArrowImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.videoLabel.mas_centerY);
        make.left.mas_equalTo([self distance]);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(12);
    }];
    
    [self.videoTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.videoLabel.mas_centerY);
        make.left.mas_equalTo(self.upArrowImageView3.mas_right).offset(2);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.downArrowImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.videoLabel.mas_centerY);
        make.left.mas_equalTo(162);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(12);
    }];
    
    [self.videoDownTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.videoLabel.mas_centerY);
        make.left.mas_equalTo(self.downArrowImageView3.mas_right).offset(2);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.videoLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(16);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.upArrowImageView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.shareLabel.mas_centerY);
        make.left.mas_equalTo([self distance]);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(12);
    }];
    
    [self.shareTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.shareLabel.mas_centerY);
        make.left.mas_equalTo(self.upArrowImageView4.mas_right).offset(2);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.downArrowImageView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.shareLabel.mas_centerY);
        make.left.mas_equalTo(162);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(12);
    }];
    
    [self.shareDownTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.shareLabel.mas_centerY);
        make.left.mas_equalTo(self.downArrowImageView4.mas_right).offset(2);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(166);
        make.left.mas_equalTo(self.mas_left).offset(53);
        make.width.mas_equalTo(14.22);
        make.height.mas_equalTo(16);
    }];
    
    [self.staticsInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(5);
        make.centerY.mas_equalTo(self.imageView.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.hotAreaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(166);
        make.left.mas_equalTo(self.mas_left).offset(53);
        //make.right.mas_equalTo(self.staticsInfoLabel.mas_right);
        make.width.mas_equalTo(105);
        make.height.mas_equalTo(26);
    }];
}

- (CGFloat)distance {
    NSString * language = [FMLanguageConfig userLanguage] ? : [NSLocale preferredLanguages].firstObject;
    
    if([language hasPrefix:@"en"]) {
        return 70.0;
    } else {
        return 56.0;
    }
}

#pragma mark --FrtcHotViewAreaViewDelegate--
- (void)didIntoArea {
    if(self.mediaStaticsDelegate && [self.mediaStaticsDelegate respondsToSelector:@selector(popupStaticsWindow)]) {
        [self.mediaStaticsDelegate popupStaticsWindow];
    }
}

#pragma mark --HoverImageViewDelegate--
- (void)hoverImageViewClickedwithSenderTag:(NSInteger)tag {
    NSLog(@"hoverImageViewClickedwithSenderTag:(NSInteger)tag");
    if(self.mediaStaticsDelegate && [self.mediaStaticsDelegate respondsToSelector:@selector(popupStaticsWindow)]) {
        [self.mediaStaticsDelegate popupStaticsWindow];
    }
}

#pragma mark --Interface Class
- (void)updateStatics:(FrtcMediaStaticsModel *)mediaStaticsModel {
    self.latencyTextField.stringValue =  [NSString stringWithFormat:@"%@ ms", [self convertIntToString:mediaStaticsModel.rttTime]];
    [NSString stringWithFormat:@"%@ ms", [self convertIntToString:mediaStaticsModel.rttTime]];
    
    long rates = [mediaStaticsModel.callRate longValue];
    //NSString *callRateString;
    if (rates > 100000) {
        long rate1 = rates / 100000;
        long rate2 = rates % 100000;
        self.rateTextField.stringValue = [NSString stringWithFormat:@"%ld",rate1];
        self.rateDownTextField.stringValue =  [NSString stringWithFormat:@"%ld",rate2];
    } else {
        self.rateTextField.stringValue = [NSString stringWithFormat:@"%ld",rates];
        self.rateDownTextField.stringValue =  [NSString stringWithFormat:@"%ld",rates];
    }
    
//    self.rateTextField.stringValue = [self convertIntToString:mediaStaticsModel.upRate];
//    self.rateDownTextField.stringValue = [self convertIntToString:mediaStaticsModel.downRate];
    
    self.audioTextField.stringValue = [NSString stringWithFormat:@"%d (%d%%)", mediaStaticsModel.audioUpRate, mediaStaticsModel.audioUpPackLost];
    self.audioDownTextField.stringValue = [NSString stringWithFormat:@"%d (%d%%)", mediaStaticsModel.audioDownRate, mediaStaticsModel.audioDownPackLost];
    
    self.videoTextField.stringValue = [NSString stringWithFormat:@"%d (%d%%)", mediaStaticsModel.videoUpRate, mediaStaticsModel.videoUpPackLost];
    self.videoDownTextField.stringValue = [NSString stringWithFormat:@"%d (%d%%)", mediaStaticsModel.videoDownRate, mediaStaticsModel.videoDownPackLost];
    
    self.shareTextField.stringValue = [NSString stringWithFormat:@"%d (%d%%)", mediaStaticsModel.contentUpRate, mediaStaticsModel.contentUpPackLost];
    self.shareDownTextField.stringValue = [NSString stringWithFormat:@"%d (%d%%)", mediaStaticsModel.contentdownRate, mediaStaticsModel.contentdownPackLost];
}

- (NSString *)convertIntToString:(int)temp {
    return [NSString stringWithFormat:@"%d", temp];
}

#pragma mark --mouse load--
- (void)mouseEntered:(NSEvent *)event {
    if(self.mediaStaticsDelegate && [self.mediaStaticsDelegate respondsToSelector:@selector(staticsViewCursorIsInView:)]) {
        [self.mediaStaticsDelegate staticsViewCursorIsInView:YES];
    }
}

- (void)mouseExited:(NSEvent *)event {
    if(self.mediaStaticsDelegate && [self.mediaStaticsDelegate respondsToSelector:@selector(staticsViewCursorIsInView:)]) {
        [self.mediaStaticsDelegate staticsViewCursorIsInView:NO];
    }
}

#pragma mark --lazy load--
- (NSTextField *)latencyLabel {
    if(!_latencyLabel) {
        _latencyLabel = [self label];
        _latencyLabel.stringValue = NSLocalizedString(@"FM_DELAY", @"Delay");
        [self addSubview:_latencyLabel];
    }
    
    return _latencyLabel;
}

- (NSTextField *)latencyTextField {
    if(!_latencyTextField) {
        _latencyTextField = [self textField];
        _latencyTextField.stringValue = @"42 ms";
        [self addSubview:_latencyTextField];
    }
    
    return _latencyTextField;
}

- (NSTextField *)rateLabel {
    if(!_rateLabel) {
        _rateLabel = [self label];
        _rateLabel.stringValue = NSLocalizedString(@"FM_CALL_RATE_USED", @"Call Rate");
        [self addSubview:_rateLabel];
    }
    
    return _rateLabel;
}

- (NSTextField *)rateTextField {
    if(!_rateTextField) {
        _rateTextField = [self textField];
        _rateTextField.stringValue = @"5674";
        [self addSubview:_rateTextField];
    }
    
    return _rateTextField;;
}

- (NSTextField *)rateDownTextField {
    if(!_rateDownTextField) {
        _rateDownTextField = [self textField];
        _rateDownTextField.stringValue = @"2345";
        [self addSubview:_rateDownTextField];
    }
    
    return _rateDownTextField;;
}



- (NSTextField *)audioLabel {
    if(!_audioLabel) {
        _audioLabel = [self label];
        _audioLabel.stringValue = NSLocalizedString(@"FM_AUDIO", @"Audio");
        [self addSubview:_audioLabel];
    }
    
    return _audioLabel;
}

- (NSTextField *)audioTextField {
    if(!_audioTextField) {
        _audioTextField = [self textField];
        _audioTextField.stringValue = @"34 (10%)";
        [self addSubview:_audioTextField];
    }
    
    return _audioTextField;;
}

- (NSTextField *)audioDownTextField {
    if(!_audioDownTextField) {
        _audioDownTextField = [self textField];
        _audioDownTextField.stringValue = @"78 (25%)";
        [self addSubview:_audioDownTextField];
    }
    
    return _audioDownTextField;;
}

- (NSTextField *)videoLabel {
    if(!_videoLabel) {
        _videoLabel = [self label];
        _videoLabel.stringValue = NSLocalizedString(@"FM_VIDEO", @"Video");
        [self addSubview:_videoLabel];
    }
    
    return _videoLabel;
}

- (NSTextField *)videoTextField {
    if(!_videoTextField) {
        _videoTextField = [self textField];
        _videoTextField.stringValue = @"768 (23%)";
        [self addSubview:_videoTextField];
    }
    
    return _videoTextField;;
}

- (NSTextField *)videoDownTextField {
    if(!_videoDownTextField) {
        _videoDownTextField = [self textField];
        _videoDownTextField.stringValue = @"3421 (30%)";
        [self addSubview:_videoDownTextField];
    }
    
    return _videoDownTextField;;
}

- (NSTextField *)shareLabel {
    if(!_shareLabel) {
        _shareLabel = [self label];
        _shareLabel.stringValue = NSLocalizedString(@"FM_SHARE", @"Content");
        [self addSubview:_shareLabel];
    }
    
    return _shareLabel;
}

- (NSTextField *)shareTextField {
    if(!_shareTextField) {
        _shareTextField = [self textField];
        _shareTextField.stringValue = @"123 (13%)";
        [self addSubview:_shareTextField];
    }
    
    return _shareTextField;;
}

- (NSTextField *)shareDownTextField {
    if(!_shareDownTextField) {
        _shareDownTextField = [self textField];
        _shareDownTextField.stringValue = @"_";
        [self addSubview:_shareDownTextField];
    }
    
    return _shareDownTextField;;
}

- (NSImageView *)upArrowImageView1 {
    if(!_upArrowImageView1) {
        _upArrowImageView1 = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 7, 12)];
        _upArrowImageView1.image = [NSImage imageNamed:@"icon-up-arrow"];
        [self addSubview:_upArrowImageView1];
    }
    
    return _upArrowImageView1;
}

- (NSImageView *)upArrowImageView2 {
    if(!_upArrowImageView2) {
        _upArrowImageView2 = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 7, 12)];
        _upArrowImageView2.image = [NSImage imageNamed:@"icon-up-arrow"];
        [self addSubview:_upArrowImageView2];
    }
    
    return _upArrowImageView2;
}

- (NSImageView *)upArrowImageView3 {
    if(!_upArrowImageView3) {
        _upArrowImageView3 = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 7, 12)];
        _upArrowImageView3.image = [NSImage imageNamed:@"icon-up-arrow"];
        [self addSubview:_upArrowImageView3];
    }
    
    return _upArrowImageView3;
}

- (NSImageView *)upArrowImageView4 {
    if(!_upArrowImageView4) {
        _upArrowImageView4 = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 7, 12)];
        _upArrowImageView4.image = [NSImage imageNamed:@"icon-up-arrow"];
        [self addSubview:_upArrowImageView4];
    }
    
    return _upArrowImageView4;
}

- (NSImageView *)downArrowImageView1 {
    if(!_downArrowImageView1) {
        _downArrowImageView1 = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 7, 12)];
        _downArrowImageView1.image = [NSImage imageNamed:@"icon-down-arrow"];
        [self addSubview:_downArrowImageView1];
    }
    
    return _downArrowImageView1;
}

- (NSImageView *)downArrowImageView2 {
    if(!_downArrowImageView2) {
        _downArrowImageView2 = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 7, 12)];
        _downArrowImageView2.image = [NSImage imageNamed:@"icon-down-arrow"];
        [self addSubview:_downArrowImageView2];
    }
    
    return _downArrowImageView2;
}

- (NSImageView *)downArrowImageView3 {
    if(!_downArrowImageView3) {
        _downArrowImageView3 = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 7, 12)];
        _downArrowImageView3.image = [NSImage imageNamed:@"icon-down-arrow"];
        [self addSubview:_downArrowImageView3];
    }
    
    return _downArrowImageView3;
}

- (NSImageView *)downArrowImageView4 {
    if(!_downArrowImageView4) {
        _downArrowImageView4 = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 7, 12)];
        _downArrowImageView4.image = [NSImage imageNamed:@"icon-down-arrow"];
        [self addSubview:_downArrowImageView4];
    }
    
    return _downArrowImageView4;
}

- (HoverImageView *)imageView {
    if(!_imageView) {
        _imageView = [[HoverImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        _imageView.delegate = self;
        _imageView.image = [NSImage imageNamed:@"icon-copy"];
        [self addSubview:_imageView];
    }
    
    return _imageView;
}

- (NSTextField *)staticsInfoLabel {
    if(!_staticsInfoLabel) {
        _staticsInfoLabel = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _staticsInfoLabel.backgroundColor = [NSColor clearColor];
        _staticsInfoLabel.font = [NSFont systemFontOfSize:12 weight:NSFontWeightRegular];
        _staticsInfoLabel.alignment = NSTextAlignmentLeft;
        _staticsInfoLabel.textColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0];
        _staticsInfoLabel.bordered = NO;
        _staticsInfoLabel.editable = NO;
        _staticsInfoLabel.stringValue = [NSString stringWithFormat:@"%@ (%@)", NSLocalizedString(@"FM_STATISTICS", @"Call Statistics"), NSLocalizedString(@"FM_INTERNAL_TEST", @"Internal test")];
        [self addSubview:_staticsInfoLabel];
        
    }
    
    return _staticsInfoLabel;;
}

- (FrtcHotViewAreaView *)hotAreaView {
    if(!_hotAreaView) {
        _hotAreaView = [[FrtcHotViewAreaView alloc] initWithFrame:NSMakeRect(0, 0, 105, 26)];
        _hotAreaView.layer.backgroundColor = [NSColor clearColor].CGColor;
        _hotAreaView.delegate = self;
        [self addSubview:_hotAreaView];
    }
    
    return _hotAreaView;
}

#pragma mark --internal function--
- (NSTextField *)label {
    NSTextField *label = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    label.backgroundColor = [NSColor clearColor];
    label.font = [NSFont systemFontOfSize:12 weight:NSFontWeightRegular];
    label.alignment = NSTextAlignmentLeft;
    label.textColor = [NSColor colorWithString:@"#666666" andAlpha:1.0];
    label.bordered = NO;
    label.editable = NO;
    
    return label;
}

- (NSTextField *)textField {
    NSTextField *textField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    textField.backgroundColor = [NSColor clearColor];
    textField.font = [NSFont systemFontOfSize:12 weight:NSFontWeightRegular];
    textField.alignment = NSTextAlignmentLeft;
    textField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
    textField.bordered = NO;
    textField.editable = NO;
    
    return textField;
}

@end
