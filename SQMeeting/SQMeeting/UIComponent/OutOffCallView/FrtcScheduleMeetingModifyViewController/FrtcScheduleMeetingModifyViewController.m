#import "FrtcScheduleMeetingModifyViewController.h"
#import "CanlanderView.h"
#import "FrtcDefaultTextField.h"
#import "HoverImageView.h"
#import "FrtcButton.h"
#import "FrtcDatePicker.h"
#import "FrtcTimeViewController.h"
#import "FrtcMeetingManagement.h"
#import "FrtcUserDefault.h"
#import "CallResultReminderView.h"

@interface FrtcScheduleMeetingModifyViewController() <CalanderViewDelegate, FrtcDatePickerDelegate, HoverImageViewDelegate, FrtcTimeViewControllerDelegate>

@property (nonatomic, strong) NSTextField *titleTextField;

@property (nonatomic, strong) NSTextField * recurrenceDetailTimeTextField;

@property (nonatomic, strong) NSTextField       *beginTimeTextLabel;
@property (nonatomic, strong) CanlanderView     *beginCanlanderView;
@property (nonatomic, strong) FrtcDefaultTextField       *beginDetailTextField;
@property (nonatomic, strong) HoverImageView    *timerImageView;

@property (nonatomic, strong) NSTextField       *endTimeTextLabel;
@property (nonatomic, strong) CanlanderView     *endCanlanderView;
@property (nonatomic, strong) FrtcDefaultTextField       *endDetailTextField;
@property (nonatomic, strong) HoverImageView    *endTimerImageView;

@property (nonatomic, strong) NSView            *line;
@property (nonatomic, strong) FrtcButton        *saveButton;

@property (nonatomic, strong) FrtcDatePicker *recurrenceStartDatePicker;

@property (nonatomic, strong) FrtcDatePicker *recurrenceEndDatePicker;

@property (nonatomic, strong) NSPopover *popover;

@property (nonatomic, strong) NSDate *scheduleMeetingStartTime;

@property (nonatomic, strong) NSDate *scheduleMeetingAllowEndTime;

@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, strong) NSDate *endDateNoDetail;

@property (nonatomic, strong) NSDate *lastMeetingDateEndTime;

@property (nonatomic, strong) NSDate *lastMeetingDateEndTimeNoDetail;

@property (nonatomic, copy)   NSString *lastMeetingDateEndTimeString;

@property (nonatomic, strong) NSDate *nextMeetingEndDate;

@property (nonatomic, strong) CallResultReminderView *reminderView;

@property (nonatomic, strong) NSTimer *reminderTipsTimer;

@property (nonatomic, copy)   NSString  *beginDetailSecondAndHour;

@property (nonatomic, strong) NSDate *beginFirstDate;

@property (nonatomic, strong) NSDate *beginLastDate;

@property (nonatomic, strong) NSDate *beginSelectDate;

@property (nonatomic, strong) NSDate *latestBeginDate;

@property (nonatomic, strong) NSDate *calendarStartTime;

@property (nonatomic, assign, getter=isFirstMeeting) BOOL firstMeeting;

@property (nonatomic, assign, getter=isLastMeeting)  BOOL lastMeeting;

@end

@implementation FrtcScheduleMeetingModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
    
    NSString *str;
    if([self.scheduleModel.recurrence_type isEqualToString:@"DAILY"]) {
        if([self.scheduleModel.recurrenceInterval integerValue] == 1) {
            str = NSLocalizedString(@"FM_MEETING_RE_EVERY_DAY", @"Every Day");
        } else {
            str = [NSString stringWithFormat:NSLocalizedString(@"FM_MEETING_RE_EVERY_SOME_DAY", @"Every %@ Day"), [self.scheduleModel.recurrenceInterval stringValue]];
        }
    } else if([self.scheduleModel.recurrence_type isEqualToString:@"WEEKLY"]) {
        if([self.scheduleModel.recurrenceInterval integerValue] == 1) {
            str = NSLocalizedString(@"FM_MEETING_RE_EVERY_WEEK", @"Every Week");
        } else {
            str = [NSString stringWithFormat:NSLocalizedString(@"FM_MEETING_RE_EVERY_SOME_WEEK", @"Every %@ Week"), [self.scheduleModel.recurrenceInterval stringValue]];
        }
        
    } else if([self.scheduleModel.recurrence_type isEqualToString:@"MONTHLY"]) {
        if([self.scheduleModel.recurrenceInterval integerValue] == 1) {
            str  = NSLocalizedString(@"FM_MEETING_RE_EVERY_MONTH", @"Every MONTH");
        } else {
            str = [NSString stringWithFormat:NSLocalizedString(@"FM_MEETING_RE_EVERY_SOME_MONTH", @"EVERY %@ Month"), [self.scheduleModel.recurrenceInterval stringValue]];
        }
    }
    self.strVaule = str;
    self.frequencyTextField.stringValue = self.strVaule;
    [self setupModifyView];
    
    self.recurrenceDetailTimeTextField.stringValue = [NSString stringWithFormat:NSLocalizedString(@"FM_MEETING_RE_END_DETAIL_TIME", "End on %@ %ld remaining meetings"), [[FrtcBaseImplement baseImpleSingleton] dateStringWithMonthAndDayString:self.scheduleModel.recurrenceEndDay], self.scheduleModelArray.recurrenceReservationList.count + 1];
    
    self.beginCanlanderView.timeTextField.stringValue = [self dateTimeString:self.scheduleModel.schedule_start_time];
    self.beginDetailTextField.stringValue = [self hourAndSecondTimeString:self.scheduleModel.schedule_start_time];
    
    self.endCanlanderView.timeTextField.stringValue = [self dateTimeString:self.scheduleModel.schedule_end_time];
    self.endDetailTextField.stringValue = [self hourAndSecondTimeString:self.scheduleModel.schedule_end_time];
    
    self.scheduleMeetingStartTime = [self dateFromTimeString:[NSString stringWithFormat:@"%@:%@",self.beginCanlanderView.timeTextField.stringValue, self.beginDetailTextField.stringValue]];
    self.calendarStartTime = self.scheduleMeetingStartTime;
    
    NSDate *date = [NSDate date];
    
    if([date compare:self.scheduleMeetingStartTime] == NSOrderedAscending) {
        self.beginFirstDate = date;
    } else {
        self.beginFirstDate = self.scheduleMeetingStartTime;
    }
    
    self.beginSelectDate = self.beginFirstDate;
    
    self.scheduleMeetingAllowEndTime = [[NSDate alloc] initWithTimeInterval:24 * 60 * 60 sinceDate:self.scheduleMeetingStartTime];
    
    if(self.row == 0) {
        self.firstMeeting = YES;
    } else {
        if(self.row == 1) {
            str = [NSString stringWithFormat:@"%@:%@",[self dateTimeString:self.scheduleModelArray.schedule_end_time], [self hourAndSecondTimeString:self.scheduleModel.schedule_end_time]];
            self.lastMeetingDateEndTime = [self dateFromTimeString:str];
            self.lastMeetingDateEndTimeString = [self dateTimeString:self.scheduleModelArray.schedule_end_time];
            self.lastMeetingDateEndTimeNoDetail = [self dateFromTimeStringNoDetail:str];
        } else {
            ScheduleModel *model = self.scheduleModelArray.recurrenceReservationList[self.row - 2];
            
            str = [NSString stringWithFormat:@"%@:%@",[self dateTimeString:model.schedule_end_time], [self hourAndSecondTimeString:model.schedule_end_time]];
            self.lastMeetingDateEndTime = [self dateFromTimeString:str];
            self.lastMeetingDateEndTimeString = [self dateTimeString:model.schedule_end_time];
            self.lastMeetingDateEndTimeNoDetail = [self dateFromTimeStringNoDetail:str];
        }
    }
    
    if(self.row == self.scheduleModelArray.recurrenceReservationList.count) {
        self.lastMeeting = YES;
    } else {
        ScheduleModel *model = self.scheduleModelArray.recurrenceReservationList[self.row];
        str = [NSString stringWithFormat:@"%@:%@",[self dateTimeString:model.schedule_start_time], [self hourAndSecondTimeString:model.schedule_start_time]];
        self.endDate = [self dateFromTimeString:str];
        
        self.endDateNoDetail = [self dateFromTimeStringNoDetail:str];
        
        NSString *nextMeetingEndTimeString = [NSString stringWithFormat:@"%@:%@",[self dateTimeString:model.schedule_end_time], [self hourAndSecondTimeString:model.schedule_end_time]];
        self.nextMeetingEndDate = [self dateFromTimeString:nextMeetingEndTimeString];
        
        self.latestBeginDate = [self.endDate dateByAddingTimeInterval:-30 * 60];
        
        str = [self dateToString:self.latestBeginDate];
        NSLog(@"-------%@-------", str);
    }
    [self updateMeetingEndTime:[self dateTimeFullString:self.scheduleModel.schedule_start_time]];
}

- (void)setupModifyView {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(32);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.frequencyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(12);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.recurrenceDetailTimeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(12);
        make.left.mas_equalTo(self.frequencyTextField.mas_right).offset(8);
        make.width.mas_equalTo(240);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.beginTimeTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.recurrenceDetailTimeTextField.mas_bottom).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.beginCanlanderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.beginTimeTextLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(24);
        make.width.mas_equalTo(207);
        make.height.mas_equalTo(36);
    }];
    
    [self.beginDetailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.beginCanlanderView.mas_right).offset(8);
        make.centerY.mas_equalTo(self.beginCanlanderView.mas_centerY);
        make.width.mas_equalTo(117);
        make.height.mas_equalTo(36);
    }];
    
    [self.timerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-32);
        make.centerY.mas_equalTo(self.beginCanlanderView.mas_centerY);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    
    [self.endTimeTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.beginCanlanderView.mas_bottom).offset(16);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.endCanlanderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.endTimeTextLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(24);
        make.width.mas_equalTo(207);
        make.height.mas_equalTo(36);
    }];
    
    [self.endDetailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.endCanlanderView.mas_right).offset(8);
        make.centerY.mas_equalTo(self.endCanlanderView.mas_centerY);
        make.width.mas_equalTo(117);
        make.height.mas_equalTo(36);
    }];
    
    [self.endTimerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-32);
        make.centerY.mas_equalTo(self.endCanlanderView.mas_centerY);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-71);
        make.left.mas_equalTo(self.view.mas_left);
        make.width.mas_equalTo(381);
        make.height.mas_equalTo(1);
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-16);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(332);
        make.height.mas_equalTo(40);
    }];
}

- (NSString *)getDefaultCurrentTimeAboutHourAndSecond {
    NSDate *theDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMinute fromDate:theDate];
    NSInteger minute = [components minute];

    // Calculate the minutes remaining until the next half-hour mark or hour
    NSInteger remainingMinutes = (15 - (minute % 15)) % 15;

    // Round up to the nearest half-hour mark or hour
    NSInteger roundedMinutes = remainingMinutes > 0 ? remainingMinutes : 15;
    NSDate *nextDate = [theDate dateByAddingTimeInterval:roundedMinutes * 60];

    // Reset the second component to 0
    NSDateComponents *newComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:nextDate];
    [newComponents setSecond:0];

    // Get the next half-hour mark or hour
    NSDate *finalDate = [calendar dateFromComponents:newComponents];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setDateFormat:@"HH:mm"];
    NSString *dateString = [formatter stringFromDate:finalDate];
    
    return dateString;
}

#pragma mark --Internal Function--
- (NSString *)dateTimeString:(NSString *)utcTimeString {
    return [self dateTimeFromUtcTimeString:utcTimeString withTimeForMatter:@"yyyy-MM-dd EE"];
}

- (NSString *)hourAndSecondTimeString:(NSString *)utcTimeString {
    return [self dateTimeFromUtcTimeString:utcTimeString withTimeForMatter:@"HH:mm"];
}

- (NSString *)dateTimeFullString:(NSString *)utcTimeString {
    return [self dateTimeFromUtcTimeString:utcTimeString withTimeForMatter:@"yyyy-MM-dd EE:HH:mm"];
}

//- (NSDate *)dateFromeUtcTimeString:()

- (NSString *)dateTimeFromUtcTimeString:(NSString *)utcTimeString withTimeForMatter:(NSString *)timeFormatter {
    NSArray *preferredLanguages = [NSLocale preferredLanguages];
    NSString *currentLanguage = preferredLanguages.firstObject;
    NSLocale *currentLocale = [NSLocale localeWithLocaleIdentifier:currentLanguage];
    
    NSTimeInterval time = [utcTimeString doubleValue] / 1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:currentLocale];
    [dateFormatter setDateFormat:timeFormatter];
    NSString *TimeDateString = [dateFormatter stringFromDate: detailDate];
    
    return TimeDateString;
}

- (FrtcDatePicker *)datePickerFormDate:(NSDate *)date {
    FrtcDatePicker *datePicker = [[FrtcDatePicker alloc] initWithFrame:NSMakeRect(0, 0, 256, 290) withDate:date];
    datePicker.datePickerDelegate = self;
    datePicker.autoresizingMask = NSViewMinYMargin;
    [self.view addSubview:datePicker];
    
    return datePicker;
}

- (NSString *)dateToString:(NSDate *)date {
    NSArray *preferredLanguages = [NSLocale preferredLanguages];
    NSString *currentLanguage = preferredLanguages.firstObject;
    NSLocale *currentLocale = [NSLocale localeWithLocaleIdentifier:currentLanguage];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:currentLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd EE:HH:mm"];
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    
    return currentDateString;
}

- (NSString *)updateToString:(NSDate *)date {
    NSArray *preferredLanguages = [NSLocale preferredLanguages];
    NSString *currentLanguage = preferredLanguages.firstObject;
    NSLocale *currentLocale = [NSLocale localeWithLocaleIdentifier:currentLanguage];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:currentLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    
    return currentDateString;
}

- (NSString *)updateToSecondString:(NSDate *)date {
    NSArray *preferredLanguages = [NSLocale preferredLanguages];
    NSString *currentLanguage = preferredLanguages.firstObject;
    NSLocale *currentLocale = [NSLocale localeWithLocaleIdentifier:currentLanguage];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:currentLocale];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    
    return currentDateString;
}

- (NSDate *)dateFromTimeString:(NSString *)timeString {
    NSArray *preferredLanguages = [NSLocale preferredLanguages];
    NSString *currentLanguage = preferredLanguages.firstObject;
    NSLocale *currentLocale = [NSLocale localeWithLocaleIdentifier:currentLanguage];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:currentLocale];
    [formatter setDateFormat:@"yyyy-MM-dd EE:HH:mm"];
    NSDate *date = [formatter dateFromString:timeString];
    
    return date;
}

- (NSDate *)dateFromTimeStringNoDetail:(NSString *)timeString {
    NSArray *array = [timeString componentsSeparatedByString:@":"];
    NSArray *preferredLanguages = [NSLocale preferredLanguages];
    NSString *currentLanguage = preferredLanguages.firstObject;
    NSLocale *currentLocale = [NSLocale localeWithLocaleIdentifier:currentLanguage];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:currentLocale];
    [formatter setDateFormat:@"yyyy-MM-dd EE"];
    NSString *str = array[0];
    NSDate *date = [formatter dateFromString:str];
    
    return date;
}

- (void)updateMeetingEndTime:(NSString *)beginTime {
    NSArray *preferredLanguages = [NSLocale preferredLanguages];
    NSString *currentLanguage = preferredLanguages.firstObject;
    NSLocale *currentLocale = [NSLocale localeWithLocaleIdentifier:currentLanguage];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setLocale:currentLocale];
    [formatter setDateFormat:@"yyyy-MM-dd EE:HH:mm"];
    NSDate *date = [formatter dateFromString:beginTime];
    NSDate *maxmumEndTime  = [[NSDate alloc] initWithTimeInterval:24 * 60 * 60 sinceDate:date];
    self.scheduleMeetingStartTime = date;
    
    NSDate *minimumEndTime = [[NSDate alloc] initWithTimeInterval:30 * 60 sinceDate:date];
    if([maxmumEndTime compare:self.endDate] == NSOrderedDescending || [[self updateToString:maxmumEndTime] isEqualToString:[self updateToString:self.endDate]]) {
        self.scheduleMeetingAllowEndTime = self.endDate;
    } else {
        self.scheduleMeetingAllowEndTime = maxmumEndTime;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:currentLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd EE:HH:mm"];
    
    if([minimumEndTime compare:self.endDate] == NSOrderedDescending) {
        minimumEndTime = [[NSDate alloc] initWithTimeInterval:15 * 60 sinceDate:date];
    }
    NSString *endMeetingTimeString = [dateFormatter stringFromDate:minimumEndTime];
    NSString *sencondEndMeetingTimeString = [dateFormatter stringFromDate:maxmumEndTime];
    
    NSLog(@"The endMeegtingTimeString is %@", endMeetingTimeString);
    NSLog(@"The secondEndMeetingTimeString is %@", sencondEndMeetingTimeString);
//
    NSArray *array = [endMeetingTimeString componentsSeparatedByString:@":"];

    self.endCanlanderView.timeTextField.stringValue = (array[0] != nil ? array[0] :@"");
    self.endDetailTextField.stringValue = [NSString stringWithFormat:@"%@:%@", array[1], array[2]];
}

- (NSString *)startTime {
    NSString *startTime =[NSString stringWithFormat:@"%@:%@",self.beginCanlanderView.timeTextField.stringValue, self.beginDetailTextField.stringValue];
    
    return [self utcTimeString:startTime];
}

- (NSDate *)timeDateWithString:(NSString *)str {
    NSArray *preferredLanguages = [NSLocale preferredLanguages];
    NSString *currentLanguage = preferredLanguages.firstObject;
    NSLocale *currentLocale = [NSLocale localeWithLocaleIdentifier:currentLanguage];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setLocale:currentLocale];

    formatter.dateFormat = @"yyyy-MM-dd EE:HH:mm";

    NSDate *date = [formatter dateFromString:str];
    
    return date;
}

- (NSString *)endTime {
    NSString *endTime =[NSString stringWithFormat:@"%@:%@",self.endCanlanderView.timeTextField.stringValue, self.endDetailTextField.stringValue];
    
    return [self utcTimeString:endTime];
}

- (NSString *)utcTimeString:(NSString *)time {
    NSArray *preferredLanguages = [NSLocale preferredLanguages];
    NSString *currentLanguage = preferredLanguages.firstObject;
    NSLocale *currentLocale = [NSLocale localeWithLocaleIdentifier:currentLanguage];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setLocale:currentLocale];

    formatter.dateFormat = @"yyyy-MM-dd EE:HH:mm";

    NSDate *date = [formatter dateFromString:time];
    UInt64 recordTime = (UInt64)([date timeIntervalSince1970] * 1000); // 客户端当前13位毫秒级时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%llu", recordTime];
 
    return timeSp;
}

#pragma mark --HoverImageViewDelegate--
- (void)hoverImageViewClickedwithSenderTag:(NSInteger)tag {
    self.popover = [[NSPopover alloc] init];
    self.popover.behavior = NSPopoverBehaviorTransient;
    
    NSRectEdge preferredPopoverEdge = NSRectEdgeMinY;
    
    if(tag == 203) {
        FrtcTimeViewController *controller = [[FrtcTimeViewController alloc] init];
        controller.delegate = self;
        controller.viewControllerTag = tag;
        controller.scheduleMeetingStartTime = self.beginSelectDate;
        if([self.beginSelectDate compare:self.beginFirstDate] == NSOrderedDescending) {
            controller.currentTimeString = @"00:15";
        } else {
            controller.currentTimeString = [self getDefaultCurrentTimeAboutHourAndSecond];
        }
        
        if([[self updateToString:self.beginSelectDate] isEqualToString:[self updateToString:self.endDate]]) {
            controller.beginLatestTime = self.beginLastDate;
            controller.beginLastDay = YES;
            controller.currentTimeString = [self updateToSecondString:self.latestBeginDate];
        } else if([[self updateToString:self.beginSelectDate] isEqualToString:[self updateToString:self.lastMeetingDateEndTime] ]) {

            controller.beginLatestTime = self.beginSelectDate;
            controller.beginLastDay = NO;
            controller.beginFirstDay = YES;
            NSDate *tempDate  = [[NSDate alloc] initWithTimeInterval:15 * 60 sinceDate:self.lastMeetingDateEndTime];
            NSString *tempString = [self updateToSecondString:tempDate];
            controller.currentTimeString = tempString;
            controller.scheduleMeetingStartTime = tempDate;
        } else {
            controller.beginLastDay = NO;
            controller.beginFirstDay = NO;
            
            controller.currentTimeString = @"00:15";
        }
    
        controller.beginTimeSheet = YES;
        self.popover.contentViewController = controller;
        [self.popover showRelativeToRect:self.timerImageView.bounds ofView:self.timerImageView preferredEdge:preferredPopoverEdge];
    } else if(tag == 204) {
        FrtcTimeViewController *controller = [[FrtcTimeViewController alloc] init];
        self.popover.contentViewController = controller;
        controller.viewControllerTag = tag;
        controller.currentTimeString = self.endDetailTextField.stringValue;
        controller.scheduleMeetingStartTime = self.scheduleMeetingStartTime;
        controller.scheduleEndDayTime = self.endCanlanderView.timeTextField.stringValue;
        controller.shceduleMeetingAllowEndTime = self.scheduleMeetingAllowEndTime;
        controller.delegate = self;
        [self.popover showRelativeToRect:self.endTimerImageView.bounds ofView:self.endTimerImageView preferredEdge:preferredPopoverEdge];
    }
}

#pragma mark --CalanderViewDelegate--
- (void)popupCalanderViewWithInterger:(NSInteger)tag {
    if(tag == 201) {
        NSDate *date = [self dateFromTimeString:[NSString stringWithFormat:@"%@:%@",self.self.beginCanlanderView.timeTextField.stringValue, self.beginDetailTextField.stringValue]];

        self.recurrenceStartDatePicker = [self datePickerFormDate:date];
        self.recurrenceStartDatePicker.datepickerTag = 203;
        [self.view addSubview:self.recurrenceStartDatePicker];
        
        [self.recurrenceStartDatePicker datePickerValidRangeFromDate:self.lastMeetingDateEndTime endDate:self.endDate wihtCurrentMeetingStartTime:date];
        
        [self.recurrenceStartDatePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.beginCanlanderView.mas_bottom).offset(8);
            make.left.mas_equalTo(24);
            make.width.mas_equalTo(256);
            make.height.mas_equalTo(290);
        }];
    } else if(tag == 202) {
        NSDate *date = [self dateFromTimeString:[NSString stringWithFormat:@"%@:%@",self.self.endCanlanderView.timeTextField.stringValue, self.endDetailTextField.stringValue]];
        self.recurrenceEndDatePicker = [self datePickerFormDate:date];
        self.recurrenceEndDatePicker.datepickerTag = 204;
        //[self.recurrenceEndDatePicker setDatePickerrangeFromDate:self.scheduleMeetingStartTime endDate:self.endDate];
        
        [self.recurrenceEndDatePicker setDatePickerrange:self.scheduleMeetingStartTime];
        [self.view addSubview:self.recurrenceEndDatePicker];
        
        [self.recurrenceEndDatePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.endCanlanderView.mas_bottom).offset(8);
            make.left.mas_equalTo(24);
            make.width.mas_equalTo(256);
            make.height.mas_equalTo(290);
        }];
    }
}



#pragma mark --FrtcDatePickerDelegate--
- (void)updateTimeString:(NSString *)timeString timeDate:(nonnull NSDate *)date type:(NSInteger)datepickerTag {
    if(datepickerTag == 204) {
        self.endCanlanderView.timeTextField.stringValue = timeString;
        if(![timeString isEqualToString:self.beginCanlanderView.timeTextField.stringValue]) {
            self.endDetailTextField.stringValue = @"00:00";
        }
        
        return;
    }
    
    if(![timeString isEqualToString:self.beginCanlanderView.timeTextField.stringValue]) {
        if([self.lastMeetingDateEndTimeString isEqualToString:timeString]) {
            NSDate *tempDate  = [[NSDate alloc] initWithTimeInterval:30 * 60 sinceDate:self.lastMeetingDateEndTime];
            NSString *tempString = [self updateToSecondString:tempDate];
            self.beginDetailTextField.stringValue = tempString;
        } else if([self.endDate compare:date] == NSOrderedSame) {
            NSString *tempString = [self updateToSecondString:self.latestBeginDate];
            self.beginDetailTextField.stringValue = tempString;
        } else {
            self.beginDetailTextField.stringValue = @"00:00";
        }
    }
    
    NSLog(@"The time String is %@", timeString);
    
    self.beginCanlanderView.timeTextField.stringValue = timeString;
    self.beginSelectDate = date;
    
    NSString *beginTimeString = [NSString stringWithFormat:@"%@:%@",self.beginCanlanderView.timeTextField.stringValue, self.beginDetailTextField.stringValue];
    NSLog(@"The begin time string is %@", beginTimeString);
    
    [self updateMeetingEndTime:beginTimeString];
}

#pragma mark --FrtcTimeViewControllerDelegate--
- (void)selectTimeValue:(NSString *)timeValue withTag:(NSInteger)tag {
    [self.popover close];
    if(tag == 203) {
        self.beginDetailTextField.stringValue = timeValue;
        
        NSString *beginTimeString = [NSString stringWithFormat:@"%@:%@",self.beginCanlanderView.timeTextField.stringValue, self.beginDetailTextField.stringValue];
        [self updateMeetingEndTime:beginTimeString];

    } else {
        self.endDetailTextField.stringValue = timeValue;
    }
}

#pragma mark --onSaveButtonPressed--
- (void)onSaveButtonPressed:(FrtcButton *)sender {
    NSDate *meetingStartDate = [self dateFromTimeString:[NSString stringWithFormat:@"%@:%@",self.self.beginCanlanderView.timeTextField.stringValue, self.beginDetailTextField.stringValue]];
    
    NSDate *meetingEndDate  = [self dateFromTimeString:[NSString stringWithFormat:@"%@:%@",self.endCanlanderView.timeTextField.stringValue, self.endDetailTextField.stringValue]];
    
    if([meetingStartDate compare:self.lastMeetingDateEndTime] == NSOrderedDescending && [meetingEndDate compare:self.endDate] == NSOrderedAscending) {
        NSString *userToken = [[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN];
        __weak __typeof(self)weakSelf = self;
        
        [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcUpdateMeetingTime:userToken
                                                                 withReservationID:self.scheduleModel.reservation_id
                                                                     withStartTime:[self startTime]
                                                                       withEndTime:[self endTime]
                   completionHandler:^(NSDictionary * _Nonnull meetingInfo) {
                       NSLog(@"Schedule a meeting success");
                            [weakSelf popupReminder:YES];

                      } failure:^(NSError * _Nonnull error) {
                          [weakSelf popupReminder:NO];
        }];
    } else {
        NSString *reminderValue;
        if([meetingStartDate compare:self.lastMeetingDateEndTime] != NSOrderedDescending) {
            reminderValue = NSLocalizedString(@"FM_MEETING_RE_MODIFY_SINGLE_MEETING_START", @"Start time cannot be earlier than the end time of the previous meeting in recurring meeting");
        } else if([meetingEndDate compare:self.endDate] != NSOrderedAscending) {
            reminderValue = NSLocalizedString(@"FM_MEETING_RE_MODIFY_SINGLE_MESSAGE_END", @"End time cannot be later than the start time of the next recurring time");
        }
        
        NSFont *font             = [NSFont systemFontOfSize:14.0f];
        NSDictionary *attributes = @{ NSFontAttributeName:font };
        CGSize size              = [reminderValue sizeWithAttributes:attributes];
        
        [self.reminderView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.centerY.mas_equalTo(self.view.mas_centerY);
            make.width.mas_equalTo(size.width + 28);
            make.height.mas_equalTo(size.height + 20);
        }];
        
        self.reminderView.tipLabel.stringValue = reminderValue;
        self.reminderView.hidden = NO;
        [self runningTimer:3.0];
    }
}

- (void)reminderTipsEvent {
    [self.reminderView setHidden:YES];
}


- (void)runningTimer:(NSTimeInterval)timeInterval {
    self.reminderTipsTimer = [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(reminderTipsEvent) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.reminderTipsTimer forMode:NSRunLoopCommonModes];
}

- (void)popupReminder:(BOOL)isSuccess {
    NSString *reminderValue;
    if(isSuccess) {
        reminderValue = NSLocalizedString(@"FM_MODIFY_MEETING_SUCCESS", @"Modified successfully");
    } else {
        reminderValue = NSLocalizedString(@"FM_MODIFY_MEETING_FAILURE", @"Modified failure");;
    }
    
    NSFont *font             = [NSFont systemFontOfSize:14.0f];
    NSDictionary *attributes = @{ NSFontAttributeName:font };
    CGSize size              = [reminderValue sizeWithAttributes:attributes];
    
    [self.reminderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.width.mas_equalTo(size.width + 28);
        make.height.mas_equalTo(size.height + 20);
    }];
    
    self.reminderView.tipLabel.stringValue = reminderValue;
    self.reminderView.hidden = NO;
    [self runningTimer:3.0];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(modifyMeetingSuccess:)]) {
        [self.delegate modifyMeetingSuccess:isSuccess];
    }
}

#pragma mark --getter load--
- (NSTextField *)titleTextField {
    if (!_titleTextField) {
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:20 weight:NSFontWeightSemibold];
        _titleTextField.alignment = NSTextAlignmentLeft;
        _titleTextField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.stringValue = NSLocalizedString(@"FM_MEETING_RE_MODIFY_SHCEDULE_MEETING", @"Edit Meeting");
        [self.view addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (NSTextField *)frequencyTextField {
    if (!_frequencyTextField) {
        _frequencyTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _frequencyTextField.backgroundColor = [NSColor clearColor];
        _frequencyTextField.font = [NSFont systemFontOfSize:13 weight:NSFontWeightRegular];
        _frequencyTextField.alignment = NSTextAlignmentLeft;
        _frequencyTextField.textColor = [NSColor colorWithString:@"#14C853" andAlpha:1.0];
        _frequencyTextField.bordered = NO;
        _frequencyTextField.editable = NO;
        _frequencyTextField.stringValue = self.strVaule;
     
        [self.view addSubview:_frequencyTextField];
    }
    
    return _frequencyTextField;
}

- (NSTextField *)recurrenceDetailTimeTextField {
    if(!_recurrenceDetailTimeTextField) {
        _recurrenceDetailTimeTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _recurrenceDetailTimeTextField.backgroundColor = [NSColor clearColor];
        _recurrenceDetailTimeTextField.font = [NSFont systemFontOfSize:13 weight:NSFontWeightRegular];
        _recurrenceDetailTimeTextField.alignment = NSTextAlignmentLeft;
        _recurrenceDetailTimeTextField.textColor = [NSColor colorWithString:@"#666666" andAlpha:1.0];
        _recurrenceDetailTimeTextField.bordered = NO;
        _recurrenceDetailTimeTextField.editable = NO;
        _recurrenceDetailTimeTextField.maximumNumberOfLines = 0;
        _recurrenceDetailTimeTextField.stringValue = @"结束于2023年10月21日 剩余5场会议";
        [self.view addSubview:_recurrenceDetailTimeTextField];
    }
    
    return _recurrenceDetailTimeTextField;
}

- (NSTextField *)beginTimeTextLabel {
    if(!_beginTimeTextLabel) {
        _beginTimeTextLabel = [self textField];
        _beginTimeTextLabel.stringValue = NSLocalizedString(@"FM_MEETING_START_TIME", @"Start Time");
        [self.view addSubview:_beginTimeTextLabel];
    }
    
    return _beginTimeTextLabel;
}

-(CanlanderView *)beginCanlanderView {
    if(!_beginCanlanderView) {
        _beginCanlanderView = [[CanlanderView alloc] initWithFrame:CGRectMake(0, 0, 207, 36)];
        _beginCanlanderView.viewTag = 201;
        _beginCanlanderView.calanlerViewDelegate = self;
        [self.view addSubview:_beginCanlanderView];
    }
    
    return _beginCanlanderView;;
}

- (NSTextField *)endTimeTextLabel {
    if(!_endTimeTextLabel) {
        _endTimeTextLabel = [self textField];
        _endTimeTextLabel.stringValue = NSLocalizedString(@"FM_MEETING_END_TIME", @"End time");
        [self.view addSubview:_endTimeTextLabel];
    }
    
    return _endTimeTextLabel;
}

- (CanlanderView *)endCanlanderView {
    if(!_endCanlanderView) {
        _endCanlanderView = [[CanlanderView alloc] initWithFrame:CGRectMake(0, 0, 207, 36)];
        _endCanlanderView.viewTag = 202;
        _endCanlanderView.calanlerViewDelegate = self;
        [self.view addSubview:_endCanlanderView];
    }
    
    return _endCanlanderView;;
}

- (FrtcDefaultTextField *)beginDetailTextField {
    if (!_beginDetailTextField) {
        _beginDetailTextField = [[FrtcDefaultTextField alloc] initWithFrame:CGRectMake(0, 0, 207, 36)];
        
        // 按照24小时制，不需要在前面加上前缀：上午或下午
        NSDate *theDate = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSCalendarUnitMinute fromDate:theDate];
        NSInteger minute = [components minute];

        // Calculate the minutes remaining until the next half-hour mark or hour
        NSInteger remainingMinutes = (15 - (minute % 15)) % 15;

        // Round up to the nearest half-hour mark or hour
        NSInteger roundedMinutes = remainingMinutes > 0 ? remainingMinutes : 15;
        NSDate *nextDate = [theDate dateByAddingTimeInterval:roundedMinutes * 60];

        // Reset the second component to 0
        NSDateComponents *newComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:nextDate];
        [newComponents setSecond:0];

        // Get the next half-hour mark or hour
        NSDate *finalDate = [calendar dateFromComponents:newComponents];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [formatter setDateFormat:@"HH:mm"];
        NSString *dateString = [formatter stringFromDate:finalDate];
        NSLog(@"beginDetailTextField: %@", dateString);
        [_beginDetailTextField setFormatter:formatter];
        _beginDetailTextField.stringValue = dateString;
        _beginDetailTextField.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
        [self.view addSubview:_beginDetailTextField];
    }
    
    return _beginDetailTextField;
}

- (HoverImageView *)timerImageView {
    if(!_timerImageView) {
        _timerImageView = [[HoverImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        _timerImageView.delegate = self;
        _timerImageView.tag = 203;
        _timerImageView.image = [NSImage imageNamed:@"icon-timer"];
        [self.view addSubview:_timerImageView];
    }
    
    return _timerImageView;
}

- (FrtcDefaultTextField *)endDetailTextField {
    if (!_endDetailTextField) {
        _endDetailTextField = [[FrtcDefaultTextField alloc] initWithFrame:CGRectMake(0, 0, 207, 36)];
        //按照24小时制，不需要在前面加上前缀：上午或下午
        NSDate *currentDate = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];

        // Get the minute component of the current date
        NSDateComponents *components = [calendar components:NSCalendarUnitMinute fromDate:currentDate];
        NSInteger minute = [components minute];

        // Calculate the minutes remaining until the next half-hour mark or hour
        NSInteger remainingMinutes = 30 - (minute % 30);

        // Add the remaining minutes to the current date
        NSDate *nextDate = [currentDate dateByAddingTimeInterval:remainingMinutes * 60];

        // Round up to the nearest half-hour mark or hour
        NSDateComponents *newComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:nextDate];
        [newComponents setSecond:0];

        NSInteger minuteComponent = [newComponents minute];
        NSInteger roundingValue = (minuteComponent >= 30) ? 60 - minuteComponent : 30 - minuteComponent;
        NSDate *finalDate = [calendar dateByAddingUnit:NSCalendarUnitMinute value:roundingValue toDate:nextDate options:0];

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [formatter setDateFormat:@"HH:mm"];
        NSString *dateString = [formatter stringFromDate:finalDate];
        NSLog(@"endDetailTextField: %@", dateString);
        
        _endDetailTextField.stringValue = dateString;
        
        
//        NSString *beginTimeString = [NSString stringWithFormat:@"%@:%@",self.beginTimeTextField.stringValue, self.beginDetailTextField.stringValue];
//        [formatter setDateFormat:@"yyyy-MM-dd EE:HH:mm"];
//        NSDate *date = [formatter dateFromString:beginTimeString];
//        nextDate = [[NSDate alloc] initWithTimeInterval:30 * 60 sinceDate:date];
//        dateString = [formatter stringFromDate:nextDate];
//        
//        NSArray *array = [dateString componentsSeparatedByString:@":"];
//        _endDetailTextField.stringValue = [NSString stringWithFormat:@"%@:%@", array[1], array[2]];
        _endDetailTextField.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
        [self.view addSubview:_endDetailTextField];
    }
    
    return _endDetailTextField;
}

- (HoverImageView *)endTimerImageView {
    if(!_endTimerImageView) {
        _endTimerImageView = [[HoverImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        _endTimerImageView.tag = 204;
        _endTimerImageView.delegate = self;
        _endTimerImageView.image = [NSImage imageNamed:@"icon-timer"];
        [self.view addSubview:_endTimerImageView];
    }
    
    return _endTimerImageView;
}

- (NSView *)line {
    if(!_line) {
        _line = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
        _line.wantsLayer = YES;
        _line.layer.backgroundColor = [NSColor colorWithString:@"#EEEFF0" andAlpha:1.0].CGColor;
        [self.view addSubview:_line];
    }
    
    return _line;
}

- (FrtcButton *)saveButton {
    if (!_saveButton) {
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_MEETING_RE_SAVE_MODIFY", @"Modify") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_MEETING_JOIN", @"Join") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        _saveButton = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 332, 36) withNormalMode:normalMode withHoverMode:hoverMode];
        _saveButton.target = self;
        _saveButton.action = @selector(onSaveButtonPressed:);
        [self.view addSubview:_saveButton];
    }
    
    return _saveButton;
}

- (CallResultReminderView *)reminderView {
    if(!_reminderView) {
        _reminderView = [[CallResultReminderView alloc] initWithFrame:CGRectMake(0, 0, 172, 40)];
        _reminderView.tipLabel.stringValue = @"账号或密码不正确";
        _reminderView.hidden = YES;
        
        [self.view addSubview:_reminderView];
    }
    
    return _reminderView;
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


@end
