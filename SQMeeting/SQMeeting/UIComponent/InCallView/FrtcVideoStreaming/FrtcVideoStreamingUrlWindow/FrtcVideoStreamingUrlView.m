#import "FrtcVideoStreamingUrlView.h"

@implementation FrtcVideoStreamingUrlView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
        //self.layer.backgroundColor = [NSColor redColor].CGColor;
        
        
        [self layoutStreamingUrlView];
    }
    
    return self;
}

- (void)layoutStreamingUrlView {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(12);
        make.width.mas_equalTo(285);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.meetingUrlTextFieldTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(20);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.urlTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.meetingUrlTextFieldTips.mas_bottom).offset(12);
        make.width.mas_equalTo(285);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.streamingPasswordTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.urlTextField.mas_bottom).offset(20);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.streamingPasswordDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.streamingPasswordTips.mas_right);
        make.centerY.mas_equalTo(self.streamingPasswordTips.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
//    [self.urlTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(16);
//        make.top.mas_equalTo(self.streamingPasswordTips.mas_bottom).offset(20);
//        make.width.mas_greaterThanOrEqualTo(0);
//        make.height.mas_greaterThanOrEqualTo(0);
//    }];
}

#pragma mark --Lazy Load--
- (NSTextField *)titleTextField {
    if(!_titleTextField) {
        _titleTextField = [self detailInfoTextField];
        _titleTextField.maximumNumberOfLines = 0;
        _titleTextField.stringValue = @"李美美 邀请您观看“2022年第三季度总结会”的会议直播";
        
        [self addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (NSTextField *)meetingUrlTextFieldTips {
    if(!_meetingUrlTextFieldTips) {
        _meetingUrlTextFieldTips = [self detailInfoTextField];
        _meetingUrlTextFieldTips.stringValue = NSLocalizedString(@"FM_VIDEO_STREAMING_SHARE_URL", @"Click the link to watch:");
        [self addSubview:_meetingUrlTextFieldTips];
    }
    
    return _meetingUrlTextFieldTips;
}

- (NSTextField *)meetingUrlTextField {
    if(!_meetingUrlTextField) {
        _meetingUrlTextField = [self detailInfoTextField];
        _meetingUrlTextField.maximumNumberOfLines = 0;
        _meetingUrlTextField.stringValue = NSLocalizedString(@"FM_MEETING_INFO_MESSAGE", @"Open the SQ Meeting CE  client and enter the “Meeting ID” to join the meeting");
        [self addSubview:_meetingUrlTextField];
        _meetingUrlTextField.textColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0];
        _meetingUrlTextField.stringValue = @"https://shenqi.isgo.com:8443/#/versions versions23949485";
    }
    
    return _meetingUrlTextField;
}

- (FrtcHyperlinkLabel *)urlTextField {
    if(!_urlTextField) {
        _urlTextField = [[FrtcHyperlinkLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _urlTextField.backgroundColor = [NSColor clearColor];
        _urlTextField.font = [NSFont systemFontOfSize:13 weight:NSFontWeightRegular];
        _urlTextField.alignment = NSTextAlignmentLeft;
        _urlTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _urlTextField.bordered = NO;
        _urlTextField.editable = NO;
        _urlTextField.maximumNumberOfLines = 0;
        [self addSubview:_urlTextField];
        _urlTextField.textColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0];
    }
    
    return _urlTextField;
}

- (NSTextField *)streamingPasswordTips {
    if(!_streamingPasswordTips) {
        _streamingPasswordTips = [self detailInfoTextField];
        _streamingPasswordTips.stringValue = NSLocalizedString(@"FM_VIDEO_STREAMING_PASSWORD_LIVE", @"Password:");
        [self addSubview:_streamingPasswordTips];
    }
    
    return _streamingPasswordTips;
}

- (NSTextField *)streamingPasswordDescription {
    if(!_streamingPasswordDescription) {
        _streamingPasswordDescription = [self detailInfoTextField];
        _streamingPasswordDescription.maximumNumberOfLines = 0;
        [self addSubview:_streamingPasswordDescription];
    }
    
    return _streamingPasswordDescription;
}

#pragma mark --Internal Function--
- (NSTextField *)detailInfoTextField {
    NSTextField * _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _titleTextField.backgroundColor = [NSColor clearColor];
    _titleTextField.font = [NSFont systemFontOfSize:13 weight:NSFontWeightRegular];
    _titleTextField.alignment = NSTextAlignmentLeft;
    _titleTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
    _titleTextField.bordered = NO;
    _titleTextField.editable = NO;
    
    return _titleTextField;
}

@end
