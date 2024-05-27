#import "FrtcScheduleMeetingTableViewCell.h"

@implementation FrtcScheduleMeetingTableViewCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)init {
    if(self = [super init]) {
        [self configHistoryCallCellLayout];
    }
    return self;
}

- (void)configHistoryCallCellLayout {
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(356);
        make.height.mas_equalTo(80);
    }];
    
    [self.numberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backgroundView.mas_left).offset(12);
        make.top.mas_equalTo(self.backgroundView.mas_top).offset(6);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.numberTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.numberLabel.mas_right).offset(-2);
        make.top.mas_equalTo(self.backgroundView.mas_top).offset(6);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    NSFont *font             = [NSFont systemFontOfSize:10.0f];
    NSDictionary *attributes1 = @{ NSFontAttributeName:font };
    CGSize size              = [NSLocalizedString(@"FM_MEETING_RECURRENCE_RECURRENT_TAG", @"Recurrence") sizeWithAttributes:attributes1];
    
    if(self.arrowImageView.isHidden) {
        [self.recurrenceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.numberTextField.mas_right).offset(2);
            make.centerY.mas_equalTo(self.numberTextField.mas_centerY);
            make.width.mas_equalTo(size.width + 10);
            make.height.mas_equalTo(16);
        }];
    } else {
        [self.recurrenceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.arrowImageView.mas_right).offset(2);
            make.centerY.mas_equalTo(self.numberTextField.mas_centerY);
            make.width.mas_equalTo(size.width + 10);
            make.height.mas_equalTo(16);
        }];
    }
            
    [self.meetingNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backgroundView.mas_left).offset(12);
        make.top.mas_equalTo(self.numberTextField.mas_bottom).offset(8);
        //make.width.mas_equalTo(270);
        make.width.mas_lessThanOrEqualTo(270);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.timeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backgroundView.mas_left).offset(12);
        make.top.mas_equalTo(self.meetingNameTextField.mas_bottom).offset(8);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
        
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.mas_equalTo(self.meetingNameTextField.mas_right).offset(10);
        make.left.mas_equalTo(self.numberTextField.mas_right).offset(2);
        make.centerY.mas_equalTo(self.numberTextField.mas_centerY);
        make.width.mas_equalTo(41);
        make.height.mas_equalTo(16);
    }];

    [self.reminderBeginMeetingTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.meetingNameTextField.mas_right).offset(10);
        make.centerY.mas_equalTo(self.meetingNameTextField.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.reminderNowMeetingTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.meetingNameTextField.mas_right).offset(10);
        make.centerY.mas_equalTo(self.meetingNameTextField.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.joinMeetingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.backgroundView.mas_right).offset(-12);
        make.top.mas_equalTo(self.backgroundView.mas_top).offset(14);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(22);
    }];
    
    [self.reminderBeginMeetingTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.joinMeetingButton.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.meetingNameTextField.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.reminderNowMeetingTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.joinMeetingButton.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.meetingNameTextField.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.overTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.backgroundView.mas_right).offset(-12);
        make.top.mas_equalTo(self.backgroundView.mas_top).offset(14);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(22);
    }];
    
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.backgroundView.mas_right).offset(-12);
        make.top.mas_equalTo(self.joinMeetingButton.mas_bottom).offset(8);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(22);
    }];
    
    [self.moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.settingButton.mas_centerX);
        make.centerY.mas_equalTo(self.settingButton.mas_centerY);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.mas_centerX);
//        make.top.mas_equalTo(self.mas_top).offset(88);
//        make.width.mas_equalTo(332);
//        make.height.mas_equalTo(1);
//    }];
}

- (void)remakeUpdateLayout {
    [self.meetingNameTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backgroundView.mas_left).offset(12);
        make.top.mas_equalTo(self.numberTextField.mas_bottom).offset(8);
        make.width.mas_lessThanOrEqualTo(270);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.meetingNameTextField.mas_right).offset(10);
//        make.centerY.mas_equalTo(self.meetingNameTextField.mas_centerY);
        make.left.mas_equalTo(self.numberTextField.mas_right).offset(2);
        make.centerY.mas_equalTo(self.numberTextField.mas_centerY);
        make.width.mas_equalTo(41);
        make.height.mas_equalTo(16);
    }];
    
    [self.reminderBeginMeetingTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.joinMeetingButton.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.meetingNameTextField.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.reminderNowMeetingTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.joinMeetingButton.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.meetingNameTextField.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.joinMeetingButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.backgroundView.mas_right).offset(-12);
        make.top.mas_equalTo(self.backgroundView.mas_top).offset(14);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(22);
    }];
    
    [self.reminderBeginMeetingTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.joinMeetingButton.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.meetingNameTextField.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.reminderNowMeetingTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.joinMeetingButton.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.meetingNameTextField.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.overTimeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.backgroundView.mas_right).offset(-12);
        make.top.mas_equalTo(self.backgroundView.mas_top).offset(14);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(22);
    }];
    
    [self.settingButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.backgroundView.mas_right).offset(-12);
        make.top.mas_equalTo(self.joinMeetingButton.mas_bottom).offset(8);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(22);
    }];
    
    [self.moreImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.settingButton.mas_centerX);
        make.centerY.mas_equalTo(self.settingButton.mas_centerY);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    _joinMeetingButton.hidden = NO;
    _settingButton.hidden     = NO;
    _moreImageView.hidden     = NO;
    _overTimeButton.hidden    = YES;
    _reminderNowMeetingTextField.hidden = YES;
    _reminderBeginMeetingTextField.hidden = YES;
    
}

- (void)updateLayout {
    if(!self.reminderNowMeetingTextField.hidden && !self.arrowImageView.hidden) {
        [self.meetingNameTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.backgroundView.mas_left).offset(12);
            make.top.mas_equalTo(self.numberTextField.mas_bottom).offset(8);
            make.width.mas_lessThanOrEqualTo(150);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
        
        [self.arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.meetingNameTextField.mas_right).offset(10);
//            make.centerY.mas_equalTo(self.meetingNameTextField.mas_centerY);
            make.left.mas_equalTo(self.numberTextField.mas_right).offset(2);
            make.centerY.mas_equalTo(self.numberTextField.mas_centerY);
            make.width.mas_equalTo(41);
            make.height.mas_equalTo(16);
        }];
        
       
        
        [self.reminderNowMeetingTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.joinMeetingButton.mas_left).offset(-10);
            make.centerY.mas_equalTo(self.meetingNameTextField.mas_centerY);
            make.width.mas_greaterThanOrEqualTo(0);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
        
        NSLog(@"%@", self.reminderNowMeetingTextField.stringValue);
        NSLog(@"%@", self.meetingNameTextField.stringValue);
        
        self.settingButton.hidden = YES;
        self.moreImageView.hidden = YES;
        
        [self.joinMeetingButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.backgroundView.mas_right).offset(-12);
            make.centerY.mas_equalTo(self.backgroundView.mas_centerY);
            make.width.mas_equalTo(48);
            make.height.mas_equalTo(22);
        }];
    } else if(!self.reminderNowMeetingTextField.hidden && self.arrowImageView.hidden) {
        [self.meetingNameTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.backgroundView.mas_left).offset(12);
            make.top.mas_equalTo(self.numberTextField.mas_bottom).offset(8);
            make.width.mas_lessThanOrEqualTo(220);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
        
       
        
        [self.reminderNowMeetingTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.joinMeetingButton.mas_left).offset(-10);
            make.centerY.mas_equalTo(self.backgroundView.mas_centerY);
            make.width.mas_greaterThanOrEqualTo(0);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
        
        self.settingButton.hidden = NO;
        self.moreImageView.hidden = NO;
        
        [self.joinMeetingButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.backgroundView.mas_right).offset(-12);
            make.top.mas_equalTo(self.backgroundView.mas_top).offset(14);
            make.width.mas_equalTo(48);
            make.height.mas_equalTo(22);
        }];
        NSLog(@"%@", self.reminderNowMeetingTextField.stringValue);
        NSLog(@"%@", self.meetingNameTextField.stringValue);
        
    } else if(self.reminderNowMeetingTextField.hidden && !self.arrowImageView.hidden) {
        [self.meetingNameTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.backgroundView.mas_left).offset(12);
            make.top.mas_equalTo(self.numberTextField.mas_bottom).offset(8);
            make.width.mas_lessThanOrEqualTo(220);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
        
        [self.arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.meetingNameTextField.mas_right).offset(10);
//            make.centerY.mas_equalTo(self.backgroundView.mas_centerY);
            make.left.mas_equalTo(self.numberTextField.mas_right).offset(2);
            make.centerY.mas_equalTo(self.numberTextField.mas_centerY);
            make.width.mas_equalTo(41);
            make.height.mas_equalTo(16);
        }];
        
        self.settingButton.hidden = YES;
        self.moreImageView.hidden = YES;
        
        [self.joinMeetingButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.backgroundView.mas_right).offset(-12);
            make.centerY.mas_equalTo(self.backgroundView.mas_centerY);
            make.width.mas_equalTo(48);
            make.height.mas_equalTo(22);
        }];
    }
    
    if(!self.reminderBeginMeetingTextField.hidden && !self.arrowImageView.hidden) {
        [self.meetingNameTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.backgroundView.mas_left).offset(12);
            make.top.mas_equalTo(self.numberTextField.mas_bottom).offset(8);
            make.width.mas_lessThanOrEqualTo(150);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
        
        [self.arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.meetingNameTextField.mas_right).offset(10);
//            make.centerY.mas_equalTo(self.meetingNameTextField.mas_centerY);
            make.left.mas_equalTo(self.numberTextField.mas_right).offset(2);
            make.centerY.mas_equalTo(self.numberTextField.mas_centerY);
            make.width.mas_equalTo(41);
            make.height.mas_equalTo(16);
        }];
        
        [self.reminderBeginMeetingTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.joinMeetingButton.mas_left).offset(-10);
            make.centerY.mas_equalTo(self.meetingNameTextField.mas_centerY);
            make.width.mas_greaterThanOrEqualTo(0);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
        
        self.settingButton.hidden = YES;
        self.moreImageView.hidden = YES;
        
        [self.joinMeetingButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.backgroundView.mas_right).offset(-12);
            make.centerY.mas_equalTo(self.backgroundView.mas_centerY);
            make.width.mas_equalTo(48);
            make.height.mas_equalTo(22);
        }];
        
        [self.reminderBeginMeetingTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.joinMeetingButton.mas_left).offset(-10);
            make.centerY.mas_equalTo(self.meetingNameTextField.mas_centerY);
            make.width.mas_greaterThanOrEqualTo(0);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
    } else if(!self.reminderBeginMeetingTextField.hidden && self.arrowImageView.hidden) {
        [self.meetingNameTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.backgroundView.mas_left).offset(12);
            make.top.mas_equalTo(self.numberTextField.mas_bottom).offset(8);
            make.width.mas_lessThanOrEqualTo(220);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
        
        self.settingButton.hidden = NO;
        self.moreImageView.hidden = NO;
        
        [self.joinMeetingButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.backgroundView.mas_right).offset(-12);
            make.top.mas_equalTo(self.backgroundView.mas_top).offset(14);
            make.width.mas_equalTo(48);
            make.height.mas_equalTo(22);
        }];
        
        [self.meetingNameTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.backgroundView.mas_left).offset(12);
            make.top.mas_equalTo(self.numberTextField.mas_bottom).offset(8);
            make.width.mas_lessThanOrEqualTo(220);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
    } else if(self.reminderBeginMeetingTextField.hidden && !self.arrowImageView.hidden) {
        CGFloat width;
        if(self.reminderNowMeetingTextField.isHidden) {
            width = 220;
        } else {
            width = 150;
        }
        
        [self.meetingNameTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.backgroundView.mas_left).offset(12);
            make.top.mas_equalTo(self.numberTextField.mas_bottom).offset(8);
            make.width.mas_lessThanOrEqualTo(width);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
        
        [self.arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.meetingNameTextField.mas_right).offset(10);
//            make.centerY.mas_equalTo(self.backgroundView.mas_centerY);
            make.left.mas_equalTo(self.numberTextField.mas_right).offset(2);
            make.centerY.mas_equalTo(self.numberTextField.mas_centerY);
            make.width.mas_equalTo(41);
            make.height.mas_equalTo(16);
        }];
        
        self.settingButton.hidden = YES;
        self.moreImageView.hidden = YES;
        
        [self.joinMeetingButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.backgroundView.mas_right).offset(-12);
            make.centerY.mas_equalTo(self.backgroundView.mas_centerY);
            make.width.mas_equalTo(48);
            make.height.mas_equalTo(22);
        }];
    }
    
    if(self.arrowImageView.isHidden) {
        NSFont *font             = [NSFont systemFontOfSize:10.0f];
        NSDictionary *attributes1 = @{ NSFontAttributeName:font };
        CGSize size              = [NSLocalizedString(@"FM_MEETING_RECURRENCE_RECURRENT_TAG", @"Recurrence") sizeWithAttributes:attributes1];
        
        [self.recurrenceView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.numberTextField.mas_right).offset(2);
            make.centerY.mas_equalTo(self.numberTextField.mas_centerY);
            make.width.mas_equalTo(size.width + 10);
            make.height.mas_equalTo(16);
        }];
    } else {
        NSFont *font             = [NSFont systemFontOfSize:10.0f];
        NSDictionary *attributes1 = @{ NSFontAttributeName:font };
        CGSize size              = [NSLocalizedString(@"FM_MEETING_RECURRENCE_RECURRENT_TAG", @"Recurrence") sizeWithAttributes:attributes1];
        
        [self.recurrenceView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.arrowImageView.mas_right).offset(2);
            make.centerY.mas_equalTo(self.numberTextField.mas_centerY);
            make.width.mas_equalTo(size.width + 10);
            make.height.mas_equalTo(16);
        }];
    }
}

- (NSString *)currentLanguageDes {
    NSString *language = [FMLanguageConfig userLanguage] ? : [NSLocale preferredLanguages].firstObject;
    
    if ([language hasPrefix:@"en"]) {
        return @"English";
    } else if ([language hasPrefix:@"zh-Hans"]) {
        return @"简体中文";
    } else if ([language hasPrefix:@"zh-HK"] || [language hasPrefix:@"zh-Hant"]) {
        return @"繁體中文";
    }
    
    return @"";
}

#pragma mark --HoverImageViewDelegate--
- (void)hoverImageViewClickedwithSenderTag:(NSInteger)tag {
    if(self.controllerDelegate && [self.controllerDelegate respondsToSelector:@selector(popUpFunctionControllerWithFrame:withRow:)]) {
        [self.controllerDelegate popUpFunctionControllerWithFrame:self.settingButton.frame withRow:self.row];
    }
}
#pragma mark --Button Sender--
- (void)onJoinVideoMeetingPressed:(FrtcMultiTypesButton *)sender {
    sender.enabled = NO;
    if(self.controllerDelegate && [self.controllerDelegate respondsToSelector:@selector(joinTheConferenceWithRow:)]) {
        [self.controllerDelegate joinTheConferenceWithRow:self.row];
    }
}

#pragma mark --Lazy getter--
- (FrtcBackGroundView *)backgroundView {
    if(!_backgroundView) {
        _backgroundView = [[FrtcBackGroundView alloc] initWithFrame:NSMakeRect(0, 0, 356, 80)];
        _backgroundView.wantsLayer = YES;
        _backgroundView.layer.masksToBounds = YES;
        _backgroundView.layer.cornerRadius = 8.0;
        [self addSubview:_backgroundView];
    }
    
    return _backgroundView;;
}

- (NSTextField *)numberLabel {
    if (!_numberLabel){
        _numberLabel = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _numberLabel.backgroundColor = [NSColor clearColor];
        _numberLabel.font = [NSFont systemFontOfSize:12 weight:NSFontWeightMedium];
        _numberLabel.alignment = NSTextAlignmentLeft;
        _numberLabel.textColor = [NSColor colorWithString:@"#999999" andAlpha:1.0];
        _numberLabel.editable = NO;
        _numberLabel.bordered = NO;
        _numberLabel.wantsLayer = NO;
        _numberLabel.stringValue = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"FM_MEETING_NUMBER", @"Meeting ID")];
        [self.backgroundView addSubview:_numberLabel];
    }
    
    return _numberLabel;
}

- (NSTextField *)numberTextField {
    if (!_numberTextField){
        _numberTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _numberTextField.backgroundColor = [NSColor clearColor];
        _numberTextField.font = [NSFont systemFontOfSize:12 weight:NSFontWeightMedium];
        _numberTextField.alignment = NSTextAlignmentRight;
        _numberTextField.textColor = [NSColor colorWithString:@"#999999" andAlpha:1.0];
        _numberTextField.editable = NO;
        _numberTextField.bordered = NO;
        _numberTextField.wantsLayer = NO;
        [self.backgroundView addSubview:_numberTextField];
    }
    
    return _numberTextField;//reminderBeginMeetingTextField
}

- (NSTextField *)reminderBeginMeetingTextField {
    if (!_reminderBeginMeetingTextField) {
        _reminderBeginMeetingTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _reminderBeginMeetingTextField.backgroundColor = [NSColor clearColor];
        _reminderBeginMeetingTextField.font = [NSFont systemFontOfSize:12 weight:NSFontWeightRegular];
        _reminderBeginMeetingTextField.alignment = NSTextAlignmentRight;
        _reminderBeginMeetingTextField.textColor = [NSColor colorWithString:@"#FF7218" andAlpha:1.0];
        _reminderBeginMeetingTextField.editable = NO;
        _reminderBeginMeetingTextField.bordered = NO;
        _reminderBeginMeetingTextField.wantsLayer = NO;
        _reminderBeginMeetingTextField.hidden = YES;
        _reminderBeginMeetingTextField.stringValue = NSLocalizedString(@"FM_MEETING_BEGIN_IN", @"Upcoming");
        [self.backgroundView addSubview:_reminderBeginMeetingTextField];
    }
    
    return _reminderBeginMeetingTextField;//reminderBeginMeetingTextField
}

- (NSTextField *)reminderNowMeetingTextField {
    if (!_reminderNowMeetingTextField) {
        _reminderNowMeetingTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _reminderNowMeetingTextField.backgroundColor = [NSColor clearColor];
        _reminderNowMeetingTextField.font = [NSFont systemFontOfSize:12 weight:NSFontWeightRegular];
        _reminderNowMeetingTextField.alignment = NSTextAlignmentLeft;
        _reminderNowMeetingTextField.textColor = [NSColor colorWithString:@"#23D862" andAlpha:1.0];
        _reminderNowMeetingTextField.editable = NO;
        _reminderNowMeetingTextField.bordered = NO;
        _reminderNowMeetingTextField.wantsLayer = NO;
        _reminderNowMeetingTextField.hidden = YES;
        _reminderNowMeetingTextField.stringValue = NSLocalizedString(@"FM_MEETING_STARTED", @"In Progress");
        [self.backgroundView addSubview:_reminderNowMeetingTextField];
    }
    
    return _reminderNowMeetingTextField;//reminderBeginMeetingTextField
}

- (NSTextField *)meetingNameTextField {
    if (!_meetingNameTextField){
        _meetingNameTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _meetingNameTextField.lineBreakMode = NSLineBreakByTruncatingTail;
        _meetingNameTextField.backgroundColor = [NSColor clearColor];
        _meetingNameTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightSemibold];
        _meetingNameTextField.alignment = NSTextAlignmentLeft;
        _meetingNameTextField.maximumNumberOfLines = 1;
        _meetingNameTextField.textColor = [NSColor colorWithString:@"#444444" andAlpha:1.0];
        _meetingNameTextField.editable = NO;
        _meetingNameTextField.bordered = NO;
        _meetingNameTextField.wantsLayer = NO;
        _meetingNameTextField.stringValue = @"会议名称 frtcmeeting";
        [self.backgroundView addSubview:_meetingNameTextField];
    }
    
    return _meetingNameTextField;
}

- (NSTextField *)timeTextField {
    if (!_timeTextField){
        _timeTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _timeTextField.backgroundColor = [NSColor clearColor];
        _timeTextField.font = [NSFont systemFontOfSize:12 weight:NSFontWeightRegular];
        _timeTextField.alignment = NSTextAlignmentLeft;
        _timeTextField.textColor = [NSColor colorWithString:@"#999999" andAlpha:1.0];
        _timeTextField.editable = NO;
        _timeTextField.bordered = NO;
        _timeTextField.wantsLayer = NO;
        [self.backgroundView addSubview:_timeTextField];
    }
    
    return _timeTextField;
}

- (HoverImageView *)copyImageView {
    if (!_copyImageView) {
        _copyImageView = [[HoverImageView alloc] initWithFrame:CGRectMake(0, 0, 136, 144)];
        [_copyImageView setImage:[NSImage imageNamed:@"icon-schedule-copy"]];
        _copyImageView.imageAlignment =  NSImageAlignTopLeft;
        _copyImageView.imageScaling =  NSImageScaleAxesIndependently;
        [self.backgroundView addSubview:_copyImageView];
    }
    
    return _copyImageView;
}

- (HoverImageView *)moreImageView {
    if (!_moreImageView) {
        _moreImageView = [[HoverImageView alloc] initWithFrame:CGRectMake(0, 0, 136, 144)];
        _moreImageView.delegate = self;
        [_moreImageView setImage:[NSImage imageNamed:@"icon-more-1"]];
        _moreImageView.imageAlignment =  NSImageAlignTopLeft;
        _moreImageView.imageScaling =  NSImageScaleAxesIndependently;
        [self.backgroundView addSubview:_moreImageView];
    }
    
    return _moreImageView;
}

- (NSImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[HoverImageView alloc] initWithFrame:CGRectMake(0, 0, 41, 16)];

        if([[self currentLanguageDes] isEqualToString:@"English"]) {
            [_arrowImageView setImage:[NSImage imageNamed:@"icon-schedule-invite-en"]];
        } else if([[self currentLanguageDes] isEqualToString:@"简体中文"]) {
            [_arrowImageView setImage:[NSImage imageNamed:@"icon-schedule-invite-hans"]];
        } else if([[self currentLanguageDes] isEqualToString:@"繁體中文"]) {
            [_arrowImageView setImage:[NSImage imageNamed:@"icon-schedule-invite-hk"]];
        }
        _arrowImageView.imageAlignment =  NSImageAlignTopLeft;
        _arrowImageView.imageScaling =  NSImageScaleAxesIndependently;
        [self.backgroundView addSubview:_arrowImageView];
    }
    
    return _arrowImageView;
}

- (FrtcMultiTypesButton *)joinMeetingButton {
    if (!_joinMeetingButton){
        _joinMeetingButton = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 48, 22) withTitle:NSLocalizedString(@"FM_JOIN", @"Join")];
        _joinMeetingButton.target = self;
        _joinMeetingButton.layer.cornerRadius = 4.0;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_JOIN", @"Join")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[[FrtcBaseImplement baseImpleSingleton] whiteColor]
                          range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:12]
                          range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [_joinMeetingButton setAttributedTitle:attrTitle];
        _joinMeetingButton.action = @selector(onJoinVideoMeetingPressed:);
        [self.backgroundView addSubview:_joinMeetingButton];
    }
    
    return _joinMeetingButton;
}

- (FrtcButton *)settingButton {
    if(!_settingButton) {
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#222222" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#EEEFF0" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#F8F9FA" andAlpha:1.0] andButtonTitle:@"" andButtonTitleFont:[NSFont systemFontOfSize:12 weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#EEEFF0" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#F8F9FA" andAlpha:1.0] andButtonTitle:@"" andButtonTitleFont:[NSFont systemFontOfSize:12 weight:NSFontWeightRegular]];
        
        _settingButton = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 48, 22) withNormalMode:normalMode withHoverMode:hoverMode];
        
        //_settingButton.action = @selector(onSettingBtnPressed:);
        [self.backgroundView addSubview:_joinMeetingButton];
        [self.backgroundView addSubview:_settingButton];
    }
    
    return _settingButton;;
}

- (FrtcButton *)overTimeButton {
    if(!_overTimeButton) {
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#CCCCCC" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#CCCCCC" andAlpha:1.0] andButtonTitle:@"失效" andButtonTitleFont:[NSFont systemFontOfSize:12 weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#CCCCCC" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#CCCCCC" andAlpha:1.0] andButtonTitle:@"失效" andButtonTitleFont:[NSFont systemFontOfSize:12 weight:NSFontWeightRegular]];
        
        _overTimeButton = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 48, 22) withNormalMode:normalMode withHoverMode:hoverMode];
        _overTimeButton.hidden = YES;
        [self.backgroundView addSubview:_overTimeButton];
    }
    
    return _overTimeButton;;
}

- (NSView *)lineView {
    if(!_lineView) {
        _lineView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 332, 1)];
        _lineView.wantsLayer = YES;
        _lineView.layer.backgroundColor = [NSColor colorWithString:@"#EEEFF0" andAlpha:1.0].CGColor;
        [self addSubview:_lineView];
    }
    
    return _lineView;
}

- (FrtcRecurrenceView *)recurrenceView {
    if(!_recurrenceView) {
        _recurrenceView = [[FrtcRecurrenceView alloc] initWithFrame:NSMakeRect(0, 0, 28, 16)];
        _recurrenceView.hidden = YES;
        [self.backgroundView addSubview:_recurrenceView];
    }
    
    return _recurrenceView;
}

@end
