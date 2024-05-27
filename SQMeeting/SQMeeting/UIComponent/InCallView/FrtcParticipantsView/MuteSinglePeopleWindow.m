#import "MuteSinglePeopleWindow.h"
#import "FrtcMultiTypesButton.h"

@interface MuteSinglePeopleWindow ()

@property (nonatomic, strong) FrtcMultiTypesButton *muteButton;

@property (nonatomic, strong) FrtcMultiTypesButton *cancelButton;

@property (nonatomic, strong) FrtcMultiTypesButton *changeNameButton;

@property (nonatomic, strong) FrtcMultiTypesButton *setLectureButton;

@property (nonatomic, strong) FrtcMultiTypesButton *setPinButton;

@property (nonatomic, strong) FrtcMultiTypesButton *removeMeetingButton;

@property (nonatomic, getter=isSetSelecter) BOOL setSelecter;

@property (nonatomic, getter=isSetPin) BOOL setPin;


@end

@implementation MuteSinglePeopleWindow

- (instancetype)initWithSize:(NSSize)size withMuteStatus:(BOOL)muteStatus withAuthority:(BOOL)authority withLectureMode:(BOOL)lecture withPin:(BOOL)pin withRow:(NSInteger)row withMe:(BOOL)me {
    self = [super init];
    
    if(self) {
        self.releasedWhenClosed = NO;
        self.styleMask = self.styleMask | NSWindowStyleMaskFullSizeContentView;
        self.titlebarAppearsTransparent = YES;
        
        self.backgroundColor = [NSColor whiteColor];
        
        [self standardWindowButton:NSWindowZoomButton].enabled = NO;
        [self standardWindowButton:NSWindowCloseButton].enabled = NO;
        [self standardWindowButton:NSWindowMiniaturizeButton].enabled = NO;
        
        [[self standardWindowButton:NSWindowZoomButton] setHidden:YES];
        [[self standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
        [[self standardWindowButton:NSWindowCloseButton] setHidden:YES];
        
        self.row = row;
        
        if(lecture) {
            size = NSMakeSize(240, 179);
        }
        
        self.contentMaxSize = size;
        self.contentMinSize = size;
        [self setContentSize:size];
        
        self.mute           = muteStatus;
        self.setSelecter    = lecture;
        self.setPin         = pin;
        
        if(authority) {
            if(self.isSetSelecter) {
                [self singleSelecterWindowWithRow:row];
            } else {
                if(/*row == 0 &&*/ me) {
                    size = NSMakeSize(240, 257);
                    
                    self.contentMaxSize = size;
                    self.contentMinSize = size;
                    [self setContentSize:size];
                }
                [self singlePeopleWindowWithRow:me];
            }
        } else {
            [self normalPeopleWindow];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWindow:) name:FMeetingCallCloseNotification object:nil];
    
    }
    
    return self;
}

- (void)closeWindow:(NSNotification*)notification {
    [self close];
}

#pragma mark --MuteSinglePeopleWindow layout--
- (void)normalPeopleWindow {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(18);
        make.left.mas_equalTo(self.contentView.mas_left).offset(22);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.muteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(14);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    
    [self.changeNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.muteButton.mas_bottom).offset(-1);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.changeNameButton.mas_bottom);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
}

- (void)singlePeopleWindowWithRow:(BOOL)me {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(18);
        make.left.mas_equalTo(self.contentView.mas_left).offset(22);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.muteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(14);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    
    [self.changeNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.muteButton.mas_bottom).offset(-1);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    
    [self.setLectureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.changeNameButton.mas_bottom).offset(-1);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    
    [self.setPinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.setLectureButton.mas_bottom).offset(-1);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    
    
    if(me) {
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.setPinButton.mas_bottom);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(40);
        }];
    } else {
        [self.removeMeetingButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.setPinButton.mas_bottom).offset(-1);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(40);
        }];
        
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.removeMeetingButton.mas_bottom);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(40);
        }];
    }
}

- (void)singleSelecterWindowWithRow:(NSInteger)row {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(18);
        make.left.mas_equalTo(self.contentView.mas_left).offset(22);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.changeNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(14);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    
    [self.setLectureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.changeNameButton.mas_bottom).offset(-1);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    
//    [self.setPinButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.setLectureButton.mas_bottom).offset(-1);
//        make.centerX.mas_equalTo(self.contentView.mas_centerX);
//        make.width.mas_equalTo(200);
//        make.height.mas_equalTo(40);
//    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.setLectureButton.mas_bottom);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark --Button Sender--
- (void)onMute:(FrtcMultiTypesButton *)sender {
    if(self.muteSinglePeopleDelegate && [self.muteSinglePeopleDelegate respondsToSelector:@selector(muteWithUUID:withRow:)]) {
        [self.muteSinglePeopleDelegate muteWithUUID:self.uuid withRow:self.row];
    }
    
    [self orderOut:nil];
}

- (void)onChangeName:(FrtcMultiTypesButton *)sender {
    if(self.muteSinglePeopleDelegate && [self.muteSinglePeopleDelegate respondsToSelector:@selector(changeOldName:)]) {
        [self.muteSinglePeopleDelegate changeOldName:self.row];
    }
    
    [self orderOut:nil];
}

- (void)onSetLecture:(FrtcMultiTypesButton *)sender {
    if(self.isSetSelecter) {
        [self setButtonTitle:sender withTitle:NSLocalizedString(@"FM_SET_LECTURE", @"Set As Lecturer") withColor:@"#026FFE"];
    } else {
        [self setButtonTitle:sender withTitle:NSLocalizedString(@"FM_UN_SET_LECTURE", @"Cancel Lecturer") withColor:@"#026FFE"];
    }
    
    if(self.muteSinglePeopleDelegate && [self.muteSinglePeopleDelegate respondsToSelector:@selector(setSelecture:isSetSelceter:)]) {
        [self.muteSinglePeopleDelegate setSelecture:self.row isSetSelceter:self.isSetSelecter];
    }
    
    self.setSelecter = !self.isSetSelecter;
    
    [self orderOut:nil];
}

- (void)onSetPin:(FrtcMultiTypesButton *)sender {
    if(self.isSetPin) {
        [self setButtonTitle:sender withTitle:NSLocalizedString(@"FM_SET_PIN", @"Pin") withColor:@"#026FFE"];
    } else {
        [self setButtonTitle:sender withTitle:NSLocalizedString(@"FM_UN_SET_PIN", @"Unpin") withColor:@"#026FFE"];
    }
    
    if(self.muteSinglePeopleDelegate && [self.muteSinglePeopleDelegate respondsToSelector:@selector(setPin:isSetPin:)]) {
        [self.muteSinglePeopleDelegate setPin:self.row isSetPin:self.isSetPin];
    }
    
    self.setPin = !self.isSetPin;
    
    [self orderOut:nil];
}

- (void)onRemoveMeetingButton:(FrtcMultiTypesButton *)sender {
    if(self.muteSinglePeopleDelegate && [self.muteSinglePeopleDelegate respondsToSelector:@selector(removeMeetingRoom:)]) {
        [self.muteSinglePeopleDelegate removeMeetingRoom:self.row];
    }
    
    [self orderOut:nil];
}

- (void)onCancel:(FrtcMultiTypesButton *)sender {
    [self orderOut:nil];
}

#pragma mark --Lazy Load--
- (NSTextField *)titleTextField {
    if (!_titleTextField){
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:15 weight:NSFontWeightSemibold];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.stringValue = @"guanghong_mac";
        [self.contentView addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (FrtcMultiTypesButton *)muteButton {
    if(!_muteButton) {
        NSString *buttonTitle;
        if(self.isMute) {
            buttonTitle = NSLocalizedString(@"FM_UN_MUTE", @"Unmute");
        } else {
            buttonTitle = NSLocalizedString(@"FM_MUTE", @"Mute");
        }
        
        _muteButton = [self baseButton:@"#026FFE" withButtonTitle:buttonTitle];
        _muteButton.action = @selector(onMute:);
        [self.contentView addSubview:_muteButton];
    }
    
    return _muteButton;
}

- (FrtcMultiTypesButton *)changeNameButton {
    if(!_changeNameButton) {
        _changeNameButton = [self baseButton:@"#026FFE" withButtonTitle:NSLocalizedString(@"FM_CHANGE_NAME", @"Change Name")];
        _changeNameButton.action = @selector(onChangeName:);
        [self.contentView addSubview:_changeNameButton];
    }
    
    return _changeNameButton;
}

- (FrtcMultiTypesButton *)setLectureButton {
    if(!_setLectureButton) {
        NSString *title;
        if(self.isSetSelecter) {
            title = NSLocalizedString(@"FM_UN_SET_LECTURE", @"Cancel Lecturer");
        } else {
            title = NSLocalizedString(@"FM_SET_LECTURE", @"Set As Lecturer");
        }
        _setLectureButton = [self baseButton:@"#026FFE" withButtonTitle:title];
        _setLectureButton.action = @selector(onSetLecture:);
        [self.contentView addSubview:_setLectureButton];
    }
    
    return _setLectureButton;
}

- (FrtcMultiTypesButton *)setPinButton {
    if(!_setPinButton) {
        NSString *title;
    
        if(self.isSetPin) {
            title = NSLocalizedString(@"FM_UN_SET_PIN", @"Unfix");
        } else {
            title = NSLocalizedString(@"FM_SET_PIN", @"Fix Screen");
        }
        
        _setPinButton = [self baseButton:@"#026FFE" withButtonTitle:title];
        _setPinButton.action = @selector(onSetPin:);
        [self.contentView addSubview:_setPinButton];
    }
    
    return _setPinButton;
}

- (FrtcMultiTypesButton *)removeMeetingButton {
    if(!_removeMeetingButton) {
        _removeMeetingButton = [self baseButton:@"#E32726" withButtonTitle:NSLocalizedString(@"FM_REMOVE_MEETING", @"Remove Meeting")];
        _removeMeetingButton.action = @selector(onRemoveMeetingButton:);
        [self.contentView addSubview:_removeMeetingButton];
    }
    
    return _removeMeetingButton;
}

- (FrtcMultiTypesButton *)baseButton:(NSString *)colorString withButtonTitle:(NSString *)buttonTitle {
    FrtcMultiTypesButton *baseButton = [[FrtcMultiTypesButton alloc] initFifthWithFrame:CGRectMake(0, 0, 48, 22) withTitle:buttonTitle];
    baseButton.hover = NO;
    baseButton.target = self;
    baseButton.layer.cornerRadius = 0;
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:buttonTitle];
    NSUInteger len = [attrTitle length];
    NSRange range = NSMakeRange(0, len);
   // baseButton.layer.borderWidth = 0.5;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:colorString andAlpha:1.0]
                      range:range];
    [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                      range:range];
    
    [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                      range:range];
    [attrTitle fixAttributesInRange:range];
    [baseButton setAttributedTitle:attrTitle];
    baseButton.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
    baseButton.layer.borderColor = [NSColor colorWithString:@"#CCCCCC" andAlpha:1.0].CGColor;
    
    return baseButton;
}



- (FrtcMultiTypesButton *)cancelButton {
    if(!_cancelButton) {
        _cancelButton = [[FrtcMultiTypesButton alloc] initFifthWithFrame:CGRectMake(0, 0, 48, 22) withTitle:NSLocalizedString(@"FM_CANCEL", @"Cancel")];
        _cancelButton.hover = NO;
        _cancelButton.target = self;
        _cancelButton.layer.cornerRadius = 4.0;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_CANCEL", @"Cancel")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#666666" andAlpha:1.0]
                          range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                          range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [_cancelButton setAttributedTitle:attrTitle];
        _cancelButton.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
        _cancelButton.layer.borderColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
        _cancelButton.action = @selector(onCancel:);
        [self.contentView addSubview:_cancelButton];
    }
    
    return _cancelButton;
}

- (void)setButtonTitle:(FrtcMultiTypesButton *)button withTitle:(NSString *)title withColor:(NSString *)colorString {
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:title];
    NSUInteger len = [attrTitle length];
    NSRange range = NSMakeRange(0, len);
  
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:colorString andAlpha:1.0]
                      range:range];
    [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                      range:range];
    
    [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                      range:range];
    [attrTitle fixAttributesInRange:range];
    
    [button setAttributedTitle:attrTitle];
}

@end
