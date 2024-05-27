#import "NormalSettingView.h"
#import "FrtcDefaultTextField.h"
#import "FrtcMultiTypesButton.h"
#import "FrtcBaseImplement.h"
#import "FrtcUserDefault.h"
#import "FrtcManagement.h"
#import "FrtcAlertMainWindow.h"
#import "FrtcPopUpButton.h"
#import "FMLanguageModel.h"
#import "NSBundle+FMLanguage.h"
#import "FMLanguageConfig.h"
#include <arpa/inet.h>

@interface NormalSettingView ()

@property (nonatomic, strong) NSTextField   *serverLabel;

@property (nonatomic, strong) FrtcDefaultTextField   *serverTextField;

@property (nonatomic, strong) FrtcMultiTypesButton      *saveButton;

@property (nonatomic, strong) NSTextField  *languageLabel;

@property (nonatomic, strong) FrtcPopUpButton *languageComboBox;

@property (nonatomic, strong) NSButton     *reminderOnOffButton;

@property (nonatomic, strong) NSTextField  *localReminderLabel;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) FMLanguageModel *languageModel;

@end

@implementation NormalSettingView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupNormalSettingView];
        [self.serverTextField.window makeFirstResponder:nil];
        [self selectLanguage];
    }
    
    return self;
}

- (void)dealloc {
}

- (void)setResponder {
    [self.serverTextField.window makeFirstResponder:nil];
}

#pragma mark -- internal layout --
- (void)setupNormalSettingView {
    [self.serverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(24);
         make.top.mas_equalTo(30);
         make.width.mas_greaterThanOrEqualTo(0);
         make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.serverTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.serverLabel.mas_bottom).offset(8);
        make.width.mas_equalTo(258);
        make.height.mas_equalTo(32);
     }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.serverTextField.mas_right).offset(10);
        make.centerY.mas_equalTo(self.serverTextField.mas_centerY);
        make.width.mas_equalTo(72);
        make.height.mas_equalTo(32);
     }];
    
    NSFont *font             = [NSFont systemFontOfSize:14.0f];
    NSDictionary *attributes = @{ NSFontAttributeName:font };
    CGSize size              = [NSLocalizedString(@"FM_SAVE_ADDRESS", @"Save Address") sizeWithAttributes:attributes];
    
    [self.saveButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.serverTextField.mas_right).offset(10);
        make.centerY.mas_equalTo(self.serverTextField.mas_centerY);
        make.width.mas_equalTo(size.width + 10);
        make.height.mas_equalTo(size.height + 10);
    }];
        
    [self.languageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.serverTextField.mas_bottom).offset(43);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.languageComboBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.languageLabel.mas_bottom).offset(8);
        make.width.mas_greaterThanOrEqualTo(145);
        make.height.mas_greaterThanOrEqualTo(32);
     }];
    
    [self.reminderOnOffButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.languageComboBox.mas_bottom).offset(43);
        make.width.mas_greaterThanOrEqualTo(360);
        make.height.mas_greaterThanOrEqualTo(16);
     }];
    
    [self.localReminderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(44);
        make.top.mas_equalTo(self.reminderOnOffButton.mas_bottom).offset(8);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
}

#pragma mark -- internal function --
- (NSButton *)checkButton:(NSString *)buttonTile aciton:(SEL)action {
    int btnWidth = 360;
    int btnHeight = 16;
    NSButton *checkButton = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, btnWidth, btnHeight)];
    [checkButton setButtonType:NSButtonTypeSwitch];
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:buttonTile];
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
    [checkButton setAttributedTitle:attrTitle];
    attrTitle = nil;
    [checkButton setNeedsDisplay:YES];
    
    checkButton.target = self;
    checkButton.action = action;
    [self addSubview:checkButton];
    
    return checkButton;
}

#pragma mark -- Button Sender --
- (void)onSaveBtnPressed {
    NSString *conferenceServer = self.serverTextField.stringValue;
    conferenceServer = [self removeSpaceAndNewLine:conferenceServer];
    
    NSString *tempServer = [[FrtcUserDefault defaultSingleton] objectForKey:STORAGE_SERVER_ADDRESS];
    tempServer = [self removeSpaceAndNewLine:tempServer];
    
    if(![tempServer isEqualToString:conferenceServer]) {
        [[FrtcUserDefault defaultSingleton] setObject:conferenceServer forKey:STORAGE_SERVER_ADDRESS];
    
        if(conferenceServer != nil || ![conferenceServer isEqualToString:@""]) {
            NSLog(@"set server is -->%@", conferenceServer);
            [[FrtcManagement sharedManagement] frtcSetSDKConfig:FRTCSDK_SERVER_ADDRESS withSDKConfigValue:conferenceServer];
        
            if(self.delegate && [self.delegate respondsToSelector:@selector(updateServerAddress)]) {
                [self.delegate updateServerAddress];
            }
        } else {
            NSLog(@"have no server");
        }
    }
}

- (void)onLanguageListSelChange {
    NSString *title = [self.languageComboBox titleOfSelectedItem];
    NSInteger index = [self.languageComboBox indexOfSelectedItem];
    
    NSLog(@"The index is %ld, the title is %@", index, title);
    
    FMLanguageModel *model = self.dataArr[index];
    if (model.select) {
        return;
    }
   
    FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_LANGUAGE_TITLE", @"Language settings will take \n effect after APP restarted") withMessage:@"" preferredStyle:FrtcWindowAlertStyleDefault withCurrentWindow:self.window];

    __weak __typeof(self)weakSelf = self;
    FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_LANGUAGE_CURRENT_ENABLE", @"Manual Restart") style:FrtcWindowAlertActionStyleOK handler:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        for (FMLanguageModel *model in strongSelf.dataArr) {
            model.select = NO;
        }
        model.select = !model.select;
        strongSelf->_languageModel = model;
        
        FMLanguageConfig.userLanguage = strongSelf->_languageModel.language;
        [NSApp terminate: nil];
    }];
    
    [alertWindow addAction:action];
    
    FrtcAlertAction *actionCancel = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_CANCEL", @"Cancel") style:FrtcWindowAlertActionStyleCancle handler:^{

    }];
    
    [alertWindow addAction:actionCancel];
}

- (void)selectLanguage {
    NSString *str = [FMLanguageConfig userLanguage];
    NSLog(@"-------%@-------", str);
    if([FMLanguageConfig userLanguage]) {
        if([[FMLanguageConfig userLanguage] isEqualToString:@"zh-Hans"]) {
            [self.languageComboBox selectItemAtIndex:0];
        } else if([[FMLanguageConfig userLanguage] isEqualToString:@"zh-HK"] || [[FMLanguageConfig userLanguage] isEqualToString:@"zh-Hant"]) {
            [self.languageComboBox selectItemAtIndex:1];
        } else {
            [self.languageComboBox selectItemAtIndex:2];
        }
    } else {
        
    }
}

- (void)onEnableReceiveMeetingReminderBtnPressed:(NSButton *)sender {
    if (sender.state == NSControlStateValueOn) {
        [[FrtcUserDefault defaultSingleton] setBoolObject:YES forKey:RECEIVE_MEETING_REMINDER];
        [[FrtcCallInterface singletonFrtcCall] enableOrDisableReceiveMeetingReminder:YES];
    } else {
        [[FrtcUserDefault defaultSingleton] setBoolObject:NO forKey:RECEIVE_MEETING_REMINDER];
        [[FrtcCallInterface singletonFrtcCall] enableOrDisableReceiveMeetingReminder:NO];
    }
}

#pragma mark -- getter lazy --
- (NSTextField *) serverLabel {
    if (!_serverLabel){
        _serverLabel = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 84, 20)];
        _serverLabel.stringValue = NSLocalizedString(@"FM_SERVER_ADDRESS", @"Server Address");
        _serverLabel.bordered = NO;
        _serverLabel.drawsBackground = NO;
        _serverLabel.backgroundColor = [NSColor clearColor];
        _serverLabel.textColor = [NSColor colorWithString:@"333333" andAlpha:1.0];
        _serverLabel.font = [NSFont systemFontOfSize:14];
        _serverLabel.alignment = NSTextAlignmentLeft;
        _serverLabel.editable = NO;
        [self addSubview:_serverLabel];
    }
    
    return _serverLabel;
}

- (FrtcDefaultTextField *)serverTextField {
    if (!_serverTextField){
        _serverTextField = [[FrtcDefaultTextField alloc] initWithFrame:CGRectMake(0, 0, 332, 20)];
        _serverTextField.layer.borderColor = [NSColor colorWithString:@"DEDEDE" andAlpha:1.0].CGColor;
        NSString *server = [[FrtcUserDefault defaultSingleton] objectForKey:STORAGE_SERVER_ADDRESS];
        server = [server isEqualToString:@""] ? @"" :server;
        _serverTextField.stringValue = server;
        _serverTextField.layer.borderWidth = 1.0;
        _serverTextField.layer.cornerRadius = 4.0f;
        _serverTextField.textColor = [NSColor colorWithString:@"222222" andAlpha:1.0];
        [[_serverTextField cell] setAllowedInputSourceLocales:@[NSAllRomanInputSourcesLocaleIdentifier]];
        [_serverTextField.cell setFont:[NSFont systemFontOfSize:14]];
        [self addSubview:_serverTextField];
    }
    
    return _serverTextField;
}

- (FrtcMultiTypesButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [[FrtcMultiTypesButton alloc] initThirdWithFrame:CGRectMake(0, 0, 0, 0) withTitle:NSLocalizedString(@"FM_SAVE_ADDRESS", @"Save Address")];
        _saveButton.target = self;
        _saveButton.action = @selector(onSaveBtnPressed);
        
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_SAVE_ADDRESS", @"Save Address")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"026FFE" andAlpha:1.0] range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14] range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
        [attrTitle fixAttributesInRange:range];
        [_saveButton setAttributedTitle:attrTitle];
        _saveButton.layer.cornerRadius = 4.0f;
        _saveButton.layer.borderWidth = 1.0;
        _saveButton.layer.masksToBounds = YES;
        _saveButton.layer.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] whiteColor].CGColor;
        _saveButton.layer.borderColor = [NSColor colorWithString:@"026FFE" andAlpha:1.0].CGColor;
        [self addSubview:_saveButton];
    }
    
    return _saveButton;
}



- (NSTextField *)languageLabel {
    if (!_languageLabel) {
        _languageLabel = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _languageLabel.stringValue = NSLocalizedString(@"FM_SELECT_LANGUAGE", @"Select language");
        _languageLabel.bordered = NO;
        _languageLabel.drawsBackground = NO;
        _languageLabel.backgroundColor = [NSColor clearColor];
        _languageLabel.textColor = [NSColor colorWithString:@"333333" andAlpha:1.0];
        _languageLabel.font = [NSFont systemFontOfSize:14];
        _languageLabel.alignment = NSTextAlignmentLeft;
        _languageLabel.editable = NO;
        [self addSubview:_languageLabel];
    }
    
    return _languageLabel;
}

- (FrtcPopUpButton *)languageComboBox {
    if (!_languageComboBox) {
        _languageComboBox = [[FrtcPopUpButton alloc] init];
        [_languageComboBox setFontWithString:@"222222" alpha:1 size:14 andType:SFProDisplayRegular];
        [_languageComboBox setTarget:self];
        [_languageComboBox setAction:@selector(onLanguageListSelChange)];
        [_languageComboBox addItemWithTitle:@"简体中文"];
        [_languageComboBox addItemWithTitle:@"繁體中文"];
        [_languageComboBox addItemWithTitle:@"English"];
        [self addSubview:_languageComboBox];
    }
    
    return  _languageComboBox;
}

- (NSButton *)reminderOnOffButton {
    if (!_reminderOnOffButton){
        _reminderOnOffButton = [self checkButton:NSLocalizedString(@"FM_MEETING_REMINDER_ACCEPTMEETING", @"Turn On Receive Meeting Reminders") aciton:@selector(onEnableReceiveMeetingReminderBtnPressed:)];
        
        BOOL withReminder = [[FrtcUserDefault defaultSingleton] boolObjectForKey:RECEIVE_MEETING_REMINDER];
        if (withReminder) {
            [_reminderOnOffButton setState:NSControlStateValueOn];
        } else {
            [_reminderOnOffButton setState:NSControlStateValueOff];
        }
    }
    
    return _reminderOnOffButton;
}

- (NSTextField *)localReminderLabel {
    if (!_localReminderLabel) {
        _localReminderLabel = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _localReminderLabel.stringValue = NSLocalizedString(@"FM_MEETING_REMINDER_SETTING_SWITCH_TIP", @"tip open receive reminder");
        _localReminderLabel.bordered = NO;
        _localReminderLabel.drawsBackground = NO;
        _localReminderLabel.backgroundColor = [NSColor clearColor];
        _localReminderLabel.textColor = [NSColor colorWithString:@"333333" andAlpha:1.0];
        _localReminderLabel.font = [NSFont systemFontOfSize:14];
        _localReminderLabel.alignment = NSTextAlignmentLeft;
        _localReminderLabel.editable = NO;
        [self addSubview:_localReminderLabel];
    }
    
    return _localReminderLabel;
}


#pragma mark --Data--

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        
        {
            FMLanguageModel *model = [FMLanguageModel new];
            model.title = @"简体中文";
            model.language = @"zh-Hans";
            model.select = [[NSBundle currentLanguage] hasPrefix:model.language];
            [_dataArr addObject:model];
        }
        
        {
            FMLanguageModel *model = [FMLanguageModel new];
            model.title = @"繁體中文";
            model.language = @"zh-HK";
            NSString *currentLan = [NSBundle currentLanguage];
            model.select = [currentLan hasPrefix:model.language] || [currentLan hasPrefix:@"zh-Hant"];
            [_dataArr addObject:model];
        }
        
        {
            FMLanguageModel *model = [FMLanguageModel new];
            model.title = @"English";
            model.language = @"en";
            model.select = [[NSBundle currentLanguage] hasPrefix:model.language];
            [_dataArr addObject:model];
        }
    }
    
    return _dataArr;
}

#pragma mark --internal function--
- (NSString *)removeSpaceAndNewLine:(NSString *)str {
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return temp;
}

- (BOOL)isValidIPAddress:(NSString *)serverAddress {
       const char *utf8 = [serverAddress UTF8String];
       int success;

       struct in_addr dst;
       success = inet_pton(AF_INET, utf8, &dst);
       if (success != 1) {
           struct in6_addr dst6;
           success = inet_pton(AF_INET6, utf8, &dst6);
       }

       return success == 1;
}

-(BOOL)checkIPandPortAddreddIsValid:(NSString*)ipAddress ipv4Type:(BOOL)isIPV4 {
    if (ipAddress.length == 0) {
        return NO;
    }
    
    NSString*strReguEx = nil;

    if (isIPV4) {
        strReguEx = @"^(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5]):([0-9]|[1-9]\\d|[1-9]\\d{2}|[1-9]\\d{3}|[1-5]\\d{4}|6[0-4]\\d{3}|65[0-4]\\d{2}|655[0-2]\\d|6553[0-5])$";
    } else {
        strReguEx = @"^((([0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){1,7}:)|(([0-9A-Fa-f]{1,4}:){6}:[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){5}(:[0-9A-Fa-f]{1,4}){1,2})|(([0-9A-Fa-f]{1,4}:){4}(:[0-9A-Fa-f]{1,4}){1,3})|(([0-9A-Fa-f]{1,4}:){3}(:[0-9A-Fa-f]{1,4}){1,4})|(([0-9A-Fa-f]{1,4}:){2}(:[0-9A-Fa-f]{1,4}){1,5})|([0-9A-Fa-f]{1,4}:(:[0-9A-Fa-f]{1,4}){1,6})|(:(:[0-9A-Fa-f]{1,4}){1,7})|(([0-9A-Fa-f]{1,4}:){6}(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])(\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])){3})|(([0-9A-Fa-f]{1,4}:){5}:(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])(\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])){3})|(([0-9A-Fa-f]{1,4}:){4}(:[0-9A-Fa-f]{1,4}){0,1}:(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])(\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])){3})|(([0-9A-Fa-f]{1,4}:){3}(:[0-9A-Fa-f]{1,4}){0,2}:(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])(\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])){3})|(([0-9A-Fa-f]{1,4}:){2}(:[0-9A-Fa-f]{1,4}){0,3}:(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])(\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])){3})|([0-9A-Fa-f]{1,4}:(:[0-9A-Fa-f]{1,4}){0,4}:(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])(\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])){3})|(:(:[0-9A-Fa-f]{1,4}){0,5}:(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])(\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])){3}))$";
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",strReguEx];
   
    BOOL result = [predicate evaluateWithObject:ipAddress];
    
    return result;
}

@end
