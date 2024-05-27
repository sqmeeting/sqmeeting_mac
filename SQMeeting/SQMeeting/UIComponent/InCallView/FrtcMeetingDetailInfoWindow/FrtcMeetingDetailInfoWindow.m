#import "FrtcMeetingDetailInfoWindow.h"
#import "FrtcMeetingDetailInfoView.h"
#import "FrtcMultiTypesButton.h"
#import "CallResultReminderView.h"

@interface FrtcMeetingDetailInfoWindow ()

@property (nonatomic, strong) NSTextField *titleTextField;

@property (nonatomic, strong) FrtcMeetingDetailInfoView *infoView;

@property (nonatomic, strong) FrtcMultiTypesButton *copyButton;

@property (nonatomic, strong) CallResultReminderView *reminderView;

@property (nonatomic, strong) NSTimer *reminderTipsTimer;

@property (nonatomic, strong) FrtcInCallModel *model;

@end

@implementation FrtcMeetingDetailInfoWindow

- (instancetype)initWithSize:(NSSize)size {
    self = [super init];
    
    if(self) {
        self.releasedWhenClosed = NO;
        self.styleMask = self.styleMask | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskClosable;
        self.titlebarAppearsTransparent = YES;
        
        self.backgroundColor = [NSColor colorWithString:@"#EEEFF0" andAlpha:1.0];
        
        [self standardWindowButton:NSWindowZoomButton].enabled = NO;
        [self standardWindowButton:NSWindowCloseButton].enabled = YES;
        [self standardWindowButton:NSWindowMiniaturizeButton].enabled = NO;
        
        [[self standardWindowButton:NSWindowZoomButton] setHidden:YES];
        [[self standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
        [[self standardWindowButton:NSWindowCloseButton] setHidden:NO];
        
        self.contentMaxSize = size;
        self.contentMinSize = size;
        [self setContentSize:size];
        
        [self detailInfoWindowLayout];
    }
    
    return self;
}

#pragma mark --- Class Interface;
- (void)setupMeetingInfo:(FrtcInCallModel *)model {
    self.model = model;
    
    self.titleTextField.stringValue = model.conferenceName;
    
    if(self.model.isLoginCall) {
        self.infoView.titleTextField.stringValue = [NSString stringWithFormat:@"%@ %@", model.clientName, NSLocalizedString(@"FM_INVITE_PEOPLE", @"Invite you to a SQ Meeting CE  meeting")];
    } else {
        self.infoView.titleTextField.stringValue = [NSString stringWithFormat:@"%@",NSLocalizedString(@"FM_INVITE_PEOPLE", @"Invite you to a SQ Meeting CE  meeting")];
    }
    
    //self.infoView.titleTextField.stringValue = [NSString stringWithFormat:@"%@ %@", model.clientName, NSLocalizedString(@"FM_INVITE_PEOPLE", @"Invite you to a SQ Meeting CE  meeting")];
    self.infoView.themeTextField.stringValue = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"FM_MEETING_OBJECT", @"Meeting Topic"), model.conferenceName];
    self.infoView.meetingNumberTextField.stringValue = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"FM_MEETING_NUMBER", @"Meeting ID"), model.conferenceNumber];
    self.infoView.meetingBeginTimeTextField.stringValue = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"FM_MEETING_START_TIME", @"Start Time"),model.scheduleStartTime];
    self.infoView.endTimeTextField.stringValue = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"FM_MEETING_END_TIME", @"End time"),model.scheduleEndTime];
    self.infoView.meetingPasswordTextField.stringValue = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"FM_PASSCODE", @"Password"), model.conferencePassword ? model.conferencePassword : @""];
    if([model.groupMeetingUrl isEqualToString:@""]) {
        self.infoView.meetingUrlTextField.stringValue = model.meetingUrl;
    } else {
        self.infoView.meetingUrlTextField.stringValue = model.groupMeetingUrl;
    }
    
    if([model.meetingUrl isEqualToString:@""] || model.meetingUrl == nil) {
        self.infoView.meetingUrlTextField.hidden = YES;
        self.infoView.meetingUrlTextFieldTips.hidden = YES;
    }
    
    if([model.scheduleEndTime isEqualToString:@"1970-01-01 08:00"] && [model.scheduleStartTime isEqualToString:@"1970-01-01 08:00"]) {
        self.infoView.meetingBeginTimeTextField.hidden = YES;
        self.infoView.endTimeTextField.hidden = YES;
        [self.infoView updateLayout];
    }
    
    if([model.conferencePassword isEqualToString:@""] || model.conferencePassword == nil) {
        [self.infoView updatePasswordLayout];
        self.infoView.meetingPasswordTextField.hidden = YES;
    }
}


#pragma mark --Detail Info Window Layout
- (void)detailInfoWindowLayout {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(9);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(40);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(356);
        make.height.mas_equalTo(295);
    }];
    
    NSFont *font             = [NSFont systemFontOfSize:14.0f];
    NSDictionary *attributes = @{ NSFontAttributeName:font };
    CGSize size              = [NSLocalizedString(@"FM_MEETING_INFO_COPY", @"Copy Invitation") sizeWithAttributes:attributes];
    
    [self.copyButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.infoView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(size.width + 10);
        make.height.mas_equalTo(size.height + 10);
    }];
}
#pragma mark --Internal Function
- (void)showReminderView {
    NSString *reminderValue = NSLocalizedString(@"FM_MEETING_COPY_SUCCESS", @"Meeting invitation has been copied to the clipboard");
    NSFont *font             = [NSFont systemFontOfSize:14.0f];
    NSDictionary *attributes = @{ NSFontAttributeName:font };
    CGSize size              = [reminderValue sizeWithAttributes:attributes];
    
    [self.reminderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(size.width + 28);
        make.height.mas_equalTo(size.height + 20);
    }];
    
    self.reminderView.tipLabel.stringValue = reminderValue;
    self.reminderView.hidden = NO;
    [self runningTimer:3.0];
}

#pragma mark --timer--
- (void)runningTimer:(NSTimeInterval)timeInterval {
    self.reminderTipsTimer = [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(reminderTipsEvent) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.reminderTipsTimer forMode:NSRunLoopCommonModes];
}

- (void)cancelTimer {
    if(_reminderTipsTimer != nil) {
        [_reminderTipsTimer invalidate];
        _reminderTipsTimer = nil;
    }
}

- (void)reminderTipsEvent {
    [self.reminderView setHidden:YES];
}

#pragma mark --Button Sender--
- (void)onSaveBtnPressed {
    NSPasteboard *pastboard = [NSPasteboard generalPasteboard];
    [pastboard clearContents];
    
    NSString *pastString;
    
    if([self.model.meetingUrl isEqualToString:@""] || self.model.meetingUrl == nil) {
        if([self.model.scheduleEndTime isEqualToString:@"1970-01-01 08:00"] && [self.model.scheduleStartTime isEqualToString:@"1970-01-01 08:00"]) {
            if(![self.model.conferencePassword isEqualToString:@""] && self.model.conferencePassword != nil) {
                pastString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n\n%@",
                                    self.infoView.titleTextField.stringValue,
                                    self.infoView.themeTextField.stringValue,
                                    self.infoView.meetingNumberTextField.stringValue,
                                    self.infoView.meetingPasswordTextField.stringValue ? self.infoView.meetingPasswordTextField.stringValue : @"",
                                    self.infoView.secondIntroductionTextField.stringValue];
            } else {
                pastString = [NSString stringWithFormat:@"%@\n%@\n%@\n\n%@",
                                    self.infoView.titleTextField.stringValue,
                                    self.infoView.themeTextField.stringValue,
                                    self.infoView.meetingNumberTextField.stringValue,
                                    self.infoView.secondIntroductionTextField.stringValue];
            }
        } else {
            if(![self.model.conferencePassword isEqualToString:@""] && self.model.conferencePassword != nil) {
                pastString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n\n%@",
                                    self.infoView.titleTextField.stringValue,
                                    self.infoView.themeTextField.stringValue,
                                    self.infoView.meetingBeginTimeTextField.stringValue,
                                    self.infoView.endTimeTextField.stringValue,
                                    self.infoView.meetingNumberTextField.stringValue,
                                    self.infoView.meetingPasswordTextField.stringValue ? self.infoView.meetingPasswordTextField.stringValue : @"",
                                    self.infoView.secondIntroductionTextField.stringValue];
            } else {
                pastString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n\n%@",
                                    self.infoView.titleTextField.stringValue,
                                    self.infoView.themeTextField.stringValue,
                                    self.infoView.meetingBeginTimeTextField.stringValue,
                                    self.infoView.endTimeTextField.stringValue,
                                    self.infoView.meetingNumberTextField.stringValue,
                                    self.infoView.secondIntroductionTextField.stringValue];
            }
        }
    } else if([self.model.scheduleEndTime isEqualToString:@"1970-01-01 08:00"] && [self.model.scheduleStartTime isEqualToString:@"1970-01-01 08:00"]) {
        if([self.model.meetingUrl isEqualToString:@""] || self.model.meetingUrl == nil) {
            if(![self.model.conferencePassword isEqualToString:@""] && self.model.conferencePassword != nil) {
                pastString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n\n%@",
                                    self.infoView.titleTextField.stringValue,
                                    self.infoView.themeTextField.stringValue,
                                    self.infoView.meetingNumberTextField.stringValue,
                                    self.infoView.meetingPasswordTextField.stringValue ? self.infoView.meetingPasswordTextField.stringValue : @"",
                                    self.infoView.secondIntroductionTextField.stringValue];
            } else {
                pastString = [NSString stringWithFormat:@"%@\n%@\n%@\n\n%@",
                                    self.infoView.titleTextField.stringValue,
                                    self.infoView.themeTextField.stringValue,
                                    self.infoView.meetingNumberTextField.stringValue,
                                    self.infoView.secondIntroductionTextField.stringValue];
            }
        } else {
            if(![self.model.conferencePassword isEqualToString:@""] && self.model.conferencePassword != nil) {
                pastString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n%@",
                                    self.infoView.titleTextField.stringValue,
                                    self.infoView.themeTextField.stringValue,
                                    self.infoView.meetingNumberTextField.stringValue,
                                    self.infoView.meetingPasswordTextField.stringValue ? self.infoView.meetingPasswordTextField.stringValue : @"",
                                    self.infoView.secondIntroductionTextField.stringValue,
                                    self.infoView.meetingUrlTextFieldTips.stringValue,
                                    self.infoView.meetingUrlTextField.stringValue];
            } else {
                pastString = [NSString stringWithFormat:@"%@\n%@\n%@\n\n%@\n%@\n%@",
                                    self.infoView.titleTextField.stringValue,
                                    self.infoView.themeTextField.stringValue,
                                    self.infoView.meetingNumberTextField.stringValue,
                                    self.infoView.secondIntroductionTextField.stringValue,
                                    self.infoView.meetingUrlTextFieldTips.stringValue,
                                    self.infoView.meetingUrlTextField.stringValue];
            }
        }
    } else {
        if(![self.model.conferencePassword isEqualToString:@""] && self.model.conferencePassword != nil) {
            pastString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n\n%@\n%@\n%@",
                                self.infoView.titleTextField.stringValue,
                                self.infoView.themeTextField.stringValue,
                                self.infoView.meetingBeginTimeTextField.stringValue,
                                self.infoView.endTimeTextField.stringValue,
                                self.infoView.meetingNumberTextField.stringValue,
                                self.infoView.meetingPasswordTextField.stringValue ? self.infoView.meetingPasswordTextField.stringValue : @"",
                                self.infoView.secondIntroductionTextField.stringValue,
                                self.infoView.meetingUrlTextFieldTips.stringValue,
                                self.infoView.meetingUrlTextField.stringValue];
        } else {
            pastString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n\n%@\n%@",
                                self.infoView.titleTextField.stringValue,
                                self.infoView.themeTextField.stringValue,
                                self.infoView.meetingBeginTimeTextField.stringValue,
                                self.infoView.endTimeTextField.stringValue,
                                self.infoView.meetingNumberTextField.stringValue,
                                self.infoView.secondIntroductionTextField.stringValue,
                                self.infoView.meetingUrlTextFieldTips.stringValue,
                                self.infoView.meetingUrlTextField.stringValue];
        }
    }

    [pastboard setString:pastString forType:NSPasteboardTypeString];
    
    [self showReminderView];
}

#pragma mark --Lazy Load--

- (NSTextField *)titleTextField {
    if(!_titleTextField) {
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightMedium];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _titleTextField.stringValue = @"meimeiellie的会议";
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        [self.contentView addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (FrtcMeetingDetailInfoView *)infoView {
    if(!_infoView) {
        _infoView = [[FrtcMeetingDetailInfoView alloc] initWithFrame:NSMakeRect(0, 0, 356, 265)];
        [self.contentView addSubview:_infoView];
    }
    
    return _infoView;
}

- (FrtcMultiTypesButton *)copyButton {
    if(!_copyButton) {
        _copyButton = [[FrtcMultiTypesButton alloc] initThirdWithFrame:CGRectMake(0, 0, 0, 0) withTitle:NSLocalizedString(@"FM_MEETING_INFO_COPY", @"Copy Invitation")];
        _copyButton.target = self;
        _copyButton.action = @selector(onSaveBtnPressed);
        
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_MEETING_INFO_COPY", @"Copy Invitation")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"026FFE" andAlpha:1.0] range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14] range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
        [attrTitle fixAttributesInRange:range];
        [_copyButton setAttributedTitle:attrTitle];
        _copyButton.layer.cornerRadius = 4.0f;
        _copyButton.layer.borderWidth = 1.0;
        _copyButton.layer.masksToBounds = YES;
        _copyButton.layer.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] whiteColor].CGColor;
        _copyButton.layer.borderColor = [NSColor colorWithString:@"026FFE" andAlpha:1.0].CGColor;
        [self.contentView addSubview:_copyButton];
    }
    
    return _copyButton;
}

- (CallResultReminderView *)reminderView {
    if(!_reminderView) {
        _reminderView = [[CallResultReminderView alloc] initWithFrame:CGRectMake(0, 0, 172, 40)];
        _reminderView.tipLabel.stringValue = @"主持人已开启静音";
        _reminderView.hidden = YES;
        
        [self.contentView addSubview:_reminderView];
    }
    
    return _reminderView;
}

@end
