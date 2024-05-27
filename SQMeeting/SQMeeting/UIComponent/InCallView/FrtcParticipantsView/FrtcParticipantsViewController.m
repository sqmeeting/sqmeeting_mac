#import "FrtcParticipantsViewController.h"
#import "RosterListTableViewCell.h"
#import "RosterListAskForUnmuteCell.h"
#import "FrtcMultiTypesButton.h"
#import "MuteSinglePeopleWindow.h"
#import "FrtcMuteAllWindow.h"
#import "FrtcUnMuteAllWindow.h"
#import "ParticipantsModel.h"
#import "FrtcMeetingManagement.h"
#import "FrtcAlertMainWindow.h"
#import "LoginTextField.h"
#import "FrtcChangeNameWindow.h"
#import "CallResultReminderView.h"

@interface FrtcParticipantsViewController ()<NSTableViewDelegate, NSTableViewDataSource, RosterListTableViewCellDelegate, MuteSinglePeopleWindowDelegate, FrtcMuteAllWindowDelegate, FrtcUnMuteAllWindowDelegate, NSTextFieldDelegate, FrtcChangeNameWindowDelegate, RosterListAskForUnmuteCellDelegate>

@property (nonatomic, strong) NSTextField *titleTextField;

@property (nonatomic, strong) NSView      *lineView;

@property (nonatomic, strong) NSScrollView *rosterListScrollView;

@property (nonatomic, strong) NSTableView  *rosterListTableView;

@property (nonatomic, strong) LoginTextField *searchTextField;

@property (nonatomic, strong) FrtcMultiTypesButton *inviteButton;

@property (nonatomic, strong) FrtcMultiTypesButton *allMuteButton;

@property (nonatomic, strong) FrtcMultiTypesButton *cancelAllMuteButton;

@property (nonatomic, strong) NSMutableArray<ParticipantsModel *> *rostListData;

@property (nonatomic, strong) NSMutableArray<ParticipantsModel *> *tempRostListData;

@property (nonatomic, strong) CallResultReminderView *reminderView;

@property (strong, nonatomic) NSTimer *reminderTipsTimer;

@property (nonatomic, assign) NSInteger selectedRow;

@property (nonatomic, copy) NSString *selectureUUID;

@property (nonatomic, copy) NSString *searchResult;

@property (strong, nonatomic) MuteSinglePeopleWindow *singlePeopleWindow;

@property (nonatomic, assign, getter=isOnSearching) BOOL onSearching;

@property (nonatomic, assign, getter=isShowAskForUnmute) BOOL showAskForUnmute;

@property (nonatomic, assign, getter=isShowNewRequest) BOOL showNewRequest;

@property (nonatomic, copy) NSString *askForUnmuteName;

@end

@implementation FrtcParticipantsViewController

- (instancetype)init {
    self = [super init];
    
    if(self) {
        self.rostListData = [NSMutableArray array];
        self.tempRostListData = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.title = @"参会者 （12）";
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
   
    [self participantsViewLayout];
    self.titleTextField.stringValue = [NSString stringWithFormat:@"%@ （%ld)",NSLocalizedString(@"FM_STATISTIC_PARTICIPANT", @"Participants"),self.rostListData.count];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUpdateRostList:) name:FMeetingUpRostListNotNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLectureRostList:) name:FMeetingLectureListNotification object:nil];
}

#pragma mark --ParticipantsView Layout--
- (void)participantsViewLayout {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(9);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(12);
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.width.mas_equalTo(356);
        make.height.mas_equalTo(28);
    }];
    
    [self.rosterListScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchTextField.mas_bottom).offset(13);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.width.mas_equalTo(388);
        make.height.mas_equalTo(363);
    }];
    
    NSFont *font             = [NSFont systemFontOfSize:14.0f];
    NSDictionary *attributes = @{ NSFontAttributeName:font };
    CGSize size              = [NSLocalizedString(@"FM_INVITE_JOIN", @"Invite") sizeWithAttributes:attributes];
    
    [self.inviteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-16);
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.width.mas_equalTo(size.width + 10);
        make.height.mas_equalTo(size.height + 10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-62);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(388);
        make.height.mas_equalTo(1);
    }];
    
    if([self.inCallModel.ownerID isEqualToString:self.inCallModel.userID] || self.inCallModel.isAuthority) {
        [self.allMuteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-16);
            make.left.mas_equalTo(self.view.mas_left).offset(172);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(30);
        }];
    
        [self.cancelAllMuteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-16);
            make.left.mas_equalTo(self.view.mas_left).offset(260);
            make.width.mas_equalTo(112);
            make.height.mas_equalTo(30);
        }];
    }
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

#pragma mark -timer
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

#pragma mark --Local Search Result
- (void)localSearchWithString:(NSString *)string {
    self.searchResult = string;
    [self.rostListData removeAllObjects];
    
    if([string isEqualToString:@""]) {
        self.onSearching = NO;
        
        [self.rostListData addObjectsFromArray:self.tempRostListData];
    } else {
        self.onSearching = YES;
        
        for(ParticipantsModel * model in self.tempRostListData) {
            if([model.name localizedCaseInsensitiveContainsString:string]) {
                [self.rostListData addObject:model];
            }
        }
    }
    
    [self.rosterListTableView reloadData];
}

#pragma mark ---Notifiacation Observer
- (void)onUpdateRostList:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSArray *rosterListArray = [userInfo valueForKey:FMeetingUpRostListKey];
    
    [self handleRosterEvent:rosterListArray];
    
    self.titleTextField.stringValue = [NSString stringWithFormat:@"%@ （%ld)",NSLocalizedString(@"FM_STATISTIC_PARTICIPANT", @"Participants"),self.tempRostListData.count];
}

- (void)onLectureRostList:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSArray *lectureListArray = [userInfo valueForKey:FMeetingLectureListKey];
    
    if([lectureListArray count] == 0) {
        self.selectureUUID = @"";
    } else {
        self.selectureUUID = (NSString *)lectureListArray[0];
    }
}

#pragma mark -- NSTextField delegate --
- (void)controlTextDidChange:(NSNotification *)obj {
    [self localSearchWithString:self.searchTextField.stringValue];
}

#pragma mark --Button Sender--
- (void)allMutePressed:(FrtcMultiTypesButton *)sender {
    FrtcMuteAllWindow *muteAllWindow = [[FrtcMuteAllWindow alloc] initWithSize:NSMakeSize(240, 220)];
    muteAllWindow.muteAllDelegate = self;
    [muteAllWindow makeKeyAndOrderFront:self];
    [muteAllWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    [muteAllWindow center];
}

- (void)cancelAllMutePressed:(FrtcMultiTypesButton *)sender {
    FrtcUnMuteAllWindow *cancelMuteAllWindow = [[FrtcUnMuteAllWindow alloc] initWithSize:NSMakeSize(240, 184)];
    cancelMuteAllWindow.unMuteAllDelegate = self;
    [cancelMuteAllWindow makeKeyAndOrderFront:self];
    [cancelMuteAllWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    [cancelMuteAllWindow center];
}

- (void)invitePressed:(FrtcMultiTypesButton *)sender {
    if(self.controllerDelegate && [self.controllerDelegate respondsToSelector:@selector(showMeetingInfoWindow)]) {
        [self.controllerDelegate showMeetingInfoWindow];
    }
}

#pragma mark --FrtcUnMuteAllWindowDelegate--
- (void)unMuteAll {
    __weak __typeof(self)weakSelf = self;
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcUnMuteAllParticipants:self.inCallModel.userToken meetingNumber:self.inCallModel.conferenceNumber muteAllCompletionHandler:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf showReminderView:NSLocalizedString(@"FM_ALREADY_UN_MUTE_ALL", @"All unmuted")];
        } muteAllFailure:^(NSError * _Nonnull error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if([error.localizedDescription isEqualToString:@"Request failed: unauthorized (401)"]) {
                FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_VERIFY_FAILURE", @"Verifyication failed") withMessage:NSLocalizedString(@"FM_RE_SIGN", @"Please sign in again") preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:strongSelf.view.window];

                FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
                    
                }];
                [alertWindow addAction:action];
            }
    }];
    
    if(self.controllerDelegate && [self.controllerDelegate respondsToSelector:@selector(muteAll)]) {
        [self.controllerDelegate muteAll];
    }
}

#pragma mark --FrtcMuteAllWindowDelegate--
- (void)muteAll:(BOOL)allowUserUnmuteSelf {
    __weak __typeof(self)weakSelf = self;
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcMuteAllParticipants:self.inCallModel.userToken meetingNumber:self.inCallModel.conferenceNumber mute:allowUserUnmuteSelf muteAllCompletionHandler:^{
            [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FrtcMeetingMeetingOwnerMuteAll object:nil userInfo:nil];
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf showReminderView:NSLocalizedString(@"FM_ALREADY_MUTE_ALL", @"NAll Mutes Enabled")];
        } muteAllFailure:^(NSError * _Nonnull error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if([error.localizedDescription isEqualToString:@"Request failed: unauthorized (401)"]) {
                FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_VERIFY_FAILURE", @"Verifyication failed") withMessage:NSLocalizedString(@"FM_RE_SIGN", @"Please sign in again") preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:strongSelf.view.window];

                FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
                    
                }];
                [alertWindow addAction:action];
            }
        }];
}

#pragma mark --FrtcChangeNameWindowDelegate--
-(void)changeName:(NSString *)name {
    ParticipantsModel *model = (ParticipantsModel *)(self.rostListData[self.selectedRow]);
    __weak __typeof(self)weakSelf = self;
    if([self.inCallModel.ownerID isEqualToString:self.inCallModel.userID] || self.inCallModel.isAuthority) {
        [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcChangeUserNameByLoginUser:self.inCallModel.userToken meetingNumber:self.inCallModel.conferenceNumber newName:name clientIdentifier:model.UUID changeSuccessfulHandler:^{
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf showReminderView:NSLocalizedString(@"FM_CHANGE_SAVED", @"Modifications saved")];
            } changeFailure:^(NSError * _Nonnull error) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf showReminderView:NSLocalizedString(@"FM_CHANGE_FAILURE", @"Network exception, setting failed, please try again later")];
        }];
    } else {
        [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcChangeUserNameByGuestClient:self.inCallModel.conferenceNumber withNewUserName:name changeNameSuccessfulHandler:^{
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf showReminderView:NSLocalizedString(@"FM_CHANGE_SAVED", @"Modifications saved")];
            } changeNameFailure:^(NSError * _Nonnull error) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf showReminderView:NSLocalizedString(@"FM_CHANGE_FAILURE", @"Network exception, setting failed, please try again later")];
        }];
    }
}

#pragma mark --MuteSinglePeopleWindowDelegate--
- (void)setSelecture:(NSInteger)row isSetSelceter:(BOOL)isSet {
    ParticipantsModel *model = (ParticipantsModel *)(self.rostListData[row]);
    __weak __typeof(self)weakSelf = self;
    if(isSet) {
        [[FrtcMeetingManagement sharedFrtcMeetingManagement]  frtcMeetingUnSetUserAsLecturer:self.inCallModel.userToken meetingNumber:self.inCallModel.conferenceNumber clientUUID:model.UUID setLecturerSuccessfulHandler:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf showReminderView:NSLocalizedString(@"FM_ALREADY_UN_LECTURE", @"This user has been canceled speaker")];
        } setLecturerFailure:^(NSError * _Nonnull error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf showReminderView:NSLocalizedString(@"FM_CHANGE_FAILURE", @"Network exception, setting failed, please try again later")];
        }];
    } else {
        [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcMeetingSetUserAsLecturer:self.inCallModel.userToken              meetingNumber:self.inCallModel.conferenceNumber clientUUID:model.UUID setLecturerSuccessfulHandler:^{
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf showReminderView:NSLocalizedString(@"FM_ALREADY_LECTURE", @"This user has been set as a speaker")];
            } setLecturerFailure:^(NSError * _Nonnull error) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf showReminderView:NSLocalizedString(@"FM_CHANGE_FAILURE", @"Network exception, setting failed, please try again later")];
        }];
    }
}

- (void)setPin:(NSInteger)row isSetPin:(BOOL)isSet {
    ParticipantsModel *model = (ParticipantsModel *)(self.rostListData[row]);
    __weak __typeof(self)weakSelf = self;
    if(isSet) {
        [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcMeetingUnPin:self.inCallModel.userToken meetingNumber:self.inCallModel.conferenceNumber unPinSuccessful:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf showReminderView:NSLocalizedString(@"FM_HAVE_UN_SETTED_PIN", @"The screen is unfixed")];
                } unPinFailure:^(NSError * _Nonnull error) {
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    [strongSelf showReminderView:NSLocalizedString(@"FM_CHANGE_FAILURE", @"Network exception, setting failed, please try again later")];
        }];
    } else {
        [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcMeetingPin:self.inCallModel.userToken meetingNumber:self.inCallModel.conferenceNumber clientIdentifier:@[model.UUID] pinSuccessful:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf showReminderView:NSLocalizedString(@"FM_HAVE_SETTED_PIN", @"The screen is fixed")];
                } pinFailure:^(NSError * _Nonnull error) {
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    [strongSelf showReminderView:NSLocalizedString(@"FM_CHANGE_FAILURE", @"Network exception, setting failed, please try again later")];
        }];
    }
}

- (void)changeOldName:(NSInteger)row {
    self.selectedRow = row;
    
    FrtcChangeNameWindow *changeNameWindow = [[FrtcChangeNameWindow alloc] initWithSize:NSMakeSize(240, 156)];
    changeNameWindow.changeNameDelegate = self;
    
    ParticipantsModel *model = (ParticipantsModel *)(self.rostListData[row]);
    
    if(row == 0) {
        NSArray *array = [model.name componentsSeparatedByString:@"("];
        [changeNameWindow setOldName:[array firstObject]];
    } else {
        [changeNameWindow setOldName:model.name];
    }
    
    [changeNameWindow showWindowWithWindow:self.view.window];
}

- (void)removeMeetingRoom:(NSInteger)row {
    ParticipantsModel *model = (ParticipantsModel *)(self.rostListData[row]);
    
    FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow   showAlertWindowWithTitle:NSLocalizedString(@"FM_REMOVE_MEETING", @"Remove Meeting") withMessage:NSLocalizedString(@"FM_REMOVE_MEETING_SURE", @"Do you want to move this user out of the conference room") preferredStyle:FrtcWindowAlertStyleDefault withCurrentWindow:self.view.window];
  
       __weak __typeof(self)weakSelf = self;
       FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
           __strong __typeof(weakSelf)strongSelf = weakSelf;
           
           [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcMeetingRmoveUserFromMeetingRoom:strongSelf.inCallModel.userToken meetingNumber:strongSelf.inCallModel.conferenceNumber clientIdentifier:model.UUID removeMeetingSuccessfulHandler:^{
                    [strongSelf showReminderView:NSLocalizedString(@"FM_ALREADY_REMOVED", @"The user has been moved out of the conference room")];
            } removeMeetingFailure:^(NSError * _Nonnull error) {
                    [strongSelf showReminderView:NSLocalizedString(@"FM_CHANGE_FAILURE", @"Network exception, setting failed, please try again later")];
            }];
       }];
       
       [alertWindow addAction:action];
       
       FrtcAlertAction *actionCancel = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_CANCEL", @"Cancel") style:FrtcWindowAlertActionStyleCancle handler:^{
       }];
       
       [alertWindow addAction:actionCancel];
}

- (void)muteWithUUID:(NSString *)uuid withRow:(NSInteger)row {
    ParticipantsModel *model = (ParticipantsModel *)(self.rostListData[row]);
    
    if(row == 0) {
        BOOL mute;
        if([model.muteAudio isEqualToString:@"true"]) {
            mute = NO;
        } else {
            mute = YES;
        }
        
        if(self.controllerDelegate && [self.controllerDelegate respondsToSelector:@selector(muteBySelf:)]) {
            [self.controllerDelegate muteBySelf:mute];
        }
        
        return;
    }

    
    if([model.muteAudio isEqualToString:@"true"]) {
        __weak __typeof(self)weakSelf = self;
        [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcUnMuteParticipant:self.inCallModel.userToken meetingNumber:self.inCallModel.conferenceNumber participantList:@[uuid] muteCompletionHandler:^{
                
            } muteAllFailure:^(NSError * _Nonnull error) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if([error.localizedDescription isEqualToString:@"Request failed: unauthorized (401)"]) {
                    FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_VERIFY_FAILURE", @"Verifyication failed") withMessage:NSLocalizedString(@"FM_RE_SIGN", @"Please sign in again") preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:strongSelf.view.window];

                    FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
                        
                    }];
                    [alertWindow addAction:action];
                }
            }];
    } else {
        __weak __typeof(self)weakSelf = self;
        [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcMuteParticipant:self.inCallModel.userToken meetingNumber:self.inCallModel.conferenceNumber allowSelfUnmute:YES participantList:@[uuid] muteCompletionHandler:^{
                NSLog(@"mute success");
            } muteAllFailure:^(NSError * _Nonnull error) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                NSLog(@"failure");
                if([error.localizedDescription isEqualToString:@"Request failed: unauthorized (401)"]) {
                    FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_VERIFY_FAILURE", @"Verifyication failed") withMessage:NSLocalizedString(@"FM_RE_SIGN", @"Please sign in again") preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:strongSelf.view.window];

                    FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
                        
                    }];
                    [alertWindow addAction:action];
                }
        }];
    }
}

#pragma mark --RosterListTableViewCellDelegate--
- (void)muteSinglePeopleOrNot {
    /*MuteSinglePeopleWindow *singlePeopleWindow = [[MuteSinglePeopleWindow alloc] initWithSize:NSMakeSize(240, 148)];
    
    [singlePeopleWindow makeKeyAndOrderFront:self];
    [singlePeopleWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    [singlePeopleWindow center];*/
}

#pragma mark --RosterListAskForUnmuteCellDelegate--
- (void)viewAllAskForMuteList {
    if(self.controllerDelegate && [self.controllerDelegate respondsToSelector:@selector(showAskForUnmuteList)]) {
        [self.controllerDelegate showAskForUnmuteList];
    }
    self.showNewRequest = NO;
}

#pragma mark -NSTableViewDelegate, NSTableViewDataSource-
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if(self.isShowAskForUnmute) {
        return [self.rostListData count] + 1;
    } else {
        return [self.rostListData count];
    }
    
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if(row == 0) {
        if(self.isShowAskForUnmute) {
            RosterListAskForUnmuteCell *cell = [tableView makeViewWithIdentifier:@"RosterListAskForUnmuteCell" owner:self];
            if(cell == nil) {
                cell = [[RosterListAskForUnmuteCell alloc] init];
                cell.delegate = self;
                cell.identifier = @"RosterListAskForUnmuteCell";
            }
            
            cell.participantName.stringValue = [NSString stringWithFormat:@"%@ %@", self.askForUnmuteName,NSLocalizedString(@"FM_TOAST_ASK_FOR_UNMUTE", @"ask to unmute")];
            cell.showNewComingView.hidden = !self.isShowNewRequest;
            
            return cell;
        }
    }
    
    RosterListTableViewCell *cell = [tableView makeViewWithIdentifier:@"RosterListTableViewCell" owner:self];
    if(cell == nil) {
        cell = [[RosterListTableViewCell alloc] init];
        cell.tableViewCellDelegate = self;
        
        cell.identifier = @"RosterListTableViewCell";
    }

    NSInteger indexRow;
    if(self.isShowAskForUnmute) {
        indexRow = row - 1;
        if(row == 1) {
            cell.cellTag = 100;
        } else {
            cell.cellTag = 101;
        }
    } else {
        indexRow = row;
        if(row == 0) {
            cell.cellTag = 100;
        } else {
            cell.cellTag = 101;
        }
    }
    
    NSString *name = ((ParticipantsModel *)_rostListData[indexRow]).name ? ((ParticipantsModel *)_rostListData[indexRow]).name : @"";
    
    if([((ParticipantsModel *)_rostListData[indexRow]).lecture boolValue]) {
        name = [NSString stringWithFormat:@"%@ %@", name, NSLocalizedString(@"FM_LECTURE", @"(Lecturer)")];
    }
    cell.participantName.stringValue = name;
//    cell.participantName.stringValue = ((ParticipantsModel *)_rostListData[indexRow]).name ? ((ParticipantsModel *)_rostListData[indexRow]).name : @"";
    
    if([((ParticipantsModel *)_rostListData[indexRow]).muteAudio isEqualToString:@"true"]) {
        cell.audioMuteStatusImageView.image = [NSImage imageNamed:@"icon-audioIncall-mute"];
        cell.audioMute = YES;
    } else {
        cell.audioMuteStatusImageView.image = [NSImage imageNamed:@"icon-audioIncall-unmute"];
        cell.audioMute = NO;
    }

    if([((ParticipantsModel *)_rostListData[indexRow]).muteVideo isEqualToString:@"true"]) {
        cell.videoMuteStatusImageView.image = [NSImage imageNamed:@"icon-videoIncall-mute"];;
    } else {
        cell.videoMuteStatusImageView.image = [NSImage imageNamed:@"icon-videoIncall-unmute"];
    }
    
    if([((ParticipantsModel *)_rostListData[indexRow]).pin boolValue]) {
        cell.pinStatusImageView.hidden = NO;
    } else {
        cell.pinStatusImageView.hidden = YES;
    }
    
    
    
    return cell;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 40;
}

-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row  {
    NSInteger indexRow;
    if(self.isShowAskForUnmute) {
        if(row == 0) {
            return NO;
        } else {
            indexRow = row - 1;
        }
    } else {
        indexRow = row;
    }
    
    if([self.inCallModel.ownerID isEqualToString:self.inCallModel.userID] || self.inCallModel.isAuthority) {
        [self popupMuteSinglePeopleWindow:NSMakeSize(240, 297) withRow:indexRow withAuthority:YES];
    } else {
        ParticipantsModel *model = (ParticipantsModel *)(self.rostListData[row]);
        if([model.UUID isEqualToString:self.inCallModel.userIdentifier]) {
            [self popupMuteSinglePeopleWindow:NSMakeSize(240, 179) withRow:indexRow withAuthority:NO];
        } else {
            return NO;
        }
//        if(indexRow != 0) {
//            return NO;
//        } else {
//            [self popupMuteSinglePeopleWindow:NSMakeSize(240, 179) withRow:indexRow withAuthority:NO];
//        }
    }
    
    return NO;
}

- (BOOL)tableView:(NSTableView *)tableView shouldTypeSelectForEvent:(NSEvent *)event withCurrentSearchString:(NSString *)searchString {
    return ([event.charactersIgnoringModifiers characterAtIndex:0]!=0x20);
}

#pragma mark --Internal Function--
- (void)setLectureUUID:(NSMutableArray *)lecture {
    if([lecture count] == 0) {
        self.selectureUUID = @"";
    } else {
        self.selectureUUID = (NSString *)lecture[0];
    }
}

- (void)updateRequestCell:(NSString *)name isShow:(BOOL)show isNewRequest:(BOOL)newRequest {
    self.showNewRequest = newRequest;
    self.showAskForUnmute = show;
    self.askForUnmuteName = name;
    
    [self.rosterListTableView reloadData];
}

- (void)updateRostListForSearch:(NSMutableArray<ParticipantsModel *> *)tempRostListData {
    if(self.isOnSearching) {
        for(ParticipantsModel *participantModel in self.tempRostListData) {
            if([participantModel.name containsString:self.searchResult]) {
                [self.rostListData addObject:participantModel];
            }
        }
        
        [self.rosterListTableView reloadData];
        return;
    }
}

- (void)handleRosterEvent:(NSArray *)rosterList {
    [self.rostListData removeAllObjects];
    [self.tempRostListData removeAllObjects];
    [self.tempRostListData addObjectsFromArray:rosterList];

    
    BOOL canFindLocalName = NO;
    
    for(ParticipantsModel *participantModel in self.tempRostListData) {
        if([participantModel.UUID isEqualToString:self.inCallModel.userIdentifier]) {
            NSString *me = NSLocalizedString(@"participants_me", nil);
            NSString *strMe = me;
            if(![participantModel.name containsString:strMe]) {
                strMe =[participantModel.name stringByAppendingString:me];
                participantModel.name = strMe;
            }
            
            [self.tempRostListData removeObject:participantModel];
            if(self.tempRostListData.count == 0) {
                [self.tempRostListData addObject:participantModel];
            } else {
                [self.tempRostListData insertObject:participantModel atIndex:0];
            }
            
            self.inCallModel.clientName = [participantModel.name stringByReplacingOccurrencesOfString:NSLocalizedString(@"participants_me", nil) withString:@""];
    
            canFindLocalName = YES;
            
            break;
        }
    }
    
    if(!canFindLocalName) {
        NSString *me = NSLocalizedString(@"participants_me", nil);
        NSString *strMe = me;
        if(![self.inCallModel.clientName containsString:strMe]) {
            strMe = [self.inCallModel.clientName stringByAppendingString:me];
        } else {
            strMe = self.inCallModel.clientName;
        }
           
        ParticipantsModel *model = [[ParticipantsModel alloc] init];
        model.name = strMe;
        model.UUID = self.inCallModel.userIdentifier;
        
        model.muteAudio = self.inCallModel.isMuteMicrophone ? @"true" : @"false";
        model.muteVideo = self.inCallModel.isMuteCamera ? @"true" : @"false";
        
        if(self.tempRostListData.count == 0) {
            [self.tempRostListData addObject:model];
        } else {
            [self.tempRostListData insertObject:model atIndex:0];
        }
    }
    
    if(self.isOnSearching) {
        NSLog(@"---------The result is %@---------",self.searchResult);
        for(ParticipantsModel *participantModel in self.tempRostListData) {
           // NSLog(@"---------The result is %@---------",self.searchResult);
            
            //NSLog(@"---------The result is %@--------- the name is %@",self.searchResult, participantModel.name);
            if([participantModel.name localizedCaseInsensitiveContainsString:self.searchResult]) {
                NSLog(@"---------The result is %@--------- the name is %@",self.searchResult, participantModel.name);
                [self.rostListData addObject:participantModel];
            }
        }
        
        [self.rosterListTableView reloadData];
        return;
    }
    
    
    [self.rostListData addObjectsFromArray:self.tempRostListData];
    [self.rosterListTableView reloadData];
}

- (void)popupMuteSinglePeopleWindow:(NSSize)size withRow:(NSInteger )row withAuthority:(BOOL)authority {
    ParticipantsModel *model = (ParticipantsModel *)(self.rostListData[row]);
    
    if([self.singlePeopleWindow isVisible] && [self.singlePeopleWindow.uuid isEqualToString:model.UUID]) {
        [self.singlePeopleWindow makeKeyAndOrderFront:self];
        
        return;
    } else {
        BOOL status;
        if([model.muteAudio isEqualToString:@"true"]) {
            status = YES;
        } else {
            status = NO;
        }
        
        BOOL selecture;
        if([self.selectureUUID isEqualToString:model.UUID]) {
            selecture = YES;
        } else {
            selecture = NO;
        }
        
        BOOL pin = [model.pin boolValue];
       
        BOOL me;
        if([model.UUID isEqualToString:self.inCallModel.userIdentifier]) {
            me = YES;
        } else {
            me = NO;
        }
        self.singlePeopleWindow = [[MuteSinglePeopleWindow alloc] initWithSize:size withMuteStatus:status withAuthority:authority withLectureMode:selecture withPin:pin withRow:row withMe:me];
        self.singlePeopleWindow.muteSinglePeopleDelegate     = self;
        self.singlePeopleWindow.uuid                         = model.UUID;
        self.singlePeopleWindow.titleTextField.stringValue   = model.name;
        
        
        [self.singlePeopleWindow makeKeyAndOrderFront:self];
        [self.singlePeopleWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
        [self.singlePeopleWindow center];
    }
}

#pragma mark --lazy load--
- (NSTextField *)titleTextField {
    if (!_titleTextField){
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightMedium];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.stringValue = @"参会者 (12)";
        [self.view addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (NSTableView *)rosterListTableView {
    if(!_rosterListTableView) {
        _rosterListTableView = [[NSTableView alloc] initWithFrame:NSMakeRect(0, 41, 388, 359)];
        NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@""];
        [_rosterListTableView addTableColumn:column];
        _rosterListTableView.delegate = self;
        _rosterListTableView.dataSource = self;
        [_rosterListTableView setAllowsTypeSelect:NO];
        _rosterListTableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
        [_rosterListTableView setHeaderView:nil];
        [_rosterListTableView setIntercellSpacing:NSMakeSize(0, 0)];
        _rosterListTableView.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0];
        _rosterListTableView.focusRingType = NSFocusRingTypeNone;
        _rosterListTableView.translatesAutoresizingMaskIntoConstraints = YES;
        [_rosterListTableView reloadData];
    }
    
    return _rosterListTableView;
}

- (NSScrollView *)rosterListScrollView {
    if (!_rosterListScrollView) {
        _rosterListScrollView = [[NSScrollView alloc] init];
        //_rosterListScrollView.backgroundColor = [NSColor redColor];
        _rosterListScrollView.contentView.documentView = self.rosterListTableView;
        _rosterListScrollView.hasVerticalScroller = YES;
        _rosterListScrollView.scrollerStyle = NSScrollerStyleOverlay;
        _rosterListScrollView.scrollerKnobStyle = NSScrollerKnobStyleDark;
        _rosterListScrollView.scrollsDynamically = YES;
        _rosterListScrollView.hasVerticalScroller = YES;
        _rosterListScrollView.autohidesScrollers = NO;
        _rosterListScrollView.verticalScroller.hidden = NO;
        _rosterListScrollView.automaticallyAdjustsContentInsets = NO;
        [self.view addSubview:_rosterListScrollView];
    }

    return _rosterListScrollView;
}

- (FrtcMultiTypesButton*)inviteButton {
    if (!_inviteButton){
        _inviteButton = [self internalButtonWithTitle:NSLocalizedString(@"FM_INVITE_JOIN", @"Invite")];
        _inviteButton.action = @selector(invitePressed:);
        [self.view addSubview:_inviteButton];
    }
    return _inviteButton;
}

- (FrtcMultiTypesButton*)allMuteButton {
    if (!_allMuteButton){
        _allMuteButton = [self internalButtonWithTitle:NSLocalizedString(@"FM_MEETING_MUTEALL", @"Mute All")];
        _allMuteButton.action = @selector(allMutePressed:);
        [self.view addSubview:_allMuteButton];
    }
    return _allMuteButton;
}

- (FrtcMultiTypesButton*)cancelAllMuteButton {
    if (!_cancelAllMuteButton){
        _cancelAllMuteButton = [self internalButtonWithTitle:NSLocalizedString(@"FM_MEETING_ASK_UNMUTE", @"Unmute All")];
        _cancelAllMuteButton.action = @selector(cancelAllMutePressed:);
        [self.view addSubview:_cancelAllMuteButton];
    }
    
    return _cancelAllMuteButton;
}

- (NSView *)lineView {
    if(!_lineView) {
        _lineView = [[NSView alloc] initWithFrame:NSMakeRect(0, 400, 388, 1)];
        _lineView.wantsLayer = YES;
        _lineView.layer.backgroundColor = [NSColor colorWithString:@"#D7DADD" andAlpha:1.0].CGColor;
        [self.view addSubview:_lineView];
    }
    
    return _lineView;
}

- (LoginTextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[LoginTextField alloc] initWithFrame:CGRectMake(0, 0, 308, 32)];
        _searchTextField.imageView.frame = CGRectMake(6, 2, 24, 24);
        _searchTextField.placeholderString = NSLocalizedString(@"FM_USER_SEARCH", @"Searching");
        _searchTextField.delegate = self;
        [_searchTextField.imageView setImage:[NSImage imageNamed:@"icon-roster-searching"]];
        [self.view addSubview:_searchTextField];
    }
    
    return _searchTextField;
}

#pragma mark --internal function--
- (FrtcMultiTypesButton*)internalButtonWithTitle:(NSString *)title {
    FrtcMultiTypesButton *internalButton = [[FrtcMultiTypesButton alloc] initFifthWithFrame:CGRectMake(0, 0, 48, 22) withTitle:title];
    internalButton.target = self;
    internalButton.layer.cornerRadius = 4.0;
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:title];
    NSUInteger len = [attrTitle length];
    NSRange range = NSMakeRange(0, len);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#333333" andAlpha:1.0]
                      range:range];
    [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                      range:range];
    
    [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                      range:range];
    [attrTitle fixAttributesInRange:range];
    [internalButton setAttributedTitle:attrTitle];
    //_removeMeetingButton.layer.backgroundColor = [NSColor colorWithString:@"#F8F9FA" andAlpha:1.0].CGColor;
    //_removeMeetingButton.bordered = YES;
    internalButton.layer.borderColor = [NSColor colorWithString:@"#CCCCCC" andAlpha:1.0].CGColor;

    
    return internalButton;;
}

- (CallResultReminderView *)reminderView {
    if(!_reminderView) {
        _reminderView = [[CallResultReminderView alloc] initWithFrame:CGRectMake(0, 0, 172, 40)];
        _reminderView.tipLabel.stringValue = NSLocalizedString(@"FM_NETWORK_EXCEPTION_REY_TRY", @"Network exception,Please check your network on try re-join");
        _reminderView.hidden = YES;
        
        [self.view addSubview:_reminderView];
    }
    
    return _reminderView;
}

@end
