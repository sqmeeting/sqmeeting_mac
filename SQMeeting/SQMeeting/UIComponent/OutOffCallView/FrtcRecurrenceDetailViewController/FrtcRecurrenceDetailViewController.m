#import "FrtcRecurrenceDetailViewController.h"
#import "FrtcRecurrenceDetailViewControllerCell.h"
#import "FrtcButton.h"
#import "FrtcAlertMainWindow.h"
#import "FrtcMeetingManagement.h"
#import "FrtcScheduleFunctionController.h"
#import "ScheduleDetailModel.h"
#import "FrtcMeetingScheduleInfoWindow.h"
#import "FrtcScheduleMeetingModifyViewController.h"
#import "FrtcMainWindow.h"
#import "FrtcScheduleDetailMeetingViewController.h"
#import "FrtcScheduleMeetingViewController.h"
#import "FrtcMainWindow.h"
#import "CallResultReminderView.h"
#import "ScheduleGroupModel.h"
#import "FrtcMeetingManagement.h"

@interface FrtcRecurrenceDetailViewController ()<NSTableViewDelegate, NSTableViewDataSource, FrtcRecurrenceDetailViewControllerCellDelegate, FrtcScheduleFunctionControllerDelegate, FrtcScheduleMeetingViewControllerDelegate, ModifySingleMeetingDelegate>

@property (nonatomic, strong) NSView *backgroundView;

@property (nonatomic, strong) NSTextField *recurrenceIntervalTextField;

@property (nonatomic, strong) NSTextField *recurrenceDetailTextField;

@property (nonatomic, strong) NSTextField *recurrenceDetailTimeTextField;

@property (nonatomic, strong) NSTableView  *recurrencMeetingTableView;

@property (nonatomic, strong) NSScrollView *recurrenceGoundView;

@property (nonatomic, strong) FrtcButton      *callButton;

@property (nonatomic, strong) FrtcButton      *copyButton;

@property (nonatomic, strong) FrtcButton      *copyButton1;

@property (nonatomic, strong) FrtcButton      *cancelButton;

@property (nonatomic, strong) FrtcButton      *removeButton;

@property (nonatomic, strong) NSMutableArray  *weekDayArray;

@property (nonatomic, strong) NSMutableArray  *monthDayArray;

@property (nonatomic, assign, getter=isClearMeeing) BOOL clearMeeting;

@property (nonatomic, strong) NSPopover *funtionPopover;

@property (nonatomic, assign) NSInteger selectedRow;

@property (nonatomic, strong) NSMutableArray<ScheduleDetailModel *> *recurrenceModelArray;

@property (nonatomic, strong) FrtcMainWindow *meetingDetailWindow;

@property (nonatomic, strong) FrtcMainWindow *scheduleWindow;

@property (nonatomic, strong) CallResultReminderView *reminderView;

@property (nonatomic, strong) NSTimer *reminderTipsTimer;



@end

@implementation FrtcRecurrenceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
    self.weekDayArray  = [NSMutableArray array];
    self.monthDayArray = [NSMutableArray array];
    
    [self setupReucrrenceDetailMeetingUI];
    
    self.titleTextField.stringValue = self.scheduleModel.meeting_name;
    [self getScheduleGroupMeetingInfo];
    [self updateReucrrenceDetailMeetingUI];
}

- (void)setupReucrrenceDetailMeetingUI {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(60);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(12);
        make.left.mas_equalTo(self.view.mas_left);
        make.width.mas_equalTo(380);
        make.height.mas_equalTo(388);
    }];
    
    [self.recurrenceIntervalTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(22);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.recurrenceDetailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(22);
        make.left.mas_equalTo(self.recurrenceIntervalTextField.mas_right).offset(6);
        make.width.mas_equalTo(250);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.recurrenceDetailTimeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.recurrenceDetailTextField.mas_bottom).offset(4);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.recurrenceGoundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.recurrenceDetailTimeTextField.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.width.mas_equalTo(348);
        make.height.mas_equalTo(324);
    }];
    
    if(self.isInvite) {
        [self.callButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.backgroundView.mas_bottom).offset(16);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(332);
            make.height.mas_equalTo(36);
        }];
        
        [self.copyButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.callButton.mas_bottom).offset(16);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(332);
            make.height.mas_equalTo(36);
        }];
    } else if(self.isAddMeeting) {
        [self.callButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.backgroundView.mas_bottom).offset(16);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(332);
            make.height.mas_equalTo(36);
        }];
        
        [self.copyButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.callButton.mas_bottom).offset(16);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(332);
            make.height.mas_equalTo(36);
        }];
        
        [self.removeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.copyButton1.mas_bottom).offset(16);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(332);
            make.height.mas_equalTo(36);
        }];
    } else {
        [self.callButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.backgroundView.mas_bottom).offset(16);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(332);
            make.height.mas_equalTo(36);
        }];
        
        [self.copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.callButton.mas_bottom).offset(16);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(332);
            make.height.mas_equalTo(36);
        }];
        
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.copyButton.mas_bottom).offset(16);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(332);
            make.height.mas_equalTo(36);
        }];
    }
}

- (void)reloadDataByMeetingGroupID:(NSString *)groupID {
    __weak __typeof(self)weakSelf = self;
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcGetScheduleMeetingGroupInformation:[[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN] withGroupID:groupID completionHandler:^(ScheduleGroupModel * _Nonnull scheduleGroupModel) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.groupModel = scheduleGroupModel;
            [strongSelf updateReucrrenceDetailMeetingUI];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"failure");
        }];
}

#pragma mark --ModifySingleMeetingDelegate--
- (void)modifyMeetingSuccess:(BOOL)isSuccess {
    if(isSuccess) {
        [self getScheduleGroupMeetingInfo];
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(updateScheduleList)]) {
            [self.delegate updateScheduleList];
        }
    }
}

- (void)getScheduleGroupMeetingInfo {
    __weak __typeof(self)weakSelf = self;
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcGetScheduleMeetingGroupInformation:[[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN] withGroupID:self.groupID completionHandler:^(ScheduleGroupModel * _Nonnull scheduleGroupModel) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.groupModel = scheduleGroupModel;
            [strongSelf updateReucrrenceDetailMeetingUI];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"failure");
    }];
}

- (void)reminderTipsEvent {
    [self.reminderView setHidden:YES];
}


- (void)runningTimer:(NSTimeInterval)timeInterval {
    self.reminderTipsTimer = [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(reminderTipsEvent) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.reminderTipsTimer forMode:NSRunLoopCommonModes];
}

- (void)getScheduleMeetingList {
    [self getScheduleGroupMeetingInfo];
}

- (void)updateReucrrenceDetailMeetingUI {
    self.recurrenceDetailTimeTextField.stringValue = [NSString stringWithFormat:NSLocalizedString(@"FM_MEETING_RE_END_DETAIL_TIME", "End on %@ %ld remaining meetings"), [[FrtcBaseImplement baseImpleSingleton] dateStringWithMonthAndDayString:self.groupModel.recurrenceEndDay], self.groupModel.meeting_schedules.count];
    if([((ScheduleModel *)(self.groupModel.meeting_schedules[0])).recurrence_type isEqualToString:@"DAILY"]) {
        if([self.groupModel.recurrenceInterval integerValue] == 1) {
            self.recurrenceIntervalTextField.stringValue = NSLocalizedString(@"FM_MEETING_RE_EVERY_DAY", @"Every Day");
            self.recurrenceDetailTextField.stringValue = NSLocalizedString(@"FM_MEETING_RE_EVERY_DAY_DETAIL", @"The meeting will repeat every day");
        } else {
            self.recurrenceIntervalTextField.stringValue = [NSString stringWithFormat:NSLocalizedString(@"FM_MEETING_RE_EVERY_SOME_DAY", "Every %@ Day"), self.groupModel.recurrenceInterval];
            self.recurrenceDetailTextField.stringValue = [NSString stringWithFormat:NSLocalizedString(@"FM_MEETING_RE_EVERY_SOME_DAY_DETAIL", "he meeting will repeat every %@ days"), self.groupModel.recurrenceInterval] ;
        }
    } else if([((ScheduleModel *)(self.groupModel.meeting_schedules[0])).recurrence_type isEqualToString:@"WEEKLY"]) {
//        [self.weekDayArray addObject:[self computeTimeToWeek:((ScheduleModel *)(self.groupModel.meeting_schedules[0])).schedule_start_time]];
//        for(ScheduleModel *model in self.groupModel.meeting_schedules) {
//            if([self.weekDayArray containsObject:[self computeTimeToWeek:model.schedule_start_time]]) {
//                break;
//            } else {
//                [self.weekDayArray addObject:[self computeTimeToWeek:model.schedule_start_time]];
//            }
//        }
        
        
        //NSString *str = self.groupModel.recurrenceDaysOfWeek[0];
        
        //NSLog(@"-------print the value--------");
        NSArray *sortArray;
        NSMutableArray *array = [NSMutableArray array];

        for(NSNumber *number in self.groupModel.recurrenceDaysOfWeek) {
            NSInteger day = 0;
            day = [number integerValue] - 1;
            
            if(day == 0) {
                day = 7;
            }
            [array addObject:[NSNumber numberWithInteger:day]];
        }

        sortArray = [array sortedArrayUsingSelector:@selector(compare:)];
        
        NSInteger weekDay = 0;
        weekDay = [sortArray[0] integerValue];

        NSString *str = [NSString stringWithFormat:@"%ld", weekDay];
        
        for(int i = 1; i < sortArray.count; i++) {
            NSInteger weekDay = 0;
            weekDay = [sortArray[i] integerValue];
                        
            str = [NSString stringWithFormat:@"%@,%ld", str, weekDay];

        }
        if([self.groupModel.recurrenceInterval integerValue] == 1) {
            self.recurrenceIntervalTextField.stringValue = NSLocalizedString(@"FM_MEETING_RE_EVERY_WEEK", @"Every Week");
            self.recurrenceDetailTextField.stringValue = [NSString stringWithFormat:NSLocalizedString(@"FM_MEETING_RE_EVERY_SOME_WEEK_DETAIL", @"The meeting will repeat every %@"), str];
            
        } else {
            self.recurrenceIntervalTextField.stringValue = [NSString stringWithFormat:NSLocalizedString(@"FM_MEETING_RE_EVERY_SOME_WEEK", "Every %@ Week"), self.groupModel.recurrenceInterval];
            self.recurrenceDetailTextField.stringValue = [NSString stringWithFormat:NSLocalizedString(@"FM_MEETING_RE_EVERY_SOME_WEEK_DETAIL", @"The meeting will repeat every %@"), str];
        }
    } else if([((ScheduleModel *)(self.groupModel.meeting_schedules[0])).recurrence_type isEqualToString:@"MONTHLY"]) {
//        [self.monthDayArray addObject:[self computeTimeToMonthDay:self.scheduleModel.schedule_start_time]];
//        for(ScheduleModel *model in self.scheduleModel.recurrenceReservationList) {
//            if([self.monthDayArray containsObject:[self computeTimeToMonthDay:model.schedule_start_time]]) {
//                break;
//            } else {
//                [self.monthDayArray addObject:[self computeTimeToMonthDay:model.schedule_start_time]];
//            }
//            
//        }
        
        NSArray *sortedArray= [self.groupModel.recurrenceDaysOfMonth sortedArrayUsingSelector:@selector(compare:)];
        NSString *str = [NSString stringWithFormat:@"%@日", sortedArray[0]];
        NSLog(@"-------print the value--------");
        //NSArray *sortedArray= [self.groupModel.recurrenceDaysOfMonth sortedArrayUsingSelector:@selector(compare:)];
        for(int i = 1; i < sortedArray.count; i++) {
            NSString *tmpStr = [NSString stringWithFormat:@"%@日", sortedArray[i]];
            str = [NSString stringWithFormat:@"%@,%@", str, tmpStr];
        }
        
        if([self.groupModel.recurrenceInterval integerValue] == 1) {
            self.recurrenceIntervalTextField.stringValue = NSLocalizedString(@"FM_MEETING_RE_EVERY_MONTH", @"Every MONTH");
            self.recurrenceDetailTextField.stringValue = [NSString stringWithFormat: NSLocalizedString(@"FM_MEETING_RE_EVERY_SOME_MONTH_DETAIL", @"The meeting will repeat every %@"), str];
        } else {
            self.recurrenceIntervalTextField.stringValue = [NSString stringWithFormat:NSLocalizedString(@"FM_MEETING_RE_EVERY_SOME_MONTH", "EVERY %@ Month"), self.groupModel.recurrenceInterval];
            self.recurrenceDetailTextField.stringValue = [NSString stringWithFormat: NSLocalizedString(@"FM_MEETING_RE_EVERY_SOME_MONTH_DETAIL", @"The meeting will repeat every %@"), str];
        }
    }
    
    [self.recurrencMeetingTableView reloadData];
}

- (NSString *)computeTimeToWeek:(NSString *)timeString {
    NSTimeInterval time = [timeString doubleValue] / 1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    
    
    //    NSCalendar *calendar = [NSCalendar currentCalendar];
    //   // [calendar setFirstWeekday:1];
    //    calendar.firstWeekday = 0;
    //    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:detailDate];
    //
    //    NSInteger day = [components weekday];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    if ([self isTodayWithTimeString:detailDate]) {
    //        [dateFormatter setDateFormat:@"a HH:mm"];
    //    } else {
    //        [dateFormatter setDateFormat:@"yyyy-MM-dd EE HH:mm"];
    //    }
    
    [dateFormatter setDateFormat:@"EE"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    
    NSLog(@"The EE is %@", currentDateStr);
    return currentDateStr;
}

- (NSString *)computeTimeToMonthDay:(NSString *)timeString {
    NSTimeInterval time = [timeString doubleValue] / 1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    
    
    //    NSCalendar *calendar = [NSCalendar currentCalendar];
    //   // [calendar setFirstWeekday:1];
    //    calendar.firstWeekday = 0;
    //    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:detailDate];
    //
    //    NSInteger day = [components weekday];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    if ([self isTodayWithTimeString:detailDate]) {
    //        [dateFormatter setDateFormat:@"a HH:mm"];
    //    } else {
    //        [dateFormatter setDateFormat:@"yyyy-MM-dd EE HH:mm"];
    //    }
    
    [dateFormatter setDateFormat:@"d"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    
    NSLog(@"The d is %@", currentDateStr);
    return currentDateStr;
}

#pragma mark --FrtcScheduleFunctionControllerDelegate--
- (void)deleteNonCurrentMeetingWithReservationID:(NSString *)reservationID withRecurrence:(BOOL)isRecurrence {
    FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_CANCEL_MEETING_ABOUT", @"Cancel Meeting") withMessage:NSLocalizedString(@"FM_CANCEL_METTING_MESSAGE", @"All participants can not join this meeting once canceled") preferredStyle:FrtcWindowAlertStyleDefault withCurrentWindow:self.view.window];
    
    __weak __typeof(self)weakSelf = self;
    FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_CANCEL_ABOUT_YES", @"YES") style:FrtcWindowAlertActionStyleOK handler:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcDeleteCurrentMeeting:[[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN] withReservationId:reservationID withCancelALL:NO deleteCompletionHandler:^{
                NSLog(@"delete meeting success!");
                //[strongSelf.recurrenceModelArray removeObjectAtIndex:self.selectedRow];
                [strongSelf getScheduleGroupMeetingInfo];
                if(strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(updateScheduleList)]) {
                [strongSelf.delegate updateScheduleList];
            }
            
        } deleteFailure:^(NSError * _Nonnull error) {
            if([error.localizedDescription isEqualToString:@"Request failed: unauthorized (401)"]) {
                FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_VERIFY_FAILURE", @"Verifyication failed") withMessage:NSLocalizedString(@"FM_RE_SIGN", @"Please sign in again") preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:self.view.window];
                
                FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
                    [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FrtcMeetingMainViewShowNotification object:nil userInfo:nil];
                }];
                [alertWindow addAction:action];
            }
        }];
        
    }];
    
   // [alertWindow addAction:action];
    [alertWindow addAction:action withTitleColor:[NSColor colorWithString:@"#E32726" andAlpha:1.0]];
    
    FrtcAlertAction *actionCancel = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_CANCEL_ABOUT", @"NO") style:FrtcWindowAlertActionStyleCancle handler:^{
    }];
    
    [alertWindow addAction:actionCancel];
}

- (void)editSelectMeetingWitReservationID:(NSString *)reservationID withRecurrence:(BOOL)isRecurrence withRow:(NSInteger)row {
    FrtcScheduleMeetingModifyViewController *modifyViewControl = [[FrtcScheduleMeetingModifyViewController alloc] init];
    modifyViewControl.delegate = self;
    modifyViewControl.row = row;
    if(row == 0) {
        modifyViewControl.scheduleModel = self.scheduleModel;
    } else {
        modifyViewControl.scheduleModel = self.scheduleModel.recurrenceReservationList[row-1];
    }
    
    modifyViewControl.scheduleModelArray = self.scheduleModel;
    FrtcMainWindow *modifyWindow = [[FrtcMainWindow alloc] initWithSize:NSMakeSize(380, 660)];
    modifyWindow.contentViewController = modifyViewControl;
    
    [modifyWindow makeKeyAndOrderFront:self];
    [modifyWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    [modifyWindow center];
    
}

- (void)editCopyMeetingWitReservationID:(NSInteger)row withReservationID:(NSString *)reservationID {
    __weak __typeof(self)weakSelf = self;
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcGetScheduleMeetingDetailInformation:[[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN] withReservationID:reservationID completionHandler:^(ScheduleSuccessModel * meetingDetailModel) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf popupScheduleMeeingInfoWithInfoModel:meetingDetailModel];
        
        
    } failure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSLog(@"%@", error);
        FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_VERIFY_FAILURE", @"Verifyication failed") withMessage:NSLocalizedString(@"FM_RE_SIGN", @"Please sign in again") preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:strongSelf.view.window];
        
        FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
            [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FrtcMeetingMainViewShowNotification object:nil userInfo:nil];
        }];
        [alertWindow addAction:action];
    }];
}

- (void)viewDetailRecurrenceWithReservationID:(NSInteger)row {
    
}

#pragma mark --Internal Function--
- (void)popupScheduleMeeingInfoWithInfoModel:(ScheduleSuccessModel *)model {
    FrtcMeetingScheduleInfoWindow *scheduledInfoWindow = [[FrtcMeetingScheduleInfoWindow alloc] initWithSize:NSMakeSize(388, 410) withSuccessfulSchedule:NO];
    
    [scheduledInfoWindow setupMeetingInfo:model];
    [scheduledInfoWindow makeKeyAndOrderFront:self];
    [scheduledInfoWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    scheduledInfoWindow.titleVisibility       = NSWindowTitleHidden;
    
    [scheduledInfoWindow showWindowWithWindow:self.view.window];
}

#pragma mark --FrtcRecurrenceDetailViewControllerCellDelegate--
- (void)popUpFunctionControllerWithFrame:(NSRect)frame withRow:(NSInteger)row {
    FrtcScheduleFunctionController *controller = [[FrtcScheduleFunctionController alloc] init];
    controller.delegate         = self;
    controller.row              = row;
    self.selectedRow            = row;
    controller.needView         = NO;

    controller.reservationID    = ((ScheduleModel *)(self.groupModel.meeting_schedules[row])).reservation_id;
    controller.meetingType      = ((ScheduleModel *)(self.groupModel.meeting_schedules[row])).meeting_type;
    
    self.funtionPopover = [[NSPopover alloc] init];
    self.funtionPopover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];
    
    self.funtionPopover.contentViewController = controller;
    self.funtionPopover.behavior = NSPopoverBehaviorTransient;
    
    FrtcRecurrenceDetailViewControllerCell* cell = (FrtcRecurrenceDetailViewControllerCell*)[_recurrencMeetingTableView viewAtColumn:0 row:row makeIfNecessary:NO];
    // controller.overTime = cell.overTime;
    
    [self.funtionPopover showRelativeToRect:frame ofView:cell preferredEdge:NSRectEdgeMinY];
}

#pragma mark -- For --<NSTableViewDelegate, NSTableViewDataSource>-- Internal Function
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.groupModel.meeting_schedules.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    FrtcRecurrenceDetailViewControllerCell *cell = [tableView makeViewWithIdentifier:@"FrtcRecurrenceDetailViewControllerCell" owner:self];
   
    
    if(cell == nil) {
        cell = [[FrtcRecurrenceDetailViewControllerCell alloc] initWithFrame:CGRectMake(0, 0, 348, 40)];
        cell.identifier = @"FrtcRecurrenceDetailViewControllerCell";
    }
    
    cell.cellTag    = row;
    cell.row        = row;
    cell.invite     = self.isInvite;
    cell.addMeeting = self.isAddMeeting;
    
    cell.delegate = self;
    if(row % 2 == 0) {
        cell.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
    } else {
        cell.layer.backgroundColor = [NSColor colorWithString:@"#F9F9F9" andAlpha:1.0].CGColor;
    }
    
    NSString *meetingStartTime;
    NSString *meetingEndTime;
    NSTimeInterval endTime;
    NSTimeInterval startTime;
   
    meetingStartTime = [self dateStringWithStartTimeString:((ScheduleModel *)(self.groupModel.meeting_schedules[row])).schedule_start_time];
    meetingEndTime = [self dateStringWithTimeString:((ScheduleModel *)(self.groupModel.meeting_schedules[row])).schedule_end_time];
    endTime = [((ScheduleModel *)(self.groupModel.meeting_schedules[row])).schedule_end_time doubleValue] / 1000;
    startTime = [((ScheduleModel *)(self.groupModel.meeting_schedules[row])).schedule_start_time doubleValue] / 1000;
    
    NSString *time = [NSString stringWithFormat:@"%@-%@", meetingStartTime, meetingEndTime];
    cell.timeTextField.stringValue = time;
    
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    
    NSDate *dateNow = [NSDate date];
    NSComparisonResult result = [dateNow compare:detailDate];
    
    detailDate = [NSDate dateWithTimeIntervalSince1970:startTime];
    NSComparisonResult result1 = [dateNow compare:detailDate];
    
    if(result1 == NSOrderedDescending && result == NSOrderedAscending) {
        cell.wordTextField.hidden = NO;
    } else {
        cell.wordTextField.hidden = YES;
    }
    
    detailDate = [NSDate dateWithTimeIntervalSince1970:startTime];
    dateNow = [NSDate date];
    
    result = [dateNow compare:detailDate];
    if(result == NSOrderedAscending) {
        NSTimeInterval timeDistance = [detailDate timeIntervalSinceDate:dateNow];
        if(timeDistance <= 900) {
            cell.willBeginTextField.hidden = NO;
        } else {
            cell.willBeginTextField.hidden = YES;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 40;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
//    if(self.delegate && [self.delegate respondsToSelector:@selector(popupDetailViewController:withIndex:)]) {
//        [self.delegate popupDetailViewController:self.row withIndex:row];
//    }
    
    return NO;
}

- (NSString *)dateStringWithStartTimeString:(NSString *)timeString {
    NSTimeInterval time = [timeString doubleValue]/1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd  EE  HH:mm"];

    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    
    return currentDateStr;
}


- (NSString *)dateStringWithTimeString:(NSString *)timeString {
    NSTimeInterval time = [timeString doubleValue] / 1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];

    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    
    return currentDateStr;
}

#pragma mark --FrtcScheduleMeetingViewControllerDelegate--
- (void)updateScheduleMeetingComplete:(BOOL)isSuccess {
    NSLog(@"modify success");
    
    [self.scheduleWindow close];
    
    NSString *reminderValue;
    if(isSuccess) {
        reminderValue = NSLocalizedString(@"FM_SCHEDULE_SUCCESS", @"Schedule success");
    } else {
        reminderValue = NSLocalizedString(@"FM_SCHEDULE_FAILURE", @"Schedule failure");;
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
    
    [self getScheduleMeetingList];
}



#pragma mark --Button Sender--
- (void)onUpdateMeeting:(FrtcButton *)sender {
    [self.view.window orderOut:nil];
    if(self.delegate && [self.delegate respondsToSelector:@selector(updateScheduleMeeting:withRecurrence:withRow:)]) {
        [self.delegate updateScheduleMeeting:((ScheduleModel *)(self.groupModel.meeting_schedules[0])).reservation_id withRecurrence:YES withRow:self.row];
    }
}

- (void)onJoinVideoMeetingPressed:(FrtcButton *)sender {
    [self.view.window orderOut:nil];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(joinMeetingWithRow:)]) {
        [self.delegate joinMeetingWithRow:self.row];
    }
}

- (void)onCopyMeeting1:(FrtcButton *)sender {
    __weak __typeof(self)weakSelf = self;
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcGetScheduleMeetingDetailInformation:[[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN] withReservationID:self.scheduleModel.reservation_id completionHandler:^(ScheduleSuccessModel * meetingDetailModel) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        FrtcMeetingScheduleInfoWindow *scheduledInfoWindow = [[FrtcMeetingScheduleInfoWindow alloc] initWithSize:NSMakeSize(388, 410) withSuccessfulSchedule:NO];
       
        [scheduledInfoWindow setupMeetingInfo:meetingDetailModel];
        [scheduledInfoWindow makeKeyAndOrderFront:strongSelf];
        [scheduledInfoWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
        scheduledInfoWindow.titleVisibility       = NSWindowTitleHidden;
        
        [scheduledInfoWindow showWindowWithWindow:strongSelf.view.window];
    } failure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSLog(@"%@", error);
        FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_VERIFY_FAILURE", @"Verifyication failed") withMessage:NSLocalizedString(@"FM_RE_SIGN", @"Please sign in again") preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:strongSelf.view.window];

        FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
            [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FrtcMeetingMainViewShowNotification object:nil userInfo:nil];
        }];
        [alertWindow addAction:action];
    }];
}
- (void)onRemoveMeeting:(FrtcButton *)sender {
    FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_REMOVE_MEETING_RECURRENT_FROM_LIST", @"Remove the recurring meeting？") withMessage:NSLocalizedString(@"FM_REMOVE_MEETING_RECURRENT_FROM_LIST_DETAIL", @"You will remove this recurring meeting from the meeting list") preferredStyle:FrtcWindowAlertStyleDefault withCurrentWindow:self.view.window withWindowSize: NSMakeSize(286, 128)];
   
    __weak __typeof(self)weakSelf = self;
    FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_REMOVE_MEETING_FROMLIST", @"Remove Meeting") style:FrtcWindowAlertActionStyleOK handler:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSString *meetingIdentifier;
        
        if([strongSelf.scheduleModel.meeting_type isEqualToString:@"recurrence"]) {
            meetingIdentifier = strongSelf.scheduleModel.groupInfoKey;
        } else {
            meetingIdentifier = strongSelf.scheduleModel.meetingInfoKey;
        }
        
        [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcRemoveMeetingListFromUrl:[[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN] meetingIdentifier:meetingIdentifier completionHandler:^(NSDictionary * _Nonnull meetingInfo) {
                NSLog(@"Success");
            
                if(strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(removeMeetingSuccess)]) {
                    [strongSelf.delegate removeAddMeetingSuccess];
                }
                [strongSelf.view.window close];
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"failure");
        }];
 
    }];
    
    [alertWindow addAction:action withTitleColor:[NSColor colorWithString:@"#E32726" andAlpha:1.0]];
    
    FrtcAlertAction *actionCancel = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_CANCEL_ABOUT", @"Not Now") style:FrtcWindowAlertActionStyleCancle handler:^{
    }];
    
    [alertWindow addAction:actionCancel];
}

- (void)onDeleteRecurrenceMeeting:(FrtcButton *)sender {
    FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_CANCEL_MEETING_ABOUT", @"Cancel Meeting") withMessage:NSLocalizedString(@"FM_CANCEL_METTING_MESSAGE", @"All participants can not join this meeting once canceled") preferredStyle:FrtcWindowAlertStyleDefault withCurrentWindow:self.view.window];
 
   __weak __typeof(self)weakSelf = self;
   FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_CANCEL_ABOUT_YES", @"YES") style:FrtcWindowAlertActionStyleOK handler:^{
       __strong __typeof(weakSelf)strongSelf = weakSelf;
 
       [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcDeleteCurrentMeeting:[[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN] withReservationId:self.scheduleModel.reservation_id withCancelALL:YES deleteCompletionHandler:^{
                NSLog(@"delete meeting success!");
                [strongSelf getScheduleGroupMeetingInfo];
                strongSelf.clearMeeting = YES;
                [strongSelf.recurrencMeetingTableView reloadData];
                
                if(strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(updateScheduleList)]) {
                    [strongSelf.delegate updateScheduleList];
                }
           
                [strongSelf.view.window close];
             
           } deleteFailure:^(NSError * _Nonnull error) {
               if([error.localizedDescription isEqualToString:@"Request failed: unauthorized (401)"]) {
                   FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_VERIFY_FAILURE", @"Verifyication failed") withMessage:NSLocalizedString(@"FM_RE_SIGN", @"Please sign in again") preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:self.view.window];
 
                   FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
                       [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FrtcMeetingMainViewShowNotification object:nil userInfo:nil];
                   }];
                   [alertWindow addAction:action];
               }
           }];
 
       }];
 
       //[alertWindow addAction:action];
       [alertWindow addAction:action withTitleColor:[NSColor colorWithString:@"#E32726" andAlpha:1.0]];
 
       FrtcAlertAction *actionCancel = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_CANCEL_ABOUT", @"NO") style:FrtcWindowAlertActionStyleCancle handler:^{
       }];
 
       [alertWindow addAction:actionCancel];
}


#pragma mark --getter load--
- (NSTextField *)titleTextField {
    if (!_titleTextField) {
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        //_titleTextField.accessibilityClearButton;
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:20 weight:NSFontWeightSemibold];
        //_titleTextField.font = [[NSFontManager sharedFontManager] fontWithFamily:@"PingFangSC-Regular" traits:NSBoldFontMask weight:NSFontWeightMedium size:18];
        _titleTextField.alignment = NSTextAlignmentLeft;
        _titleTextField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.stringValue = @"meimeili 预约的会议";
        [self.view addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (NSView *)backgroundView {
    if(!_backgroundView) {
        _backgroundView = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 380, 388)];
        _backgroundView.wantsLayer = YES;
        _backgroundView.layer.backgroundColor = [NSColor colorWithString:@"#F9F9F9" andAlpha:1.0].CGColor;
        [self.view addSubview:_backgroundView];
    }
    
    return _backgroundView;
}

- (NSTextField *)recurrenceIntervalTextField {
    if(!_recurrenceIntervalTextField) {
        _recurrenceIntervalTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _recurrenceIntervalTextField.backgroundColor = [NSColor clearColor];
        _recurrenceIntervalTextField.font = [NSFont systemFontOfSize:13 weight:NSFontWeightRegular];
        _recurrenceIntervalTextField.alignment = NSTextAlignmentLeft;
        _recurrenceIntervalTextField.textColor = [NSColor colorWithString:@"#14C853" andAlpha:1.0];
        _recurrenceIntervalTextField.bordered = NO;
        _recurrenceIntervalTextField.editable = NO;
        _recurrenceIntervalTextField.stringValue = @"每2天";
        [self.view addSubview:_recurrenceIntervalTextField];
    }
    
    return _recurrenceIntervalTextField;
}

- (NSTextField *)recurrenceDetailTextField {
    if(!_recurrenceDetailTextField) {
        _recurrenceDetailTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _recurrenceDetailTextField.backgroundColor = [NSColor clearColor];
        _recurrenceDetailTextField.font = [NSFont systemFontOfSize:13 weight:NSFontWeightRegular];
        _recurrenceDetailTextField.alignment = NSTextAlignmentLeft;
        _recurrenceDetailTextField.textColor = [NSColor colorWithString:@"#000000" andAlpha:1.0];
        _recurrenceDetailTextField.bordered = NO;
        _recurrenceDetailTextField.editable = NO;

        _recurrenceDetailTextField.maximumNumberOfLines = 0;
        _recurrenceDetailTextField.stringValue = @"会议将于每2天重复";
        [self.view addSubview:_recurrenceDetailTextField];
    }
    
    return _recurrenceDetailTextField;
}

- (NSTextField *)recurrenceDetailTimeTextField {
    if(!_recurrenceDetailTimeTextField) {
        _recurrenceDetailTimeTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _recurrenceDetailTimeTextField.backgroundColor = [NSColor clearColor];
        _recurrenceDetailTimeTextField.font = [NSFont systemFontOfSize:13 weight:NSFontWeightRegular];
        _recurrenceDetailTimeTextField.alignment = NSTextAlignmentLeft;
        _recurrenceDetailTimeTextField.textColor = [NSColor colorWithString:@"#000000" andAlpha:1.0];
        _recurrenceDetailTimeTextField.bordered = NO;
        _recurrenceDetailTimeTextField.editable = NO;
        _recurrenceDetailTimeTextField.stringValue = @"结束于2023年10月21日 剩余5场会议";
        [self.view addSubview:_recurrenceDetailTimeTextField];
    }
    
    return _recurrenceDetailTimeTextField;
}

- (NSTableView *)recurrencMeetingTableView {
    if(!_recurrencMeetingTableView) {
        _recurrencMeetingTableView = [[NSTableView alloc] initWithFrame:NSMakeRect(0, 266, 380, 393)];
        NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@""];
        [_recurrencMeetingTableView addTableColumn:column];
        
        _recurrencMeetingTableView.delegate = self;
        _recurrencMeetingTableView.dataSource = self;
        _recurrencMeetingTableView.gridStyleMask = NSTableViewGridNone;
        [_recurrencMeetingTableView setAllowsTypeSelect:NO];
        _recurrencMeetingTableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
        [_recurrencMeetingTableView setIntercellSpacing:NSMakeSize(0, 0)];
        _recurrencMeetingTableView.allowsColumnReordering = NO;
        [_recurrencMeetingTableView setHeaderView:nil];
        _recurrencMeetingTableView.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] whiteColor];
        _recurrencMeetingTableView.focusRingType = NSFocusRingTypeNone;
        _recurrencMeetingTableView.translatesAutoresizingMaskIntoConstraints = YES;
        
        if(@available(macos 11.0, *)) {
            _recurrencMeetingTableView.style = NSTableViewStylePlain;
        }
        [self.view addSubview:_recurrencMeetingTableView];
        [_recurrencMeetingTableView reloadData];
    }
    
    return _recurrencMeetingTableView;
}

- (NSScrollView *)recurrenceGoundView {
    if (!_recurrenceGoundView) {
        _recurrenceGoundView = [[NSScrollView alloc] init];
        _recurrenceGoundView.documentView = self.recurrencMeetingTableView;
        _recurrenceGoundView.hasVerticalScroller = YES;
        _recurrenceGoundView.hasHorizontalScroller = NO;
        _recurrenceGoundView.scrollerStyle = NSScrollerStyleOverlay;
        _recurrenceGoundView.scrollerKnobStyle = NSScrollerKnobStyleDark;
        _recurrenceGoundView.scrollsDynamically = YES;
        _recurrenceGoundView.autohidesScrollers = NO;
        _recurrenceGoundView.verticalScroller.hidden = NO;
        _recurrenceGoundView.horizontalScroller.hidden = YES;
        _recurrenceGoundView.automaticallyAdjustsContentInsets = NO;
        _recurrenceGoundView.backgroundColor = [NSColor whiteColor];
        [self.view addSubview:_recurrenceGoundView];
    }

    return _recurrenceGoundView;
}

- (FrtcButton *)callButton {
    if (!_callButton){
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_MEETING_JOIN", @"Join") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_MEETING_JOIN", @"Join") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        _callButton = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 332, 36) withNormalMode:normalMode withHoverMode:hoverMode];
        _callButton.target = self;
        _callButton.action = @selector(onJoinVideoMeetingPressed:);
        [self.view addSubview:_callButton];
    }
    
    return _callButton;
}

- (FrtcButton *)copyButton {
    if (!_copyButton){
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#CCCCCC" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_MEETING_RECURRENCE_MODIFY", @"Edit Recurring Meeting") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#CCCCCC" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_MEETING_RECURRENCE_MODIFY", @"Edit Recurring Meeting") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        _copyButton = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 332, 36) withNormalMode:normalMode withHoverMode:hoverMode];
        _copyButton.target = self;
        _copyButton.action = @selector(onUpdateMeeting:);
        [self.view addSubview:_copyButton];
    }
    return _copyButton;
}

- (FrtcButton *)cancelButton {
    if (!_cancelButton){
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#E32726" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#CCCCCC" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_MEETING_RECURRENCE_CANCEL", @"Cancel Recurring Meeting") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#E32726" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#CCCCCC" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_MEETING_RECURRENCE_CANCEL", @"Cancel Recurring Meeting") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        _cancelButton = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 332, 36) withNormalMode:normalMode withHoverMode:hoverMode];
        _cancelButton.target = self;
        _cancelButton.action = @selector(onDeleteRecurrenceMeeting:);
        [self.view addSubview:_cancelButton];
    }
    return _cancelButton;
}

- (FrtcButton*)removeButton {
    if (!_removeButton){
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#E32726" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#CCCCCC" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_REMOVE_MEETING_FROMLIST", @"Remove Meeting") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#E32726" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#CCCCCC" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_REMOVE_MEETING_FROMLIST", @"Remove Meeting") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        _removeButton = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 332, 36) withNormalMode:normalMode withHoverMode:hoverMode];
        _removeButton.target = self;
        _removeButton.action = @selector(onRemoveMeeting:);
        [self.view addSubview:_removeButton];
    }
    return _removeButton;
}

- (FrtcButton*)copyButton1 {
    if (!_copyButton1){
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#CCCCCC" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_COPY_INVITE", @"Copy Invitation") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#CCCCCC" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_COPY_INVITE", @"Copy Invitation") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        _copyButton1 = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 332, 36) withNormalMode:normalMode withHoverMode:hoverMode];
        _copyButton1.target = self;
        _copyButton1.action = @selector(onCopyMeeting1:);
        [self.view addSubview:_copyButton1];
    }
    return _copyButton1;
}



@end
