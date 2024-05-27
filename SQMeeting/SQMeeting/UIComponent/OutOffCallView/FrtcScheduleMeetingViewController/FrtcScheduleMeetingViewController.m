#import "FrtcScheduleMeetingViewController.h"
#import "ScheduleView.h"
#import "FrtcMainWindow.h"
#import "FrtcInviteUserListViewController.h"
#import "FrtcMeetingManagement.h"
#import "FrtcButton.h"
#import "FrtcAlertMainWindow.h"
#import "CallResultReminderView.h"

@interface FrtcScheduleMeetingViewController ()<ScheduleViewDelegate, FrtcInviteUserListViewControllerDelegate>

@property (nonatomic, strong) NSTextField    *titleTextField;
@property (nonatomic, strong) NSView         *line1;
@property (nonatomic, strong) NSScrollView   *backGoundView;
@property (nonatomic, strong) ScheduleView   *scheduleView;
@property (nonatomic, strong) FrtcMainWindow *inviteUserWindow;
@property (nonatomic, strong) FrtcButton     *scheduleMeetingButton;
@property (nonatomic, strong) NSView         *line2;
@property (nonatomic, strong) NSArray        *selectedUserList;
@property (nonatomic, strong) NSDictionary   *selectDictonary;

@property (nonatomic, strong) CallResultReminderView *reminderView;
@property (nonatomic, strong) NSTimer       *reminderTipsTimer;

@end

@implementation FrtcScheduleMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self setupScheduleMeetingUI];
}

- (void)dealloc {
    NSLog(@"---------FrtcScheduleMeetingViewController dealloc--------------");
}

#pragma mark --getter load--
- (void)setupScheduleMeetingUI {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(8);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(14);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(380);
        make.height.mas_equalTo(1);
     }];
    
    [self.backGoundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line1.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view.mas_left);
        make.width.mas_equalTo(380);
        make.height.mas_equalTo(584);
    }];
    
    [self.scheduleMeetingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-16);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(332);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark --Internal Class--
- (void)updateScheduleView:(ScheduleSuccessModel *)meetingDetailInfoModel withRecurrence:(BOOL)isRecurrence {
    [self.scheduleView updateScheduleView:meetingDetailInfoModel withRecurrence:isRecurrence];
    self.selectedUserList = meetingDetailInfoModel.invited_users_details;
}

- (void)updateScheduleButtonName {
    self.scheduleMeetingButton.title = NSLocalizedString(@"FM_MEETING_RE_SAVE_MODIFY", @"Modify");
    
    FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_MEETING_RE_SAVE_MODIFY", @"Modify") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
    
    FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_MEETING_RE_SAVE_MODIFY", @"Modify") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];

    self.scheduleMeetingButton.normalButtonMode = normalMode;
    self.scheduleMeetingButton.hoverButtonMode  = hoverMode;
    
    self.titleTextField.stringValue = NSLocalizedString(@"FM_MEETING_RE_MODIFY_SHCEDULE_MEETING", @"Edit Meeting");
    
    self.scheduleMeetingButton.enabled = YES;
    
    [self.scheduleMeetingButton customizedPrimaryStyle];
}

- (void)showReminderView:(NSString *)reminderValue {
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

#pragma mark --ScheduleViewDelegate--
- (void)showReminderView {
    [self showReminderView:@"会议名称不可为空!"];
}

- (void)showTimeReminderValue:(NSString *)value {
    [self showReminderView:value];
}


- (void)showInviteView {
    FrtcInviteUserListViewController *userListViewController = [[FrtcInviteUserListViewController alloc] initWithNibName:nil bundle:nil];
    userListViewController.delegate = self;
    self.inviteUserWindow = [[FrtcMainWindow alloc] initWithSize:NSMakeSize(380, 660)];
    self.inviteUserWindow.titleVisibility       = NSWindowTitleHidden;
    self.inviteUserWindow.contentViewController = userListViewController;

    [self.inviteUserWindow makeKeyAndOrderFront:self];
    [self.inviteUserWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    [self.inviteUserWindow center];
    [userListViewController updateSelectUserInfo:self.selectedUserList];
    
    NSString *userToken = [[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN];
    
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcGetAllUserList:userToken withPage:1 withFilter:@""  completionHandler:^(UserListModel * _Nonnull allUserListModel) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [userListViewController setAllUserListModel:allUserListModel];
        });
        
    } failure:^(NSError * _Nonnull error) {
        if([error.localizedDescription isEqualToString:@"Request failed: unauthorized (401)"]) {
            FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_VERIFY_FAILURE", @"Verifyication failed") withMessage:NSLocalizedString(@"FM_RE_SIGN", @"Please sign in again") preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:self.view.window];

            FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
                
            }];
            [alertWindow addAction:action];
        }
    }];
}

- (void)updateUserListVie:(NSArray *)selectedUserList {
    self.selectedUserList = selectedUserList;
}

- (void)scheduleMeetingComplete:(BOOL)isSuccess withScheduleSuccessModel:(nonnull ScheduleSuccessModel *)model {
    if(self.delegate && [self.delegate respondsToSelector:@selector(scheduleMeetingComplete:withScheduleSuccessModel:)]) {
        [self.delegate scheduleMeetingComplete:isSuccess withScheduleSuccessModel:model];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view.window close];
        });
        
        NSDictionary *dic = [NSDictionary dictionaryWithObject:@(isSuccess) forKey:FrtcMeetingUpdateScheduleKey];
        
        [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FrtcMeetingUpdateScheduleNotification object:nil userInfo:dic];
    }
}

- (void)updateScheduleMeetingComplete:(BOOL)isSuccess {
    if(self.delegate && [self.delegate respondsToSelector:@selector(updateScheduleMeetingComplete:)]) {
        [self.delegate updateScheduleMeetingComplete:YES];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view.window close];
        });
        NSDictionary *dic = [NSDictionary dictionaryWithObject:@(isSuccess) forKey:FrtcMeetingUpdateScheduleKey];
        
        [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FrtcMeetingUpdateScheduleNotification object:nil userInfo:dic];
    }
}

- (void)enableScheduleButton:(BOOL)enable {
    self.scheduleMeetingButton.enabled = enable;
    if(enable) {
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_SCHEDULE", @"Schedule") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_SCHEDULE", @"Schedule") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        self.scheduleMeetingButton.hoverButtonMode = hoverMode;
        [self.scheduleMeetingButton updateButtonWithButtonMode:normalMode];
        self.scheduleMeetingButton.normalButtonMode = normalMode;
        self.scheduleMeetingButton.hoverd = YES;
    } else {
        FrtcButtonMode *disableMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:0.6] andbackgroundacaColor:[NSColor colorWithString:@"#026FFE" andAlpha:0.6] andButtonTitle:NSLocalizedString(@"FM_SCHEDULE", @"Schedule") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        self.scheduleMeetingButton.hoverd = NO;
        [self.scheduleMeetingButton updateButtonWithButtonMode:disableMode];
    }
}

#pragma mark --FrtcInviteUserListViewControllerDelegate--
- (void)selectUsers:(NSMutableArray<NSDictionary *> *)usersList {
    self.selectedUserList = usersList;
    NSArray<NSString *> *tempArray = [NSArray array];
    for(NSDictionary *dictionary in usersList) {
        NSLog(@"-----%@------", dictionary[@"user_id"]);
        tempArray = [tempArray arrayByAddingObject:dictionary[@"user_id"]];
    }
    
    [self.scheduleView updateSelectUsers:tempArray];
}

#pragma mark --Button Sender
- (void)scheduleBtnPressed:(FrtcButton *)sender {
    if([self.scheduleView compareTime]) {
        [self.scheduleView scheduleMeeting];
    }
}

#pragma mark --getter load--
- (NSTextField *)titleTextField {
    if (!_titleTextField) {
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:16 weight:NSFontWeightMedium];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.stringValue = NSLocalizedString(@"FM_SCHEDULE_MEETING", @"Schedule Meeting");;
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

- (ScheduleView *)scheduleView {
    if(!_scheduleView) {
        _scheduleView = [[ScheduleView alloc] initWithFrame:NSMakeRect(0, 0, 380, 960)];
        _scheduleView.meetingRooms = self.meetingRooms;
        _scheduleView.authority    = self.authority;
        _scheduleView.meetingDetailObject.stringValue = [NSString stringWithFormat:@"%@ %@", self.userName, NSLocalizedString(@"FM_SCHEDULED_MEETING_USED", @"s Meeting")];
        _scheduleView.delegate = self;
    }
    
    return _scheduleView;
}

- (NSScrollView *)backGoundView {
    if (!_backGoundView) {
        _backGoundView = [[NSScrollView alloc] init];
        _backGoundView.documentView = self.scheduleView;
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

- (FrtcButton *)scheduleMeetingButton {
    if(!_scheduleMeetingButton) {
        NSString *buttonTile;
        if(self.isUpdateView) {
            buttonTile = NSLocalizedString(@"FM_MEETING_RE_SAVE_MODIFY", @"Modify");
        } else {
            buttonTile = NSLocalizedString(@"FM_SCHEDULE", @"Schedule");
        }
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andButtonTitle:buttonTile andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andButtonTitle:buttonTile andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        _scheduleMeetingButton = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 332, 40) withNormalMode:normalMode withHoverMode:hoverMode];
        _scheduleMeetingButton.hoverd = YES;
        _scheduleMeetingButton.target = self;
        _scheduleMeetingButton.action = @selector(scheduleBtnPressed:);
        
        [self.view addSubview:_scheduleMeetingButton];
    }
    
    return _scheduleMeetingButton;;
}

- (NSView *)line2 {
    if(!_line2) {
        _line2 = [self line];
        _line2.layer.backgroundColor = [NSColor colorWithString:@"#F0F0F5" andAlpha:1.0].CGColor;
        [self.view addSubview:_line2];
    }
    
    return _line2;
}

- (NSArray *)selectedUserList {
    if(!_selectedUserList) {
        _selectedUserList = [[NSArray alloc] init];
    }
    
    return _selectedUserList;
}

- (NSDictionary *)selectDictonary {
    if(!_selectDictonary) {
        _selectDictonary = [[NSDictionary alloc] init];
    }
    
    return _selectDictonary;
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
- (NSView *)line {
    NSView *line1 = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
    line1.wantsLayer = YES;
    line1.layer.backgroundColor = [NSColor colorWithString:@"#EEEFF0" andAlpha:1.0].CGColor;
    
    return line1;
}

@end
