#import "FrtcCallBarView.h"
#import "FrtcInfoInstance.h"


@interface FrtcCallBarView () <HoverImageViewDelegate>

@property (nonatomic, strong) FrtcHoverButton  *muteCameraButton;

@property (nonatomic, strong) FrtcHoverButton  *dropCallButton;
@property (nonatomic, strong) NSTextField           *dropCallLabel;
@property (nonatomic, strong) CallBarBackGroundView *dropCallBackGroundView;



@property (nonatomic, strong) FrtcHoverButton  *inviteButton;
@property (nonatomic, strong) NSTextField           *inviteLabel;
@property (nonatomic, strong) CallBarBackGroundView *inviteBackGroundView;

@property (nonatomic, strong) FrtcHoverButton  *nameListButton;
@property (nonatomic, strong) NSTextField           *nameListLabel;
@property (nonatomic, strong) CallBarBackGroundView *nameListBackGroundView;

@property (nonatomic, strong) FrtcHoverButton  *callSettingButton;
@property (nonatomic, strong) NSTextField           *callSettingLabel;
@property (nonatomic, strong) CallBarBackGroundView *callSettingBackGroundView;

@property (nonatomic, strong) CallBarBackGroundView *localMuteBackGroundView;

@property (nonatomic, strong) FrtcHoverButton  *shareContentButton;
@property (nonatomic, strong) NSTextField           *shareContentLabel;
@property (nonatomic, strong) CallBarBackGroundView *shareContentBackGroundView;

@property (nonatomic, assign, getter=isAuthority)    BOOL authority;

@property (nonatomic, assign, getter=isMeetingOwner) BOOL meetingOwner;

@end

@implementation FrtcCallBarView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)init {
    self = [super init];
    
    if(self) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
        
        [self setupCallBarViewLayout];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUpateRosterNumber:) name:FMeetingUpdateRosterNumberNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMeterKey:) name:FrtcMeetingAudioMeterNotification object:nil];
    }
    
    return self;
}

- (instancetype)initWithAudoStatus:(BOOL)audioCall withAuthority:(BOOL)authority withMeetingOwner:(BOOL)meetingOwner {
    self = [super init];
    
    if(self) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
        self.audioCall = audioCall;
        self.authority = authority;
        self.meetingOwner = meetingOwner;
        [self setupCallBarViewLayout];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUpateRosterNumber:) name:FMeetingUpdateRosterNumberNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMeterKey:) name:FrtcMeetingAudioMeterNotification object:nil];
    }
    
    return self;
}

- (void)recordLayout {
    NSLog(@"%@", self.videoRecordingBackGroundView);
    [self.videoRecordingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(6);
        make.left.mas_equalTo(self.disableTextButton.mas_right).offset(35);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.videoRecordingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(35);
        make.centerX.mas_equalTo(self.videoRecordingButton.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.videoRecordingBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.centerX.mas_equalTo(self.videoRecordingButton.mas_centerX);
        make.width.mas_equalTo([self isEnglish] ? 48 : 48);
        make.height.mas_equalTo(56);
    }];
}

- (void)streamingLayout {
    NSLog(@"%@", self.videoStreamingBackGroundView);
    
    [self.videoStreamingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(6);
        make.left.mas_equalTo(self.videoRecordingButton.mas_right).offset(35);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.videoStreamingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(35);
        make.centerX.mas_equalTo(self.videoStreamingButton.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.videoStreamingBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.centerX.mas_equalTo(self.videoStreamingButton.mas_centerX);
        make.width.mas_equalTo([self isEnglish] ? 50 : 48);
        make.height.mas_equalTo(56);
    }];
    
    [self.inviteStreamingBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.videoStreamingBackGroundView.mas_right).offset(3);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(48);
    }];
    
    [self.inviteStreamingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.centerX.mas_equalTo(self.inviteStreamingBackGroundView.mas_centerX);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(8);
    }];
}

- (void)basicRightsLayout {
    NSLog(@"%@", self.inviteBackGroundView);
    
    [self.inviteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(6);
        make.right.mas_equalTo(self.nameListButton.mas_left).offset(-35);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.inviteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(35);
        make.centerX.mas_equalTo(self.inviteButton.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.inviteBackGroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self.inviteButton.mas_centerX);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(56);
    }];
    
    NSLog(@"%@", self.disableTextBackGroundView);
    
    [self.disableTextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(6);
        make.left.mas_equalTo(self.enableTextButton.mas_right).offset(35);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.disableTexttLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(35);
        make.centerX.mas_equalTo(self.disableTextButton.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.disableTextBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.centerX.mas_equalTo(self.disableTextButton.mas_centerX);
        make.width.mas_equalTo([self isEnglish] ? 48 : 48);
        make.height.mas_equalTo(56);
    }];
    
    NSLog(@"%@", self.localMuteBackGroundView);
    [self.localMuteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(6);
        make.right.mas_equalTo(self.inviteButton.mas_left).offset(/*-[self distance]*/ - 30);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.localMuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(35);
        make.centerX.mas_equalTo(self.localMuteButton.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.localMuteBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.centerX.mas_equalTo(self.localMuteButton.mas_centerX);
        make.width.mas_equalTo([self isEnglish] ? 80 :68);
        make.height.mas_equalTo(56);
    }];
    
    NSLog(@"%@", self.shareContentBackGroundView);
 
    [self.shareContentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(6);
        make.right.mas_equalTo(self.localMuteButton.mas_left).offset([self isEnglish] ? -38 :-33);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.shareContentBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.centerX.mas_equalTo(self.shareContentButton.mas_centerX);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(56);
    }];
    
    [self.shareContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(35);
        make.centerX.mas_equalTo(self.shareContentButton.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)basicLayoutForOwner {
    [self basicRightsLayout];
    NSLog(@"%@", self.videoRecordingBackGroundView);
    [self recordLayout];
    
    NSLog(@"%@", self.callSettingBackGroundView);
    [self.callSettingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(6);
        make.left.mas_equalTo(self.videoRecordingButton.mas_right).offset(35);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.callSettingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(35);
        make.centerX.mas_equalTo(self.callSettingButton.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.callSettingBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.centerX.mas_equalTo(self.callSettingButton.mas_centerX);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(56);
    }];
}

- (void)meetingOwnerLayoutButHaveNoAutrority {
    NSLog(@"%@", self.enableTextBackGroundView);
    
    [self.enableTextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(6);
        make.left.mas_equalTo(self.mas_centerX).offset(17.5);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.enableTexttLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(35);
        make.centerX.mas_equalTo(self.enableTextButton.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.enableTextBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.centerX.mas_equalTo(self.enableTextButton.mas_centerX);
        make.width.mas_equalTo([self isEnglish] ? 48 : 48);
        make.height.mas_equalTo(56);
    }];

    NSLog(@"%@", self.nameListBackGroundView);
    
    [self.nameListButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(6);
        make.right.mas_equalTo(self.mas_centerX).offset(-17.5);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.rosterNumberTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(9);
        make.left.mas_equalTo(self.nameListButton.mas_right);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.nameListLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(35);
        make.centerX.mas_equalTo(self.nameListButton.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.nameListBackGroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.centerX.mas_equalTo(self.nameListLabel.mas_centerX);
        make.width.mas_equalTo([self isEnglish] ? 80 : 48);
        make.height.mas_equalTo(56);
    }];
    
    [self basicLayoutForOwner];
}

- (void)basicRightsHaveNoLabFeature {
    NSLog(@"%@", self.nameListBackGroundView);
    [self.nameListButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(6);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.rosterNumberTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(9);
        make.left.mas_equalTo(self.nameListButton.mas_right);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.nameListLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(35);
        make.centerX.mas_equalTo(self.nameListButton.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.nameListBackGroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.centerX.mas_equalTo(self.nameListButton.mas_centerX);
        make.width.mas_equalTo([self isEnglish] ? 80 : 48);
        make.height.mas_equalTo(56);
    }];
    

    NSLog(@"%@", self.enableTextBackGroundView);
    [self.enableTextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(6);
        //make.centerX.mas_equalTo(self.mas_centerX);
        make.left.mas_equalTo(self.nameListButton.mas_right).offset(35);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.enableTexttLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(35);
        make.centerX.mas_equalTo(self.enableTextButton.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.enableTextBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.centerX.mas_equalTo(self.enableTextButton.mas_centerX);
        make.width.mas_equalTo([self isEnglish] ? 48 : 48);
        make.height.mas_equalTo(56);
    }];
}

- (void)basicRightsHaveAllRights {
    NSLog(@"%@", self.enableTextBackGroundView);
    
    [self.enableTextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(6);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.enableTexttLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(35);
        make.centerX.mas_equalTo(self.enableTextButton.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.enableTextBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.centerX.mas_equalTo(self.enableTextButton.mas_centerX);
        make.width.mas_equalTo([self isEnglish] ? 48 : 48);
        make.height.mas_equalTo(56);
    }];
  
    NSLog(@"%@", self.nameListBackGroundView);
    
    [self.nameListButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(6);
        make.right.mas_equalTo(self.enableTextButton.mas_left).offset(-35);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.rosterNumberTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(9);
        make.left.mas_equalTo(self.nameListButton.mas_right);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.nameListLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(35);
        make.centerX.mas_equalTo(self.nameListButton.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.nameListBackGroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.centerX.mas_equalTo(self.nameListLabel.mas_centerX);
        make.width.mas_equalTo([self isEnglish] ? 80 : 48);
        make.height.mas_equalTo(56);
    }];
    
}

- (void)setupCallBarViewLayout {
    [self.dropCallBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.right.mas_equalTo(-21);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(56);
    }];
    
    [self.dropCallButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(6);
        make.right.mas_equalTo(-31);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.dropCallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(35);
        make.centerX.mas_equalTo(self.dropCallButton.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.muteAudioBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(21);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(56);
    }];
    
    [self.muteAudioButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(6);
        make.left.mas_equalTo(31);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.muteAudioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(35);
        make.centerX.mas_equalTo(self.muteAudioButton.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.selectAudioDeviceBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.muteAudioBackGroundView.mas_right).offset(3);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(48);
    }];
    
    [self.selectAudioDeviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.centerX.mas_equalTo(self.selectAudioDeviceBackGroundView.mas_centerX);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(8);
    }];
    
    if(self.isAudioCall) {
        [self.nameListBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(48);
            make.height.mas_equalTo(56);
        }];
        
        [self.nameListButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(6);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(28);
            make.height.mas_equalTo(28);
        }];
        
        [self.rosterNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(9);
            make.left.mas_equalTo(self.nameListButton.mas_right);
            make.width.mas_greaterThanOrEqualTo(0);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
        
        [self.nameListLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(35);
            make.centerX.mas_equalTo(self.nameListButton.mas_centerX);
            make.width.mas_greaterThanOrEqualTo(0);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
        
        [self.callSettingBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.nameListBackGroundView.mas_right).offset(31);
            make.width.mas_equalTo(48);
            make.height.mas_equalTo(56);
        }];

        [self.callSettingButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(6);
            make.left.mas_equalTo(self.nameListButton.mas_right).offset(40);
            make.width.mas_equalTo(28);
            make.height.mas_equalTo(28);
        }];
        
        [self.callSettingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(35);
            make.centerX.mas_equalTo(self.callSettingButton.mas_centerX);
            make.width.mas_greaterThanOrEqualTo(0);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
        
        [self.inviteBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(self.nameListBackGroundView.mas_left).offset(-31);
            make.width.mas_equalTo(48);
            make.height.mas_equalTo(56);
        }];
        
        [self.inviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(6);
            make.right.mas_equalTo(self.nameListButton.mas_left).offset(-51);
            make.width.mas_equalTo(28);
            make.height.mas_equalTo(28);
        }];
        
        [self.inviteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(35);
            make.centerX.mas_equalTo(self.inviteButton.mas_centerX);
            make.width.mas_greaterThanOrEqualTo(0);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
        
        return;
    }
    
    [self.inviteBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(56);
    }];
    
    [self.inviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(6);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.inviteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(35);
        make.centerX.mas_equalTo(self.inviteButton.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.nameListBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.inviteBackGroundView.mas_right).offset([self distance]);
        make.width.mas_equalTo([self isEnglish] ? 60 : 48);
        make.height.mas_equalTo(56);
    }];
    
    [self.nameListButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(6);
        make.left.mas_equalTo(self.inviteButton.mas_right).offset(40);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.rosterNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(9);
        make.left.mas_equalTo(self.nameListButton.mas_right);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.nameListLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(35);
        make.centerX.mas_equalTo(self.nameListButton.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.nameListBackGroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.centerX.mas_equalTo(self.nameListLabel.mas_centerX);
        make.width.mas_equalTo([self isEnglish] ? 80 : 48);
        make.height.mas_equalTo(56);
    }];
    
    if(self.isAuthority) {
        BOOL enableLab = [[FrtcUserDefault defaultSingleton] boolObjectForKey:ENABLE_LAB_FEATURE];
        if(!enableLab) {
            [self basicRightsHaveNoLabFeature];
            [self basicRightsLayout];
    
            NSLog(@"%@", self.callSettingBackGroundView);
            
            [self.callSettingButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top).offset(6);
                make.left.mas_equalTo(self.disableTextButton.mas_right).offset(35);
                make.width.mas_equalTo(28);
                make.height.mas_equalTo(28);
            }];
            
            [self.callSettingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top).offset(35);
                make.centerX.mas_equalTo(self.callSettingButton.mas_centerX);
                make.width.mas_greaterThanOrEqualTo(0);
                make.height.mas_greaterThanOrEqualTo(0);
            }];
            
            [self.callSettingBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top);
                make.centerX.mas_equalTo(self.callSettingButton.mas_centerX);
                make.width.mas_equalTo(48);
                make.height.mas_equalTo(56);
            }];
        } else {
            [self basicRightsHaveAllRights];
            [self basicRightsLayout];
         
            [self recordLayout];
            [self streamingLayout];
            
            [self.callSettingBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top);
                make.left.mas_equalTo(self.videoStreamingBackGroundView.mas_right).offset(31);
                make.width.mas_equalTo(48);
                make.height.mas_equalTo(56);
            }];
            
            [self.callSettingButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top).offset(6);
                make.left.mas_equalTo(self.videoStreamingButton.mas_right).offset(35);
                make.width.mas_equalTo(28);
                make.height.mas_equalTo(28);
            }];
            
            [self.callSettingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top).offset(35);
                make.centerX.mas_equalTo(self.callSettingButton.mas_centerX);
                make.width.mas_greaterThanOrEqualTo(0);
                make.height.mas_greaterThanOrEqualTo(0);
            }];
            
            [self.callSettingBackGroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top);
                make.centerX.mas_equalTo(self.callSettingButton.mas_centerX);
                make.width.mas_equalTo(48);
                make.height.mas_equalTo(56);
            }];
        }
        
        goto end;
    } else {
        if(!self.isMeetingOwner) {
            NSLog(@"%@", self.callSettingBackGroundView);

            [self.callSettingButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top).offset(6);
                make.left.mas_equalTo(self.nameListButton.mas_right).offset(51);
                make.width.mas_equalTo(28);
                make.height.mas_equalTo(28);
            }];
            
            [self.callSettingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top).offset(35);
                make.centerX.mas_equalTo(self.callSettingButton.mas_centerX);
                make.width.mas_greaterThanOrEqualTo(0);
                make.height.mas_greaterThanOrEqualTo(0);
            }];
            
            [self.callSettingBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top);
                make.centerX.mas_equalTo(self.callSettingButton.mas_centerX);
                make.width.mas_equalTo(48);
                make.height.mas_equalTo(56);
            }];
            
            NSLog(@"%@", self.localMuteBackGroundView);
            
            [self.localMuteButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top).offset(6);
                make.right.mas_equalTo(self.inviteButton.mas_left).offset(/*-[self distance]*/ - 40);
                make.width.mas_equalTo(28);
                make.height.mas_equalTo(28);
            }];
            
            [self.localMuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top).offset(35);
                make.centerX.mas_equalTo(self.localMuteButton.mas_centerX);
                make.width.mas_greaterThanOrEqualTo(0);
                make.height.mas_greaterThanOrEqualTo(0);
            }];
            
            
            [self.localMuteBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top);
                make.centerX.mas_equalTo(self.localMuteButton.mas_centerX);
                make.width.mas_equalTo([self isEnglish] ? 80 :68);
                make.height.mas_equalTo(56);
            }];

            NSLog(@"%@", self.shareContentBackGroundView);
            
            [self.shareContentButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top).offset(6);
                make.right.mas_equalTo(self.localMuteButton.mas_left).offset([self isEnglish] ? -38 :-33);
                make.width.mas_equalTo(28);
                make.height.mas_equalTo(28);
            }];
            
            [self.shareContentBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top);
                make.centerX.mas_equalTo(self.shareContentButton.mas_centerX);
                make.width.mas_equalTo(48);
                make.height.mas_equalTo(56);
            }];
                
            [self.shareContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top).offset(35);
                make.centerX.mas_equalTo(self.shareContentButton.mas_centerX);
                make.width.mas_greaterThanOrEqualTo(0);
                make.height.mas_greaterThanOrEqualTo(0);
            }];
            
            
            
           // goto end;
            [self.videoMuteBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top);
                make.left.mas_equalTo(self.muteAudioBackGroundView.mas_right).offset(32);
                make.width.mas_equalTo([self isEnglish] ? 60 :48);
                make.height.mas_equalTo(56);
            }];
            
            [self.videoMuteButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top).offset(6);
                make.left.mas_equalTo(self.muteAudioButton.mas_right).offset(52);
                make.width.mas_equalTo(28);
                make.height.mas_equalTo(28);
            }];
            
            [self.videoMuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top).offset(35);
                make.centerX.mas_equalTo(self.videoMuteButton.mas_centerX);
                make.width.mas_greaterThanOrEqualTo(0);
                make.height.mas_greaterThanOrEqualTo(0);
            }];
            
            [self.videoMuteBackGroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top);
                make.centerX.mas_equalTo(self.videoMuteButton.mas_centerX);
                make.width.mas_equalTo([self isEnglish] ? 60 :48);
                make.height.mas_equalTo(56);
            }];
            
            [self.selectVideoDeviceBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.mas_centerY);
                make.left.mas_equalTo(self.videoMuteBackGroundView.mas_right).offset(3);
                make.width.mas_equalTo(12);
                make.height.mas_equalTo(48);
            }];
            
            [self.selectVideoDeviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.mas_centerY);
                make.centerX.mas_equalTo(self.selectVideoDeviceBackGroundView.mas_centerX);
                make.width.mas_equalTo(8);
                make.height.mas_equalTo(8);
            }];
            
            [self.showNewComingView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.nameListButton.mas_top).offset(5);
                make.left.mas_equalTo(self.nameListButton.mas_right).offset(-5);
                make.width.mas_equalTo(8);
                make.height.mas_equalTo(8);
            }];
            
            return;
        }
    }
    
    if(self.isMeetingOwner) {
        BOOL enableLab = [[FrtcUserDefault defaultSingleton] boolObjectForKey:ENABLE_LAB_FEATURE];
        if(!enableLab) {
            [self basicRightsHaveNoLabFeature];
            [self basicRightsLayout];
    
            NSLog(@"%@", self.callSettingBackGroundView);
            
            [self.callSettingButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top).offset(6);
                make.left.mas_equalTo(self.disableTextButton.mas_right).offset(35);
                make.width.mas_equalTo(28);
                make.height.mas_equalTo(28);
            }];
            
            [self.callSettingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top).offset(35);
                make.centerX.mas_equalTo(self.callSettingButton.mas_centerX);
                make.width.mas_greaterThanOrEqualTo(0);
                make.height.mas_greaterThanOrEqualTo(0);
            }];
            
            [self.callSettingBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top);
                make.centerX.mas_equalTo(self.callSettingButton.mas_centerX);
                make.width.mas_equalTo(48);
                make.height.mas_equalTo(56);
            }];
        } else {
            if(self.isAuthority) {
                [self basicRightsHaveAllRights];
                [self basicRightsLayout];
             
                [self recordLayout];
                [self streamingLayout];
                
                [self.callSettingBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.mas_top);
                    make.left.mas_equalTo(self.videoStreamingBackGroundView.mas_right).offset(31);
                    make.width.mas_equalTo(48);
                    make.height.mas_equalTo(56);
                }];
                
                [self.callSettingButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.mas_top).offset(6);
                    make.left.mas_equalTo(self.videoStreamingButton.mas_right).offset(35);
                    make.width.mas_equalTo(28);
                    make.height.mas_equalTo(28);
                }];
                
                [self.callSettingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.mas_top).offset(35);
                    make.centerX.mas_equalTo(self.callSettingButton.mas_centerX);
                    make.width.mas_greaterThanOrEqualTo(0);
                    make.height.mas_greaterThanOrEqualTo(0);
                }];
                
                [self.callSettingBackGroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.mas_top);
                    make.centerX.mas_equalTo(self.callSettingButton.mas_centerX);
                    make.width.mas_equalTo(48);
                    make.height.mas_equalTo(56);
                }];
            } else {
                [self meetingOwnerLayoutButHaveNoAutrority];
            }
        }
    } else {
        NSLog(@"%@", self.callSettingBackGroundView);

        [self.callSettingButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(6);
            make.left.mas_equalTo(self.nameListButton.mas_right).offset(51);
            make.width.mas_equalTo(28);
            make.height.mas_equalTo(28);
        }];
        
        [self.callSettingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(35);
            make.centerX.mas_equalTo(self.callSettingButton.mas_centerX);
            make.width.mas_greaterThanOrEqualTo(0);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
        
        [self.callSettingBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.centerX.mas_equalTo(self.callSettingButton.mas_centerX);
            make.width.mas_equalTo(48);
            make.height.mas_equalTo(56);
        }];
        
        NSLog(@"%@", self.localMuteBackGroundView);
        
        [self.localMuteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(6);
            make.right.mas_equalTo(self.inviteButton.mas_left).offset(-[self distance] - 30);
            make.width.mas_equalTo(28);
            make.height.mas_equalTo(28);
        }];
        
        [self.localMuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(35);
            make.centerX.mas_equalTo(self.localMuteButton.mas_centerX);
            make.width.mas_greaterThanOrEqualTo(0);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
        
        
        [self.localMuteBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.centerX.mas_equalTo(self.localMuteButton.mas_centerX);
            make.width.mas_equalTo([self isEnglish] ? 80 :68);
            make.height.mas_equalTo(56);
        }];

        NSLog(@"%@", self.shareContentBackGroundView);
        
        [self.shareContentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(6);
            make.right.mas_equalTo(self.localMuteButton.mas_left).offset([self isEnglish] ? -38 :-33);
            make.width.mas_equalTo(28);
            make.height.mas_equalTo(28);
        }];
        
        [self.shareContentBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.centerX.mas_equalTo(self.shareContentButton.mas_centerX);
            make.width.mas_equalTo(48);
            make.height.mas_equalTo(56);
        }];
            
        [self.shareContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(35);
            make.centerX.mas_equalTo(self.shareContentButton.mas_centerX);
            make.width.mas_greaterThanOrEqualTo(0);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
    }
    
end:
    [self.localMuteBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.right.mas_equalTo(self.inviteBackGroundView.mas_left).offset(-[self distance] - 10);
        make.width.mas_equalTo([self isEnglish] ? 80 :68);
        make.height.mas_equalTo(56);
    }];
 
    [self.localMuteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(6);
        make.right.mas_equalTo(self.inviteButton.mas_left).offset(/*-[self distance]*/ - 30);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.localMuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(35);
        make.centerX.mas_equalTo(self.localMuteButton.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    
    [self.localMuteBackGroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.centerX.mas_equalTo(self.localMuteButton.mas_centerX);
        make.width.mas_equalTo([self isEnglish] ? 80 :68);
        make.height.mas_equalTo(56);
    }];

    [self.shareContentBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.right.mas_equalTo(self.localMuteBackGroundView.mas_left).offset(-28);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(56);
    }];
    
    [self.shareContentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(6);
        make.right.mas_equalTo(self.localMuteButton.mas_left).offset([self isEnglish] ? -38 :-33);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.shareContentBackGroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.centerX.mas_equalTo(self.shareContentButton.mas_centerX);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(56);
    }];
        
    [self.shareContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(35);
        make.centerX.mas_equalTo(self.shareContentButton.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.videoMuteBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.muteAudioBackGroundView.mas_right).offset(32);
        make.width.mas_equalTo([self isEnglish] ? 60 :48);
        make.height.mas_equalTo(56);
    }];
    
    [self.videoMuteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(6);
        make.left.mas_equalTo(self.muteAudioButton.mas_right).offset(52);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.videoMuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(35);
        make.centerX.mas_equalTo(self.videoMuteButton.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.videoMuteBackGroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.centerX.mas_equalTo(self.videoMuteButton.mas_centerX);
        make.width.mas_equalTo([self isEnglish] ? 60 :48);
        make.height.mas_equalTo(56);
    }];
    
    [self.selectVideoDeviceBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.videoMuteBackGroundView.mas_right).offset(3);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(48);
    }];
    
    [self.selectVideoDeviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.centerX.mas_equalTo(self.selectVideoDeviceBackGroundView.mas_centerX);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(8);
    }];
    
    [self.showNewComingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.nameListButton.mas_top).offset(5);
        make.left.mas_equalTo(self.nameListButton.mas_right).offset(-5);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(8);
    }];
}

- (CGFloat)distance {
    NSString * language = [FMLanguageConfig userLanguage] ? : [NSLocale preferredLanguages].firstObject;
    
    if([language hasPrefix:@"en"]) {
        return 38.0;
    } else {
        return 31.0;
    }
}

- (BOOL)isEnglish {
    NSString * language = [FMLanguageConfig userLanguage] ? : [NSLocale preferredLanguages].firstObject;
    
    if([language hasPrefix:@"en"]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)updateAudioLever:(NSInteger)meterLevel {
    if(meterLevel == 0) {
        [self.muteAudioButton setOnStatusImagePath:@"icon_callbar_view_big_0"];
    } else if(meterLevel == 1) {
        [self.muteAudioButton setOnStatusImagePath:@"icon_callbar_view_big_1"];
    } else if(meterLevel == 2) {
        [self.muteAudioButton setOnStatusImagePath:@"icon_callbar_view_big_2"];
    } else if(meterLevel == 3) {
        [self.muteAudioButton setOnStatusImagePath:@"icon_callbar_view_big_3"];
    } else if(meterLevel == 4) {
        [self.muteAudioButton setOnStatusImagePath:@"icon_callbar_view_big_4"];
    }
}

#pragma mark ---Notifiacation Observer
-(void)onUpateRosterNumber:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSString *rosterNumber = [userInfo valueForKey:FMeetingRosterNumberKey];
    self.rosterNumberTextField.stringValue = rosterNumber;
    if([rosterNumber isEqualToString:@"1"]) {
        self.localMuteButton.enabled = NO;
        self.localMuteLabel.textColor = [NSColor colorWithString:@"#666666" andAlpha:0.3];
    } else {
        self.localMuteButton.enabled = YES;
        self.localMuteLabel.textColor = [NSColor colorWithString:@"#666666" andAlpha:1.0];
    }
}

- (void)onMeterKey:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSNumber *audioMeterLevel = [userInfo valueForKey:FrtcMeetingAudioMeteKey];
    
    float meter = [audioMeterLevel floatValue];
    //NSLog(@"The meter is %f", meter);
    if(meter > 0.000 && meter <= 0.100) {
        //NSLog(@"00000000000000");
        [self updateAudioLever:0];
    } else if(meter > 0.000 && meter <= 0.25) {
        //NSLog(@"1111111111111");
        [self updateAudioLever:1];
    } else if(meter > 0.25 && meter <= 0.5) {
        //NSLog(@"2222222222222");
        [self updateAudioLever:2];
    } else if(meter > 0.5  && meter <= 0.75) {
        //NSLog(@"3333333333333");
        [self updateAudioLever:3];
    } else if(meter > 0.75 && meter <= 1.0 ) {
        //NSLog(@"4444444444444");
        [self updateAudioLever:4];
    }
}

#pragma --HoverImageViewDelegate--
- (void)hoverImageViewClickedwithSenderTag:(NSInteger)tag {
    if(self.callBarViewDelegate && [self.callBarViewDelegate respondsToSelector:@selector(poverContentAudio)]) {
        [self.callBarViewDelegate poverContentAudio];
    }
}

#pragma --lazy load--
- (FrtcHoverButton *)muteAudioButton {
    if(!_muteAudioButton) {
        _muteAudioButton = [self frtcCallButton:@"icon-audio-mute" withOnStatusImagePath:@"icon-audio-unmute"];
        [_muteAudioButton setState:NSControlStateValueOn];
        [_muteAudioButton setAction:@selector(frtcMuteLocalAudio:)];
        [self addSubview:_muteAudioButton];
    }
    
    return _muteAudioButton;
}

- (NSTextField *)muteAudioLabel {
    if(!_muteAudioLabel) {
        _muteAudioLabel = [self frtcCallLabel:NSLocalizedString(@"FM_MUTE", @"Mute") titleColor:[NSColor colorWithString:@"#666666" andAlpha:1.0]];
        [self addSubview:_muteAudioLabel];
    }
    
    return _muteAudioLabel;
}

- (CallBarBackGroundView *)muteAudioBackGroundView {
    if(!_muteAudioBackGroundView) {
        _muteAudioBackGroundView = [[CallBarBackGroundView alloc] initWithFrame:NSMakeRect(0, 0, 48, 56)];
        [self addSubview:_muteAudioBackGroundView];
    }
    
    return _muteAudioBackGroundView;
}

- (FrtcHoverButton *)inviteButton {
    if(!_inviteButton) {
        _inviteButton = [self frtcCallButton:@"icon-invite" withOnStatusImagePath:@"icon-invite"];
        [_inviteButton setAction:@selector(inviteButtonSender:)];
        [self addSubview:_inviteButton];
    }
    
    return _inviteButton;
}

- (CallBarBackGroundView *)selectAudioDeviceBackGroundView {
    if(!_selectAudioDeviceBackGroundView) {
        _selectAudioDeviceBackGroundView = [[CallBarBackGroundView alloc] initWithFrame:NSMakeRect(0, 0, 12, 48)];
        [self addSubview:_selectAudioDeviceBackGroundView];
    }
    
    return _selectAudioDeviceBackGroundView;
}

- (FrtcHoverButton *)selectAudioDeviceButton {
    if(!_selectAudioDeviceButton) {
        _selectAudioDeviceButton = [self frtcCallButton:@"icon_streaming_url" withOnStatusImagePath:@"icon_streaming_url"];
        [_selectAudioDeviceButton setAction:@selector(onSelectAudioDevice:)];
        [self addSubview:_selectAudioDeviceButton];
    }
    
    return _selectAudioDeviceButton;
}

- (NSTextField *)inviteLabel {
    if(!_inviteLabel) {
        _inviteLabel = [self frtcCallLabel:NSLocalizedString(@"FM_INVITE_JOIN", @"Invite") titleColor:[NSColor colorWithString:@"#666666" andAlpha:1.0]];
        [self addSubview:_inviteLabel];
    }
    
    return _inviteLabel;
}

- (CallBarBackGroundView *)inviteBackGroundView {
    if(!_inviteBackGroundView) {
        _inviteBackGroundView = [[CallBarBackGroundView alloc] initWithFrame:NSMakeRect(0, 0, 48, 56)];
        [self addSubview:_inviteBackGroundView];
    }
    
    return _inviteBackGroundView;
}

- (FrtcHoverButton *)nameListButton {
    if(!_nameListButton) {
        _nameListButton = [self frtcCallButton:@"icon-particpants-list" withOnStatusImagePath:@"icon-particpants-list"];
        [_nameListButton setAction:@selector(showNameList:)];
        [self addSubview:_nameListButton];
    }
    
    return _nameListButton;
}

- (NSTextField *)nameListLabel {
    if(!_nameListLabel) {
        _nameListLabel = [self frtcCallLabel:NSLocalizedString(@"FM_STATISTIC_PARTICIPANT", @"Participants") titleColor:[NSColor colorWithString:@"#666666" andAlpha:1.0]];
        [self addSubview:_nameListLabel];
    }
    
    return _nameListLabel;
}

- (CallBarBackGroundView *)nameListBackGroundView {
    if(!_nameListBackGroundView) {
        _nameListBackGroundView = [[CallBarBackGroundView alloc] initWithFrame:NSMakeRect(0, 0, 48, 56)];
        [self addSubview:_nameListBackGroundView];
    }
    
    return _nameListBackGroundView;
}

- (NSImageView *)showNewComingView {
    if (!_showNewComingView) {
        _showNewComingView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        _showNewComingView.wantsLayer = YES;
        _showNewComingView.layer.cornerRadius = 4.0;
        _showNewComingView.layer.masksToBounds = YES;
        _showNewComingView.layer.backgroundColor = [NSColor colorWithString:@"#FA5150" andAlpha:1.0].CGColor;
        _showNewComingView.hidden = YES;
        [self addSubview:_showNewComingView];
    }
        
    return _showNewComingView;
}

- (HoverImageView *)contentAudioImageView {
    if(!_contentAudioImageView) {
        _contentAudioImageView = [[HoverImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        _contentAudioImageView.delegate = self;
        _contentAudioImageView.image = [NSImage imageNamed:@"icon-content-audio-arrow"];
        [self addSubview:_contentAudioImageView];
    }
    
    return _contentAudioImageView;
}

- (CallBarBackGroundView *)contentAudioBackGroundView {
    if(!_contentAudioBackGroundView) {
        _contentAudioBackGroundView = [[CallBarBackGroundView alloc] initWithFrame:NSMakeRect(0, 0, 12, 44)];
        [self addSubview:_contentAudioBackGroundView];
        
    }
    
    
    return _contentAudioBackGroundView;
}

- (FrtcHoverButton *)enableTextButton {
    if(!_enableTextButton) {
        _enableTextButton = [self frtcCallButton:@"icon-incall-text" withOnStatusImagePath:@"icon-incall-text"];
        [_enableTextButton setAction:@selector(enableText:)];
        [self addSubview:_enableTextButton];
    }
    
    return _enableTextButton;;
}

- (NSTextField *)enableTexttLabel {
    if(!_enableTexttLabel) {
        _enableTexttLabel = [self frtcCallLabel:NSLocalizedString(@"FM_MESSAGE_BAR", @"Overlay") titleColor:[NSColor colorWithString:@"#666666" andAlpha:1.0]];
        [self addSubview:_enableTexttLabel];
    }
    
    return _enableTexttLabel;
}

- (CallBarBackGroundView *)enableTextBackGroundView {
    if(!_enableTextBackGroundView) {
        _enableTextBackGroundView = [[CallBarBackGroundView alloc] initWithFrame:NSMakeRect(0, 0, 48, 56)];
        [self addSubview:_enableTextBackGroundView];
    }
    
    return _enableTextBackGroundView;
}

- (FrtcHoverButton *)disableTextButton {
    if(!_disableTextButton) {
        _disableTextButton = [self frtcCallButton:@"icon-incall-untext" withOnStatusImagePath:@"icon-incall-untext"];
        [_disableTextButton setAction:@selector(disableText:)];
        [self addSubview:_disableTextButton];
    }
    
    return _disableTextButton;;
}

- (NSTextField *)disableTexttLabel {
    if(!_disableTexttLabel) {
        _disableTexttLabel = [self frtcCallLabel:NSLocalizedString(@"FM_UN_MESSAGE", @"Stop Message") titleColor:[NSColor colorWithString:@"#666666" andAlpha:1.0]];
        [self addSubview:_disableTexttLabel];
    }
    
    return _disableTexttLabel;
}

- (CallBarBackGroundView *)disableTextBackGroundView {
    if(!_disableTextBackGroundView) {
        _disableTextBackGroundView = [[CallBarBackGroundView alloc] initWithFrame:NSMakeRect(0, 0, 48, 56)];
        [self addSubview:_disableTextBackGroundView];
    }
    
    return _disableTextBackGroundView;
}

- (FrtcHoverButton *)callSettingButton {
    if(!_callSettingButton) {
        _callSettingButton = [self frtcCallButton:@"icon-incall-setting" withOnStatusImagePath:@"icon-incall-setting"];
        [_callSettingButton setAction:@selector(showSettingWindow:)];
        [self addSubview:_callSettingButton];
    }
    
    return _callSettingButton;
}

- (NSTextField *)callSettingLabel {
    if(!_callSettingLabel) {
        _callSettingLabel = [self frtcCallLabel:NSLocalizedString(@"FM_SETTING", @"Settings") titleColor:[NSColor colorWithString:@"#666666" andAlpha:1.0]];
        [self addSubview:_callSettingLabel];
    }
    
    return _callSettingLabel;
}

- (CallBarBackGroundView *)callSettingBackGroundView {
    if(!_callSettingBackGroundView) {
        _callSettingBackGroundView = [[CallBarBackGroundView alloc] initWithFrame:NSMakeRect(0, 0, 48, 56)];
        [self addSubview:_callSettingBackGroundView];
    }
    
    return _callSettingBackGroundView;
}

- (FrtcHoverButton *)dropCallButton {
    if(!_dropCallButton) {
        _dropCallButton = [self frtcCallButton:@"icon-dropcall" withOnStatusImagePath:@"icon-dropcall"];
        [_dropCallButton setAction:@selector(frtcDropCall:)];
        [self addSubview:_dropCallButton];
    }
    
    return _dropCallButton;
}

- (NSTextField *)dropCallLabel {
    if(!_dropCallLabel) {
        _dropCallLabel = [self frtcCallLabel:NSLocalizedString(@"FM_STOP", @"End") titleColor:[NSColor colorWithString:@"#E32726" andAlpha:1.0]];
        [self addSubview:_dropCallLabel];
    }
    
    return _dropCallLabel;
}

- (CallBarBackGroundView *)dropCallBackGroundView {
    if(!_dropCallBackGroundView) {
        _dropCallBackGroundView = [[CallBarBackGroundView alloc] initWithFrame:NSMakeRect(0, 0, 48, 56)];
        [self addSubview:_dropCallBackGroundView];
    }
    
    return _dropCallBackGroundView;
}

- (CallBarBackGroundView *)localMuteBackGroundView {
    if(!_localMuteBackGroundView) {
        _localMuteBackGroundView = [[CallBarBackGroundView alloc] initWithFrame:NSMakeRect(0, 0, 68, 56)];
        [self addSubview:_localMuteBackGroundView];
    }
    
    return _localMuteBackGroundView;
}

- (FrtcHoverButton *)localMuteButton {
    if(!_localMuteButton) {
        _localMuteButton = [self frtcCallButton:@"icon-localvideo-hidden" withOnStatusImagePath:@"icon-localvideo-unhidden"];
        [_localMuteButton setState:NSControlStateValueOn];
        [_localMuteButton setAction:@selector(hideLocalView:)];
        [self addSubview:_localMuteButton];
    }
    
    return _localMuteButton;
}

- (NSTextField *)localMuteLabel {
    if(!_localMuteLabel) {
        _localMuteLabel = [self frtcCallLabel:NSLocalizedString(@"FM_MEETING_COLSE_LOCAL_VIEW", @"Stop local view") titleColor:[NSColor colorWithString:@"#666666" andAlpha:1.0]];
        //_localMuteLabel.textColor = [NSColor colorWithString:@"#666666" andAlpha:0.3];
        [self addSubview:_localMuteLabel];
    }
    
    return _localMuteLabel;
}

- (CallBarBackGroundView *)selectVideoDeviceBackGroundView {
    if(!_selectVideoDeviceBackGroundView) {
        _selectVideoDeviceBackGroundView = [[CallBarBackGroundView alloc] initWithFrame:NSMakeRect(0, 0, 12, 48)];
        [self addSubview:_selectVideoDeviceBackGroundView];
    }
    
    return _selectVideoDeviceBackGroundView;
}

- (FrtcHoverButton *)selectVideoDeviceButton {
    if(!_selectVideoDeviceButton) {
        _selectVideoDeviceButton = [self frtcCallButton:@"icon_streaming_url" withOnStatusImagePath:@"icon_streaming_url"];
        [_selectVideoDeviceButton setAction:@selector(onSelectVideoDevice:)];
        [self addSubview:_selectVideoDeviceButton];
    }
    
    return _selectVideoDeviceButton;
}

- (FrtcHoverButton *)shareContentButton {
    if(!_shareContentButton) {
        _shareContentButton = [self frtcCallButton:@"icon-share-content" withOnStatusImagePath:@"icon-share-content"];
        [_shareContentButton setAction:@selector(shareContent:)];
        [self addSubview:_shareContentButton];
    }
    
    return _shareContentButton;
}

- (NSTextField *)shareContentLabel {
    if(!_shareContentLabel) {
        _shareContentLabel = [self frtcCallLabel:NSLocalizedString(@"FM_SHARE_CONTENT", @"Share") titleColor:[NSColor colorWithString:@"#666666" andAlpha:1.0]];
        [self addSubview:_shareContentLabel];
    }
    
    return _shareContentLabel;
}

- (CallBarBackGroundView *)shareContentBackGroundView {
    if(!_shareContentBackGroundView) {
        _shareContentBackGroundView = [[CallBarBackGroundView alloc] initWithFrame:NSMakeRect(0, 0, 48, 56)];
        [self addSubview:_shareContentBackGroundView];
    }
    
    return _shareContentBackGroundView;
}

- (FrtcHoverButton *)videoMuteButton {
    if(!_videoMuteButton) {
        _videoMuteButton = [self frtcCallButton:@"icon-video-mute" withOnStatusImagePath:@"icon-video-unmute"];
        [_videoMuteButton setAction:@selector(localVideoMute:)];
        [_videoMuteButton setState:NSControlStateValueOn];
        [self addSubview:_videoMuteButton];
    }
    
    return _videoMuteButton;
}

- (NSTextField *)videoMuteLabel {
    if(!_videoMuteLabel) {
        _videoMuteLabel = [self frtcCallLabel:NSLocalizedString(@"FM_OPEN_VIDEO", @"Start Video") titleColor:[NSColor colorWithString:@"#666666" andAlpha:1.0]];
        [self addSubview:_videoMuteLabel];
    }
    
    return _videoMuteLabel;
}

- (CallBarBackGroundView *)videoMuteBackGroundView {
    if(!_videoMuteBackGroundView) {
        _videoMuteBackGroundView = [[CallBarBackGroundView alloc] initWithFrame:NSMakeRect(0, 0, 48, 56)];
        [self addSubview:_videoMuteBackGroundView];
    }
    
    return _videoMuteBackGroundView;
}

- (NSTextField *)rosterNumberTextField {
    if (!_rosterNumberTextField){
        _rosterNumberTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _rosterNumberTextField.backgroundColor = [NSColor clearColor];
        _rosterNumberTextField.font = [NSFont systemFontOfSize:10 weight:NSFontWeightRegular];
        _rosterNumberTextField.alignment = NSTextAlignmentLeft;
        _rosterNumberTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _rosterNumberTextField.stringValue = @"1";
        _rosterNumberTextField.bordered = NO;
        _rosterNumberTextField.editable = NO;
        [self addSubview:_rosterNumberTextField];
    }
    
    return _rosterNumberTextField;
}

- (FrtcHoverButton *)videoRecordingButton {
    if(!_videoRecordingButton) {
        _videoRecordingButton = [self frtcCallButton:@"icon_recording" withOnStatusImagePath:@"icon_stop_recording"];
        [_videoRecordingButton setAction:@selector(onVideoRecording:)];
        [self addSubview:_videoRecordingButton];
    }
    
    return _videoRecordingButton;
}

- (NSTextField *)videoRecordingLabel {
    if(!_videoRecordingLabel) {
        _videoRecordingLabel = [self frtcCallLabel:NSLocalizedString(@"FM_VIDEO_RECORDING", @"Record") titleColor:[NSColor colorWithString:@"#666666" andAlpha:1.0]];
        [self addSubview:_videoRecordingLabel];
    }
    
    return _videoRecordingLabel;
}

- (CallBarBackGroundView *)videoRecordingBackGroundView {
    if(!_videoRecordingBackGroundView) {
        _videoRecordingBackGroundView = [[CallBarBackGroundView alloc] initWithFrame:NSMakeRect(0, 0, 48, 56)];
        [self addSubview:_videoRecordingBackGroundView];
    }
    
    return _videoRecordingBackGroundView;
}

- (FrtcHoverButton *)videoStreamingButton {
    if(!_videoStreamingButton) {
        _videoStreamingButton = [self frtcCallButton:@"icon_streaming" withOnStatusImagePath:@"icon_stop_streaming"];
        [_videoStreamingButton setAction:@selector(onVideoStreaming:)];
        [self addSubview:_videoStreamingButton];
    }
    
    return _videoStreamingButton;
}

- (NSTextField *)videoStreamingLabel {
    if(!_videoStreamingLabel) {
        _videoStreamingLabel = [self frtcCallLabel:NSLocalizedString(@"FM_VIDEO_STREAMING", @"Live") titleColor:[NSColor colorWithString:@"#666666" andAlpha:1.0]];
        [self addSubview:_videoStreamingLabel];
    }
    
    return _videoStreamingLabel;
}

- (CallBarBackGroundView *)videoStreamingBackGroundView {
    if(!_videoStreamingBackGroundView) {
        _videoStreamingBackGroundView = [[CallBarBackGroundView alloc] initWithFrame:NSMakeRect(0, 0, 48, 56)];
        [self addSubview:_videoStreamingBackGroundView];
    }
    
    return _videoStreamingBackGroundView;
}

- (CallBarBackGroundView *)inviteStreamingBackGroundView {
    if(!_inviteStreamingBackGroundView) {
        _inviteStreamingBackGroundView = [[CallBarBackGroundView alloc] initWithFrame:NSMakeRect(0, 0, 12, 48)];
        [self addSubview:_inviteStreamingBackGroundView];
    }
    
    return _inviteStreamingBackGroundView;
}

- (FrtcHoverButton *)inviteStreamingButton {
    if(!_inviteStreamingButton) {
        _inviteStreamingButton = [self frtcCallButton:@"icon_streaming_url" withOnStatusImagePath:@"icon_streaming_url"];
        _inviteStreamingButton.hidden = YES;
        _inviteStreamingBackGroundView.hidden = YES;
        [_inviteStreamingButton setAction:@selector(onInviteStreamingUrl:)];
        [self addSubview:_inviteStreamingButton];
    }
    
    return _inviteStreamingButton;
}

#pragma mark --Button Sender--
- (void)showNameList:(FrtcHoverButton *)sender {
    if(self.callBarViewDelegate && [self.callBarViewDelegate respondsToSelector:@selector(showNameList)]) {
        [self.callBarViewDelegate showNameList];
    }
}

- (void)frtcDropCall:(FrtcHoverButton *)sender {
    if(self.callBarViewDelegate && [self.callBarViewDelegate respondsToSelector:@selector(endMeeting)]) {
        [self.callBarViewDelegate endMeeting];
    }
}

- (void)enableText:(FrtcHoverButton *)sender {
    if(self.callBarViewDelegate && [self.callBarViewDelegate respondsToSelector:@selector(enableMesage:)]) {
        [self.callBarViewDelegate enableMesage:YES];
    }
}

- (void)disableText:(FrtcHoverButton *)sender {
    if(self.callBarViewDelegate && [self.callBarViewDelegate respondsToSelector:@selector(enableMesage:)]) {
        [self.callBarViewDelegate enableMesage:NO];
    }
}

- (void)showSettingWindow:(FrtcHoverButton *)sender {
    if(self.callBarViewDelegate && [self.callBarViewDelegate respondsToSelector:@selector(showSettingWindow)]) {
        [self.callBarViewDelegate showSettingWindow];
    }
}

- (void)inviteButtonSender:(FrtcHoverButton *)sender {
    if(self.callBarViewDelegate && [self.callBarViewDelegate respondsToSelector:@selector(showMeetingInfo)]) {
        [self.callBarViewDelegate showMeetingInfo];
    }
}

- (void)localVideoMute:(FrtcHoverButton *)sender {
    if(sender.state == NSControlStateValueOn) {
        self.videoMuteLabel.stringValue = NSLocalizedString(@"FM_CLOSE_VIDEO", @"Stop Video");
        [[FrtcCallInterface singletonFrtcCall] videoMute:NO];
        
        self.videoMuteButton.enabled = NO;

        __weak typeof(self) weakSelf = self;
        [NSTimer scheduledTimerWithTimeInterval:1.7 repeats:NO block:^(NSTimer * _Nonnull timer) {
            weakSelf.videoMuteButton.enabled = YES;
        }];
    } else {
        self.videoMuteLabel.stringValue = NSLocalizedString(@"FM_OPEN_VIDEO", @"Start Video");
        [[FrtcCallInterface singletonFrtcCall] videoMute:YES];
    }
}

- (void)frtcMuteLocalAudio:(FrtcHoverButton *)sender {
    BOOL mute;
    if(sender.state == NSControlStateValueOn) {
        mute = NO;
    } else {
        mute = YES;
    }
    
    if(self.callBarViewDelegate && [self.callBarViewDelegate respondsToSelector:@selector(muteAudioByUser:)]) {
        [self.callBarViewDelegate muteAudioByUser:mute];
    }
}

- (void)shareContent:(FrtcHoverButton *)sender {
    if(self.callBarViewDelegate && [self.callBarViewDelegate respondsToSelector:@selector(showContentWindow)]) {
        [self.callBarViewDelegate showContentWindow];
    }
}

- (void)hideLocalView:(FrtcHoverButton *)sender {
    if(sender.state == NSControlStateValueOn) {
        self.localMuteLabel.stringValue = NSLocalizedString(@"FM_MEETING_COLSE_LOCAL_VIEW", @"Stop local view");
        [[FrtcCallInterface singletonFrtcCall] hideLocalView:NO];
    } else {
        self.localMuteLabel.stringValue = NSLocalizedString(@"FM_MEETING_OPEN_LOCAL_VIEW", @"Open local view");
        [[FrtcCallInterface singletonFrtcCall] hideLocalView:YES];
    }
}

- (void)onVideoRecording:(FrtcHoverButton *)sender {
    if(sender.state == NSControlStateValueOn) {
        //self.videoRecordingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_STOP_RECORDING", @"End Record");
        [sender setState:NSControlStateValueOff];
        if(self.callBarViewDelegate && [self.callBarViewDelegate respondsToSelector:@selector(showVideoRecordingWindow:)]) {
            [self.callBarViewDelegate showVideoRecordingWindow:YES];
        }
    } else {
        //self.videoRecordingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_RECORDING", @"Record");
        [sender setState:NSControlStateValueOn];
        if(self.callBarViewDelegate && [self.callBarViewDelegate respondsToSelector:@selector(showVideoRecordingWindow:)]) {
            [self.callBarViewDelegate showVideoRecordingWindow:NO];
        }
    }
}


- (void)onVideoStreaming:(FrtcHoverButton *)sender {
    if(sender.state == NSControlStateValueOn) {
        //self.videoStreamingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_STOP_STREAMING", @"End Live");
        [sender setState:NSControlStateValueOff];
        if(self.callBarViewDelegate && [self.callBarViewDelegate respondsToSelector:@selector(showVideoStreamingWindow:)]) {
            [self.callBarViewDelegate showVideoStreamingWindow:YES];
        }
    } else {
        [sender setState:NSControlStateValueOn];
        //self.videoStreamingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_STREAMING", @"Live");
        if(self.callBarViewDelegate && [self.callBarViewDelegate respondsToSelector:@selector(showVideoStreamingWindow:)]) {
            [self.callBarViewDelegate showVideoStreamingWindow:NO];
        }
    }
}

- (void)onInviteStreamingUrl:(FrtcHoverButton *)sender {
    if(self.callBarViewDelegate && [self.callBarViewDelegate respondsToSelector:@selector(showVideoStreamUrlWindow)]) {
        [self.callBarViewDelegate showVideoStreamUrlWindow];
    }
}

- (void)onSelectVideoDevice:(FrtcHoverButton *)sender {
    if(self.callBarViewDelegate && [self.callBarViewDelegate respondsToSelector:@selector(quickSelectVideoDevice)]) {
        [self.callBarViewDelegate quickSelectVideoDevice];
    }
}

- (void)onSelectAudioDevice:(FrtcHoverButton *)sender {
    if(self.callBarViewDelegate && [self.callBarViewDelegate respondsToSelector:@selector(quickSelectAudioDevice)]) {
        [self.callBarViewDelegate quickSelectAudioDevice];
    }
}

#pragma mark --Class Interface--
- (void)setButtonState:(NSControlStateValue)stateValue {
    if(stateValue == NSControlStateValueOn) {
        [[FrtcCallInterface singletonFrtcCall] audioMute:NO];
    } else {
        [[FrtcCallInterface singletonFrtcCall] audioMute:YES];
    }
}

- (void)setVideoButtonState:(NSControlStateValue)stateValue {
    if(stateValue == NSControlStateValueOn) {
        [[FrtcCallInterface singletonFrtcCall] videoMute:NO];
    } else {
        [[FrtcCallInterface singletonFrtcCall] videoMute:YES];
    }
}

#pragma mark --Internal Function--
- (NSTextField *)frtcCallLabel:(NSString *)stringValue titleColor:(NSColor *)titleColor {
    NSTextField *label = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    label.backgroundColor = [NSColor clearColor];
    label.font = [NSFont systemFontOfSize:10 weight:NSFontWeightMedium];;
    label.alignment = NSTextAlignmentCenter;
    label.textColor = titleColor;
    label.bordered = NO;
    label.editable = NO;
    label.stringValue = stringValue;
    
    return label;
}

- (FrtcHoverButton *)frtcCallButton:(NSString *)offStatusImagePath withOnStatusImagePath:(NSString *)onStatusImagePath {
    FrtcHoverButton *button = [[FrtcHoverButton alloc] init];
    [button setOffStatusImagePath:offStatusImagePath];
    [button setOnStatusImagePath:onStatusImagePath];
    [button setTarget:self];
    
    return button;
}

@end
