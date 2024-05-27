#import "FrtcEnableMessageWindow.h"
#import "FrtcEnableMessageView.h"
#import "FrtcMeetingManagement.h"

@interface FrtcEnableMessageWindow () <FrtcEnableMessageViewDelegate>

@property (nonatomic, assign) NSSize        windowSize;
@property (nonatomic, assign) NSRect        windowFrame;
@property (nonatomic, strong) NSView        *parentView;
@property (nonatomic, assign) BOOL          defaultCenter;
//@property (nonatomic, weak)   AppDelegate   *appDelegate;

@property (nonatomic, strong) NSTextField *titleTextField;
@property (nonatomic, strong) NSView      *lineView;
@property (nonatomic, strong) FrtcEnableMessageView *messageView;

@end

@implementation FrtcEnableMessageWindow

- (instancetype)initWithSize:(NSSize)size {
    self = [super init];
    
    if(self) {
        self.defaultCenter = YES;
        self.windowSize = size;
        self.releasedWhenClosed = NO;
        
        self.styleMask = self.styleMask | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskClosable;
        self.titlebarAppearsTransparent = YES;
        self.backgroundColor = [NSColor whiteColor];
        [self standardWindowButton:NSWindowZoomButton].enabled = NO;
        [self standardWindowButton:NSWindowCloseButton].enabled = YES;
        [self standardWindowButton:NSWindowMiniaturizeButton].enabled = NO;
        [[self standardWindowButton:NSWindowZoomButton] setHidden:YES];
        [[self standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
        [[self standardWindowButton:NSWindowCloseButton] setHidden:NO];
        
        [self setEnableMessageWindowSetting];
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"FrtcMainWindow dealloc");
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

- (void)adjustToSize:(NSSize)size {
    NSRect frameRelativeToWindow = [self.parentView convertRect:self.parentView.bounds toView:nil];
    NSPoint pointRelativeToScreen = [self.parentView.window convertRectToScreen:frameRelativeToWindow].origin;
    NSPoint pos = NSZeroPoint;
    pos.x = pointRelativeToScreen.x + (self.parentView.bounds.size.width-size.width-self.parentView.frame.origin.x)/2;
    pos.y = pointRelativeToScreen.y + (self.parentView.bounds.size.height-size.height-self.parentView.frame.origin.y)/2;
    [self setFrame:NSMakeRect(0, 0, size.width, size.height) display:YES];
    [self setFrameOrigin:pos];
}

- (void)setEnableMessageWindowSetting {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(400);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_top).offset(1);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.width.mas_equalTo(400);
        make.height.mas_equalTo(357);
    }];
}

- (BOOL)windowShouldClose:(id)sender {
    if(self.messageWindwoDelegate && [self.messageWindwoDelegate respondsToSelector:@selector(cancelMessage)]) {
        [self.messageWindwoDelegate cancelMessage];
    }
    
    return YES;
}

#pragma mark --FrtcEnableMessageViewDelegate--
- (void)enableScroll:(BOOL)scroll {
    if(scroll) {
        NSSize size = NSMakeSize(400, 405);
        self.contentMaxSize = size;
        self.contentMinSize = size;
        [self setContentSize:size];
      
        [self.messageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.lineView.mas_top).offset(1);
            make.left.mas_equalTo(self.contentView.mas_left);
            make.width.mas_equalTo(400);
            make.height.mas_equalTo(357);
        }];
    } else {
        NSSize size = NSMakeSize(400, 354);
        self.contentMaxSize = size;
        self.contentMinSize = size;
        [self setContentSize:size];
        
        [self.messageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.lineView.mas_top).offset(1);
            make.left.mas_equalTo(self.contentView.mas_left);
            make.width.mas_equalTo(400);
            make.height.mas_equalTo(306);
        }];
    }
}

- (void)startOverlayMessage:(NSString *)message withRepeat:(NSInteger)repeat withPosition:(NSInteger)position withScroll:(BOOL)isScroll {
    __weak __typeof(self)weakSelf = self;
    
    [[FrtcMeetingManagement sharedFrtcMeetingManagement]
                        frtcMeetingStartOverlayMessage:self.inCallModel.userToken
                                         meetingNumber:self.inCallModel.conferenceNumber
                                      clientIdentifier:self.inCallModel.userIdentifier
                                 overlayMessageContent:message
                                                repeat:repeat
                                              position:position
                                                scroll:isScroll
                         startMessageSuccessfulHandler:^{
                                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                                    if(strongSelf.messageWindwoDelegate && [strongSelf.messageWindwoDelegate respondsToSelector:@selector(startMessageSuccess)]) {
                                        [strongSelf.messageWindwoDelegate startMessageSuccess];
                                    }
                                 } startMessageFailure:^(NSError * _Nonnull error) {
                        }
    ];
}

- (void)cancelMessage {
    if(self.messageWindwoDelegate && [self.messageWindwoDelegate respondsToSelector:@selector(cancelMessage)]) {
        [self.messageWindwoDelegate cancelMessage];
    }
}


#pragma mark --Lazy Load--
- (NSTextField *)titleTextField {
    if (!_titleTextField){
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:16 weight:NSFontWeightMedium];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.stringValue = NSLocalizedString(@"FM_MESSAGE", @"Enable Message");
        [self.contentView addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (NSView *)lineView {
    if(!_lineView) {
        _lineView = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 400, 0.5)];
        _lineView.wantsLayer = YES;
        _lineView.layer.backgroundColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
        [self.contentView addSubview:_lineView];
    }
    
    return _lineView;
}

- (FrtcEnableMessageView *)messageView {
    if(!_messageView) {
        _messageView = [[FrtcEnableMessageView alloc] initWithFrame:CGRectMake(0, 47, 400, 357)];
        _messageView.wantsLayer = YES;
        _messageView.delegate = self;
        _messageView.layer.backgroundColor = [NSColor whiteColor].CGColor;
        [self.contentView addSubview:_messageView];
    }
    
    return _messageView;
}

@end
