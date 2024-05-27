#import "FrtcLocalReminderManagement.h"
#import "FrtcLocalReminderWindowController.h"

#import <EventKit/EventKit.h> //for iCal


@interface FrtcLocalReminderManagement ()

@property (nonatomic, strong) FrtcLocalReminderWindowController *frtcLocalReminderWindowController;

@end


static FrtcLocalReminderManagement *localReminderManagement = nil;

@implementation FrtcLocalReminderManagement


#pragma mark -- Lify Cycle --

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localReminderManagement = [[FrtcLocalReminderManagement alloc] init];
    });
    return localReminderManagement;
}

- (instancetype)init {
    if (self = [super init]) {
        self.enableReceiveReminder = NO;
        self.frtcLocalReminderWindowController = [[FrtcLocalReminderWindowController alloc] init];
        self.reminderWindowDelegate = self.frtcLocalReminderWindowController;
        
        self.upcomingMeetingArray = [NSMutableArray array];
        self.upcomingAlertTimeArray = [NSMutableArray array];
        self.upcomingAlertTimeMeetingsDict = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (void)releaseInstance {
    //NSLog(@"[%s]", __func__);
    if (localReminderManagement != nil) {
        localReminderManagement.frtcLocalReminderWindowController = nil;
        localReminderManagement = nil;
    }
}

- (void)dealloc {
    //NSLog(@"[%s] ", __func__);
    if (_alertTimer) {
        [_alertTimer invalidate];
        _alertTimer = nil;
    }
    if (nil != _upcomingMeetingArray) {
        [_upcomingMeetingArray removeAllObjects];
        _upcomingMeetingArray = nil;
    }
    if (nil != _upcomingAlertTimeArray) {
        [_upcomingAlertTimeArray removeAllObjects];
        _upcomingAlertTimeArray = nil;
    }
    if (nil != _upcomingAlertTimeArray) {
        // Remove all objects from the upcomingDict dictionary
        NSArray *allKeys = [_upcomingAlertTimeMeetingsDict allKeys];
        for (NSDate *key in allKeys) {
            NSMutableArray *array = [_upcomingAlertTimeMeetingsDict objectForKey:key];
            [array removeAllObjects];
        }
        // Release the upcomingDict dictionary
        _upcomingAlertTimeMeetingsDict = nil;
    }
}


#pragma mark -- Reminder Data and Logic --

- (void)setScheduledModelArrayForShowOnPopWindow:(ScheduledModelArray *) aScheduledModelArray {
    //NSLog(@"[%s]: ", __func__);
    self.scheduledModelArray = aScheduledModelArray;
    [self updateReminderWindow];
}

- (void)getScheduledModelArrayForShowOnPopWindow_new {
    //NSLog(@"[%s]: ", __func__);
    NSMutableArray<ScheduleModel *> *allSchedules = [NSMutableArray arrayWithArray:self.scheduledModelArray.meeting_schedules];
    NSMutableArray<ScheduleModel *> *nearSchedules = [NSMutableArray array];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd KK:mm"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentDateString = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *currentTime = [dateFormatter dateFromString:currentDateString];
    
    //filter: schedule meeting will start in 5 minutes.
    for (ScheduleModel *schedule in allSchedules) {
        // Convert the Unix timestamp to an NSDate object
        NSTimeInterval timestamp = [schedule.schedule_start_time doubleValue] / 1000.0;
        NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:timestamp];
        NSTimeInterval timeInterval = [startTime timeIntervalSinceDate:currentTime];
        
        if (0 <= timeInterval  && timeInterval <= (60 * 5)) { // 300 seconds = 5 minutes
            // Add the schedule to the "nearSchedules" array
            ScheduleModel *newSchedule = [[ScheduleModel alloc] init];
            newSchedule.meeting_name = schedule.meeting_name;
            newSchedule.meeting_number = schedule.meeting_number;
            newSchedule.meeting_password = schedule.meeting_password;
            newSchedule.meeting_type = schedule.meeting_type;
            newSchedule.owner_id = schedule.owner_id;
            newSchedule.owner_name = schedule.owner_name;
            newSchedule.recurrence_gid = schedule.recurrence_gid;
            newSchedule.recurrence_type = schedule.recurrence_type;
            newSchedule.reservation_id = schedule.reservation_id;
            newSchedule.schedule_end_time = schedule.schedule_end_time;
            newSchedule.schedule_start_time = schedule.schedule_start_time;
            newSchedule.meeting_url = schedule.meeting_url;
            
            [nearSchedules addObject:schedule];
        }
    }
    
    self.reminderShowScheduledModelArray = [NSMutableArray arrayWithArray:nearSchedules];
    //NSLog(@"[%s]: reminderShowScheduledModelArray.count: %d", __func__, (int)self.reminderShowScheduledModelArray.count);
}
    
- (void)getScheduledModelArrayForShowOnPopWindow {
    //NSLog(@"[%s][%d]: ", __func__, __LINE__);
    //[self removeExpiredMeetings]; // remove all ended-meeting.

    [self.upcomingMeetingArray removeAllObjects];
    [self.upcomingAlertTimeArray removeAllObjects];
    [self.upcomingAlertTimeMeetingsDict removeAllObjects];
    
    NSMutableArray<ScheduleModel *> *allSchedules = [NSMutableArray arrayWithArray:self.scheduledModelArray.meeting_schedules];
    //NSMutableArray<ScheduleModel *> *nearSchedules = [NSMutableArray array];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd KK:mm"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentDateString = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *currentTime = [dateFormatter dateFromString:currentDateString];
    
    for (ScheduleModel *schedule in allSchedules) {
        // Convert the Unix timestamp to an NSDate object
        NSTimeInterval timestamp = [schedule.schedule_start_time doubleValue] / 1000.0;
        NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:timestamp];
        NSTimeInterval endTimerTimestamp = [schedule.schedule_start_time doubleValue] / 1000.0;
        NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:endTimerTimestamp];
        
        NSTimeInterval timeIntervalStart = [startTime timeIntervalSinceDate:currentTime];
        NSTimeInterval timeIntervalEnd = [startTime timeIntervalSinceDate:currentTime];

        if (timeIntervalEnd <= 0) {
            // The meeting has ended, there is no need to remind, remove from the upcoming array.
            [self.upcomingMeetingArray removeObject:schedule];
            continue;
        }
        if (timeIntervalStart <= 0) {
            // The meeting has already begun, no need to remind.
            continue;
        }
        if (timeIntervalStart <= 20 * 60) {
            //NSLog(@"[%s][%d]: will start in 20 minutes, add to self.upcomingMeetings & self.upcomingAlerts, schedule.meeting_number: %@", __func__, __LINE__, schedule.meeting_number);
            //[self showSchedulMeetingInfo:schedule];
            
            
            [self.upcomingMeetingArray addObject:schedule];
            
            // get reminder time and store to upcomingDict
            NSDate *alertTime = [startTime dateByAddingTimeInterval:-5 * 60];
            //self.upcomingDict[alertTime] = schedule;
            //[self.upcomingAlerts addObject:alertTime];
            
            [self addSchedule:schedule withAlertTime:alertTime];
        }
    }

    if (self.upcomingMeetingArray.count > 0) {
        // If there is an upcoming meeting, sort the reminder times in upcomeAlerts,
        // then start timing and wait for the meeting reminder time
        self.upcomingAlertTimeArray = [[self.upcomingAlertTimeArray sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
        [self startAlertTimer];
    } else {
        // If there are no upcoming meetings, return.
    }
}

- (void)addSchedule:(ScheduleModel *)scheduleMeeting withAlertTime:(NSDate *)alertTime {
    //NSLog(@"[%s][%d]: %@, scheduleMeeting", __func__, __LINE__, alertTime);
    //1.store the alertTime.
    [self.upcomingAlertTimeArray addObject:alertTime];

    //2.store the schedule meetings, maybe there are some meeting's start time is the same as alertTime, so use array.
    // Retrieve the existing array of schedules for the alert time, or create a new one if none exists
    NSMutableArray *upcomingSchedulesArray = [self.upcomingAlertTimeMeetingsDict objectForKey:alertTime];
    if (!upcomingSchedulesArray) {
        upcomingSchedulesArray = [NSMutableArray array];
        [self.upcomingAlertTimeMeetingsDict setObject:upcomingSchedulesArray forKey:alertTime];
    }

    // Add the new schedule to the array
    [upcomingSchedulesArray addObject:scheduleMeeting];
}

- (NSMutableArray *)getScheduleMeetingWithAlertTime:(NSDate *)alertTime {
    // Retrieve the array of schedules for the alert time, or return an empty array if none exists
    NSMutableArray *upcomingSchedulesArray = [self.upcomingAlertTimeMeetingsDict objectForKey:alertTime];
    if (!upcomingSchedulesArray) {
        upcomingSchedulesArray = [NSMutableArray array];
    }

    return upcomingSchedulesArray;
}

- (void)startAlertTimer {
    //NSLog(@"[%s][%d]: ", __func__, __LINE__);
    
    // If there is already a timer running, stop it first
    if (_alertTimer) {
        [_alertTimer invalidate];
        _alertTimer = nil;
    }
    
    // Get the latest reminder time
    NSDate *nextAlertTime = [self.upcomingAlertTimeArray firstObject];
    
    // If there is a reminder time, start timing
    if (nextAlertTime) {
        //NSLog(@"[%s][%d]: ", __func__, __LINE__);
        NSTimeInterval timeInterval = [nextAlertTime timeIntervalSinceNow];
        self.alertTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(showAlertWindow) userInfo:nil repeats:NO];
    }
}

- (void)showAlertWindow {
    //NSLog(@"[%s][%d]: ", __func__, __LINE__);

    // Obtain the latest reminder time and remove the corresponding meeting from the reminder list and dictionary
    NSDate *nextAlertTime = [self.upcomingAlertTimeArray firstObject];
    //ScheduleModel *scheduleMeeting = self.upcomingDict[nextAlertTime];
    NSMutableArray *upcomingSchedulesArray = [self getScheduleMeetingWithAlertTime:nextAlertTime];
        
    //remove those schedule meetings at the current alertTime, and prepare for the next alertTime.
    //[self.upcomingMeetings removeObject:scheduleMeeting];
    if (upcomingSchedulesArray.count > 0) {
        [self.upcomingMeetingArray removeObject:upcomingSchedulesArray];
    }
    
    [self.upcomingAlertTimeArray removeObject:nextAlertTime];
    [self.upcomingAlertTimeMeetingsDict removeObjectForKey:nextAlertTime];

    //NSLog(@"[%s][%d]: add to reminder window to show, nextAlertTime: %@", __func__, __LINE__, nextAlertTime);

    // add meeting and show reminder
    [self showAlertWindowWithMeeting:upcomingSchedulesArray];

    // restart the timer
    [self startAlertTimer];
}

- (void)showAlertWindowWithMeeting:(NSMutableArray *)meetings {
    [self.frtcLocalReminderWindowController addReminderMeeting:meetings];
}

- (void)closeReminderWindow {
    //NSLog(@"[%s][%d]: ", __func__, __LINE__);

//    if (self.reminderWindowController) {
//        [self.reminderWindowController close];
//        self.reminderWindowController = nil;
//    }
}

- (void)removeExpiredMeetings {
    //NSLog(@"[%s][%d]: ", __func__, __LINE__);

//    NSMutableArray *expiredMeetings = [NSMutableArray array];
//    for (Meeting *meeting in self.upcomingMeetings) {
//        NSDate *endTime = meeting.endTime;
//        NSTimeInterval timeIntervalEnd = [endTime timeIntervalSinceNow];
//        if (timeIntervalEnd <= 0) {
//            // 会议已经结束，从提醒列表中移除
//            [expiredMeetings addObject:meeting];
//        }
//    }
//    [self.upcomingMeetings removeObjectsInArray:expiredMeetings];
}

- (void)showSchedulMeetingInfo:(ScheduleModel *)schedule {
    // Set up the date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    //[Note]: verify those data.
    //int i = 0;

    // Convert the Unix timestamp to an NSDate object
    NSTimeInterval startTimestamp = [schedule.schedule_start_time doubleValue] / 1000.0;
    NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:startTimestamp];
    
    // Convert the NSDate object to a formatted string
    NSString *startTimeString = [dateFormatter stringFromDate:startTime];
    
    // Convert the Unix timestamp to an NSDate object
    NSTimeInterval endTimestamp = [schedule.schedule_end_time doubleValue] / 1000.0;
    NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:endTimestamp];
    
    // Convert the NSDate object to a formatted string
    NSString *endTimeString = [dateFormatter stringFromDate:endTime];
}

- (void)updateReminderWindow {
    //NSLog(@"[UI][%s]: -> call getScheduledModelArray", __func__);
    
    [self getScheduledModelArrayForShowOnPopWindow];
}

- (void)enableOrDisableReceiveMeetingReminder:(BOOL)enable {
    if (YES == self.isEnableReceiveReminder && NO == enable) {
        [self setEnableReceiveReminder:enable];
        
        //stop timer
        //NSLog(@"[%s][Receive reminder]: user select: enable: %@ -> close reminder window, and stop timer...", __func__, enable?@"YES":@"NO");
        [self showOrHideMeetingReminderWindow:NO];
        
        if ([self.reminderWindowJoinMeetingDelegate respondsToSelector:@selector(enableOrDisableReceiveReminder:)]) {
            //NSLog(@"[%s]: setScheduledModelArray:", __func__);
            [self.reminderWindowJoinMeetingDelegate enableOrDisableReceiveReminder:enable];
        } else {
            NSLog(@"[%s]: delegate not respond with enableOrDisableReceiveReminder:", __func__);
        }
        
    } else if (NO == self.isEnableReceiveReminder && YES == enable) {
        [self setEnableReceiveReminder:enable];
        
        //start timer
        //NSLog(@"[%s][Receive reminder]: user select: enable: %@ -> start timer..., will show reminder window", __func__, enable?@"YES":@"NO");
        if ([self.reminderWindowJoinMeetingDelegate respondsToSelector:@selector(enableOrDisableReceiveReminder:)]) {
            [self.reminderWindowJoinMeetingDelegate enableOrDisableReceiveReminder:enable];
        } else {
            NSLog(@"[%s]: delegate not respond with enableOrDisableReceiveReminder:", __func__);
        }
    }
}

- (void)showOrHideMeetingReminderWindow:(BOOL)enable {
    if (self.reminderWindowDelegate && [self.reminderWindowDelegate respondsToSelector:@selector(showOrHideMeetingReminderWindow:)]) {
        [self.reminderWindowDelegate showOrHideMeetingReminderWindow:enable];
    } else {
        NSLog(@"[%s]: delegate not respond with showOrHideMeetingReminderWindow:", __func__);
    }
}

@end
