#import "FrtcCallWindow.h"
#import "AppDelegate.h"
#import "FrtcDefaultTextField.h"
#import "FrtcMultiTypesButton.h"
#import "FrtcDefaultLabel.h"
#import "Masonry.h"
#import "FrtcBaseImplement.h"
#import "FrtcCallInterface.h"
#import "FrtcUserDefault.h"
#import "FrtcBorderTextField.h"
#import "NumberLimiteFormatter.h"
#import "CallResultReminderView.h"

@interface FrtcCallWindow () <NSTextFieldDelegate>

@property (nonatomic, assign) NSSize        windowSize;
@property (nonatomic, assign) NSRect        windowFrame;
@property (nonatomic, strong) NSView        *parentView;
@property (nonatomic, assign) BOOL          defaultCenter;
@property (nonatomic, weak)   AppDelegate   *appDelegate;

@property (nonatomic, strong) NSTextField   *titleTextField;
@property (nonatomic, strong) FrtcDefaultLabel       *meetingIDLabel;
@property (nonatomic, strong) FrtcDefaultTextField   *meetingIDText;
@property (nonatomic, strong) FrtcDefaultLabel       *nameLabel;
@property (nonatomic, strong) FrtcDefaultTextField   *nameText;

@property (nonatomic, strong) NSButton      *micphoneOnOffButton;
@property (nonatomic, strong) NSButton      *cameraOnOffButton;
@property (nonatomic, strong) NSButton      *audioOnlyButton;

@property (nonatomic, strong) NSView        *line;

@property (nonatomic, strong) FrtcMultiTypesButton      *joinMeetingButton;
@property (nonatomic, strong) FrtcMultiTypesButton      *cancelMeetingButton;

@property (nonatomic, strong) FrtcBorderTextField *reminderUserNameTextField;
@property (nonatomic, strong) NSImageView   *reminderUserNameImageView;

@property (nonatomic, strong) FrtcBorderTextField *reminderConferenceTextField;
@property (nonatomic, strong) NSImageView   *reminderConferenceImageView;

@property (nonatomic, strong) CallResultReminderView *reminderView;

@property (nonatomic, strong) NSTimer *reminderTipsTimer;

@end

@implementation FrtcCallWindow

- (instancetype)initWithSize:(NSSize)size {
    self = [super init];
    
    if (self) {
        self.defaultCenter = YES;
        self.releasedWhenClosed = NO;
        self.windowSize = size;
        [self setMovable:NO];
        self.titlebarAppearsTransparent = YES;
        self.backgroundColor = [NSColor whiteColor];
        self.styleMask = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable;
        [[self standardWindowButton:NSWindowZoomButton] setHidden:YES];
        [[self standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
        [self setupCallWindowUI];
        [self setDefaultNameAndConferenceAlias];
    }
    
    return self;
}

- (void)setDefaultNameAndConferenceAlias {
    NSString *name;
    
    if (self.isLogin) {
        name = self.userName;
    } else {
        name = [[FrtcUserDefault defaultSingleton] objectForKey:STORAGE_USER_NAME];;
    }
    
    if (name != nil) {
        _nameText.stringValue = name;
    }
    
    NSString *conferenceAlias = [[FrtcUserDefault defaultSingleton] objectForKey:STORAGE_MEETING_NUMBER];
    
    if (conferenceAlias != nil) {
        _meetingIDText.stringValue = [[FrtcUserDefault defaultSingleton] objectForKey:STORAGE_MEETING_NUMBER];
    }
}

- (void)showReminderView:(NSString *)stringValue {
    NSString *reminderValue = stringValue;
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

#pragma mark- --Timer--
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


- (void)setUserName:(NSString *)userName {
    if(userName != nil) {
        _userName = userName;
        _nameText.stringValue = _userName;
    }
}

- (NSString *)removeSpaceAndNewLine:(NSString *)str {
    NSString *temp = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return temp;
}

#pragma mark --button sender--
- (void)onJoinVideoMeetingPressed {
    self.meetingIDText.stringValue = [self removeSpaceAndNewLine:self.meetingIDText.stringValue];
    
    if ([[self.meetingIDText stringValue] isEqualToString:@""]) {
        [self.nameText mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(self.meetingIDText.mas_bottom).offset(30);
            make.width.mas_equalTo(336);
            make.height.mas_equalTo(40);
        }];
        
        self.reminderConferenceTextField.hidden = NO;
        self.reminderConferenceImageView.hidden = NO;

        [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
            context.duration = 0.5;
            context.allowsImplicitAnimation = true;
            [self.contentView layoutSubtreeIfNeeded];
        } completionHandler:^{
        }];
        
        return;;
    }
    
    self.nameText.stringValue = [self removeSpaceAndNewLine:self.nameText.stringValue];
    
    if ([[self.nameText stringValue] isEqualToString:@""]) {
        [self.micphoneOnOffButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(24);
            make.top.mas_equalTo(self.nameText.mas_bottom).offset(35);
            make.width.mas_greaterThanOrEqualTo(360);
            make.height.mas_greaterThanOrEqualTo(16);
         }];
        self.reminderUserNameTextField.hidden = NO;
        self.reminderUserNameImageView.hidden = NO;

        [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
            context.duration = 0.5;
            context.allowsImplicitAnimation = true;
            [self.contentView layoutSubtreeIfNeeded];
        } completionHandler:^{
        }];
        
        return;;
    }
    
    NSString* conferenceAlias =  [self.meetingIDText stringValue];
    NSString* displayName = [self.nameText stringValue];
    
    BOOL joinWitCamera = NO;
    BOOL joinWithMicrophone = NO;
    BOOL audioOnlyCall = NO;

    if (self.micphoneOnOffButton.state == NSControlStateValueOn) {
        joinWithMicrophone = YES;
    } else {
        joinWithMicrophone = NO;
    }
    
    if (self.cameraOnOffButton.state == NSControlStateValueOn) {
        joinWitCamera = YES;
    } else {
        joinWitCamera = NO;
    }
    
    if (self.audioOnlyButton.state == NSControlStateValueOn) {
        audioOnlyCall = YES;
    } else {
        audioOnlyCall = NO;
    }
    
    [[FrtcUserDefault defaultSingleton] setObject:conferenceAlias forKey:STORAGE_MEETING_NUMBER];
    
    if (!self.isLogin) {
        [[FrtcUserDefault defaultSingleton] setObject:displayName forKey:STORAGE_USER_NAME];
    }
    
    NSString *conferenceCallRate = [[FrtcUserDefault defaultSingleton] objectForKey:MEETING_RATE];
    int numberCallRate = [conferenceCallRate intValue];
    
    FRTCMeetingParameters callParam;
    
    callParam.meeting_alias         = conferenceAlias;
    callParam.display_name          = displayName;
    callParam.call_rate             = numberCallRate;
    callParam.video_mute            = !joinWitCamera;
    callParam.audio_mute            = !joinWithMicrophone;
    callParam.audio_only            = audioOnlyCall;
    
    if (self.isLogin) {
        callParam.user_id           = self.userId;
    }
    if (self.frtcCallWindowdelegate && [self.frtcCallWindowdelegate respondsToSelector:@selector(makeCall:)]) {
        [self.frtcCallWindowdelegate makeCall:callParam];
    }
    [self close];
}

- (void)onCancelBtnPressed {
    [self close];
}

- (void)dealloc {
    NSLog(@"Frtc Call Window dealloc");
}

#pragma mark -- NSTextField delegate --
- (void)controlTextDidChange:(NSNotification *)obj {
    if(((FrtcDefaultTextField *)(obj.object)).tag == 101) {
        if (self.reminderConferenceTextField.stringValue.length > 0) {
            [self.nameText mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.contentView.mas_centerX);
                make.top.mas_equalTo(self.meetingIDText.mas_bottom).offset(16);
                make.width.mas_equalTo(336);
                make.height.mas_equalTo(40);
            }];
            self.reminderConferenceTextField.hidden = YES;
            self.reminderConferenceImageView.hidden = YES;

            [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
                context.duration = 0.5;
                context.allowsImplicitAnimation = true;
                [self.contentView layoutSubtreeIfNeeded];
            } completionHandler:^{
            }];
        }
    } else if(((FrtcDefaultTextField *)(obj.object)).tag == 102) {
        if (self.reminderUserNameTextField.stringValue.length > 0) {
            [self.micphoneOnOffButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView.mas_left).offset(24);
                make.top.mas_equalTo(self.nameText.mas_bottom).offset(19);
                make.width.mas_greaterThanOrEqualTo(360);
                make.height.mas_greaterThanOrEqualTo(16);
             }];
            self.reminderUserNameTextField.hidden = YES;
            self.reminderUserNameImageView.hidden = YES;

            [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
                context.duration = 0.5;
                context.allowsImplicitAnimation = true;
                [self.contentView layoutSubtreeIfNeeded];
            } completionHandler:^{
            }];
        }
    }
}

#pragma mark --internal function--
- (void)setupCallWindowUI {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.mas_equalTo(self.contentView.mas_centerX);
         make.top.mas_equalTo(self.contentView.mas_top).offset(6);
         make.width.mas_equalTo(204);
         make.height.mas_equalTo(28);
     }];
    
    [self.meetingIDText mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.mas_equalTo(self.contentView.mas_centerX);
         make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(16);
         make.width.mas_equalTo(336);
         make.height.mas_equalTo(40);
     }];
    
    [self.reminderConferenceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(self.contentView.mas_left).offset(24);
         make.top.mas_equalTo(self.meetingIDText.mas_bottom).offset(11);
         make.width.mas_equalTo(12);
         make.height.mas_equalTo(12);
     }];
    
    [self.reminderConferenceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.mas_equalTo(self.reminderConferenceImageView.mas_centerY);
         make.left.mas_equalTo(self.reminderConferenceImageView.mas_right).offset(3);
         make.width.mas_greaterThanOrEqualTo(0);
         make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.meetingIDText.mas_bottom).offset(16);
        make.width.mas_equalTo(336);
        make.height.mas_equalTo(40);
     }];
    
    [self.reminderUserNameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(self.contentView.mas_left).offset(24);
         make.top.mas_equalTo(self.nameText.mas_bottom).offset(11);
         make.width.mas_equalTo(12);
         make.height.mas_equalTo(12);
     }];
    
    [self.reminderUserNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.mas_equalTo(self.reminderUserNameImageView.mas_centerY);
         make.left.mas_equalTo(self.reminderUserNameImageView.mas_right).offset(3);
         make.width.mas_greaterThanOrEqualTo(0);
         make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.micphoneOnOffButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(24);
        make.top.mas_equalTo(self.nameText.mas_bottom).offset(19);
        make.width.mas_greaterThanOrEqualTo(360);
        make.height.mas_greaterThanOrEqualTo(16);
     }];
    
    [self.cameraOnOffButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(24);
        make.top.mas_equalTo(self.micphoneOnOffButton.mas_bottom).offset(16);
        make.width.mas_greaterThanOrEqualTo(360);
        make.height.mas_greaterThanOrEqualTo(16);
     }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(24);
        make.top.mas_equalTo(self.cameraOnOffButton.mas_bottom).offset(15);
        make.width.mas_equalTo(332);
        make.height.mas_equalTo(1);
    }];
    
    [self.audioOnlyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(24);
        make.top.mas_equalTo(self.cameraOnOffButton.mas_bottom).offset(30);
        make.width.mas_greaterThanOrEqualTo(360);
        make.height.mas_greaterThanOrEqualTo(16);
    }];
    
    
    [self.joinMeetingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-24);
        //make.top.mas_equalTo(self.audioOnlyButton.mas_bottom).offset(16);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-24);
        make.width.mas_equalTo(158);
        make.height.mas_equalTo(36);
    }];
    
    [self.cancelMeetingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(24);
        //make.top.mas_equalTo(self.audioOnlyButton.mas_bottom).offset(16);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-24);
        make.width.mas_equalTo(158);
        make.height.mas_equalTo(36);
    }];
}

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
    [self.contentView addSubview:checkButton];
    
    return checkButton;
}

- (void)showWindow {
    self.appDelegate = (AppDelegate*)[NSApplication sharedApplication].delegate;
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
    
    [self.meetingIDText.window makeFirstResponder:nil];
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

- (void)orderOut:(id)sender {
    if(self.frtcCallWindowdelegate && [self.frtcCallWindowdelegate respondsToSelector:@selector(closeWindow)]) {
        [self.frtcCallWindowdelegate closeWindow];
    }
    [super orderOut:sender];
}

#pragma mark --Button Sender--
- (void)onOnlyAudioCall:(NSButton *)sender {
    if(sender.state == NSControlStateValueOn) {
        self.cameraOnOffButton.enabled = NO;
        [self.cameraOnOffButton setState:NSControlStateValueOff];
        [[FrtcUserDefault defaultSingleton] setBoolObject:YES forKey:CALL_MEETING_AUDIO_ONLY  ];
        [self showReminderView: NSLocalizedString(@"FM_AUDIO_ONLY_DESCRIPTION", @"Video and screen sharing don't work")];
    } else {
        self.cameraOnOffButton.enabled = YES;
        [[FrtcUserDefault defaultSingleton] setBoolObject:NO forKey:CALL_MEETING_AUDIO_ONLY  ];
    }
}

- (void)onEnableMicphone:(NSButton *)sender {
    if(sender.state == NSControlStateValueOn) {
        [[FrtcUserDefault defaultSingleton] setBoolObject:YES forKey:CALL_MEETING_MICPHONE_ON_OFF];
    } else {
        [[FrtcUserDefault defaultSingleton] setBoolObject:NO forKey:CALL_MEETING_MICPHONE_ON_OFF];
    }
}

- (void)onEnableCamera:(NSButton *)sender {
    if(sender.state == NSControlStateValueOn) {
        [[FrtcUserDefault defaultSingleton] setBoolObject:YES forKey:CALL_MEETING_CAMERA_ON_OFF];
    } else {
        [[FrtcUserDefault defaultSingleton] setBoolObject:NO forKey:CALL_MEETING_CAMERA_ON_OFF];
    }
}

#pragma mark --lazy load--
- (NSTextField *)titleTextField {
    if (!_titleTextField){
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        //_titleTextField.accessibilityClearButton;
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:18 weight:NSFontWeightMedium];
        //_titleTextField.font = [[NSFontManager sharedFontManager] fontWithFamily:@"PingFangSC-Regular" traits:NSBoldFontMask weight:NSFontWeightMedium size:18];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.stringValue = NSLocalizedString(@"FM_JOIN_MEETING_TITLE", @"Join Meeting");
        [self.contentView addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (FrtcDefaultTextField *)meetingIDText {
    if (!_meetingIDText){
        _meetingIDText = [[FrtcDefaultTextField alloc] initWithFrame:CGRectMake(0, 0, 332, 20)];
        _meetingIDText.delegate = self;
        _meetingIDText.tag = 101;
        _meetingIDText.placeholderString = NSLocalizedString(@"FM_MEETINGID_PLACEHOLDER", @"Please input meeting ID");
        _meetingIDText.layer.borderColor = [NSColor colorWithString:@"#CCCCCC" andAlpha:1.0].CGColor;
        [self.contentView addSubview:_meetingIDText];
    }
    
    return _meetingIDText;
}

- (FrtcDefaultTextField *)nameText {
    if (!_nameText){
        _nameText = [[FrtcDefaultTextField alloc] initWithFrame:CGRectMake(0, 0, 332, 20)];
        _nameText.tag = 102;
        _nameText.delegate = self;
        _nameText.placeholderString = NSLocalizedString(@"FM_PLEASE_NAME", @"Please input your name");
        NumberLimiteFormatter *formatter = [[NumberLimiteFormatter alloc] init];
        [formatter setMaximumLength:48];
        [_nameText setFormatter:formatter];
        _nameText.layer.borderColor = [NSColor colorWithString:@"#CCCCCC" andAlpha:1.0].CGColor;
        [self.contentView addSubview:_nameText];
    }
    
    return _nameText;
}

- (NSButton *)audioOnlyButton {
    if (!_audioOnlyButton) {
        _audioOnlyButton = [self checkButton:NSLocalizedString(@"FM_AUDIO_ONLY", @"audio only") aciton:@selector(onOnlyAudioCall:)];
        
        BOOL withAudioOnly = [[FrtcUserDefault defaultSingleton] boolObjectForKey:CALL_MEETING_AUDIO_ONLY  ];
        if (withAudioOnly) {
            [_audioOnlyButton setState:NSControlStateValueOn];
            self.cameraOnOffButton.enabled = NO;
            [self.cameraOnOffButton setState:NSControlStateValueOff];
        } else {
            [_audioOnlyButton setState:NSControlStateValueOff];
            self.cameraOnOffButton.enabled = YES;
        }
    }
    
    return _audioOnlyButton;
}

- (NSButton *)micphoneOnOffButton {
    if (!_micphoneOnOffButton) {
        _micphoneOnOffButton = [self checkButton:NSLocalizedString(@"FM_JOIN_WITH_MICROPHONE", @"Turn On Microphone") aciton:@selector(onEnableMicphone:)];
        
        BOOL withMic = [[FrtcUserDefault defaultSingleton] boolObjectForKey:CALL_MEETING_MICPHONE_ON_OFF];
        if (withMic) {
            [_micphoneOnOffButton setState:NSControlStateValueOn];
        } else {
            [_micphoneOnOffButton setState:NSControlStateValueOff];
        }
    }
    
    return _micphoneOnOffButton;
}

- (NSButton *)cameraOnOffButton {
    if (!_cameraOnOffButton){
        _cameraOnOffButton = [self checkButton:NSLocalizedString(@"FM_JOIN_WITH_CAMERA", @"Turn On Camera") aciton:@selector(onEnableCamera:)];
        
        BOOL withCamera = [[FrtcUserDefault defaultSingleton] boolObjectForKey:CALL_MEETING_CAMERA_ON_OFF];
        if (withCamera) {
            [_cameraOnOffButton setState:NSControlStateValueOn];
        } else {
            [_cameraOnOffButton setState:NSControlStateValueOff];
        }
    }
    
    return _cameraOnOffButton;
}

- (NSView *)line {
    if(!_line) {
        _line = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
        _line.wantsLayer = YES;
        _line.layer.backgroundColor = [NSColor colorWithString:@"#EEEFF0" andAlpha:1.0].CGColor;
        
        [self.contentView addSubview:_line];
    }
    
    return _line;
}

- (FrtcMultiTypesButton *)joinMeetingButton {
    if (!_joinMeetingButton){
        _joinMeetingButton = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 158, 36) withTitle:NSLocalizedString(@"FM_JOIN_MEETING", @"Join")];
        _joinMeetingButton.target = self;
        _joinMeetingButton.layer.cornerRadius = 4.0;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_JOIN_MEETING", @"Join")];
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
        [_joinMeetingButton setAttributedTitle:attrTitle];
        _joinMeetingButton.action = @selector(onJoinVideoMeetingPressed);
        [self.contentView addSubview:_joinMeetingButton];
    }
    
    return _joinMeetingButton;
}

- (FrtcMultiTypesButton*)cancelMeetingButton {
    if (!_cancelMeetingButton){
        _cancelMeetingButton = [[FrtcMultiTypesButton alloc] initSecondaryWithFrame:CGRectMake(0, 0, 158, 36) withTitle:NSLocalizedString(@"FM_CANCEL", @"Cancel")];
        _cancelMeetingButton.target = self;
        _cancelMeetingButton.hover = NO;
        _cancelMeetingButton.layer.cornerRadius = 4.0;
        _cancelMeetingButton.bordered = NO;
        _cancelMeetingButton.layer.borderWidth = 0.0;
        _cancelMeetingButton.layer.backgroundColor = [NSColor colorWithRed:240/255.0 green:240/255.0 blue:245/255.0 alpha:1.0].CGColor;
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
        [_cancelMeetingButton setAttributedTitle:attrTitle];
        _cancelMeetingButton.action = @selector(onCancelBtnPressed);
        [self.contentView addSubview:_cancelMeetingButton];
    }
    return _cancelMeetingButton;
}

- (FrtcBorderTextField *)reminderConferenceTextField {
    if (!_reminderConferenceTextField) {
        _reminderConferenceTextField = [[FrtcBorderTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _reminderConferenceTextField.backgroundColor = [NSColor clearColor];
        _reminderConferenceTextField.font = [NSFont systemFontOfSize:12 weight:NSFontWeightMedium];
        _reminderConferenceTextField.alignment = NSTextAlignmentLeft;
        _reminderConferenceTextField.textColor = [NSColor colorWithString:@"666666" andAlpha:1.0];
        _reminderConferenceTextField.bordered = NO;
        _reminderConferenceTextField.editable = NO;
        _reminderConferenceTextField.stringValue = NSLocalizedString(@"FM_MEETINDID_ERROR", @"Meeting ID can't be empty");
        _reminderConferenceTextField.hidden = YES;
        [self.contentView addSubview:_reminderConferenceTextField];
    }
    
    return _reminderConferenceTextField;
}

- (NSImageView *)reminderConferenceImageView {
    if (!_reminderConferenceImageView) {
        _reminderConferenceImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        [_reminderConferenceImageView setImage:[NSImage imageNamed:@"icon_reminder"]];
        _reminderConferenceImageView.imageAlignment =  NSImageAlignTopLeft;
        _reminderConferenceImageView.imageScaling =  NSImageScaleAxesIndependently;
        _reminderConferenceImageView.hidden = YES;
        [self.contentView addSubview:_reminderConferenceImageView];
    }
    
    return _reminderConferenceImageView;
}

- (FrtcBorderTextField *)reminderUserNameTextField {
    if (!_reminderUserNameTextField) {
        _reminderUserNameTextField = [[FrtcBorderTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _reminderUserNameTextField.backgroundColor = [NSColor clearColor];
        _reminderUserNameTextField.font = [NSFont systemFontOfSize:12 weight:NSFontWeightMedium];
        _reminderUserNameTextField.alignment = NSTextAlignmentLeft;
        _reminderUserNameTextField.textColor = [NSColor colorWithString:@"666666" andAlpha:1.0];
        _reminderUserNameTextField.bordered = NO;
        _reminderUserNameTextField.editable = NO;
        _reminderUserNameTextField.stringValue = NSLocalizedString(@"FM_DIAPLAYNAME_ERROR", @"Please input your display name");
        _reminderUserNameTextField.hidden = YES;
        [self.contentView addSubview:_reminderUserNameTextField];
    }
    
    return _reminderUserNameTextField;
}

- (NSImageView *)reminderUserNameImageView {
    if (!_reminderUserNameImageView) {
        _reminderUserNameImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        [_reminderUserNameImageView setImage:[NSImage imageNamed:@"icon_reminder"]];
        _reminderUserNameImageView.imageAlignment =  NSImageAlignTopLeft;
        _reminderUserNameImageView.imageScaling =  NSImageScaleAxesIndependently;
        _reminderUserNameImageView.hidden = YES;
        [self.contentView addSubview:_reminderUserNameImageView];
    }
    
    return _reminderUserNameImageView;
}

- (CallResultReminderView *)reminderView {
    if(!_reminderView) {
        _reminderView = [[CallResultReminderView alloc] initWithFrame:CGRectMake(0, 0, 172, 40)];
        _reminderView.tipLabel.stringValue = @"主持人已开启静音";
        _reminderView.hidden = YES;
        
        [self.contentView addSubview:_reminderView];
    }
    
    return _reminderView;
}

- (void)mouseEntered:(NSEvent *)event {
 
}

- (void)mouseExited:(NSEvent *)event {
    
}



@end
