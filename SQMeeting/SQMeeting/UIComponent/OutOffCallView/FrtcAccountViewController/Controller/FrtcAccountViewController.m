#import "FrtcAccountViewController.h"
#import "FrtcMeetingManagement.h"
#import "FrtcPersonalViewController.h"
#import "FrtcSettingViewController.h"
#import "HoverImageView.h"
#import "FrtcUpdatePasswordWindow.h"
#import "FrtcAlertWindow.h"
#import "FrtcAlertMainWindow.h"
#import "FrtcMaskView.h"
#import "FrtcCallWindow.h"
#import "CallResultReminderView.h"
#import "FrtcScheduleViewController.h"
#import "FrtcInputPasswordWindow.h"
#import "FrtcHistoryCallTableViewCell.h"
#import "FrtcPersistence.h"
#import "FrtcDetailMeetingViewController.h"
#import "FrtcMainWindow.h"
#import "FrtcModifyNameWindow.h"
#import "FrtcTagSelectCell.h"
#import "FrtcScheduleMeetingTableViewCell.h"
#import "FrtcScheduleFunctionController.h"
#import "FrtcScheduleDetailMeetingViewController.h"
#import "FrtcScheduleMeetingViewController.h"
#import "FrtcLocalReminderManagement.h"
#import "FrtcCancelMeetingWindow.h"
#import "FrtcRecurrenceDetailViewController.h"
#import "FrtcMeetingDetailInfoWindow.h"
#import "FrtcMeetingScheduleInfoWindow.h"
#import "FrtcModifyCancelTypeWindow.h"
#import "FrtcScheduleMeetingModifyViewController.h"

@interface FrtcAccountViewController ()<HoverImageViewDelegate, FrtcPersonalViewControllerDelegate, FrtcUpdatePasswordWindowDelegate, FrtcAlertWindowDelegate, FrtcCallWindowDelegate, FrtcInputPasswordWindowDelegate,FrtcHistoryCallTableViewCellDelegate,FrtcDetailMeetingViewControllerDelegate,NSTableViewDelegate, NSTableViewDataSource, FrtcModifyNameWindowDelegate, FrtcTagSelectCellDelegate, FrtcScheduleMeetingTableViewCellDelegate, FrtcScheduleFunctionControllerDelegate, FrtcScheduleMeetingViewControllerDelegate, NSPopoverDelegate, FrtcScheduleDetailMeetingViewControllerDelegate, FrtcLocalReminderManagementJoinMeetingDelegate, FrtcCancelMeetingWindowDelegate, FrtcRecurrenceDetailViewControllerDelegate, FrtcRecurrenceDetailViewControllerDelegate, FrtcModifyCancelTypeWindowDelegate, ModifySingleMeetingDelegate> {
    FrtcTagSelectCell *_selectedCell;
}

@property (nonatomic, strong) NSImageView               *userImageView;

@property (nonatomic, strong) NSTextField               *displayNameTextField;

@property (nonatomic, strong) FrtcHoverButton      *settingButton;

@property (nonatomic, strong) FrtcHoverButton      *setupMeetingButton;

@property (nonatomic, strong) FrtcHoverButton      *joinMeetingButton;

@property (nonatomic, strong) FrtcHoverButton      *scheduleMeetingButton;

@property (nonatomic, strong) HoverImageView            *arrorwImageView;

@property (nonatomic, strong) HoverImageView            *scheduleRefreshView;

@property (nonatomic, strong) NSTextField               *setupMeetingTextField;

@property (nonatomic, strong) NSTextField               *joinMeetingTextField;

@property (nonatomic, strong) NSTextField               *scheduleMeetingTextField;

@property (nonatomic, strong) NSTextField               *noMeetingTextField;

@property (nonatomic, strong) NSView                    *lineView;

@property (nonatomic, strong) NSImageView               *timerImageView;

@property (nonatomic, strong) NSTextField               *callHistoryTextField;

@property (nonatomic, strong) FrtcHoverButton      *removeButton;

@property (nonatomic, strong) FrtcHoverButton      *refreshButton;

@property (nonatomic, strong) NSView                    *lineView1;

@property (nonatomic, strong) NSImageView               *noCallHistoryImageView;

@property (nonatomic, strong) NSTextField               *haveNoMeetingTextField;

@property (nonatomic, strong) NSPopover                 *popover;

@property (nonatomic, strong) FrtcUpdatePasswordWindow  *updatePasswordWindow;

@property (nonatomic, strong) FrtcMaskView              *maskView;

//for story: SN-3457
//@property (nonatomic, strong) FrtcMakeCallProgressView  *makeCallProgress;
@property (nonatomic, strong) NSProgressIndicator       *makeCallProgress;

@property (nonatomic, strong) CallResultReminderView    *reminderView;

@property (strong, nonatomic) NSTimer                   *reminderTipsTimer;

@property (nonatomic, strong) NSTableView               *rosterTableView;

@property (nonatomic, strong) NSScrollView              *backGoundView;

@property (nonatomic, copy)   NSArray <MeetingDetailModel *> *recentCallList;

@property (nonatomic, strong) FrtcMainWindow *settingWindow;

@property (nonatomic, strong) FrtcMainWindow *scheduleWindow;

@property (nonatomic, strong) FrtcMainWindow *meetingDetailWindow;

@property (nonatomic, strong) FrtcMainWindow *recurrenceDetailWindow;

@property (nonatomic, copy)   NSString *displayName;

@property (nonatomic, strong) FrtcTagSelectCell *scheduleSelectTagCell;

@property (nonatomic, strong) FrtcTagSelectCell *callHistorySelectTagCell;

@property (nonatomic, strong) NSImageView *scheduleLine;

@property (nonatomic, strong) NSImageView *callHistoryLine;

@property (nonatomic, strong) NSView *testView;

@property (nonatomic, assign) FrtcTagSelectTag selectTag;

@property (nonatomic, strong) ScheduledModelArray *scheduleModelArray;

@property (nonatomic, strong) NSPopover * funtionPopover;

@property (nonatomic, strong) MeetingRooms *meetingRooms;

@property (nonatomic, assign, getter=isUsingPersonalNumber) BOOL usingPersonalNumber;

@property (nonatomic, copy) NSString *personalMeetingNumber;

@property (nonatomic, copy) NSString *personalMeetingPassword;

@property (nonatomic, strong) NSTextView *theTextView;

@property (nonatomic, assign) NSInteger selectRow;

@property (nonatomic, assign, getter=isCallSuccess) BOOL callSuccess;

@property (nonatomic, strong) FrtcLocalReminderManagement *localReminderManagement;
@property (nonatomic, strong) NSTimer   *localReminderTimer;

@property (nonatomic, assign, getter=isInviteMeeting) BOOL inviteMeeting;


@end

@implementation FrtcAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
    [self setupAccountView];
    
    //self.displayNameTextField.stringValue = self.model.realName ? self.model.realName : [NSString stringWithFormat:@"%@%@",self.model.lastname, self.model.firstname];
    self.displayName = self.model.realName ? self.model.realName : [NSString stringWithFormat:@"%@%@",self.model.lastname, self.model.firstname];
    
    [self getScheduleMeetingList];
    [self getPersonalMeetingRooms];
    self.title = NSLocalizedString(@"FM_SCHEDULE_MEETING", @"Schedule Meeting");
    
    self.localReminderManagement = [FrtcLocalReminderManagement sharedInstance];
    [self.localReminderManagement setReminderWindowJoinMeetingDelegate:self];
    [self setDefaultEnabeReceiveMeetingReminder];
    [self enableOrDisableReceiveMeetingReminder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUpdateMeeting:) name:FrtcMeetingUpdateScheduleNotification object:nil];
}

- (void)dealloc {
    NSLog(@"FrtcAccountViewController dealloc");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FMeetingUserActivelyHangupNotification object:nil];
    
    [self releaseLocalReminderManager];
}

- (CGFloat)distance {
    NSString * language = [FMLanguageConfig userLanguage] ? : [NSLocale preferredLanguages].firstObject;
    
    if([language hasPrefix:@"en"]) {
        return 80.0;
    } else {
        return 60.0;
    }
}

- (void)setupAccountView {
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(48);
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    [self.displayNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.userImageView.mas_centerY);
        make.left.mas_equalTo(self.userImageView.mas_right).offset(8);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.userImageView.mas_centerY);
        make.right.mas_equalTo(self.view.mas_right).offset(-28);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    
    [self.setupMeetingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.top.mas_equalTo(self.view.mas_top).offset(104);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(56);
    }];
    
    [self.joinMeetingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.setupMeetingButton.mas_centerY);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(56);
    }];
    
    [self.scheduleMeetingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.joinMeetingButton.mas_centerY);
        make.right.mas_equalTo(self.view.mas_right).offset(-24);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(56);
    }];
    
    [self.setupMeetingTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.setupMeetingButton.mas_centerX);
        make.top.mas_equalTo(self.setupMeetingButton.mas_bottom).offset(8);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.arrorwImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.setupMeetingTextField.mas_centerY);
        make.left.mas_equalTo(self.setupMeetingTextField.mas_right).offset(4);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(14);
    }];
    
    [self.joinMeetingTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.joinMeetingButton.mas_centerX);
        make.top.mas_equalTo(self.joinMeetingButton.mas_bottom).offset(8);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.scheduleMeetingTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.scheduleMeetingButton.mas_centerX);
        make.top.mas_equalTo(self.scheduleMeetingButton.mas_bottom).offset(8);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top).offset(212);
        make.width.mas_equalTo(380);
        make.height.mas_equalTo(8);
    }];
    
    [self.scheduleSelectTagCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.top.mas_equalTo(self.lineView.mas_top).offset(10);
        make.size.mas_equalTo(NSMakeSize([self distance], 28));
    }];
    
    [self.callHistorySelectTagCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_top).offset(9);
        make.left.mas_equalTo(self.scheduleSelectTagCell.mas_right).offset(32);
        make.size.mas_equalTo(NSMakeSize([self distance], 28));
    }];
    
    [self.removeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_top).offset(13);
        make.right.mas_equalTo(self.view.mas_right).offset(-24);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(22);
    }];
    
    [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_top).offset(13);
        make.right.mas_equalTo(self.view.mas_right).offset(-24);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(22);
    }];
    
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.scheduleSelectTagCell.mas_bottom).offset(8);
        make.width.mas_equalTo(380);
        make.height.mas_equalTo(1);
    }];
    
    [self.scheduleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.bottom.mas_equalTo(self.lineView1.mas_top);
        make.width.mas_equalTo([self distance]);
        make.height.mas_equalTo(2);
    }];
    
    [self.callHistoryLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.callHistorySelectTagCell.mas_centerX);
        make.bottom.mas_equalTo(self.lineView1.mas_top);
        make.width.mas_equalTo([self distance]);
        make.height.mas_equalTo(2);
    }];
    
    [self.noCallHistoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.lineView1.mas_bottom).offset(43);
        make.width.mas_equalTo(136);
        make.height.mas_equalTo(136);
    }];
    
    [self.noMeetingTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.noCallHistoryImageView.mas_bottom).offset(15);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.makeCallProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(32);
    }];
    //for story: SN-3457
    /*
     [self.makeCallProgress mas_makeConstraints:^(MASConstraintMaker *make) {
     make.centerY.mas_equalTo(self.view.mas_centerY);
     make.centerX.mas_equalTo(self.view.mas_centerX);
     make.width.mas_equalTo(64);
     make.height.mas_equalTo(64);
     }];
     */
    
    [self.backGoundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView1.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view.mas_left);
        make.width.mas_equalTo(380);
        make.height.mas_equalTo(393);
    }];
}

#pragma mark --Get Personal Meeting Rooms
- (void)getPersonalMeetingRooms {
    __weak __typeof(self)weakSelf = self;
    NSString *userToken = [[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN];
    
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcQueryMeetingRoomList:userToken queryMeetingRoomSuccess:^(MeetingRooms * _Nonnull meetingRooms) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.meetingRooms = meetingRooms;
    } queryMeetingRoomFailure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)hangupCall {
    [self getRecentCallList];
}

#pragma mark --Class Interface
- (void)showReminderView:(NSString *)reminderValue {
    NSFont *font             = [NSFont systemFontOfSize:14.0f];
    NSDictionary *attributes = @{ NSFontAttributeName:font };
    CGSize size              = [reminderValue sizeWithAttributes:attributes];
    
    CGRect rect = [reminderValue boundingRectWithSize:CGSizeMake(350, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    
    [self.reminderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.width.mas_equalTo(rect.size.width + 28);
        make.height.mas_equalTo(rect.size.height + 20);
    }];
    
    self.reminderView.tipLabel.stringValue = reminderValue;
    self.reminderView.hidden = NO;
    [self runningTimer:2.0];
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

#pragma mark --button sender--
- (void)onSettingBtnPressed:(FrtcHoverButton *)sender {
    if([self.settingWindow isVisible]) {
        [self.settingWindow makeKeyAndOrderFront:self];
    } else {
        FrtcSettingViewController *settingViewController = [[FrtcSettingViewController alloc] init];
        //settingViewController.login = YES;
        settingViewController.settingType = SettingTypeLogin;
        
        settingViewController.model = self.model;
        
        self.settingWindow = [[FrtcMainWindow alloc] initWithSize:NSMakeSize(640, 560)];
        self.settingWindow.contentViewController = settingViewController;
        self.settingWindow.titleVisibility       = NSWindowTitleHidden;
        [self.settingWindow makeKeyAndOrderFront:self];
        [self.settingWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
        [self.settingWindow center];
    }
}

- (void)onSetupMeetingButtonPressed:(FrtcHoverButton *)sender {
    sender.enabled = NO;
    
    NSString *userToken     = [[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN];
    NSString *meetingName   = [NSString stringWithFormat:@"%@%@", self.model.username, NSLocalizedString(@"FM_SOMEONE_MEETING_ROOM", @"s meeting room")];
    
    if(self.isUsingPersonalNumber) {
        FRTCMeetingParameters callParam;
        callParam.meeting_alias         = self.personalMeetingNumber;
        callParam.display_name          = self.model.realName ? self.model.realName :[NSString stringWithFormat:@"%@%@", self.model.lastname, self.model.firstname];
        callParam.user_token            = userToken;
        callParam.meeting_password      = self.personalMeetingPassword;
        callParam.video_mute            = ![[FrtcUserDefault defaultSingleton] boolObjectForKey:CAMERA_ENABLE];;
        callParam.audio_mute            = YES;
        callParam.audio_only            = NO;
        callParam.user_id               = self.model.user_id;
        
        [self makeCall:callParam];
        self.usingPersonalNumber = NO;
        
        return;
    }
    
    __weak __typeof(self)weakSelf = self;
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcSetupMeetingWithUsertoken:userToken meetingName:meetingName scheduleCompletionHandler:^(SetupMeetingModel * _Nonnull model) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        FRTCMeetingParameters callParam;
        callParam.meeting_alias     = model.meetingNumber;
        callParam.display_name      = self.model.realName ? self.model.realName :[NSString stringWithFormat:@"%@%@", self.model.lastname, self.model.firstname];;
        callParam.user_token        = userToken;
        callParam.meeting_password         = model.meetingPassword;
        callParam.video_mute        =  ![[FrtcUserDefault defaultSingleton] boolObjectForKey:CAMERA_ENABLE];;
        callParam.audio_mute        = YES;
        callParam.audio_only        = NO;
        callParam.user_id           = strongSelf.model.user_id;
        
        [strongSelf makeCall:callParam];
        
    } scheduleFailure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.makeCallProgress stopAnimation:strongSelf];
            strongSelf.makeCallProgress.hidden = YES;
            [strongSelf.maskView removeFromSuperview];
        });
        if([error.localizedDescription isEqualToString:@"Request failed: unauthorized (401)"]) {
            FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_LOGOUT_NOTIFICATION", @"Logout Notification") withMessage:NSLocalizedString(@"FM_LOGIN_AGAIN_NOTIFICATION", @"Verifyication failed. Please re-login and join meeting again.") preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:self.view.window];
            
            FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
                [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FrtcMeetingMainViewShowNotification object:nil userInfo:nil];
            }];
            [alertWindow addAction:action];
        }
    }];
}

- (void)onJoinMeetingButtonPressed:(FrtcHoverButton *)sender {
    FrtcCallWindow *callWindow = [[FrtcCallWindow alloc] initWithSize:NSMakeSize(380, 365)];
    callWindow.frtcCallWindowdelegate = self;
    callWindow.login = YES;
    callWindow.userName = self.model.realName ? self.model.realName :[NSString stringWithFormat:@"%@%@", self.model.lastname, self.model.firstname];//self.displayName;//self.model.username;
    callWindow.userId = self.model.user_id;
    [callWindow showWindow];
}

- (void)onScheduleMeetingButtonBtnPressed:(FrtcHoverButton *)sender {
    if([self.scheduleWindow isVisible]) {
        [self.scheduleWindow makeKeyAndOrderFront:self];
    } else {
        BOOL authority;
        if([self.model.role containsObject:@"MeetingOperator"] || [self.model.role containsObject:@"SystemAdmin"]) {
            authority = YES;
        } else {
            authority = NO;
        }
        
        FrtcScheduleMeetingViewController *meetingDetailViewController = [[FrtcScheduleMeetingViewController alloc] initWithNibName:nil bundle:nil];
        meetingDetailViewController.delegate = self;
        meetingDetailViewController.meetingRooms = self.meetingRooms;
        meetingDetailViewController.userName = self.model.username;
        meetingDetailViewController.authority = authority;
        
        self.scheduleWindow = [[FrtcMainWindow alloc] initWithSize:NSMakeSize(380, 660)];
        self.scheduleWindow.titleVisibility       = NSWindowTitleHidden;
        self.scheduleWindow.contentViewController = meetingDetailViewController;
        
        [self.scheduleWindow makeKeyAndOrderFront:self];
        [self.scheduleWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
        [self.scheduleWindow center];
    }
}

- (void)onRemoveButtonPressed:(FrtcHoverButton *)sender {
    FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_CLIAR_HISTORY", @"Clear History") withMessage:NSLocalizedString(@"FM_CLEAR_HISTORY_DETAIL", @"Are you sure to clear all meeting histories?") preferredStyle:FrtcWindowAlertStyleDefault withCurrentWindow:self.view.window];
    
    __weak __typeof(self)weakSelf = self;
    FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [[FrtcPersistence sharedUserPersistence] deleteCurrentUserHistoryMeeting];
        [strongSelf getRecentCallList];
    }];
    
    [alertWindow addAction:action];
    
    FrtcAlertAction *actionCancel = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_CANCEL", @"Cancel") style:FrtcWindowAlertActionStyleCancle handler:^{
    }];
    
    [alertWindow addAction:actionCancel];
}

- (void)onRefreshButtonPressed:(FrtcHoverButton *)sender {
    [self getScheduleMeetingList];
}

- (void)popupScheduleMeeingInfoWithInfoModel:(ScheduleSuccessModel *)model {
    FrtcMeetingScheduleInfoWindow *scheduledInfoWindow = [[FrtcMeetingScheduleInfoWindow alloc] initWithSize:NSMakeSize(388, 410) withSuccessfulSchedule:YES];
   
    [scheduledInfoWindow setupMeetingInfo:model];
    [scheduledInfoWindow makeKeyAndOrderFront:self];
    [scheduledInfoWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    scheduledInfoWindow.titleVisibility       = NSWindowTitleHidden;
    
    
    [scheduledInfoWindow showWindow];
}

#pragma mark --ModifySingleMeetingDelegate--
- (void)modifyMeetingSuccess:(BOOL)isSuccess {
    if(isSuccess) {
        [self updateScheduleList];
    }
}

#pragma mark --FrtcRecurrenceDetailViewControllerDelegate--
- (void)updateScheduleList {
    [self getScheduleMeetingList];
}

- (void)updateScheduleMeeting:(NSString *)reversionID withRecurrence:(BOOL)isRecurrence withRow:(NSInteger)row {
//   [self editSelectMeetingWitReservationID:reversionID withRecurrence:isRecurrence withRow:row];
    
    [self modifyMeetingWithRecurrence:isRecurrence withReversionID:reversionID withRow:row];
}

- (void)removeAddMeetingSuccess {
    [self getScheduleMeetingList];
}

- (void)popupDetailViewController:(NSInteger)row withIndex:(NSInteger)index {
    ScheduleModel *detailModel = self.scheduleModelArray.meeting_schedules[row];
    NSInteger remainMeetings = detailModel.recurrenceReservationList.count + 1;
    if(index != 0) {
        detailModel = detailModel.recurrenceReservationList[index - 1];
    }
    FrtcScheduleDetailMeetingViewController *meetingDetailViewController = [[FrtcScheduleDetailMeetingViewController alloc] initWithNibName:nil bundle:nil];
    
    meetingDetailViewController.name                 = self.model.realName ? self.model.realName : [NSString stringWithFormat:@"%@%@", self.model.lastname, self.model.firstname];
    meetingDetailViewController.scheduleModel        = detailModel;
    meetingDetailViewController.row                  = row;
    meetingDetailViewController.remainMeetings       = remainMeetings;
    meetingDetailViewController.reversionID          = detailModel.reservation_id;
    meetingDetailViewController.currentReservationID = detailModel.reservation_id;
    
    if([detailModel.owner_id isEqualToString:self.model.user_id]) {
        meetingDetailViewController.invite = NO;
    } else {
        if([detailModel.participantUsers containsObject:self.model.user_id]) {
            meetingDetailViewController.invite = YES;
        } else {
            meetingDetailViewController.addMeeting = YES;
        }
    }
    
    FrtcScheduleMeetingTableViewCell* cell = (FrtcScheduleMeetingTableViewCell*)[_rosterTableView viewAtColumn:0 row:row makeIfNecessary:NO];
    meetingDetailViewController.overtime = cell.overTime;
    meetingDetailViewController.delegate = self;
    
    self.meetingDetailWindow = [[FrtcMainWindow alloc] initWithSize:NSMakeSize(380, 660)];
    self.meetingDetailWindow.contentViewController = meetingDetailViewController;

    self.meetingDetailWindow.title = NSLocalizedString(@"FM_MEETING_DETAILS", @"Meeting Detail");
    [self.meetingDetailWindow makeKeyAndOrderFront:self];
    [self.meetingDetailWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    [self.meetingDetailWindow center];
}

#pragma mark --FrtcMeetingUpdateScheduleNotification--
- (void)onUpdateMeeting:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSNumber *isSuccess = [userInfo valueForKey:FrtcMeetingUpdateScheduleKey];
    [self updateScheduleMeetingComplete:[isSuccess boolValue]];
}

#pragma mark --FrtcScheduleMeetingViewControllerDelegate--
- (void)updateScheduleMeetingComplete:(BOOL)isSuccess {
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

- (void)scheduleMeetingComplete:(BOOL)isSuccess withScheduleSuccessModel:(nonnull ScheduleSuccessModel *)model {
    [self.scheduleWindow close];
    
    NSString *reminderValue;
    if(isSuccess) {
        reminderValue = NSLocalizedString(@"FM_SCHEDULE_SUCCESS", @"Schedule success");
        
        [self popupScheduleMeeingInfoWithInfoModel:model];
        [self getScheduleMeetingList];
        
        return;
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

- (void)joinMeetingWithRow:(NSInteger)row {
    self.selectRow = row;
    
    FRTCMeetingParameters callParam;
    ScheduleModel *scheduleModel = self.scheduleModelArray.meeting_schedules[row];
    
    callParam.meeting_alias         = scheduleModel.meeting_number;
    callParam.display_name          = self.model.realName ? self.model.realName :[NSString stringWithFormat:@"%@%@", self.model.lastname, self.model.firstname];
    callParam.user_token            = [[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN];
    callParam.meeting_password      = scheduleModel.meeting_password;
    callParam.user_id               = self.model.user_id;
    
    callParam.video_mute            = YES;
    callParam.audio_mute            = YES;
    callParam.audio_only            = NO;
    
    [self makeCall:callParam];
}

#pragma mark --FrtcScheduleMeetingTableViewCellDelegate--
- (void)popUpFunctionControllerWithFrame:(NSRect)frame withRow:(NSInteger)row {
    //ScheduleModel *scheduleModel = self.scheduleModelArray.meeting_schedules[row];
    FrtcScheduleFunctionController *controller = [[FrtcScheduleFunctionController alloc] init];
    controller.row              = row;
    controller.reservationID    = ((ScheduleModel *)(self.scheduleModelArray.meeting_schedules[row])).reservation_id;
    controller.delegate         = self;
    controller.meetingType      = ((ScheduleModel *)(self.scheduleModelArray.meeting_schedules[row])).meeting_type;
    //if([controller.meetingType isEqualToString:@""]) {
        controller.needView = YES;
    //}
    
    if([ ((ScheduleModel *)(self.scheduleModelArray.meeting_schedules[row])).owner_id isEqualToString:self.model.user_id]) {
        controller.addMeeting = NO;
    } else {
        if([ ((ScheduleModel *)(self.scheduleModelArray.meeting_schedules[row])).participantUsers containsObject:self.model.user_id]) {
            controller.addMeeting = NO;
        } else {
            controller.addMeeting = YES;
        }
    }
    
    self.funtionPopover = [[NSPopover alloc] init];
    self.funtionPopover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];
    
    self.funtionPopover.contentViewController = controller;
    self.funtionPopover.behavior = NSPopoverBehaviorTransient;
    
    FrtcScheduleMeetingTableViewCell* cell = (FrtcScheduleMeetingTableViewCell*)[_rosterTableView viewAtColumn:0 row:row makeIfNecessary:NO];
    controller.overTime = cell.overTime;
    
    [self.funtionPopover showRelativeToRect:frame ofView:cell preferredEdge:NSRectEdgeMinY];
}

- (void)joinTheConferenceWithRow:(NSInteger)row {
    self.selectRow = row;
    
    FRTCMeetingParameters callParam;
    ScheduleModel *scheduleModel = self.scheduleModelArray.meeting_schedules[row];
    
    callParam.meeting_alias = scheduleModel
        .meeting_number;
    callParam.display_name      = self.model.realName ? self.model.realName :[NSString stringWithFormat:@"%@%@", self.model.lastname, self.model.firstname];
    callParam.user_token        = [[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN];
    callParam.meeting_password         = scheduleModel.meeting_password;
    callParam.user_id           = self.model.user_id;
    
    callParam.video_mute        = YES;
    callParam.audio_mute        = YES;
    callParam.audio_only        = NO;
    
    [self makeCall:callParam];
}

#pragma mark --FrtcScheduleDetailMeetingViewControllerDelegate--
- (void)joinMeeting:(NSInteger)row {
    self.selectRow = row;
    
    FRTCMeetingParameters callParam;
    ScheduleModel *scheduleModel = self.scheduleModelArray.meeting_schedules[row];
    
    callParam.meeting_alias         = scheduleModel.meeting_number;
    callParam.display_name          = self.model.realName ? self.model.realName :[NSString stringWithFormat:@"%@%@", self.model.lastname, self.model.firstname];
    callParam.user_token            = [[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN];
    callParam.meeting_password         = scheduleModel.meeting_password;
    callParam.user_id               = self.model.user_id;
    
    callParam.video_mute            = YES;
    callParam.audio_mute            = YES;
    callParam.audio_only            = NO;
    
    [self makeCall:callParam];
}

- (void)removeMeetingSuccess {
    [self getScheduleMeetingList];
}

#pragma makr --FrtcCancelMeetingWindowDelegate--
- (void)cancelMeetingWithCancelRecurrence:(BOOL)cancelAll withReservationID:(NSString *)reservationID {
    __weak __typeof(self)weakSelf = self;
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcDeleteCurrentMeeting:[[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN] withReservationId:reservationID withCancelALL:cancelAll deleteCompletionHandler:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            NSLog(@"delete meeting success!");
            [strongSelf getScheduleMeetingList];
        } deleteFailure:^(NSError * _Nonnull error) {
            if([error.localizedDescription isEqualToString:@"Request failed: unauthorized (401)"]) {
                FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_VERIFY_FAILURE", @"Verifyication failed") withMessage:NSLocalizedString(@"FM_RE_SIGN", @"Please sign in again") preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:self.view.window];

                FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
                    [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FrtcMeetingMainViewShowNotification object:nil userInfo:nil];
                }];
                [alertWindow addAction:action];
            }
    }];
}

#pragma mark --FrtcModifyCancelTypeWindowDelegate--
- (void)modifyMeetingWithRecurrence:(BOOL)isRecurrence withReversionID:(NSString *)reversionID withRow:(NSInteger)row;
 {
    if(isRecurrence) {
        FrtcScheduleMeetingViewController *scheduleMeetingViewController = [[FrtcScheduleMeetingViewController alloc] initWithNibName:nil bundle:nil];
        scheduleMeetingViewController.userName = self.model.username;
        scheduleMeetingViewController.meetingRooms = self.meetingRooms;
        scheduleMeetingViewController.delegate = self;
        scheduleMeetingViewController.updateView = YES;
        
        self.scheduleWindow = [[FrtcMainWindow alloc] initWithSize:NSMakeSize(380, 660)];
        self.scheduleWindow.titleVisibility       = NSWindowTitleHidden;
        self.scheduleWindow.contentViewController = scheduleMeetingViewController;
        
        //[scheduleMeetingViewController updateScheduleButtonName];
        
        [self.scheduleWindow makeKeyAndOrderFront:self];
        [self.scheduleWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
        [self.scheduleWindow center];
        
        __weak __typeof(self)weakSelf = self;
        [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcGetScheduleMeetingDetailInformation:[[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN] withReservationID:reversionID completionHandler:^(ScheduleSuccessModel * meetingDetailModel) {
            [scheduleMeetingViewController updateScheduleView:meetingDetailModel withRecurrence:isRecurrence];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_VERIFY_FAILURE", @"Verifyication failed") withMessage:NSLocalizedString(@"FM_RE_SIGN", @"Please sign in again") preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:strongSelf.view.window];

            FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
                [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FrtcMeetingMainViewShowNotification object:nil userInfo:nil];
            }];
            [alertWindow addAction:action];
        }];
    } else {
        FrtcScheduleMeetingModifyViewController *modifyViewControl = [[FrtcScheduleMeetingModifyViewController alloc] init];
        modifyViewControl.scheduleModel = ((ScheduleModel *)(self.scheduleModelArray.meeting_schedules[row]));
        modifyViewControl.delegate = self;
        modifyViewControl.scheduleModelArray = ((ScheduleModel *)(self.scheduleModelArray.meeting_schedules[row]));
        FrtcMainWindow *modifyWindow = [[FrtcMainWindow alloc] initWithSize:NSMakeSize(380, 660)];
        modifyWindow.contentViewController = modifyViewControl;
        
        [modifyWindow makeKeyAndOrderFront:self];
        [modifyWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
        [modifyWindow center];
    }
}

#pragma mark --FrtcScheduleFunctionControllerDelegate--
- (void)deleteNonCurrentMeetingWithReservationID:(NSString *)reservationID withRecurrence:(BOOL)isRecurrence {
    [self.funtionPopover close];
    if(!isRecurrence) {
         FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_CANCEL_MEETING_ABOUT", @"Cancel Meeting") withMessage:NSLocalizedString(@"FM_CANCEL_METTING_MESSAGE", @"All participants can not join this meeting once canceled") preferredStyle:FrtcWindowAlertStyleDefault withCurrentWindow:self.view.window];
      
        __weak __typeof(self)weakSelf = self;
        FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_CANCEL_ABOUT_YES", @"YES") style:FrtcWindowAlertActionStyleOK handler:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
      
            [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcDeleteCurrentMeeting:[[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN] withReservationId:reservationID withCancelALL:NO deleteCompletionHandler:^{
                    NSLog(@"delete meeting success!");
                    [strongSelf getScheduleMeetingList];
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
    } else {
        FrtcCancelMeetingWindow *cancelRecurrenceMeetingWindow = [[FrtcCancelMeetingWindow alloc] initWithSize:NSMakeSize(320, 160)];
        cancelRecurrenceMeetingWindow.cancelMeetingDelegate = self;
        cancelRecurrenceMeetingWindow.reservationID = reservationID;
        [cancelRecurrenceMeetingWindow showWindow];
    }
}

- (void)editSelectMeetingWitReservationID:(NSString *)reservationID withRecurrence:(BOOL)isRecurrence withRow:(NSInteger)row {
    if(isRecurrence) {
        FrtcModifyCancelTypeWindow *modifyMeetingWindow = [[FrtcModifyCancelTypeWindow alloc] initWithSize:NSMakeSize(332, 160)];
        modifyMeetingWindow.modifyDelegate = self;
        modifyMeetingWindow.row = row;
        modifyMeetingWindow.reversionID = reservationID;
        [modifyMeetingWindow showWindow];
    } else {
        FrtcScheduleMeetingViewController *scheduleMeetingViewController = [[FrtcScheduleMeetingViewController alloc] initWithNibName:nil bundle:nil];
        scheduleMeetingViewController.userName = self.model.username;
        scheduleMeetingViewController.meetingRooms = self.meetingRooms;
        scheduleMeetingViewController.delegate = self;
        scheduleMeetingViewController.updateView = YES;

        self.scheduleWindow = [[FrtcMainWindow alloc] initWithSize:NSMakeSize(380, 660)];
        self.scheduleWindow.titleVisibility       = NSWindowTitleHidden;
        self.scheduleWindow.contentViewController = scheduleMeetingViewController;

        //[scheduleMeetingViewController updateScheduleButtonName];
        [self.scheduleWindow makeKeyAndOrderFront:self];
        [self.scheduleWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
        [self.scheduleWindow center];
        
        __weak __typeof(self)weakSelf = self;
        [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcGetScheduleMeetingDetailInformation:[[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN] withReservationID:reservationID completionHandler:^(ScheduleSuccessModel * meetingDetailModel) {
            [scheduleMeetingViewController updateScheduleView:meetingDetailModel withRecurrence:isRecurrence];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_VERIFY_FAILURE", @"Verifyication failed") withMessage:NSLocalizedString(@"FM_RE_SIGN", @"Please sign in again") preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:strongSelf.view.window];

            FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
                [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FrtcMeetingMainViewShowNotification object:nil userInfo:nil];
            }];
            [alertWindow addAction:action];
        }];
    }
}

- (NSString *)dateTimeFromUtcTimeString:(NSTimeInterval )time1 withTimeForMatter:(NSString *)timeFormatter {
    NSTimeInterval time = time1 / 1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:timeFormatter];
    NSString *TimeDateString = [dateFormatter stringFromDate: detailDate];
    
    return TimeDateString;
}

- (NSString *)dateStringWithTimeString:(NSString *)timeString {
    NSTimeInterval time = [timeString doubleValue]/1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];

    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    
    return currentDateStr;
}


- (void)editCopyMeetingWitReservationID:(NSInteger)row withReservationID:(NSString *)reservationID {
    __weak __typeof(self)weakSelf = self;
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcGetScheduleMeetingDetailInformation:[[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN] withReservationID:reservationID completionHandler:^(ScheduleSuccessModel * meetingDetailModel) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        FrtcMeetingScheduleInfoWindow *scheduledInfoWindow = [[FrtcMeetingScheduleInfoWindow alloc] initWithSize:NSMakeSize(388, 410) withSuccessfulSchedule:NO];
       
        [scheduledInfoWindow setupMeetingInfo:meetingDetailModel];
        [scheduledInfoWindow makeKeyAndOrderFront:strongSelf];
        [scheduledInfoWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
        scheduledInfoWindow.titleVisibility       = NSWindowTitleHidden;
        
        
        [scheduledInfoWindow showWindow];
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
    ScheduleModel *detailModel = self.scheduleModelArray.meeting_schedules[row];
    
    FrtcRecurrenceDetailViewController *recurrenceDetailViewControl = [[FrtcRecurrenceDetailViewController alloc] init];
    recurrenceDetailViewControl.scheduleModel = detailModel;
    recurrenceDetailViewControl.delegate = self;
    recurrenceDetailViewControl.row = row;
    recurrenceDetailViewControl.groupID = detailModel.recurrence_gid;
    recurrenceDetailViewControl.invite = self.isInviteMeeting;
    if([detailModel.owner_id isEqualToString:self.model.user_id]) {
        recurrenceDetailViewControl.invite = NO;
    } else {
        if([detailModel.participantUsers containsObject:self.model.user_id]) {
            recurrenceDetailViewControl.invite = YES;
        } else {
            recurrenceDetailViewControl.addMeeting = YES;
        }
    }
    self.recurrenceDetailWindow = [[FrtcMainWindow alloc] initWithSize:NSMakeSize(380, 660)];
    self.recurrenceDetailWindow.contentViewController = recurrenceDetailViewControl;
    
   

    self.recurrenceDetailWindow.title = NSLocalizedString(@"FM_MEETING_RECURRENCE_TITLE", @"Recurring Meeting");
    [self.recurrenceDetailWindow makeKeyAndOrderFront:self];
    [self.recurrenceDetailWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    [self.recurrenceDetailWindow center];
}

- (void)removeDetailRecurrenceWithReservationID:(NSInteger)row {
//    FM_REMOVE_MEETING_FROMLIST = "Remove Meeting";
//    FM_REMOVE_MEETING_NORMAL_FROM_LIST_DETAIL = "You will remove this meeting from the meeting list";
    FrtcAlertMainWindow *alertWindow;
    if([((ScheduleModel *)self.scheduleModelArray.meeting_schedules[row]).meeting_type isEqualToString:@"recurrence"]) {
        alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_REMOVE_MEETING_RECURRENT_FROM_LIST", @"Remove the recurring meeting？") withMessage:NSLocalizedString(@"FM_REMOVE_MEETING_RECURRENT_FROM_LIST_DETAIL", @"You will remove this recurring meeting from the meeting list") preferredStyle:FrtcWindowAlertStyleDefault withCurrentWindow:self.view.window withWindowSize: NSMakeSize(286, 128)];
    } else {
        alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_REMOVE_MEETING_FROMLIST", @"Remove Meeting") withMessage:NSLocalizedString(@"FM_REMOVE_MEETING_NORMAL_FROM_LIST_DETAIL", @"You will remove this recurring meeting from the meeting list") preferredStyle:FrtcWindowAlertStyleDefault withCurrentWindow:self.view.window withWindowSize: NSMakeSize(286, 128)];
    }

    __weak __typeof(self)weakSelf = self;
    FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_REMOVE_MEETING_FROMLIST", @"Remove Meeting") style:FrtcWindowAlertActionStyleOK handler:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSString *meetingIdentifier;
        
        if([((ScheduleModel *)strongSelf.scheduleModelArray.meeting_schedules[row]).meeting_type isEqualToString:@"recurrence"]) {
            meetingIdentifier = ((ScheduleModel *)strongSelf.scheduleModelArray.meeting_schedules[row]).groupInfoKey;
        } else {
            meetingIdentifier = ((ScheduleModel *)strongSelf.scheduleModelArray.meeting_schedules[row]).meetingInfoKey;
        }
        [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcRemoveMeetingListFromUrl:[[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN] meetingIdentifier:meetingIdentifier completionHandler:^(NSDictionary * _Nonnull meetingInfo) {
                NSLog(@"Success");
                [strongSelf getScheduleMeetingList];
    
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"failure");
        }];
    }];
    
    [alertWindow addAction:action withTitleColor:[NSColor colorWithString:@"#E32726" andAlpha:1.0]];
    
    FrtcAlertAction *actionCancel = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_CANCEL_ABOUT", @"Not Now") style:FrtcWindowAlertActionStyleCancle handler:^{
    }];
    
    [alertWindow addAction:actionCancel];
}

#pragma mark --FrtcTagSelectCellDelegate--
- (void)didSelectedCell:(FrtcTagSelectCell *)cell {
    if(cell.tag == FrtcSelectSheduleTag) {
        if(cell.tag != _selectedCell.tag) {
            self.removeButton.hidden    = YES;
            self.scheduleLine.hidden    = NO;
            self.refreshButton.hidden   = NO;
            self.callHistoryLine.hidden = YES;
            self.selectTag = FrtcSelectSheduleTag;
            
            [self.scheduleSelectTagCell mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.view.mas_left).offset(24);
                make.top.mas_equalTo(self.lineView.mas_top).offset(10);
                make.size.mas_equalTo(NSMakeSize([self distance], 28));
            }];
            
            [self.callHistorySelectTagCell mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.lineView.mas_top).offset(9);
                make.left.mas_equalTo(self.scheduleSelectTagCell.mas_right).offset(32);
                make.size.mas_equalTo(NSMakeSize([self distance], 28));
            }];
            [self getScheduleMeetingList];
        }
    } else if(cell.tag == FrtcSelectCallHistoryTag) {
        if(cell.tag != _selectedCell.tag) {
            self.removeButton.hidden    = NO;
            self.scheduleLine.hidden    = YES;
            self.refreshButton.hidden   = YES;
            self.callHistoryLine.hidden = NO;
            self.selectTag = FrtcSelectCallHistoryTag;
            
            [self.scheduleSelectTagCell mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.view.mas_left).offset(24);
                make.top.mas_equalTo(self.lineView.mas_top).offset(9);
                make.size.mas_equalTo(NSMakeSize([self distance], 28));
            }];
            
            [self.callHistorySelectTagCell mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.lineView.mas_top).offset(10);
                make.left.mas_equalTo(self.scheduleSelectTagCell.mas_right).offset(32);
                make.size.mas_equalTo(NSMakeSize([self distance], 28));
            }];
            
            [self getRecentCallList];
        }
    }
    
    if (_selectedCell == cell) {
        return;
    }
    
    [_selectedCell disSelected];
    _selectedCell = cell;
    [_selectedCell selected];
}


#pragma mark --FrtcDetailMeetingViewControllerDelegate--
- (void)popupRecurrenceDetailView:(NSInteger)row withInvite:(BOOL)isInvite {
    self.inviteMeeting = isInvite;
    [self viewDetailRecurrenceWithReservationID:row];
}
- (void)updateScheduleMeetingWithRecurrence:(BOOL)isRecurrence withReversionID:(NSString *)reversionID withRow:(NSInteger)row {
    [self modifyMeetingWithRecurrence:isRecurrence withReversionID:reversionID withRow:row];
}

- (void)joinCall:(MeetingDetailModel *)model {
    [self.meetingDetailWindow close];
    
    FRTCMeetingParameters callParam;
    callParam.meeting_alias         = model.meetingNumber;
    callParam.display_name          =  self.model.realName ? self.model.realName : [NSString stringWithFormat:@"%@%@", self.model.lastname, self.model.firstname];
    callParam.user_token            = [[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN];
    callParam.meeting_password      = model.meetingPassword;
    callParam.user_id               = self.model.user_id;
    
    callParam.video_mute            = YES;
    callParam.audio_mute            = YES;
    callParam.audio_only            = NO;
    
    [self makeCall:callParam];
}

- (void)updateScheduleMeetingWhenDeleteSuccess {
    [self getScheduleMeetingList];
}

- (void)deleteMeetingWithReservationID:(NSString *)reservationID {
    __weak __typeof(self)weakSelf = self;
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcDeleteCurrentMeeting:[[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN] withReservationId:reservationID
                                     withCancelALL:NO
                                    deleteCompletionHandler:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            NSLog(@"delete meeting success!");
            [strongSelf getScheduleMeetingList];
        } deleteFailure:^(NSError * _Nonnull error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if([error.localizedDescription isEqualToString:@"Request failed: unauthorized (401)"]) {
                FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_VERIFY_FAILURE", @"Verifyication failed") withMessage:NSLocalizedString(@"FM_RE_SIGN", @"Please sign in again") preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:strongSelf.view.window];

                FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
                    [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FrtcMeetingMainViewShowNotification object:nil userInfo:nil];
                }];
                [alertWindow addAction:action];
            }
    }];
}

- (void)removeInfomationItem:(NSString *)meetingStartTime {
    [self.meetingDetailWindow close];
    [[FrtcPersistence sharedUserPersistence] deleteHistoryMeetingWithMeetingStartTime:meetingStartTime];
    [self getRecentCallList];
}


#pragma mark --FrtcCallWindowDelegate--
- (void)makeCall:(FRTCMeetingParameters)callParam {
    NSString *userToken = [[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN];
    callParam.user_token = userToken;
    callParam.call_rate  = 0;
    self.maskView.alphaValue = 0.2;
    [self.view addSubview:self.maskView];
    self.makeCallProgress.hidden = NO;
    [self.view addSubview:self.makeCallProgress];
    [self.makeCallProgress startAnimation:self];
    
    __weak __typeof(self)weakSelf = self;
    
    BOOL authority;
    if([self.model.role containsObject:@"MeetingOperator"] || [self.model.role containsObject:@"SystemAdmin"]) {
        authority = YES;
    } else {
        authority = NO;
    }
    
    [[FrtcCallInterface singletonFrtcCall] frtcJoinMeetingWithCallParam:callParam withAuthority:authority withJoinMeetingSuccessfulCallBack:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.callSuccess = YES;
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.makeCallProgress stopAnimation:strongSelf];
            strongSelf.makeCallProgress.hidden = YES;
            [strongSelf.maskView removeFromSuperview];
            strongSelf.setupMeetingButton.enabled ? : strongSelf.setupMeetingButton.enabled = YES;
            
            if(strongSelf.rosterTableView.numberOfRows != 0) {
                if(self.selectTag == FrtcSelectSheduleTag) {
                    FrtcScheduleMeetingTableViewCell* cell = (FrtcScheduleMeetingTableViewCell *)[strongSelf.rosterTableView viewAtColumn:0 row:strongSelf.selectRow makeIfNecessary:NO];
                    cell.joinMeetingButton.enabled ? : cell.joinMeetingButton.enabled = YES;
                } else {
                    FrtcHistoryCallTableViewCell* cell = (FrtcHistoryCallTableViewCell *)[strongSelf.rosterTableView viewAtColumn:0 row:strongSelf.selectRow makeIfNecessary:NO];
                    cell.joinMeetingButton.enabled ? : cell.joinMeetingButton.enabled = YES;
                }
            }
        });
    } withJoinMeetingFailureCalBack:^(FRTCMeetingStatusReason reason) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
    
        strongSelf.setupMeetingButton.enabled ? : strongSelf.setupMeetingButton.enabled = YES;
        if(strongSelf.rosterTableView.numberOfRows != 0) {
            if(self.selectTag == FrtcSelectSheduleTag) {
                FrtcScheduleMeetingTableViewCell* cell = (FrtcScheduleMeetingTableViewCell *)[strongSelf.rosterTableView viewAtColumn:0 row:strongSelf.selectRow makeIfNecessary:NO];
                cell.joinMeetingButton.enabled ? : cell.joinMeetingButton.enabled = YES;
            } else {
                FrtcHistoryCallTableViewCell* cell = (FrtcHistoryCallTableViewCell *)[strongSelf.rosterTableView viewAtColumn:0 row:strongSelf.selectRow makeIfNecessary:NO];
                cell.joinMeetingButton.enabled ? : cell.joinMeetingButton.enabled = YES;
            }
        }
        
        [strongSelf hangupCall];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.makeCallProgress stopAnimation:strongSelf];
            strongSelf.makeCallProgress.hidden = YES;
            [strongSelf.maskView removeFromSuperview];
            
            NSString *failureReason;
            
            if(reason == MEETING_STATUS_SERVERERROR) {
                failureReason = NSLocalizedString(@"FM_SERVER_UNREACHABLE", @"Please check your server setting");
                [self showAlertWindow:failureReason];
                return;
            } else if(reason == MEETING_STATUS_LOCKED) {
                failureReason = NSLocalizedString(@"FM_MEETING_LOCKED", @"Meeting locked");
                [self showAlertWindow:failureReason];
                return;
            } else if(reason == MEETING_STATUS_MEETINGNOTEXIST) {
                failureReason = NSLocalizedString(@"FM_MEETING_NOT_EXIST", @"The meeting requires sign in or doesn't exist. Retry after sign in");
            } else if(reason == MEETING_STATUS_ABORTED) {
                failureReason = NSLocalizedString(@"FM_MEETING_CALL_ENDED", @"Meeting Ended");
                return;
            } else if(reason == MEETING_STATUS_STOP) {
                if(!self.isCallSuccess) {
                    return;
                }
                
                FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_MEETING_CALL_ENDED", @"Meeting Ended") withMessage:NSLocalizedString(@"FM_MEETING_CALL_ENDED_BYUSER", @"The meeting has been ended by the host") preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:self.view.window];

                FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_MEETING_CALL_ENDED_KOOWEN", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
                }];
                
                [alertWindow addAction:action];
            
                strongSelf.callSuccess = NO;
                return;
            } else if(reason == MEETING_STATUS_REMOVE) {
                FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_MEETING_CALL_ENDED", @"Meeting Ended") withMessage:NSLocalizedString(@"FM_MEETING_HOST_REMOVE", @"You have been removed from the meeting by host") preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:self.view.window];

                FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_MEETING_CALL_ENDED_KOOWEN", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
                    
                }];
                
                [alertWindow addAction:action];
            
                return;
            } else if(reason == MEETING_STATUS_PASSWORD_TOO_MANY_RETRIES) {
                failureReason = NSLocalizedString(@"FM_MEETING_PWD_MAX", @"The maximum number of incorrect passwords has been reached, please rejoin the meeting");
            } else if(reason == MEETING_STATUS_EXPIRED) {
                failureReason =  NSLocalizedString(@"FM_MEETING_OVERTIME", @"Meeting expired");
                [self showAlertWindow:failureReason];
                return;
            } else if(reason == MEETING_STATUS_NOT_STARTED) {
                failureReason =  NSLocalizedString(@"FM_MEETING_JOIN_BEFORE_THIRTY_MINMUTES", @"You can join the meeting 30 minutes before the meeting starts");;
                [self showAlertWindow:failureReason];
                return;
            } else if(reason == MEETING_STATUS_GUEST_UNALLOWED) {
                failureReason =  NSLocalizedString(@"FM_NOT_ALLOW_GUEST", @"Guest users can't join this meeting, please sign in and try again");;
                [self showAlertWindow:failureReason];
                return;
            } else if(reason == MEETING_STATUS_PEOPLE_FULL) {
                failureReason =  NSLocalizedString(@"FM_FULL_LIST", @"Join meeting failed, the meeting is full");
                [self showAlertWindow:failureReason];
                return;
            } else if(reason == MEETING_STATUS_NO_LICENSE) {
                failureReason = NSLocalizedString(@"FM_CERTIFICATE_EXPIRED", @"No software license or license has expired");
                [self showAlertWindow:failureReason];
                return;
            } else if(reason == MEETING_STATUS_LICENSE_MAX_LIMIT_REACHED) {
                failureReason =  NSLocalizedString(@"FM_NEED_UPDATE_LICENSE_FOR_USERS", @"The number of users has reached the maximum, please upgrade your software license");
                [self showAlertWindow:failureReason];
                return;
            }
            else {
                failureReason = NSLocalizedString(@"FM_MEETING_NOT_EXIST", @"The meeting requires sign in or doesn't exist. Retry after sign in");
            }
            
            [strongSelf showReminderView:failureReason];
        });
    } withRequestPasswordCallBack:^(BOOL requestError) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            FrtcInputPasswordWindow *inputPasswordWindow = [[FrtcInputPasswordWindow alloc] initWithSize:NSMakeSize(280, 172)];
            inputPasswordWindow.inputPasscodeDelegate = strongSelf;
            [inputPasswordWindow showWindow];
            
            if(requestError) {
                [inputPasswordWindow displayToast];
            }
        });
    }];
}

- (void)showAlertWindow:(NSString *)reminderValue {
    FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_JOIN_FAILURE", @"Join Meeting Failed") withMessage:reminderValue preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:self.view.window];

    FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
        
    }];
    [alertWindow addAction:action];
}

- (void)showServerErrorInfo {
    FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:@"" withMessage:NSLocalizedString(@"FM_ADD_MEETING_SERVER_ERROR", @"Not supported for joining external systems") preferredStyle:FrtcWindowAlertStyleNoTitle withCurrentWindow:self.view.window];
    
    FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
        [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FrtcMeetingMainViewShowNotification object:nil userInfo:nil];
    }];
    
    [alertWindow addAction:action];
}

- (void)addMeeing:(NSString *)url {
    NSArray *array = [url componentsSeparatedByString:@"://"];
    NSString *meetingIdentifier;
    
    if(array.count == 2) {
        NSString *uri = array[1];
        NSArray *uriArray = [uri componentsSeparatedByString:@"/"];
        meetingIdentifier = uriArray[2];
    }
    
    __weak __typeof(self)weakSelf = self;
        
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcAddMeetingListFromUrl:[[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN] meetingIdentifier:meetingIdentifier completionHandler:^(NSDictionary * _Nonnull meetingInfo) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf showReminderView:NSLocalizedString(@"FM_ADD_MEETING_LIST_SUCCESS", @"Added to the meeting list successfully")];
        [strongSelf getScheduleMeetingList];
    } failure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf showReminderView:NSLocalizedString(@"FM_ADD_MEETING_LIST_FAILURE", @"Adding to meeting list failed")];
    }];
}

- (void)makeUrlCall:(NSString *)url {
    FRTCMeetingParameters callParam;
    
    callParam.meeting_url           = url;
    callParam.meeting_alias         = @"";
    callParam.display_name          = self.model.realName ? self.model.realName : [NSString stringWithFormat:@"%@%@", self.model.lastname, self.model.firstname];
    callParam.call_rate             = 0;
    callParam.video_mute            = YES;
    callParam.audio_mute            = YES;
    callParam.audio_only            = NO;
    
    callParam.user_id               = self.model.user_id;
    
    [self makeCall:callParam];
}


#pragma mark --FrtcInputPasswordWindow--
- (void)sendPasscode:(NSString *)passcode {
    [[FrtcCallInterface singletonFrtcCall] frtcSendPassword:passcode];
}

- (void)cancelSendPasscode {
    [self.makeCallProgress stopAnimation:self];
    self.makeCallProgress.hidden = YES;
    [self.makeCallProgress removeFromSuperview];
    [self.maskView removeFromSuperview];
    
    [[FrtcCallInterface singletonFrtcCall] endMeeting];
}

#pragma mark --NSPopoverDelegate--
- (void)popoverWillClose:(NSNotification *)notification {
    self.usingPersonalNumber = ((FrtcScheduleViewController *)self.popover.contentViewController).isPersonalNumber;
    if(self.usingPersonalNumber) {
        self.personalMeetingNumber = ((FrtcScheduleViewController *)self.popover.contentViewController).personaConferencelNumber;
        self.personalMeetingPassword = ((FrtcScheduleViewController *)self.popover.contentViewController).personalConferencePassword;
        NSLog(@"The personal meeting number is %@, the personal meeting password is %@", self.personalMeetingNumber, self.personalMeetingPassword);
    } else {
        NSLog(@"Dn not user the personal number");
    }
}

#pragma mark --HoverImageViewDelegate--
- (void)didIntoArea:(BOOL)isInImageViewArea withSenderTag:(NSInteger)tag {
    if(isInImageViewArea) {
        if(!self.popover.isShown) {
            NSViewController *controller;
            NSImageView *imageView;
            
            if(tag == 201) {
                controller = [[FrtcPersonalViewController alloc] init];
                ((FrtcPersonalViewController *)controller).delegate = self;
                ((FrtcPersonalViewController *)controller).model = self.model;
                imageView = self.userImageView;
            } else if(tag == 202) {
                controller = [[FrtcScheduleViewController alloc] init];
                ((FrtcScheduleViewController *)controller).meetingRooms = self.meetingRooms;
                imageView = self.arrorwImageView;
            }
            
            self.popover = [[NSPopover alloc] init];
            self.popover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];
            if(tag == 202) {
                self.popover.delegate = self;
            }
            
            self.popover.contentViewController = controller;
            self.popover.behavior = NSPopoverBehaviorTransient;
        
            [self.popover showRelativeToRect:imageView.frame ofView:self.userImageView.superview preferredEdge:NSRectEdgeMinY];
        }
    } 
}

- (void)hoverImageViewClickedwithSenderTag:(NSInteger)tag {
    if(!self.popover.isShown) {
        NSViewController *controller;
        NSImageView *imageView;
        
        if(tag == 201) {
            controller = [[FrtcPersonalViewController alloc] init];
            ((FrtcPersonalViewController *)controller).delegate = self;
            ((FrtcPersonalViewController *)controller).model = self.model;
            imageView = self.userImageView;
        } else if(tag == 202) {
            controller = [[FrtcScheduleViewController alloc] init];
            ((FrtcScheduleViewController *)controller).meetingRooms = self.meetingRooms;
            imageView = self.arrorwImageView;
        }
        
        self.popover = [[NSPopover alloc] init];
        self.popover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];
        
        if(tag == 202) {
            self.popover.delegate = self;
        }
        
        self.popover.contentViewController = controller;
        self.popover.behavior = NSPopoverBehaviorTransient;
    
        [self.popover showRelativeToRect:imageView.frame ofView:self.userImageView.superview preferredEdge:NSRectEdgeMinY];
    } else {
        NSLog(@"Do nothing!!!");
    }
}

#pragma mark --FrtcPersonalViewControllerDelegate--
- (void)frtcPersonalViewLogout {
    if(self.popover.isShown) {
        [self.popover close];
    }
    
    NSString *userToken = [[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN];
    
    __weak __typeof(self)weakSelf = self;
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcLogoutWithUserToken:userToken logoutSuccess:^(NSDictionary * _Nonnull userInfo) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if([strongSelf.settingWindow isVisible]) {
            [strongSelf.settingWindow close];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FrtcMeetingMainViewShowNotification object:nil userInfo:userInfo];
        [[FrtcUserDefault defaultSingleton] setObject:@"" forKey:USER_ID];
        
    } logoutFailure:^(NSError * _Nonnull error) {
        if([error.localizedDescription isEqualToString:@"Request failed: unauthorized (401)"]) {
            FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_VERIFY_FAILURE", @"Verifyication failed") withMessage:NSLocalizedString(@"FM_RE_SIGN", @"Please sign in again") preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:self.view.window];
            
            FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
                [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FrtcMeetingMainViewShowNotification object:nil userInfo:nil];
            }];
            [alertWindow addAction:action];
        }
    }];
}

- (void)frtcPersonalViewUpdatePassword {
    if(self.popover.isShown) {
        [self.popover close];
    }
    
    self.updatePasswordWindow = [[FrtcUpdatePasswordWindow alloc] initWithSize:NSMakeSize(380, 455)];
    self.updatePasswordWindow.normalUser = [self.model.securityLevel isEqualToString:@"NORMAL"] ? YES : NO;
    [self.updatePasswordWindow setupPasswordSecurityLevel];
    
    self.updatePasswordWindow.modifyDelegate = self;
    
    [self.updatePasswordWindow setMovable:NO];
    self.updatePasswordWindow.titlebarAppearsTransparent = YES;
    self.updatePasswordWindow.backgroundColor = [NSColor whiteColor];
    self.updatePasswordWindow.styleMask = NSWindowStyleMaskTitled|NSWindowStyleMaskClosable | NSWindowStyleMaskFullSizeContentView;
    
    [self.updatePasswordWindow showWindow];
}

- (void)frtcPersonalPopupModifyNameWindow {
    if(self.popover.isShown) {
        [self.popover close];
    }
    
    FrtcModifyNameWindow *modifyNameWindow = [[FrtcModifyNameWindow alloc] initWithSize:NSMakeSize(290, 176)];
    modifyNameWindow.modifyNameDelegate = self;
    modifyNameWindow.titlebarAppearsTransparent = YES;
    modifyNameWindow.backgroundColor = [NSColor whiteColor];
    modifyNameWindow.styleMask = NSWindowStyleMaskTitled | NSWindowStyleMaskFullSizeContentView;
    [modifyNameWindow showWindow];
    [modifyNameWindow setDisplayName:self.displayName];
}

#pragma mark --FrtcModifyNameWindowDelegate--
- (void)saveDisplayName:(NSString *)displayName {
    self.displayName = displayName;
}

#pragma mark --FrtcUpdatePasswordWindowDelegate--
- (void)modifyPassWord:(NSString *)oldPasssword newPassword:(NSString *)newPassword {
    NSString *userToken = [[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN];
    if(userToken == nil || [userToken isEqualToString:@""]) {
        NSLog(@"modify password failuer");
    }
    
    __weak __typeof(self)weakSelf = self;
    
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcUpdatePasswordWithUserToken:userToken oldPassword:oldPasssword newPassword:newPassword modifyCompletionHandler:^(FRTCSDKModifyPasswordResult result) {
        if(result == FRTCSDK_MODIFY_PASSWORD_SUCCESS) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.updatePasswordWindow orderOut:nil];
                strongSelf.maskView.alphaValue = 0.2;
                [strongSelf.view addSubview:strongSelf.maskView];
                
                FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_PASSWORD_CHANGE_OK", @"Password update successfully") withMessage:NSLocalizedString(@"FM_PASSWORD_LOGINCHANGE_OK", @"Your password was updated, please login again") preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:self.view.window];
    
                FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
                    if([strongSelf.settingWindow isVisible]) {
                        [strongSelf.settingWindow close];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FrtcMeetingMainViewShowNotification object:nil userInfo:nil];
                }];
                [alertWindow addAction:action];
            });
            
        } else if(result == FRTCSDK_MODIFY_PASSWORD_FAILED) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.updatePasswordWindow showReminderView:NSLocalizedString(@"FM_PASSWORD_OLD_PASSWORD_ERROR", @"Update password failed")];
            });
        }
    }];
}

#pragma mark --FrtcHistoryCallTableViewCellDelegate
- (void)removeCallHistoryAtRow:(NSInteger)row {
    FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_DELETE_MEETING", @"Delete Meeting") withMessage:NSLocalizedString(@"FM_DELETE_MEETING_SURE", @"Are you sure to delete this meeting from history meetings?") preferredStyle:FrtcWindowAlertStyleDefault withCurrentWindow:self.view.window];

    __weak __typeof(self)weakSelf = self;
    FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSString *startTime = strongSelf.recentCallList[row].meetingStartTime;
        [[FrtcPersistence sharedUserPersistence] deleteHistoryMeetingWithMeetingStartTime:startTime];
        [strongSelf getRecentCallList];
 
    }];
    
    [alertWindow addAction:action];
    
    FrtcAlertAction *actionCancel = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_CANCEL", @"Cancel") style:FrtcWindowAlertActionStyleCancle handler:^{
    }];
    
    [alertWindow addAction:actionCancel];
}

- (void)joinMeetingAtRow:(NSInteger)row {
    self.selectRow = row;
    FRTCMeetingParameters callParam;
    callParam.meeting_alias         = self.recentCallList[row].meetingNumber;
    callParam.display_name          = self.displayName;//self.model.username;
    callParam.user_token            = [[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN];
    callParam.meeting_password      = self.recentCallList[row].meetingPassword;
    callParam.user_id               = self.model.user_id;
    
    callParam.video_mute            = YES;
    callParam.audio_mute            = YES;
    callParam.audio_only            = NO;
    
    [self makeCall:callParam];
}

#pragma mark --FrtcAlertWindowDelegate--
- (void)logoutNotification {
    [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FrtcMeetingMainViewShowNotification object:nil userInfo:nil];
}

#pragma mark -- For --<NSTableViewDelegate, NSTableViewDataSource>-- Internal Function
- (NSTableCellView *)AccoutTableViewCellWithTableView:(NSTableView *)tableView withTableViewRow:(NSInteger)row {
    NSTableCellView *cell;
    if(self.selectTag == FrtcSelectSheduleTag) {
        cell = [tableView makeViewWithIdentifier:@"FrtcScheduleMeetingTableViewCell" owner:self];
        if(cell == nil) {
            cell = [[FrtcScheduleMeetingTableViewCell alloc] init];
            ((FrtcScheduleMeetingTableViewCell *)cell).controllerDelegate = self;
            cell.identifier = @"FrtcScheduleMeetingTableViewCell";
        } else {
            [((FrtcScheduleMeetingTableViewCell *)cell) remakeUpdateLayout];
        }
        ScheduleModel *scheduleModel = self.scheduleModelArray.meeting_schedules[row];
        
        if([scheduleModel.meeting_type isEqualToString:@"recurrence"]) {
            ((FrtcScheduleMeetingTableViewCell *)cell).recurrenceView.hidden = NO;
        } else {
            ((FrtcScheduleMeetingTableViewCell *)cell).recurrenceView.hidden = YES;
        }
            
        NSString *startTime = [[FrtcBaseImplement baseImpleSingleton] dateStringWithAccountTimeString:scheduleModel.schedule_start_time];
        NSString *endTime   = [[FrtcBaseImplement baseImpleSingleton] dateStringWithAccountTimeString:scheduleModel.schedule_end_time];
            
        ((FrtcScheduleMeetingTableViewCell *)cell).meetingNameTextField.stringValue   = scheduleModel.meeting_name ? scheduleModel.meeting_name : @"";
        ((FrtcScheduleMeetingTableViewCell *)cell).numberTextField.stringValue        = scheduleModel.meeting_number ? scheduleModel.meeting_number : @"";
        ((FrtcScheduleMeetingTableViewCell *)cell).timeTextField.stringValue          = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
            
        ((FrtcScheduleMeetingTableViewCell *)cell).row = row;
        NSTimeInterval time = [scheduleModel.schedule_end_time doubleValue] / 1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
        NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
            
        NSDate *dateNow = [NSDate date];
        NSComparisonResult result = [dateNow compare:detailDate];
        time = [scheduleModel.schedule_start_time doubleValue] / 1000;
        detailDate = [NSDate dateWithTimeIntervalSince1970:time];
        NSComparisonResult result1 = [dateNow compare:detailDate];
        
        if(result1 == NSOrderedDescending && result == NSOrderedAscending) {
            ((FrtcScheduleMeetingTableViewCell *)cell).reminderNowMeetingTextField.hidden = NO;
        } else {
            ((FrtcScheduleMeetingTableViewCell *)cell).reminderNowMeetingTextField.hidden = YES;
        }
        
        time = [scheduleModel.schedule_start_time doubleValue] / 1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
        detailDate = [NSDate dateWithTimeIntervalSince1970:time];
        dateNow = [NSDate date];
        
        result = [dateNow compare:detailDate];
        if(result == NSOrderedAscending) {
            NSTimeInterval timeDistance = [detailDate timeIntervalSinceDate:dateNow];
            if(timeDistance <= 900) {
                ((FrtcScheduleMeetingTableViewCell *)cell).reminderBeginMeetingTextField.hidden = NO;
            } else {
                ((FrtcScheduleMeetingTableViewCell *)cell).reminderBeginMeetingTextField.hidden = YES;
            }
        }
        
        if([scheduleModel.owner_id isEqualToString:self.model.user_id]) {
            ((FrtcScheduleMeetingTableViewCell *)cell).arrowImageView.hidden = YES;
        } else {
            if([scheduleModel.participantUsers containsObject:self.model.user_id]) {
                ((FrtcScheduleMeetingTableViewCell *)cell).arrowImageView.hidden = NO;
            } else {
                ((FrtcScheduleMeetingTableViewCell *)cell).arrowImageView.hidden = YES;
            }
        }
        
        [((FrtcScheduleMeetingTableViewCell *)cell) updateLayout];
    } else {
        cell = [tableView makeViewWithIdentifier:@"FrtcHistoryCallTableViewCell" owner:self];
        if(cell == nil) {
            cell = [[FrtcHistoryCallTableViewCell alloc] init];
            ((FrtcHistoryCallTableViewCell *)cell).delegate = self;
            cell.identifier = @"FrtcHistoryCallTableViewCell";
        }
        
        ((FrtcHistoryCallTableViewCell *)cell).row = row;
        
        MeetingDetailModel *detailModel = self.recentCallList[row];
        NSString *startTime = [[FrtcBaseImplement baseImpleSingleton] dateStringWithTimeString:detailModel.meetingStartTime];
        //NSString *endTime   = [[FrtcBaseImplement baseImpleSingleton] dateStringWithTimeString:detailModel.meetingEndTime];

        ((FrtcHistoryCallTableViewCell *)cell).meetingNameTextField.stringValue   = detailModel.meetingName ? detailModel.meetingName : @"";
        ((FrtcHistoryCallTableViewCell *)cell).numberTextField.stringValue        = detailModel.meetingNumber ? detailModel.meetingNumber : @"";
       // ((FrtcHistoryCallTableViewCell *)cell).timeTextField.stringValue          = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
        ((FrtcHistoryCallTableViewCell *)cell).timeTextField.stringValue          = [NSString stringWithFormat:@"%@", startTime];
    }
    
    return cell;
}

#pragma mark --<NSTableViewDelegate, NSTableViewDataSource>--
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if(self.selectTag == FrtcSelectSheduleTag) {
        return self.scheduleModelArray.meeting_schedules.count;
    } else {
        return self.recentCallList.count;
    }
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return [self AccoutTableViewCellWithTableView:tableView withTableViewRow:row];
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 89;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    if(self.selectTag == FrtcSelectSheduleTag) {
        [self popupDetailViewController:row withIndex:0];
        return NO;
    }
    if([self.meetingDetailWindow isVisible]) {
        [self.meetingDetailWindow makeKeyAndOrderFront:self];
        [((FrtcDetailMeetingViewController *)self.meetingDetailWindow.contentViewController) updateMeetingInfomation:self.recentCallList[row]];
    } else {
        MeetingDetailModel *detailModel = self.recentCallList[row];
        FrtcDetailMeetingViewController *meetingDetailViewController = [[FrtcDetailMeetingViewController alloc] initWithNibName:nil bundle:nil];
    
        meetingDetailViewController.detailMeetingInfoModel = detailModel;
        meetingDetailViewController.delegate = self;
        
        self.meetingDetailWindow = [[FrtcMainWindow alloc] initWithSize:NSMakeSize(380, 660)];
        self.meetingDetailWindow.contentViewController = meetingDetailViewController;
    
        self.meetingDetailWindow.title = NSLocalizedString(@"FM_MEETING_DETAILS", @"Meeting Detail");
        [self.meetingDetailWindow makeKeyAndOrderFront:self];
        [self.meetingDetailWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
        [self.meetingDetailWindow center];
    }
    
    return NO;
}

#pragma mark --getter load--
- (NSImageView *)userImageView {
    if (!_userImageView){
        _userImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_userImageView setImage:[NSImage imageNamed:@"icon_logo_blue"]];
        _userImageView.tag = 201;
       // _userImageView.delegate = self;
        _userImageView.imageAlignment = NSImageAlignTopLeft;
        _userImageView.imageScaling   =  NSImageScaleAxesIndependently;
        [self.view addSubview:_userImageView];
    }
    
    return _userImageView;
}

- (NSTextField *)displayNameTextField {
    if (!_displayNameTextField){
        _displayNameTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _displayNameTextField.stringValue = NSLocalizedString(@"FM_APP_NAME", @"FR App Name");
        _displayNameTextField.bordered = NO;
        _displayNameTextField.drawsBackground = NO;
        _displayNameTextField.backgroundColor = [NSColor clearColor];
        _displayNameTextField.layer.backgroundColor = [NSColor colorWithString:@"FFFFFF" andAlpha:1.0].CGColor;
        _displayNameTextField.font = [NSFont systemFontOfSize:16 weight:NSFontWeightMedium];
        _displayNameTextField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
        _displayNameTextField.alignment = NSTextAlignmentLeft;
        _displayNameTextField.editable = NO;
        [self.view addSubview:_displayNameTextField];
    }
    
    return _displayNameTextField;
}

- (FrtcHoverButton *)settingButton {
    if (!_settingButton) {
        _settingButton = [[FrtcHoverButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [_settingButton setOffStatusImagePath:@"icon-settings"];
        _settingButton.bezelStyle = NSBezelStyleRegularSquare;
        _settingButton.target = self;
        _settingButton.action = @selector(onSettingBtnPressed:);
        [self.view addSubview:_settingButton];
    }
    
    return _settingButton;
}

- (FrtcHoverButton *)setupMeetingButton {
    if (!_setupMeetingButton) {
        _setupMeetingButton = [[FrtcHoverButton alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
        [_setupMeetingButton setOffStatusImagePath:@"icon-setup"];
        _setupMeetingButton.bezelStyle = NSBezelStyleRegularSquare;
        _setupMeetingButton.target = self;
        _setupMeetingButton.action = @selector(onSetupMeetingButtonPressed:);
        [self.view addSubview:_setupMeetingButton];
    }
    
    return _setupMeetingButton;
}

- (FrtcHoverButton *)joinMeetingButton {
    if (!_joinMeetingButton) {
        _joinMeetingButton = [[FrtcHoverButton alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
        [_joinMeetingButton setOffStatusImagePath:@"icon-joining"];
        _joinMeetingButton.bezelStyle = NSBezelStyleRegularSquare;
        _joinMeetingButton.target = self;
        _joinMeetingButton.action = @selector(onJoinMeetingButtonPressed:);
        [self.view addSubview:_joinMeetingButton];
    }
    
    return _joinMeetingButton;
}

- (FrtcHoverButton *)scheduleMeetingButton {
    if (!_scheduleMeetingButton) {
        _scheduleMeetingButton = [[FrtcHoverButton alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
        [_scheduleMeetingButton setOffStatusImagePath:@"icon-schedule"];
        _scheduleMeetingButton.bezelStyle = NSBezelStyleRegularSquare;
        _scheduleMeetingButton.target = self;
        _scheduleMeetingButton.action = @selector(onScheduleMeetingButtonBtnPressed:);
        [self.view addSubview:_scheduleMeetingButton];
    }
    
    return _scheduleMeetingButton;
}

- (HoverImageView *)arrorwImageView {
    if (!_arrorwImageView){
        _arrorwImageView = [[HoverImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
        _arrorwImageView.tag = 202;
        [_arrorwImageView setImage:[NSImage imageNamed:@"icon-arrow-down"]];
        _arrorwImageView.delegate = self;
        _arrorwImageView.imageAlignment = NSImageAlignTopLeft;
        _arrorwImageView.imageScaling   =  NSImageScaleAxesIndependently;
        [self.view addSubview:_arrorwImageView];
    }
    
    return _arrorwImageView;
}

- (HoverImageView *)scheduleRefreshView {
    if (!_scheduleRefreshView){
        _scheduleRefreshView = [[HoverImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 2)];
        _scheduleRefreshView.tag = 202;
        [_scheduleRefreshView setImage:[NSImage imageNamed:@"icon-refresh"]];
        _scheduleRefreshView.delegate = self;
        _scheduleRefreshView.imageAlignment = NSImageAlignTopLeft;
        _scheduleRefreshView.imageScaling   =  NSImageScaleAxesIndependently;
        [self.view addSubview:_scheduleRefreshView];
    }
    
    return _scheduleRefreshView;
}

- (NSTextField *)setupMeetingTextField {
    if (!_setupMeetingTextField) {
        _setupMeetingTextField = [self textField];
        _setupMeetingTextField.stringValue = NSLocalizedString(@"FM_NEW_MEETING", @"Instant");
        [self.view addSubview:_setupMeetingTextField];
    }
    
    return _setupMeetingTextField;
}

- (NSTextField *)joinMeetingTextField {
    if (!_joinMeetingTextField){
        _joinMeetingTextField = [self textField];
        _joinMeetingTextField.stringValue = NSLocalizedString(@"FM_JOIN_MEETING", @"Join");;
        [self.view addSubview:_joinMeetingTextField];
    }
    
    return _joinMeetingTextField;
}

- (NSTextField *)scheduleMeetingTextField {
    if (!_scheduleMeetingTextField){
        _scheduleMeetingTextField = [self textField];
        _scheduleMeetingTextField.stringValue = NSLocalizedString(@"FM_SCHEDULE_MEETING", @"Schedule");
        [self.view addSubview:_scheduleMeetingTextField];
    }
    
    return _scheduleMeetingTextField;
}

- (NSView *)lineView {
    if(!_lineView) {
        _lineView = [[NSView alloc] initWithFrame:CGRectMake(0, 212, 380, 8)];
        _lineView.wantsLayer = YES;
        _lineView.layer.backgroundColor = [NSColor colorWithString:@"F8F9FA" andAlpha:1.0].CGColor;
        [self.view addSubview:_lineView];
    }
    
    return _lineView;
}

- (NSTextField *)callHistoryTextField {
    if (!_callHistoryTextField){
        _callHistoryTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _callHistoryTextField.stringValue = NSLocalizedString(@"FM_HISTORY_MEETING", @"History");
        _callHistoryTextField.bordered = NO;
        _callHistoryTextField.drawsBackground = NO;
        _callHistoryTextField.backgroundColor = [NSColor clearColor];
        _callHistoryTextField.layer.backgroundColor = [NSColor colorWithString:@"FFFFFF" andAlpha:1.0].CGColor;
        _callHistoryTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightMedium];
        _callHistoryTextField.textColor = [NSColor colorWithString:@"333333" andAlpha:1.0];
        _callHistoryTextField.alignment = NSTextAlignmentLeft;
        _callHistoryTextField.editable = NO;
        [self.view addSubview:_callHistoryTextField];
    }
    
    return _callHistoryTextField;
}

- (NSImageView *)timerImageView {
    if (!_timerImageView){
        _timerImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        [_timerImageView setImage:[NSImage imageNamed:@"icon-timer"]];
        _timerImageView.imageAlignment =  NSImageAlignTopLeft;
        _timerImageView.imageScaling =  NSImageScaleAxesIndependently;
        [self.view addSubview:_timerImageView];
    }
    return _timerImageView;
}

- (FrtcHoverButton *)removeButton {
    if (!_removeButton) {
        _removeButton = [[FrtcHoverButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        [_removeButton setOffStatusImagePath:@"icon-remove"];
        _removeButton.bezelStyle = NSBezelStyleRegularSquare;
        _removeButton.hidden = YES;
        _removeButton.target = self;
        _removeButton.action = @selector(onRemoveButtonPressed:);
        [self.view addSubview:_removeButton];
    }
    
    return _removeButton;
}

- (FrtcHoverButton *)refreshButton {
    if (!_refreshButton) {
        _refreshButton = [[FrtcHoverButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        [_refreshButton setOffStatusImagePath:@"icon-refresh"];
        _refreshButton.bezelStyle = NSBezelStyleRegularSquare;
        _refreshButton.hidden = NO;
        _refreshButton.target = self;
        _refreshButton.action = @selector(onRefreshButtonPressed:);
        [self.view addSubview:_refreshButton];
    }
    
    return _refreshButton;
}



- (NSView *)lineView1 {
    if(!_lineView1) {
        _lineView1 = [[NSView alloc] initWithFrame:CGRectMake(0, 335.5, 380, 8)];
        _lineView1.wantsLayer = YES;
        _lineView1.layer.backgroundColor = [NSColor colorWithString:@"EEEFF0" andAlpha:1.0].CGColor;
        [self.view addSubview:_lineView1];
    }
    
    return _lineView1;
}

- (NSImageView *)noCallHistoryImageView {
    if (!_noCallHistoryImageView){
        _noCallHistoryImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 136, 136)];
        [_noCallHistoryImageView setImage:[NSImage imageNamed:@"icon-noMeeting"]];
        _noCallHistoryImageView.imageAlignment =  NSImageAlignTopLeft;
        _noCallHistoryImageView.imageScaling =  NSImageScaleAxesIndependently;
        [self.view addSubview:_noCallHistoryImageView];
    }
    return _noCallHistoryImageView;
}

- (FrtcMaskView *)maskView {
    if (!_maskView) {
        _maskView = [[FrtcMaskView alloc] initWithFrame:NSMakeRect(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _maskView.wantsLayer = YES;
        _maskView.layer.backgroundColor = [NSColor blackColor].CGColor;
    }
    return _maskView;
}


- (NSProgressIndicator *)makeCallProgress {
    if (!_makeCallProgress){
        _makeCallProgress = [[NSProgressIndicator alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        _makeCallProgress.style = NSProgressIndicatorStyleSpinning;
        _makeCallProgress.hidden = YES;
        [self.view addSubview:_makeCallProgress];
    }
    return _makeCallProgress;
}

//for story: SN-3457
/*
- (FrtcMakeCallProgressView *)makeCallProgress {
    if (!_makeCallProgress) {
        _makeCallProgress = [[FrtcMakeCallProgressView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
        _makeCallProgress.hidden = YES;
        [self.view addSubview:_makeCallProgress];
    }
    return _makeCallProgress;
}
*/

- (CallResultReminderView *)reminderView {
    if(!_reminderView) {
        _reminderView = [[CallResultReminderView alloc] initWithFrame:CGRectMake(0, 0, 172, 40)];
        _reminderView.tipLabel.stringValue = @"账号或密码不正确";
        _reminderView.hidden = YES;
        
        [self.view addSubview:_reminderView];
    }
    
    return _reminderView;
}

- (NSTableView *)rosterTableView {
    if(!_rosterTableView) {
        _rosterTableView = [[NSTableView alloc] initWithFrame:NSMakeRect(0, 266, 380, 393)];
        NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@""];
        [_rosterTableView addTableColumn:column];
        
        _rosterTableView.delegate = self;
        _rosterTableView.dataSource = self;
        _rosterTableView.gridStyleMask = NSTableViewGridNone;
        [_rosterTableView setAllowsTypeSelect:NO];
        _rosterTableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
        [_rosterTableView setIntercellSpacing:NSMakeSize(0, 3)];
        _rosterTableView.allowsColumnReordering = NO;
        [_rosterTableView setHeaderView:nil];
        _rosterTableView.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] whiteColor];
        _rosterTableView.focusRingType = NSFocusRingTypeNone;
        _rosterTableView.translatesAutoresizingMaskIntoConstraints = YES;
        [self.view addSubview:_rosterTableView];
        [_rosterTableView reloadData];
    }
    
    return _rosterTableView;
}

- (NSScrollView *) backGoundView {
    if (!_backGoundView) {
        _backGoundView = [[NSScrollView alloc] init];
        _backGoundView.documentView = self.rosterTableView;
        _backGoundView.hasVerticalScroller = YES;
        _backGoundView.hasHorizontalScroller = NO;
        _backGoundView.scrollerStyle = NSScrollerStyleOverlay;
        _backGoundView.scrollerKnobStyle = NSScrollerKnobStyleDark;
        _backGoundView.scrollsDynamically = YES;
        _backGoundView.autohidesScrollers = NO;
        _backGoundView.verticalScroller.hidden = NO;
        _backGoundView.horizontalScroller.hidden = YES;
        _backGoundView.automaticallyAdjustsContentInsets = NO;
        _backGoundView.backgroundColor = [NSColor whiteColor];
        [self.view addSubview:_backGoundView];
    }

    return _backGoundView;
}

- (FrtcTagSelectCell *)scheduleSelectTagCell {
    if(!_scheduleSelectTagCell) {
        FrtcTabControlSelectMode *model = [FrtcTabControlSelectMode modelWithSelectedTitleColor:[NSColor colorWithString:@"333333" andAlpha:1.0] andDisSelectedTitleColor:[NSColor colorWithString:@"999999" andAlpha:1.0] andSelectedTitleFont:[NSFont systemFontOfSize:15 weight:NSFontWeightMedium] andUnSelectedTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightMedium]];
        _scheduleSelectTagCell = [[FrtcTagSelectCell alloc] initWithTabControlModel:model];
        _scheduleSelectTagCell.tag = FrtcSelectSheduleTag;
        [_scheduleSelectTagCell selected];
        _scheduleSelectTagCell.delegate = self;
        _selectedCell = _scheduleSelectTagCell;
        _scheduleSelectTagCell.titleView.stringValue = NSLocalizedString(@"FM_SCHEDULED_MEETING", @"Scheduled");
        _selectTag = FrtcSelectSheduleTag;
        [self.view addSubview:_scheduleSelectTagCell];
    }
    
    return _scheduleSelectTagCell;
}

- (FrtcTagSelectCell *)callHistorySelectTagCell {
    if(!_callHistorySelectTagCell) {
        FrtcTabControlSelectMode *model = [FrtcTabControlSelectMode modelWithSelectedTitleColor:[NSColor colorWithString:@"333333" andAlpha:1.0] andDisSelectedTitleColor:[NSColor colorWithString:@"999999" andAlpha:1.0] andSelectedTitleFont:[NSFont systemFontOfSize:15 weight:NSFontWeightMedium] andUnSelectedTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightMedium]];
        _callHistorySelectTagCell = [[FrtcTagSelectCell alloc] initWithTabControlModel:model];
        _callHistorySelectTagCell.tag = FrtcSelectCallHistoryTag;
        [_callHistorySelectTagCell disSelected];
        _callHistorySelectTagCell.delegate = self;
        _callHistorySelectTagCell.titleView.stringValue = NSLocalizedString(@"FM_HISTORY_MEETING", @"History");
        [self.view addSubview:_callHistorySelectTagCell];
    }
    
    return _callHistorySelectTagCell;
}

- (NSImageView *)scheduleLine {
    if (!_scheduleLine){
        _scheduleLine = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 1)];
        [_scheduleLine setImage:[NSImage imageNamed:@"icon-select-line"]];
        _scheduleLine.imageAlignment =  NSImageAlignTopLeft;
        _scheduleLine.imageScaling =  NSImageScaleAxesIndependently;
        [self.view addSubview:_scheduleLine];
    }
    return _scheduleLine;
}

- (NSTextField *)noMeetingTextField {
    if(!_noMeetingTextField) {
        _noMeetingTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _noMeetingTextField.stringValue = NSLocalizedString(@"NO_SCHEDULE_MEETING", @"No schedule meeting");
        _noMeetingTextField.bordered = NO;
        _noMeetingTextField.drawsBackground = NO;
        _noMeetingTextField.backgroundColor = [NSColor clearColor];
        _noMeetingTextField.layer.backgroundColor = [NSColor colorWithString:@"FFFFFF" andAlpha:1.0].CGColor;
        _noMeetingTextField.font = [NSFont systemFontOfSize:13 weight:NSFontWeightRegular];
        _noMeetingTextField.textColor = [NSColor colorWithString:@"#999999" andAlpha:1.0];
        _noMeetingTextField.alignment = NSTextAlignmentLeft;
        [self.view addSubview:_noMeetingTextField];
        _noMeetingTextField.editable = NO;
    }
    
    return _noMeetingTextField;
}

- (NSImageView *)callHistoryLine {
    if (!_callHistoryLine){
        _callHistoryLine = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 1)];
        [_callHistoryLine setImage:[NSImage imageNamed:@"icon-select-line"]];
        _callHistoryLine.imageAlignment =  NSImageAlignTopLeft;
        _callHistoryLine.imageScaling =  NSImageScaleAxesIndependently;
        _callHistoryLine.hidden = YES;
        [self.view addSubview:_callHistoryLine];
    }
    return _callHistoryLine;
}

#pragma mark --internal function--
- (NSTextField *)textField {
    NSTextField *textField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    textField.stringValue = @"显示名字";
    textField.bordered = NO;
    textField.drawsBackground = NO;
    textField.backgroundColor = [NSColor clearColor];
    textField.layer.backgroundColor = [NSColor colorWithString:@"FFFFFF" andAlpha:1.0].CGColor;
    textField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightRegular];
    textField.textColor = [NSColor colorWithString:@"333333" andAlpha:1.0];
    textField.alignment = NSTextAlignmentRight;
    textField.editable = NO;
    
    return textField;;
}

- (void)getRecentCallList {
    self.recentCallList = [[FrtcPersistence sharedUserPersistence] getMeetingList];
    
    if(self.recentCallList.count == 0) {
        self.noCallHistoryImageView.hidden = NO;
        self.backGoundView.hidden          = YES;
        [self.noCallHistoryImageView setImage:[NSImage imageNamed:@"icon-noMeeting"]];
        self.noMeetingTextField.hidden = NO;
        self.noMeetingTextField.stringValue = NSLocalizedString(@"NO_HISTORY_MEETING", @"No history meeting");
    } else {
        self.noCallHistoryImageView.hidden = YES;
        self.noMeetingTextField.hidden = YES;
        self.backGoundView.hidden          = NO;
    }
    
    [self.rosterTableView reloadData];
}

- (void)getScheduleMeetingList {
    NSString *userToken = [[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN];
    __weak __typeof(self)weakSelf = self;
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcGetScheduledMeeting:userToken getScheduledHandler:^(ScheduledModelArray * _Nonnull scheduledMeetingModelArray) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.scheduleModelArray = scheduledMeetingModelArray;
        
            if(self.selectTag == FrtcSelectSheduleTag) {
                [strongSelf.rosterTableView reloadData];
                
                if(strongSelf.scheduleModelArray.meeting_schedules.count == 0) {
                    strongSelf.noCallHistoryImageView.hidden = NO;
                    [strongSelf.noCallHistoryImageView setImage:[NSImage imageNamed:@"icon-noMeeting"]];
                    strongSelf.noMeetingTextField.stringValue = NSLocalizedString(@"NO_SCHEDULE_MEETING", @"No schedule meeting");
                    strongSelf.noMeetingTextField.hidden = NO;
                    strongSelf.backGoundView.hidden          = YES;
                } else {
                    strongSelf.noCallHistoryImageView.hidden = YES;
                    strongSelf.backGoundView.hidden          = NO;
                    strongSelf.noMeetingTextField.hidden = YES;
                }
            }
        
            [strongSelf setScheduledModelArrayForShowOnPopWindow];
        } getScheduledFailure:^(NSError * _Nonnull error) {
            NSLog(@"Failure");
            if([error.localizedDescription isEqualToString:@"Request failed: unauthorized (401)"]) {
                FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_VERIFY_FAILURE", @"Verifyication failed") withMessage:NSLocalizedString(@"FM_RE_SIGN", @"Please sign in again") preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:self.view.window];

                FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
                    [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FrtcMeetingMainViewShowNotification object:nil userInfo:nil];
                }];
                [alertWindow addAction:action];
            }
    }];
}

#pragma mark --Local Reminder--

- (void)setScheduledModelArrayForShowOnPopWindow {
    if ([self.localReminderManagement isEnableReceiveReminder]) {
        [self.localReminderManagement setScheduledModelArrayForShowOnPopWindow:self.scheduleModelArray];
    } else {
        //NSLog(@"[%s]: user disable to receive local reminder!", __func__);
    }
}

- (void)releaseLocalReminderManager {
    NSLog(@"[%s]", __func__);
    [self stopLocalReminderTimer];
    //[self.localReminderManagement stopLocalReminderManager];
    [FrtcLocalReminderManagement releaseInstance];
}

- (void)startMeetingTimer:(NSTimeInterval)timeInterval {
    if (nil == _localReminderTimer) {
        __weak __typeof(self)weakSelf = self;
        self.localReminderTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
            [weakSelf getScheduleMeetingList];
        }];
    }
}

- (void)startLocalReminderTimer {
    //NSLog(@"[Timer][%s]: -> start timer", __func__);
    //[self.localReminderManagement setReminderWindowJoinMeetingDelegate:self];
    [self startMeetingTimer:15 * 60]; //15 minutes
    //[self startMeetingTimer:60];
}

- (void)stopLocalReminderTimer {
    //[self.localReminderManagement setReminderWindowJoinMeetingDelegate:nil];
    if (nil != _localReminderTimer) {
        //NSLog(@"[Timer][%s]: -> stop and release timer", __func__);
        [_localReminderTimer invalidate];
        _localReminderTimer = nil;
    }
}

- (void)enableOrDisableReceiveMeetingReminder {
    BOOL withReminder = [[FrtcUserDefault defaultSingleton] boolObjectForKey:RECEIVE_MEETING_REMINDER];
    //NSLog(@"[%s]: [enable receiv reminder] withReminder : %@", __func__, withReminder? @"Yes": @"Not");
    [self.localReminderManagement setEnableReceiveReminder:withReminder];
    if (withReminder) {
        [self startLocalReminderTimer];
    } else {
        [self stopLocalReminderTimer];
    }
}

- (void)setDefaultEnabeReceiveMeetingReminder {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // check the key is exist.
    if ([defaults objectForKey:RECEIVE_MEETING_REMINDER] == nil) {
        NSLog(@"[%s]: RECEIVE_MEETING_REMINDER not exist", __func__);
        [[FrtcUserDefault defaultSingleton] setBoolObject:YES forKey:RECEIVE_MEETING_REMINDER];
        [[FrtcCallInterface singletonFrtcCall] enableOrDisableReceiveMeetingReminder:YES];
    } else {
        NSLog(@"[%s]: RECEIVE_MEETING_REMINDER is exist", __func__);
        //do nothing.
    }
}

#pragma mark --FrtcLocalReminderManagementJoinMeetingDelegate--

- (void)joinTheConferenceWithScheduleModel:(ScheduleModel *)scheduleModel {
    //NSLog(@"[%s]: -> joinMeeting with: scheduleModel: %@", __func__, scheduleModel);

    BOOL isInConference = [[FrtcCallInterface singletonFrtcCall] isInConference];
    if (isInConference) {
        //NSLog(@"[%s]: current is in call: isInConference: %@", __func__, isInConference?@"YES":@"NO");
        return;
    } else {
        FRTCMeetingParameters callParam;

        callParam.meeting_alias         = scheduleModel.meeting_number;
        callParam.display_name          = self.model.realName ? self.model.realName :[NSString stringWithFormat:@"%@%@", self.model.lastname, self.model.firstname];
        callParam.user_token            = [[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN];
        callParam.meeting_password      = scheduleModel.meeting_password;
        callParam.user_id               = self.model.user_id;
        callParam.video_mute            = YES;
        callParam.audio_mute            = YES;
        callParam.audio_only            = NO;

        [self makeCall:callParam];
    }
}

- (void)enableOrDisableReceiveReminder:(BOOL)enable {
    if (enable) {
        [self getScheduleMeetingList];
        
        [self startLocalReminderTimer];
    } else {
        [self stopLocalReminderTimer];
    }
}


@end
