#import "FrtcSettingViewController.h"
#import "FrtcTabControlView.h"
#import "NormalSettingView.h"
#import "MediaSettingView.h"
#import "AboutSettingView.h"
#import "RecordingView.h"
#import "FrtcDefaultTextField.h"
#import "FrtcAlertMainWindow.h"
#import "FrtcMeetingManagement.h"
#import "CallResultReminderView.h"
#import "LabView.h"
#import "AccountView.h"
#import "UploadingLogView.h"
#import "VideoSettingView.h"
#import "FrtcUpdatePasswordWindow.h"
#import "AudioSettingView.h"

@interface FrtcSettingViewController () <FrtcTabControlViewViewDelegate, NSWindowDelegate, NormalSettingViewDelegate, LabViewDelegate, AccountViewDelegate, FrtcUpdatePasswordWindowDelegate>

@property (nonatomic, strong) FrtcTabControlView *tabControlView;

@property (nonatomic, strong) NSView *horizenView;

@property (nonatomic, strong) NSView *lineView;

@property (nonatomic, strong) NormalSettingView *normalSettingView;

@property (nonatomic, strong) AudioSettingView  *mediaSettingView;

@property (nonatomic, strong) AboutSettingView  *aboutSettingView;

@property (nonatomic, strong) LabView           *labView;

@property (nonatomic, strong) RecordingView     *recordingView;

@property (nonatomic, strong) AccountView       *accountView;

@property (nonatomic, strong) UploadingLogView  *uploadingView;

@property (nonatomic, strong) VideoSettingView  *videoSettingView;

@property (nonatomic, assign) NSUInteger oldIndex;

@property (nonatomic, strong) NSTextField  *titleTextField;

@property (nonatomic, strong) CallResultReminderView *reminderView;

@property (nonatomic, strong) NSTimer       *reminderTipsTimer;

@property (nonatomic, strong) FrtcUpdatePasswordWindow *updatePasswordWindow;


@end

@implementation FrtcSettingViewController

- (instancetype)initWithloginStatus:(BOOL)loginStatus {
    self = [super init];
    
    if(self) {
        self.login = loginStatus;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTabControlView];
    [self loadFirstView];
}

- (void)viewDidAppear {
    [self.normalSettingView setResponder];
}

- (void)dealloc {
    NSLog(@"------FrtcSettingViewController dealloc------");
}

- (void)stopLocalViewRender {
    if(!self.videoSettingView.isHidden) {
        [self.videoSettingView stop];
    }
}

- (void)loadFirstView {
    if(self.settingType == SettingTypeGuestCall || self.settingType == SettingTypeLoginCall) {
        self.videoSettingView.hidden = NO;
        self.normalSettingView.hidden = YES;
        [self.videoSettingView showLocalVideoView];
    } else {
        self.videoSettingView.hidden = YES;
        self.normalSettingView.hidden = NO;
    }
}

- (void)setupTabControlView {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(13);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.tabControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(44);
        make.width.mas_equalTo(184);
        make.height.mas_equalTo(516);
    }];
    
    [self.horizenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(43);
        make.width.mas_equalTo(640);
        make.height.mas_equalTo(1);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tabControlView.mas_right);
        make.top.mas_equalTo(44);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(516);
    }];
    
    [self.normalSettingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lineView.mas_right);
        make.top.mas_equalTo(44);
        make.width.mas_equalTo(455);
        make.height.mas_equalTo(516);
    }];
    
    [self.mediaSettingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lineView.mas_right);
        make.top.mas_equalTo(44);
        make.width.mas_equalTo(455);
        make.height.mas_equalTo(516);
    }];
    
    [self.aboutSettingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lineView.mas_right);
        make.top.mas_equalTo(44);
        make.width.mas_equalTo(455);
        make.height.mas_equalTo(516);
    }];
    
    [self.uploadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lineView.mas_right);
        make.top.mas_equalTo(44);
        make.width.mas_equalTo(455);
        make.height.mas_equalTo(516);
    }];
}

#pragma mark -AccountViewDelegate-
- (void)frtcPersonalLogout {
    NSString *userToken = [[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN];
    
    __weak __typeof(self)weakSelf = self;
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcLogoutWithUserToken:userToken logoutSuccess:^(NSDictionary * _Nonnull userInfo) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if([strongSelf.view.window isVisible]) {
            [strongSelf.view.window close];
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

- (void)frtcPersonalupdatePassword {
    self.updatePasswordWindow = [[FrtcUpdatePasswordWindow alloc] initWithSize:NSMakeSize(380, 455)];
    self.updatePasswordWindow.normalUser = [self.model.securityLevel isEqualToString:@"NORMAL"] ? YES : NO;
    [self.updatePasswordWindow setupPasswordSecurityLevel];
    
    self.updatePasswordWindow.modifyDelegate = self;
    
    [self.updatePasswordWindow setMovable:NO];
    self.updatePasswordWindow.titlebarAppearsTransparent = YES;
    self.updatePasswordWindow.backgroundColor = [NSColor whiteColor];
    self.updatePasswordWindow.styleMask = NSWindowStyleMaskTitled|NSWindowStyleMaskClosable | NSWindowStyleMaskFullSizeContentView;
    
    [self.updatePasswordWindow showWindowWithWindow:self.view.window];
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
                    if([strongSelf.view.window isVisible]) {
                        [strongSelf.view.window close];
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


#pragma mark -FrtcTabControlViewViewDelegate-
- (void)didSelectedIndex:(NSInteger)index {
    if(index == SettingNormalTag) {
        if(self.normalSettingView.isHidden) {
            self.normalSettingView.hidden = NO;
        }
        self.videoSettingView.hidden      = YES;
        self.mediaSettingView.hidden      = YES;
        self.aboutSettingView.hidden      = YES;
        self.labView.hidden               = YES;
        self.recordingView.hidden         = YES;
        self.accountView.hidden           = YES;
        self.uploadingView.hidden         = YES;
    } else if(index == SettingVideoTag) {
        if(self.videoSettingView.isHidden) {
            self.videoSettingView.hidden = NO;
            [self.videoSettingView showLocalVideoView];
        }
        self.normalSettingView.hidden    = YES;
        self.mediaSettingView.hidden     = YES;
        self.aboutSettingView.hidden     = YES;
        self.labView.hidden              = YES;
        self.recordingView.hidden        = YES;
        self.accountView.hidden          = YES;
        self.uploadingView.hidden        = YES;
    } else if(index == SettingMediaTag) {
        if(self.mediaSettingView.isHidden) {
            self.mediaSettingView.hidden = NO;
        }
        self.normalSettingView.hidden    = YES;
        self.videoSettingView.hidden      = YES;
        self.aboutSettingView.hidden     = YES;
        self.labView.hidden              = YES;
        self.recordingView.hidden        = YES;
        self.accountView.hidden          = YES;
        self.uploadingView.hidden        = YES;
    } else if(index == SettingAboutTag) {
        if(self.aboutSettingView.isHidden) {
            self.aboutSettingView.hidden = NO;
        }
        self.normalSettingView.hidden    = YES;
        self.videoSettingView.hidden      = YES;
        self.mediaSettingView.hidden     = YES;
        self.labView.hidden              = YES;
        self.recordingView.hidden        = YES;
        self.accountView.hidden          = YES;
        self.uploadingView.hidden        = YES;
    } else if(index == SettingLabTag) {
        if(self.labView.isHidden) {
            self.labView.hidden = NO;
        }
        
        self.normalSettingView.hidden = YES;
        self.videoSettingView.hidden      = YES;
        self.mediaSettingView.hidden  = YES;
        self.aboutSettingView.hidden  = YES;
        self.recordingView.hidden     = YES;
        self.accountView.hidden       = YES;
        self.uploadingView.hidden     = YES;
    } else if(index == SettingRecordingTag) {
        if(self.recordingView.isHidden) {
            self.recordingView.hidden = NO;
        }
        
        self.normalSettingView.hidden = YES;
        self.videoSettingView.hidden      = YES;
        self.mediaSettingView.hidden  = YES;
        self.aboutSettingView.hidden  = YES;
        self.labView.hidden           = YES;
        self.accountView.hidden       = YES;
        self.uploadingView.hidden     = YES;
    } else if(index == SettingAccountTag) {
        if(self.accountView.isHidden) {
            self.accountView.hidden = NO;
            
            self.accountView.nameTabCell.detailTextField.stringValue = self.model.realName ? self.model.realName : [NSString stringWithFormat:@"%@%@",self.model.lastname, self.model.firstname];
            self.accountView.accountTabCell.detailTextField.stringValue = self.model.username;
        }
        
        self.normalSettingView.hidden = YES;
        self.videoSettingView.hidden  = YES;
        self.mediaSettingView.hidden  = YES;
        self.aboutSettingView.hidden  = YES;
        self.labView.hidden           = YES;
        self.recordingView.hidden     = YES;
        self.uploadingView.hidden     = YES;
    } else if(index == SettingDiagnosis) {
        if(self.uploadingView.isHidden) {
            self.uploadingView.hidden = NO;
        }
        
        self.normalSettingView.hidden = YES;
        self.videoSettingView.hidden      = YES;
        self.mediaSettingView.hidden  = YES;
        self.aboutSettingView.hidden  = YES;
        self.labView.hidden           = YES;
        self.accountView.hidden       = YES;
        self.recordingView.hidden     = YES;
    }
    
    _oldIndex = index;
}

#pragma mark --LabViewDelegate--
- (void)enableLabFeature:(BOOL)enableLabFeature {
    [self.tabControlView updateLayout:enableLabFeature];
}

#pragma mark --NormalSettingViewDelegate--
- (void)updateServerAddress {
    NSString *description;
    if(self.settingType == SettingTypeLogin || self.settingType == SettingTypeLoginCall) {
        description = NSLocalizedString(@"FM_MODITY_SERVER_ADDRESS_LOGIN", @"Please sign in again");
        [self popupAlertWindowWithDescription:description];
    } else {
        description = NSLocalizedString(@"FM_MODITY_SERVER_ADDRESS", @"Saved successfully");
        [self showReminderView:description];
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

- (void)wrongServerAddress {
    FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:@"错误" withMessage:@"输入服务器地址错误" preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:self.view.window];

    FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
    }];
    
    [alertWindow addAction:action];
}

- (BOOL)checkIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    
    NSString *strReguEx = @"^(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",strReguEx];
       // 字符串判断，然后BOOL值
    BOOL result = [predicate evaluateWithObject:ipAddress];
    
    return result;
}
#pragma mark --internal function
- (void)popupAlertWindowWithDescription:(NSString *)description {
    FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_MODIFY_SERVER_ADDRESS_TITLE", @"Server address changed") withMessage:description preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:self.view.window];
    
    __weak __typeof(self)weakSelf = self;
    FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if(strongSelf.settingType == SettingTypeLogin || strongSelf.settingType == SettingTypeLoginCall) {
            NSString *userToken = [[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN];
            
            [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcLogoutWithUserToken:userToken logoutSuccess:^(NSDictionary * _Nonnull userInfo) {
                [[FrtcUserDefault defaultSingleton] setObject:@"" forKey:USER_ID];
            } logoutFailure:^(NSError * _Nonnull error) {
                NSLog(@"-------%@--------", error);
            }];
            
            [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FrtcMeetingMainViewShowNotification object:nil userInfo:nil];
            [self.view.window close];
        }
    }];
    
    [alertWindow addAction:action];
}

- (void)close {
    if(!self.videoSettingView.isHidden) {
        [self.videoSettingView stop];
    }
}

- (void)updataSettingComboxWithUserSelectMenuButtonGridMode:(BOOL)isGridMode {
    [self.videoSettingView updataSettingComboxWithUserSelectMenuButtonGridMode:isGridMode];
}

#pragma mark -- getter lazy --
- (FrtcTabControlView *)tabControlView {
    if(!_tabControlView) {
        _tabControlView = [[FrtcTabControlView alloc] initWithFrame:NSMakeRect(0, 0, 184, 516) withLoginStatus:self.login withSettingType:self.settingType];
        //_tabControlView.login = self.isLogin;
        _tabControlView.settingType = self.settingType;
        _tabControlView.tabControlDelegate = self;
        [self.view addSubview:_tabControlView];
    }
    
    return _tabControlView;;
}

- (NSView *)lineView {
    if(!_lineView) {
        _lineView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 1, 517)];
        _lineView.wantsLayer = YES;
        _lineView.layer.backgroundColor = [NSColor colorWithString:@"F0F0F5" andAlpha:1].CGColor;
        [self.view addSubview:_lineView];
    }
    
    return _lineView;
}

- (NSView *)horizenView {
    if(!_horizenView) {
        _horizenView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 640, 1)];
        _horizenView.wantsLayer = YES;
        _horizenView.layer.backgroundColor = [NSColor colorWithString:@"F0F0F5" andAlpha:1].CGColor;
        [self.view addSubview:_horizenView];
    }
    
    return _horizenView;
}

- (NormalSettingView *)normalSettingView {
    if(!_normalSettingView) {
        _normalSettingView = [[NormalSettingView alloc] init];
        _normalSettingView.wantsLayer = YES;
        _normalSettingView.delegate = self;
        _normalSettingView.layer.backgroundColor = [NSColor whiteColor].CGColor;
        _normalSettingView.hidden = NO;
        [self.view addSubview:_normalSettingView];
    }
    
    return _normalSettingView;
}

- (AudioSettingView *)mediaSettingView {
    if(!_mediaSettingView) {
        _mediaSettingView = [[AudioSettingView alloc] initWithFrame:CGRectMake(186, 0, 455, 516)];
        _mediaSettingView.wantsLayer = YES;
        _mediaSettingView.layer.backgroundColor = [NSColor whiteColor].CGColor;
        _mediaSettingView.hidden = YES;
        [self.view addSubview:_mediaSettingView];
    }
    
    return _mediaSettingView;
}

- (AboutSettingView *)aboutSettingView {
    if(!_aboutSettingView) {
        _aboutSettingView = [[AboutSettingView alloc] initWithFrame:CGRectMake(186, 0, 455, 516)];
        _aboutSettingView.wantsLayer = YES;
        _aboutSettingView.layer.backgroundColor = [NSColor whiteColor].CGColor;
        _aboutSettingView.hidden = YES;
        [self.view addSubview:_aboutSettingView];
    }
    
    return _aboutSettingView;
}

- (LabView *)labView {
    if(!_labView) {
        _labView = [[LabView alloc] initWithFrame:CGRectMake(186, 0, 455, 516)];
        _labView.wantsLayer = YES;
        _labView.delegate = self;
        _labView.layer.backgroundColor = [NSColor whiteColor].CGColor;
        _labView.hidden = YES;
        [self.view addSubview:_labView];
    }
    
    return _labView;
}

-(RecordingView *)recordingView {
    if(!_recordingView) {
        _recordingView = [[RecordingView alloc] initWithFrame:CGRectMake(186, 0, 455, 516)];
        _recordingView.wantsLayer = YES;
        _recordingView.layer.backgroundColor = [NSColor whiteColor].CGColor;
        _recordingView.hidden = YES;
        [self.view addSubview:_recordingView];
    }
    
    return _recordingView;
}

- (AccountView *)accountView {
    if(!_accountView) {
        _accountView = [[AccountView alloc] initWithFrame:CGRectMake(186, 0, 455, 516)];
        _accountView.wantsLayer = YES;
        _accountView.hidden = YES;
        _accountView.delegate = self;
        [self.view addSubview:_accountView];
    }
    
    return _accountView;
}

- (UploadingLogView *)uploadingView {
    if(!_uploadingView) {
        _uploadingView = [[UploadingLogView alloc] initWithFrame:CGRectMake(186, 0, 455, 516)];
        _uploadingView.wantsLayer = YES;
        _uploadingView.hidden = YES;
        //_uploadingView.delegate = self;
        [self.view addSubview:_uploadingView];
    }
    
    return _uploadingView;
}

- (VideoSettingView *)videoSettingView {
    if(!_videoSettingView) {
        _videoSettingView = [[VideoSettingView alloc] initWithFrame:CGRectMake(186, 0, 455, 516)];
        _videoSettingView.wantsLayer = YES;
        _videoSettingView.hidden = YES;
        //_uploadingView.delegate = self;
        [self.view addSubview:_videoSettingView];
    }
    
    return _videoSettingView;
}



- (NSTextField *)titleTextField {
    if (!_titleTextField){
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleTextField.stringValue = NSLocalizedString(@"FM_SETTING", @"Settings");
        _titleTextField.bordered = NO;
        _titleTextField.drawsBackground = NO;
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.layer.backgroundColor = [NSColor colorWithString:@"FFFFFF" andAlpha:1.0].CGColor;
        _titleTextField.font = [NSFont systemFontOfSize:16 weight:NSFontWeightMedium];
        _titleTextField.textColor = [NSColor colorWithString:@"222222" andAlpha:1.0];
        _titleTextField.alignment = NSTextAlignmentRight;
        _titleTextField.editable = NO;
        [self.view addSubview:_titleTextField];
    }
    
    return _titleTextField;
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


@end
