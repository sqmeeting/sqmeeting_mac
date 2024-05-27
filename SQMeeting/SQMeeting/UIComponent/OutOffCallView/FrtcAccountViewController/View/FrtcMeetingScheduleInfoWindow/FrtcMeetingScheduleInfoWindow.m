#import "FrtcMeetingScheduleInfoWindow.h"
#import "FrtcMeetingDetailInfoView.h"
#import "FrtcMultiTypesButton.h"
#import "AppDelegate.h"
#import "CallResultReminderView.h"
#import "FrtcCopyInfoView.h"

@interface FrtcMeetingScheduleInfoWindow ()<FrtcCopyInfoViewDelegate>

@property (nonatomic, assign) NSSize        windowSize;

@property (nonatomic, assign) NSRect        windowFrame;

@property (nonatomic, strong) NSView        *parentView;

@property (nonatomic, assign) BOOL          defaultCenter;

@property (nonatomic, weak)   AppDelegate   *appDelegate;

@property (nonatomic, strong) NSTextField *titleTextField;

@property (nonatomic, strong) FrtcMeetingDetailInfoView *infoView;

@property (nonatomic, strong) FrtcMultiTypesButton *copyButton;

@property (nonatomic, strong) CallResultReminderView *reminderView;

@property (nonatomic, strong) NSTimer *reminderTipsTimer;

@property (nonatomic, strong) ScheduleSuccessModel *model;

@property (nonatomic, strong) NSImageView *imageView;

@property (nonatomic, strong) FrtcCopyInfoView *copyInfoView;

@end

@implementation FrtcMeetingScheduleInfoWindow

- (instancetype)initWithSize:(NSSize)size withSuccessfulSchedule:(BOOL)isSchedule {
    self = [super init];
    
    if(self) {
        self.defaultCenter = YES;
        self.releasedWhenClosed = NO;
        self.titleVisibility = NSWindowTitleHidden;
        self.windowSize = size;
        
        self.releasedWhenClosed = NO;
        self.styleMask = self.styleMask | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskClosable;
        self.titlebarAppearsTransparent = YES;
        
        self.backgroundColor = [NSColor colorWithString:@"#F6F8FB" andAlpha:1.0];
        
        [self standardWindowButton:NSWindowZoomButton].enabled = NO;
        [self standardWindowButton:NSWindowCloseButton].enabled = YES;
        [self standardWindowButton:NSWindowMiniaturizeButton].enabled = NO;
        
        [[self standardWindowButton:NSWindowZoomButton] setHidden:YES];
        [[self standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
        [[self standardWindowButton:NSWindowCloseButton] setHidden:NO];
        
        self.contentMaxSize = size;
        self.contentMinSize = size;
        [self setContentSize:size];
        
        self.scheduleSuccess = isSchedule;
        
        [self detailInfoWindowLayout];
    }
    
    return self;
}

- (void)showWindowWithWindow:(NSWindow *)window {
    NSView* view = window.contentView;
    NSRect frameRelativeToWindow = [view convertRect:view.bounds toView:nil];
    NSPoint pointRelativeToScreen = [view.window convertRectToScreen:frameRelativeToWindow].origin;
    NSPoint pos = NSZeroPoint;
    if (self.defaultCenter) {
        pos.x = pointRelativeToScreen.x + (view.bounds.size.width-self.windowSize.width-view.frame.origin.x)/2;
        pos.y = pointRelativeToScreen.y + (view.bounds.size.height-self.windowSize.height-view.frame.origin.y)/2;
    } else {
        pos = self.frame.origin;
    }
    [self setFrame:NSMakeRect(0, 0, self.windowSize.width, self.windowSize.height) display:YES];
    [self setFrameOrigin:pos];
    [view.window addChildWindow:self ordered:NSWindowAbove];
    
    [self setParentView:view];
    [self makeKeyAndOrderFront:self.parentWindow];
}

- (void)showWindow {
    self.appDelegate = (AppDelegate*)[NSApplication sharedApplication].delegate;
    NSWindow* window = [NSApplication sharedApplication].windows.firstObject;
    NSView* view = window.contentView;
    NSRect frameRelativeToWindow = [view convertRect:view.bounds toView:nil];
    NSPoint pointRelativeToScreen = [view.window convertRectToScreen:frameRelativeToWindow].origin;
    NSPoint pos = NSZeroPoint;
    if (self.defaultCenter) {
        pos.x = pointRelativeToScreen.x + (view.bounds.size.width-self.windowSize.width-view.frame.origin.x)/2;
        pos.y = pointRelativeToScreen.y + (view.bounds.size.height-self.windowSize.height-view.frame.origin.y)/2;
    } else {
        pos = self.frame.origin;
    }
    [self setFrame:NSMakeRect(0, 0, self.windowSize.width, self.windowSize.height) display:YES];
    [self setFrameOrigin:pos];
    [view.window addChildWindow:self ordered:NSWindowAbove];
    self.parentView = view;
    [self makeKeyAndOrderFront:self.parentWindow];
    
    //[self.meetingIDText.window makeFirstResponder:nil];
}

- (void)adjustToSize:(NSSize)size {
    NSRect frameRelativeToWindow = [self.parentView convertRect:self.parentView.bounds toView:nil];
    NSPoint pointRelativeToScreen = [self.parentView.window convertRectToScreen:frameRelativeToWindow].origin;
    NSPoint pos = NSZeroPoint;
    pos.x = pointRelativeToScreen.x + (self.parentView.bounds.size.width-size.width-self.parentView.frame.origin.x)/2;
    pos.y = pointRelativeToScreen.y + (self.parentView.bounds.size.height-size.height-self.parentView.frame.origin.y)/2;
    [self setFrame:NSMakeRect(0, 0, size.width, size.height) display:YES];
    [self setFrameOrigin:pos];
}

#pragma mark --FrtcCopyInfoViewDelegate--
- (void)copyInfo {
    [self onSaveBtnPressed];
}

#pragma mark --- Class Interface;
- (void)setupMeetingInfo:(ScheduleSuccessModel *)model {
    self.model = model;
    
    if(!self.isScheduleSuccess) {
        self.titleTextField.stringValue = model.meeting_name;
    }
    
    self.infoView.titleTextField.stringValue = [NSString stringWithFormat:@"%@ %@", model.owner_name, NSLocalizedString(@"FM_INVITE_PEOPLE", @"Invite you to a SQ Meeting CE  meeting")];
    
    //self.infoView.titleTextField.stringValue = [NSString stringWithFormat:@"%@ %@", model.clientName, NSLocalizedString(@"FM_INVITE_PEOPLE", @"Invite you to a SQ Meeting CE  meeting")];
    self.infoView.themeTextField.stringValue = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"FM_MEETING_OBJECT", @"Meeting Topic"), model.meeting_name];
    self.infoView.meetingNumberTextField.stringValue = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"FM_MEETING_NUMBER", @"Meeting ID"), model.meeting_number];
    self.infoView.meetingBeginTimeTextField.stringValue = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"FM_MEETING_START_TIME", @"Start Time"),[self dateTimeString:model.schedule_start_time]];
    self.infoView.endTimeTextField.stringValue = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"FM_MEETING_END_TIME", @"End time"),[self dateTimeString:model.schedule_end_time]];
    self.infoView.meetingPasswordTextField.stringValue = [NSString stringWithFormat:@"%@：%@", NSLocalizedString(@"FM_PASSCODE", @"Password"), model.meeting_password ? model.meeting_password : @""];
    
    if([model.meeting_type isEqualToString:@"recurrence"]) {
        self.infoView.meetingUrlTextField.stringValue = model.groupMeetingUrl;
    } else {
        self.infoView.meetingUrlTextField.stringValue = model.meeting_url;
    }
    
    if([model.meeting_url isEqualToString:@""] || model.meeting_url == nil) {
        self.infoView.meetingUrlTextField.hidden = YES;
        self.infoView.meetingUrlTextFieldTips.hidden = YES;
    }
    
    if([[self dateTimeString:model.schedule_end_time] isEqualToString:@"1970-01-01 08:00"] && [[self dateTimeString:model.schedule_start_time] isEqualToString:@"1970-01-01 08:00"]) {
        self.infoView.meetingBeginTimeTextField.hidden = YES;
        self.infoView.endTimeTextField.hidden = YES;
        [self.infoView updateLayout];
    }
    
    if([model.meeting_password isEqualToString:@""] || model.meeting_password == nil) {
        [self.infoView updatePasswordLayout];
        self.infoView.meetingPasswordTextField.hidden = YES;
    }
    
    if([model.meeting_type isEqualToString:@"recurrence"]) {
        [self.infoView updateRecurrenceLayout];
        NSString *recurrenceStartDay = [self dateTimeStringNoHour:model.recurrenceStartDay];
        NSString *recurrenceEndDay   = [self dateTimeStringNoHour:model.recurrenceEndDay];
        
        NSString *str = [NSString stringWithFormat:@"%@ - %@", recurrenceStartDay, recurrenceEndDay];
        NSString *timeHour = [NSString stringWithFormat:@"%@-%@", [self hourAndSecondTimeString:model.schedule_start_time], [self hourAndSecondTimeString:model.schedule_end_time]];
        NSString *recurrenceString;
        if([self.model.recurrence_type isEqualToString:@"DAILY"]) {
            if([model.recurrenceInterval integerValue] == 1) {
                recurrenceString = NSLocalizedString(@"FM_MEETING_RE_EVERY_DAY_DETAIL", @"The meeting will repeat every day");
                
                
            } else {
                recurrenceString = [NSString stringWithFormat:NSLocalizedString(@"FM_MEETING_RE_EVERY_SOME_DAY_DETAIL", @"The meeting will repeat every %@ days"),model.recurrenceInterval];
            }
            
        } else if([self.model.recurrence_type isEqualToString:@"WEEKLY"]) {
    
            NSString * str = [self convertValueToWeekDay: [self.model.recurrenceDaysOfWeek[0] stringValue] ];
            NSInteger value = [self.model.recurrenceDaysOfWeek[0] integerValue];
            value -= 1;
            if(value == 0) {
                value = 7;
            }
            for(int i = 1; i < self.model.recurrenceDaysOfWeek.count; i++) {
                str = [NSString stringWithFormat:@"%@,%@", str,[self convertValueToWeekDay:[self.model.recurrenceDaysOfWeek[i] stringValue]]];
            }
            if([model.recurrenceInterval integerValue] == 1) {
                recurrenceString = [NSString stringWithFormat:NSLocalizedString(@"FM_MEETING_RE_EVERY_ONE_WEEK", @"Every week on day(%@)"),str];
                
                
            } else {
                recurrenceString = [NSString stringWithFormat:NSLocalizedString(@"FM_MEETING_RE_EVERY_MORE_WEEK", @"Every %@ week on day(%@)"),model.recurrenceInterval,str];
            }
            
        } else if([self.model.recurrence_type isEqualToString:@"MONTHLY"]) {
            NSArray *sortedArray= [self.model.recurrenceDaysOfMonth sortedArrayUsingSelector:@selector(compare:)];
            NSString *str = [NSString stringWithFormat:@"%@", sortedArray[0]];
            
           // NSString *str = self.model.recurrenceDaysOfMonth[0];
            for(int i = 1; i < sortedArray.count; i++) {
                str = [NSString stringWithFormat:@"%@,%@", str,sortedArray[i]];
            }
            if([model.recurrenceInterval integerValue] == 1) {
                recurrenceString = [NSString stringWithFormat:NSLocalizedString(@"FM_MEETING_RE_EVERY_ONE_MONTH", @"Every month on day(%@)"),str];
                
                
            } else {
                recurrenceString = [NSString stringWithFormat:NSLocalizedString(@"FM_MEETING_RE_EVERY_MORE_MONTH", @"Every %@ month on day(%@)"),model.recurrenceInterval,str];
            }
        }
        self.infoView.recurrenceTextField.stringValue = [NSString stringWithFormat:@"%@：%@ %@ %@", NSLocalizedString(@"FM_MEETING_RECURRENCE_RECURRENT", @"Recurrence"), str ,timeHour, recurrenceString];
    }
}

- (NSString *)dateTimeString:(NSString *)utcTimeString {
    return [self dateTimeFromUtcTimeString:utcTimeString withTimeForMatter:@"yyyy-MM-dd HH:mm"];
}

- (NSString *)dateTimeStringNoHour:(NSString *)utcTimeString {
    return [self dateTimeFromUtcTimeString:utcTimeString withTimeForMatter:@"yyyy-MM-dd"];
}


- (NSString *)hourAndSecondTimeString:(NSString *)utcTimeString {
    return [self dateTimeFromUtcTimeString:utcTimeString withTimeForMatter:@"HH:mm"];
}

- (NSString *)dateTimeFromUtcTimeString:(NSString *)utcTimeString withTimeForMatter:(NSString *)timeFormatter {
    NSTimeInterval time = [utcTimeString doubleValue] / 1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:timeFormatter];
    NSString *TimeDateString = [dateFormatter stringFromDate: detailDate];
    
    return TimeDateString;
}

- (NSString *)convertValueToWeekDay:(NSString *)value {
    if([value isEqualToString:@"1"]) {
        return  NSLocalizedString(@"FM_MEETING_SUN", @"Sun");
    } else if([value isEqualToString:@"2"]) {
        return  NSLocalizedString(@"FM_MEETING_MON", @"Mon");
    } else if([value isEqualToString:@"3"]) {
        return  NSLocalizedString(@"FM_MEETING_TUE", @"Tue");
    } else if([value isEqualToString:@"4"]) {
        return  NSLocalizedString(@"FM_MEETING_WED", @"Wed");
    } else if([value isEqualToString:@"5"]) {
        return  NSLocalizedString(@"FM_MEETING_THU", @"Thu");
    } else if([value isEqualToString:@"6"]) {
        return  NSLocalizedString(@"FM_MEETING_FRI", @"Fri");
    } else if([value isEqualToString:@"7"]) {
        return  NSLocalizedString(@"FM_MEETING_SAT", @"Sat");
    }
    
    return @"";
}


#pragma mark --Detail Info Window Layout
- (void)detailInfoWindowLayout {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(9);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    if(self.isScheduleSuccess) {
        self.imageView.hidden = NO;
    }
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleTextField.mas_centerY);
        make.right.mas_equalTo(self.titleTextField.mas_left).offset(-12);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(40);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(356);
        make.height.mas_equalTo(315);
    }];
    
    NSFont *font             = [NSFont systemFontOfSize:14.0f];
    NSDictionary *attributes = @{ NSFontAttributeName:font };
    CGSize size              = [NSLocalizedString(@"FM_MEETING_INFO_COPY", @"Copy Invitation") sizeWithAttributes:attributes];
    
//    [self.copyButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.infoView.mas_bottom).offset(10);
//        make.centerX.mas_equalTo(self.contentView.mas_centerX);
//        make.width.mas_equalTo(size.width + 10);
//        make.height.mas_equalTo(size.height + 10);
//    }];
    
    [self.copyInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.infoView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(size.width + 70);
        make.height.mas_equalTo(32);
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
    
    pastString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",
                        self.infoView.titleTextField.stringValue,
                        self.infoView.themeTextField.stringValue,
                        self.infoView.meetingBeginTimeTextField.stringValue,
                        self.infoView.endTimeTextField.stringValue
                    ];
    
    if([self.model.meeting_type isEqualToString:@"recurrence"]) {
        pastString = [NSString stringWithFormat:@"%@\n%@\n%@", pastString,
                      self.infoView.recurrenceTextField.stringValue,
                      self.infoView.meetingNumberTextField.stringValue
                    ];
    } else {
        pastString = [NSString stringWithFormat:@"%@\n%@", pastString,
                       self.infoView.meetingNumberTextField.stringValue
                    ];
    }
    
    if(![self.model.meeting_password isEqualToString:@""] && self.model.meeting_password != nil) {
        pastString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@", pastString,
                      self.infoView.meetingPasswordTextField.stringValue,
                      self.infoView.secondIntroductionTextField.stringValue,
                      self.infoView.meetingUrlTextFieldTips.stringValue,
                      self.infoView.meetingUrlTextField.stringValue
                    ];
    } else {
        pastString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@", pastString,
                      self.infoView.secondIntroductionTextField.stringValue,
                      self.infoView.meetingUrlTextFieldTips.stringValue,
                      self.infoView.meetingUrlTextField.stringValue
                    ];
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
        _titleTextField.stringValue = NSLocalizedString(@"FM_MEETING_SCHEDULE_SUCCESS_TAG", @"Scheduled successful");
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        [self.contentView addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (FrtcMeetingDetailInfoView *)infoView {
    if(!_infoView) {
        _infoView = [[FrtcMeetingDetailInfoView alloc] initWithFrame:NSMakeRect(0, 0, 356, 285)];
        [self.contentView addSubview:_infoView];
    }
    
    return _infoView;
}

- (FrtcCopyInfoView *)copyInfoView {
    if(!_copyInfoView) {
        _copyInfoView = [[FrtcCopyInfoView alloc] initWithFrame:CGRectMake(0, 0, 188, 32)];
        _copyInfoView.delegate = self;
        [self.contentView addSubview:_copyInfoView];
    }
    
    return _copyInfoView;;
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

- (NSImageView *)imageView {
    if(!_imageView) {
        _imageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        _imageView.image = [NSImage imageNamed:@"icon_schedule_success"];
        _imageView.hidden = YES;
        [self.contentView addSubview:_imageView];
    }
    
    return _imageView;
}

@end
