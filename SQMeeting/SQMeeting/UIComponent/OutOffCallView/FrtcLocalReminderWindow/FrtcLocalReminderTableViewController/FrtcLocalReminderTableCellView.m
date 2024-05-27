#import "FrtcLocalReminderTableCellView.h"
#import "FrtcMultiTypesButton.h"

#import "Masonry.h"
#import "NSColor+Utils.h"
#import "NSColor+Enhancement.h"


@interface FrtcLocalReminderTableCellView()

@property (nonatomic, strong) NSView     *backgroundView;
@property (nonatomic, strong) FrtcMultiTypesButton   *joinMeetingButton;
@property (nonatomic, strong) NSView     *lineView;

@end


@implementation FrtcLocalReminderTableCellView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited;
        
        NSRect rect = NSMakeRect(0, 0, 380, 60);
        NSTrackingArea *focusTrackingArea = [[NSTrackingArea alloc] initWithRect:rect
                                                                         options:focusTrackingAreaOptions
                                                                           owner:self
                                                                        userInfo:nil];
        [self addTrackingArea:focusTrackingArea];
        
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor whiteColor].CGColor;
        
        [self configureCellLayout];
    }
    return self;
}


#pragma mark  -- UI views --

- (void)configureCellLayout {
    [self.backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.centerX.mas_equalTo(self.mas_centerX);
        //make.width.mas_equalTo(380-32);
        make.width.mas_equalTo(356); //380
        make.height.mas_equalTo(60);
    }];
    
    [self.reminderImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backgroundView.mas_left).offset(4);
        make.top.mas_equalTo(self.backgroundView.mas_top).offset(14);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.meetingNameTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.reminderImageView.mas_right).offset(8);
        make.top.mas_equalTo(self.backgroundView.mas_top).offset(6);
        make.width.mas_equalTo(240);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.timeAndOwnerTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.reminderImageView.mas_right).offset(8);
        make.top.mas_equalTo(self.meetingNameTextField.mas_bottom).offset(6);
        make.width.mas_equalTo(240);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.joinMeetingButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.backgroundView.mas_right).offset(-4);
        make.top.mas_equalTo(self.backgroundView.mas_top).offset(18);
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(24);
    }];
}

- (void)updateLayout {
    [self.backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.centerX.mas_equalTo(self.mas_centerX);
        //make.width.mas_equalTo(380-32);
        make.width.mas_equalTo(356); //380
        make.height.mas_equalTo(60);
    }];
    
    [self.reminderImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backgroundView.mas_left).offset(4);
        make.top.mas_equalTo(self.backgroundView.mas_top).offset(14);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.meetingNameTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.reminderImageView.mas_right).offset(8);
        make.top.mas_equalTo(self.backgroundView.mas_top).offset(6);
        make.width.mas_equalTo(240);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.timeAndOwnerTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.reminderImageView.mas_right).offset(8);
        make.top.mas_equalTo(self.meetingNameTextField.mas_bottom).offset(6);
        make.width.mas_equalTo(240);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.joinMeetingButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.backgroundView.mas_right).offset(-4);
        make.top.mas_equalTo(self.backgroundView.mas_top).offset(18);
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(24);
    }];
}

#pragma mark --Button Sender--

- (void)onJoinVideoMeetingClicked:(FrtcMultiTypesButton *)sender {
    //NSLog(@"[%s]", __func__);
    if (self.delegate && [self.delegate respondsToSelector:@selector(joinMeetingAtRow:)]) {
        [self.delegate joinMeetingAtRow:self.row];
    }
}

#pragma mark --Lazy getter--

- (NSView *)backgroundView {
    if (!_backgroundView) {
        //_backgroundView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 380 - 32, 60)];
        _backgroundView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 356, 60)];
        _backgroundView.wantsLayer = YES;
        _backgroundView.layer.masksToBounds = YES;
        _backgroundView.layer.cornerRadius = 4.0;
        [self addSubview:_backgroundView];
    }
    return _backgroundView;;
}

- (NSImageView *)reminderImageView {
    if (!_reminderImageView) {
        _reminderImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        _reminderImageView.image = [NSImage imageNamed:@"local_reminder_icon"];
        [self addSubview:_reminderImageView];
    }
    return _reminderImageView;;
}

- (NSTextField *)meetingNameTextField {
    //NSLog(@"[%s]", __func__);
    if (!_meetingNameTextField) {
        _meetingNameTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _meetingNameTextField.backgroundColor = [NSColor clearColor];
        //_meetingNameTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightSemibold];
        _meetingNameTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightMedium];
        _meetingNameTextField.alignment = NSTextAlignmentLeft;
        _meetingNameTextField.lineBreakMode = NSLineBreakByTruncatingTail;
        _meetingNameTextField.maximumNumberOfLines = 1;
        _meetingNameTextField.textColor = [NSColor colorWithString:@"#444444" andAlpha:1.0];
        _meetingNameTextField.editable = NO;
        _meetingNameTextField.bordered = NO;
        _meetingNameTextField.wantsLayer = NO;
        _meetingNameTextField.stringValue = @"会议名称 frtcmeeting";
        
        [self.backgroundView addSubview:_meetingNameTextField];
    }
    return _meetingNameTextField;
}

- (NSTextField *)timeAndOwnerTextField {
    //NSLog(@"[%s]", __func__);
    if (!_timeAndOwnerTextField) {
        _timeAndOwnerTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _timeAndOwnerTextField.backgroundColor = [NSColor clearColor];
        _timeAndOwnerTextField.font = [NSFont systemFontOfSize:13 weight:NSFontWeightMedium];
        _timeAndOwnerTextField.alignment = NSTextAlignmentLeft;
        _timeAndOwnerTextField.lineBreakMode = NSLineBreakByTruncatingTail;
        _timeAndOwnerTextField.maximumNumberOfLines = 1;
        _timeAndOwnerTextField.textColor = [NSColor colorWithString:@"#999999" andAlpha:1.0];
        _timeAndOwnerTextField.editable = NO;
        _timeAndOwnerTextField.bordered = NO;
        _timeAndOwnerTextField.wantsLayer = NO;
        [self.backgroundView addSubview:_timeAndOwnerTextField];
    }
    return _timeAndOwnerTextField;
}

- (FrtcMultiTypesButton *)joinMeetingButton {
    if (!_joinMeetingButton) {
        _joinMeetingButton = [[FrtcMultiTypesButton alloc] initNineWithFrame: CGRectMake(0, 0, 64, 24)
                                                       withTitle: NSLocalizedString(@"FM_JOIN_MEETING", @"Join")
                                                    withFontSize: 12
                                                withCornerRadius: 4];
        _joinMeetingButton.target = self;
        _joinMeetingButton.action = @selector(onJoinVideoMeetingClicked:);
        [self.backgroundView addSubview:_joinMeetingButton];
    }
    return _joinMeetingButton;
}


#pragma mark  -- Mouse Event --

- (void)mouseEntered:(NSEvent *)event {
    //NSLog(@"[%s]", __func__);
    //_mouseIn = YES;
    [[NSCursor pointingHandCursor] set];
    self.layer.backgroundColor = [NSColor colorWithString:@"#F5F6F7" andAlpha:1.0].CGColor;
    
    //[self showFrame];
}

- (void)mouseExited:(NSEvent *)event {
    //NSLog(@"[%s]", __func__);
    // _mouseIn = NO;
    [[NSCursor arrowCursor] set];
    self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
}

- (void)showFrame {
    NSLog(@"[%s]: cell backgroundView.bounds: [%d, %d, %d, %d]", __func__,
          (int)self.backgroundView.bounds.origin.x,
          (int)self.backgroundView.bounds.origin.y,
          (int)self.backgroundView.bounds.size.width,
          (int)self.backgroundView.bounds.size.height);
    
    NSLog(@"[%s]: cell backgroundView.frame: [%d, %d, %d, %d]", __func__,
          (int)self.backgroundView.frame.origin.x,
          (int)self.backgroundView.frame.origin.y,
          (int)self.backgroundView.frame.size.width,
          (int)self.backgroundView.frame.size.height);
}

@end
