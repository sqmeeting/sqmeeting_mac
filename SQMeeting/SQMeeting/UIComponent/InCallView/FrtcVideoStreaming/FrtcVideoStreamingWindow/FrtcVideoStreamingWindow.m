#import "FrtcVideoStreamingWindow.h"
#import "FrtcMultiTypesButton.h"

@interface FrtcVideoStreamingWindow () <NSTextFieldDelegate>

@property (nonatomic, assign) NSSize        windowSize;
@property (nonatomic, assign) NSRect        windowFrame;
@property (nonatomic, strong) NSView        *parentView;
@property (nonatomic, assign) BOOL          defaultCenter;

@property (nonatomic, strong) NSTextField   *titleTextField;
@property (nonatomic, strong) NSTextField   *descriptionTextField;

@property (nonatomic, strong) FrtcMultiTypesButton      *okButton;
@property (nonatomic, strong) FrtcMultiTypesButton      *cancelButton;

@property (nonatomic, strong) NSButton      *enableStreamingPasswordBtn;
@property (nonatomic, strong) NSTextField   *detailText;

@end

@implementation FrtcVideoStreamingWindow

- (instancetype)initWithSize:(NSSize)size {
    self = [super init];
    if (self) {
        self.defaultCenter = YES;
        self.windowSize = size;
        self.releasedWhenClosed = NO;
        
        [self setMovable:NO];
        self.titlebarAppearsTransparent = YES;
        self.backgroundColor = [NSColor colorWithString:@"FFFFFF" andAlpha:1.0];
        self.styleMask = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskFullSizeContentView;
        [[self standardWindowButton:NSWindowZoomButton] setHidden:YES];
        [[self standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
        [[self standardWindowButton:NSWindowCloseButton] setHidden:YES];
        
        [self setupVideoRecordingWindow];
    }
    
    return self;
}

- (instancetype)initWithFrame:(NSRect)rect {
    self = [super init];
    if (self) {
        self.defaultCenter = NO;
        self.windowFrame = rect;
        self.windowSize = rect.size;
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"FrtcInputPasswordWindow dealloc");
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

- (void)setupVideoRecordingWindow {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.mas_equalTo(self.contentView.mas_centerX);
         make.top.mas_equalTo(self.contentView.mas_top).offset(24);
         make.width.mas_greaterThanOrEqualTo(0);
         make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.descriptionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.mas_equalTo(self.contentView.mas_centerX);
         make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(10);
         make.width.mas_equalTo(332);
         make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.enableStreamingPasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.descriptionTextField.mas_bottom).offset(15);
        make.left.mas_equalTo(26);
        make.width.mas_greaterThanOrEqualTo(84);
        make.height.mas_greaterThanOrEqualTo(20);
     }];
    
    [self.detailText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.enableStreamingPasswordBtn.mas_bottom).offset(8);
        make.left.mas_equalTo(26);
        make.width.mas_equalTo(429);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
   
    
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-78);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-24);
        make.width.mas_equalTo(104);
        make.height.mas_equalTo(32);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(78);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-24);
        make.width.mas_equalTo(104);
        make.height.mas_equalTo(32);
    }];
}

#pragma mark --Internal Function--
- (NSString *)getVerificationCode {
    NSArray *strArr = [[NSArray alloc]initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",nil] ;
    NSMutableString *getStr = [[NSMutableString alloc]initWithCapacity:5];
    for(int i = 0; i < 6; i++) {
        int index = arc4random() % ([strArr count]);  //得到数组中随机数的下标
        [getStr appendString:[strArr objectAtIndex:index]];
        
    }
    NSLog(@"验证码:%@",getStr);

    return getStr;
}

#pragma mark --Button Sender--
- (void)onOKBtnPressed {
    NSString *password;
    if(self.enableStreamingPasswordBtn.state == NSControlStateValueOn) {
        password = [self getVerificationCode];
    } else {
        password = @"";
    }
    if(self.startVideoStreamingDelegate && [self.startVideoStreamingDelegate respondsToSelector:@selector(startVideoStreamingWithPassword:)]) {
        [self.startVideoStreamingDelegate startVideoStreamingWithPassword:password];
    }
    
    [self close];
}

- (void)onCancelBtnPressed {
    if(self.startVideoStreamingDelegate && [self.startVideoStreamingDelegate respondsToSelector:@selector(cancelVideoStreaming)]) {
        [self.startVideoStreamingDelegate cancelVideoStreaming];
    }
    
    [self close];
}

- (void)enableStreamingPassword:(NSButton *)sender {
    if(sender.state == NSControlStateValueOn) {
        [[FrtcUserDefault defaultSingleton] setBoolObject:YES forKey:ENABLE_STREAM_PASSWORD];
    } else {
        [[FrtcUserDefault defaultSingleton] setBoolObject:NO forKey:ENABLE_STREAM_PASSWORD];
    }
}

#pragma mark --lazy load--
- (NSTextField *)titleTextField {
    if (!_titleTextField){
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        //_titleTextField.accessibilityClearButton;
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:16 weight:NSFontWeightMedium];
        //_titleTextField.font = [[NSFontManager sharedFontManager] fontWithFamily:@"PingFangSC-Regular" traits:NSBoldFontMask weight:NSFontWeightMedium size:18];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];;
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.stringValue = NSLocalizedString(@"FM_VIDEO_START_STREAMING", @"Start live Stream？");
        [self.contentView addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (NSTextField *)descriptionTextField {
    if (!_descriptionTextField){
        _descriptionTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        //_titleTextField.accessibilityClearButton;
        _descriptionTextField.backgroundColor = [NSColor clearColor];
        _descriptionTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightRegular];
        //_titleTextField.font = [[NSFontManager sharedFontManager] fontWithFamily:@"PingFangSC-Regular" traits:NSBoldFontMask weight:NSFontWeightMedium size:18];
        _descriptionTextField.alignment = NSTextAlignmentLeft;
        _descriptionTextField.maximumNumberOfLines = 0;
        _descriptionTextField.textColor = [NSColor colorWithString:@"#666666" andAlpha:1.0];;
        _descriptionTextField.bordered = NO;
        _descriptionTextField.editable = NO;
        _descriptionTextField.stringValue = NSLocalizedString(@"FM_VIDEO_START_STREAMING_MESSAGE", @"It will live meeting audio, video and shared screen, and inform all members.");
        [self.contentView addSubview:_descriptionTextField];
    }
    
    return _descriptionTextField;
}

#pragma mark --Lazy Load
- (NSButton *)enableStreamingPasswordBtn {
    if (!_enableStreamingPasswordBtn) {
        _enableStreamingPasswordBtn = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, 36, 16)];
        [_enableStreamingPasswordBtn setButtonType:NSButtonTypeSwitch];
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_VIDEO_STREAMING_PASSWORD_BUTTON_TITLE", @"Password protection")];
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
        [_enableStreamingPasswordBtn setAttributedTitle:attrTitle];
        attrTitle = nil;
        [_enableStreamingPasswordBtn setNeedsDisplay:YES];
        
        BOOL enableLab = [[FrtcUserDefault defaultSingleton] boolObjectForKey:ENABLE_STREAM_PASSWORD];
        if (enableLab) {
            [_enableStreamingPasswordBtn setState:NSControlStateValueOn];
        } else {
            [_enableStreamingPasswordBtn setState:NSControlStateValueOff];
        }
    
      
        _enableStreamingPasswordBtn.target = self;
        _enableStreamingPasswordBtn.action = @selector(enableStreamingPassword:);
        [self.contentView addSubview:_enableStreamingPasswordBtn];
    }
    
    return _enableStreamingPasswordBtn;
}

- (NSTextField *)detailText {
    if (!_detailText){
        _detailText = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _detailText.stringValue = NSLocalizedString(@"FM_VIDEO_STREAMING_PASSWORD_DESCRIPTION", @"It will make your live streaming safer");
        _detailText.bordered = NO;
        _detailText.drawsBackground = NO;
        _detailText.backgroundColor = [NSColor clearColor];
        _detailText.textColor = [NSColor colorWithString:@"#999999" andAlpha:1.0];
        _detailText.font = [NSFont fontWithSFProDisplay:12 andType:SFProDisplayRegular];
        _detailText.maximumNumberOfLines = 0;
        _detailText.alignment = NSTextAlignmentLeft;
        _detailText.editable = NO;
        [self.contentView addSubview:_detailText];
    }
    
    return _detailText;
}


- (FrtcMultiTypesButton *)okButton {
    if (!_okButton){
        _okButton = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 158, 36) withTitle:NSLocalizedString(@"FM_VIDEO_START_STREAMING_BUTTON_TITLE", @"Start Live")];
        _okButton.target = self;
        _okButton.layer.cornerRadius = 4.0;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_VIDEO_START_STREAMING_BUTTON_TITLE", @"Start Live")];
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
        [_okButton setAttributedTitle:attrTitle];
        _okButton.action = @selector(onOKBtnPressed);
        [self.contentView addSubview:_okButton];
    }
    
    return _okButton;
}

- (FrtcMultiTypesButton*)cancelButton {
    if (!_cancelButton){
        _cancelButton = [[FrtcMultiTypesButton alloc] initSecondaryWithFrame:CGRectMake(0, 0, 158, 36) withTitle:NSLocalizedString(@"FM_CANCEL", @"Cancel")];
        _cancelButton.target = self;
        _cancelButton.hover = NO;
        _cancelButton.layer.cornerRadius = 4.0;
        _cancelButton.bordered = NO;
        _cancelButton.layer.borderWidth = 0.0;
        _cancelButton.layer.backgroundColor = [NSColor colorWithRed:240/255.0 green:240/255.0 blue:245/255.0 alpha:1.0].CGColor;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_CANCEL", @"Cancel")];
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
        [_cancelButton setAttributedTitle:attrTitle];
        _cancelButton.action = @selector(onCancelBtnPressed);
        [self.contentView addSubview:_cancelButton];
    }
    return _cancelButton;
}

@end
