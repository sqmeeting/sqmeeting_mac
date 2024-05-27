#import "FrtcMainViewController.h"
#import "FrtcCall.h"
#import "AppDelegate.h"
#import "Masonry.h"
#import "FrtcUserDefault.h"
#import "FrtcBaseImplement.h"
#import "StaticsWindowController.h"
#import "FrtcHoverButton.h"
#import "FrtcMultiTypesButton.h"
#import "DashView.h"
#import "FrtcCallWindow.h"
#import "MyCustomAnimator.h"
#import "FrtcSignViewController.h"
#import "CallResultReminderView.h"
#import "FrtcSettingViewController.h"
#import "FrtcAccountViewController.h"
#import "FrtcInputPasswordWindow.h"
#import "FrtcMainWindow.h"
#import "FrtcAlertMainWindow.h"
#import "FrtcSaveServerAddressWindow.h"

//for story: SN-3457
//#import "FrtcMakeCallProgressView.h"


@interface FrtcMainViewController () <FrtcCallWindowDelegate, FrtcInputPasswordWindowDelegate, FrtcSignViewControllerDelegate>

@property (nonatomic, strong) NSImageView               *backgroundView;
@property (nonatomic, strong) NSImageView               *logoView;

@property (nonatomic, strong) FrtcHoverButton      *settingButton;
@property (nonatomic, strong) FrtcMultiTypesButton                  *joinMeetingButton;
@property (nonatomic, strong) FrtcMultiTypesButton                  *loginButton;

@property (nonatomic, strong) NSTextField               *appCopyright;
@property (nonatomic, strong) NSTextField               *appNameText;
@property (nonatomic, strong) NSTextField               *betaText;

@property (nonatomic, strong) DashView                  *dashView;

@property (nonatomic, strong) NSTextField               *tipsText;
@property (nonatomic, strong) NSTextField               *tipsText1;

@property (nonatomic, strong) NSImageView               *arrowImageView;

@property (nonatomic, strong) FrtcCallWindow            *callWindow;

//for story: SN-3457
//@property (nonatomic, strong) FrtcMakeCallProgressView  *makeCallProgress;
@property (nonatomic, strong) NSProgressIndicator       *makeCallProgress;

@property (nonatomic, strong) NSTextField               *makeCallTips;
@property (nonatomic, strong) CallResultReminderView    *reminderView;

@property (strong, nonatomic) NSTimer                   *reminderTipsTimer;

@property (strong, nonatomic) FrtcMainWindow            *settingWindow;

@property (strong, nonatomic) FrtcSaveServerAddressWindow *saveServerWindow;

@property (nonatomic, assign, getter=isCallSuccess) BOOL callSuccess;

@property (nonatomic, assign, getter=isUrlCallStarted) BOOL urlCallStarted;

@property (nonatomic, copy) NSString *callUrl;

@end

@implementation FrtcMainViewController

- (instancetype) initWithNibName:(NSNibName)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle:nibBundleOrNil];
       
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMainView];
    [self configMainView];
    [self addNotificationObserver];
}

- (void)dealloc {
    NSLog(@"FrtcMainViewController dealloc");
}

- (void)addNotificationObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLoginViewNotification:) name:FrtcMeetingLoginViewShowNotification object:nil];
}

- (void)configMainView {
    NSString *serverAddress = [[FrtcUserDefault defaultSingleton] objectForKey:STORAGE_SERVER_ADDRESS];
    
    if(serverAddress != nil && ![serverAddress isEqualToString:@""]) {
        [self tipsHiddden:YES];
    } else {
        [self tipsHiddden:NO];
    }
}

- (void)tipsHiddden:(BOOL)hidden {
    self.tipsText.hidden        = hidden;
    self.tipsText1.hidden       = hidden;
    self.arrowImageView.hidden  = hidden;
    self.dashView.hidden        = hidden;
}

- (void)setupMainView {
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(292);
        make.left.mas_equalTo(self.view.mas_left);
        make.width.mas_equalTo(640);
        make.height.mas_equalTo(188);
     }];
    
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(50);
        make.left.mas_equalTo(self.view.mas_left).offset(266);
        make.width.mas_equalTo(108);
        make.height.mas_equalTo(108);
     }];
    
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(24);
        make.right.mas_equalTo(self.view.mas_right).offset(-24);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
     }];
    
    [self.joinMeetingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(240);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(240);
        make.height.mas_equalTo(40);
     }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.joinMeetingButton.mas_bottom).offset(16);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(240);
        make.height.mas_equalTo(40);
     }];
    
    [self.appCopyright mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-28);
        make.width.mas_greaterThanOrEqualTo(179);
        make.height.mas_greaterThanOrEqualTo(17);
     }];
    
    [self.appNameText mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.mas_equalTo(self.view.mas_left).offset(268);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(163);
        make.width.mas_greaterThanOrEqualTo(72);
        make.height.mas_greaterThanOrEqualTo(28);
     }];
        
    [self.dashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.top.mas_equalTo(self.view.mas_top).offset(69);
        make.width.mas_equalTo(228);
        make.height.mas_equalTo(32);
     }];
    
    [self.tipsText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dashView.mas_left).offset(16);
        make.centerY.mas_equalTo(self.dashView.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(156);
        make.height.mas_greaterThanOrEqualTo(17);
     }];
    
    [self.tipsText1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.dashView.mas_right).offset(-16);
        make.centerY.mas_equalTo(self.dashView.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(36);
        make.height.mas_greaterThanOrEqualTo(17);
     }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(44);
        make.right.mas_equalTo(self.view.mas_right).offset(-42);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(25);
     }];
    
    [self.makeCallProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(254);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(32);
    }];
    //for story: SN-3457
    /*
    [self.makeCallProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(254-32);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(64);
    }];
    */
    
    [self.makeCallTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-165);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.reminderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(196);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(172);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark --notification observer
- (void)receiveLoginViewNotification:(NSNotification*)noti {
    if([self.settingWindow isVisible]) {
        [self.settingWindow close];
    }
}

#pragma mark --buffon sender--
- (void)onJoinVideoMeetingPressed {
    FrtcCallWindow *callWindow = [[FrtcCallWindow alloc] initWithSize:NSMakeSize(380, 365)];
    callWindow.frtcCallWindowdelegate = self;
    callWindow.login = NO;

    [callWindow showWindow];
    [self showMaskView:YES];
}

#pragma mark --Internal Function--
- (BOOL)isEnglish {
    NSString * language = [FMLanguageConfig userLanguage] ? : [NSLocale preferredLanguages].firstObject;
    
    if([language hasPrefix:@"en"]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)showServerErrorInfo {
    FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:@"" withMessage:NSLocalizedString(@"FM_ADD_MEETING_SERVER_ERROR", @"Not supported for joining external systems") preferredStyle:FrtcWindowAlertStyleNoTitle withCurrentWindow:self.view.window];
    
    FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
        [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FrtcMeetingMainViewShowNotification object:nil userInfo:nil];
    }];
    [alertWindow addAction:action];
}

- (void)showLoginInfo {
    FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:@"" withMessage:NSLocalizedString(@"FM_ADD_MEETING_LOGIN_SERVER_ERROR", @"Please log in first before adding meeting") preferredStyle:FrtcWindowAlertStyleNoTitle withCurrentWindow:self.view.window];
    
    FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
        [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FrtcMeetingMainViewShowNotification object:nil userInfo:nil];
    }];
    [alertWindow addAction:action];
}

- (void)makeUrlCall:(NSString *)url {
    BOOL agreeProtocol = [[FrtcUserDefault defaultSingleton] boolObjectForKey:AGREE_PROTOCOL];
    if(!agreeProtocol) {
        self.callUrl = url;
        self.urlCallStarted = YES;
        return;
    }
    
    NSString *urlServer = [[FrtcCall sharedFrtcCall] parseUrl:url];
    
    if(![urlServer isEqualToString:[[FrtcUserDefault defaultSingleton] objectForKey:STORAGE_SERVER_ADDRESS]]) {
        if(self.isCallSuccess) {
            [self makeCallWithUrl:url];
        } else {
            
            NSSize size;
            
            if([self isEnglish]) {
                size = NSMakeSize(300, 215);
            } else {
                size = NSMakeSize(300, 164);
            }
            
            if([self.saveServerWindow isVisible]) {
                return;
            }
            
            self.saveServerWindow = [[FrtcSaveServerAddressWindow alloc] initWithSize:size];
            __weak __typeof(self)weakSelf = self;
            
            [self.saveServerWindow showWindowWithWindow:self.view.window withSaveAction:^{
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [[FrtcUserDefault defaultSingleton] setObject:urlServer forKey:STORAGE_SERVER_ADDRESS];
                [[FrtcCall sharedFrtcCall] saveUrl:urlServer];
                [strongSelf showReminderView:NSLocalizedString(@"FM_SAVE_ADDRESS_SUCCESSFULLY", @"Saved successfully")];
                [strongSelf makeCallWithUrl:url];
            } withCancelAction:^{
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf makeCallWithUrl:url];
            }];
            
            NSString *descriptionString = [NSString stringWithFormat:NSLocalizedString(@"FM_COMPARE_SERVER_DESCRIPTION", @"The server address \n\"%@\"\n of this meeting is different from the default address. Save it as the default address?"),urlServer];
            self.saveServerWindow.descriptionTextField.stringValue = descriptionString;
            
            return;
        }
    } else {
        [self makeCallWithUrl:url];
    }
}
    
- (void)makeCallWithUrl:(NSString *)url {
    NSString *userName = [[FrtcUserDefault defaultSingleton] objectForKey:STORAGE_USER_NAME];
    if(userName == nil || [userName isEqualToString:@""]) {
        userName = [NSHost currentHost].localizedName;
    }
    
    FRTCMeetingParameters callParam;
    
    callParam.meeting_url           = url;
    
    callParam.meeting_alias         = @"";
    callParam.display_name          = userName;
    callParam.call_rate             = 0;
    callParam.video_mute            = YES;
    callParam.audio_mute            = YES;
    callParam.audio_only            = NO;
    
    [self makeCall:callParam];
}


- (void)onCancelBtnPressed:(NSButton *)sender {
    FrtcSignViewController* signViewController = [[FrtcSignViewController alloc] initWithNibName:nil bundle:nil];
    signViewController.delegate = self;
    signViewController.settingWindow = self.settingWindow;
    id animator = [[MyCustomAnimator alloc] init];
    [self presentViewController:signViewController animator:animator];
}

- (void)onSettingBtnPressed {
    if([self.settingWindow isVisible]) {
        [self.settingWindow makeKeyAndOrderFront:self];
    } else {
        [self tipsHiddden:YES];
        FrtcSettingViewController *settingViewController = [[FrtcSettingViewController alloc] initWithloginStatus:NO];
        settingViewController.settingType = SettingTypeGuest;
        //settingViewController.login = NO;
    
        self.settingWindow = [[FrtcMainWindow alloc] initWithSize:NSMakeSize(640, 560)];
        self.settingWindow.contentViewController = settingViewController;
        self.settingWindow.titleVisibility       = NSWindowTitleHidden;
        [self.settingWindow makeKeyAndOrderFront:self];
        [self.settingWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
        [self.settingWindow center];
    }
}

#pragma mark --FrtcSignViewControllerDelegate--
- (void)popupSettingWindow {
    [self onSettingBtnPressed];
}

#pragma mark --buffon sender--
- (void)closeWindow {
    [self showMaskView:NO];
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

#pragma mark --FrtcInputPasswordWindowDelegate--
- (void)sendPasscode:(NSString *)passcode {
    [[FrtcCallInterface singletonFrtcCall] frtcSendPassword:passcode];
}

- (void)cancelSendPasscode {
    [self.makeCallProgress stopAnimation:self];
    
    self.makeCallTips.hidden        = YES;
    self.makeCallProgress.hidden    = YES;
    self.joinMeetingButton.hidden   = NO;
    self.loginButton.hidden         = NO;
    
    [[FrtcCallInterface singletonFrtcCall] endMeeting];
}

#pragma mark --FrtcCallWindowDelegate--
- (void)makeCall:(FRTCMeetingParameters)callParam  {
    callParam.user_id = @"";
    
    self.makeCallTips.hidden        = NO;
    self.makeCallProgress.hidden    = NO;
    self.joinMeetingButton.hidden   = YES;
    self.loginButton.hidden         = YES;
    
    [self.makeCallProgress startAnimation:self];
    
    __weak __typeof(self)weakSelf = self;
    
    [[FrtcCallInterface singletonFrtcCall] frtcJoinMeetingWithCallParam:callParam withAuthority:NO withJoinMeetingSuccessfulCallBack:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.callSuccess = YES;
    
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.makeCallTips.hidden        = YES;
            strongSelf.makeCallProgress.hidden    = YES;
            strongSelf.joinMeetingButton.hidden   = NO;
            strongSelf.loginButton.hidden         = NO;
        });
    } withJoinMeetingFailureCalBack:^(FRTCMeetingStatusReason reason) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.makeCallTips.hidden        = YES;
            strongSelf.makeCallProgress.hidden    = YES;
            strongSelf.joinMeetingButton.hidden   = NO;
            strongSelf.loginButton.hidden         = NO;
            
            NSString *failureReason;
            
            if(reason == MEETING_STATUS_SERVERERROR) {
                failureReason = NSLocalizedString(@"FM_SERVER_UNREACHABLE", @"Please check your server setting");
                [strongSelf showAlertWindow:failureReason];
                return;
            } else if(reason == MEETING_STATUS_LOCKED) {
                failureReason = NSLocalizedString(@"FM_MEETING_LOCKED", @"Meeting locked");;
                [strongSelf showAlertWindow:failureReason];
                return;
            } else if(reason == MEETING_STATUS_MEETINGNOTEXIST) {
                failureReason = NSLocalizedString(@"FM_MEETING_NOT_EXIST", @"The meeting requires sign in or doesn't exist. Retry after sign in");
            } else if(reason == MEETING_STATUS_ABORTED) {
                failureReason = NSLocalizedString(@"FM_MEETING_CALL_ENDED", @"Meeting Ended");
                strongSelf.callSuccess = NO;
                return;
            } else if(reason == MEETING_STATUS_STOP) {
                if(!strongSelf.isCallSuccess) {
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
                failureReason =  NSLocalizedString(@"FM_MEETING_OVERTIME", @"Meeting expired");;
                [strongSelf showAlertWindow:failureReason];
                return;
            } else if(reason == MEETING_STATUS_NOT_STARTED) {
                failureReason =  NSLocalizedString(@"FM_MEETING_JOIN_BEFORE_THIRTY_MINMUTES", @"You can join the meeting 30 minutes before the meeting starts");;
                [strongSelf showAlertWindow:failureReason];
                return;
            } else if(reason == MEETING_STATUS_GUEST_UNALLOWED) {
                failureReason =  NSLocalizedString(@"FM_NOT_ALLOW_GUEST", @"Guest users can't join this meeting, please sign in and try again");;
                [strongSelf showAlertWindow:failureReason];
                return;
            } else if(reason == MEETING_STATUS_PEOPLE_FULL) {
                failureReason =  NSLocalizedString(@"FM_FULL_LIST", @"Join meeting failed, the meeting is full");
                [strongSelf showAlertWindow:failureReason];
                return;
            } else if(reason == MEETING_STATUS_NO_LICENSE) {
                failureReason =  NSLocalizedString(@"FM_CERTIFICATE_EXPIRED", @"No software license or license has expired");
                [strongSelf showAlertWindow:failureReason];
                return;
            } else if(reason == MEETING_STATUS_LICENSE_MAX_LIMIT_REACHED) {
                failureReason =  NSLocalizedString(@"FM_NEED_UPDATE_LICENSE_FOR_USERS", @"The number of users has reached the maximum, please upgrade your software license");
                [strongSelf showAlertWindow:failureReason];
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

- (void)showAlertWindow:(NSString *)reminderValue {
    FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_JOIN_FAILURE", @"Join Meeting Failed") withMessage:reminderValue preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:self.view.window];

    FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
        
    }];
    [alertWindow addAction:action];
}

#pragma mark --lazy load function--
- (NSImageView *)backgroundView {
    if (!_backgroundView){
        _backgroundView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 292, 640, 188)];
        [_backgroundView setImage:[NSImage imageNamed:@"icon-background"]];//icon_new_feature
        //[_backgroundView setImage:[NSImage imageNamed:@"icon_new_feature"]];
        _backgroundView.imageAlignment =  NSImageAlignCenter;
        _backgroundView.imageScaling =  NSImageScaleAxesIndependently;
        [self.view addSubview:_backgroundView];
    }
    return _backgroundView;
}

- (NSImageView *)logoView {
    if (!_logoView){
        _logoView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 108, 108)];
        [_logoView setImage:[NSImage imageNamed:@"icon-logo"]];
        _logoView.imageAlignment =  NSImageAlignTopLeft;
        _logoView.imageScaling =  NSImageScaleAxesIndependently;
        [self.view addSubview:_logoView];
    }
    return _logoView;
}

- (FrtcHoverButton *)settingButton {
    if (!_settingButton) {
        _settingButton = [[FrtcHoverButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [_settingButton setOffStatusImagePath:@"icon-settings"];
        _settingButton.bezelStyle = NSBezelStyleRegularSquare;
        _settingButton.target = self;
        _settingButton.action = @selector(onSettingBtnPressed);
        [self.view addSubview:_settingButton];
    }
    
    return _settingButton;
}

- (FrtcMultiTypesButton *)joinMeetingButton {
    if (!_joinMeetingButton){
        _joinMeetingButton = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 240, 40) withTitle:NSLocalizedString(@"FM_JOIN_MEETING_TITLE", @"Join Meeting")];
        _joinMeetingButton.target = self;
        _joinMeetingButton.action = @selector(onJoinVideoMeetingPressed);
        [self.view addSubview:_joinMeetingButton];
    }
    
    return _joinMeetingButton;
}

- (FrtcMultiTypesButton*)loginButton {
    if (!_loginButton){
        _loginButton = [[FrtcMultiTypesButton alloc] initSecondaryWithFrame:CGRectMake(0, 0, 0, 0) withTitle:NSLocalizedString(@"FM_SIGN_IN", @"Sign In")];
        _loginButton.target = self;
        _loginButton.action = @selector(onCancelBtnPressed:);
        [self.view addSubview:_loginButton];
    }
    return _loginButton;
}

- (NSTextField *)appCopyright {
    if (!_appCopyright){
        _appCopyright = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _appCopyright.backgroundColor = [NSColor clearColor];
        _appCopyright.font = [NSFont systemFontOfSize:12];
        _appCopyright.alignment = NSTextAlignmentCenter;
        _appCopyright.textColor = [NSColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        _appCopyright.bordered = NO;
        _appCopyright.editable = NO;
        _appCopyright.stringValue = NSLocalizedString(@"FM_COPYRIGHT", @"Version：version + build");
        [self.view addSubview:_appCopyright];
    }
    
    return _appCopyright;
}

- (NSTextField *)appNameText {
    if (!_appNameText){
        _appNameText = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _appNameText.backgroundColor = [NSColor clearColor];
        _appNameText.font = [NSFont systemFontOfSize:18 weight:NSFontWeightMedium];
        _appNameText.alignment = NSTextAlignmentCenter;
        _appNameText.textColor = [NSColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
        _appNameText.bordered = NO;
        _appNameText.editable = NO;
        _appNameText.stringValue = NSLocalizedString(@"FM_APP_NAME", @"SQ Meeting CE ");
        [self.view addSubview:_appNameText];
    }
    
    return _appNameText;
}

- (NSTextField *)betaText {
    if (!_betaText){
        _betaText = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _betaText.backgroundColor = [NSColor clearColor];
        _betaText.font = [[NSFontManager sharedFontManager] fontWithFamily:@"PingFangSC-Regular" traits:NSBoldFontMask weight:NSFontWeightMedium size:10];//[NSFont systemFontOfSize:10 weight:NSFontWeightMedium];
        _betaText.alignment = NSTextAlignmentRight;
        _betaText.textColor = [NSColor colorWithRed:18/255.0 green:120/255.0 blue:247/255.0 alpha:1.0];
        _betaText.bordered = NO;
        _betaText.editable = NO;
        _betaText.stringValue = @"BETA";
        [self.view addSubview:_betaText];
    }
    
    return _betaText;
}

- (DashView *)dashView {
    if(!_dashView) {
        _dashView = [[DashView alloc] initWithFrame:CGRectMake(0, 0, 228, 32)];
        _dashView.wantsLayer = YES;
        _dashView.layer.backgroundColor = [NSColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1.0].CGColor;
        _dashView.layer.cornerRadius = 20.0f;
        [self.view addSubview:_dashView];
    }
    
    return _dashView;
}

- (NSTextField *)tipsText {
    if (!_tipsText){
        _tipsText = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _tipsText.backgroundColor = [NSColor clearColor];
        _tipsText.font = [[NSFontManager sharedFontManager] fontWithFamily:@"PingFangSC-Regular" traits:NSBoldFontMask weight:NSFontWeightMedium size:12];//[NSFont systemFontOfSize:10 weight:NSFontWeightMedium];
        _tipsText.alignment = NSTextAlignmentLeft;
        _tipsText.textColor = [NSColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
        _tipsText.bordered = NO;
        _tipsText.editable = NO;
        _tipsText.stringValue = @"入会或登录须先设置服务器！";
        [self.dashView addSubview:_tipsText];
    }
    
    return _tipsText;
}

- (NSTextField *)tipsText1 {
    if (!_tipsText1) {
        _tipsText1 = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _tipsText1.backgroundColor = [NSColor clearColor];
        _tipsText1.font = [[NSFontManager sharedFontManager] fontWithFamily:@"PingFangSC-Regular" traits:NSBoldFontMask weight:NSFontWeightMedium size:12];//[NSFont systemFontOfSize:10 weight:NSFontWeightMedium];
        _tipsText1.alignment = NSTextAlignmentLeft;
        _tipsText1.textColor = [NSColor colorWithRed:2/255.0 green:111/255.0 blue:254/255.0 alpha:1.0];
        _tipsText1.bordered = NO;
        _tipsText1.editable = NO;
        _tipsText1.stringValue = @"去设置";
        [self.dashView addSubview:_tipsText1];
    }
    
    return _tipsText1;
}

- (NSImageView *)arrowImageView {
    if (!_arrowImageView){
        _arrowImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 25)];
        [_arrowImageView setImage:[NSImage imageNamed:@"icon_arrow"]];
        _arrowImageView.imageAlignment =  NSImageAlignTopLeft;
        _arrowImageView.imageScaling =  NSImageScaleAxesIndependently;
        [self.view addSubview:_arrowImageView];
    }
    return _arrowImageView;
}

- (NSProgressIndicator *)makeCallProgress {
    if (!_makeCallProgress){
        _makeCallProgress = [[NSProgressIndicator alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        _makeCallProgress.style = NSProgressIndicatorStyleSpinning;
        _makeCallProgress.hidden = YES;
        [self.background addSubview:_makeCallProgress];
    }
    return _makeCallProgress;
}

//for story: SN-3457
/*
- (FrtcMakeCallProgressView *)makeCallProgress {
    if (!_makeCallProgress) {
        _makeCallProgress = [[FrtcMakeCallProgressView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
        _makeCallProgress.hidden = YES;
        [self.background addSubview:_makeCallProgress];
    }
    return _makeCallProgress;
}
*/

- (NSTextField *)makeCallTips {
    if (!_makeCallTips) {
        _makeCallTips = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _makeCallTips.backgroundColor = [NSColor clearColor];
        _makeCallTips.font = [NSFont systemFontOfSize:14 weight:NSFontWeightMedium];;
        _makeCallTips.alignment = NSTextAlignmentLeft;
        _makeCallTips.textColor = [NSColor colorWithString:@"666666" andAlpha:1.0];
        _makeCallTips.bordered = NO;
        _makeCallTips.editable = NO;
        _makeCallTips.stringValue = NSLocalizedString(@"FM_JOINING_CALL", @"Join...");
        _makeCallTips.hidden = YES;
        [self.view addSubview:_makeCallTips];
    }
    
    return _makeCallTips;
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
