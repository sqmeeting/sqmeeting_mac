#import "AudioSettingView.h"
#import "FrtcPopUpButton.h"
#import "FrtcMultiTypesButton.h"

typedef void (^TestSpeakerHandler)(float meter, BOOL enable);
typedef void (^TestMicphoneHandler)(float meter, BOOL enable);

@interface AudioSettingView ()

@property (nonatomic, strong) NSTextField *speakerTextField;
@property (nonatomic, strong) NSTextField *speakerDescriptionTextField;
@property (nonatomic, strong) FrtcPopUpButton *speakerComboBox;
@property (nonatomic, strong) FrtcMultiTypesButton *testSpeakerButton;
@property (nonatomic, strong) NSTextField *outputLevelTextField;
@property (nonatomic, strong) NSImageView *outputImageView;
@property (nonatomic, strong) NSView      *outputTestView1;
@property (nonatomic, strong) NSView      *outputTestView2;
@property (nonatomic, strong) NSView      *outputTestView3;
@property (nonatomic, strong) NSView      *outputTestView4;
@property (nonatomic, strong) NSView      *outputTestView5;
@property (nonatomic, strong) NSView      *outputTestView6;
@property (nonatomic, strong) NSView      *outputTestView7;
@property (nonatomic, strong) NSView      *outputTestView8;

@property (nonatomic, strong) NSTextField *micphoneTextField;
@property (nonatomic, strong) NSTextField *micphoneDescriptionTextField;
@property (nonatomic, strong) FrtcPopUpButton *micphoneComboBox;
@property (nonatomic, strong) FrtcMultiTypesButton *testMicphoneButton;
@property (nonatomic, strong) NSTextField *inputLevelTextField;
@property (nonatomic, strong) NSImageView *inputImageView;
@property (nonatomic, strong) NSView      *inputTestView1;
@property (nonatomic, strong) NSView      *inputTestView2;
@property (nonatomic, strong) NSView      *inputTestView3;
@property (nonatomic, strong) NSView      *inputTestView4;
@property (nonatomic, strong) NSView      *inputTestView5;
@property (nonatomic, strong) NSView      *inputTestView6;
@property (nonatomic, strong) NSView      *inputTestView7;
@property (nonatomic, strong) NSView      *inputTestView8;

@property (nonatomic, strong) NSButton      *intelligentNoiseReductionBtn;

@property (nonatomic, strong) NSMutableArray<NSView *> *outViewArray;
@property (nonatomic, strong) NSMutableArray<NSView *> *inputViewArray;

@property (nonatomic, assign, getter=isTestingSpeakerEnable)  BOOL testingSpeakerEnable;
@property (nonatomic, assign, getter=isTestingMicphoneEnable) BOOL testingMicphoneEnable;

@property (nonatomic, copy) TestSpeakerHandler speakerHandler;
@property (nonatomic, copy) TestMicphoneHandler micphoneHandler;

@property (nonatomic, copy) NSString *defaultSpeaker;
@property (nonatomic, copy) NSString *defaultMicphone;

@end

@implementation AudioSettingView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)viewWillDraw {
    [super viewWillDraw];
    
//    [self loadVideoDevice];
    [self loadMicDevice];
    [self loadSpeakerDevice];
}

- (instancetype)init {
    self = [super init];
    
    if(self) {
        [self configAudioSettingView];
//        [self addNotification];
//        [self selectLayoutMode];
    
    }
    
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        [self configAudioSettingView];
        [self addNotification];
//        [self selectLayoutMode];
        
        self.outViewArray = [NSMutableArray array];
        [self.outViewArray addObject:self.outputTestView1];
        [self.outViewArray addObject:self.outputTestView2];
        [self.outViewArray addObject:self.outputTestView3];
        [self.outViewArray addObject:self.outputTestView4];
        [self.outViewArray addObject:self.outputTestView5];
        [self.outViewArray addObject:self.outputTestView6];
        [self.outViewArray addObject:self.outputTestView7];
        [self.outViewArray addObject:self.outputTestView8];
    
        self.inputViewArray = [NSMutableArray array];
        [self.inputViewArray addObject:self.inputTestView1];
        [self.inputViewArray addObject:self.inputTestView2];
        [self.inputViewArray addObject:self.inputTestView3];
        [self.inputViewArray addObject:self.inputTestView4];
        [self.inputViewArray addObject:self.inputTestView5];
        [self.inputViewArray addObject:self.inputTestView6];
        [self.inputViewArray addObject:self.inputTestView7];
        [self.inputViewArray addObject:self.inputTestView8];
        
        self.defaultMicphone = [[FrtcUserDefault defaultSingleton] objectForKey:DEFAULT_MICROPHONE];
        self.defaultSpeaker  = [[FrtcUserDefault defaultSingleton] objectForKey:DEFAULT_SPEAKER];
        
        [self testHanler];
    }
    
    return self;
}

- (void)addNotification {
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(onDeviceListChaned:) name:FMeetingDeviceListChangedNotification object:nil];
    [nc addObserver:self selector:@selector(onDisplayChanged:) name:FMeetingDisplayChangedNotification object:nil];
    [nc addObserver:self selector:@selector(onSettingClose:) name:FMeetingSettingViewCloseNotification object:nil];
}

- (void)testHanler {
    __weak __typeof(self)weakSelf = self;
    
    self.micphoneHandler = ^void(float meter, BOOL enable) {
        NSLog(@"The float value is %f", meter);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if(!enable) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1");
                [strongSelf recoverInputColor];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf updateInputViewColorWithMeter:meter];
            });
        }
    };
    
    self.speakerHandler = ^void(float meter, BOOL enable) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if(enable) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf updateOutputViewColorWithMeter:meter];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf recoverOutputColor];
            });
        }
    };
}

- (void)recoverOutputColor {
    for(int i = 0; i < 8; i++) {
        NSView *view = self.outViewArray[i];
        view.wantsLayer = YES;
        view.layer.backgroundColor = [NSColor colorWithString:@"#EAEAF0" andAlpha:1.0].CGColor;
    }
}

- (void)recoverInputColor {
    for(int i = 0; i < 8; i++) {
        NSView *view = self.inputViewArray[i];
        view.wantsLayer = YES;
        view.layer.backgroundColor = [NSColor colorWithString:@"#EAEAF0" andAlpha:1.0].CGColor;
    }
}

- (void)updateOutputViewColor:(int)number {
    for (int i = 0; i < number; i++) {
        NSView *view = self.outViewArray[i];
        view.wantsLayer = YES;
        view.layer.backgroundColor = [NSColor colorWithString:@"#0FD152" andAlpha:1.0].CGColor;
    }
}

- (void)updateOutputViewColorWithMeter:(float)meter {
    [self recoverOutputColor];
    if(meter > 0 && meter <= 0.125) {
        [self updateOutputViewColor:1];
        
    } else if(meter > 0.125 && meter <= 0.25) {
        [self updateOutputViewColor:2];
    } else if(meter > 0.25  && meter <= 0.375) {
        [self updateOutputViewColor:3];
    } else if(meter > 0.375 && meter <= 0.5 ) {
        [self updateOutputViewColor:4];
    } else if(meter > 0.5   && meter <= 0.625) {
        [self updateOutputViewColor:5];
    } else if(meter > 0.625 && meter <= 0.75) {
        [self updateOutputViewColor:6];
    } else if(meter > 0.75  && meter <= 0.875) {
        [self updateOutputViewColor:7];
    } else if(meter > 0.875 && meter <= 1) {
        [self updateOutputViewColor:8];
    }
}

- (void)updateInputViewColor:(int)number {
    for (int i = 0; i < number; i++) {
        NSView *view = self.inputViewArray[i];
        view.wantsLayer = YES;
        view.layer.backgroundColor = [NSColor colorWithString:@"#0FD152" andAlpha:1.0].CGColor;
    }
}

- (void)updateInputViewColorWithMeter:(float)meter {
    [self recoverInputColor];
    if(meter > 0.005 && meter <= 0.125) {
        [self updateInputViewColor:1];
        
    } else if(meter > 0.125 && meter <= 0.25) {
        [self updateInputViewColor:2];
    } else if(meter > 0.25  && meter <= 0.375) {
        [self updateInputViewColor:3];
    } else if(meter > 0.375 && meter <= 0.5 ) {
        [self updateInputViewColor:4];
    } else if(meter > 0.5   && meter <= 0.625) {
        [self updateInputViewColor:5];
    } else if(meter > 0.625 && meter <= 0.75) {
        [self updateInputViewColor:6];
    } else if(meter > 0.75  && meter <= 0.875) {
        [self updateInputViewColor:7];
    } else if(meter > 0.875 && meter <= 1) {
        [self updateInputViewColor:8];
    }
}

#pragma mark -- notification
- (void)onDeviceListChaned:(NSNotification *)notification {
    NSLog(@"-------- (void)onDeviceListChaned:(NSNotification *)notification-----");
    NSDictionary *userInfo = notification.userInfo;
    NSDictionary *inUseDev = [userInfo valueForKey:FMeetingDeviceListInUseKey];
//    NSString *inuseMic = [inUseDev valueForKey:@"micphone"];
//    NSString *inuseSpk = [inUseDev valueForKey:@"speaker"];
    
    NSString *defaultMicName = [inUseDev valueForKey:@"defaultMicName"];
    NSString *defaultSpeakerName = [inUseDev valueForKey:@"defaultSpeakerName"];
    
//    [[FrtcUserDefault defaultSingleton] setObject:inuseMic forKey:DEFAULT_MICROPHONE];
//    [[FrtcUserDefault defaultSingleton] setObject:inuseSpk forKey:DEFAULT_SPEAKER];
    
    [[FrtcUserDefault defaultSingleton] setObject:defaultMicName forKey:DEFAULT_MICROPHONE];
    NSLog(@"[onDeviceListChaned]The default speaker name is %@", defaultSpeakerName);
    [[FrtcUserDefault defaultSingleton] setObject:defaultSpeakerName forKey:DEFAULT_SPEAKER];

    [self loadMicDevice];
    [self loadSpeakerDevice];
}

- (void)onDisplayChanged:(NSNotification *)notification {
    [self loadMicDevice];
    [self loadSpeakerDevice];
}

- (void)onSettingClose:(NSNotification *)notification {
    [self isTestingSpeaker];
    [self isTestingMicphone];
}

- (void)configAudioSettingView {
    [self.speakerTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(23);
        make.left.mas_equalTo(24);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.speakerDescriptionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.speakerTextField.mas_right).offset(8);
        make.centerY.mas_equalTo(self.speakerTextField.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.speakerComboBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.speakerTextField.mas_bottom).offset(12);
        make.width.mas_equalTo(299);
        make.height.mas_equalTo(32);
     }];
    
    [self.testSpeakerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.speakerComboBox.mas_right).offset(8);
        make.centerY.mas_equalTo(self.speakerComboBox.mas_centerY);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(32);
     }];
    
    [self.outputLevelTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.speakerComboBox.mas_bottom).offset(20);
        make.left.mas_equalTo(24);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.outputImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.outputLevelTextField.mas_right).offset(10);
        make.centerY.mas_equalTo(self.outputLevelTextField.mas_centerY);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    
    [self.outputTestView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.outputImageView.mas_right).offset(11);
        make.centerY.mas_equalTo(self.outputLevelTextField.mas_centerY);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(8);
    }];
    
    [self.outputTestView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.outputTestView1.mas_right).offset(8);
        make.centerY.mas_equalTo(self.outputLevelTextField.mas_centerY);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(8);
    }];
    
    [self.outputTestView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.outputTestView2.mas_right).offset(8);
        make.centerY.mas_equalTo(self.outputLevelTextField.mas_centerY);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(8);
    }];
    
    [self.outputTestView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.outputTestView3.mas_right).offset(8);
        make.centerY.mas_equalTo(self.outputLevelTextField.mas_centerY);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(8);
    }];
    
    [self.outputTestView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.outputTestView4.mas_right).offset(8);
        make.centerY.mas_equalTo(self.outputLevelTextField.mas_centerY);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(8);
    }];
    
    [self.outputTestView6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.outputTestView5.mas_right).offset(8);
        make.centerY.mas_equalTo(self.outputLevelTextField.mas_centerY);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(8);
    }];
    
    [self.outputTestView7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.outputTestView6.mas_right).offset(8);
        make.centerY.mas_equalTo(self.outputLevelTextField.mas_centerY);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(8);
    }];
    
    [self.outputTestView8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.outputTestView7.mas_right).offset(8);
        make.centerY.mas_equalTo(self.outputLevelTextField.mas_centerY);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(8);
    }];
    
    [self.micphoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.outputLevelTextField.mas_bottom).offset(32);
        make.left.mas_equalTo(24);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.micphoneDescriptionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.micphoneTextField.mas_right).offset(8);
        make.centerY.mas_equalTo(self.micphoneTextField.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.micphoneComboBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(self.micphoneTextField.mas_bottom).offset(12);
        make.width.mas_equalTo(299);
        make.height.mas_equalTo(32);
    }];
    
    [self.testMicphoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.micphoneComboBox.mas_right).offset(8);
        make.centerY.mas_equalTo(self.micphoneComboBox.mas_centerY);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(32);
    }];
    
    [self.inputLevelTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.micphoneComboBox.mas_bottom).offset(20);
        make.left.mas_equalTo(24);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.inputImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inputLevelTextField.mas_right).offset(10);
        make.centerY.mas_equalTo(self.inputLevelTextField.mas_centerY);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    
    [self.inputTestView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inputImageView.mas_right).offset(11);
        make.centerY.mas_equalTo(self.inputLevelTextField.mas_centerY);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(8);
    }];
    
    [self.inputTestView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inputTestView1.mas_right).offset(8);
        make.centerY.mas_equalTo(self.inputLevelTextField.mas_centerY);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(8);
    }];
    
    [self.inputTestView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inputTestView2.mas_right).offset(8);
        make.centerY.mas_equalTo(self.inputLevelTextField.mas_centerY);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(8);
    }];
    
    [self.inputTestView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inputTestView3.mas_right).offset(8);
        make.centerY.mas_equalTo(self.inputLevelTextField.mas_centerY);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(8);
    }];
    
    [self.inputTestView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inputTestView4.mas_right).offset(8);
        make.centerY.mas_equalTo(self.inputLevelTextField.mas_centerY);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(8);
    }];
    
    [self.inputTestView6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inputTestView5.mas_right).offset(8);
        make.centerY.mas_equalTo(self.inputLevelTextField.mas_centerY);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(8);
    }];
    
    [self.inputTestView7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inputTestView6.mas_right).offset(8);
        make.centerY.mas_equalTo(self.inputLevelTextField.mas_centerY);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(8);
    }];
    
    [self.inputTestView8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.inputTestView7.mas_right).offset(8);
        make.centerY.mas_equalTo(self.inputLevelTextField.mas_centerY);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(8);
    }];
    
    [self.intelligentNoiseReductionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.inputLevelTextField.mas_bottom).offset(42);
        make.left.mas_equalTo(26);
        make.width.mas_greaterThanOrEqualTo(360);
        make.height.mas_greaterThanOrEqualTo(16);
     }];
}

- (void)isTestingSpeaker {
    if(self.isTestingSpeakerEnable) {
        NSMutableAttributedString *attrTitle = [self buttonString:NSLocalizedString(@"FM_SPEAKER_TEST", @"Test") withTitleColor:[NSColor colorWithString:@"#222222" andAlpha:1.0]];
        [self.testSpeakerButton setAttributedTitle:attrTitle];
        self.testSpeakerButton.state = NSControlStateValueOff;
        
        [self recoverOutputColor];
        [[FrtcCall sharedFrtcCall] testSpeaker:NO withHandler:self.speakerHandler];
    }
}

- (void)isTestingMicphone {
    if(self.isTestingMicphoneEnable) {
        [[FrtcCall sharedFrtcCall] testMicphone:NO withHandler:self.micphoneHandler];

        NSMutableAttributedString *attrTitle = [self buttonString:NSLocalizedString(@"FM_MICPHONE_TEST", @"Test") withTitleColor:[NSColor colorWithString:@"#222222" andAlpha:1.0]];
        [self.testMicphoneButton setAttributedTitle:attrTitle];
        self.testMicphoneButton.state = NSControlStateValueOff;

        [self recoverInputColor];
    }
}

- (void)stopTest {
    [self isTestingSpeaker];
    [self isTestingMicphone];
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if(hidden) {
        [self stopTest];
    } else {
        
    }
}
#pragma mark -- FrtcMultiTypesButton Sender --
- (void)onTestMicBtnPressed {
    [self isTestingSpeaker];
    
    if(self.testMicphoneButton.state == NSControlStateValueOn) {
        NSMutableAttributedString *attrTitle = [self buttonString:NSLocalizedString(@"FM_STOP_TEST", @"Stop Test") withTitleColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0]];
        [self.testMicphoneButton setAttributedTitle:attrTitle];
        self.testingMicphoneEnable = YES;
    } else {
        NSMutableAttributedString *attrTitle = [self buttonString:NSLocalizedString(@"FM_MICPHONE_TEST", @"Test") withTitleColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0]];
        [self.testMicphoneButton setAttributedTitle:attrTitle];
        self.testingMicphoneEnable = NO;
        [self recoverInputColor];
    }
    
    [[FrtcCall sharedFrtcCall] testMicphone:self.isTestingMicphoneEnable withHandler:self.micphoneHandler];
}

- (void)onTestSpeakerBtnPressed {
    [self isTestingMicphone];
    
    if(self.testSpeakerButton.state == NSControlStateValueOn) {
        NSMutableAttributedString *attrTitle = [self buttonString:NSLocalizedString(@"FM_STOP_TEST", @"Stop Test") withTitleColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0]];
        [self.testSpeakerButton setAttributedTitle:attrTitle];
        self.testingSpeakerEnable = YES;
    } else {
        NSMutableAttributedString *attrTitle = [self buttonString:NSLocalizedString(@"FM_SPEAKER_TEST", @"Test") withTitleColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0]];
        [self.testSpeakerButton setAttributedTitle:attrTitle];
        self.testingSpeakerEnable = NO;
        
        [self recoverOutputColor];
    }
    
    [[FrtcCall sharedFrtcCall] testSpeaker:self.isTestingSpeakerEnable withHandler:self.speakerHandler];
}

#pragma mark -- popbutton select changed handler
- (void)onMicPhoneListSelChange {
    NSString *title = [self.micphoneComboBox titleOfSelectedItem];
    [[FrtcUserDefault defaultSingleton] setObject:title forKey:DEFAULT_MICROPHONE];
    [[FrtcCall sharedFrtcCall] frtcSelectMic:title];
    
    if(![self.defaultMicphone isEqualToString:title]) {
        [self isTestingMicphone];
        self.defaultMicphone = title;
    }
}

- (void)onSpeakerListSelChange {
    NSString *title = [self.speakerComboBox titleOfSelectedItem];
    NSLog(@"[onSpeakerListSelChange], the title is %@", title);
    [[FrtcUserDefault defaultSingleton] setObject:title forKey:DEFAULT_SPEAKER];
    [[FrtcCall sharedFrtcCall] frtcSelectSpeaker:title];
    
    if(![self.defaultSpeaker isEqualToString:title]) {
        [self isTestingSpeaker];
        self.defaultSpeaker = title;
    }
}

- (void)onNoiseBlockerBtnPressed:(NSButton *)sender {
    if(sender.state == NSControlStateValueOn) {
        [[FrtcCall sharedFrtcCall] frtcEnableNoiseBlocker:YES];
        [[FrtcUserDefault defaultSingleton] setBoolObject:YES forKey:INTELLIGENG_NOISE_REDUCTION];
    } else {
        [[FrtcCall sharedFrtcCall] frtcEnableNoiseBlocker:NO];
        [[FrtcUserDefault defaultSingleton] setBoolObject:NO forKey:INTELLIGENG_NOISE_REDUCTION];
    }
}

- (void)loadSpeakerDevice {
    NSLog(@"-------- loadSpeakerDevice-----");
    NSString *defaultSpk = [[FrtcUserDefault defaultSingleton] objectForKey:DEFAULT_SPEAKER];
    NSLog(@"[loadSpeakerDevice]The default speaker name is %@", defaultSpk);
    NSString* curSel = [self.speakerComboBox titleOfSelectedItem];
    
    NSLog(@"The defaulet speaker is %@, the current speaker is %@", defaultSpk, curSel);
    
    NSMutableArray* list = [[NSMutableArray alloc ] init];

    [[FrtcCall sharedFrtcCall] frtcSpeakerList:list];

    [self.speakerComboBox removeAllItems];
    
    BOOL found = NO;
    for (NSMutableDictionary *deviceInfo in list) {
        NSString *devName = [deviceInfo valueForKey:@"name"];
        NSLog(@"The devName is %@", devName);
        [[self speakerComboBox] addItemWithTitle:devName];
        if ([defaultSpk isEqualToString:devName]){
            found = YES;
            NSLog(@"can find the default speaker in deviceInfo");
        }
    }

    NSColor *textColor = [[FrtcBaseImplement baseImpleSingleton] baseColor];
    NSArray *itemArray = [self.speakerComboBox itemArray];
    int i = 0;
    NSDictionary *attributes = [NSDictionary
                                dictionaryWithObjectsAndKeys:
                                textColor, NSForegroundColorAttributeName,
                                [NSFont systemFontOfSize: [NSFont systemFontSize]],
                                NSFontAttributeName, nil];

    for (i = 0; i < [itemArray count]; i++) {
        NSMenuItem *item = [itemArray objectAtIndex:i];

        NSAttributedString *as = [[NSAttributedString alloc]
                 initWithString:[item title]
                 attributes:attributes];

        [item setAttributedTitle:as];
    }
    
    if (found) {
        NSLog(@"Found the device");
        NSInteger index = [self.speakerComboBox indexOfItemWithTitle:defaultSpk];
        NSLog(@"The index is %ld", index);
        [self.speakerComboBox selectItemAtIndex:index];
        [self onSpeakerListSelChange];
    } else if(curSel) {
        NSInteger index = [self.speakerComboBox indexOfItemWithTitle:curSel];
        if(index != -1) {
            NSLog(@"The index == -1");
            [self.speakerComboBox selectItemAtIndex:index];
        } else{
            for (NSMutableDictionary *speakerInfo  in list) {
                NSString *devType = [speakerInfo valueForKey:@"transportType"];
                if ([devType isEqualToString:FMeetingAudioDeviceTransportTypeBuiltIn]) {
                    NSString *devName = [speakerInfo valueForKey:@"name"];
                    NSLog(@"The FMeetingAudioDeviceTransportTypeBuiltIn devName is %@", devName);
                    NSInteger index = [self.speakerComboBox indexOfItemWithTitle:devName];
                    [self.speakerComboBox selectItemAtIndex:index];
                    [self onSpeakerListSelChange];
                    break;
                }
            }
        }
    }
}

- (void)loadMicDevice {
    NSString *defaultMic = [[FrtcUserDefault defaultSingleton] objectForKey:DEFAULT_MICROPHONE];
    NSString* curSel = [self.micphoneComboBox titleOfSelectedItem];
    
    NSMutableArray* micList = [[NSMutableArray alloc ] init];
    [[FrtcCall sharedFrtcCall] frtcMicphoneList:micList];
    
    [self.micphoneComboBox removeAllItems];
    
    BOOL found = NO;
    for (NSMutableDictionary *deviceInfo in micList) {
        NSString *devName = [deviceInfo valueForKey:@"name"];
        [[self micphoneComboBox] addItemWithTitle:devName];
        if ([defaultMic isEqualToString:devName]){
            found = YES;
        }
    }
    
    
    NSColor *textColor = [[FrtcBaseImplement baseImpleSingleton] baseColor];
    NSArray *itemArray = [self.micphoneComboBox itemArray];
    int i = 0;
    NSDictionary *attributes = [NSDictionary
                                dictionaryWithObjectsAndKeys:
                                textColor, NSForegroundColorAttributeName,
                                [NSFont systemFontOfSize: [NSFont systemFontSize]],
                                NSFontAttributeName, nil];

    for (i = 0; i < [itemArray count]; i++) {
        NSMenuItem *item = [itemArray objectAtIndex:i];

        NSAttributedString *as = [[NSAttributedString alloc]
                 initWithString:[item title]
                 attributes:attributes];

        [item setAttributedTitle:as];
    }
    
    if (found/*[defaultMic length] > 0*/){
        NSInteger index = [self.micphoneComboBox indexOfItemWithTitle:defaultMic];
        [self.micphoneComboBox selectItemAtIndex:index];
        [self onMicPhoneListSelChange];
    } else if(curSel) {
        NSInteger index = [self.micphoneComboBox indexOfItemWithTitle:curSel];
        if(index != -1) {
            [self.micphoneComboBox selectItemAtIndex:index];
        } else {
            for (NSMutableDictionary *micInfo  in micList) {
                NSString *devType = [micInfo valueForKey:@"transportType"];
                
                if ([devType isEqualToString:FMeetingAudioDeviceTransportTypeBuiltIn]){
                    NSString *devName = [micInfo valueForKey:@"name"];
                    NSInteger index = [self.micphoneComboBox indexOfItemWithTitle:devName];
                    [self.micphoneComboBox selectItemAtIndex:index];
                    [self onMicPhoneListSelChange];
                    break;
                }
            }
        }
    }
}

- (NSMutableAttributedString *)buttonString:(NSString *)title withTitleColor:(NSColor *)color {
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:title];
    NSUInteger len = [attrTitle length];
    NSRange range = NSMakeRange(0, len);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attrTitle addAttribute:NSForegroundColorAttributeName value:color
                      range:range];
    [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                      range:range];
    
    [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                      range:range];
    [attrTitle fixAttributesInRange:range];
    
    return attrTitle;
}


- (NSTextField *)speakerTextField {
    if (!_speakerTextField) {
        _speakerTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _speakerTextField.bordered = NO;
        _speakerTextField.drawsBackground = NO;
        _speakerTextField.backgroundColor = [NSColor clearColor];
        _speakerTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _speakerTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightSemibold];
        _speakerTextField.alignment = NSTextAlignmentLeft;
        _speakerTextField.maximumNumberOfLines = 0;
        _speakerTextField.editable = NO;
        _speakerTextField.stringValue = NSLocalizedString(@"FM_SPEAKER", @"Speaker");
        [self addSubview:_speakerTextField];
    }
    
    return _speakerTextField;
}

- (NSTextField *)speakerDescriptionTextField {
    if (!_speakerDescriptionTextField) {
        _speakerDescriptionTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _speakerDescriptionTextField.bordered = NO;
        _speakerDescriptionTextField.drawsBackground = NO;
        _speakerDescriptionTextField.backgroundColor = [NSColor clearColor];
        _speakerDescriptionTextField.textColor = [NSColor colorWithString:@"#999999" andAlpha:1.0];
        _speakerDescriptionTextField.font = [NSFont systemFontOfSize:12 weight:NSFontWeightRegular];
        _speakerDescriptionTextField.alignment = NSTextAlignmentLeft;
        _speakerDescriptionTextField.maximumNumberOfLines = 2;
        _speakerDescriptionTextField.editable = NO;
        _speakerDescriptionTextField.stringValue = NSLocalizedString(@"FM_SPEAKER_DESCRIPTION", @"Test it to make sure you can hear others.");
       
        [self addSubview:_speakerDescriptionTextField];
    }
    
    return _speakerDescriptionTextField;
}

- (FrtcPopUpButton *)speakerComboBox {
    if (!_speakerComboBox) {
        _speakerComboBox = [[FrtcPopUpButton alloc] init];
        [_speakerComboBox setFontWithString:@"222222" alpha:1 size:14 andType:SFProDisplayRegular];
        [_speakerComboBox setTarget:self];
        [_speakerComboBox setAction:@selector(onSpeakerListSelChange)];
        [self addSubview:_speakerComboBox];
    }
    
    return  _speakerComboBox;
}

- (FrtcMultiTypesButton *)testSpeakerButton {
    if (!_testSpeakerButton) {
        _testSpeakerButton = [[FrtcMultiTypesButton alloc] initEightWithFrame:CGRectMake(0, 0, 0, 0) withTitle:NSLocalizedString(@"FM_SPEAKER_TEST", @"Test")];
        _testSpeakerButton.target = self;
        _testSpeakerButton.action = @selector(onTestSpeakerBtnPressed);
        
        [self addSubview:_testSpeakerButton];
    }
    
    return _testSpeakerButton;
}

- (NSTextField *)outputLevelTextField {
    if (!_outputLevelTextField) {
        _outputLevelTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _outputLevelTextField.bordered = NO;
        _outputLevelTextField.drawsBackground = NO;
        _outputLevelTextField.backgroundColor = [NSColor clearColor];
        _outputLevelTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _outputLevelTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightRegular];
        _outputLevelTextField.alignment = NSTextAlignmentLeft;
        _outputLevelTextField.maximumNumberOfLines = 0;
        _outputLevelTextField.editable = NO;
        _outputLevelTextField.stringValue = NSLocalizedString(@"FM_OUTPUT_LEVEL", @"Output");
       
        [self addSubview:_outputLevelTextField];
    }
    
    return _outputLevelTextField;
}

- (NSImageView *)outputImageView {
    if (!_outputImageView){
        _outputImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        [_outputImageView setImage:[NSImage imageNamed:@"icon_output_level"]];
        _outputImageView.imageAlignment = NSImageAlignTopLeft;
        _outputImageView.imageScaling = NSImageScaleAxesIndependently;
        [self addSubview:_outputImageView];
    }
    
    return _outputImageView;
}

- (NSView *)outputTestView1 {
    if(!_outputTestView1) {
        _outputTestView1 = [self testView];
        [self addSubview:_outputTestView1];
    }
    
    return _outputTestView1;
}

- (NSView *)outputTestView2 {
    if(!_outputTestView2) {
        _outputTestView2 = [self testView];
        [self addSubview:_outputTestView2];
    }
    
    return _outputTestView2;
}

- (NSView *)outputTestView3 {
    if(!_outputTestView3) {
        _outputTestView3 = [self testView];
        [self addSubview:_outputTestView3];
    }
    
    return _outputTestView3;
}

- (NSView *)outputTestView4 {
    if(!_outputTestView4) {
        _outputTestView4 = [self testView];
        [self addSubview:_outputTestView4];
    }
    
    return _outputTestView4;
}

- (NSView *)outputTestView5 {
    if(!_outputTestView5) {
        _outputTestView5 = [self testView];
        [self addSubview:_outputTestView5];
    }
    
    return _outputTestView5;
    
}

- (NSView *)outputTestView6 {
    if(!_outputTestView6) {
        _outputTestView6 = [self testView];
        [self addSubview:_outputTestView6];
    }
    
    return _outputTestView6;
}

- (NSView *)outputTestView7 {
    if(!_outputTestView7) {
        _outputTestView7 = [self testView];
        [self addSubview:_outputTestView7];
    }
    
    return _outputTestView7;
}

- (NSView *)outputTestView8 {
    if(!_outputTestView8) {
        _outputTestView8 = [self testView];
        [self addSubview:_outputTestView8];
    }
    
    return _outputTestView8;
}

- (NSView *)inputTestView1 {
    if(!_inputTestView1) {
        _inputTestView1 = [self testView];
        [self addSubview:_inputTestView1];
    }
    
    return _inputTestView1;
}

- (NSView *)inputTestView2 {
    if(!_inputTestView2) {
        _inputTestView2 = [self testView];
        [self addSubview:_inputTestView2];
    }
    
    return _inputTestView2;
}

- (NSView *)inputTestView3 {
    if(!_inputTestView3) {
        _inputTestView3 = [self testView];
        [self addSubview:_inputTestView3];
    }
    
    return _inputTestView3;
}

- (NSView *)inputTestView4 {
    if(!_inputTestView4) {
        _inputTestView4 = [self testView];
        [self addSubview:_inputTestView4];
    }
    
    return _inputTestView4;
}

- (NSView *)inputTestView5 {
    if(!_inputTestView5) {
        _inputTestView5 = [self testView];
        [self addSubview:_inputTestView5];
    }
    
    return _inputTestView5;
    
}

- (NSView *)inputTestView6 {
    if(!_inputTestView6) {
        _inputTestView6 = [self testView];
        [self addSubview:_inputTestView6];
    }
    
    return _inputTestView6;
}

- (NSView *)inputTestView7 {
    if(!_inputTestView7) {
        _inputTestView7 = [self testView];
        [self addSubview:_inputTestView7];
    }
    
    return _inputTestView7;
}

- (NSView *)inputTestView8 {
    if(!_inputTestView8) {
        _inputTestView8 = [self testView];
        [self addSubview:_inputTestView8];
    }
    
    return _inputTestView8;
}


- (NSView *)testView {
    NSView *testView = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 32, 8)];
    testView.wantsLayer = YES;
    testView.layer.backgroundColor = [NSColor colorWithString:@"#EAEAF0" andAlpha:1.0].CGColor;
    testView.layer.masksToBounds = YES;
    testView.layer.cornerRadius = 1.0;
    
    return testView;
}

- (NSTextField *)micphoneTextField {
    if (!_micphoneTextField) {
        _micphoneTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _micphoneTextField.bordered = NO;
        _micphoneTextField.drawsBackground = NO;
        _micphoneTextField.backgroundColor = [NSColor clearColor];
        _micphoneTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _micphoneTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightSemibold];
        _micphoneTextField.alignment = NSTextAlignmentLeft;
        _micphoneTextField.maximumNumberOfLines = 0;
        _micphoneTextField.editable = NO;
        _micphoneTextField.stringValue = NSLocalizedString(@"FM_MICROPHONE", @"Microphone");
        [self addSubview:_micphoneTextField];
    }
    
    return _micphoneTextField;
}

- (NSTextField *)micphoneDescriptionTextField {
    if (!_micphoneDescriptionTextField) {
        _micphoneDescriptionTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _micphoneDescriptionTextField.bordered = NO;
        _micphoneDescriptionTextField.drawsBackground = NO;
        _micphoneDescriptionTextField.backgroundColor = [NSColor clearColor];
        _micphoneDescriptionTextField.textColor = [NSColor colorWithString:@"#999999" andAlpha:1.0];
        _micphoneDescriptionTextField.font = [NSFont systemFontOfSize:12 weight:NSFontWeightRegular];
        _micphoneDescriptionTextField.alignment = NSTextAlignmentLeft;
        _micphoneDescriptionTextField.maximumNumberOfLines = 2;
        _micphoneDescriptionTextField.editable = NO;
        _micphoneDescriptionTextField.stringValue = NSLocalizedString(@"FM_MICPHONE_DESCRIPTION", @"Test it to make sure others can hear you.");
       
        [self addSubview:_micphoneDescriptionTextField];
    }
    
    return _micphoneDescriptionTextField;
}

- (FrtcPopUpButton *)micphoneComboBox {
    if (!_micphoneComboBox) {
        _micphoneComboBox = [[FrtcPopUpButton alloc] init];
        [_micphoneComboBox setFontWithString:@"222222" alpha:1 size:14 andType:SFProDisplayRegular];
        [_micphoneComboBox setTarget:self];
        [_micphoneComboBox setAction:@selector(onMicPhoneListSelChange)];
        [self addSubview:_micphoneComboBox];
    }
    
    return  _micphoneComboBox;
}

- (FrtcMultiTypesButton *)testMicphoneButton {
    if (!_testMicphoneButton) {
        _testMicphoneButton = [[FrtcMultiTypesButton alloc] initEightWithFrame:CGRectMake(0, 0, 0, 0) withTitle:NSLocalizedString(@"FM_MICPHONE_TEST", @"Test")];
        _testMicphoneButton.target = self;
        _testMicphoneButton.action = @selector(onTestMicBtnPressed);
        
        [self addSubview:_testMicphoneButton];
    }
    
    return _testMicphoneButton;
}

- (NSTextField *)inputLevelTextField {
    if (!_inputLevelTextField) {
        _inputLevelTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _inputLevelTextField.bordered = NO;
        _inputLevelTextField.drawsBackground = NO;
        _inputLevelTextField.backgroundColor = [NSColor clearColor];
        _inputLevelTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _inputLevelTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightRegular];
        _inputLevelTextField.alignment = NSTextAlignmentLeft;
        _inputLevelTextField.maximumNumberOfLines = 0;
        _inputLevelTextField.editable = NO;
        _inputLevelTextField.stringValue = NSLocalizedString(@"FM_INPUT_LEVEL", @"Input");
       
        [self addSubview:_inputLevelTextField];
    }
    
    return _inputLevelTextField;
}

- (NSImageView *)inputImageView {
    if (!_inputImageView){
        _inputImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        [_inputImageView setImage:[NSImage imageNamed:@"icon_input_level"]];
        _inputImageView.imageAlignment = NSImageAlignTopLeft;
        _inputImageView.imageScaling = NSImageScaleAxesIndependently;
        [self addSubview:_inputImageView];
    }
    
    return _inputImageView;
}

- (NSButton *)intelligentNoiseReductionBtn {
    if (!_intelligentNoiseReductionBtn) {
        _intelligentNoiseReductionBtn = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, 36, 16)];
        [_intelligentNoiseReductionBtn setButtonType:NSButtonTypeSwitch];
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_NOISE_BLOCKER", @"Intelligent Noise Reduction")];
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
        [_intelligentNoiseReductionBtn setAttributedTitle:attrTitle];
        attrTitle = nil;
        [_intelligentNoiseReductionBtn setNeedsDisplay:YES];
        
        BOOL enableNB = [[FrtcUserDefault defaultSingleton] boolObjectForKey:INTELLIGENG_NOISE_REDUCTION];
        if (enableNB) {
            [_intelligentNoiseReductionBtn setState:NSControlStateValueOn];
        } else {
            [_intelligentNoiseReductionBtn setState:NSControlStateValueOff];
        }
        
        _intelligentNoiseReductionBtn.target = self;
        _intelligentNoiseReductionBtn.action = @selector(onNoiseBlockerBtnPressed:);
        [self addSubview:_intelligentNoiseReductionBtn];
    }
    
    return _intelligentNoiseReductionBtn;
}

@end
