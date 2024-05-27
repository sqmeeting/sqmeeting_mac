#import "FrtcUpdatePasswordWindow.h"
#import "AppDelegate.h"
#import "FrtcSecureTextField.h"
#import "FrtcMultiTypesButton.h"
#import "CallResultReminderView.h"
#import "PasswordTextField.h"

@interface FrtcUpdatePasswordWindow() <PMSecureTextFieldDelegate, PasswordTextFieldDelegate>

@property (nonatomic, assign) NSSize        windowSize;
@property (nonatomic, assign) NSRect        windowFrame;
@property (nonatomic, strong) NSView        *parentView;
@property (nonatomic, assign) BOOL          defaultCenter;
@property (nonatomic, weak)   AppDelegate   *appDelegate;

@property (nonatomic, strong) NSTextField   *titleTextField;

@property (nonatomic, strong) NSView        *lineView;

@property (nonatomic, strong) NSTextField           *oldPasswordText;
@property (nonatomic, strong) FrtcSecureTextField     *oldPasswordInputView;
@property (nonatomic, strong) PasswordTextField     *pwdTextField;

@property (nonatomic, strong) NSTextField           *updatePasswordText;
@property (nonatomic, strong) FrtcSecureTextField     *updatePasswordInputView;
@property (nonatomic, strong) PasswordTextField     *updatePwdTextField;

@property (nonatomic, strong) NSTextField           *passwordDescription;
@property (nonatomic, strong) NSTextField           *confirmPassWordText;
@property (nonatomic, strong) FrtcSecureTextField     *confirmPasswordInputView;
@property (nonatomic, strong) PasswordTextField     *confirmPwdTextField;

@property (nonatomic, strong) FrtcMultiTypesButton              *saveUpdateButton;
@property (nonatomic, strong) FrtcMultiTypesButton              *cancelUpdateButton;

@property (nonatomic, strong) CallResultReminderView *reminderView;
@property (nonatomic, strong) NSTimer                *reminderTipsTimer;

@end

@implementation FrtcUpdatePasswordWindow

- (instancetype)initWithSize:(NSSize)size {
    self = [super init];
    if (self) {
        self.defaultCenter = YES;
        self.windowSize = size;
        self.releasedWhenClosed = NO;
        [self setupUpdatePasswordWindowUI];
    }
    
    return self;
}

- (instancetype)initWithFrame:(NSRect)rect {
    self = [super init];
    if (self) {
        self.defaultCenter = NO;
        self.windowFrame = rect;
        self.windowSize = rect.size;
        [self setupUpdatePasswordWindowUI];
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"FrtcUpdatePasswordWindow dealloc");
}

- (void)setupUpdatePasswordWindowUI {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(7);
        make.width.mas_equalTo(381);
        make.height.mas_equalTo(1);
    }];
    
    [self.oldPasswordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(24);
        make.top.mas_equalTo(self.lineView.mas_top).offset(30);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.oldPasswordInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.mas_equalTo(self.oldPasswordText.mas_centerY);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(36);
    }];
    
    [self.pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.mas_equalTo(self.oldPasswordText.mas_centerY);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(36);
    }];
    
    [self.updatePasswordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(24);
        make.top.mas_equalTo(self.oldPasswordText.mas_bottom).offset(28);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.updatePasswordInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.mas_equalTo(self.updatePasswordText.mas_centerY);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(36);
    }];
    
    [self.updatePwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.mas_equalTo(self.updatePasswordText.mas_centerY);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(36);
    }];
    
    [self.passwordDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(80);
        make.top.mas_equalTo(self.updatePasswordInputView.mas_bottom).offset(4);
        //make.width.mas_greaterThanOrEqualTo(0);
        make.width.mas_equalTo(280);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
        
    [self.confirmPassWordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(24);
        make.top.mas_equalTo(self.passwordDescription.mas_bottom).offset(15);
        //make.width.mas_greaterThanOrEqualTo(0);
        make.width.mas_equalTo(280);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.confirmPasswordInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.mas_equalTo(self.updatePasswordText.mas_right).offset(8);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.mas_equalTo(self.confirmPassWordText.mas_centerY);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(36);
    }];
    
    [self.confirmPwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.mas_equalTo(self.confirmPassWordText.mas_centerY);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(36);
    }];
    
    [self.saveUpdateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-24);
        make.top.mas_equalTo(self.confirmPasswordInputView.mas_bottom).offset(24);
        make.width.mas_equalTo(158);
        make.height.mas_equalTo(36);
    }];
    
    [self.cancelUpdateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(24);
        make.top.mas_equalTo(self.confirmPasswordInputView.mas_bottom).offset(24);
        make.width.mas_equalTo(158);
        make.height.mas_equalTo(36);
    }];
    
    [self.reminderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(158);
        make.height.mas_equalTo(36);
    }];
}

- (void)showWindow {
    self.appDelegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
    NSWindow* window = [NSApplication sharedApplication].windows.firstObject;
    NSView* view = window.contentView;
    NSRect frameRelativeToWindow = [view convertRect:view.bounds toView:nil];
    NSPoint pointRelativeToScreen = [view.window convertRectToScreen:frameRelativeToWindow].origin;
    NSPoint pos = NSZeroPoint;
    if (self.defaultCenter) {
        pos.x = pointRelativeToScreen.x + (view.bounds.size.width-self.windowSize.width-view.frame.origin.x)/2;
        pos.y = pointRelativeToScreen.y + (view.bounds.size.height-self.windowSize.height-view.frame.origin.y)/2;
    } else {
        pos = self.frame.origin;
    }
    [self setFrame:NSMakeRect(0, 0, self.windowSize.width, self.windowSize.height) display:YES];
    [self setFrameOrigin:pos];
    [view.window addChildWindow:self ordered:NSWindowAbove];
    self.parentView = view;
    [self makeKeyAndOrderFront:self.parentWindow];
}

- (void)showWindowWithWindow:(NSWindow *)window {
    NSView* view = window.contentView;
    NSRect frameRelativeToWindow = [view convertRect:view.bounds toView:nil];
    NSPoint pointRelativeToScreen = [view.window convertRectToScreen:frameRelativeToWindow].origin;
    NSPoint pos = NSZeroPoint;
    if (self.defaultCenter) {
        pos.x = pointRelativeToScreen.x + (view.bounds.size.width-self.windowSize.width-view.frame.origin.x)/2;
        pos.y = pointRelativeToScreen.y + (view.bounds.size.height-self.windowSize.height-view.frame.origin.y)/2;
    } else {
        pos = self.frame.origin;
    }
    [self setFrame:NSMakeRect(0, 0, self.windowSize.width, self.windowSize.height) display:YES];
    [self setFrameOrigin:pos];
    [view.window addChildWindow:self ordered:NSWindowAbove];
    self.parentView = view;
    [self makeKeyAndOrderFront:self.parentWindow];
}

- (void)adjustToSize:(NSSize)size {
    NSRect frameRelativeToWindow = [self.parentView convertRect:self.parentView.bounds toView:nil];
    NSPoint pointRelativeToScreen = [self.parentView.window convertRectToScreen:frameRelativeToWindow].origin;
    NSPoint pos = NSZeroPoint;
    pos.x = pointRelativeToScreen.x + (self.parentView.bounds.size.width-size.width-self.parentView.frame.origin.x)/2;
    pos.y = pointRelativeToScreen.y + (self.parentView.bounds.size.height-size.height-self.parentView.frame.origin.y)/2;
    [self setFrame:NSMakeRect(0, 0, size.width, size.height) display:YES];
    [self setFrameOrigin:pos];
}

- (void)setupPasswordSecurityLevel {
    if(self.isNormalUser) {
        self.passwordDescription.stringValue = NSLocalizedString(@"FM_NORMAL_PASSWORD", @"Password length must be between 6 and 48 characters, can be upper and lower case letters, numbers, or special characters");
    } else {
        self.passwordDescription.stringValue = NSLocalizedString(@"FM_LOGIN_PASSWORD", @"Password length must be between 8 and 48 characters, must contain upper and lower case letters, numbers, and special characters");
    }
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

#pragma mark --PasswordTextFieldDelegate--PMSecureTextFieldDelegate---
- (void)switchPasswordView:(NSInteger)tag {
    if(tag == 201) {
        self.oldPasswordInputView.hidden = YES;
        self.pwdTextField.hidden = NO;
        self.pwdTextField.stringValue = self.oldPasswordInputView.stringValue;
        [self.pwdTextField becomeFirstResponder];
    } else if(tag == 202) {
        self.pwdTextField.hidden = YES;
        self.oldPasswordInputView.hidden = NO;
        self.oldPasswordInputView.stringValue = self.pwdTextField.stringValue;
        [self.oldPasswordInputView becomeFirstResponder];
    } else if(tag == 203) {
        self.updatePasswordInputView.hidden = YES;
        self.updatePwdTextField.hidden = NO;
        self.updatePwdTextField.stringValue = self.updatePasswordInputView.stringValue;
        [self.updatePwdTextField becomeFirstResponder];
    } else if(tag == 204) {
        self.updatePwdTextField.hidden = YES;
        self.updatePasswordInputView.hidden = NO;
        self.updatePasswordInputView.stringValue = self.updatePwdTextField.stringValue;
        [self.updatePasswordInputView becomeFirstResponder];
    } else if(tag == 205) {
        self.confirmPasswordInputView.hidden = YES;
        self.confirmPwdTextField.hidden = NO;
        self.confirmPwdTextField.stringValue = self.confirmPasswordInputView.stringValue;
        [self.confirmPwdTextField becomeFirstResponder];
    } else if(tag == 206) {
        self.confirmPwdTextField.hidden = YES;
        self.confirmPasswordInputView.hidden = NO;
        self.confirmPasswordInputView.stringValue = self.confirmPwdTextField.stringValue;
        [self.confirmPasswordInputView becomeFirstResponder];
    }
}

#pragma mark --Button Sender--
- (void)onSaveModifyPassword:(FrtcMultiTypesButton *)sender {
    NSLog(@"%@",self.pwdTextField.stringValue);
    NSLog(@"%@",self.oldPasswordInputView.stringValue);
    NSLog(@"%@",self.updatePwdTextField.stringValue);
    NSLog(@"%@",self.updatePasswordInputView.stringValue);
    NSLog(@"%@",self.confirmPwdTextField.stringValue);
    NSLog(@"%@",self.confirmPasswordInputView.stringValue);
    NSString *oldPassword = self.pwdTextField.hidden ? self.oldPasswordInputView.stringValue : self.pwdTextField.stringValue;
    NSString *updatePassword = self.updatePwdTextField.hidden ? self.updatePasswordInputView.stringValue : self.updatePwdTextField.stringValue;
    NSString *confirmPassword = self.confirmPwdTextField.hidden ? self.confirmPasswordInputView.stringValue : self.confirmPwdTextField.stringValue;
   
    if([oldPassword isEqualToString:@""] || [updatePassword isEqualToString:@""] || [confirmPassword isEqualToString:@""]) {
        [self showReminderView:NSLocalizedString(@"FM_PASSWORD_NOT_EMPTY", @"Password can't be empty")];
        return;
    }
    if(![updatePassword isEqualToString:confirmPassword]) {
        [self showReminderView:NSLocalizedString(@"FM_PASSWORD_TWO_ERROR", @"Confirm password is inconsistent with new password")];
        return;
    }
    
    NSString *patternText;
    if(self.isNormalUser) {
        patternText = @"^[a-zA-Z0-9!@#$%*()\\[\\]_+^&}{:;?.]{6,48}$";
    } else {
        patternText = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$!@#$%*()\\[\\]_+^&}{:;?.])[A-Za-z\\d$!@#$%*()\\[\\]_+^&}{:;?.]{8,48}";
    }
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:patternText options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:confirmPassword options:0 range:NSMakeRange(0, [confirmPassword length])];
    if (!result) {
        [self showReminderView:NSLocalizedString(@"FM_PASSWORD_NEW_PASSWORD_WRONG", @"New password doesn't meet the complexity rules")];
        return;
    }
    
    if(self.modifyDelegate && [self.modifyDelegate respondsToSelector:@selector(modifyPassWord:newPassword:)]) {
        [self.modifyDelegate modifyPassWord:oldPassword newPassword:confirmPassword];
    }
}

- (void)onCancelModifyPassword:(FrtcMultiTypesButton *)sender {
    [self orderOut:nil];
}

#pragma mark --Class Interface
- (void)showReminderView:(NSString *)reminderValue {
    NSFont *font             = [NSFont systemFontOfSize:14.0f];
    NSDictionary *attributes = @{ NSFontAttributeName:font };
    CGSize size              = [reminderValue sizeWithAttributes:attributes];
    
    [self.reminderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(size.width + 28);
        make.height.mas_equalTo(size.height + 20);
    }];
    
    self.reminderView.tipLabel.stringValue = reminderValue;
    self.reminderView.hidden = NO;
    [self runningTimer:2.0];
}


#pragma mark -- NSTextField delegate
- (void)controlTextDidChange:(NSNotification *)obj {
    NSLog(@"%@", obj);
}

#pragma mark --lazy load--
- (NSTextField *)titleTextField {
    if (!_titleTextField){
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
   
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:16 weight:NSFontWeightMedium];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"222222" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.stringValue = NSLocalizedString(@"FM_MODIFY_PASSWORD", @"Update Password");
        [self.contentView addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (NSView *)lineView {
    if(!_lineView) {
        _lineView = [[NSView alloc] initWithFrame:CGRectMake(0, 43, 381, 1)];
        _lineView.wantsLayer = YES;
        _lineView.layer.backgroundColor = [NSColor colorWithString:@"F0F0F5" andAlpha:1.0].CGColor;
        [self.contentView addSubview:_lineView];
    }
    
    return _lineView;
}

- (NSTextField *)oldPasswordText {
    if(!_oldPasswordText) {
        _oldPasswordText = [self textLabel:NSLocalizedString(@"FM_OLD_PASSWORD", @"Old")];
        [self.contentView addSubview:_oldPasswordText];
    }
    
    return _oldPasswordText;;
}

- (FrtcSecureTextField *)oldPasswordInputView {
    if (!_oldPasswordInputView){
        _oldPasswordInputView = [self secureTextView];
        _oldPasswordInputView.placeholderString = NSLocalizedString(@"FM_UPDATE_OLD_PASSWORD", @"Old Password");
        _oldPasswordInputView.tag = 201;
        _oldPasswordInputView.secureTextFieldDelegate = self;
        [self.contentView addSubview:_oldPasswordInputView];
    }
    
    return  _oldPasswordInputView;
}

- (PasswordTextField *)pwdTextField {
    if(!_pwdTextField) {
        _pwdTextField = [self pwdTextView];
        _pwdTextField.placeholderString = NSLocalizedString(@"FM_UPDATE_OLD_PASSWORD", @"Old Password");
        _pwdTextField.passwordDelegate = self;
        _pwdTextField.tag = 202;
        _pwdTextField.hidden = YES;
        [self.contentView addSubview:_pwdTextField];
    }
    
    return _pwdTextField;
}

- (NSTextField *)updatePasswordText {
    if(!_updatePasswordText) {
        _updatePasswordText = [self textLabel:NSLocalizedString(@"FM_NEW_PASSWORD", @"New")];
        _updatePasswordText.placeholderString = @"";
        [self.contentView addSubview:_updatePasswordText];
    }
    
    return _updatePasswordText;
}

- (FrtcSecureTextField *)updatePasswordInputView {
    if (!_updatePasswordInputView){
        _updatePasswordInputView = [self secureTextView];
        _updatePasswordInputView.placeholderString = NSLocalizedString(@"FM_UPDATE_NEW_PASSWORD", @"Set a new password");
        _updatePasswordInputView.secureTextFieldDelegate = self;
        _updatePasswordInputView.tag = 203;
        [self.contentView addSubview:_updatePasswordInputView];
    }
    
    return  _updatePasswordInputView;
}

- (PasswordTextField *)updatePwdTextField {
    if(!_updatePwdTextField) {
        _updatePwdTextField = [self pwdTextView];
        _updatePwdTextField.placeholderString = NSLocalizedString(@"FM_UPDATE_NEW_PASSWORD", @"Set a new password");
        _updatePwdTextField.passwordDelegate = self;
        _updatePwdTextField.tag = 204;
        _updatePwdTextField.hidden = YES;
        [self.contentView addSubview:_updatePwdTextField];
    }
    
    return _updatePwdTextField;
}

-(NSTextField *)passwordDescription {
    if(!_passwordDescription) {
        _passwordDescription = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        //_titleTextField.accessibilityClearButton;
        _passwordDescription.backgroundColor = [NSColor clearColor];
        _passwordDescription.font = [NSFont systemFontOfSize:12 weight:NSFontWeightRegular];
        _passwordDescription.alignment = NSTextAlignmentLeft;
        _passwordDescription.textColor = [NSColor colorWithString:@"999999" andAlpha:1.0];
        _passwordDescription.bordered = NO;
        _passwordDescription.editable = NO;
        _passwordDescription.maximumNumberOfLines = 3;
        _passwordDescription.stringValue = @"密码长度为6-16位，必须包含字母和数字";
        [self.contentView addSubview:_passwordDescription];
    }
    
    return _passwordDescription;
}


- (NSTextField *)confirmPassWordText {
    if(!_confirmPassWordText) {
        _confirmPassWordText = [self textLabel:NSLocalizedString(@"FM_CONFIRM", @"Confirm")];
        //_titleTextField.accessibilityClearButton;
        [self.contentView addSubview:_confirmPassWordText];
    }
    
    return _confirmPassWordText;;
}

- (FrtcSecureTextField *)confirmPasswordInputView {
    if(!_confirmPasswordInputView) {
        _confirmPasswordInputView = [self secureTextView];
        _confirmPasswordInputView.secureTextFieldDelegate = self;
        _confirmPasswordInputView.placeholderString = NSLocalizedString(@"FM_CONFIRM_NEW_PASSWORD", @"Confirm new password");;
        _confirmPasswordInputView.tag = 205;
        [self.contentView addSubview:_confirmPasswordInputView];
    }
    
    return _confirmPasswordInputView;
}

- (PasswordTextField *)confirmPwdTextField {
    if(!_confirmPwdTextField) {
        _confirmPwdTextField = [self pwdTextView];
        _confirmPwdTextField.passwordDelegate = self;
        _confirmPwdTextField.placeholderString = NSLocalizedString(@"FM_CONFIRM_NEW_PASSWORD", @"Confirm new password");;
        _confirmPwdTextField.tag = 206;
        _confirmPwdTextField.hidden = YES;
        [self.contentView addSubview:_confirmPwdTextField];
    }
    
    return _confirmPwdTextField;
}

- (FrtcMultiTypesButton *)saveUpdateButton {
    if (!_saveUpdateButton) {
        _saveUpdateButton = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 158, 36) withTitle:NSLocalizedString(@"FM_SAVE", @"Save")];
        _saveUpdateButton.target = self;
        _saveUpdateButton.layer.cornerRadius = 4.0;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_SAVE", @"Save")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[[FrtcBaseImplement baseImpleSingleton] whiteColor]
                          range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                          range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [_saveUpdateButton setAttributedTitle:attrTitle];
        _saveUpdateButton.action = @selector(onSaveModifyPassword:);
        [self.contentView addSubview:_saveUpdateButton];
    }
    
    return _saveUpdateButton;
}

- (FrtcMultiTypesButton*)cancelUpdateButton {
    if (!_cancelUpdateButton){
        _cancelUpdateButton = [[FrtcMultiTypesButton alloc] initSecondaryWithFrame:CGRectMake(0, 0, 158, 36) withTitle:NSLocalizedString(@"FM_CANCEL", @"Cancel")];
        _cancelUpdateButton.target = self;
        _cancelUpdateButton.hover = NO;
        _cancelUpdateButton.layer.cornerRadius = 4.0;
        _cancelUpdateButton.bordered = NO;
        _cancelUpdateButton.layer.borderWidth = 0.0;
        _cancelUpdateButton.layer.backgroundColor = [NSColor colorWithRed:240/255.0 green:240/255.0 blue:245/255.0 alpha:1.0].CGColor;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_CANCEL", @"Cancel")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]
                          range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                          range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [_cancelUpdateButton setAttributedTitle:attrTitle];
        _cancelUpdateButton.action = @selector(onCancelModifyPassword:);
        [self.contentView addSubview:_cancelUpdateButton];
    }
    return _cancelUpdateButton;
}

-(CallResultReminderView *)reminderView {
    if(!_reminderView) {
        _reminderView = [[CallResultReminderView alloc] initWithFrame:CGRectMake(0, 0, 172, 40)];
        _reminderView.tipLabel.stringValue = NSLocalizedString(@"FM_NETWORK_EXCEPTION_REY_TRY", @"Network exception,Please check your network on try re-join");
        _reminderView.hidden = YES;
        
        [self.contentView addSubview:_reminderView];
    }
    
    return _reminderView;
}

#pragma mark --internal function--
- (NSTextField *)textLabel:(NSString *)title {
    NSTextField *text = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    text.backgroundColor = [NSColor clearColor];
    text.font = [NSFont systemFontOfSize:14 weight:NSFontWeightRegular];
    text.alignment = NSTextAlignmentLeft;
    text.textColor = [NSColor colorWithString:@"222222" andAlpha:1.0];
    text.bordered = NO;
    text.editable = NO;
    text.stringValue = title;
    
    return text;
}

- (FrtcSecureTextField *)secureTextView {
    FrtcSecureTextField *secureInputView = [[FrtcSecureTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    secureInputView.editable = YES;
    secureInputView.bordered = YES;
    secureInputView.textColor = [NSColor colorWithString:@"222222" andAlpha:1.0];
    secureInputView.alignment = NSTextAlignmentLeft;
    [secureInputView setFocusRingType:NSFocusRingTypeNone];
    secureInputView.backgroundColor = [NSColor whiteColor];
    [secureInputView.cell setFont:[NSFont systemFontOfSize:14]];
    secureInputView.wantsLayer = YES;
    secureInputView.layer.backgroundColor = [NSColor whiteColor].CGColor;
    secureInputView.layer.cornerRadius = 4.0f;
    secureInputView.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
    secureInputView.layer.borderWidth = 1.0;
    [secureInputView.cell setAllowedInputSourceLocales: @[NSAllRomanInputSourcesLocaleIdentifier]];
    
    return secureInputView;
}

- (PasswordTextField *)pwdTextView {
    PasswordTextField *pwdInputView = [[PasswordTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    pwdInputView.editable = YES;
    pwdInputView.bordered = YES;
    pwdInputView.textColor = [NSColor colorWithString:@"222222" andAlpha:1.0];
    pwdInputView.alignment = NSTextAlignmentLeft;
    [pwdInputView setFocusRingType:NSFocusRingTypeNone];
    pwdInputView.backgroundColor = [NSColor whiteColor];
    [pwdInputView.cell setFont:[NSFont systemFontOfSize:14]];
    pwdInputView.wantsLayer = YES;
    pwdInputView.layer.backgroundColor = [NSColor whiteColor].CGColor;
    pwdInputView.layer.cornerRadius = 4.0f;
    pwdInputView.layer.borderColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
    pwdInputView.layer.borderWidth = 1.0;
    [pwdInputView.cell setAllowedInputSourceLocales: @[NSAllRomanInputSourcesLocaleIdentifier]];
    
    return pwdInputView;
}

@end
