#import "FrtcAlertMainWindow.h"
#import "AppDelegate.h"
#import "FrtcMultiTypesButton.h"

@interface FrtcAlertAction ()

@property (nullable, nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) FrtcWindowAlertActionStyle style;

@end

@implementation FrtcAlertAction

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(FrtcWindowAlertActionStyle)style handler:(void (^ __nullable)())handler {
    FrtcAlertAction *alertAction = [[FrtcAlertAction alloc] init];
    [alertAction actionWithTitle:title style:style handler:handler];
    
    return alertAction;
}

- (void)actionWithTitle:(nullable NSString *)title style:(FrtcWindowAlertActionStyle)style handler:(void (^ __nullable)())handler {
    self.title = title;
    self.style = style;
    self.alertActionHandler = handler;
}

@end

@interface FrtcAlertMainWindow ()

@property (nonatomic, assign) NSSize        windowSize;
@property (nonatomic, assign) NSRect        windowFrame;
@property (nonatomic, strong) NSView        *parentView;
@property (nonatomic, assign) BOOL          defaultCenter;
@property (nonatomic, weak)   AppDelegate   *appDelegate;

@property (nonatomic, strong) NSTextField   *titleTextField;
@property (nonatomic, strong) NSTextField   *descriptionTextField;
@property (nonatomic, strong) NSView        *lineView;
@property (nonatomic, strong) NSView        *verticalView;
@property (nonatomic, strong) FrtcMultiTypesButton      *okButton;
@property (nonatomic, strong) FrtcMultiTypesButton      *cancleButton;

@property (nonatomic, strong) NSWindow      *currentWindow;

@property (nonatomic, strong) FrtcAlertAction *alertAction;
@property (nonatomic, strong) FrtcAlertAction *alertCancelAction;

@end

@implementation FrtcAlertMainWindow

+ (FrtcAlertMainWindow *)showAlertWindowWithTitle:(NSString *)title withMessage:(NSString *)message preferredStyle:(FrtcWindowAlertStyle)style withCurrentWindow:(NSWindow *)window {
    
    NSSize windowSize;
    if(style == FrtcWindowAlertStyleNoTitle) {
        windowSize = NSMakeSize(239, 128);
    } else {
        windowSize = NSMakeSize(239, 128);
    }
    FrtcAlertMainWindow *alertWindow = [[FrtcAlertMainWindow alloc] initWithSize:windowSize];
    [alertWindow showAlertWindowWithTitle:title withMessage:message preferredStyle:style withCurrentWindow:window];
    
    return alertWindow;
}

+ (FrtcAlertMainWindow *)showAlertWindowWithTitle:(NSString *)title withMessage:(NSString *)message preferredStyle:(FrtcWindowAlertStyle)style withCurrentWindow:(NSWindow *)window withWindowSize:(NSSize)size {
    
    NSSize windowSize;
    if(style == FrtcWindowAlertStyleNoTitle) {
        windowSize = NSMakeSize(239, 128);
    } else {
        windowSize = NSMakeSize(239, 128);
    }
    
    windowSize = size;
    FrtcAlertMainWindow *alertWindow = [[FrtcAlertMainWindow alloc] initWithSize:windowSize];
    [alertWindow showAlertWindowWithTitle:title withMessage:message preferredStyle:style withCurrentWindow:window];
    
    return alertWindow;
}

- (void)showAlertWindowWithTitle:(NSString *)title withMessage:(NSString *)message preferredStyle:(FrtcWindowAlertStyle)style withCurrentWindow:(NSWindow *)currentWindow {
    self.currentWindow                      = currentWindow;
    self.titleTextField.stringValue         = title;
    self.descriptionTextField.stringValue   = message;
    
    if(style == FrtcWindowAlertStyleOnly) {
        [self setupWindowActionStyleOK];
    } else if(style == FrtcWindowAlertStyleNoTitle) {
        [self setupWindowsActionStyleNoTitle];
    } else {
        [self setupWindowAlertStyleDefault];
    }
    
    [self showWindow];
}

- (instancetype)initWithSize:(NSSize)size {
    self = [super init];
    if (self) {
        self.defaultCenter = YES;
        self.windowSize = size;
        self.releasedWhenClosed = NO;
        
        [self setMovable:NO];
        self.titlebarAppearsTransparent = YES;
        self.backgroundColor = [NSColor colorWithString:@"FFFFFF" andAlpha:1.0];
        self.styleMask = NSWindowStyleMaskTitled|NSWindowStyleMaskClosable | NSWindowStyleMaskFullSizeContentView;
        [[self standardWindowButton:NSWindowZoomButton] setHidden:YES];
        [[self standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
        [[self standardWindowButton:NSWindowCloseButton] setHidden:YES];
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"FrtcAlertMainWindow dealloc");
}

- (void)showWindow {
    self.appDelegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
    NSWindow* window = [NSApplication sharedApplication].windows.firstObject;
    window = self.currentWindow;
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

- (void)addAction:(FrtcAlertAction *)action {
    if(action.style == FrtcWindowAlertActionStyleOK) {
        [self.okButton setAttributedTitle:[self attrTitleWithTitleString:action.title withTitleColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0]]];
        self.alertAction = action;
    } else if(action.style == FrtcWindowAlertActionStyleCancle) {
        [self.cancleButton setAttributedTitle:[self attrTitleWithTitleString:action.title withTitleColor:[NSColor colorWithString:@"#666666" andAlpha:1.0]]];
        self.alertCancelAction = action;
    }
}

- (void)addAction:(FrtcAlertAction *)action withTitleColor:(NSColor *)titleColor {
    if(action.style == FrtcWindowAlertActionStyleOK) {
        [self.okButton setAttributedTitle:[self attrTitleWithTitleString:action.title withTitleColor:titleColor]];
        self.alertAction = action;
    } else if(action.style == FrtcWindowAlertActionStyleCancle) {
        [self.cancleButton setAttributedTitle:[self attrTitleWithTitleString:action.title withTitleColor:[NSColor colorWithString:@"#666666" andAlpha:1.0]]];
        self.alertCancelAction = action;
    }
}

#pragma mark --Button Sender--
- (void)onOKPressed:(FrtcMultiTypesButton *)sender {
    self.alertAction.alertActionHandler();
    [self orderOut:nil];
}

- (void)onCanclePressed:(FrtcMultiTypesButton *)sender {
    self.alertCancelAction.alertActionHandler();
    [self orderOut:nil];
}

#pragma mark --layout UI for FrtcWindowAlertActionStyleOK
- (void)setupBasicWindow {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top).offset(16);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.descriptionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(8);
        make.width.mas_equalTo(self.windowSize.width - 10);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(80);
        make.width.mas_equalTo(self.windowSize.width);
        make.height.mas_equalTo(1);
    }];
}

- (void)setupWindowActionStyleOK {
    [self setupBasicWindow];
    
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(0);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(48);
    }];
}

- (void)setupWindowsActionStyleNoTitle {
    [self.descriptionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top).offset(36);
        make.width.mas_equalTo(self.windowSize.width - 10);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    self.descriptionTextField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(80);
        make.width.mas_equalTo(240);
        make.height.mas_equalTo(1);
    }];
    
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(0);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(48);
    }];
}

- (void)setupWindowAlertStyleDefault {
    [self setupBasicWindow];
    
    [self.verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(self.windowSize.width / 2);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(0);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(50);
    }];
    
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(0);
        make.width.mas_equalTo(self.windowSize.width / 2 - 0.5);
        make.height.mas_equalTo(48);
    }];
    
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(0);
        make.width.mas_equalTo(self.windowSize.width / 2 - 0.5);
        make.height.mas_equalTo(48);
    }];
}

- (CGFloat)fontFloatTitle {
    NSString * language = [FMLanguageConfig userLanguage] ? : [NSLocale preferredLanguages].firstObject;
    
    if([language hasPrefix:@"en"]) {
        return 14.0;
    } else {
        return 16.0;
    }
}

- (CGFloat)fontFloatDescription {
    NSString * language = [FMLanguageConfig userLanguage] ? : [NSLocale preferredLanguages].firstObject;
    
    if([language hasPrefix:@"en"]) {
        return 12.0;
    } else {
        return 14.0;
    }
}

#pragma mark --lazy load--
- (NSTextField *)titleTextField {
    if (!_titleTextField){
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:[self fontFloatTitle] weight:NSFontWeightMedium];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.stringValue = NSLocalizedString(@"FM_PASSWORD_CHANGE_OK", @"Password update successfully");;
        [self.contentView addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (NSTextField *)descriptionTextField {
    if (!_descriptionTextField) {
        _descriptionTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _descriptionTextField.backgroundColor = [NSColor clearColor];
        _descriptionTextField.font = [NSFont systemFontOfSize:[self fontFloatDescription] weight:NSFontWeightRegular];
        _descriptionTextField.alignment = NSTextAlignmentCenter;
        _descriptionTextField.textColor = [NSColor colorWithString:@"#666666" andAlpha:1.0];
        _descriptionTextField.bordered = NO;
        _descriptionTextField.editable = NO;
        _descriptionTextField.stringValue = NSLocalizedString(@"FM_PASSWORD_LOGINCHANGE_OK", @"Your password was updated, please login again");;
        [self.contentView addSubview:_descriptionTextField];
    }
    
    return _descriptionTextField;
}

- (NSView *)lineView {
    if(!_lineView) {
        _lineView = [[NSView alloc] initWithFrame:CGRectMake(0, 43, 381, 1)];
        _lineView.wantsLayer = YES;
        _lineView.layer.backgroundColor = [NSColor colorWithString:@"DEDEDE" andAlpha:1.0].CGColor;
        [self.contentView addSubview:_lineView];
    }
    
    return _lineView;
}

- (NSView *)verticalView {
    if(!_verticalView) {
        _verticalView = [[NSView alloc] initWithFrame:CGRectMake(189, 112, 2, 48)];
        _verticalView.wantsLayer = YES;
        _verticalView.layer.backgroundColor = [NSColor colorWithString:@"DEDEDE" andAlpha:1.0].CGColor;
        [self.contentView addSubview:_verticalView];
    }
    
    return _verticalView;
}

- (FrtcMultiTypesButton *)okButton {
    if(!_okButton) {
        _okButton = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 120, 48) withTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK")];
        _okButton.hover = NO;
        _okButton.target = self;
        _okButton.layer.cornerRadius = 4.0;
        _okButton.layer.backgroundColor = [NSColor whiteColor].CGColor;
        _okButton.action = @selector(onOKPressed:);
        [self.contentView addSubview:_okButton];
    }
    
    return _okButton;
}

- (FrtcMultiTypesButton *)cancleButton {
    if(!_cancleButton) {
        _cancleButton = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 141, 48) withTitle:NSLocalizedString(@"FM_CANCEL", @"Cancel")];
        _cancleButton.target = self;
        //_cancleButton.layer.cornerRadius = 0.0;
        _cancleButton.layer.maskedCorners = NO;
        _cancleButton.bordered = NO;
        _cancleButton.hover = NO;
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

#pragma mark --internal function--
- (NSMutableAttributedString *)attrTitleWithTitleString:(NSString *)title withTitleColor:(NSColor *)titleColor {
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:title];
    NSUInteger len = [attrTitle length];
    NSRange range = NSMakeRange(0, len);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attrTitle addAttribute:NSForegroundColorAttributeName value:titleColor
                      range:range];
    [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                      range:range];
    
    [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                      range:range];
    [attrTitle fixAttributesInRange:range];
    
    return attrTitle;
}

@end
