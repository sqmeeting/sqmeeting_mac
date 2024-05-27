#import "FrtcCancelMeetingWindow.h"
#import "FrtcMultiTypesButton.h"
#import "AppDelegate.h"

@interface FrtcCancelMeetingWindow ()

@property (nonatomic, assign) NSSize        windowSize;

@property (nonatomic, assign) NSRect        windowFrame;

@property (nonatomic, strong) NSView        *parentView;

@property (nonatomic, assign) BOOL          defaultCenter;

@property (nonatomic, weak)   AppDelegate   *appDelegate;


@property (nonatomic, strong) NSTextField   *titleTextField;

@property (nonatomic, strong) NSButton      *cancelMeetingOnOffButton;

@property (nonatomic, strong) FrtcMultiTypesButton      *cancleMeetingButton;

@property (nonatomic, strong) FrtcMultiTypesButton      *notNowcancelMeetingButton;

@property (nonatomic, assign, getter=isCancelAll) BOOL cancelAll;

@end

@implementation FrtcCancelMeetingWindow

- (instancetype)initWithSize:(NSSize)size {
    self = [super init];
    
    if (self) {
        self.defaultCenter = YES;
        self.releasedWhenClosed = NO;
        self.titleVisibility = NSWindowTitleHidden;
        self.windowSize = size;
        [self setMovable:NO];
        self.titlebarAppearsTransparent = YES;
        self.backgroundColor = [NSColor whiteColor];
        self.styleMask =  NSWindowStyleMaskTitled;
        self.contentView.wantsLayer = YES;
        //self.contentView.layer.cornerRadius = 4;
        [[self standardWindowButton:NSWindowZoomButton] setHidden:YES];
        [[self standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
        
        [[self standardWindowButton:NSWindowZoomButton] setHidden:YES];
        [[self standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
        [[self standardWindowButton:NSWindowCloseButton] setHidden:NO];
        
        self.styleMask = self.styleMask | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskClosable;
        self.titlebarAppearsTransparent = YES;
        self.backgroundColor = [NSColor whiteColor];
        [self standardWindowButton:NSWindowZoomButton].enabled = NO;
        [self standardWindowButton:NSWindowCloseButton].enabled = YES;
        
        [self standardWindowButton:NSWindowZoomButton].enabled = NO;
        [self standardWindowButton:NSWindowCloseButton].enabled = YES;
        [self standardWindowButton:NSWindowMiniaturizeButton].enabled = NO;
        [[self standardWindowButton:NSWindowZoomButton] setHidden:YES];
        [[self standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
        [[self standardWindowButton:NSWindowCloseButton] setHidden:NO];
        [self setupCancelMeetingWindowUI];
    }
    
    return self;
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
    
    //[self.meetingIDText.window makeFirstResponder:nil];
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
    
    [self setParentView:view];
    [self makeKeyAndOrderFront:self.parentWindow];
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
//    if(self.frtcCallWindowdelegate && [self.frtcCallWindowdelegate respondsToSelector:@selector(closeWindow)]) {
//        [self.frtcCallWindowdelegate closeWindow];
//    }
    [super orderOut:sender];
}

#pragma mark --internal function--
- (void)setupCancelMeetingWindowUI {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top).offset(30);
        //make.width.mas_greaterThanOrEqualTo(0);
        make.width.mas_equalTo(272);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.cancelMeetingOnOffButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(8);
        make.width.mas_greaterThanOrEqualTo(180);
        make.height.mas_greaterThanOrEqualTo(28);
     }];
    
    [self.cancleMeetingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-48);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-24);
        make.width.mas_equalTo(104);
        make.height.mas_equalTo(32);
    }];
    
    [self.notNowcancelMeetingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(48);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-24);
        make.width.mas_equalTo(104);
        make.height.mas_equalTo(32);
    }];
}

#pragma mark --Button Sender--
- (void)onEnableMicphone:(NSButton *)sender {
    if(sender.state == NSControlStateValueOn) {
        self.cancelAll = YES;
    } else {
        self.cancelAll = NO;
    }
}

- (void)onCancelMeetingPressed {
    [self close];
    if(self.cancelMeetingDelegate && [self.cancelMeetingDelegate respondsToSelector:@selector(cancelMeetingWithCancelRecurrence:withReservationID:)]) {
        [self.cancelMeetingDelegate cancelMeetingWithCancelRecurrence:self.isCancelAll withReservationID:self.reservationID];
    }
}

- (void)notCancelMeetingBtnPressed {
    [self close];
}

#pragma mark --Lazy Load--
- (NSTextField *)titleTextField {
    if (!_titleTextField){
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleTextField.font = [NSFont systemFontOfSize:16 weight:NSFontWeightMedium];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.maximumNumberOfLines = 0;
        _titleTextField.stringValue = NSLocalizedString(@"FM_CANCEL_MEETING_SURE", @"Are you sure you want to cancel this meeting?");
        [self.contentView addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (NSButton *)cancelMeetingOnOffButton {
    if (!_cancelMeetingOnOffButton) {
        _cancelMeetingOnOffButton = [self checkButton:NSLocalizedString(@"FM_CANCEL_MEETING_RECURRENCE", @"Cancel the entire series as well") aciton:@selector(onEnableMicphone:)];
        [_cancelMeetingOnOffButton setState:NSControlStateValueOff];
    }
    
    return _cancelMeetingOnOffButton;
}

- (FrtcMultiTypesButton *)cancleMeetingButton {
    if (!_cancleMeetingButton) {
        _cancleMeetingButton = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 158, 36) withTitle:NSLocalizedString(@"FM_MEETING_CANCEL", @"Cancel")];
        _cancleMeetingButton.target = self;
        _cancleMeetingButton.layer.cornerRadius = 4.0;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_MEETING_CANCEL", @"Cancel")];
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
        [_cancleMeetingButton setAttributedTitle:attrTitle];
        _cancleMeetingButton.action = @selector(onCancelMeetingPressed);
        [self.contentView addSubview:_cancleMeetingButton];
    }
    
    return _cancleMeetingButton;
}

- (FrtcMultiTypesButton *)notNowcancelMeetingButton {
    if (!_notNowcancelMeetingButton){
        _notNowcancelMeetingButton = [[FrtcMultiTypesButton alloc] initSecondaryWithFrame:CGRectMake(0, 0, 158, 36) withTitle:NSLocalizedString(@"FM_CANCEL_ABOUT", @"Not Now")];
        _notNowcancelMeetingButton.target = self;
        _notNowcancelMeetingButton.hover = NO;
        _notNowcancelMeetingButton.layer.cornerRadius = 4.0;
        _notNowcancelMeetingButton.bordered = NO;
        _notNowcancelMeetingButton.layer.borderWidth = 0.0;
        _notNowcancelMeetingButton.layer.backgroundColor = [NSColor colorWithRed:240/255.0 green:240/255.0 blue:245/255.0 alpha:1.0].CGColor;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_CANCEL_ABOUT", @"Not Now")];
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
        [_notNowcancelMeetingButton setAttributedTitle:attrTitle];
        _notNowcancelMeetingButton.action = @selector(notCancelMeetingBtnPressed);
        [self.contentView addSubview:_notNowcancelMeetingButton];
    }
    return _notNowcancelMeetingButton;
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
    [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#666666" andAlpha:1.0]
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

@end
