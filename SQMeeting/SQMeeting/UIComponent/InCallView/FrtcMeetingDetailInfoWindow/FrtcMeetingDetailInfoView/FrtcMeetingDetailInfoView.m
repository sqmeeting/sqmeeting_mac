#import "FrtcMeetingDetailInfoView.h"

@implementation FrtcMeetingDetailInfoView

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
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        
        [self layoutInfomationView];
    }
    
    return self;
}

#pragma mark --Meeting Information Layout--
- (void)layoutInfomationView {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.themeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
        
    [self.meetingBeginTimeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.themeTextField.mas_bottom).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.endTimeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.meetingBeginTimeTextField.mas_bottom).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.meetingNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.endTimeTextField.mas_bottom).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.meetingPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.meetingNumberTextField.mas_bottom).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.secondIntroductionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.meetingPasswordTextField.mas_bottom).offset(24);
        make.width.mas_equalTo(324);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.meetingUrlTextFieldTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.secondIntroductionTextField.mas_bottom).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.meetingUrlTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.meetingUrlTextFieldTips.mas_bottom).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)updateLayout {
    [self.meetingNumberTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.themeTextField.mas_bottom).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)updatePasswordLayout {
    [self.secondIntroductionTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.meetingNumberTextField.mas_bottom).offset(24);
        make.width.mas_equalTo(324);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    NSString *endTitle1 = NSLocalizedString(@"FM_MEETING_INFO_MESSAGE", @"Open the SQ Meeting CE  client and enter the Meeting ID to join the meeting");
    self.secondIntroductionTextField.stringValue = endTitle1;
}

- (void)updateRecurrenceLayout {
    [self.recurrenceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.endTimeTextField.mas_bottom).offset(12);
        make.width.mas_equalTo(324);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.meetingNumberTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(self.recurrenceTextField.mas_bottom).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

#pragma mark --Lazy Load--
- (NSTextField *)titleTextField {
    if(!_titleTextField) {
        _titleTextField = [self detailInfoTextField];
        _titleTextField.stringValue = @"美美邀请您参加会议";
        [self addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (NSTextField *)themeTextField {
    if(!_themeTextField) {
        _themeTextField = [self detailInfoTextField];
        _themeTextField.stringValue = @"会议主题：美美的会议";
        [self addSubview:_themeTextField];
    }
    
    return _themeTextField;
}

- (NSTextField *)introductionTextField {
    if(!_introductionTextField) {
        _introductionTextField = [self detailInfoTextField];
        _introductionTextField.stringValue = @"会议介绍：会议介绍的文字";
        [self addSubview:_introductionTextField];
    }
    
    return _introductionTextField;
}

- (NSTextField *)meetingBeginTimeTextField {
    if(!_meetingBeginTimeTextField) {
        _meetingBeginTimeTextField = [self detailInfoTextField];
        _meetingBeginTimeTextField.stringValue = @"开始时间：2021-11-18 10:28";
        [self addSubview:_meetingBeginTimeTextField];
    }
    
    return _meetingBeginTimeTextField;
}

- (NSTextField *)meetingNumberTextField {
    if(!_meetingNumberTextField) {
        _meetingNumberTextField = [self detailInfoTextField];
        _meetingNumberTextField.stringValue = @"会议号：66661234";
        [self addSubview:_meetingNumberTextField];
    }
    
    return _meetingNumberTextField;
}

- (NSTextField *)meetingPasswordTextField {
    if(!_meetingPasswordTextField) {
        _meetingPasswordTextField = [self detailInfoTextField];
        _meetingPasswordTextField.stringValue = @"会议密码：123921";
        [self addSubview:_meetingPasswordTextField];
    }
    
    return _meetingPasswordTextField;
}

- (NSTextField *)secondIntroductionTextField {
    if(!_secondIntroductionTextField) {
        _secondIntroductionTextField = [self detailInfoTextField];
        _secondIntroductionTextField.stringValue = NSLocalizedString(@"FM_MEETING_INFO_MESSAGE_AND_PASSWORD", @"Open the SQ Meeting CE  client and enter the \"Meeting ID\" and \"Password\" to join the meeting");
        _secondIntroductionTextField.maximumNumberOfLines = 2;
        [self addSubview:_secondIntroductionTextField];
    }
    
    return _secondIntroductionTextField;
}

- (NSTextField *)meetingUrlTextFieldTips {
    if(!_meetingUrlTextFieldTips) {
        _meetingUrlTextFieldTips = [self detailInfoTextField];
        _meetingUrlTextFieldTips.stringValue = NSLocalizedString(@"FM_URL_JOIN_CALL", @"Or click the following URL to join meeting:");
        [self addSubview:_meetingUrlTextFieldTips];
    }
    
    return _meetingUrlTextFieldTips;
}

- (NSTextField *)beginTimeTextField {
    if(!_beginTimeTextField) {
        _beginTimeTextField = [self detailInfoTextField];
        _beginTimeTextField.stringValue = NSLocalizedString(@"FM_MEETING_START_TIME", @"Start Time");
        [self addSubview:_beginTimeTextField];
    }
    
    return _beginTimeTextField;
}

- (NSTextField *)beginTimeDetailTextField {
    if(!_beginTimeDetailTextField) {
        _beginTimeDetailTextField = [self detailInfoTextField];
        //_beginTimeDetailTextField.stringValue = NSLocalizedString(@"FM_URL_JOIN_CALL", @"Or click this url to join meeting:");
        [self addSubview:_beginTimeDetailTextField];
    }
    
    return _beginTimeDetailTextField;
}

- (NSTextField *)endTimeTextField {
    if(!_endTimeTextField) {
        _endTimeTextField = [self detailInfoTextField];
        _endTimeTextField.stringValue = NSLocalizedString(@"FM_MEETING_END_TIME", @"End time");
        [self addSubview:_endTimeTextField];
    }
    
    return _endTimeTextField;
}

- (NSTextField *)endTimeDetailTextField {
    if(!_endTimeDetailTextField) {
        _endTimeDetailTextField = [self detailInfoTextField];
        [self addSubview:_endTimeDetailTextField];
    }
    
    return _endTimeDetailTextField;
}

- (NSTextField *)meetingUrlTextField {
    if(!_meetingUrlTextField) {
        _meetingUrlTextField = [self detailInfoTextField];
        _meetingUrlTextField.stringValue = NSLocalizedString(@"FM_MEETING_INFO_MESSAGE", @"Open the SQ Meeting CE  client and enter the “Meeting ID” to join the meeting");
        [self addSubview:_meetingUrlTextField];
        _meetingUrlTextField.textColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0];
    }
    
    return _meetingUrlTextField;
}

- (NSTextField *)recurrenceTextField {
    if(!_recurrenceTextField) {
        _recurrenceTextField = [self detailInfoTextField];
        _recurrenceTextField.maximumNumberOfLines = 0;
        _recurrenceTextField.stringValue = NSLocalizedString(@"FM_MEETING_RECURRENCE_RECURRENT", @"Recurrence");
        [self addSubview:_recurrenceTextField];
    }
    
    return _recurrenceTextField;
}

- (NSTextField *)recurrenceDetailTextField {
    if(!_recurrenceDetailTextField) {
        _recurrenceDetailTextField = [self detailInfoTextField];
        [self addSubview:_recurrenceDetailTextField];
    }
    
    return _recurrenceDetailTextField;
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
