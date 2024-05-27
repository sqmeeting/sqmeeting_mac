#import "FrtcSignViewController.h"
#import "Masonry.h"
#import "FrtcHoverButton.h"
#import "FrtcMultiTypesButton.h"
#import "MyCustomAnimator.h"
#import "FrtcDefaultTextField.h"
#import "FrtcUserDefault.h"
#import "FrtcBaseImplement.h"
#import "FrtcCallWindow.h"
#import "FrtcSettingViewController.h"
#import "LoginTextField.h"
#import "FrtcMeetingManagement.h"
#import "CallResultReminderView.h"
#import "LoginSecureTextField.h"
#import "NumberLimiteFormatter.h"
#import "FrtcButton.h"
#import "LoginFailureModel.h"

#define kLoginErrorCode00 @"0x00003000"
#define kLoginErrorCode01 @"0x00003001"
#define kLoginErrorCode02 @"0x00003002"
#define kLoginErrorCode03 @"0x00003003"

#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

@interface FrtcSignViewController ()<NSTextFieldDelegate>

@property (nonatomic, strong) NSImageView               *backgroundView;
@property (nonatomic, strong) NSImageView               *logoView;
@property (nonatomic, strong) FrtcHoverButton      *settingButton;
@property (nonatomic, strong) NSTextField               *titleTextField;

@property (nonatomic, strong) LoginTextField            *accountIDText;
@property (nonatomic, strong) LoginSecureTextField      *passwordText;
//@property (nonatomic, strong) FrtcMultiTypesButton                  *loginButton;
@property (nonatomic, strong) FrtcButton                *loginButton;

@property (nonatomic, strong) NSButton                  *rememberPasswordButton;
@property (nonatomic, strong) FrtcMultiTypesButton                  *nextButton;
@property (nonatomic, strong) NSButton                  *backButton;
@property (nonatomic, strong) FrtcMultiTypesButton                  *backButton1;

#pragma mark --After login UI--

@property (nonatomic, strong) NSImageView               *bigLogoView;
@property (nonatomic, strong) NSTextField               *appNameText;
@property (nonatomic, strong) NSTextField               *betaText;
@property (nonatomic, strong) NSTextField               *loginText;
@property (nonatomic, strong) CallResultReminderView    *reminderView;

@property (strong, nonatomic) NSTimer                   *reminderTipsTimer;

@end

@implementation FrtcSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self configMainView];
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
    [self setDefaultValue];
}

- (void)configMainView {
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(292);
        make.left.mas_equalTo(self.view.mas_left);
        make.width.mas_equalTo(640);
        make.height.mas_equalTo(188);
     }];
    
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(86);
        make.left.mas_equalTo(self.view.mas_left).offset(260);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
     }];
    
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(94);
        make.left.mas_equalTo(self.logoView.mas_right).offset(8);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.accountIDText mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.mas_equalTo(self.view.mas_centerX);
         make.top.mas_equalTo(self.logoView.mas_bottom).offset(30);
         make.width.mas_equalTo(280);
         make.height.mas_equalTo(40);
     }];
    
    [self.passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.accountIDText.mas_bottom).offset(16);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(40);
     }];
    
    //self.accountIDText.nextKeyView = self.passwordText;
    
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(24);
        make.right.mas_equalTo(self.view.mas_right).offset(-24);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
     }];
    
//    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.view.mas_top).offset(276);
//        make.centerX.mas_equalTo(self.view.mas_centerX);
//        make.width.mas_equalTo(280);
//        make.height.mas_equalTo(40);
//     }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(276);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(40);
     }];
    
    [self.rememberPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loginButton.mas_bottom).offset(16);
        make.left.mas_equalTo(self.view.mas_left).offset(186);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
//    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.rememberPasswordButton.mas_centerY);
//        make.right.mas_equalTo(self.view.mas_right).offset(-184);
//        make.width.mas_equalTo(60);
//        make.height.mas_equalTo(20);
//     }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(24);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-26);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.backButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backButton.mas_right).offset(4);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-26);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(20);
    }];
    
    NSFont *font             = [NSFont systemFontOfSize:14.0f];
    NSDictionary *attributes = @{ NSFontAttributeName:font };
    CGSize size              = [NSLocalizedString(@"FM_BACK", @"Back") sizeWithAttributes:attributes];
        
    [self.backButton1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backButton.mas_right).offset(2);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-27);
        make.width.mas_equalTo(size.width + 10);
        make.height.mas_equalTo(20);
    }];
    
#pragma mark --After login UI--
    [self.bigLogoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(50);
        //make.left.mas_equalTo(self.view.mas_left).offset(266);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(108);
        make.height.mas_equalTo(108);
     }];
    
    [self.appNameText mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.left.mas_equalTo(self.view.mas_left).offset(268);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(163);
        make.width.mas_greaterThanOrEqualTo(72);
        make.height.mas_greaterThanOrEqualTo(28);
     }];
    

    self.betaText.hidden = YES;
    
    [self.loginText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(249);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.reminderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(232);
        make.width.mas_equalTo(208);
        make.height.mas_equalTo(40);
     }];
}

- (void)dealloc {
    NSLog(@"FrtcSignViewController dealloc");
    [self cancelTimer];
}

- (void)setDefaultValue {
    NSString *name = [[FrtcUserDefault defaultSingleton] objectForKey:LOGIN_NAME];
    
    if(name != nil || ![name isEqualToString:@""]) {
        self.accountIDText.stringValue = [[FrtcUserDefault defaultSingleton] objectForKey:LOGIN_NAME];
    } else {
        self.accountIDText.stringValue = @"";
    }
}

#pragma mark -- NSTextField delegate
- (void)controlTextDidChange:(NSNotification *)obj {
    BOOL userNameCharacters2One = self.accountIDText.stringValue.length > 0 ? YES : NO;
    BOOL userPasswordCharacters2Six = self.passwordText.stringValue.length > 5 ? YES : NO;
    
    NSTextField *textField = obj.object;
    if(textField.tag == 101) {
        if([textField.stringValue length] > 0) {
            userNameCharacters2One = YES;
        } else {
            userNameCharacters2One = NO;
        }
    } else if(textField.tag == 102) {
        if([textField.stringValue length] > 5) {
            userPasswordCharacters2Six = YES;
        } else {
            userPasswordCharacters2Six = NO;
        }
    }
    
    if(userNameCharacters2One && userPasswordCharacters2Six) {
        self.loginButton.enabled = YES;
        
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_SIGN_IN", @"Sign In") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_SIGN_IN", @"Sign In") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        self.loginButton.hoverButtonMode = hoverMode;
        [self.loginButton updateButtonWithButtonMode:normalMode];
        self.loginButton.normalButtonMode = normalMode;
        self.loginButton.hoverd = YES;
    } else {
        self.loginButton.enabled = NO;
        FrtcButtonMode *disableMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:0.6] andbackgroundacaColor:[NSColor colorWithString:@"#026FFE" andAlpha:0.6] andButtonTitle:NSLocalizedString(@"FM_SIGN_IN", @"Sign In") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        self.loginButton.hoverd = NO;
        [self.loginButton updateButtonWithButtonMode:disableMode];
    }
}

- (BOOL)control:(NSControl*)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector {
    BOOL result = NO;
    
    if (commandSelector == @selector(insertTab:)) {
        if(((LoginTextField *)control).tag == 101) {
            //NSTextView* textView = (NSTextView *)(((DetailTimeTextField *)control).currentEditor);
            [self.passwordText becomeFirstResponder];
        }
        
    }
    return result;

}


#pragma mark --Button Sender--
- (void)onSettingButtonPressed:(FrtcHoverButton *)senser {
    if(self.delegate && [self.delegate respondsToSelector:@selector(popupSettingWindow)]) {
        [self.delegate popupSettingWindow];
    }
}

- (void)onLoginPressed:(FrtcMultiTypesButton *)sender {
    [self onLoginingStatus];
    [[FrtcUserDefault defaultSingleton] setObject:self.accountIDText.stringValue forKey:LOGIN_NAME];
    
    if (self.rememberPasswordButton.state == NSControlStateValueOn) {
        [[FrtcUserDefault defaultSingleton] setObject:self.passwordText.stringValue forKey:LOGIN_PASSWORD];
    }
    
    __weak __typeof(self)weakSelf = self;
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcLoginWithUserName:self.accountIDText.stringValue withPassword:self.passwordText.stringValue loginSuccess:^(LoginModel *model) {
        NSLog(@"Mac Client login success!");
        NSDictionary *userInfo = @{@"loginmodel" :model};
        [[FrtcUserDefault defaultSingleton] setObject:model.user_id forKey:USER_ID];
        [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FrtcMeetingLoginViewShowNotification object:nil userInfo:userInfo];
    } loginFailure:^(NSError * _Nonnull error) {
        NSLog(@"Mac Client login failure");
        NSLog(@"%@", error);
        //error.userInfo
        NSHTTPURLResponse *response = error.userInfo[@"com.alamofire.serialization.response.error.response"];
//        NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
//
        NSInteger statusCode = response.statusCode;
        
        NSLog(@"**********************************");
        NSDictionary *erroInfo = error.userInfo;
        NSData *data = [erroInfo valueForKey:@"com.alamofire.serialization.response.error.data"];
        NSString *errorString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSError *error1 = nil;
        LoginFailureModel *failureModel = [[LoginFailureModel alloc] initWithString:errorString error:&error1];
        
        NSLog(@"The LoginFailureModel error is %@, error code is %@", failureModel.error, failureModel.errorCode);
        
        NSLog(@"userInfo error113 %@", errorString);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSLog(@"**********************************");
        [strongSelf onLoginFailure];
        NSString *reminderValue = [self toastString:failureModel.errorCode];
        
        if(kStringIsEmpty(reminderValue)) {
            reminderValue = [self getErrorWithCode:error.code];
        }
        
        [self showReminderView:reminderValue];
        
        // 获取错误信息mutableUserInfo
//        NSError *mutableUserInfo = error.userInfo[NSUnderlyingErrorKey];
//        // 获取错误响应请求信息
//        NSHTTPURLResponse *urlResponse = mutableUserInfo.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
//        // 获取错误响应信息
//        NSString *errStr = [[NSString alloc] initWithData: mutableUserInfo.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding: NSUTF8StringEncoding];
//        if (urlResponse.statusCode == 302) {
//          // 状态为302
//          //  TODO
       // }

    }];
}

-(NSString *)getErrorWithCode:(NSInteger)code {
    NSString *errorMsg = @"";
    switch (code) {
        case NSURLErrorUnknown: //-1
            errorMsg = NSLocalizedString(@"network_error_1", nil);
            break;
        case NSURLErrorCancelled: //-999
            errorMsg = NSLocalizedString(@"network_error_999", nil);
            break;
        case NSURLErrorTimedOut: //-1001
            errorMsg = NSLocalizedString(@"network_error_1001", nil);
            break;
        case NSURLErrorUnsupportedURL: //-1002
            errorMsg = NSLocalizedString(@"network_error_1002", nil);
            break;;
        case NSURLErrorBadServerResponse: //-1011
            errorMsg = NSLocalizedString(@"network_error_1011", nil);
            break;
        case NSURLErrorCannotParseResponse: //-1017
            errorMsg = NSLocalizedString(@"network_error_1017", nil);
            break;
        default:
            errorMsg = NSLocalizedString(@"network_error", nil);
            break;
    }
    return errorMsg;
}

- (NSString *)toastString:(NSString *)errorCode {
    NSString *errorMessage = @"";
    if ([errorCode isEqualToString:kLoginErrorCode00]) { // 登录时发生错误，请重新登录
        errorMessage = NSLocalizedString(@"FM_USER_PASSWORD_ERROR", @"Invalid username or password.Please try again.");
    } else if ([errorCode isEqualToString:kLoginErrorCode01]) { // 登录时，密码输入6次后，账户被冻结
        errorMessage = NSLocalizedString(@"FM_USER_LOGIN_ERROR01", @"User has been locked, please retry after 5 minutes");
    } else if ([errorCode isEqualToString:kLoginErrorCode02]) { // 登录时，账户已被锁定
        //self.lock = YES;
        errorMessage = NSLocalizedString(@"FM_USER_LOGIN_ERROR02", @"User has been locked, please contact administrator");
    } else if ([errorCode isEqualToString:kLoginErrorCode03]) { // 登录时，密码输入错误，但是尚未冻结
        errorMessage = NSLocalizedString(@"FM_USER_PASSWORD_ERROR", @"Invalid username or password.Please try again.");
    } else {
        errorMessage = NSLocalizedString(@"FM_USER_PASSWORD_ERROR", @"Invalid username or password.Please try again.");
    }
    
    return errorMessage;
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

- (void)onRememberButtonPressed:(NSButton *)sender {
    if(sender.state == NSControlStateValueOn) {
        [[FrtcUserDefault defaultSingleton] setBoolObject:YES forKey:STORAGE_PASSWORD];
    } else {
        [[FrtcUserDefault defaultSingleton] setBoolObject:NO forKey:STORAGE_PASSWORD];
    }
}

- (void)onJoinVideoMeetingPressed:(FrtcMultiTypesButton *)sender {
    FrtcCallWindow *callWindow = [[FrtcCallWindow alloc] initWithSize:NSMakeSize(380, 365)];
    //callWindow.delegate = self;
    
    [callWindow setMovable:NO];
    callWindow.titlebarAppearsTransparent = YES;
    callWindow.backgroundColor = [NSColor whiteColor];
    callWindow.styleMask = NSWindowStyleMaskTitled|NSWindowStyleMaskClosable;
    
    [callWindow showWindow];
}

- (void)onBackButtonPressed {
    id animator = [[MyCustomAnimator alloc] init];
    [self dismissController:animator];
}

#pragma mark --internal function--
- (void)onLoginingStatus {
    self.logoView.hidden                = YES;
    self.loginButton.hidden             = YES;
    self.titleTextField.hidden          = YES;
    self.rememberPasswordButton.hidden  = YES;
    self.accountIDText.hidden           = YES;
    self.passwordText.hidden            = YES;
    //self.nextButton.hidden              = YES;
    
    self.bigLogoView.hidden             = NO;
    self.appNameText.hidden             = NO;
    self.betaText.hidden                = YES;
    self.loginText.hidden               = NO;
}

- (void)onLoginFailure {
    self.logoView.hidden                = NO;
    self.loginButton.hidden             = NO;
    self.titleTextField.hidden          = NO;
    self.rememberPasswordButton.hidden  = NO;
    self.accountIDText.hidden           = NO;
    self.passwordText.hidden            = NO;
    //self.nextButton.hidden              = NO;
    
    self.bigLogoView.hidden             = YES;
    self.appNameText.hidden             = YES;
    self.betaText.hidden                = YES;
    self.loginText.hidden               = YES;
    self.reminderView.hidden            = NO;
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

#pragma mark --getter lazy load--
- (NSImageView *)backgroundView {
    if (!_backgroundView){
        _backgroundView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 292, 640, 188)];
        [_backgroundView setImage:[NSImage imageNamed:@"icon-background"]];
        _backgroundView.imageAlignment =  NSImageAlignCenter;
        _backgroundView.imageScaling =  NSImageScaleAxesIndependently;
        [self.view addSubview:_backgroundView];
    }
    return _backgroundView;
}

- (NSImageView *)logoView {
    if (!_logoView){
        _logoView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 108, 108)];
        [_logoView setImage:[NSImage imageNamed:@"icon-small-logo"]];
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
        _settingButton.action = @selector(onSettingButtonPressed:);
        [self.view addSubview:_settingButton];
    }
    
    return _settingButton;
}

- (FrtcButton *)loginButton {
    if(!_loginButton) {
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_SIGN_IN", @"Sign In") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_SIGN_IN", @"Sign In") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        FrtcButtonMode *disableMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:0.6] andbackgroundacaColor:[NSColor colorWithString:@"#026FFE" andAlpha:0.6] andButtonTitle:NSLocalizedString(@"FM_SIGN_IN", @"Sign In") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
 
        _loginButton = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 240, 40) withNormalMode:normalMode withHoverMode:hoverMode];
        [_loginButton updateButtonWithButtonMode:disableMode];
        _loginButton.enabled = NO;
        _loginButton.hoverd  = NO;
        _loginButton.target  = self;
        _loginButton.action  = @selector(onLoginPressed:);
        
        [self.view addSubview:_loginButton];
    }
    
    return _loginButton;
}

- (NSTextField *)titleTextField {
    if (!_titleTextField){
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleTextField.stringValue = NSLocalizedString(@"FM_USER_LOGIN", @"User Sign In");
        _titleTextField.bordered = NO;
        _titleTextField.drawsBackground = NO;
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.layer.backgroundColor = [NSColor colorWithString:@"FFFFFF" andAlpha:1.0].CGColor;
        _titleTextField.font = [NSFont systemFontOfSize:18 weight:NSFontWeightMedium];
        _titleTextField.textColor = [NSColor colorWithString:@"222222" andAlpha:1.0];
        _titleTextField.alignment = NSTextAlignmentLeft;
        _titleTextField.editable = NO;
        [self.view addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (NSButton *)rememberPasswordButton {
    if (!_rememberPasswordButton) {
        _rememberPasswordButton = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, 36, 16)];
        [_rememberPasswordButton setButtonType:NSButtonTypeSwitch];
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_AUTO_LOGIN", @"Auto Sign In")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[[FrtcBaseImplement baseImpleSingleton] baseColor]
                          range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                          range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [_rememberPasswordButton setAttributedTitle:attrTitle];
        attrTitle = nil;
        [_rememberPasswordButton setNeedsDisplay:YES];
        
        BOOL enableNB = [[FrtcUserDefault defaultSingleton] boolObjectForKey:STORAGE_PASSWORD];
        if (enableNB) {
            [_rememberPasswordButton setState:NSControlStateValueOn];
        } else {
            [_rememberPasswordButton setState:NSControlStateValueOff];
        }
        
        _rememberPasswordButton.target = self;
        _rememberPasswordButton.action = @selector(onRememberButtonPressed:);
        [self.view addSubview:_rememberPasswordButton];
    }
    
    return _rememberPasswordButton;
}

- (LoginTextField *)accountIDText {
    if (!_accountIDText){
        _accountIDText = [[LoginTextField alloc] initWithFrame:CGRectMake(0, 0, 332, 40)];
        _accountIDText.tag = 101;
        _accountIDText.placeholderString = NSLocalizedString(@"FM_USER_PALCEHOLDER", @"User Sign In");
        _accountIDText.delegate = self;
        NumberLimiteFormatter *formatter = [[NumberLimiteFormatter alloc] init];
        [formatter setMaximumLength:48];
        [_accountIDText setFormatter:formatter];
        [_accountIDText.imageView setImage:[NSImage imageNamed:@"icon-account-login"]];
        [self.view addSubview:_accountIDText];
    }
    
    return _accountIDText;
}

- (LoginSecureTextField *)passwordText {
    if (!_passwordText){
        _passwordText = [[LoginSecureTextField alloc] initWithFrame:CGRectMake(0, 0, 332, 40)];
        _passwordText.tag = 102;
        _passwordText.placeholderString = NSLocalizedString(@"FM_PLEASE_PASSWORD", @"Please input password");
        _passwordText.delegate = self;
        NumberLimiteFormatter *formatter = [[NumberLimiteFormatter alloc] init];
        [formatter setMaximumLength:32];
        [_passwordText setFormatter:formatter];
        [_passwordText.imageView setImage:[NSImage imageNamed:@"icon-sectet-login"]];
        [self.view addSubview:_passwordText];
    }
    
    return _passwordText;
}

- (FrtcMultiTypesButton *)nextButton {
    if(!_nextButton) {
        _nextButton = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 240, 40) withTitle:NSLocalizedString(@"FM_SIGN_IN", @"Sign In")];
        _nextButton.target = self;
        _nextButton.action = @selector(onJoinVideoMeetingPressed:);
        _nextButton.hover = NO;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:@"会议号入会"];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"026FFE" andAlpha:1.0]
                          range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:12]
                          range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [_nextButton setAttributedTitle:attrTitle];
        attrTitle = nil;
        [_nextButton setBordered:NO];
        _nextButton.layer.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] whiteColor].CGColor;
        _nextButton.layer.masksToBounds = NO;
        [self.view addSubview:_nextButton];
    }
    
    return _nextButton;
}

- (NSButton *)backButton {
    if (!_backButton){
        _backButton = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _backButton.bordered = NO;
        _backButton.wantsLayer = YES;
        _backButton.layer.backgroundColor = [NSColor clearColor].CGColor;
        [_backButton setImage:[NSImage imageNamed:@"icon-back-gray"]];
        _backButton.target = self;
        _backButton.action = @selector(onBackButtonPressed);
        [self.view addSubview:_backButton];
    }
    
    return _backButton;
}

- (FrtcMultiTypesButton *)backButton1 {
    if(!_backButton1) {
        _backButton1 = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 240, 40) withTitle:NSLocalizedString(@"FM_BACK", @"Back")];
        _backButton1.hover = NO;
        _backButton1.target = self;
        _backButton1.action = @selector(onBackButtonPressed);
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_BACK", @"Back")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"666666" andAlpha:1.0]
                          range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                          range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [_backButton1 setAttributedTitle:attrTitle];
        attrTitle = nil;
        [_backButton1 setBordered:NO];
        _backButton1.layer.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] whiteColor].CGColor;
        _backButton1.layer.masksToBounds = NO;
        [self.view addSubview:_backButton1];
    }
    
    return _backButton1;
}

- (NSImageView *)bigLogoView {
    if (!_bigLogoView){
        _bigLogoView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 108, 108)];
        [_bigLogoView setImage:[NSImage imageNamed:@"icon-logo"]];
        _bigLogoView.imageAlignment =  NSImageAlignTopLeft;
        _bigLogoView.imageScaling =  NSImageScaleAxesIndependently;
        _bigLogoView.hidden = YES;
        [self.view addSubview:_bigLogoView];
    }
    return _bigLogoView;
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
        _appNameText.hidden = YES;
        _appNameText.stringValue = NSLocalizedString(@"FM_APP_NAME", @"SQ Meeting CE ");
        [self.view addSubview:_appNameText];
    }
    
    return _appNameText;
}

- (NSTextField *)betaText {
    if (!_betaText){
        _betaText = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _betaText.backgroundColor = [NSColor clearColor];
        _betaText.font = [[NSFontManager sharedFontManager] fontWithFamily:@"PingFangSC-Regular" traits:NSBoldFontMask weight:NSFontWeightMedium size:10];
        _betaText.alignment = NSTextAlignmentRight;
        _betaText.textColor = [NSColor colorWithRed:18/255.0 green:120/255.0 blue:247/255.0 alpha:1.0];
        _betaText.bordered = NO;
        _betaText.editable = NO;
        _betaText.stringValue = @"BETA";
        _betaText.hidden = YES;
        [self.view addSubview:_betaText];
    }
    
    return _betaText;
}

- (NSTextField *)loginText {
    if (!_loginText){
        _loginText = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _loginText.backgroundColor = [NSColor clearColor];
        _loginText.font = [NSFont systemFontOfSize:16 weight:NSFontWeightSemibold];
        _loginText.alignment = NSTextAlignmentRight;
        _loginText.textColor = [NSColor colorWithString:@"026FFE" andAlpha:1.0];
        _loginText.bordered = NO;
        _loginText.editable = NO;
        _loginText.hidden = YES;
        _loginText.stringValue = NSLocalizedString(@"FM_LOGIN", @"Signing…");
        [self.view addSubview:_loginText];
    }
    
    return _loginText;
}

- (CallResultReminderView *)reminderView {
    if(!_reminderView) {
        _reminderView = [[CallResultReminderView alloc] initWithFrame:CGRectMake(0, 0, 172, 40)];
        _reminderView.tipLabel.stringValue = NSLocalizedString(@"FM_USER_PASSWORD_ERROR", @"Invalid username or password.Please try again.");
        _reminderView.hidden = YES;
        
        [self.view addSubview:_reminderView];
    }
    
    return _reminderView;
}

- (void)mouseDown:(NSEvent *)event {
    NSLog(@"---------");
    NSPoint aPoint = [self.view convertPoint:[event locationInWindow] fromView:nil];
    if (!NSPointInRect(aPoint, self.view.bounds)) {
        return;
    }
}

@end
