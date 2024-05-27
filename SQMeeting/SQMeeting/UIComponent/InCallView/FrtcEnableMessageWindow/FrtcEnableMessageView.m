#import "FrtcEnableMessageView.h"
#import "FrtcMultiTypesButton.h"
#import "IntegerFormatter.h"

@interface FrtcEnableMessageView () <EnableMessageGroundViewTypeDelegate, MessageButtonDelegate, NSTextFieldDelegate>

@property (nonatomic, strong) NSTextField *meetingDescriptionLabel;

@property (nonatomic, strong) NSTextField *meetingDescriptionTextField;

@property (nonatomic, strong) NSImageView *warningImageView;

@property (nonatomic, strong) NSTextField *warningTextField;

@property (nonatomic, strong) NSTextField *scrollTextField;

@property (nonatomic, strong) NSButton  *scrollButton;

@property (nonatomic, strong) NSTextField *messagePositionTextField;

@property (nonatomic, strong) FrtcMultiTypesButton      *okButton;

@property (nonatomic, strong) FrtcMultiTypesButton      *cancleButton;

@property (nonatomic, strong) NSView        *lineView;

@property (nonatomic, strong) NSView        *secondLineView;

@property (nonatomic, strong) NSTextField   *caculateTextField;

@property (nonatomic, strong) NSTextField   *caculateTextField1;

@property (nonatomic, assign) NSInteger circleTimes;

@property (nonatomic, assign) NSInteger position;

@end

@implementation FrtcEnableMessageView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        self.circleTimes = 3;
        self.position    = 0;
        [self layouEnableMessageView];
    }
    
    return self;
}

#pragma mark --Layout--
- (void)layouEnableMessageView {
    [self.meetingDescriptionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(87);
        make.top.mas_equalTo(16);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(87);
     }];
    
    [self.meetingDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.right.mas_equalTo(self.meetingDescriptionTextField.mas_left).offset(-5);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.warningImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.meetingDescriptionTextField.mas_bottom).offset(8);
        make.left.mas_equalTo(87);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(12);
     }];
    
    [self.warningTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.warningImageView.mas_right).offset(4);
        make.centerY.mas_equalTo(self.warningImageView.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.scrollButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(87);
        make.top.mas_equalTo(self.meetingDescriptionTextField.mas_bottom).offset(25);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(14);
    }];
    
    [self.scrollButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(87);
        make.top.mas_equalTo(self.meetingDescriptionTextField.mas_bottom).offset(25);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(14);
    }];
    
    [self.scrollTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.scrollButton.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.scrollButton.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(87);
        make.top.mas_equalTo(self.scrollButton.mas_bottom).offset(26);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [self.caculateTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.downButton.mas_right).offset(-1);
        make.top.mas_equalTo(self.scrollButton.mas_bottom).offset(26);
        make.width.mas_equalTo(124);
        make.height.mas_equalTo(30);
    }];
    
    [self.upButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.caculateTextField.mas_right);
        make.top.mas_equalTo(self.scrollButton.mas_bottom).offset(26);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [self.caculateTextField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.downButton.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.downButton.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
        
    [self.topBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(87);
        make.top.mas_equalTo(self.downButton.mas_bottom).offset(20);
        make.width.mas_equalTo(88);
        make.height.mas_equalTo(74);
    }];
    
    [self.middleBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topBackgroundView.mas_right).offset(8);
        make.centerY.mas_equalTo(self.topBackgroundView.mas_centerY);
        make.width.mas_equalTo(88);
        make.height.mas_equalTo(74);
    }];
    
    [self.bottomBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.middleBackgroundView.mas_right).offset(8);
        make.centerY.mas_equalTo(self.topBackgroundView.mas_centerY);
        make.width.mas_equalTo(88);
        make.height.mas_equalTo(74);
    }];
    
    [self.messagePositionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.topBackgroundView.mas_left).offset(-5);
        make.top.mas_equalTo(self.scrollTextField.mas_bottom).offset(75);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.top.mas_equalTo(self.topBackgroundView.mas_bottom).offset(16);
        make.width.mas_equalTo(390);
        make.height.mas_equalTo(1);
    }];

    [self.secondLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(196);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(0);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(48);
    }];

    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.secondLineView.mas_left);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(1);
        make.width.mas_equalTo(196);
        make.height.mas_equalTo(48);
    }];

    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.secondLineView.mas_right);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(1);
        make.width.mas_equalTo(196);
        make.height.mas_equalTo(48);
    }];
}

#pragma mark -- NSTextField delegate --
- (void)controlTextDidChange:(NSNotification *)obj {
    if(((NSTextField *)(obj.object)).tag == 201) {
        if([((NSTextField *)(obj.object)).stringValue isEqualToString:@""]) {
            self.okButton.enabled = NO;
            self.warningImageView.hidden = NO;
            self.warningTextField.hidden = NO;
        } else {
            self.okButton.enabled = YES;
            self.warningImageView.hidden = YES;
            self.warningTextField.hidden = YES;
        }
    }
    
    self.circleTimes = [self.caculateTextField.stringValue integerValue];
    
    if(self.circleTimes > 999) {
        self.circleTimes = 999;
    } else if(self.circleTimes < 1) {
        self.circleTimes = 1;
    }
    
    self.caculateTextField.stringValue = [NSString stringWithFormat:@"%ld", _circleTimes];
}

#pragma mark --MessageButtonDelegate--
- (void)messageButtonClicked:(MessageButtonType)type {
    if(type == MessageButtonUp) {
        ++_circleTimes;
    } else {
        --_circleTimes;
        if(_circleTimes < 1) {
            _circleTimes = 1;
        }
    }
    
    self.caculateTextField.stringValue = [NSString stringWithFormat:@"%ld", _circleTimes];
}

#pragma mark --EnableMessageGroundViewTypeDelegate--
- (void)EnableMessageGroundViewClicked:(EnableMessageGroundViewType)type {
    if(type == EnableMessageGroundViewTop) {
        self.position = 0;
        [self.middleBackgroundView messageBackgroundViewSelected:NO];
        [self.bottomBackgroundView messageBackgroundViewSelected:NO];
        [self.topBackgroundView messageBackgroundViewSelected:YES];
    } else if(type == EnableMessageGroundViewMiddle) {
        self.position = 50;
        [self.topBackgroundView messageBackgroundViewSelected:NO];
        [self.bottomBackgroundView messageBackgroundViewSelected:NO];
        [self.middleBackgroundView messageBackgroundViewSelected:YES];
    } else {
        self.position = 100;
        [self.middleBackgroundView messageBackgroundViewSelected:NO];
        [self.topBackgroundView messageBackgroundViewSelected:NO];
        [self.bottomBackgroundView messageBackgroundViewSelected:YES];
    }
}

#pragma mark --Internal Function--
- (void)reMakeLayout {
    self.upButton.hidden = NO;
    self.downButton.hidden = NO;
    self.caculateTextField.hidden = NO;
    self.caculateTextField1.hidden = NO;
        
    [self.topBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(87);
        make.top.mas_equalTo(self.downButton.mas_bottom).offset(20);
        make.width.mas_equalTo(88);
        make.height.mas_equalTo(74);
    }];
    
    [self.messagePositionTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.topBackgroundView.mas_left).offset(-5);
        make.top.mas_equalTo(self.scrollTextField.mas_bottom).offset(75);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

#pragma mark --Button Sender--
- (void)onCheckScrollButton:(NSButton *)sender {
    BOOL enableScroll;
    if(sender.state == NSControlStateValueOn) {
        enableScroll = YES;
        [self reMakeLayout];
    } else {
        enableScroll = NO;
        self.upButton.hidden = YES;
        self.downButton.hidden = YES;
        self.caculateTextField.hidden = YES;
        self.caculateTextField1.hidden = YES;
        
        [self.topBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(87);
            make.top.mas_equalTo(self.scrollButton.mas_bottom).offset(25);
            make.width.mas_equalTo(88);
            make.height.mas_equalTo(74);
        }];
        
        [self.messagePositionTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.topBackgroundView.mas_left).offset(-5);
            make.top.mas_equalTo(self.scrollTextField.mas_bottom).offset(25);
            make.width.mas_greaterThanOrEqualTo(0);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(enableScroll:)]) {
        [self.delegate enableScroll:enableScroll];
    }
}

- (void)onOKPressed:(FrtcMultiTypesButton *)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(startOverlayMessage:withRepeat:withPosition:withScroll:)]) {
        [self.delegate startOverlayMessage:self.meetingDescriptionTextField.stringValue withRepeat:self.circleTimes withPosition:self.position withScroll:self.scrollButton.state == NSControlStateValueOn ? YES : NO];
        
    }
    [self.window orderOut:nil];
}

- (void)onCanclePressed:(FrtcMultiTypesButton *)sender {
    [self.window orderOut:nil];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(cancelMessage)]) {
        [self.delegate cancelMessage];
    }
}

#pragma mark --lazy load--
- (NSTextField *)meetingDescriptionLabel {
    if(!_meetingDescriptionLabel) {
        _meetingDescriptionLabel = [self textField];
        _meetingDescriptionLabel.stringValue = NSLocalizedString(@"FM_MESSAGE_CONTENT", @"Message");
        [self addSubview:_meetingDescriptionLabel];
    }
    
    return _meetingDescriptionLabel;
}

- (NSTextField *)meetingDescriptionTextField {
    if (!_meetingDescriptionTextField){
        _meetingDescriptionTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 332, 36)];
        _meetingDescriptionTextField.editable = YES;
        _meetingDescriptionTextField.bordered = YES;
        _meetingDescriptionTextField.tag = 201;
        _meetingDescriptionTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _meetingDescriptionTextField.alignment = NSTextAlignmentLeft;
        [_meetingDescriptionTextField setFocusRingType:NSFocusRingTypeNone];
        [_meetingDescriptionTextField.cell setFont:[NSFont systemFontOfSize:14]];
        _meetingDescriptionTextField.wantsLayer = YES;
        _meetingDescriptionTextField.layer.backgroundColor = [NSColor whiteColor].CGColor;
        _meetingDescriptionTextField.layer.borderColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
        _meetingDescriptionTextField.layer.borderWidth = 1.0;
        _meetingDescriptionTextField.stringValue = NSLocalizedString(@"FM_MESSAGE_WELCOME", @"Welcome");
        _meetingDescriptionTextField.layer.cornerRadius = 4.0f;
        _meetingDescriptionTextField.maximumNumberOfLines = 0;
        _meetingDescriptionTextField.lineBreakMode = NSLineBreakByCharWrapping;
        _meetingDescriptionTextField.delegate = self;
        _meetingDescriptionTextField.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
        [self addSubview:_meetingDescriptionTextField];
    }
    
    return _meetingDescriptionTextField;
}

- (NSImageView *)warningImageView {
    if(!_warningImageView) {
        _warningImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        [_warningImageView setImage:[NSImage imageNamed:@"icon_reminder"]];
        _warningImageView.hidden = YES;
        [self addSubview:_warningImageView];
    }
    
    return _warningImageView;
}

- (NSTextField *)warningTextField {
    if(!_warningTextField) {
        _warningTextField = [self textField];
        _warningTextField.backgroundColor = [NSColor clearColor];
        _warningTextField.font = [NSFont systemFontOfSize:12 weight:NSFontWeightRegular];
        _warningTextField.alignment = NSTextAlignmentLeft;
        _warningTextField.textColor = [NSColor colorWithString:@"#999999" andAlpha:1.0];
        _warningTextField.bordered = NO;
        _warningTextField.editable = NO;
        _warningTextField.hidden = YES;
        _warningTextField.stringValue = NSLocalizedString(@"FM_MESSAGE_WARNING", @"Message cannot be empty");
        [self addSubview:_warningTextField];
    }
    
    return _warningTextField;
}

- (NSTextField *)scrollTextField {
    if(!_scrollTextField) {
        _scrollTextField = [self textField];
        _scrollTextField.stringValue = NSLocalizedString(@"FM_MESSAGE_SCROLL", @"Roll");
        [self addSubview:_scrollTextField];
    }
    
    return _scrollTextField;
}

- (NSButton *)scrollButton {
    if (!_scrollButton) {
        _scrollButton = [self checkButton:@"" aciton:@selector(onCheckScrollButton:)];
        [_scrollButton setState:NSControlStateValueOn];
        
        [self addSubview:_scrollButton];
    }
    
    return _scrollButton;
}

- (NSTextField *)messagePositionTextField {
    if(!_messagePositionTextField) {
        _messagePositionTextField = [self textField];
        _messagePositionTextField.stringValue = NSLocalizedString(@"FM_MESSAGE_LOCATION", @"Position");
        [self addSubview:_messagePositionTextField];
    }
    
    return _messagePositionTextField;
}

- (FrtcEnableMessageBackgroundView *)topBackgroundView {
    if(!_topBackgroundView) {
        _topBackgroundView = [[FrtcEnableMessageBackgroundView alloc] initWithFrame:CGRectMake(0, 0, 104, 92)];
        _topBackgroundView.type = EnableMessageGroundViewTop;
        [_topBackgroundView messageBackgroundViewSelected:YES];
        _topBackgroundView.delegate = self;
        _topBackgroundView.imageView.image = [NSImage imageNamed:@"icon_message_top"];
        _topBackgroundView.titleTextField.stringValue = NSLocalizedString(@"FM_MESSAGE_TOP", @"Top");
        [self addSubview:_topBackgroundView];
    }
    
    return _topBackgroundView;
}

- (FrtcEnableMessageBackgroundView *)middleBackgroundView {
    if(!_middleBackgroundView) {
        _middleBackgroundView = [[FrtcEnableMessageBackgroundView alloc] initWithFrame:CGRectMake(0, 0, 104, 92)];
        _middleBackgroundView.type = EnableMessageGroundViewMiddle;
        _middleBackgroundView.delegate = self;
        _middleBackgroundView.imageView.image = [NSImage imageNamed:@"icon_message_middle"];
        _middleBackgroundView.titleTextField.stringValue = NSLocalizedString(@"FM_MESSAGE_MIDDLE", @"Middle View");
        [self addSubview:_middleBackgroundView];
    }
    
    return _middleBackgroundView;
}

- (FrtcEnableMessageBackgroundView *)bottomBackgroundView {
    if(!_bottomBackgroundView) {
        _bottomBackgroundView = [[FrtcEnableMessageBackgroundView alloc] initWithFrame:CGRectMake(0, 0, 104, 92)];
        _bottomBackgroundView.type = EnableMessageGroundViewBottom;
        _bottomBackgroundView.delegate = self;
        _bottomBackgroundView.imageView.image = [NSImage imageNamed:@"icon_message_bottom"];
        _bottomBackgroundView.titleTextField.stringValue = NSLocalizedString(@"FM_MESSAGE_BOTTOM", @"Bottom View");
        [self addSubview:_bottomBackgroundView];
    }
    
    return _bottomBackgroundView;
}

- (NSView *)lineView {
    if(!_lineView) {
        _lineView = [[NSView alloc] initWithFrame:CGRectMake(0, 108, 281, 1)];
        _lineView.wantsLayer = YES;
        _lineView.layer.backgroundColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
        [self addSubview:_lineView];
    }
    
    return _lineView;
}

- (NSView *)secondLineView {
    if(!_secondLineView) {
        _secondLineView = [[NSView alloc] initWithFrame:CGRectMake(140, 109, 1, 48)];
        _secondLineView.wantsLayer = YES;
        _secondLineView.layer.backgroundColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
        [self addSubview:_secondLineView];
    }
    
    return _secondLineView;
}


- (FrtcMultiTypesButton *)okButton {
    if(!_okButton) {
        _okButton = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 141, 48) withTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK")];
        _okButton.hover = NO;
        _okButton.target = self;
        _okButton.layer.maskedCorners = NO;
        _okButton.bordered = NO;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_BUTTON_OK", @"OK")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"026FFE" andAlpha:1.0]
                          range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                          range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [_okButton setAttributedTitle:attrTitle];
        _okButton.layer.backgroundColor = [NSColor whiteColor].CGColor;
        _okButton.layer.borderColor = [NSColor colorWithString:@"#B6B6B6" andAlpha:1.0].CGColor;
        _okButton.action = @selector(onOKPressed:);
        [self addSubview:_okButton];
    }
    
    return _okButton;
}

- (FrtcMultiTypesButton *)cancleButton {
    if(!_cancleButton) {
        _cancleButton = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 141, 48) withTitle:NSLocalizedString(@"FM_CANCEL", @"Cancel")];
        _cancleButton.hover = NO;
        _cancleButton.target = self;
        //_cancleButton.layer.cornerRadius = 0.0;
        _cancleButton.layer.maskedCorners = NO;
        _cancleButton.bordered = NO;
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
        [_cancleButton setAttributedTitle:attrTitle];
        _cancleButton.layer.backgroundColor = [NSColor whiteColor].CGColor;
        _cancleButton.action = @selector(onCanclePressed:);
        _cancleButton.layer.borderColor = [NSColor colorWithString:@"#B6B6B6" andAlpha:1.0].CGColor;
        [self addSubview:_cancleButton];
    }
    
    return _cancleButton;
}

- (NSTextField *)caculateTextField1 {
    if(!_caculateTextField1) {
        _caculateTextField1 = [self textField];
        _caculateTextField1.stringValue = NSLocalizedString(@"FM_MESSAGE_TIMES", @"Playback times");
        [self addSubview:_caculateTextField1];
    }
    
    return _caculateTextField1;
}

- (MessageButton *)downButton {
    if(!_downButton) {
        _downButton = [[MessageButton alloc] initWithFrame:NSMakeRect(0, 0, 30, 30)];
        _downButton.buttonType = MessageButtonDown;
        _downButton.delegate = self;
        [_downButton.imageView setImage:[NSImage imageNamed:@"icon_message_down"]];
        [self addSubview:_downButton];
    }
    
    return _downButton;
}

- (NSTextField *)caculateTextField {
    if (!_caculateTextField){
        _caculateTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 332, 36)];
        _caculateTextField.editable = YES;
        _caculateTextField.bordered = YES;
        _caculateTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _caculateTextField.alignment = NSTextAlignmentCenter;
        [_caculateTextField setFocusRingType:NSFocusRingTypeNone];
        [_caculateTextField.cell setFont:[NSFont systemFontOfSize:14]];
        IntegerFormatter *formatter = [[IntegerFormatter alloc] init];
        [_caculateTextField setFormatter:formatter];
        _caculateTextField.delegate = self;
        _caculateTextField.wantsLayer = YES;
        _caculateTextField.layer.backgroundColor = [NSColor whiteColor].CGColor;
        _caculateTextField.layer.borderColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
        _caculateTextField.layer.borderWidth = 1.0;
        _caculateTextField.stringValue = @"3";
        _caculateTextField.maximumNumberOfLines = 1;
        _caculateTextField.tag = 202;
       // _caculateTextField.lineBreakMode = NSLineBreakByCharWrapping;
        _caculateTextField.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
        [self addSubview:_caculateTextField];
    }
    
    return _caculateTextField;
}

- (MessageButton *)upButton {
    if(!_upButton) {
        _upButton = [[MessageButton alloc] initWithFrame:NSMakeRect(0, 0, 30, 30)];
        _upButton.buttonType = MessageButtonUp;
        _upButton.delegate = self;
        [_upButton.imageView setImage:[NSImage imageNamed:@"icon_message_up"]];
        [self addSubview:_upButton];
    }
    
    return _upButton;
}

#pragma mark --Internal Function--
- (NSTextField *)textField {
    NSTextField *internalTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    internalTextField.backgroundColor = [NSColor clearColor];
    internalTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightMedium];
    internalTextField.alignment = NSTextAlignmentCenter;
    internalTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
    internalTextField.bordered = NO;
    internalTextField.editable = NO;
 
    return internalTextField;
}

#pragma mark -- internal function --
- (NSButton *)checkButton:(NSString *)buttonTile aciton:(SEL)action {
    int btnWidth = 14;
    int btnHeight = 14;
    NSButton *checkButton = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, btnWidth, btnHeight)];
    [checkButton setButtonType:NSButtonTypeSwitch];
    [checkButton setNeedsDisplay:YES];
    
    checkButton.target = self;
    checkButton.action = action;
    [self addSubview:checkButton];
    
    return checkButton;
}

@end
