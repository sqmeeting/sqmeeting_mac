#import "FrtcSaveServerAddressWindow.h"
#import "FrtcMultiTypesButton.h"

@interface FrtcSaveServerAddressWindow()

@property (nonatomic, assign) NSSize        windowSize;
@property (nonatomic, assign) NSRect        windowFrame;
@property (nonatomic, strong) NSView        *parentView;
@property (nonatomic, assign) BOOL          defaultCenter;

@property (nonatomic, strong) NSTextField   *questionTextField;

@property (nonatomic, strong) FrtcMultiTypesButton      *okButton;
@property (nonatomic, strong) FrtcMultiTypesButton      *cancleButton;

@property (nonatomic, strong) NSView        *lineView;
@property (nonatomic, strong) NSView        *secondLineView;

@end

@implementation FrtcSaveServerAddressWindow

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
        
        [self layoutSaveServerAddressWindow];
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

- (void)showWindowWithWindow:(NSWindow *)window
              withSaveAction:(FrtcSaveServerAddressActionHandler)saveAction
            withCancelAction:(FrtcSaveServerAddressCancelActionHandler)cancelSaveAction {
    
    self.saveActionHandler = saveAction;
    self.cancelSaveActionHandler = cancelSaveAction;
    
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

#pragma mark --layout--
- (void)layoutSaveServerAddressWindow {
    [self.descriptionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.top.mas_equalTo(16);
        make.width.mas_equalTo(272);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.questionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.descriptionTextField.mas_bottom).offset(8);
        make.left.mas_equalTo(14);
        make.width.mas_equalTo(232);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-48);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(1);
    }];

    [self.secondLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(150);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(0);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(48);
    }];

    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.secondLineView.mas_left);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(1);
        make.width.mas_equalTo(149.5);
        make.height.mas_equalTo(48);
    }];

    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.secondLineView.mas_right);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(1);
        make.width.mas_equalTo(149.5);
        make.height.mas_equalTo(48);
    }];
}

#pragma mark --Button Sender--
- (void)onOKPressed:(FrtcMultiTypesButton *)sener {
    self.saveActionHandler();
    [self close];
}

- (void)onCanclePressed:(FrtcMultiTypesButton *)sender {
    self.cancelSaveActionHandler();
    [self close];
}

#pragma mark --Lazy Load--
- (NSTextField *)descriptionTextField {
    if(!_descriptionTextField) {
        _descriptionTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _descriptionTextField.backgroundColor = [NSColor clearColor];
        _descriptionTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightMedium];
        _descriptionTextField.alignment = NSTextAlignmentLeft;
        _descriptionTextField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
        _descriptionTextField.stringValue = NSLocalizedString(@"FM_COMPARE_SERVER_DESCRIPTION", @"The server address \"%@\" of this meeting is different from  the default address. Save it as the default address?");
        _descriptionTextField.bordered = NO;
        _descriptionTextField.editable = NO;
        [self.contentView addSubview:_descriptionTextField];
    }
    
    return _descriptionTextField;
}

- (NSTextField *)questionTextField {
    if(!_questionTextField) {
        _questionTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _questionTextField.backgroundColor = [NSColor clearColor];
        _questionTextField.font = [NSFont systemFontOfSize:12 weight:NSFontWeightRegular];
        _questionTextField.alignment = NSTextAlignmentLeft;
        _questionTextField.textColor = [NSColor colorWithString:@"#666666" andAlpha:1.0];
        _questionTextField.stringValue = NSLocalizedString(@"FM_QUESTION_DESCRIPTION", @"If you have any questions, please contact the administrator.");
        _questionTextField.bordered = NO;
        _questionTextField.editable = NO;
        [self.contentView addSubview:_questionTextField];
    }
    
    return _questionTextField;
}


- (NSView *)lineView {
    if(!_lineView) {
        _lineView = [[NSView alloc] initWithFrame:CGRectMake(0, 117, 262, 1)];
        _lineView.wantsLayer = YES;
        _lineView.layer.backgroundColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
        [self.contentView addSubview:_lineView];
    }
    
    return _lineView;
}

- (NSView *)secondLineView {
    if(!_secondLineView) {
        _secondLineView = [[NSView alloc] initWithFrame:CGRectMake(131, 116, 1, 48)];
        _secondLineView.wantsLayer = YES;
        _secondLineView.layer.backgroundColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
        [self.contentView addSubview:_secondLineView];
    }
    
    return _secondLineView;
}


- (FrtcMultiTypesButton *)okButton {
    if(!_okButton) {
        _okButton = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 141, 48) withTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK")];
        _okButton.hover = NO;
        _okButton.target = self;
        _okButton.layer.maskedCorners = NO;
        _okButton.bordered = NO;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_BUTTON_OK", @"OK")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"026FFE" andAlpha:1.0]
                          range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                          range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [_okButton setAttributedTitle:attrTitle];
        _okButton.layer.backgroundColor = [NSColor whiteColor].CGColor;
        _okButton.layer.borderColor = [NSColor colorWithString:@"#B6B6B6" andAlpha:1.0].CGColor;
        _okButton.action = @selector(onOKPressed:);
        [self.contentView addSubview:_okButton];
    }
    
    return _okButton;
}

- (FrtcMultiTypesButton *)cancleButton {
    if(!_cancleButton) {
        _cancleButton = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 141, 48) withTitle:NSLocalizedString(@"FM_CANCEL", @"Cancel")];
        _cancleButton.hover = NO;
        _cancleButton.target = self;
        //_cancleButton.layer.cornerRadius = 0.0;
        _cancleButton.layer.maskedCorners = NO;
        _cancleButton.bordered = NO;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_CANCEL", @"Cancel")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#666666" andAlpha:1.0]
                          range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                          range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [_cancleButton setAttributedTitle:attrTitle];
        _cancleButton.layer.backgroundColor = [NSColor whiteColor].CGColor;
        _cancleButton.action = @selector(onCanclePressed:);
        _cancleButton.layer.borderColor = [NSColor colorWithString:@"#B6B6B6" andAlpha:1.0].CGColor;
        [self.contentView addSubview:_cancleButton];
    }
    
    return _cancleButton;
}



@end
