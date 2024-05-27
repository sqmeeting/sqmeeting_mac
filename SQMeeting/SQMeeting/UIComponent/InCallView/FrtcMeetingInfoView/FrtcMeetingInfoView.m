#import "FrtcMeetingInfoView.h"

@implementation FrtcMeetingInfoView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor colorWithString:@"#F8F9FA" andAlpha:1.0].CGColor;
        NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited;
        
        NSRect rect = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height);
        NSTrackingArea *focusTrackingArea = [[NSTrackingArea alloc] initWithRect:rect
                                                                         options:focusTrackingAreaOptions owner:self userInfo:nil];
        [self addTrackingArea:focusTrackingArea];
        [self meetingInfoViewLayout];
    }
    
    return self;
}

- (void)meetingInfoViewLayout {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(16);
        make.width.mas_equalTo(235);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.meetingNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(16);
        make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(10);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.meetingNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.meetingNumberLabel.mas_centerY);
        make.left.mas_equalTo(self.meetingNumberLabel.mas_right).offset(6);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.meetingOwnerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(16);
        make.top.mas_equalTo(self.meetingNumberLabel.mas_bottom).offset(10);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.meetingOwnerTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.meetingOwnerLabel.mas_centerY);
        make.left.mas_equalTo(self.meetingOwnerLabel.mas_right).offset(6);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.meetingPasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(16);
        make.top.mas_equalTo(self.meetingOwnerLabel.mas_bottom).offset(10);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.meetingPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.meetingPasswordLabel.mas_centerY);
        make.left.mas_equalTo(self.meetingPasswordLabel.mas_right).offset(6);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

#pragma mark --HoverImageViewDelegate--
- (void)hoverImageViewClickedwithSenderTag:(NSInteger)tag {
    NSLog(@"hoverImageViewClickedwithSenderTag");
}

- (void)mouseEntered:(NSEvent *)event {
    NSLog(@"-----------mouseEntered:(NSEvent *)event----------");
    if(self.meetingInfoDelegate && [self.meetingInfoDelegate respondsToSelector:@selector(cursorIsInView:)]) {
        [self.meetingInfoDelegate cursorIsInView:YES];
    }
}

- (void)mouseExited:(NSEvent *)event {
    NSLog(@"-----------mouseExited:(NSEvent *)event----------");
    if(self.meetingInfoDelegate && [self.meetingInfoDelegate respondsToSelector:@selector(cursorIsInView:)]) {
        [self.meetingInfoDelegate cursorIsInView:NO];
    }
}

#pragma mark --Lazy Load--
- (NSTextField *)titleTextField {
    if (!_titleTextField) {
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightMedium];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleTextField.maximumNumberOfLines = 1;
        _titleTextField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        
        [self addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (NSTextField *)meetingNumberLabel {
    if(!_meetingNumberLabel) {
        _meetingNumberLabel = [self label];
        _meetingNumberLabel.stringValue = NSLocalizedString(@"FM_MEETING_NUMBER", @"Meeting ID");
        [self addSubview:_meetingNumberLabel];
    }
    
    return _meetingNumberLabel;
}

- (NSTextField *)meetingNumberTextField {
    if(!_meetingNumberTextField) {
        _meetingNumberTextField = [self textField];
        [self addSubview:_meetingNumberTextField];
    }
    
    return _meetingNumberTextField;;
}

- (NSTextField *)meetingOwnerLabel {
    if(!_meetingOwnerLabel) {
        _meetingOwnerLabel = [self label];
        _meetingOwnerLabel.stringValue = NSLocalizedString(@"FM_MEETING_HOST", @"Chairperson");
        [self addSubview:_meetingOwnerLabel];
    }
    
    return _meetingOwnerLabel;
}

- (NSTextField *)meetingOwnerTextField {
    if(!_meetingOwnerTextField) {
        _meetingOwnerTextField = [self textField];
        [self addSubview:_meetingOwnerTextField];
    }
    
    return _meetingOwnerTextField;;
}

- (NSTextField *)meetingPasswordLabel {
    if(!_meetingPasswordLabel) {
        _meetingPasswordLabel = [self label];
        _meetingPasswordLabel.stringValue = NSLocalizedString(@"FM_MEETING_PASSWORD", @"Meeting Password");
        [self addSubview:_meetingPasswordLabel];
    }
    
    return _meetingPasswordLabel;
}

- (NSTextField *)meetingPasswordTextField {
    if(!_meetingPasswordTextField) {
        _meetingPasswordTextField = [self textField];
        [self addSubview:_meetingPasswordTextField];
    }
    
    return _meetingPasswordTextField;;
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

- (NSTextField *)meetingCopyInfoLabel {
    if(!_meetingCopyInfoLabel) {
        _meetingCopyInfoLabel = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _meetingCopyInfoLabel.backgroundColor = [NSColor clearColor];
        _meetingCopyInfoLabel.font = [NSFont systemFontOfSize:12 weight:NSFontWeightRegular];
        _meetingCopyInfoLabel.alignment = NSTextAlignmentLeft;
        _meetingCopyInfoLabel.textColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0];
        _meetingCopyInfoLabel.bordered = NO;
        _meetingCopyInfoLabel.editable = NO;
        _meetingCopyInfoLabel.stringValue = @"复制会议信息";
        [self addSubview:_meetingCopyInfoLabel];
        
    }
    
    return _meetingCopyInfoLabel;;
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
    textField.font = [NSFont systemFontOfSize:12 weight:NSFontWeightMedium];
    textField.alignment = NSTextAlignmentLeft;
    textField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
    textField.bordered = NO;
    textField.editable = NO;
    
    return textField;
}


@end
