#import "MediaSettingView.h"
#import "FrtcUserDefault.h"
#import "FrtcBaseImplement.h"
#import "FrtcPopUpButton.h"
#import "FrtcCall.h"
#import "FMLanguageConfig.h"

#import <AVFoundation/AVFoundation.h>

@interface MediaSettingView ()

@property (nonatomic, strong) FrtcPopUpButton *cameraComboBox;

@property (nonatomic, strong) FrtcPopUpButton *micphoneComboBox;

@property (nonatomic, strong) FrtcPopUpButton *speakerComboBox;

@property (nonatomic, strong) FrtcPopUpButton *videoLayoutCombox;

@property (nonatomic, strong) NSTextField   *cameraLabel;

@property (nonatomic, strong) NSTextField   *micphoneLabel;

@property (nonatomic, strong) NSTextField   *speakerLabel;

@property (nonatomic, strong) NSTextField   *videoLayoutLabel;

@property (nonatomic, strong) NSButton      *intelligentNoiseReductionBtn;

@property (nonatomic, strong) FrtcPopUpButton *modeSelectButton;


@end

@implementation MediaSettingView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)viewWillDraw {
    [super viewWillDraw];
    
    [self loadVideoDevice];
    [self loadMicDevice];
    [self loadSpeakerDevice];
}

- (instancetype)init {
    self = [super init];
    
    if(self) {
        [self configMediaView];
        [self addNotification];
        [self selectLayoutMode];
    }
    
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        [self configMediaView];
        [self addNotification];
        [self selectLayoutMode];
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"------MediaSettingView dealloc------");
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addNotification {
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(onDeviceListChaned:) name:FMeetingDeviceListChangedNotification object:nil];
    [nc addObserver:self selector:@selector(onDisplayChanged:) name:FMeetingDisplayChangedNotification object:nil];
}

- (void)selectLayoutMode {
    NSString *layoutMode = [[FrtcUserDefault defaultSingleton] objectForKey:DEFAULT_LAYOUT];
    if([layoutMode isEqualToString:@"gallery"]) {
        [self.videoLayoutCombox selectItemAtIndex:1];
    } else {
        [self.videoLayoutCombox selectItemAtIndex:0];
    }
}

- (CGFloat)distance {
    NSString * language = [FMLanguageConfig userLanguage] ? : [NSLocale preferredLanguages].firstObject;
    
    if([language hasPrefix:@"en"]) {
        return 115.0;
    } else {
        return 88.0;
    }
}

- (void)loadVideoDevice {
    NSString *defaultCamera = [[FrtcUserDefault defaultSingleton] objectForKey:DEFAULT_CAMERA];
    NSString* curSel = [self.cameraComboBox titleOfSelectedItem];
    
    NSMutableArray* camList = [[NSMutableArray alloc ] init];
    [[FrtcCall sharedFrtcCall] frtcCameraList:camList];

    [self.cameraComboBox removeAllItems];

    BOOL found = NO;
    for (NSMutableDictionary *deviceInfo  in camList) {
        NSString *devName = [deviceInfo valueForKey:@"name"];
        [[self cameraComboBox] addItemWithTitle:devName];
        if ([defaultCamera isEqualToString:devName]) {
            found = YES;
        }
    }
    
    NSColor *textColor = [[FrtcBaseImplement baseImpleSingleton] baseColor];;
    NSArray *itemArray = [self.cameraComboBox itemArray];
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
    
    if (found /*&& [defaultCamera length] > 0*/){
        NSInteger index = [self.cameraComboBox indexOfItemWithTitle:defaultCamera];
        [self.cameraComboBox selectItemAtIndex:index];
    } else if(curSel) {
        NSInteger index = [self.cameraComboBox indexOfItemWithTitle:curSel];
        if(index != -1) {
            [self.cameraComboBox selectItemAtIndex:index];
        } else {
            for (NSMutableDictionary *camInfo  in camList) {
                NSString *devType = [camInfo valueForKey:@"transportType"];
                if ([devType isEqualToString:FMeetingAudioDeviceTransportTypeBuiltIn]){
                    NSString *devName = [camInfo valueForKey:@"name"];
                    NSInteger index = [self.cameraComboBox indexOfItemWithTitle:devName];
                    [self.cameraComboBox selectItemAtIndex:index];
                    [self onVideoListSelChange];
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
    for (NSMutableDictionary *deviceInfo  in micList) {
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

- (void)loadSpeakerDevice {
    NSString *defaultSpk = [[FrtcUserDefault defaultSingleton] objectForKey:DEFAULT_SPEAKER];

    NSString* curSel = [self.speakerComboBox titleOfSelectedItem];
    
    NSMutableArray* list = [[NSMutableArray alloc ] init];

    [[FrtcCall sharedFrtcCall] frtcSpeakerList:list];

    [self.speakerComboBox removeAllItems];
    
    BOOL found = NO;
    for (NSMutableDictionary *deviceInfo  in list) {
        NSString *devName = [deviceInfo valueForKey:@"name"];
        [[self speakerComboBox] addItemWithTitle:devName];
        if ([defaultSpk isEqualToString:devName]){
            found = YES;
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
    
    if (found/*[defaultSpk length] > 0*/){
        NSInteger index = [self.speakerComboBox indexOfItemWithTitle:defaultSpk];
        [self.speakerComboBox selectItemAtIndex:index];
        [self onSpeakerListSelChange];
    } else if(curSel) {
        NSInteger index = [self.speakerComboBox indexOfItemWithTitle:curSel];
        if(index != -1) {
            [self.speakerComboBox selectItemAtIndex:index];
        } else{
            for (NSMutableDictionary *speakerInfo  in list) {
                NSString *devType = [speakerInfo valueForKey:@"transportType"];
                if ([devType isEqualToString:FMeetingAudioDeviceTransportTypeBuiltIn]) {
                    NSString *devName = [speakerInfo valueForKey:@"name"];
                    NSInteger index = [self.speakerComboBox indexOfItemWithTitle:devName];
                    [self.speakerComboBox selectItemAtIndex:index];
                    [self onSpeakerListSelChange];
                    break;
                }
            }
        }
    }
}

#pragma mark -- notification
- (void)onDeviceListChaned:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSDictionary *inUseDev = [userInfo valueForKey:FMeetingDeviceListInUseKey];
    NSString *inuseCamera = [inUseDev valueForKey:@"camera"];
    NSString *inuseMic = [inUseDev valueForKey:@"micphone"];
    NSString *inuseSpk = [inUseDev valueForKey:@"speaker"];
    
    NSString *defaultMicName = [inUseDev valueForKey:@"defaultMicName"];
    NSString *defaultSpeakerName = [inUseDev valueForKey:@"defaultSpeakerName"];
    
    [[FrtcUserDefault defaultSingleton] setObject:inuseCamera forKey:DEFAULT_CAMERA];
    [[FrtcUserDefault defaultSingleton] setObject:inuseMic forKey:DEFAULT_MICROPHONE];
    [[FrtcUserDefault defaultSingleton] setObject:inuseSpk forKey:DEFAULT_SPEAKER];
    
    [[FrtcUserDefault defaultSingleton] setObject:defaultMicName forKey:DEFAULT_MICROPHONE];
    [[FrtcUserDefault defaultSingleton] setObject:defaultSpeakerName forKey:DEFAULT_SPEAKER];

    [self loadVideoDevice];
    [self loadMicDevice];
    [self loadSpeakerDevice];
}

- (void)onDisplayChanged:(NSNotification *)notification {
    [self loadVideoDevice];
    [self loadMicDevice];
    [self loadSpeakerDevice];
}

#pragma mark -- popbutton select changed handler
- (void)onMicPhoneListSelChange {
    NSString *title = [self.micphoneComboBox titleOfSelectedItem];
    [[FrtcUserDefault defaultSingleton] setObject:title forKey:DEFAULT_MICROPHONE];
    [[FrtcCall sharedFrtcCall] frtcSelectMic:title];
}

- (void)onSpeakerListSelChange {
    NSString *title = [self.speakerComboBox titleOfSelectedItem];
    [[FrtcUserDefault defaultSingleton] setObject:title forKey:DEFAULT_SPEAKER];
    [[FrtcCall sharedFrtcCall] frtcSelectSpeaker:title];
}

- (void)onVideoListSelChange {
    NSString *title = [self.cameraComboBox titleOfSelectedItem];
    [[FrtcUserDefault defaultSingleton] setObject:title forKey:DEFAULT_CAMERA];
    [[FrtcCall sharedFrtcCall] frtcSelectCamera:title];
}

- (void)onLayoutListSelChange {
    NSString *title = [self.videoLayoutCombox titleOfSelectedItem];
    if ([title isEqualToString:NSLocalizedString(@"FM_GALLERT_MODE", @"Gallery View")]) {
        [[FrtcCallInterface singletonFrtcCall] switchGridMode:YES];
    } else {
        [[FrtcCallInterface singletonFrtcCall] switchGridMode:NO];
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

- (void)configMediaView {
    CGFloat distance = [self distance];
    
    [self.cameraLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(24);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.cameraComboBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(distance);
        make.centerY.mas_equalTo(self.cameraLabel.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(286);
        make.height.mas_greaterThanOrEqualTo(32);
     }];
    
    [self.micphoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cameraLabel.mas_bottom).offset(28);
        make.left.mas_equalTo(24);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.micphoneComboBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(distance);
        make.centerY.mas_equalTo(self.micphoneLabel.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(286);
        make.height.mas_greaterThanOrEqualTo(32);
     }];
    
    [self.speakerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.micphoneLabel.mas_bottom).offset(28);
        make.left.mas_equalTo(24);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.speakerComboBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(distance);
        make.centerY.mas_equalTo(self.speakerLabel.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(286);
        make.height.mas_greaterThanOrEqualTo(32);
     }];
    
    [self.videoLayoutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.speakerLabel.mas_bottom).offset(28);
        make.left.mas_equalTo(24);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.videoLayoutCombox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(distance);
        make.centerY.mas_equalTo(self.videoLayoutLabel.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(286);
        make.height.mas_greaterThanOrEqualTo(32);
     }];
    
    [self.intelligentNoiseReductionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.videoLayoutLabel.mas_bottom).offset(25);
        make.left.mas_equalTo(26);
        make.width.mas_greaterThanOrEqualTo(360);
        make.height.mas_greaterThanOrEqualTo(16);
     }];
    
}

- (NSTextField *)cameraLabel {
    if (!_cameraLabel){
        _cameraLabel = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _cameraLabel.stringValue = NSLocalizedString(@"FM_CAMERA", @"Camera");
        _cameraLabel.bordered = NO;
        _cameraLabel.drawsBackground = NO;
        _cameraLabel.backgroundColor = [NSColor clearColor];
        _cameraLabel.textColor = [NSColor colorWithString:@"333333" andAlpha:1.0];
        _cameraLabel.font = [NSFont systemFontOfSize:14];
        _cameraLabel.alignment = NSTextAlignmentLeft;
        _cameraLabel.editable = NO;
        [self addSubview:_cameraLabel];
    }
    
    return _cameraLabel;
}

- (FrtcPopUpButton *)cameraComboBox {
    if (!_cameraComboBox) {
        _cameraComboBox = [[FrtcPopUpButton alloc] init];
        [_cameraComboBox setFontWithString:@"222222" alpha:1 size:14 andType:SFProDisplayRegular];
        [_cameraComboBox setTarget:self];
        [_cameraComboBox setAction:@selector(onVideoListSelChange)];
        [self  addSubview:_cameraComboBox];
    }
    return  _cameraComboBox;
}

- (NSTextField *)micphoneLabel {
    if (!_micphoneLabel) {
        _micphoneLabel = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _micphoneLabel.stringValue = NSLocalizedString(@"FM_MICROPHONE", @"Microphone");
        _micphoneLabel.bordered = NO;
        _micphoneLabel.drawsBackground = NO;
        _micphoneLabel.backgroundColor = [NSColor clearColor];
        _micphoneLabel.textColor = [NSColor colorWithString:@"333333" andAlpha:1.0];
        _micphoneLabel.font = [NSFont systemFontOfSize:14];
        _micphoneLabel.alignment = NSTextAlignmentLeft;
        _micphoneLabel.editable = NO;
        [self addSubview:_micphoneLabel];
    }
    
    return _micphoneLabel;
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

- (NSTextField *)speakerLabel {
    if (!_speakerLabel){
        _speakerLabel = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _speakerLabel.stringValue = NSLocalizedString(@"FM_SPEAKER", @"Speaker");
        _speakerLabel.bordered = NO;
        _speakerLabel.drawsBackground = NO;
        _speakerLabel.backgroundColor = [NSColor clearColor];
        _speakerLabel.textColor = [NSColor colorWithString:@"333333" andAlpha:1.0];
        _speakerLabel.font = [NSFont systemFontOfSize:14];
        _speakerLabel.alignment = NSTextAlignmentLeft;
        _speakerLabel.editable = NO;
        [self addSubview:_speakerLabel];
    }
    
    return _speakerLabel;
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

- (NSTextField *)videoLayoutLabel {
    if (!_videoLayoutLabel){
        _videoLayoutLabel = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _videoLayoutLabel.stringValue = NSLocalizedString(@"PAM_VIDEO_LAYOUT", @"Video Layout");
        _videoLayoutLabel.bordered = NO;
        _videoLayoutLabel.drawsBackground = NO;
        _videoLayoutLabel.backgroundColor = [NSColor clearColor];
        _videoLayoutLabel.layer.borderColor = [NSColor colorWithString:@"DEDEDE" andAlpha:1.0].CGColor;
        _videoLayoutLabel.layer.backgroundColor = [NSColor colorWithString:@"FFFFFF" andAlpha:1.0].CGColor;
        _videoLayoutLabel.font = [NSFont systemFontOfSize:14];
        _videoLayoutLabel.alignment = NSTextAlignmentLeft;
        _videoLayoutLabel.editable = NO;
        [self addSubview:_videoLayoutLabel];
    }
    
    return _videoLayoutLabel;
}

- (FrtcPopUpButton *)videoLayoutCombox {
    if (!_videoLayoutCombox) {
        _videoLayoutCombox = [[FrtcPopUpButton alloc] init];
        [_videoLayoutCombox setFontWithString:@"222222" alpha:1 size:14 andType:SFProDisplayRegular];
        [_videoLayoutCombox setTarget:self];
        [_videoLayoutCombox setAction:@selector(onLayoutListSelChange)];
        [[self videoLayoutCombox] addItemWithTitle:NSLocalizedString(@"FM_PRESENTER_MODE", @"Presenter View")];
        [[self videoLayoutCombox] addItemWithTitle:NSLocalizedString(@"FM_GALLERT_MODE", @"Gallery View")];
        [self addSubview:_videoLayoutCombox];
    }
    return  _videoLayoutCombox;
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

- (void)updataSettingComboxWithUserSelectMenuButtonGridMode:(BOOL)isGridMode {
    if(isGridMode) { // gallery
        [self.videoLayoutCombox selectItemAtIndex:1];
    } else { // presentor
        [self.videoLayoutCombox selectItemAtIndex:0];
    }
}

@end
