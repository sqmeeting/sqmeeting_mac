#import "FrtcShareContentToolBar.h"
#import "AppDelegate.h"
#import "FrtcDefaultLabel.h"
#import "FrtcBaseImplement.h"
#import "Masonry.h"
#import "FrtcInfoInstance.h"
#import "FrtcMediaStaticsView.h"
#import "CallBarBackGroundView.h"

@interface FrtcShareContentToolBar () <HoverImageViewDelegate>

@property (nonatomic, strong) FrtcDefaultLabel  *timeLabel;

@property (nonatomic, strong) FrtcMediaStaticsView *staticsView;

@end

@implementation FrtcShareContentToolBar

- (NSRect)toolBarRect {
    NSApplication* app = [NSApplication sharedApplication];
    NSWindow* mainWindow = ((AppDelegate*)(app.delegate)).window;
    CGFloat menuHeight = [[app mainMenu] menuBarHeight];
    
    NSScreen* screen = [mainWindow screen];
    NSSize size = screen.frame.size;
    NSPoint origin = screen.frame.origin;
    
    NSRect windowRect = NSMakeRect(origin.x + size.width/2 - TOOL_BAR_WIDTH/2, origin.y + size.height - TOOL_BAR_HEIGHT - menuHeight, TOOL_BAR_WIDTH, TOOL_BAR_HEIGHT);
    
    return windowRect;
}

- (void)dealloc {
    [self removeNotificationObserver];
}

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)windowStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)deferCreation {
    NSRect windowRect = [self toolBarRect];
    self = [super initWithContentRect:windowRect
                            styleMask:(0)
                              backing:NSBackingStoreBuffered defer:YES];
    
    if (self) {
        [self setUpViews];
        
        [self makeKeyAndOrderFront:NSApp];
        [self setLevel: NSFloatingWindowLevel];
        [self orderOut:nil];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUpateRosterNumber:) name:FMeetingUpdateRosterNumberNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMeterKey:) name:FrtcMeetingAudioMeterNotification object:nil];
    }
    
    return self;
}

- (void)setUpViews {
    [self setUpBackgrounds];
    [self configLayout];
}

- (void)setUpBackgrounds {
    [self setAlphaValue:1.0f];
    [self.contentView setAutoresizesSubviews:YES];
    self.contentView.wantsLayer = YES;
    self.contentView.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
    self.contentView.layer.cornerRadius = 2.0f;
    self.contentView.layer.masksToBounds = NO;
}

-(void)onUpateRosterNumber:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSString *rosterNumber = [userInfo valueForKey:FMeetingRosterNumberKey];
    self.rosterNumberTextField.stringValue = rosterNumber;
}

- (void)onMeterKey:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSNumber *audioMeterLevel = [userInfo valueForKey:FrtcMeetingAudioMeteKey];
    
    float meter = [audioMeterLevel floatValue];
  
    if(meter > 0.000 && meter <= 0.100) {
        [self updateAudioLever:0];
    } else if(meter > 0.000 && meter <= 0.25) {
        [self updateAudioLever:1];
    } else if(meter > 0.25 && meter <= 0.5) {
        [self updateAudioLever:2];
    } else if(meter > 0.5  && meter <= 0.75) {
        [self updateAudioLever:3];
    } else if(meter > 0.75 && meter <= 01 ) {
        [self updateAudioLever:4];
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

- (void)reLayout {
    self.contentView.layer.backgroundColor = [NSColor colorWithString:@"#333333" andAlpha:0.8].CGColor;
    self.nameTextField.textColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0];
    self.timeTextField.textColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0];
    self.inviteStreamingBackGroundView.hidden = YES;
    
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_left).offset(60);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
    
    [self.timeTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(14);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    self.nameTextField.hidden = YES;
}

- (void)reBackLayout {
    self.contentView.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
    
    self.nameTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
    self.timeTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
    
    [self.timeTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.timeTextField.mas_centerY);
        make.right.mas_equalTo(self.timeTextField.mas_left).offset(-14);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
    
    self.nameTextField.hidden = YES;
    [self.nameTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.timeTextField.mas_centerY);
        make.left.mas_equalTo(self.timeTextField.mas_right).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)configLayout {
    [self.timeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.timeTextField.mas_centerY);
        make.right.mas_equalTo(self.timeTextField.mas_left).offset(-14);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
    
    self.nameTextField.hidden = YES;
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.timeTextField.mas_centerY);
        make.left.mas_equalTo(self.timeTextField.mas_right).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.muteAudioButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(40);
        make.left.mas_equalTo(34);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.muteAudioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(68);
        make.centerX.mas_equalTo(self.muteAudioButton.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.selectAudioDeviceBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.muteAudioButton.mas_centerY);
        make.left.mas_equalTo(self.muteAudioButton.mas_right).offset(5);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(48);
    }];
    
    [self.selectAudioDeviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.muteAudioButton.mas_centerY);
        make.centerX.mas_equalTo(self.selectAudioDeviceBackGroundView.mas_centerX);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(8);
    }];
    
    [self.videoMuteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(40);
        make.left.mas_equalTo(self.muteAudioButton.mas_right).offset(52);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.videoMuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(68);
        make.centerX.mas_equalTo(self.videoMuteButton.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.selectVideoDeviceBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.videoMuteButton.mas_centerY);
        make.left.mas_equalTo(self.videoMuteButton.mas_right).offset(5);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(48);
    }];
    
    [self.selectVideoDeviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.videoMuteButton.mas_centerY);
        make.centerX.mas_equalTo(self.selectVideoDeviceBackGroundView.mas_centerX);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(8);
    }];
        
    [self.inviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(40);
        make.left.mas_equalTo(self.videoMuteButton.mas_right).offset(52);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.inviteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(68);
        make.centerX.mas_equalTo(self.inviteButton.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.nameListButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(40);
        make.left.mas_equalTo(self.inviteButton.mas_right).offset(52);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.rosterNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(43);
        make.left.mas_equalTo(self.nameListButton.mas_right);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.nameListLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(68);
        make.centerX.mas_equalTo(self.nameListButton.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.callSettingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(40);
        make.left.mas_equalTo(self.nameListButton.mas_right).offset(52);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.callSettingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(68);
        make.centerX.mas_equalTo(self.callSettingButton.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.dropCallButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(40);
        make.left.mas_equalTo(self.callSettingButton.mas_right).offset(52);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];

    [self.dropCallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(68);
        make.centerX.mas_equalTo(self.dropCallButton.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)basicLayout {
    [self.enableTextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(40);
        make.left.mas_equalTo(self.nameListButton.mas_right).offset(52);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.enableTexttLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(68);
        make.centerX.mas_equalTo(self.enableTextButton.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.disableTextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(40);
        make.left.mas_equalTo(self.enableTextButton.mas_right).offset(52);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [self.disableTexttLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(68);
        make.centerX.mas_equalTo(self.disableTextButton.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)updateLayout:(BOOL)isAuthority meetingOwner:(BOOL)isMeetingOwner {
    if((isAuthority && isMeetingOwner) || (isAuthority && !isMeetingOwner)) {
        [self basicLayout];
        
        self.enableTexttLabel.hidden = NO;
        self.enableTextButton.hidden = NO;
        self.disableTexttLabel.hidden = NO;
        self.disableTextButton.hidden = NO;
        
        BOOL enableLab = [[FrtcUserDefault defaultSingleton] boolObjectForKey:ENABLE_LAB_FEATURE];
        if(!enableLab) {
            self.videoStreamingLabel.hidden  = YES;
            self.videoStreamingButton.hidden = YES;
            
            self.videoRecordingLabel.hidden  = YES;
            self.videoRecordingButton.hidden = YES;
            
            self.inviteStreamingBackGroundView.hidden = YES;
            self.inviteStreamingButton.hidden = YES;
            
            [self.callSettingButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView.mas_top).offset(40);
                make.left.mas_equalTo(self.disableTextButton.mas_right).offset(52);
                make.width.mas_equalTo(28);
                make.height.mas_equalTo(28);
            }];
            
            [self.callSettingLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView.mas_top).offset(68);
                make.centerX.mas_equalTo(self.callSettingButton.mas_centerX);
                make.width.mas_greaterThanOrEqualTo(0);
                make.height.mas_greaterThanOrEqualTo(0);
            }];

        } else {
            self.videoStreamingButton.hidden = NO;
            self.videoStreamingLabel.hidden  = NO;
            
            self.videoRecordingLabel.hidden  = NO;
            self.videoRecordingButton.hidden = NO;
            
//            self.inviteStreamingBackGroundView.hidden = NO;
//            self.inviteStreamingButton.hidden = NO;
            
            [self.videoRecordingButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView.mas_top).offset(40);
                make.left.mas_equalTo(self.disableTextButton.mas_right).offset(52);
                make.width.mas_equalTo(28);
                make.height.mas_equalTo(28);
            }];
            
            [self.videoRecordingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView.mas_top).offset(68);
                make.centerX.mas_equalTo(self.videoRecordingButton.mas_centerX);
                make.width.mas_greaterThanOrEqualTo(0);
                make.height.mas_greaterThanOrEqualTo(0);
            }];
            
            [self.videoStreamingButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView.mas_top).offset(40);
                make.left.mas_equalTo(self.videoRecordingButton.mas_right).offset(52);
                make.width.mas_equalTo(28);
                make.height.mas_equalTo(28);
            }];
            
            [self.videoStreamingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView.mas_top).offset(68);
                make.centerX.mas_equalTo(self.videoStreamingButton.mas_centerX);
                make.width.mas_greaterThanOrEqualTo(0);
                make.height.mas_greaterThanOrEqualTo(0);
            }];
            
            [self.inviteStreamingBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.videoStreamingButton.mas_centerY);
                make.left.mas_equalTo(self.videoStreamingButton.mas_right).offset(3);
                make.width.mas_equalTo(12);
                make.height.mas_equalTo(48);
            }];
            
            [self.inviteStreamingButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.videoStreamingButton.mas_centerY);
                make.centerX.mas_equalTo(self.inviteStreamingBackGroundView.mas_centerX);
                make.width.mas_equalTo(8);
                make.height.mas_equalTo(8);
            }];
            
            [self.callSettingButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView.mas_top).offset(40);
                make.left.mas_equalTo(self.videoStreamingButton.mas_right).offset(52);
                make.width.mas_equalTo(28);
                make.height.mas_equalTo(28);
            }];
            
            [self.callSettingLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView.mas_top).offset(68);
                make.centerX.mas_equalTo(self.callSettingButton.mas_centerX);
                make.width.mas_greaterThanOrEqualTo(0);
                make.height.mas_greaterThanOrEqualTo(0);
            }];
        }
    } else if(!isAuthority && isMeetingOwner) {
        self.enableTexttLabel.hidden = NO;
        self.enableTextButton.hidden = NO;
        self.disableTexttLabel.hidden = NO;
        self.disableTextButton.hidden = NO;
        
        [self.enableTextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(40);
            make.left.mas_equalTo(self.nameListButton.mas_right).offset(52);
            make.width.mas_equalTo(28);
            make.height.mas_equalTo(28);
        }];
        
        [self.enableTexttLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(68);
            make.centerX.mas_equalTo(self.enableTextButton.mas_centerX);
            make.width.mas_greaterThanOrEqualTo(0);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
        
        [self.disableTextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(40);
            make.left.mas_equalTo(self.enableTextButton.mas_right).offset(52);
            make.width.mas_equalTo(28);
            make.height.mas_equalTo(28);
        }];
        
        [self.disableTexttLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(68);
            make.centerX.mas_equalTo(self.disableTextButton.mas_centerX);
            make.width.mas_greaterThanOrEqualTo(0);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
        
        BOOL enableLab = [[FrtcUserDefault defaultSingleton] boolObjectForKey:ENABLE_LAB_FEATURE];
        if(!enableLab) {
            self.videoStreamingLabel.hidden  = YES;
            self.videoStreamingButton.hidden = YES;
            
            self.videoRecordingLabel.hidden  = YES;
            self.videoRecordingButton.hidden = YES;
            
            self.inviteStreamingBackGroundView.hidden = YES;
            self.inviteStreamingButton.hidden = YES;
            
            [self.callSettingButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView.mas_top).offset(40);
                make.left.mas_equalTo(self.disableTextButton.mas_right).offset(52);
                make.width.mas_equalTo(28);
                make.height.mas_equalTo(28);
            }];
            
            [self.callSettingLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView.mas_top).offset(68);
                make.centerX.mas_equalTo(self.callSettingButton.mas_centerX);
                make.width.mas_greaterThanOrEqualTo(0);
                make.height.mas_greaterThanOrEqualTo(0);
            }];

        } else {
            self.videoStreamingButton.hidden = YES;
            self.videoStreamingLabel.hidden  = YES;
            
            self.inviteStreamingBackGroundView.hidden = NO;
            self.inviteStreamingButton.hidden = YES;
            
            self.videoRecordingLabel.hidden  = NO;
            self.videoRecordingButton.hidden = NO;
            
            [self.videoRecordingButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView.mas_top).offset(40);
                make.left.mas_equalTo(self.disableTextButton.mas_right).offset(52);
                make.width.mas_equalTo(28);
                make.height.mas_equalTo(28);
            }];
            
            [self.videoRecordingLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView.mas_top).offset(68);
                make.centerX.mas_equalTo(self.videoRecordingButton.mas_centerX);
                make.width.mas_greaterThanOrEqualTo(0);
                make.height.mas_greaterThanOrEqualTo(0);
            }];
            
            [self.callSettingButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView.mas_top).offset(40);
                make.left.mas_equalTo(self.videoRecordingButton.mas_right).offset(52);
                make.width.mas_equalTo(28);
                make.height.mas_equalTo(28);
            }];
            
            [self.callSettingLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView.mas_top).offset(68);
                make.centerX.mas_equalTo(self.callSettingButton.mas_centerX);
                make.width.mas_greaterThanOrEqualTo(0);
                make.height.mas_greaterThanOrEqualTo(0);
            }];
        }
        
    } else if(!isAuthority && !isMeetingOwner) {
        self.enableTexttLabel.hidden = YES;
        self.enableTextButton.hidden = YES;
        self.disableTexttLabel.hidden = YES;
        self.disableTextButton.hidden = YES;
        
        self.videoStreamingButton.hidden = YES;
        self.videoStreamingLabel.hidden  = YES;
        
        self.inviteStreamingBackGroundView.hidden = YES;
        self.inviteStreamingButton.hidden = YES;
     
        self.videoRecordingLabel.hidden  = YES;
        self.videoRecordingButton.hidden = YES;
        
        [self.callSettingButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(40);
            make.left.mas_equalTo(self.nameListButton.mas_right).offset(52);
            make.width.mas_equalTo(28);
            make.height.mas_equalTo(28);
        }];
        
        [self.callSettingLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(68);
            make.centerX.mas_equalTo(self.callSettingButton.mas_centerX);
            make.width.mas_greaterThanOrEqualTo(0);
            make.height.mas_greaterThanOrEqualTo(0);
        }];
    }
}

- (FrtcDefaultLabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[FrtcDefaultLabel alloc] init];
        [_timeLabel setFont:[NSFont systemFontOfSize:14]];
        [_timeLabel setAlignment:NSTextAlignmentLeft];
        [_timeLabel setTextColor:[NSColor whiteColor]];
        [_timeLabel setSelectable:NO];
        [_timeLabel setEditable:NO];
        [_timeLabel setDrawsBackground:NO];
        [_timeLabel setBordered:NO];
        [_timeLabel setStringValue:@"1:13:45"];
        [[_timeLabel cell] setWraps:NO];
        _timeLabel.layer.backgroundColor = [NSColor clearColor].CGColor;
        [self.contentView addSubview:_timeLabel];
    }
    
    return _timeLabel;
}
#pragma mark - Layout Notification

- (void)removeNotificationObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - show or hide releted windows

- (void)onTopContentBtnClick:(id)object {
    NSWindow *mainWindow = ((AppDelegate *)NSApp.delegate).window;
    [mainWindow makeKeyAndOrderFront:nil];
}

- (void)onStopContentButton:(id)object {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:FMeetingUserStopContentNotification object:nil userInfo:nil];
    });
}

- (BOOL)canBecomeKeyWindow {
    return YES;
}

- (BOOL)canBecomeMainWindow {
    return YES;
}

- (void)frtcDropCall:(FrtcHoverButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:FMeetingUserStopContentNotification object:nil userInfo:nil];
    });
    
    if(self.shareBarDelegate && [self.shareBarDelegate respondsToSelector:@selector(stopShareContent)]) {
        [self.shareBarDelegate stopShareContent];
    }
}

#pragma mark --Button Sender--
- (void)showNameList:(FrtcHoverButton *)sender {
    if(self.shareBarDelegate && [self.shareBarDelegate respondsToSelector:@selector(showRosterWindow)]) {
        [self.shareBarDelegate showRosterWindow];
    }
}

- (void)showSettingWindow:(FrtcHoverButton *)sender {
    if(self.shareBarDelegate && [self.shareBarDelegate respondsToSelector:@selector(showSettingWindow)]) {
        [self.shareBarDelegate showSettingWindow];
    }
}

- (void)inviteButtonSender:(FrtcHoverButton *)sender {
    if(self.shareBarDelegate && [self.shareBarDelegate respondsToSelector:@selector(showSettingWindow)]) {
        [self.shareBarDelegate showMeetingInfo];
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
    if(sender.state == NSControlStateValueOn) {
        self.muteAudioLabel.stringValue = NSLocalizedString(@"FM_MUTE", @"Mute");
        [[FrtcCallInterface singletonFrtcCall] audioMute:NO];
    } else {
        self.muteAudioLabel.stringValue = NSLocalizedString(@"FM_UN_MUTE", @"Unmute");
        [[FrtcCallInterface singletonFrtcCall] audioMute:YES];
    }
}

- (void)enableText:(FrtcHoverButton *)sender {
    if(self.shareBarDelegate && [self.shareBarDelegate respondsToSelector:@selector(showStartOverLayMessage:)]) {
        [self.shareBarDelegate showStartOverLayMessage:YES];
    }
}

- (void)disableText:(FrtcHoverButton *)sender {
    if(self.shareBarDelegate && [self.shareBarDelegate respondsToSelector:@selector(showStartOverLayMessage:)]) {
        [self.shareBarDelegate showStartOverLayMessage:NO];
    }
}

- (void)onVideoRecording:(FrtcHoverButton *)sender {
    if(sender.state == NSControlStateValueOn) {
        //self.videoRecordingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_STOP_RECORDING", @"End Record");
        [sender setState:NSControlStateValueOff];
        if(self.shareBarDelegate && [self.shareBarDelegate respondsToSelector:@selector(showVideoRecordingWindow:)]) {
            [self.shareBarDelegate showVideoRecordingWindow:YES];
        }
    } else {
        //self.videoRecordingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_RECORDING", @"Record");
        [sender setState:NSControlStateValueOn];
        if(self.shareBarDelegate && [self.shareBarDelegate respondsToSelector:@selector(showVideoRecordingWindow:)]) {
            [self.shareBarDelegate showVideoRecordingWindow:NO];
        }
    }
}


- (void)onVideoStreaming:(FrtcHoverButton *)sender {
    if(sender.state == NSControlStateValueOn) {
        //self.videoStreamingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_STOP_STREAMING", @"End Live");
        [sender setState:NSControlStateValueOff];
        if(self.shareBarDelegate && [self.shareBarDelegate respondsToSelector:@selector(showVideoStreamingWindow:)]) {
            [self.shareBarDelegate showVideoStreamingWindow:YES];
        }
    } else {
        [sender setState:NSControlStateValueOn];
        //self.videoStreamingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_STREAMING", @"Live");
        if(self.shareBarDelegate && [self.shareBarDelegate respondsToSelector:@selector(showVideoStreamingWindow:)]) {
            [self.shareBarDelegate showVideoStreamingWindow:NO];
        }
    }
}

- (void)onInviteStreamingUrl:(FrtcHoverButton *)sender {
    if(self.shareBarDelegate && [self.shareBarDelegate respondsToSelector:@selector(showVideoStreamUrlWindow)]) {
        [self.shareBarDelegate showVideoStreamUrlWindow];
    }
}

- (void)onSelectAudioDevice:(FrtcHoverButton *)sender {
    if(self.shareBarDelegate && [self.shareBarDelegate respondsToSelector:@selector(quickSelectAudioDevice)]) {
        [self.shareBarDelegate quickSelectAudioDevice];
    }
}

- (void)onSelectVideoDevice:(FrtcHoverButton *)sender {
    if(self.shareBarDelegate && [self.shareBarDelegate respondsToSelector:@selector(quickSelectVideoDevice)]) {
        [self.shareBarDelegate quickSelectVideoDevice];
    }
}

- (CGFloat)distance {
    NSString * language = [FMLanguageConfig userLanguage] ? : [NSLocale preferredLanguages].firstObject;
    
    if([language hasPrefix:@"en"]) {
        return 62.0;
    } else {
        return 52.0;
    }
}

#pragma mark --HoverImageViewDelegate--
- (void)hoverImageViewClickedwithSenderTag:(NSInteger)tag {
    if(self.shareBarDelegate && [self.shareBarDelegate respondsToSelector:@selector(showStatics)]) {
        [self.shareBarDelegate showStatics];
    }
}

#pragma mark --Lazy Load--
- (NSTextField *)timeTextField {
    if (!_timeTextField) {
        _timeTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _timeTextField.backgroundColor = [NSColor clearColor];
        _timeTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightMedium];
        _timeTextField.alignment = NSTextAlignmentLeft;
        _timeTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _timeTextField.stringValue = @"1:13:45";
        _timeTextField.bordered = NO;
        _timeTextField.editable = NO;
        
        [self.contentView addSubview:_timeTextField];
    }
    
    return _timeTextField;
}

- (NSTextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _nameTextField.backgroundColor = [NSColor clearColor];
        _nameTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightMedium];
        _nameTextField.alignment = NSTextAlignmentLeft;
        _nameTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _nameTextField.stringValue = @"meimeiellie 的会议";
        _nameTextField.bordered = NO;
        _nameTextField.editable = NO;
        
        [self.contentView addSubview:_nameTextField];
    }
    
    return _nameTextField;
}

- (HoverImageView *)imageView {
    if (!_imageView){
        _imageView = [[HoverImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        [_imageView setImage:[NSImage imageNamed:@"icon-network-info"]];
        _imageView.delegate = self;
        _imageView.imageAlignment = NSImageAlignTopLeft;
        _imageView.imageScaling   =  NSImageScaleAxesIndependently;
        [self.contentView addSubview:_imageView];
    }
    
    return _imageView;
}

- (FrtcHoverButton *)muteAudioButton {
    if(!_muteAudioButton) {
        _muteAudioButton = [self frtcCallButton:@"icon-audio-mute" withOnStatusImagePath:@"icon-audio-unmute"];
        [_muteAudioButton setState:NSControlStateValueOn];
        [_muteAudioButton setAction:@selector(frtcMuteLocalAudio:)];
        [self.contentView addSubview:_muteAudioButton];
    }
    
    return _muteAudioButton;
}

- (NSTextField *)muteAudioLabel {
    if(!_muteAudioLabel) {
        _muteAudioLabel = [self frtcCallLabel:NSLocalizedString(@"FM_MUTE", @"Mute") titleColor:[NSColor colorWithString:@"#666666" andAlpha:1.0]];
        [self.contentView addSubview:_muteAudioLabel];
    }
    
    return _muteAudioLabel;
}

- (CallBarBackGroundView *)selectAudioDeviceBackGroundView {
    if(!_selectAudioDeviceBackGroundView) {
        _selectAudioDeviceBackGroundView = [[CallBarBackGroundView alloc] initWithFrame:NSMakeRect(0, 0, 12, 48)];
        [self.contentView addSubview:_selectAudioDeviceBackGroundView];
    }
    
    return _selectAudioDeviceBackGroundView;
}

- (FrtcHoverButton *)selectAudioDeviceButton {
    if(!_selectAudioDeviceButton) {
        _selectAudioDeviceButton = [self frtcCallButton:@"icon_streaming_url" withOnStatusImagePath:@"icon_streaming_url"];
        [_selectAudioDeviceButton setAction:@selector(onSelectAudioDevice:)];
        [self.contentView addSubview:_selectAudioDeviceButton];
    }
    
    return _selectAudioDeviceButton;
}

- (FrtcHoverButton *)inviteButton {
    if(!_inviteButton) {
        _inviteButton = [self frtcCallButton:@"icon-invite" withOnStatusImagePath:@"icon-invite"];
        [_inviteButton setAction:@selector(inviteButtonSender:)];
        [self.contentView addSubview:_inviteButton];
    }
    
    return _inviteButton;
}

- (NSTextField *)inviteLabel {
    if(!_inviteLabel) {
        _inviteLabel = [self frtcCallLabel:NSLocalizedString(@"FM_INVITE", @"Invite") titleColor:[NSColor colorWithString:@"#666666" andAlpha:1.0]];
        [self.contentView addSubview:_inviteLabel];
    }
    
    return _inviteLabel;
}


- (FrtcHoverButton *)nameListButton {
    if(!_nameListButton) {
        _nameListButton = [self frtcCallButton:@"icon-particpants-list" withOnStatusImagePath:@"icon-particpants-list"];
        [_nameListButton setAction:@selector(showNameList:)];
        [self.contentView addSubview:_nameListButton];
    }
    
    return _nameListButton;
}

- (NSTextField *)nameListLabel {
    if(!_nameListLabel) {
        _nameListLabel = [self frtcCallLabel:NSLocalizedString(@"FM_STATISTIC_PARTICIPANT", @"Participants") titleColor:[NSColor colorWithString:@"#666666" andAlpha:1.0]];
        [self.contentView addSubview:_nameListLabel];
    }
    
    return _nameListLabel;
}

- (FrtcHoverButton *)callSettingButton {
    if(!_callSettingButton) {
        _callSettingButton = [self frtcCallButton:@"icon-incall-setting" withOnStatusImagePath:@"icon-incall-setting"];
        [_callSettingButton setAction:@selector(showSettingWindow:)];
        [self.contentView addSubview:_callSettingButton];
    }
    
    return _callSettingButton;
}

- (NSTextField *)callSettingLabel {
    if(!_callSettingLabel) {
        _callSettingLabel = [self frtcCallLabel:NSLocalizedString(@"FM_SETTING", @"Settings") titleColor:[NSColor colorWithString:@"#666666" andAlpha:1.0]];
        [self.contentView addSubview:_callSettingLabel];
    }
    
    return _callSettingLabel;
}


- (FrtcHoverButton *)dropCallButton {
    if(!_dropCallButton) {
        _dropCallButton = [self frtcCallButton:@"icon-stop-content" withOnStatusImagePath:@"icon-stop-content"];
        [_dropCallButton setAction:@selector(frtcDropCall:)];
        [self.contentView addSubview:_dropCallButton];
    }
    
    return _dropCallButton;
}



- (NSTextField *)dropCallLabel {
    if(!_dropCallLabel) {
        _dropCallLabel = [self frtcCallLabel:NSLocalizedString(@"FM_STOP_SHAR", @"Stop Share") titleColor:[NSColor colorWithString:@"#E32726" andAlpha:1.0]];
        [self.contentView addSubview:_dropCallLabel];
    }
    
    return _dropCallLabel;
}

- (FrtcHoverButton *)localMuteButton {
    if(!_localMuteButton) {
        _localMuteButton = [self frtcCallButton:@"icon-localvideo-hidden" withOnStatusImagePath:@"icon-localvideo-unhidden"];
        [_localMuteButton setState:NSControlStateValueOn];
        [self.contentView addSubview:_localMuteButton];
    }
    
    return _localMuteButton;
}

- (NSTextField *)localMuteLabel {
    if(!_localMuteLabel) {
        _localMuteLabel = [self frtcCallLabel:NSLocalizedString(@"FM_MEETING_OPEN_LOCAL_VIEW", @"Open local view") titleColor:[NSColor colorWithString:@"#666666" andAlpha:1.0]];
        [self.contentView addSubview:_localMuteLabel];
    }
    
    return _localMuteLabel;
}

- (FrtcHoverButton *)shareContentButton {
    if(!_shareContentButton) {
        _shareContentButton = [self frtcCallButton:@"icon-new-share-content" withOnStatusImagePath:@"icon-new-share-content"];
       // [_shareContentButton setAction:@selector(shareContent:)];
        [self.contentView addSubview:_shareContentButton];
    }
    
    return _shareContentButton;
}

- (NSTextField *)shareContentLabel {
    if(!_shareContentLabel) {
        _shareContentLabel = [self frtcCallLabel:@"新的共享" titleColor:[NSColor colorWithString:@"#666666" andAlpha:1.0]];
        [self.contentView addSubview:_shareContentLabel];
    }
    
    return _shareContentLabel;
}

- (FrtcHoverButton *)videoMuteButton {
    if(!_videoMuteButton) {
        _videoMuteButton = [self frtcCallButton:@"icon-video-mute" withOnStatusImagePath:@"icon-video-unmute"];
        [_videoMuteButton setAction:@selector(localVideoMute:)];
        [_videoMuteButton setState:NSControlStateValueOn];
        [self.contentView addSubview:_videoMuteButton];
    }
    
    return _videoMuteButton;
}

- (NSTextField *)videoMuteLabel {
    if(!_videoMuteLabel) {
        _videoMuteLabel = [self frtcCallLabel:NSLocalizedString(@"FM_OPEN_VIDEO", @"Start Video") titleColor:[NSColor colorWithString:@"#666666" andAlpha:1.0]];
        [self.contentView addSubview:_videoMuteLabel];
    }
    
    return _videoMuteLabel;
}

- (CallBarBackGroundView *)selectVideoDeviceBackGroundView {
    if(!_selectVideoDeviceBackGroundView) {
        _selectVideoDeviceBackGroundView = [[CallBarBackGroundView alloc] initWithFrame:NSMakeRect(0, 0, 12, 48)];
        [self.contentView addSubview:_selectVideoDeviceBackGroundView];
    }
    
    return _selectVideoDeviceBackGroundView;
}

- (FrtcHoverButton *)selectVideoDeviceButton {
    if(!_selectVideoDeviceButton) {
        _selectVideoDeviceButton = [self frtcCallButton:@"icon_streaming_url" withOnStatusImagePath:@"icon_streaming_url"];
        [_selectVideoDeviceButton setAction:@selector(onSelectVideoDevice:)];
        [self.contentView addSubview:_selectVideoDeviceButton];
    }
    
    return _selectVideoDeviceButton;
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
        [self.contentView addSubview:_rosterNumberTextField];
    }
    
    return _rosterNumberTextField;
}

- (FrtcMediaStaticsView *)staticsView {
    if(!_staticsView) {
        _staticsView = [[FrtcMediaStaticsView alloc] initWithFrame:NSMakeRect(0, 0, 260, 197)];
        //_staticsView.mediaStaticsDelegate = self;
        [self.contentView addSubview:_staticsView];
        _staticsView.hidden = YES;
    }
    
    return _staticsView;
}

- (FrtcHoverButton *)enableTextButton {
    if(!_enableTextButton) {
        _enableTextButton = [self frtcCallButton:@"icon-incall-text" withOnStatusImagePath:@"icon-incall-text"];
        [_enableTextButton setAction:@selector(enableText:)];
        [self.contentView addSubview:_enableTextButton];
    }
    
    return _enableTextButton;;
}

- (NSTextField *)enableTexttLabel {
    if(!_enableTexttLabel) {
        _enableTexttLabel = [self frtcCallLabel:NSLocalizedString(@"FM_MESSAGE_BAR", @"Overlay") titleColor:[NSColor colorWithString:@"#666666" andAlpha:1.0]];
        [self.contentView addSubview:_enableTexttLabel];
    }
    
    return _enableTexttLabel;
}

- (FrtcHoverButton *)disableTextButton {
    if(!_disableTextButton) {
        _disableTextButton = [self frtcCallButton:@"icon-incall-untext" withOnStatusImagePath:@"icon-incall-untext"];
        [_disableTextButton setAction:@selector(disableText:)];
        [self.contentView addSubview:_disableTextButton];
    }
    
    return _disableTextButton;;
}

- (NSTextField *)disableTexttLabel {
    if(!_disableTexttLabel) {
        _disableTexttLabel = [self frtcCallLabel:NSLocalizedString(@"FM_UN_MESSAGE", @"Stop Message") titleColor:[NSColor colorWithString:@"#666666" andAlpha:1.0]];
        [self.contentView addSubview:_disableTexttLabel];
    }
    
    return _disableTexttLabel;
}

- (FrtcHoverButton *)videoRecordingButton {
    if(!_videoRecordingButton) {
        _videoRecordingButton = [self frtcCallButton:@"icon_recording" withOnStatusImagePath:@"icon_stop_recording"];
        [_videoRecordingButton setAction:@selector(onVideoRecording:)];
        [self.contentView addSubview:_videoRecordingButton];
    }
    
    return _videoRecordingButton;
}

- (NSTextField *)videoRecordingLabel {
    if(!_videoRecordingLabel) {
        _videoRecordingLabel = [self frtcCallLabel:NSLocalizedString(@"FM_VIDEO_RECORDING", @"Record") titleColor:[NSColor colorWithString:@"#666666" andAlpha:1.0]];
        [self.contentView addSubview:_videoRecordingLabel];
    }
    
    return _videoRecordingLabel;
}

- (FrtcHoverButton *)videoStreamingButton {
    if(!_videoStreamingButton) {
        _videoStreamingButton = [self frtcCallButton:@"icon_streaming" withOnStatusImagePath:@"icon_stop_streaming"];
        [_videoStreamingButton setAction:@selector(onVideoStreaming:)];
        [self.contentView addSubview:_videoStreamingButton];
    }
    
    return _videoStreamingButton;
}

- (NSTextField *)videoStreamingLabel {
    if(!_videoStreamingLabel) {
        _videoStreamingLabel = [self frtcCallLabel:NSLocalizedString(@"FM_VIDEO_STREAMING", @"Live") titleColor:[NSColor colorWithString:@"#666666" andAlpha:1.0]];
        [self.contentView addSubview:_videoStreamingLabel];
    }
    
    return _videoStreamingLabel;
}

- (CallBarBackGroundView *)inviteStreamingBackGroundView {
    if(!_inviteStreamingBackGroundView) {
        _inviteStreamingBackGroundView = [[CallBarBackGroundView alloc] initWithFrame:NSMakeRect(0, 0, 12, 48)];
        _inviteStreamingBackGroundView.hidden = YES;
        [self.contentView addSubview:_inviteStreamingBackGroundView];
    }
    
    return _inviteStreamingBackGroundView;
}

- (FrtcHoverButton *)inviteStreamingButton {
    if(!_inviteStreamingButton) {
        _inviteStreamingButton = [self frtcCallButton:@"icon_streaming_url" withOnStatusImagePath:@"icon_streaming_url"];
        [_inviteStreamingButton setAction:@selector(onInviteStreamingUrl:)];
        _inviteStreamingButton.hidden = YES;
        [self.contentView addSubview:_inviteStreamingButton];
    }
    
    return _inviteStreamingButton;
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
