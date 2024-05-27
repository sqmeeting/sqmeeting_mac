#import "FrtcVideoStreamingUrlWindow.h"
#import "FrtcVideoStreamingUrlView.h"
#import "FrtcMultiTypesButton.h"
#import "CallResultReminderView.h"

@interface FrtcVideoStreamingUrlWindow ()

@property (nonatomic, strong) NSTextField *titleTextField;

@property (nonatomic, strong) FrtcVideoStreamingUrlView *infoView;

@property (nonatomic, strong) FrtcMultiTypesButton      *okButton;

@property (nonatomic, strong) FrtcMultiTypesButton      *cancelButton;

@property (nonatomic, strong) CallResultReminderView *reminderView;

@property (nonatomic, strong) NSTimer *reminderTipsTimer;

@end


@implementation FrtcVideoStreamingUrlWindow

- (instancetype)initWithSize:(NSSize)size {
    self = [super init];
    
    if(self) {
        self.releasedWhenClosed = NO;
        self.styleMask = self.styleMask | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskClosable;
        self.titlebarAppearsTransparent = YES;
        
        self.backgroundColor = [NSColor colorWithString:@"#F8F9FA" andAlpha:1.0];
        
        [self standardWindowButton:NSWindowZoomButton].enabled = NO;
        [self standardWindowButton:NSWindowCloseButton].enabled = YES;
        [self standardWindowButton:NSWindowMiniaturizeButton].enabled = NO;
        
        [[self standardWindowButton:NSWindowZoomButton] setHidden:YES];
        [[self standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
        [[self standardWindowButton:NSWindowCloseButton] setHidden:NO];
        
        self.contentMaxSize = size;
        self.contentMinSize = size;
        [self setContentSize:size];
        
        [self detailUrlWindowLayout];
    }
    
    return self;
}

#pragma mark --Detail Info Window Layout
- (void)detailUrlWindowLayout {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(9);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(40);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(316);
        make.height.mas_equalTo(172);
    }];
    
//    NSFont *font             = [NSFont systemFontOfSize:14.0f];
//    NSDictionary *attributes = @{ NSFontAttributeName:font };
//    CGSize size              = [NSLocalizedString(@"FM_MEETING_INFO_COPY", @"Copy Invitation") sizeWithAttributes:attributes];
//
//    [self.copyButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.infoView.mas_bottom).offset(10);
//        make.centerX.mas_equalTo(self.contentView.mas_centerX);
//        make.width.mas_equalTo(size.width + 10);
//        make.height.mas_equalTo(size.height + 10);
//    }];
    
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-16);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-16);
        make.width.mas_equalTo(154);
        make.height.mas_equalTo(32);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(16);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-16);
        make.width.mas_equalTo(154);
        make.height.mas_equalTo(32);
    }];
}

- (void)setupStreamingUrlInfo:(FrtcMeetingStreamingModel *)model {
    self.streamingUrlModel = model;
    
    self.infoView.titleTextField.stringValue = [NSString stringWithFormat:NSLocalizedString(@"FM_VIDEO_STREAMING_SHARE_URL_INVITE", @"%@ invites you to a\"%@\"live streaming."), model.clientName, model.conferenceName];
    if(model.streamingUrl == nil) {
        model.streamingUrl = @"";
    }
    self.infoView.meetingUrlTextField.stringValue = model.streamingUrl;
    self.infoView.urlTextField.hyperlink = model.streamingUrl;
    self.infoView.urlTextField.stringValue = model.streamingUrl;
    
    if(model.streamingPassword == nil || [model.streamingPassword isEqualToString:@""]) {
        self.infoView.streamingPasswordTips.hidden = YES;
        self.infoView.streamingPasswordDescription.hidden = YES;
    } else {
        self.infoView.streamingPasswordTips.hidden = NO;
        self.infoView.streamingPasswordDescription.hidden = NO;

        self.infoView.streamingPasswordDescription.stringValue = model.streamingPassword;
    }
}

#pragma mark --Button Sender--
- (void)onOKBtnPressed {
    NSPasteboard *pastboard = [NSPasteboard generalPasteboard];
    [pastboard clearContents];
    
    NSString *pastString;
    
    pastString = [NSString stringWithFormat:@"%@\n%@\n\n%@",
                        self.infoView.titleTextField.stringValue,
                        self.infoView.meetingUrlTextFieldTips.stringValue,
                        self.infoView.meetingUrlTextField.stringValue];
    
    if(!self.infoView.streamingPasswordTips.hidden) {
        NSString *passwordString = [NSString stringWithFormat:@"%@%@",self.infoView.streamingPasswordTips.stringValue,
        self.infoView.streamingPasswordDescription.stringValue];
        
        pastString =  [NSString stringWithFormat:@"%@\n\n%@", pastString, passwordString];
    }
    
    [pastboard setString:pastString forType:NSPasteboardTypeString];
    
    [self showReminderView];
}

- (void)onCancelBtnPressed {
    [self close];
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

- (void)showReminderView {
    NSString *reminderValue = NSLocalizedString(@"FM_VIDEO_STREAMING_SHARE_URL_REMINDER", @"Live info copied to the clipboard");
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

#pragma mark --Lazy Load--

- (NSTextField *)titleTextField {
    if(!_titleTextField) {
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightMedium];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _titleTextField.stringValue = NSLocalizedString(@"FM_VIDEO_STREAMING_SHARE_URL_TITLE", @"Share Live Streaming");
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        [self.contentView addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (FrtcVideoStreamingUrlView *)infoView {
    if(!_infoView) {
        _infoView = [[FrtcVideoStreamingUrlView alloc] initWithFrame:NSMakeRect(0, 0, 316, 145)];
        [self.contentView addSubview:_infoView];
    }
    
    return _infoView;
}

- (FrtcMultiTypesButton *)okButton {
    if (!_okButton) {
        _okButton = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 158, 36) withTitle:NSLocalizedString(@"FM_VIDEO_STREAMING_SHARE_URL_BUTTON", @"Copy live info")];
        _okButton.target = self;
        _okButton.layer.cornerRadius = 4.0;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_VIDEO_STREAMING_SHARE_URL_BUTTON", @"Copy live info")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[[FrtcBaseImplement baseImpleSingleton] whiteColor]
                          range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                          range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [_okButton setAttributedTitle:attrTitle];
        _okButton.action = @selector(onOKBtnPressed);
        [self.contentView addSubview:_okButton];
    }
    
    return _okButton;
}

- (FrtcMultiTypesButton*)cancelButton {
    if (!_cancelButton){
        _cancelButton = [[FrtcMultiTypesButton alloc] initSecondaryWithFrame:CGRectMake(0, 0, 158, 36) withTitle:NSLocalizedString(@"FM_CANCEL", @"Cancel")];
        _cancelButton.target = self;
        _cancelButton.hover = NO;
        _cancelButton.layer.cornerRadius = 4.0;
        _cancelButton.bordered = NO;
        _cancelButton.layer.borderWidth = 0.0;
        _cancelButton.layer.backgroundColor = [NSColor colorWithRed:240/255.0 green:240/255.0 blue:245/255.0 alpha:1.0].CGColor;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_CANCEL", @"Cancel")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]
                          range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                          range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [_cancelButton setAttributedTitle:attrTitle];
        _cancelButton.action = @selector(onCancelBtnPressed);
        [self.contentView addSubview:_cancelButton];
    }
    return _cancelButton;
}

- (CallResultReminderView *)reminderView {
    if(!_reminderView) {
        _reminderView = [[CallResultReminderView alloc] initWithFrame:CGRectMake(0, 0, 172, 40)];
        _reminderView.tipLabel.stringValue = NSLocalizedString(@"FM_VIDEO_STREAMING_SHARE_URL_REMINDER", @"Live info copied to the clipboard");
        _reminderView.hidden = YES;
        
        [self.contentView addSubview:_reminderView];
    }
    
    return _reminderView;
}


@end
