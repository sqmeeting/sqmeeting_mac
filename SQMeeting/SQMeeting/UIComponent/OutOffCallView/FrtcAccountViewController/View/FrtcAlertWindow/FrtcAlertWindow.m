#import "FrtcAlertWindow.h"
#import "AppDelegate.h"
#import "FrtcMultiTypesButton.h"

@interface FrtcAlertWindow ()

@property (nonatomic, assign) NSSize        windowSize;
@property (nonatomic, assign) NSRect        windowFrame;
@property (nonatomic, strong) NSView        *parentView;
@property (nonatomic, assign) BOOL          defaultCenter;
@property (nonatomic, weak)   AppDelegate   *appDelegate;

@property (nonatomic, strong) NSTextField   *titleTextField;
@property (nonatomic, strong) NSTextField   *descriptionTextField;
@property (nonatomic, strong) NSView        *lineView;
@property (nonatomic, strong) FrtcMultiTypesButton      *okButton;

@end

@implementation FrtcAlertWindow

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
        
        [self setupWindowUI];
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
    NSLog(@"FrtcAlertWindow dealloc");
}

- (void)showWindow {
    self.appDelegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
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

- (void)setupWindowUI {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top).offset(16);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.descriptionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(8);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.descriptionTextField.mas_bottom).offset(14);
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

#pragma mark --Button Sender--
- (void)onOKPressed:(FrtcMultiTypesButton *)sender {
    [self orderOut:nil];
    
    if(self.frtcAlertWindowDelegate && [self.frtcAlertWindowDelegate respondsToSelector:@selector(logoutNotification)]) {
        [self.frtcAlertWindowDelegate logoutNotification];
    }
}

#pragma mark --lazy load--
- (NSTextField *)titleTextField {
    if (!_titleTextField){
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:16 weight:NSFontWeightMedium];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"222222" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.stringValue = NSLocalizedString(@"FM_PASSWORD_CHANGE_OK", @"Password update successfully");
        [self.contentView addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (NSTextField *)descriptionTextField {
    if (!_descriptionTextField) {
        _descriptionTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _descriptionTextField.backgroundColor = [NSColor clearColor];
        _descriptionTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightRegular];
        _descriptionTextField.alignment = NSTextAlignmentCenter;
        _descriptionTextField.textColor = [NSColor colorWithString:@"666666" andAlpha:1.0];
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

- (FrtcMultiTypesButton *)okButton {
    if(!_okButton) {
        _okButton = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 120, 48) withTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK")];
        _okButton.target = self;
        _okButton.layer.cornerRadius = 4.0;
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
        _okButton.action = @selector(onOKPressed:);
        [self.contentView addSubview:_okButton];
    }
    
    return _okButton;
}

@end
