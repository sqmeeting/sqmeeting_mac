#import "FrtcTitleBarView.h"

@interface FrtcTitleBarView () <TitleBarButtonDelegate>

@property (strong, nonatomic) NSTextField *timeDurationLabel;

@property (assign, nonatomic) NSInteger i;

@property (strong, nonatomic) NSTimer   *meetingTimer;

@property (assign, getter=isFullScreen) BOOL fullScreen;

@end

@implementation FrtcTitleBarView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)init {
    self = [super init];
    
    if(self) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor colorWithString:@"#F8F9FA" andAlpha:1.0].CGColor;
        
        [self titleBarViewLayout];
        [self startMeetingDurationTimer];
    }
    
    return self;
}

- (void)fullScreenState:(NSInteger)state {
    NSInteger fullScreenState = state;
    if(fullScreenState == 1) {
        self.fullScreen = YES;
        self.fullScreenButton.title.stringValue = NSLocalizedString(@"FM_EXIT_FULL_SCREEN_WINDOW", @"Exit Full Screen");
        
        NSFont *font             = [NSFont systemFontOfSize:12.0f];
        NSDictionary *attributes = @{ NSFontAttributeName:font };
        CGSize size              = [NSLocalizedString(@"FM_EXIT_FULL_SCREEN_WINDOW", @"Exit Full Screen") sizeWithAttributes:attributes];
        [self.fullScreenButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(size.width + 30);
            make.height.mas_equalTo(size.height + 10);
        }];
    } else {
        self.fullScreen = NO;
        self.fullScreenButton.title.stringValue = NSLocalizedString(@"FM_ENTER_FULL_SCREEN_WINDOW", @"Full Screen");
        
        NSFont *font             = [NSFont systemFontOfSize:12.0f];
        NSDictionary *attributes = @{ NSFontAttributeName:font };
        CGSize size              = [NSLocalizedString(@"FM_ENTER_FULL_SCREEN_WINDOW", @"Full Screen") sizeWithAttributes:attributes];
        [self.fullScreenButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(size.width + 30);
            make.height.mas_equalTo(size.height + 10);
        }];
    }
    if(self.titleBarViewDelegate && [self.titleBarViewDelegate respondsToSelector:@selector(enterFullScreen:)]) {
        [self.titleBarViewDelegate enterFullScreen:self.isFullScreen];
    }
}

- (void)handleTimeInterval {
    _i ++;
    NSTimeInterval timeInterval = (double)(self.i);
    int hour = (int)(timeInterval/3600);
    NSString *_hour;
    if(hour < 10) {
        _hour = [NSString stringWithFormat:@"0%d", hour];
    } else {
        _hour = [NSString stringWithFormat:@"%d", hour];
    }

    int minute = (int)(timeInterval - hour*3600)/60;
    NSString *_minute;
    if(minute < 10) {
        _minute = [NSString stringWithFormat:@"0%d", minute];
    } else {
        _minute = [NSString stringWithFormat:@"%d", minute];
    }
    
    int second = timeInterval - hour*3600 - minute*60;
    NSString *_second;
    if(second < 10) {
        _second = [NSString stringWithFormat:@"0%d", second];
    } else {
        _second = [NSString stringWithFormat:@"%d", second];
    }

    NSString *dural;
    if(hour == 0) {
        dural = [NSString stringWithFormat:@"%@:%@", _minute,_second];
    } else {
        dural = [NSString stringWithFormat:@"%@:%@:%@",_hour, _minute,_second];
    }
    
    self.timeDurationLabel.stringValue = dural;
}

- (void)startMeetingDurationTimer {
    self.timeDurationLabel.stringValue = @"00:00";
    _i = 0;
    [self startMeetingTimer:1];
}

- (void)cancelMeetingDurationTimer {
    if(_meetingTimer != nil) {
        [_meetingTimer invalidate];
        _meetingTimer = nil;
    }
}

- (void)startMeetingTimer:(NSTimeInterval)timeInterval {
    self.meetingTimer = [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(handleTimeInterval) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.meetingTimer forMode:NSRunLoopCommonModes];
}

- (void)titleBarViewLayout {
    [self.timeDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.infoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(84);
        make.height.mas_equalTo(24);
    }];
    
    NSFont *font1             = [NSFont systemFontOfSize:12.0f];
    NSDictionary *attributes1 = @{ NSFontAttributeName:font1 };
    CGSize size1              = [NSLocalizedString(@"FM_MEETING_INFO", @"Meeting info") sizeWithAttributes:attributes1];
    
    [self.infoButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(size1.width + 30);
        make.height.mas_equalTo(size1.height + 10);
    }];
    
    [self.networkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.infoButton.mas_right).offset(4);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(84);
        make.height.mas_equalTo(24);
    }];
    
    [self.fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(24);
    }];
    
    NSFont *font             = [NSFont systemFontOfSize:12.0f];
    NSDictionary *attributes = @{ NSFontAttributeName:font };
    CGSize size              = [NSLocalizedString(@"FM_ENTER_FULL_SCREEN_WINDOW", @"Full Screen") sizeWithAttributes:attributes];

    [self.fullScreenButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(size.width + 30);
        make.height.mas_equalTo(size.height + 10);
    }];
    
    [self.gridModeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.fullScreenButton.mas_left).offset(-8);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(24);
    }];
    
 
    size = [self.gridModeButton.title.stringValue  sizeWithAttributes:attributes];

    [self.gridModeButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.fullScreenButton.mas_left).offset(-8);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(size.width + 30);
        make.height.mas_equalTo(size.height + 10);
    }];
}

- (void)updateGridModeButtonLayout:(NSString *)str {
    NSFont *font             = [NSFont systemFontOfSize:12.0f];
    NSDictionary *attributes = @{ NSFontAttributeName:font };
    
    CGSize size = [str sizeWithAttributes:attributes];

    [self.gridModeButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.fullScreenButton.mas_left).offset(-8);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(size.width + 30);
        make.height.mas_equalTo(size.height + 10);
    }];
}

#pragma mark --TitleBarButtonDelegate--
- (void)titleBarButtonClicked:(TitleBarButtonType)type {
    if(type == TitleBarButtonGirdMode) {
        if(self.titleBarViewDelegate && [self.titleBarViewDelegate respondsToSelector:@selector(openGridModeView)]) {
            [self.titleBarViewDelegate openGridModeView];
        }
    } else if(type == TitleBarButtonEnterFullScreen) {
        if(self.isFullScreen) {
            self.fullScreen = NO;
            self.fullScreenButton.title.stringValue = NSLocalizedString(@"FM_ENTER_FULL_SCREEN_WINDOW", @"Full Screen");
            
            NSFont *font             = [NSFont systemFontOfSize:12.0f];
            NSDictionary *attributes = @{ NSFontAttributeName:font };
            CGSize size              = [NSLocalizedString(@"FM_ENTER_FULL_SCREEN_WINDOW", @"Full Screen") sizeWithAttributes:attributes];

            [self.fullScreenButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-12);
                make.centerY.mas_equalTo(self.mas_centerY);
                make.width.mas_equalTo(size.width + 30);
                make.height.mas_equalTo(size.height + 10);
            }];
        } else {
            self.fullScreen = YES;
            self.fullScreenButton.title.stringValue = NSLocalizedString(@"FM_EXIT_FULL_SCREEN_WINDOW", @"Exit Full Screen");
            
            NSFont *font             = [NSFont systemFontOfSize:12.0f];
            NSDictionary *attributes = @{ NSFontAttributeName:font };
            CGSize size              = [NSLocalizedString(@"FM_EXIT_FULL_SCREEN_WINDOW", @"Exit Full Screen") sizeWithAttributes:attributes];
            
            [self.fullScreenButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-12);
                make.centerY.mas_equalTo(self.mas_centerY);
                make.width.mas_equalTo(size.width + 30);
                make.height.mas_equalTo(size.height + 10);
            }];
        }
        
        if(self.titleBarViewDelegate && [self.titleBarViewDelegate respondsToSelector:@selector(enterFullScreen:)]) {
            [self.titleBarViewDelegate enterFullScreen:self.fullScreen];
        }
    } else if(type == TitleBarButtonExitFullScreen) {
        NSLog(@"TitleBarButtonExitFullScreen");
    } else if(type == TitleBarButtonGirdMode) {
        if(self.titleBarViewDelegate && [self.titleBarViewDelegate respondsToSelector:@selector(openGridModeView)]) {
            [self.titleBarViewDelegate openGridModeView];
        }
    }
}

- (void)didIntoArea:(BOOL)isInTitleButtonViewArea withSenderType:(TitleBarButtonType)type {
    if(type == TitleBarButtonInfo) {
        if(self.titleBarViewDelegate && [self.titleBarViewDelegate respondsToSelector:@selector(popupMeetingInfo:)]) {
            [self.titleBarViewDelegate popupMeetingInfo:isInTitleButtonViewArea];
        }
    } else if(type == TitleBarButtonNetWork) {
        if(self.titleBarViewDelegate && [self.titleBarViewDelegate respondsToSelector:@selector(popupStaticsInfo:)]) {
            [self.titleBarViewDelegate popupStaticsInfo:isInTitleButtonViewArea];
        }
    }
}

#pragma mark --Lazy Load--
-(NSTextField *)timeDurationLabel {
    if(!_timeDurationLabel) {
        _timeDurationLabel = [[NSTextField alloc] init];
        _timeDurationLabel.editable = NO;
        _timeDurationLabel.bordered = NO;
        _timeDurationLabel.backgroundColor = [NSColor clearColor];
        _timeDurationLabel.alignment = NSTextAlignmentCenter;
        _timeDurationLabel.font = [NSFont systemFontOfSize:12.0];
        _timeDurationLabel.textColor = [NSColor colorWithString:@"#666666" andAlpha:1.0];
        [self addSubview:_timeDurationLabel];
    }
    
    return _timeDurationLabel;
}

- (TitleBarButton *)infoButton {
    if(!_infoButton) {
        _infoButton = [[TitleBarButton alloc] initWithFrame:NSMakeRect(0, 0, 84, 24)];
        _infoButton.title.stringValue = NSLocalizedString(@"FM_MEETING_INFO", @"Meeting info");
        _infoButton.buttonType = TitleBarButtonInfo;
        _infoButton.titleBarButtonDelegate = self;
        [_infoButton.imageView setImage:[NSImage imageNamed:@"icon-meeting-info"]];
        [self addSubview:_infoButton];
    }
    
    return _infoButton;
}

- (TitleBarButton *)networkButton {
    if(!_networkButton) {
        _networkButton = [[TitleBarButton alloc] initWithFrame:NSMakeRect(0, 0, 84, 24)];
        _networkButton.title.stringValue = NSLocalizedString(@"FM_NETWORK_INFO", @"Network");
        _networkButton.buttonType = TitleBarButtonNetWork;
        _networkButton.titleBarButtonDelegate = self;
        [_networkButton.imageView setImage:[NSImage imageNamed:@"icon-network-info"]];
        [self addSubview:_networkButton];
    }
    
    return _networkButton;
}

- (TitleBarButton *)fullScreenButton {
    if(!_fullScreenButton) {
        _fullScreenButton = [[TitleBarButton alloc] initWithFrame:NSMakeRect(0, 0, 84, 24)];
        _fullScreenButton.title.stringValue = NSLocalizedString(@"FM_ENTER_FULL_SCREEN_WINDOW", @"Full Screen");
        _fullScreenButton.buttonType = TitleBarButtonEnterFullScreen;
        _fullScreenButton.titleBarButtonDelegate = self;
        [_fullScreenButton.imageView setImage:[NSImage imageNamed:@"icon-full-screen"]];
        [self addSubview:_fullScreenButton];
    }
    
    return _fullScreenButton;
}

- (TitleBarButton *)gridModeButton {
    if(!_gridModeButton) {
        _gridModeButton = [[TitleBarButton alloc] initWithFrame:NSMakeRect(0, 0, 84, 24)];
        _gridModeButton.title.stringValue = NSLocalizedString(@"FM_GALLERT_MODE", @"Gallery View");
        _gridModeButton.buttonType = TitleBarButtonGirdMode;
        _gridModeButton.titleBarButtonDelegate = self;
        [_gridModeButton.imageView setImage:[NSImage imageNamed:@"icon-grid-mode"]];
        [self addSubview:_gridModeButton];
    }
    
    return _gridModeButton;
}

- (TitleBarButton *)exitModeButton {
    if(!_exitModeButton) {
        _exitModeButton = [[TitleBarButton alloc] initWithFrame:NSMakeRect(0, 0, 84, 24)];
        _exitModeButton.title.stringValue = NSLocalizedString(@"FM_EXIT_FULL_SCREEN_WINDOW", @"Exit Full Screen");
        _exitModeButton.buttonType = TitleBarButtonExitFullScreen;
        _exitModeButton.titleBarButtonDelegate = self;
        [_exitModeButton.imageView setImage:[NSImage imageNamed:@"icon-exit-full-screen"]];
        [self addSubview:_exitModeButton];
    }
    
    return _exitModeButton;
}

@end
