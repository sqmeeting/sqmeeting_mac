#import "FrtcVideoRecordingSuccessWindow.h"
#import "FrtcMultiTypesButton.h"

@interface FrtcVideoRecordingSuccessWindow ()

@property (nonatomic, assign) NSSize        windowSize;
@property (nonatomic, assign) NSRect        windowFrame;
@property (nonatomic, strong) NSView        *parentView;
@property (nonatomic, assign) BOOL          defaultCenter;

@property (nonatomic, strong) NSTextField   *titleTextField;
@property (nonatomic, strong) NSTextField   *descriptionTextField;

@property (nonatomic, strong) FrtcMultiTypesButton      *okButton;

@end

@implementation FrtcVideoRecordingSuccessWindow

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
        
        self.contentMaxSize = size;
        self.contentMinSize = size;
        [self setContentSize:size];
        
        [self setupVideoRecordingSuccessWindow];
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
    
    pos.x = window.frame.size.width - self.windowSize.width + pointRelativeToScreen.x -5;
    pos.y = self.windowSize.height + 40;// + pointRelativeToScreen.y;
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

- (void)setupVideoRecordingSuccessWindow {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.mas_equalTo(self.contentView.mas_centerX);
         make.top.mas_equalTo(self.contentView.mas_top).offset(16);
         make.width.mas_greaterThanOrEqualTo(0);
         make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.descriptionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.mas_equalTo(self.contentView.mas_centerX);
         make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(5);
         make.width.mas_equalTo(212);
         make.height.mas_greaterThanOrEqualTo(0);
     }];
   
    
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-16);
        make.width.mas_equalTo(104);
        make.height.mas_equalTo(32);
    }];
}

#pragma mark --Button Sender--
- (void)onOKBtnPressed {
    [self close];
    
    if(self.closedDelegate && [self.closedDelegate respondsToSelector:@selector(closedByUser)]) {
        [self.closedDelegate closedByUser];
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
        _titleTextField.stringValue = NSLocalizedString(@"FM_VIDEO_RECORDING_SUCCESS_TITLE", @"Recording");
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
        _descriptionTextField.stringValue = NSLocalizedString(@"FM_VIDEO_RECORDING_SUCCESS_DESCRIPTION", @"After recording ended, go to “SQ Meeting CE  Webpotal-Meeting Recording” to check recorded files.");
        [self.contentView addSubview:_descriptionTextField];
    }
    
    return _descriptionTextField;
}

- (FrtcMultiTypesButton *)okButton {
    if (!_okButton){
        _okButton = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 158, 36) withTitle:NSLocalizedString(@"FM_VIDEO_RECORDING_SUCCESS_BUTTON", @"Got It")];
        _okButton.target = self;
        _okButton.layer.cornerRadius = 4.0;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_VIDEO_RECORDING_SUCCESS_BUTTON", @"Got It")];
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

@end
