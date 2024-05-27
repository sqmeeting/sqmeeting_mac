#import "FrtcTimeViewController.h"
#import "FrtcTimeViewControllerCell.h"

@interface FrtcTimeViewController () <NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic, strong) NSScrollView   *backGoundView;
@property (nonatomic, strong) NSTableView    *timeListTableView;

@property (nonatomic, strong) NSArray *timeArray;
//@property (nonatomic, copy)   NSString *currentTimeString;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign, getter=isDifferentDay) BOOL differentDay;

@end

@implementation FrtcTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self frtcTimeViewControllerLayout];
    self.timeArray = @[@"00:00", @"00:15", @"00:30", @"00:45", @"01:00", @"01:15", @"01:30", @"01:45",
                       @"02:00", @"02:15", @"02:30", @"02:45", @"03:00", @"03:15", @"03:30", @"03:45",
                       @"04:00", @"04:15", @"04:30", @"04:45", @"05:00", @"05:15", @"05:30", @"05:45",
                       @"06:00", @"06:15", @"06:30", @"06:45", @"07:00", @"07:15", @"07:30", @"07:45",
                       @"08:00", @"08:15", @"08:30", @"08:45", @"09:00", @"09:15", @"09:30", @"09:45",
                       @"10:00", @"10:15", @"10:30", @"10:45", @"11:00", @"11:15", @"11:30", @"11:45",
                       @"12:00", @"12:15", @"12:30", @"12:45", @"13:00", @"13:15", @"13:30", @"13:45",
                       @"14:00", @"14:15", @"14:30", @"14:45", @"15:00", @"15:15", @"15:30", @"15:45",
                       @"16:00", @"16:15", @"16:30", @"16:45", @"17:00", @"17:15", @"17:30", @"17:45",
                       @"18:00", @"18:15", @"18:30", @"18:45", @"19:00", @"19:15", @"19:30", @"19:45",
                       @"20:00", @"20:15", @"20:30", @"20:45", @"21:00", @"21:15", @"21:30", @"21:45",
                       @"22:00", @"22:15", @"22:30", @"22:45", @"23:00", @"23:15", @"23:30", @"23:45"];
    
    if(self.isBeginTimeSheet) {
        [self setBeginTimeSheetConfig];
    } else {
        [self setEndTimeSheetConfig];
    }
    
    [self.timeListTableView reloadData];
    
    NSInteger scrollVerticalLength = [self.timeArray indexOfObject:self.currentTimeString];
    if(scrollVerticalLength > 10) {
        [_backGoundView.documentView scrollPoint:NSMakePoint(0, 20 * (self.currentIndex - 10)  + 5 * (self.currentIndex - 10) + 25 * 5 )];
    }
}

- (void)setBeginTimeSheetConfig {
    NSCalendar *selectCalendar = [NSCalendar currentCalendar];
    NSDateComponents *selectComponents = [selectCalendar components:NSCalendarUnitDay | NSCalendarUnitMinute fromDate:self.scheduleMeetingStartTime];
    NSInteger selectDay = [selectComponents day];
    
    self.currentIndex = [self.timeArray indexOfObject:self.currentTimeString];
    
    self.scheduleMeetingStartTime = [[NSDate alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay | NSCalendarUnitMinute fromDate:self.scheduleMeetingStartTime];
    NSInteger minute = [components minute];
    NSInteger currentDay = [components day];
    
    if(currentDay != selectDay) {
        self.differentDay = YES;
    }
    
    if(!self.isDifferentDay) {
        // Calculate the minutes remaining until the next half-hour mark or hour
        NSInteger remainingMinutes = (15 - (minute % 15)) % 15;
        
        // Round up to the nearest half-hour mark or hour
        NSInteger roundedMinutes = remainingMinutes > 0 ? remainingMinutes : 15;
        NSDate *nextDate = [self.scheduleMeetingStartTime dateByAddingTimeInterval:roundedMinutes * 60];
        
        // Reset the second component to 0
        NSDateComponents *newComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:nextDate];
        [newComponents setSecond:0];
        
        // Get the next half-hour mark or hour
        NSDate *finalDate = [calendar dateFromComponents:newComponents];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [formatter setDateFormat:@"HH:mm"];
        NSString *reasonableTimeString = [formatter stringFromDate:finalDate];
        NSInteger reasonableIndex  = [self.timeArray indexOfObject:reasonableTimeString];
        
        if(self.currentIndex < reasonableIndex) {
            self.currentIndex = reasonableIndex;
            self.currentTimeString = reasonableTimeString;
        }
    }
}

- (void)setEndTimeSheetConfig {
    NSInteger reasonableIndex  = [self.timeArray indexOfObject:self.currentTimeString];
    
    if(self.currentIndex < reasonableIndex) {
        self.currentIndex = reasonableIndex;
       // self.currentTimeString = reasonableTimeString;
    }
}

#pragma mark --layout
- (void)frtcTimeViewControllerLayout {
    [self.backGoundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(272);
    }];
}

- (NSDate *)timeFromString:(NSString *)string {
    NSArray *preferredLanguages = [NSLocale preferredLanguages];
    
    // Use the first language in the preferred languages array
    NSString *currentLanguage = preferredLanguages.firstObject;
    
    // Create an NSLocale with the current language identifier
    NSLocale *currentLocale = [NSLocale localeWithLocaleIdentifier:currentLanguage];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd EE:HH:mm"];
    [formatter setLocale:currentLocale];
        //NSString转NSDate
    NSDate *date = [formatter dateFromString:string];
    
    return date;
}

- (NSString *)dateToString:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd EE:HH:mm"];
        //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    return currentDateString;

}

#pragma mark --<NSTableViewDelegate, NSTableViewDataSource>--
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.timeArray.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    FrtcTimeViewControllerCell *cell = [tableView makeViewWithIdentifier:@"FrtcInviteUserListViewCell" owner:self];
    if(cell == nil) {
        cell = [[FrtcTimeViewControllerCell alloc] init];
    }
        
    cell.userNameTextField.stringValue = self.timeArray[row];
    NSLog(@"The test string is %@", self.timeArray[row]);
    if(!self.isBeginTimeSheet) {
        NSString *time = [NSString stringWithFormat:@"%@:%@", self.scheduleEndDayTime, self.timeArray[row]];
        NSLog(@"The time is %@", time);
       
        NSDate *date = [self timeFromString:time];
        NSLog(@"The current date string is %@", [self dateToString:self.scheduleMeetingStartTime]);
        if([date compare:self.scheduleMeetingStartTime] == NSOrderedAscending || [date compare:self.shceduleMeetingAllowEndTime] == NSOrderedDescending ) {
            NSLog(@"111111");
            cell.canSelected = NO;
            cell.userNameTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:0.3];
        } else {
            if([date compare:self.scheduleMeetingStartTime] == NSOrderedSame || [date compare:self.shceduleMeetingAllowEndTime] == NSOrderedSame) {
                cell.canSelected = NO;
                cell.userNameTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:0.3];
            } else {
                NSLog(@"2222222");
                cell.canSelected = YES;
                cell.userNameTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
            }
        }
        

        return cell;
    }
    
    if(self.isDifferentDay) {
        if(self.isBeginLastDay) {
            if(row <= [self.timeArray indexOfObject:self.currentTimeString]) {
                cell.canSelected = YES;
                cell.userNameTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
            } else {
                cell.canSelected = NO;
                cell.userNameTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:0.3];
            }
        } else if(self.isBeginFirstDay) {
            if(row < [self.timeArray indexOfObject:self.currentTimeString]) {
                cell.canSelected = NO;
                cell.userNameTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:0.3];
            } else {
                cell.canSelected = YES;
                if(row == [self.timeArray indexOfObject:self.currentTimeString]) {
                    cell.userNameTextField.textColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0];
                } else {
                    cell.userNameTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
                }
            }
        }
        else {
            cell.canSelected = YES;
            if(row == [self.timeArray indexOfObject:self.currentTimeString]) {
                cell.userNameTextField.textColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0];
            } else {
                cell.userNameTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
            }
        }
    } else {
        if(row < [self.timeArray indexOfObject:self.currentTimeString]) {
            cell.canSelected = NO;
            cell.userNameTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:0.3];
        } else {
            cell.canSelected = YES;
            if(row == [self.timeArray indexOfObject:self.currentTimeString]) {
                cell.userNameTextField.textColor = [NSColor colorWithString:@"#026FFE" andAlpha:1.0];
            } else {
                cell.userNameTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
            }
        }
    }
   
    return cell;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 20;
}

-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row  {
//    if(!self.isDifferentDay && row < [self.timeArray indexOfObject:self.currentTimeString]) {
//        return NO;
//    }
    FrtcTimeViewControllerCell* cell = (FrtcTimeViewControllerCell*)[self.timeListTableView viewAtColumn:0 row:row makeIfNecessary:NO];
    
    if(!cell.isCanSelected) {
        return NO;
    }

    if(self.delegate && [self.delegate respondsToSelector:@selector(selectTimeValue:withTag:)]) {
        [self.delegate selectTimeValue:cell.userNameTextField.stringValue withTag:self.viewControllerTag];
    }
    
    return NO;
}

#pragma mark --lazy load
- (NSScrollView *) backGoundView {
    if (!_backGoundView) {
        _backGoundView = [[NSScrollView alloc] init];
        _backGoundView.documentView = self.timeListTableView;
        [[_backGoundView contentView] setPostsBoundsChangedNotifications:YES];
        _backGoundView.hasVerticalScroller = YES;
        _backGoundView.hasHorizontalScroller = NO;
        _backGoundView.scrollerStyle = NSScrollerStyleOverlay;
        _backGoundView.scrollerKnobStyle = NSScrollerKnobStyleDark;
        _backGoundView.scrollsDynamically = YES;
        _backGoundView.autohidesScrollers = NO;
        _backGoundView.verticalScroller.hidden = NO;
        _backGoundView.horizontalScroller.hidden = YES;
        _backGoundView.automaticallyAdjustsContentInsets = NO;
        //_backGoundView.verticalPageScroll = 100;
        _backGoundView.backgroundColor = [NSColor whiteColor];
        //[_backGoundView.documentView scrollPoint:NSMakePoint(200,500)];
        [self.view addSubview:_backGoundView];
    }

    return _backGoundView;
}

- (NSTableView *)timeListTableView {
    if(!_timeListTableView) {
        _timeListTableView = [[NSTableView alloc] initWithFrame:NSMakeRect(5, 0, 90, 272)];
        NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@""];
        [_timeListTableView addTableColumn:column];
        
        _timeListTableView.delegate = self;
        _timeListTableView.dataSource = self;
        _timeListTableView.gridStyleMask = NSTableViewGridNone;
        _timeListTableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
        [_timeListTableView setIntercellSpacing:NSMakeSize(0, 5)];
        _timeListTableView.allowsColumnReordering = NO;
        [_timeListTableView setHeaderView:nil];
        _timeListTableView.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] whiteColor];
        _timeListTableView.focusRingType = NSFocusRingTypeNone;
        _timeListTableView.translatesAutoresizingMaskIntoConstraints = YES;
        
        if(@available(macos 11.0, *)) {
            _timeListTableView.style = NSTableViewStylePlain;
        }
        [self.view addSubview:_timeListTableView];
        [_timeListTableView reloadData];
    }
    
    return _timeListTableView;
}

@end
