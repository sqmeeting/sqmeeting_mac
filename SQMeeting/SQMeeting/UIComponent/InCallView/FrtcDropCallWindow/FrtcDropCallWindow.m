#import "FrtcDropCallWindow.h"
#import "FrtcButtonMode.h"
#import "FrtcButton.h"

@interface FrtcDropCallWindow ()

@property (nonatomic, strong) FrtcButton *leaveButton;

@property (nonatomic, strong) FrtcButton *endButton;

@property (nonatomic, strong) FrtcButton *cancelButton;

@property (nonatomic, assign) NSSize        windowSize;

@property (nonatomic, assign) NSRect        windowFrame;

@property (nonatomic, strong) NSView        *parentView;

@property (nonatomic, assign) BOOL          defaultCenter;

@end

@implementation FrtcDropCallWindow

- (instancetype)initWithSize:(NSSize)size {
    self = [super init];
    
    if(self) {
        self.defaultCenter = YES;
        self.windowSize = size;
        
        self.releasedWhenClosed = NO;
        self.styleMask = self.styleMask | NSWindowStyleMaskFullSizeContentView;
        self.titlebarAppearsTransparent = YES;
        self.backgroundColor = [NSColor whiteColor];
        [self standardWindowButton:NSWindowZoomButton].enabled = NO;
        [self standardWindowButton:NSWindowCloseButton].enabled = NO;
        [self standardWindowButton:NSWindowMiniaturizeButton].enabled = NO;
        [[self standardWindowButton:NSWindowZoomButton] setHidden:YES];
        [[self standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
        [[self standardWindowButton:NSWindowCloseButton] setHidden:YES];
        self.contentMaxSize = size;
        self.contentMinSize = size;
        [self setContentSize:size];
        
        [self dropCallWindowLayoutWithHeight:size.height];
    }
    
    return self;
}

- (void)showWindowWithWindow:(NSWindow *)window {
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
}

#pragma mark --layout
- (void)dropCallWindowLayoutWithHeight:(CGFloat)height {
    [self.leaveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top).offset(28);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    
    if(height == 180) {
        [self.endButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(self.leaveButton.mas_bottom).offset(17);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(40);
        }];
    
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(self.endButton.mas_bottom).offset(12);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(40);
        }];
    } else {
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(self.leaveButton.mas_bottom).offset(12);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(40);
        }];
    }
}

#pragma mark --FrtcButton Sender--
- (void)onLeaveMeeting:(FrtcButton *)sender {
    if(self.dropCallDelegate && [self.dropCallDelegate respondsToSelector:@selector(leaveMeeting)]) {
        [self.dropCallDelegate leaveMeeting];
    }
    
    [self orderOut:nil];
}

- (void)onEndMeeting:(FrtcButton *)sender {
    if(self.dropCallDelegate && [self.dropCallDelegate respondsToSelector:@selector(endingMeeting)]) {
        [self.dropCallDelegate endingMeeting];
    }
    
    [self orderOut:nil];
}

- (void)onCancelHandle:(FrtcButton *)sender {
    if(self.dropCallDelegate && [self.dropCallDelegate respondsToSelector:@selector(cancelDropCall)]) {
        [self.dropCallDelegate cancelDropCall];
    }
    [self orderOut:nil];
}

#pragma mark --lazy getter--
- (FrtcButton *)leaveButton {
    if(!_leaveButton) {
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_LEAVE_MEETING", @"Leave Meeting") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#026FFE" andAlpha:0.07] andButtonTitle:NSLocalizedString(@"FM_LEAVE_MEETING", @"Leave Meeting") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        _leaveButton = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 200, 40) withNormalMode:normalMode withHoverMode:hoverMode];
        _leaveButton.target = self;
        _leaveButton.action = @selector(onLeaveMeeting:);
        _leaveButton.hoverd = YES;
        
        [self.contentView addSubview:_leaveButton];
    }
    
    return _leaveButton;;
}

- (FrtcButton *)endButton {
    if(!_endButton) {
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#E32726" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#E32726" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_STOP_MEETING", @"End Meeting") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#E32726" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#E32726" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#E32726" andAlpha:0.06] andButtonTitle:NSLocalizedString(@"FM_STOP_MEETING", @"End Meeting") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        _endButton = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 200, 40) withNormalMode:normalMode withHoverMode:hoverMode];
        _endButton.target = self;
        _endButton.action = @selector(onEndMeeting:);
        _endButton.hoverd = YES;
        
        [self.contentView addSubview:_endButton];
    }
    
    return _endButton;;
}

- (FrtcButton *)cancelButton {
    if(!_cancelButton) {
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#333333" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_CANCEL", @"Cancel") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#333333" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_CANCEL", @"Cancel") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        _cancelButton = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 200, 40) withNormalMode:normalMode withHoverMode:hoverMode];
        _cancelButton.target = self;
        _cancelButton.action = @selector(onCancelHandle:);
        _cancelButton.hoverd = NO;
        
        [self.contentView addSubview:_cancelButton];
    }
    
    return _cancelButton;;
}

@end
