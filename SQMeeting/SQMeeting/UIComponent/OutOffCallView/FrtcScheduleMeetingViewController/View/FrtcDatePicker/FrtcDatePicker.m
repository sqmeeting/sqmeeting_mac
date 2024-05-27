#import "FrtcDatePicker.h"

@interface FrtcDatePicker ()

@property (nonatomic, strong) NSDate *rangeBeginDate;

@property (nonatomic, strong) NSDate *rangeEndDate;

@end

@implementation FrtcDatePicker

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    NSColor *color = self.backgroundColor;
    [color setFill];
    //[dirtyRect fill];
}

- (instancetype)initWithFrame:(NSRect)frameRect withDate:(NSDate *)date {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        //self.calendar;
        self.wantsLayer = YES;
        [self setupView];
        self.dateValue = date;
        self.currentMonthLabel = [[NSTextField alloc] initWithFrame:NSZeroRect];
        self.monthBackButton = [[NSButton alloc] initWithFrame:NSZeroRect];
        self.monthForwardButton = [[NSButton alloc] initWithFrame:NSZeroRect];
        self.currentHeight = 0;
        self.font = [NSFont systemFontOfSize:12.0];
        self.titleFont = [NSFont boldSystemFontOfSize:12.0];
        self.firstDayOfWeek = 2;
        self.lineHeight = [FrtcDatePicker lineHeightForFont:self.font];
        self.markedDates = [NSMutableArray array];
        self.weekdays = [NSMutableArray array];
        self.weekdayLabels = [NSMutableArray array];
        self.days = [NSMutableArray array];
        
        self.calendar = [NSCalendar currentCalendar];
        self.dateUnitMask = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
        self.dateTimeUnitMask = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay|NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        
        self.backgroundColor = [NSColor whiteColor];
        self.font = [NSFont systemFontOfSize:13.0];
        self.titleFont = [NSFont boldSystemFontOfSize:14.0];
        
        
        // Text color
        self.textColor = [NSColor blackColor];
        self.todayTextColor = [NSColor redColor];
        self.selectedTextColor = [NSColor whiteColor];
        
        // Markers
        self.markColor = [NSColor darkGrayColor];
        self.todayMarkColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0];
        self.selectedMarkColor = [NSColor whiteColor];
        
        // Today
        self.todayBackgroundColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0];
        self.todayBorderColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0];
        
        // Selection
        //self.selectedBackgroundColor = [NSColor lightGrayColor];
        self.selectedBackgroundColor = [NSColor colorWithString:@"#6AAAFE" andAlpha:1.0];
        //self.selectedBorderColor = [NSColor lightGrayColor];
        self.selectedBorderColor = [NSColor colorWithString:@"#6AAAFE" andAlpha:1.0];
        
        // Next & previous month days
        self.nextMonthTextColor = [NSColor grayColor];
        self.previousMonthTextColor = [NSColor grayColor];
        self.previousMonthTextColor = [NSColor colorWithString:@"#CCCCCC" andAlpha:1.0];
        self.highlightedBackgroundColor =  [NSColor colorWithWhite:0.95 alpha:1.0];
        self.highlightedBorderColor =  [NSColor colorWithWhite:0.95 alpha:1.0];
        
        [self addMouseDownEvent];
        [self configurePicker];
    }
    
    return self;
}

- (void)addMouseDownEvent {
    [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskLeftMouseDown handler:^NSEvent*_Nullable(NSEvent *event) {
            switch (event.type) {
                case NSEventTypeLeftMouseDown:
                {
                    NSPoint locationInView = [self convertPoint:[event locationInWindow] fromView:nil];
                    BOOL isMouseIn = [self mouse:locationInView inRect:self.bounds];
                    if (isMouseIn) {
                        //NSLog(@"Do nothing");
                    } else {
                        [self removeFromSuperview];
                    }
                }
                    break;
                default:
                    break;
            }
        return event;
    }];
}

- (void)setupView {
    self.backgroundColor = [NSColor whiteColor];
    self.layer.backgroundColor = self.backgroundColor.CGColor;
    self.font = [NSFont systemFontOfSize:13.0];
    self.titleFont = [NSFont boldSystemFontOfSize:14.0];
    
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
    self.layer.cornerRadius = 4;
    
    
    // Text color
    self.textColor = [NSColor blackColor];
    self.todayTextColor = [NSColor redColor];
    self.selectedTextColor = [NSColor whiteColor];
    
    // Markers
    self.markColor = [NSColor darkGrayColor];
    self.todayMarkColor = [NSColor redColor];
    self.selectedMarkColor = [NSColor whiteColor];
    
    // Today
    self.todayBackgroundColor = [NSColor redColor];
    self.todayBorderColor = [NSColor redColor];
    
    // Selection
    self.selectedBackgroundColor = [NSColor lightGrayColor];
    self.selectedBorderColor = [NSColor lightGrayColor];
    
    // Next & previous month days
    self.nextMonthTextColor = [NSColor grayColor];
    self.previousMonthTextColor = [NSColor grayColor];;
    
    // 'Mouse-over' highlight
    self.highlightedBackgroundColor =  [NSColor colorWithWhite:0.95 alpha:1.0];
    self.highlightedBorderColor =  [NSColor colorWithWhite:0.95 alpha:1.0];
}

- (BOOL)isFlipped {
    return YES;
}

+ (CGFloat)lineHeightForFont:(NSFont *)font {
    return 16.0;
}

+ (BOOL)isEqualDay:(NSDateComponents *)dateComponents anotherDate:(NSDate *)anotherDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *anotherDateComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:anotherDate];
    
    if(dateComponents.day == anotherDateComponents.day && dateComponents.month == anotherDateComponents.month && dateComponents.year == anotherDateComponents.year) {
        return YES;
    } else {
        return NO;
    }
}

- (void)configurePicker {
    self.calendar.firstWeekday = self.firstDayOfWeek;
    self.firstDayComponents = [self firstDayOfMonthForDate:self.dateValue];
    [self configureDateFormatter];
    [self configureWeekdays];
    [self configureViewAppearance];
    [self doLayout];
}

- (void)configureViewAppearance {
    [self updateCurrentMonthLabel];
    
    self.currentMonthLabel.editable = NO;
    self.currentMonthLabel.backgroundColor = [NSColor clearColor];
    self.currentMonthLabel.bordered = NO;
    self.currentMonthLabel.alignment = NSTextAlignmentCenter;
    self.currentMonthLabel.font = self.titleFont;
    self.currentMonthLabel.textColor = self.textColor;
    
    [self addSubview:self.currentMonthLabel];
    
    self.monthBackButton.title = @"<";
    self.monthBackButton.alignment = NSTextAlignmentCenter;
    ((NSButtonCell *)(self.monthBackButton.cell)).bezelStyle = NSBezelStyleCircular;
    self.monthBackButton.target = self;
    self.monthBackButton.action = @selector(monthBackAction:);
    [self addSubview:self.monthBackButton];
    
    self.monthForwardButton.title = @">";
    self.monthForwardButton.alignment = NSTextAlignmentCenter;((NSButtonCell *)(self.monthBackButton.cell)).bezelStyle = NSBezelStyleCircular;
    self.monthForwardButton.target = self;
    self.monthForwardButton.action = @selector(monthForwardAction:);
    [self addSubview:self.monthForwardButton];
    
    for(NSTextField *textField in self.weekdayLabels) {
        [textField removeFromSuperview];
    }
    
    [self.weekdayLabels removeAllObjects];
    for(int i = 0; i < 7; i++) {
        NSString *weekday = [self weekdayNameForColumn:i];
        NSTextField *weekdayLabel = [[NSTextField alloc] initWithFrame:NSZeroRect];
        weekdayLabel.font = self.font;
        weekdayLabel.textColor = self.textColor;
        weekdayLabel.editable = NO;
        weekdayLabel.backgroundColor = [NSColor clearColor];
        weekdayLabel.bordered = NO;
        weekdayLabel.alignment = NSTextAlignmentCenter;
        weekdayLabel.stringValue = weekday;
        
        [self.weekdayLabels addObject:weekdayLabel];
        [self addSubview:weekdayLabel];
    }
    
    [self updateDaysView];
    
}

- (void)monthForwardAction:(NSButton *)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];

    NSString *currentDateStr = [dateFormatter stringFromDate: self.dateValue];
    NSLog(@"Before forward action The current Date String is %@", currentDateStr);
    self.firstDayComponents = [self oneMonthLaterDayForDay:self.firstDayComponents];
    [self updateCurrentMonthLabel];
    [self updateDaysView];
    
    if(self.isNeedDisableSomeDay) {
        [self updateRangeDate];
    }
    
    if(self.isRangeOfSomeDay) {
        [self updateTimeRange];
    }
}

- (void)monthBackAction:(NSButton *)sender {
    self.firstDayComponents = [self oneMonthEarlierDayForDay:self.firstDayComponents];
    [self updateCurrentMonthLabel];
    [self updateDaysView];
    
    if(self.isNeedDisableSomeDay) {
        [self updateRangeDate];
    }
    
    if(self.isRangeOfSomeDay) {
        [self updateTimeRange];
    }
}

- (NSDateComponents *)oneMonthLaterDayForDay:(NSDateComponents *)dateComponents {
    NSDateComponents *newDateComponents = [[NSDateComponents alloc] init];
    newDateComponents.day = dateComponents.day;
    newDateComponents.month = dateComponents.month + 1;
    newDateComponents.year = dateComponents.year;
    
    NSDate *oneMonthLaterDay = [self.calendar dateFromComponents:newDateComponents];
    return [self.calendar components:self.dateUnitMask fromDate:oneMonthLaterDay];
}

- (NSDateComponents *)oneMonthEarlierDayForDay:(NSDateComponents *)dateComponents {
    NSDateComponents *newDateComponents = [[NSDateComponents alloc] init];
    newDateComponents.day = dateComponents.day;
    newDateComponents.month = dateComponents.month - 1;
    newDateComponents.year = dateComponents.year;
    
    NSDate *oneMonthLaterDay = [self.calendar dateFromComponents:newDateComponents];
    return [self.calendar components:self.dateUnitMask fromDate:oneMonthLaterDay];
}

- (void)highLighterCurrentDay:(FrtcDatePickerView *)day {
    if([FrtcDatePicker isEqualDay:day.dateComponents anotherDate:self.dateValue]) {
        if([FrtcDatePicker isEqualDay:day.dateComponents anotherDate:[[NSDate alloc] init]]) {
            day.selectedBackgroundColor = self.todayBackgroundColor;
            day.selectedBorderColor = self.todayBorderColor;
        } else {
            day.selectedBackgroundColor = self.selectedBackgroundColor;
            day.selectedBorderColor = self.selectedBorderColor;
        }
        
        day.selectedTextColor = self.selectedTextColor;
        day.label.textColor = day.selectedTextColor;
        day.markColor = self.selectedMarkColor;
        [day setDayViewSelected:YES];
        day.selected = YES;
    }
}

- (BOOL)compareDay:(FrtcDatePickerView *)day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
   
    NSDateComponents *todayComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[[NSDate alloc] init]];
    
    if(todayComponents.year > day.dateComponents.year) {
        day.textColor = self.previousMonthTextColor;
        day.label.textColor = day.textColor;
        return NO;
    } else if(todayComponents.year < day.dateComponents.year) {
        day.textColor = self.textColor;
        day.label.textColor = day.textColor;
        return YES;
    } else {
        if(todayComponents.month > day.dateComponents.month) {
            day.textColor = self.previousMonthTextColor;
            day.label.textColor = day.textColor;
            
            return NO;
        } else if(todayComponents.month == day.dateComponents.month) {
            if(day.dateComponents.day < todayComponents.day) {
                day.textColor = self.previousMonthTextColor;
                day.label.textColor = day.textColor;
                return NO;
            } else if(day.dateComponents.day > todayComponents.day) {
                day.textColor = self.textColor;
                day.label.textColor = day.textColor;
            }
        } else {
            day.textColor = self.textColor;
            day.label.textColor = day.textColor;
            return YES;
            
        }
    }
    
    return YES;
}

- (BOOL)equalDateCompontens:(NSDateComponents *)dateComponents withAnohterComponents:(NSDateComponents *)anotherDateComponents {
    if(dateComponents.day == anotherDateComponents.day && dateComponents.month == anotherDateComponents.month && dateComponents.year == anotherDateComponents.year) {
        return YES;
    } else {
        return NO;
    }
}

- (void)updateTimeRange {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd EE:HH:mm"];

    NSString *begintDateString = [dateFormatter stringFromDate:self.rangeBeginDate];
    NSString *currentDateString = [dateFormatter stringFromDate:self.rangeEndDate];
    
    NSLog(@"----------------");
    NSLog(@"The begint time is %@, and the latest time is %@", begintDateString, currentDateString);
    NSLog(@"----------------");
    
    NSDateComponents *dateValueFromComponents = [self.calendar components:self.dateUnitMask fromDate:self.rangeBeginDate];
    
    NSDate *dateValueFrom = [self.calendar dateFromComponents:dateValueFromComponents];
    if(self.rangeEndDate != nil) {
        NSDateComponents *dateValueEndComponents = [self.calendar components:self.dateUnitMask fromDate:self.rangeEndDate];
        NSDate *dateValueEnd = [self.calendar dateFromComponents:dateValueEndComponents];
        
        NSLog(@"dateValueFromComponents' day is %ld, month is %ld, year is %ld", dateValueFromComponents.day, dateValueFromComponents.month, dateValueFromComponents.year);
        
        NSLog(@"dateValueEndComponents' day is %ld, month is %ld, year is %ld", dateValueEndComponents.day, dateValueEndComponents.month, dateValueEndComponents.year);
        
        for(FrtcDatePickerView *dayView in self.days) {
            dayView.selected = NO;
            __block FrtcDatePickerView *weakDay = dayView;
            dayView.dayHighlightedAction = ^(BOOL highlighted) {
                [weakDay setViewHighlighted:NO];
            };
            NSDate *oneMonthLaterDay = [self.calendar dateFromComponents:dayView.dateComponents];
            
            if([oneMonthLaterDay compare:dateValueFrom] == NSOrderedAscending
               || [oneMonthLaterDay compare:dateValueEnd] == NSOrderedDescending
               /*|| [oneMonthLaterDay compare:dateValueEnd] == NSOrderedSame*/) {
                dayView.label.textColor = self.previousMonthTextColor;
                dayView.daySelectedAction = ^(){
                    
                };
            } else {
                dayView.label.textColor = self.textColor;
                dayView.layer.backgroundColor = [NSColor whiteColor].CGColor;
                
                __block FrtcDatePickerView *weakDay = dayView;
                dayView.dayHighlightedAction = ^(BOOL highlighted) {
                    [weakDay setViewHighlighted:highlighted];
                };
            }
        }
    } else {
        for(FrtcDatePickerView *dayView in self.days) {
            dayView.selected = NO;
            __block FrtcDatePickerView *weakDay = dayView;
            dayView.dayHighlightedAction = ^(BOOL highlighted) {
                [weakDay setViewHighlighted:NO];
            };
            NSDate *oneMonthLaterDay = [self.calendar dateFromComponents:dayView.dateComponents];
            
            if([oneMonthLaterDay compare:dateValueFrom] == NSOrderedAscending) {
                dayView.label.textColor = self.previousMonthTextColor;
                dayView.daySelectedAction = ^(){
                    
                };
            } else {
                dayView.label.textColor = self.textColor;
                dayView.layer.backgroundColor = [NSColor whiteColor].CGColor;
                
                __block FrtcDatePickerView *weakDay = dayView;
                dayView.dayHighlightedAction = ^(BOOL highlighted) {
                    [weakDay setViewHighlighted:highlighted];
                };
            }
        }
    }
}

- (void)datePickerValidRangeFromDate:(NSDate *)beginDate endDate:(NSDate *)endDate wihtCurrentMeetingStartTime:(NSDate *)meetingStartTime {
    if(beginDate == nil) {
        self.rangeBeginDate = meetingStartTime;
    } else {
        self.rangeBeginDate = beginDate;
    }
    
    self.rangeEndDate   = endDate;
    self.rangeOfSomeDay = YES;
    [self updateTimeRange];
}

- (void)setDatePickerrangeFromDate:(NSDate *)date endDate:(NSDate *)endDate {
    NSDate *currentDate = [NSDate date];
    
    if([date compare:currentDate] == NSOrderedAscending) {
        self.rangeBeginDate = currentDate;
    } else {
        self.rangeBeginDate = date;
    }
    
    self.rangeEndDate = endDate;
    self.rangeOfSomeDay = YES;
    
    [self updateTimeRange];
}

- (void)updateRangeDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd EE:HH:mm"];
//    NSString *begintDateString = [dateFormatter stringFromDate:self.rangeBeginDate];
//    NSString *currentDateString = [dateFormatter stringFromDate:self.rangeEndDate];
// 
    NSDateComponents *dateValueFromComponents = [self.calendar components:self.dateUnitMask fromDate:self.rangeBeginDate];
    
    NSDateComponents *dateValueEndComponents = [self.calendar components:self.dateUnitMask fromDate:self.rangeEndDate];
    
//    NSDate *dateValueFrom = [self.calendar dateFromComponents:dateValueFromComponents];
//    NSDate *dateValueEnd = [self.calendar dateFromComponents:dateValueEndComponents];
//    
    for(FrtcDatePickerView *dayView in self.days) {
        dayView.selected = NO;
        __block FrtcDatePickerView *weakDay = dayView;
        dayView.dayHighlightedAction = ^(BOOL highlighted) {
            [weakDay setViewHighlighted:NO];
        };
        
//        NSDate *oneMonthLaterDay = [self.calendar dateFromComponents:dayView.dateComponents];
//
//        if([oneMonthLaterDay compare:dateValueFrom] == NSOrderedAscending
//           || [oneMonthLaterDay compare:dateValueEnd] == NSOrderedDescending) {
//            dayView.label.textColor = self.previousMonthTextColor;
//            dayView.daySelectedAction = ^(){
//               
//            };
//        } else {
//            dayView.label.textColor = self.textColor;
//            dayView.layer.backgroundColor = [NSColor whiteColor].CGColor;
//            
//            __block FrtcDatePickerView *weakDay = dayView;
//            dayView.dayHighlightedAction = ^(BOOL highlighted) {
//                [weakDay setViewHighlighted:highlighted];
//            };
//        }
        if(![self equalDateCompontens:dayView.dateComponents withAnohterComponents:dateValueFromComponents]) {
            dayView.label.textColor = self.previousMonthTextColor;
            dayView.daySelectedAction = ^(){
               
            };
        } else {
            dayView.label.textColor = self.textColor;
            dayView.layer.backgroundColor = [NSColor whiteColor].CGColor;
            
            __block FrtcDatePickerView *weakDay = dayView;
            dayView.dayHighlightedAction = ^(BOOL highlighted) {
                [weakDay setViewHighlighted:highlighted];
            };
            
            if(dateValueEndComponents != dateValueFromComponents) {
                dateValueFromComponents = dateValueEndComponents;
            }
        }
    }
}

- (void)setDatePickerrange:(NSDate *)beginDate {
    self.rangeBeginDate = beginDate;
    self.rangeEndDate = [[NSDate alloc] initWithTimeInterval:23 * 60 * 60 sinceDate:self.rangeBeginDate];
    self.needDisableSomeDay = YES;

    [self updateRangeDate];
}

- (void)updateDaysView {
    for(FrtcDatePickerView *dayView in self.days) {
        [dayView removeFromSuperview];
    }
    
    [self.days removeAllObjects];
    
    NSUInteger daysInMonth = [self daysCountInMonthForDay:self.firstDayComponents];
    NSDateComponents *dateComponents = self.firstDayComponents;
    NSInteger firstWkDay = self.firstDayComponents.weekday;
    
    NSInteger visibledaysPreviousMonth = firstWkDay - self.firstDayOfWeek;
    if(visibledaysPreviousMonth < 0) {
        visibledaysPreviousMonth += 7;
    }
    
    visibledaysPreviousMonth *= -1;
    
    for(NSInteger index = visibledaysPreviousMonth; index < 0; index++) {
        NSDateComponents *dayComponents = [self dayByAddingDays:index fromDate:self.firstDayComponents];
        FrtcDatePickerView *day = [[FrtcDatePickerView alloc] initWithDateComponents:dayComponents];
        
        day.backgroundColor = self.backgroundColor;
        day.font = self.font;
        day.textColor = self.previousMonthTextColor;
        day.label.textColor = day.textColor;
        day.highlightedBorderColor = self.highlightedBorderColor;
        day.highlightedBackgroundColor = self.highlightedBackgroundColor;
        day.markColor = self.markColor;
        
        for(NSDate *markedDate in self.markedDates) {
            if([FrtcDatePicker isEqualDay:day.dateComponents anotherDate:markedDate]) {
                day.marked = YES;
            }
        }
        
        if([FrtcDatePicker isEqualDay:day.dateComponents anotherDate:[[NSDate alloc] init]]) {
            day.textColor = self.todayTextColor;
            day.label.textColor = day.textColor;
            day.markColor = self.todayMarkColor;
        }
        
        BOOL isValid = [self compareDay:day];
        
        [self highLighterCurrentDay:day];
        
        __block FrtcDatePickerView *weakDay = day;
        day.dayHighlightedAction = ^(BOOL highlighted) {
            if(isValid) {
                [weakDay setViewHighlighted:highlighted];
            }
        };
        
        // Selected day callback action
        __weak __typeof(self)weakSelf = self;
        day.daySelectedAction = ^(){
            if(isValid) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf monthBackAction:nil];
                NSDateComponents *dateComponents = weakDay.dateComponents;
                NSDateComponents *dateValueComponents = [strongSelf.calendar components:self.dateTimeUnitMask fromDate:self.dateValue];
                dateComponents.hour = dateValueComponents.hour;
                dateComponents.minute = dateValueComponents.minute;
                dateComponents.second = dateValueComponents.second;
                
                NSDate *dateValue = [strongSelf.calendar dateFromComponents:dateComponents];
                strongSelf.dateValue = dateValue;
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy-MM-dd EE";
                
                NSString *dateString = [formatter stringFromDate:strongSelf.dateValue];
                if(strongSelf.datePickerDelegate && [strongSelf.datePickerDelegate respondsToSelector:@selector(updateTimeString:timeDate:type:)]) {
                    [strongSelf.datePickerDelegate updateTimeString:dateString timeDate:weakSelf.dateValue type:weakSelf.datepickerTag];
                    [strongSelf removeFromSuperview];
                }
                
                [strongSelf updateDaysView];
            }
        };
        [self.days addObject:day];
        [self addSubview:day];
    }
    
    for(int i = 0; i < daysInMonth; i++) {
        FrtcDatePickerView *day = [[FrtcDatePickerView alloc] initWithDateComponents:dateComponents];
        day.backgroundColor = self.backgroundColor;
        
        day.highlightedBorderColor = self.highlightedBorderColor;
        day.highlightedBackgroundColor = self.highlightedBackgroundColor;
        day.todayBorderColor = self.todayBorderColor;
        day.font = self.font;
        day.textColor = self.textColor;
        day.markColor = self.markColor;
      
        if([FrtcDatePicker isEqualDay:day.dateComponents anotherDate:[[NSDate alloc] init]]) {
            day.textColor = self.todayTextColor;
            day.label.textColor = day.textColor;
            day.markColor = self.todayMarkColor;
        }
        
        BOOL isValid = [self compareDay:day];
        
        __block FrtcDatePickerView *weakDay = day;
        day.dayHighlightedAction = ^(BOOL highlighted) {
            if(isValid) {
                [weakDay setViewHighlighted:highlighted];
            }
        };
        
        // Selected day callback action
        __weak __typeof(self)weakSelf = self;
        day.daySelectedAction = ^(){
            if(isValid) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                NSDateComponents *dateComponents = weakDay.dateComponents;
                NSDateComponents *dateValueComponents = [strongSelf.calendar components:self.dateTimeUnitMask fromDate:self.dateValue];
                dateComponents.hour = dateValueComponents.hour;
                dateComponents.minute = dateValueComponents.minute;
                dateComponents.second = dateValueComponents.second;
                
                NSDate *dateValue = [strongSelf.calendar dateFromComponents:dateComponents];
                strongSelf.dateValue = dateValue;
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy-MM-dd EE";
                
                NSString *dateString = [formatter stringFromDate:strongSelf.dateValue];
                if(strongSelf.datePickerDelegate && [strongSelf.datePickerDelegate respondsToSelector:@selector(updateTimeString:timeDate:type:)]) {
                    [strongSelf.datePickerDelegate updateTimeString:dateString timeDate:self.dateValue type:strongSelf.datepickerTag];
                    [strongSelf removeFromSuperview];
                }
                
                [strongSelf updateDaysView];
                
            }
        };
    
        for(NSDate *markedDate in self.markedDates) {
            if([FrtcDatePicker isEqualDay:day.dateComponents anotherDate:markedDate]) {
                day.marked = YES;
            }
        }
    
        [self highLighterCurrentDay:day];
        
        [self.days addObject:day];
        [self addSubview:day];
        dateComponents = [self dayByAddingDays:1 fromDate:dateComponents];
    }
    
    NSInteger visibleDayNextMonth = self.firstDayOfWeek + 7 - dateComponents.weekday;
    
    if(visibleDayNextMonth > 7) {
        visibleDayNextMonth -= 7;
    }
    
    for (int i = 1; i <= visibleDayNextMonth; i++) {
        FrtcDatePickerView *day = [[FrtcDatePickerView alloc] initWithDateComponents:dateComponents];
        day.backgroundColor = self.backgroundColor;
        day.font = self.font;
        //day.textColor = self.nextMonthTextColor;
        day.textColor = self.textColor;
        day.label.textColor = day.textColor;
        day.highlightedBorderColor = self.highlightedBorderColor;
        day.highlightedBackgroundColor = self.highlightedBackgroundColor;
        day.markColor = self.markColor;
        
        for(NSDate *markedDate in self.markedDates) {
            if([FrtcDatePicker isEqualDay:day.dateComponents anotherDate:markedDate]) {
                day.marked = YES;
            }
        }
        
        if([FrtcDatePicker isEqualDay:day.dateComponents anotherDate:[[NSDate alloc] init]]) {
            day.textColor = self.todayTextColor;
            day.label.textColor = day.textColor;
            day.markColor = self.todayMarkColor;
        }
        
        BOOL isValid = [self compareDay:day];
        
        __block FrtcDatePickerView *weakDay = day;
        day.dayHighlightedAction = ^(BOOL highlighted) {
            if(isValid) {
                [weakDay setViewHighlighted:highlighted];
            }
        };
        
        // Selected day callback action
        __weak __typeof(self)weakSelf = self;
        day.daySelectedAction = ^(){
            if(isValid) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf monthForwardAction:nil];
                NSDateComponents *dateComponents = weakDay.dateComponents;
                NSDateComponents *dateValueComponents = [strongSelf.calendar components:self.dateTimeUnitMask fromDate:self.dateValue];
                dateComponents.hour = dateValueComponents.hour;
                dateComponents.minute = dateValueComponents.minute;
                dateComponents.second = dateValueComponents.second;
                
                NSDate *dateValue = [strongSelf.calendar dateFromComponents:dateComponents];
                strongSelf.dateValue = dateValue;
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy-MM-dd EE";
                
                NSString *dateString = [formatter stringFromDate:strongSelf.dateValue];
                if(strongSelf.datePickerDelegate && [strongSelf.datePickerDelegate respondsToSelector:@selector(updateTimeString:timeDate:type:)]) {
                    [strongSelf.datePickerDelegate updateTimeString:dateString timeDate:self.dateValue type:strongSelf.datepickerTag];
                    [strongSelf removeFromSuperview];
                }
                
                [strongSelf updateDaysView];
            }
            
        };
        
        [self highLighterCurrentDay:day];
        
        [self.days addObject:day];
        [self addSubview:day];
        dateComponents = [self dayByAddingDays:1 fromDate:dateComponents];
    }

    [self doLayout];
}

- (void)doLayout {
    CGFloat margin = 40;
    self.currentMonthLabel.frame = NSMakeRect(margin, 10, self.bounds.size.width - 2 * margin, 30);
    self.monthBackButton.frame = NSMakeRect(0, 0, 38, 39);
    self.monthForwardButton.frame = NSMakeRect(self.bounds.size.width - 38, 0, 38, 39);
    
    CGFloat labelWidth = floor(self.bounds.size.width / 7);
    CGFloat currentX = 0.0;
    CGFloat currentY = NSMaxY(self.currentMonthLabel.frame) + 10.0;
    
    for(NSTextField *weekdayLabel in self.weekdayLabels) {
        weekdayLabel.frame = NSMakeRect(currentX, currentY, labelWidth, self.lineHeight);
        
        if(weekdayLabel.frame.size.height > self.lineHeight) {
            self.lineHeight = weekdayLabel.frame.size.height;
        }
        
        currentX += labelWidth;
    }
    
    NSInteger dayViewWidth = (NSInteger)labelWidth;
    NSInteger dayViewHeight = dayViewWidth;
    
    NSInteger originY = (NSInteger)(currentY + self.lineHeight);
    BOOL nextLine = NO;
    
    for(FrtcDatePickerView *dayView in self.days) {
        if(nextLine) {
            nextLine = NO;
            originY += dayViewHeight;
        }
        
        NSInteger weekday = dayView.dateComponents.weekday;
        NSInteger column = [self columnForWeekday:weekday];
        
        NSInteger originX = dayViewWidth * column;
        
        dayView.frame = NSMakeRect(originX, originY, dayViewWidth, dayViewHeight);
            
        if(column == 6) {
            nextLine = YES;
            originX = 0;
        } else {
            originX += dayViewWidth;
        }
    }
    
    originY += dayViewHeight;
    
    if(originY != self.currentHeight) {
        self.currentHeight = originY;
        
//        if let delegate = self.delegate {
//            delegate.nmDatePicker?(self, newSize: NSMakeSize(self.bounds.size.width, CGFloat(originY)))
//            
//        }
    }
    
}

- (NSDateComponents *)dayByAddingDays:(NSInteger)days fromDate:(NSDateComponents *)anotherDate {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    dateComponents.day = anotherDate.day + days;
    dateComponents.month = anotherDate.month;
    dateComponents.year = anotherDate.year;
    
    NSDate *day = [self.calendar dateFromComponents:dateComponents];
    
    return [self.calendar components:self.dateUnitMask fromDate:day];
}

- (NSUInteger)daysCountInMonthForDay:(NSDateComponents *)dateComponents {
    NSDate * date= [self.calendar dateFromComponents:dateComponents];
    NSRange range = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    
    return range.length;
}

- (void)updateCurrentMonthLabel {
    self.currentMonthLabel.stringValue = [self monthAndYearForDay:self.firstDayComponents];

}

- (NSString *)monthAndYearForDay:(NSDateComponents *)dateComponents {
    NSInteger year = dateComponents.year;
    NSInteger month = dateComponents.month;
    NSArray<NSString *> *months = self.dateFormatter.standaloneMonthSymbols;
    
    NSString *monthSymbol = months[month-1];
    
    return [NSString stringWithFormat:@"\%@%ld", monthSymbol, (long)year];
}

- (void)configureWeekdays {
    NSDateFormatter *dateFormatter = self.dateFormatter;
    dateFormatter.dateFormat = @"EEEEE";
    NSTimeInterval oneDayInterval = 60 * 60 * 24;
    
    NSDate *now = [[NSDate alloc] init];
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:now];
    
    NSDateComponents *dayComponents = [[NSDateComponents alloc] init];
    
    dayComponents.hour = 12;
    dayComponents.weekday = 1;
    dayComponents.weekdayOrdinal = 1;
    dayComponents.month = components.month;
    dayComponents.year = components.year;
    
    NSDate *day = [calendar dateFromComponents:dayComponents];
    
    for (int i = 0; i < 7; i++) {
        NSString * daySymbol = [dateFormatter stringFromDate:day];
        [self.weekdays addObject:daySymbol];
        day = (NSDate *)([day dateByAddingTimeInterval:oneDayInterval]);
    }
}

- (void)configureDateFormatter {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
    self.dateFormatter = formatter;
}

- (NSDateComponents *)firstDayOfMonthForDate:(NSDate *)date {
    NSDateComponents *dateComponents = [self.calendar components:self.dateUnitMask fromDate:date];
    NSInteger weekday = dateComponents.weekday;
    NSInteger day = dateComponents.day;
    NSInteger weekOffset = day % 7;
    
    dateComponents.day = 1;
    dateComponents.weekday = weekday - weekOffset + 1;
    
    if(dateComponents.weekday < 0) {
        dateComponents.weekday += 7;
    }
    
    return dateComponents;
}

- (NSString *)weekdayNameForColumn:(NSInteger)column {
    NSInteger index = column + self.firstDayOfWeek - 1;
    if(index >= 7) {
        index -= 7;
    }
    
    return self.weekdays[index];
}

- (NSInteger)columnForWeekday:(NSInteger)weekday {
    NSInteger column = weekday - self.firstDayOfWeek;
    if(column < 0 ) {
        column += 7;
    }
    
    return column;
}

@end
