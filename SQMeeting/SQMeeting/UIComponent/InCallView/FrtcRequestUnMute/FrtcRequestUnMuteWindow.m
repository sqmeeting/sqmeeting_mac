#import "FrtcRequestUnMuteWindow.h"
#import "FrtcMultiTypesButton.h"

@interface FrtcRequestUnMuteWindow ()

@property (nonatomic, assign) NSSize        windowSize;
@property (nonatomic, assign) NSRect        windowFrame;
@property (nonatomic, strong) NSView        *parentView;
@property (nonatomic, assign) BOOL          defaultCenter;

@property (nonatomic, strong) NSTextField   *nameTextField;
@property (nonatomic, strong) NSTextField   *titleTextField;

@property (nonatomic, strong) FrtcMultiTypesButton      *okButton;

@end

@implementation FrtcRequestUnMuteWindow

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
        
        [self setupRequestUnMuteWindow];
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

- (void)setupRequestUnMuteWindow {
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_left).offset(16);
        make.width.mas_lessThanOrEqualTo(108);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.nameTextField.mas_right);
        make.width.mas_lessThanOrEqualTo(108);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
//    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.contentView.mas_centerX);
//        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-16);
//        make.width.mas_equalTo(104);
//        make.height.mas_equalTo(32);
//    }];
}

#pragma mark --lazy load--
- (NSTextField *)nameTextField {
    if (!_nameTextField){
        _nameTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _nameTextField.backgroundColor = [NSColor clearColor];
        _nameTextField.font = [NSFont systemFontOfSize:13 weight:NSFontWeightSemibold];
        _nameTextField.alignment = NSTextAlignmentCenter;
        _nameTextField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
        _nameTextField.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameTextField.bordered = NO;
        _nameTextField.editable = NO;
        _nameTextField.stringValue = @"李美美";
        [self.contentView addSubview:_nameTextField];
    }
    
    return _nameTextField;
}

- (NSTextField *)titleTextField {
    if (!_titleTextField){
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:13 weight:NSFontWeightSemibold];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];;
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.stringValue = NSLocalizedString(@"FM_TOAST_ASK_FOR_UNMUTE", @"ask to unmute");
        [self.contentView addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

@end
