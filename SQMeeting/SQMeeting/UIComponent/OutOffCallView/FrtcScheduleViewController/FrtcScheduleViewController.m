#import "FrtcScheduleViewController.h"
#import "FrtcPopUpButton.h"

@interface FrtcScheduleViewController ()

@property (nonatomic, strong) NSButton  *enableCameraButton;

@property (nonatomic, strong) NSView    *lineView;

@property (nonatomic, strong) NSButton  *enablePersonalMeetingIDButton;

@property (nonatomic, strong) FrtcPopUpButton *personalConferenceNumberCombox;

@end

@implementation FrtcScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
    [self setupScheduleViewLayout];
}

#pragma mark --layout--
- (void)setupScheduleViewLayout {
    [self.enableCameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(22);
        make.width.mas_greaterThanOrEqualTo(70);
        make.height.mas_greaterThanOrEqualTo(20);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.enableCameraButton.mas_bottom).offset(12);
        make.width.mas_equalTo(203);
        make.height.mas_equalTo(1);
    }];
    
    [self.enablePersonalMeetingIDButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(12);
        make.width.mas_greaterThanOrEqualTo(126);
        make.height.mas_greaterThanOrEqualTo(20);
    }];
    
    [self.personalConferenceNumberCombox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(self.enablePersonalMeetingIDButton.mas_bottom).offset(12);
        make.width.mas_greaterThanOrEqualTo(172);
        make.height.mas_greaterThanOrEqualTo(32);
     }];
}

#pragma mark --button sender--
- (void)onEnableCamera:(NSButton *)sender {
    if(sender.state == NSControlStateValueOn) {
        [[FrtcUserDefault defaultSingleton] setBoolObject:YES forKey:CAMERA_ENABLE];
    } else {
        [[FrtcUserDefault defaultSingleton] setBoolObject:NO forKey:CAMERA_ENABLE];
    }
}

- (void)onEnablePersonalMeetingID:(NSButton *)sender {
    if(sender.state == NSControlStateValueOn) {
        self.preferredContentSize = NSMakeSize(204, 168);
        self.personalConferenceNumberCombox.hidden = NO;
        self.personalNumber = YES;
    } else {
        self.preferredContentSize = NSMakeSize(204, 103);
        self.personalConferenceNumberCombox.hidden = YES;
        self.personalNumber = NO;
    }
}

- (void)onPersonalNumberSelect {
    self.personaConferencelNumber = [self.personalConferenceNumberCombox titleOfSelectedItem];
    self.personalConferencePassword =((PersonalMeetingModel *)(self.meetingRooms.meeting_rooms[_personalConferenceNumberCombox.indexOfSelectedItem])).meeting_password;
    self.personalConferencePassword = self.personalConferencePassword ? self.personalConferencePassword : @"";
}

#pragma mark --lazy getter
- (NSButton *)enableCameraButton {
    if (!_enableCameraButton){
        _enableCameraButton = [self checkButton:NSLocalizedString(@"FM_JOIN_WITH_CAMERA", @"Turn On Camera") aciton:@selector(onEnableCamera:)];
        
        BOOL enableCamrea = [[FrtcUserDefault defaultSingleton] boolObjectForKey:CAMERA_ENABLE];
        if(enableCamrea) {
            [_enableCameraButton setState:NSControlStateValueOn];
        } else {
            [_enableCameraButton setState:NSControlStateValueOff];
        }
    }
    
    return _enableCameraButton;
}

- (NSView *)lineView {
    if(!_lineView) {
        _lineView = [[NSView alloc] initWithFrame:CGRectMake(0, 54, 203, 1)];
        _lineView.wantsLayer = YES;
        _lineView.layer.backgroundColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
        [self.view addSubview:_lineView];
    }
    
    return _lineView;
}

- (NSButton *)enablePersonalMeetingIDButton {
    if(!_enablePersonalMeetingIDButton) {
        _enablePersonalMeetingIDButton = [self checkButton:NSLocalizedString(@"FM_USE_PERSONAL_NUMBER", @"Use Personal Meeting ID") aciton:@selector(onEnablePersonalMeetingID:)];
        [_enablePersonalMeetingIDButton setState:NSControlStateValueOff];
        if(self.meetingRooms.meeting_rooms.count > 0) {
            _enablePersonalMeetingIDButton.enabled = YES;
        } else {
            _enablePersonalMeetingIDButton.enabled = NO;
        }
    }
    
    return _enablePersonalMeetingIDButton;
}

- (FrtcPopUpButton *)personalConferenceNumberCombox {
    if (!_personalConferenceNumberCombox) {
        _personalConferenceNumberCombox = [[FrtcPopUpButton alloc] init];
        [_personalConferenceNumberCombox setFontWithString:@"222222" alpha:1 size:14 andType:SFProDisplayRegular];
        [_personalConferenceNumberCombox setTarget:self];
        [_personalConferenceNumberCombox setAction:@selector(onPersonalNumberSelect)];
        
        if(self.meetingRooms.meeting_rooms.count > 0) {
            for(PersonalMeetingModel *model in self.meetingRooms.meeting_rooms) {
                [[self personalConferenceNumberCombox] addItemWithTitle:model.meeting_number];
            }
            
            self.personaConferencelNumber = _personalConferenceNumberCombox.selectedItem.title;
            self.personalConferencePassword =((PersonalMeetingModel *)(self.meetingRooms.meeting_rooms[_personalConferenceNumberCombox.indexOfSelectedItem])).meeting_password;
            self.personalConferencePassword = self.personalConferencePassword ? self.personalConferencePassword :@"";
        }
        [self.view addSubview:_personalConferenceNumberCombox];
        _personalConferenceNumberCombox.hidden = YES;
    }
    return  _personalConferenceNumberCombox;
}

#pragma mark --internal function--
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
    [self.view addSubview:checkButton];
    
    return checkButton;
}

@end
