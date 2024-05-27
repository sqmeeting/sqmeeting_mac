#import "RosterListTableViewCell.h"

@interface RosterListTableViewCell() <HoverImageViewDelegate>

@end

@implementation RosterListTableViewCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)init {
    if(self = [super init]) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor colorWithString:@"#F8F9FA" andAlpha:1.0].CGColor;
        [self configRosterCellLayout];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMeterKey:) name:FrtcMeetingAudioMeterNotification object:nil];
        
        NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited;
        
        NSRect rect = NSMakeRect(0, 0, 388, 40);
        NSTrackingArea *focusTrackingArea = [[NSTrackingArea alloc] initWithRect:rect
                                                                         options:focusTrackingAreaOptions owner:self userInfo:nil];
        [self addTrackingArea:focusTrackingArea];
    }
    return self;
}

#pragma mark ---Notifiacation Observer
- (void)onMeterKey:(NSNotification *)notification {
    if(self.cellTag != 100) {
        return;
    }
    
    if(self.isAudioMute) {
        return;
    }
    
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
        self.audioMuteStatusImageView.image = [NSImage imageNamed:@"icon_callbar_view_big_0"];
    } else if(meterLevel == 1) {
        self.audioMuteStatusImageView.image = [NSImage imageNamed:@"icon_callbar_view_big_1"];
    } else if(meterLevel == 2) {
        self.audioMuteStatusImageView.image = [NSImage imageNamed:@"icon_callbar_view_big_2"];
    } else if(meterLevel == 3) {
        self.audioMuteStatusImageView.image = [NSImage imageNamed:@"icon_callbar_view_big_3"];
    } else if(meterLevel == 4) {
        self.audioMuteStatusImageView.image = [NSImage imageNamed:@"icon_callbar_view_big_4"];
    }
}

#pragma mark --HoverImageViewDelegate--
- (void)hoverImageViewClickedwithSenderTag:(NSInteger)tag {
    if(self.tableViewCellDelegate && [self.tableViewCellDelegate respondsToSelector:@selector(muteSinglePeopleOrNot)]) {
        [self.tableViewCellDelegate muteSinglePeopleOrNot];
    }
}

#pragma mark --RosterListLayout--
- (void)configRosterCellLayout {
    [self.spliteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top);
        make.width.mas_equalTo(341);
        make.height.mas_equalTo(1);
    }];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(24);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.videoMuteStatusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-24);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    
    [self.audioMuteStatusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.videoMuteStatusImageView.mas_left).offset(-12);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    
    [self.pinStatusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.audioMuteStatusImageView.mas_left).offset(-12);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    
    [self.participantName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(52);
        make.width.mas_equalTo(240);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)updateBKColor:(BOOL)flag {
    if (flag) {
        self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:0.7].CGColor;
    } else {
        self.layer.backgroundColor = [NSColor colorWithString:@"#F8F9FA" andAlpha:1.0].CGColor;
    }
}

- (void)mouseEntered:(NSEvent *)event {
    [self updateBKColor:YES];
}

- (void)mouseExited:(NSEvent *)event {
    [self updateBKColor:NO];
}

#pragma mark -- lazy load--
- (NSImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[HoverImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _headerImageView.delegate = self;
        _headerImageView.image = [NSImage imageNamed:@"icon-header"];
        [self addSubview:_headerImageView];
    }
        
    return _headerImageView;
}

- (NSTextField *) participantName {
    if (!_participantName) {
        _participantName = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _participantName.backgroundColor = [NSColor clearColor];
        _participantName.font = [NSFont systemFontOfSize:14 weight:NSFontWeightRegular];
        _participantName.alignment = NSTextAlignmentLeft;
        _participantName.lineBreakMode = NSLineBreakByTruncatingTail;
        _participantName.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
        _participantName.bordered = NO;
        _participantName.editable = NO;
        _participantName.stringValue = @"参会者 (12)";
        [self addSubview:_participantName];
    }
    
    return _participantName;;
}

- (NSImageView *)audioMuteStatusImageView {
    if (!_audioMuteStatusImageView) {
        _audioMuteStatusImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        _audioMuteStatusImageView.image = [NSImage imageNamed:@"icon-audioIncall-mute"];
        [self addSubview:_audioMuteStatusImageView];
    }
        
    return _audioMuteStatusImageView;
}

- (NSImageView *)videoMuteStatusImageView {
    if (!_videoMuteStatusImageView) {
        _videoMuteStatusImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        _videoMuteStatusImageView.image = [NSImage imageNamed:@"icon-videoIncall-mute"];
        [self addSubview:_videoMuteStatusImageView];
    }
        
    return _videoMuteStatusImageView;
}

- (NSImageView *)pinStatusImageView {
    if (!_pinStatusImageView) {
        _pinStatusImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        _pinStatusImageView.image = [NSImage imageNamed:@"icon_status_pin1"];
        _pinStatusImageView.hidden = YES;
        [self addSubview:_pinStatusImageView];
    }
        
    return _pinStatusImageView;
}

- (NSView *) spliteLine {
    if (!_spliteLine){
        _spliteLine = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 341, 0.5)];
        _spliteLine.wantsLayer = YES;
        _spliteLine.layer.backgroundColor = [NSColor colorWithString:@"#D7DADD" andAlpha:1.0].CGColor;
        [self addSubview:_spliteLine];
    }
    
    return  _spliteLine;
}


@end
