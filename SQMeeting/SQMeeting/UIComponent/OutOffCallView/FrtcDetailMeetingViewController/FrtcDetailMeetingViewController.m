#import "FrtcDetailMeetingViewController.h"
#import "FrtcMultiTypesButton.h"
#import "FrtcAlertMainWindow.h"

@interface FrtcDetailMeetingViewController ()

@property (nonatomic, strong) NSTextField   *titleTextField;
@property (nonatomic, strong) NSView        *line1;
@property (nonatomic, strong) NSTextField   *beginTimeLabel;
@property (nonatomic, strong) NSTextField   *beginTimeTextField;
@property (nonatomic, strong) NSView        *line2;
@property (nonatomic, strong) NSTextField   *durationTimeLabel;
@property (nonatomic, strong) NSTextField   *durationTimeTextField;
@property (nonatomic, strong) NSView        *line3;
@property (nonatomic, strong) NSTextField   *meetingNumberLabel;
@property (nonatomic, strong) NSTextField   *meetingNumberTextField;
@property (nonatomic, strong) NSView        *line4;
@property (nonatomic, strong) NSTextField   *meetingPasswordLabel;
@property (nonatomic, strong) NSTextField   *meetingPasswordTextField;
@property (nonatomic, strong) NSView        *line5;
@property (nonatomic, strong) NSTextField   *meetingLeadLabel;
@property (nonatomic, strong) NSTextField   *meetingLeadTextField;
@property (nonatomic, strong) NSView        *line6;
@property (nonatomic, strong) FrtcMultiTypesButton      *beginButton;
@property (nonatomic, strong) FrtcMultiTypesButton      *removeButton;

@end

@implementation FrtcDetailMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
    [self setupDetailMeetingUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMainViewNotification:) name:FrtcMeetingMainViewShowNotification object:nil];
}

- (void)dealloc {
    NSLog(@"FrtcDetailMeetingViewController dealloc");
}

- (void)setupDetailMeetingUI {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(60);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(350);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(14);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(380);
        make.height.mas_equalTo(1);
     }];
    
    [self.beginTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line1.mas_bottom).offset(15);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.beginTimeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-24);
        make.centerY.mas_equalTo(self.beginTimeLabel.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.beginTimeLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.width.mas_equalTo(380);
        make.height.mas_equalTo(1);
     }];
    
    [self.durationTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line2.mas_bottom).offset(11);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.durationTimeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-24);
        make.centerY.mas_equalTo(self.durationTimeLabel.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.durationTimeLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.width.mas_equalTo(332);
        make.height.mas_equalTo(1);
     }];
    
    [self.meetingNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line3.mas_bottom).offset(15);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.meetingNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-24);
        make.centerY.mas_equalTo(self.meetingNumberLabel.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.meetingNumberLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.width.mas_equalTo(332);
        make.height.mas_equalTo(1);
     }];
    
    [self.meetingPasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line4.mas_bottom).offset(15);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.meetingPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-24);
        make.centerY.mas_equalTo(self.meetingPasswordLabel.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.meetingPasswordLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.width.mas_equalTo(332);
        make.height.mas_equalTo(1);
     }];
    
    [self.meetingLeadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line5.mas_bottom).offset(15);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.meetingLeadTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-24);
        make.centerY.mas_equalTo(self.meetingLeadLabel.mas_centerY);
        make.width.mas_equalTo(280);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.line6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.meetingLeadLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.width.mas_equalTo(332);
        make.height.mas_equalTo(1);
     }];
    
    [self.beginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line6.mas_bottom).offset(24);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(332);
        make.height.mas_equalTo(36);
     }];
    
    [self.removeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.beginButton.mas_bottom).offset(16);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(332);
        make.height.mas_equalTo(36);
     }];
}

#pragma mark -- implement notification
- (void)receiveMainViewNotification:(NSNotification*)noti {
    [self.view.window close];
}

- (NSString *)timeDurationWithStartTime:(NSString *)startTime withEndTime:(NSString *)endTime {
    NSTimeInterval startTimeInterval = [startTime doubleValue] / 1000;
    NSTimeInterval endTimeInterval = [endTime doubleValue] / 1000;
    
    NSTimeInterval durationTimeInterval = endTimeInterval - startTimeInterval;
     
    return [self timeWithMessageString:durationTimeInterval];
}


- (NSString *)timeWithMessageString:(NSTimeInterval)timeInter {
    int month = timeInter / (3600 * 24 * 30);
    int day = timeInter / (3600 * 24);
    int hour = timeInter / 3600;
    int minute = timeInter / 60;
    
    int day_process = day - month * 30;
    int hour_process = hour - day *24;
    int minute_process = minute - hour *60;
    int miao_process = timeInter - minute*60;
    
    NSString *timedate = nil;
    if (day == 0) {
        timedate = [NSString stringWithFormat:@"%d%@%d%@",hour_process,NSLocalizedString(@"FM_HOUR", @"hour"),minute_process, NSLocalizedString(@"FM_MINUTE", @"minute")];
        if (hour == 0) {
            timedate = [NSString stringWithFormat:@"%d%@%d%@",minute_process, NSLocalizedString(@"FM_MINUTE", @"minute"), miao_process, NSLocalizedString(@"FM_SECOND", @"second")];
            if (minute == 0) {
                timedate = [NSString stringWithFormat:@"%d%@",miao_process, NSLocalizedString(@"FM_SECOND", @"second")];
            }
        }
    } else {
        timedate = [NSString stringWithFormat:@"%d天%d%@%d%@%d%@",day_process,hour_process,NSLocalizedString(@"FM_HOUR", @"hour"),minute_process,NSLocalizedString(@"FM_MINUTE", @"minute"),miao_process, NSLocalizedString(@"FM_SECOND", @"second")];
    }
    
    return timedate;
}

#pragma mark --Class Inferface--
- (void)updateMeetingInfomation:(MeetingDetailModel *)detailMeetingInfoModel {
    NSString *startTime = [[FrtcBaseImplement baseImpleSingleton] dateStringWithTimeString:detailMeetingInfoModel.meetingStartTime];
    
    _titleTextField.stringValue             = detailMeetingInfoModel.meetingName;
    _beginTimeTextField.stringValue         = startTime;
    _durationTimeTextField.stringValue      = detailMeetingInfoModel.meetingDuration;
    _meetingLeadTextField.stringValue       = detailMeetingInfoModel.meetingName;
    _meetingNumberTextField.stringValue     = detailMeetingInfoModel.meetingNumber;
    
}

#pragma mark --Button Sender--
- (void)onJoinVideoMeetingPressed:(FrtcMultiTypesButton *)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(joinCall:)]) {
        [self.delegate joinCall:self.detailMeetingInfoModel];
    }
}

- (void)onRemovePressed:(FrtcMultiTypesButton *)sender {
    FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_DELETE_MEETING", @"Delete Meeting") withMessage:NSLocalizedString(@"FM_DELETE_MEETING_SURE", @"Are you sure to delete this meeting from history meetings?") preferredStyle:FrtcWindowAlertStyleDefault withCurrentWindow:self.view.window];

    __weak __typeof(self)weakSelf = self;
    FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if(strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(removeInfomationItem:)]) {
            [strongSelf.delegate removeInfomationItem:self.detailMeetingInfoModel.meetingStartTime];
        }
 
    }];
    
    [alertWindow addAction:action];
    
    FrtcAlertAction *actionCancel = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_CANCEL", @"Cancel") style:FrtcWindowAlertActionStyleCancle handler:^{
    }];
    
    [alertWindow addAction:actionCancel];
//    if(self.delegate && [self.delegate respondsToSelector:@selector(removeInfomationItem:)]) {
//        [self.delegate removeInfomationItem:self.detailMeetingInfoModel.meetingStartTime];
//    }
}

#pragma mark --getter load--
- (NSTextField *)titleTextField {
    if (!_titleTextField) {
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        //_titleTextField.accessibilityClearButton;
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:16 weight:NSFontWeightSemibold];
        //_titleTextField.font = [[NSFontManager sharedFontManager] fontWithFamily:@"PingFangSC-Regular" traits:NSBoldFontMask weight:NSFontWeightMedium size:18];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleTextField.maximumNumberOfLines = 1;
        _titleTextField.textColor = [NSColor colorWithString:@"222222" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.stringValue = self.detailMeetingInfoModel.meetingName;
        [self.view addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (NSView *)line1 {
    if(!_line1) {
        _line1 = [self line];
        [self.view addSubview:_line1];
    }
    
    return _line1;
}

- (NSTextField *)beginTimeLabel {
    if (!_beginTimeLabel) {
        _beginTimeLabel = [self interalLabel];
        _beginTimeLabel.stringValue = NSLocalizedString(@"FM_MEETING_HISTORY_START_TIME", @"Start Time");
        [self.view addSubview:_beginTimeLabel];
    }
    
    return _beginTimeLabel;
}

- (NSTextField *)beginTimeTextField {
    if (!_beginTimeTextField) {
        _beginTimeTextField = [self internalTextField];
        _beginTimeTextField.stringValue = [[FrtcBaseImplement baseImpleSingleton] dateStringWithTimeString:self.detailMeetingInfoModel.meetingStartTime];
        [self.view addSubview:_beginTimeTextField];
    }
    
    return _beginTimeTextField;
}

- (NSView *)line2 {
    if(!_line2) {
        _line2 = [self line];
        [self.view addSubview:_line2];
    }
    
    return _line2;
}

- (NSTextField *)durationTimeLabel {
    if(!_durationTimeLabel) {
        _durationTimeLabel = [self interalLabel];
        _durationTimeLabel.stringValue = NSLocalizedString(@"FM_MEETING_HISTORY_DURATION_TIME", @"Duration");
        [self.view addSubview:_durationTimeLabel];
    }
    
    return _durationTimeLabel;
}

- (NSTextField *)durationTimeTextField {
    if(!_durationTimeTextField) {
        _durationTimeTextField = [self internalTextField];
        _durationTimeTextField.stringValue = [self timeDurationWithStartTime:self.detailMeetingInfoModel.meetingStartTime withEndTime:self.detailMeetingInfoModel.meetingEndTime];
        [self.view addSubview:_durationTimeTextField];
    }
    
    return _durationTimeTextField;
}

- (NSView *)line3 {
    if(!_line3) {
        _line3 = [self line];
        [self.view addSubview:_line3];
    }
    
    return _line3;
}

- (NSTextField *)meetingNumberLabel {
    if(!_meetingNumberLabel) {
        _meetingNumberLabel = [self interalLabel];
        _meetingNumberLabel.stringValue =NSLocalizedString(@"FM_MEETING_NUMBER", @"Meeting ID");
        [self.view addSubview:_meetingNumberLabel];
    }
    
    return _meetingNumberLabel;
}

- (NSTextField *)meetingNumberTextField {
    if(!_meetingNumberTextField) {
        _meetingNumberTextField = [self internalTextField];
        _meetingNumberTextField.stringValue = self.detailMeetingInfoModel.meetingNumber;
        [self.view addSubview:_meetingNumberTextField];
    }
    
    return _meetingNumberTextField;
}

- (NSView *)line4 {
    if(!_line4) {
        _line4 = [self line];
        [self.view addSubview:_line4];
    }
    
    return _line4;
}

- (NSTextField *)meetingPasswordLabel {
    if(!_meetingPasswordLabel) {
        _meetingPasswordLabel = [self interalLabel];
        _meetingPasswordLabel.stringValue = NSLocalizedString(@"FM_SIGN_IN_PASSWORD", @"Password");
        [self.view addSubview:_meetingPasswordLabel];
    }
    
    return _meetingPasswordLabel;
}

- (NSTextField *)meetingPasswordTextField {
    if(!_meetingPasswordTextField) {
        _meetingPasswordTextField = [self internalTextField];
        _meetingPasswordTextField.stringValue = self.detailMeetingInfoModel.meetingPassword ? self.detailMeetingInfoModel.meetingPassword : @"";
        [self.view addSubview:_meetingPasswordTextField];
    }
    
    return _meetingPasswordTextField;
}

- (NSView *)line5 {
    if(!_line5) {
        _line5 = [self line];
        [self.view addSubview:_line5];
    }
    
    return _line5;
}

- (NSTextField *)meetingLeadLabel {
    if(!_meetingLeadLabel) {
        _meetingLeadLabel = [self interalLabel];
        _meetingLeadLabel.stringValue = NSLocalizedString(@"FM_MEETING_ORIGINZER", @"Sponsor");
        [self.view addSubview:_meetingLeadLabel];
    }
    
    return _meetingLeadLabel;
}

- (NSTextField *)meetingLeadTextField {
    if(!_meetingLeadTextField) {
        _meetingLeadTextField = [self internalTextField];
        _meetingLeadTextField.lineBreakMode = NSLineBreakByTruncatingTail;
        _meetingLeadTextField.maximumNumberOfLines = 1;
        _meetingLeadTextField.stringValue = self.detailMeetingInfoModel.ownerName == nil ? self.detailMeetingInfoModel.meetingName : self.detailMeetingInfoModel.ownerName;
        _meetingLeadTextField.alignment = NSTextAlignmentLeft;
        [self.view addSubview:_meetingLeadTextField];
    }
    
    return _meetingLeadTextField;
}

- (NSView *)line6 {
    if(!_line6) {
        _line6 = [self line];
        [self.view addSubview:_line6];
    }
    
    return _line6;
}

- (FrtcMultiTypesButton *)beginButton {
    if (!_beginButton){
        _beginButton = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 48, 22) withTitle:NSLocalizedString(@"FM_JOIN", @"Join")];
        _beginButton.target = self;
        _beginButton.layer.cornerRadius = 8.0;
        _beginButton.hover = NO;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_JOIN", @"Join")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#026FFE" andAlpha:1.0]
                          range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                          range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [_beginButton setAttributedTitle:attrTitle];
        _beginButton.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
        _beginButton.bordered = YES;
        _beginButton.layer.borderColor = [NSColor colorWithString:@"##999999" andAlpha:1.0].CGColor;
        _beginButton.action = @selector(onJoinVideoMeetingPressed:);
        [self.view addSubview:_beginButton];
    }
    
    return _beginButton;
}

- (FrtcMultiTypesButton*)removeButton {
    if (!_removeButton){
        _removeButton = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 48, 22) withTitle:NSLocalizedString(@"FM_REMOVE", @"Delete")];
        _removeButton.hover = NO;
        _removeButton.target = self;
        _removeButton.layer.cornerRadius = 8.0;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_REMOVE", @"Delete")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#E32726" andAlpha:1.0]
                          range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                          range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [_removeButton setAttributedTitle:attrTitle];
        _removeButton.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
        _removeButton.bordered = YES;
        _removeButton.action = @selector(onRemovePressed:);
        _removeButton.layer.borderColor = [NSColor colorWithString:@"##999999" andAlpha:1.0].CGColor;
        [self.view addSubview:_removeButton];
    }
    return _removeButton;
}


#pragma mark --Internal Function--
- (NSTextField *)interalLabel {
    NSTextField *internalLabel = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    internalLabel = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    internalLabel.bordered = NO;
    internalLabel.drawsBackground = NO;
    internalLabel.backgroundColor = [NSColor clearColor];
    internalLabel.layer.backgroundColor = [NSColor colorWithString:@"FFFFFF" andAlpha:1.0].CGColor;
    internalLabel.font = [NSFont systemFontOfSize:14 weight:NSFontWeightRegular];
    internalLabel.textColor = [NSColor colorWithString:@"#666666" andAlpha:1.0];
    internalLabel.alignment = NSTextAlignmentLeft;
    internalLabel.editable = NO;
    
    return internalLabel;
}

- (NSTextField *)internalTextField {
    NSTextField *internalTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    //_titleTextField.accessibilityClearButton;
    internalTextField.backgroundColor = [NSColor clearColor];
    internalTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightRegular];
    //_titleTextField.font = [[NSFontManager sharedFontManager] fontWithFamily:@"PingFangSC-Regular" traits:NSBoldFontMask weight:NSFontWeightMedium size:18];
    internalTextField.alignment = NSTextAlignmentCenter;
    internalTextField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
    internalTextField.bordered = NO;
    internalTextField.editable = NO;
    
    return internalTextField;
}

- (NSView *)line {
    NSView *line1 = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
    line1.wantsLayer = YES;
    line1.layer.backgroundColor = [NSColor colorWithString:@"#EEEFF0" andAlpha:1.0].CGColor;
    
    return line1;
}

@end
