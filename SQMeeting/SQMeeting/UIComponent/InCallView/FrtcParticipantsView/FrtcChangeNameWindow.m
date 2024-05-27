#import "FrtcChangeNameWindow.h"
#import "FrtcMultiTypesButton.h"
#import "AppDelegate.h"
#import "FrtcSecureTextField.h"
#import "FrtcDefaultTextField.h"
#import "FrtcBorderTextField.h"
#import "CallResultReminderView.h"
#import "NumberLimiteFormatter.h"

@interface FrtcChangeNameWindow () <NSTextFieldDelegate>

@property (nonatomic, assign) NSSize        windowSize;
@property (nonatomic, assign) NSRect        windowFrame;
@property (nonatomic, strong) NSView        *parentView;
@property (nonatomic, assign) BOOL          defaultCenter;
@property (nonatomic, weak)   AppDelegate   *appDelegate;

@property (nonatomic, strong) FrtcDefaultTextField   *titleTextField;
@property (nonatomic, strong) NSView        *lineView;
@property (nonatomic, strong) NSView        *secondLineView;
@property (nonatomic, strong) FrtcMultiTypesButton      *okButton;
@property (nonatomic, strong) FrtcMultiTypesButton      *cancleButton;

@property (nonatomic, strong) FrtcDefaultTextField     *oldNameText;


@property (nonatomic, strong) FrtcBorderTextField *reminderConferenceTextField;
@property (nonatomic, strong) NSImageView   *reminderConferenceImageView;

@property (nonatomic, strong) CallResultReminderView *reminderView;

@end

@implementation FrtcChangeNameWindow

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
    NSLog(@"FrtcInputPasswordWindow dealloc");
}

#pragma mark -- NSTextField delegate --
- (void)controlTextDidChange:(NSNotification *)obj {
    NSString *temp = [self.oldNameText.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([temp length] != 0) {
        printf("\nnormal");
        self.okButton.enabled = YES;
    } else {
        printf("\nall of them is whitespace");
        self.okButton.enabled = NO;
    }
}

- (void)setOldName:(NSString *)oldName {
    self.oldNameText.stringValue = oldName;
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

- (void)setupWindowUI {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.width.mas_equalTo(192);
        make.height.mas_equalTo(40);
    }];
    
    [self.oldNameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(4);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    
    [self.reminderConferenceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(self.contentView.mas_left).offset(17);
         make.top.mas_equalTo(self.oldNameText.mas_bottom).offset(11);
         make.width.mas_equalTo(12);
         make.height.mas_equalTo(12);
     }];
    
    [self.reminderConferenceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.mas_equalTo(self.reminderConferenceImageView.mas_centerY);
         make.left.mas_equalTo(self.reminderConferenceImageView.mas_right).offset(3);
         make.width.mas_greaterThanOrEqualTo(0);
         make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.top.mas_equalTo(self.oldNameText.mas_bottom).offset(16);
        make.width.mas_equalTo(240);
        make.height.mas_equalTo(1);
    }];
    
    [self.secondLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(120);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(0);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(48);
    }];
    
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.secondLineView.mas_left);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(1);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(48);
    }];
    
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.secondLineView.mas_right);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(1);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(48);
    }];
}

- (void)displayToast {
    self.reminderConferenceImageView.hidden = NO;
    self.reminderConferenceTextField.hidden = NO;
}

#pragma mark --Button Sender--
- (void)onInputPasscodePressed:(FrtcMultiTypesButton *)sender {
    NSString *temp = [self.oldNameText.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(self.changeNameDelegate && [self.changeNameDelegate respondsToSelector:@selector(changeName:)]) {
        [self.changeNameDelegate changeName:temp];
    }
    
    [self orderOut:nil];
}

- (void)onCanclePressed:(FrtcMultiTypesButton *)sender {
    [self orderOut:nil];
}

#pragma mark --lazy load--
- (FrtcDefaultTextField *)titleTextField {
    if (!_titleTextField){
        _titleTextField = [[FrtcDefaultTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:16 weight:NSFontWeightMedium];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"333333" andAlpha:1.0];
        _titleTextField.editable = NO;
        _titleTextField.bordered = NO;
        _titleTextField.wantsLayer = NO;
        _titleTextField.stringValue = NSLocalizedString(@"FM_CHANGE_NAME", @"Change Name");
        [self.contentView addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (FrtcDefaultTextField *)oldNameText {
    if (!_oldNameText){
        _oldNameText = [[FrtcDefaultTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _oldNameText.tag = 102;
        _oldNameText.delegate = self;
        _oldNameText.placeholderString = NSLocalizedString(@"FM_PLEASE_NAME", @"Please input your name");
        _oldNameText.layer.borderColor = [NSColor colorWithString:@"#CCCCCC" andAlpha:1.0].CGColor;
        
        NumberLimiteFormatter *formatter = [[NumberLimiteFormatter alloc] init];
        [formatter setMaximumLength:48];
        [_oldNameText setFormatter:formatter];
        [self.contentView addSubview:_oldNameText];
    }
    
    return _oldNameText;
}

- (NSView *)lineView {
    if(!_lineView) {
        _lineView = [[NSView alloc] initWithFrame:CGRectMake(0, 108, 281, 1)];
        _lineView.wantsLayer = YES;
        _lineView.layer.backgroundColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
        [self.contentView addSubview:_lineView];
    }
    
    return _lineView;
}

- (NSView *)secondLineView {
    if(!_secondLineView) {
        _secondLineView = [[NSView alloc] initWithFrame:CGRectMake(140, 109, 1, 48)];
        _secondLineView.wantsLayer = YES;
        _secondLineView.layer.backgroundColor = [NSColor colorWithString:@"#DEDEDE" andAlpha:1.0].CGColor;
        [self.contentView addSubview:_secondLineView];
    }
    
    return _secondLineView;
}

- (FrtcBorderTextField *)reminderConferenceTextField {
    if (!_reminderConferenceTextField) {
        _reminderConferenceTextField = [[FrtcBorderTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _reminderConferenceTextField.backgroundColor = [NSColor clearColor];
        _reminderConferenceTextField.font = [NSFont systemFontOfSize:12 weight:NSFontWeightMedium];
        _reminderConferenceTextField.alignment = NSTextAlignmentLeft;
        _reminderConferenceTextField.textColor = [NSColor colorWithString:@"666666" andAlpha:1.0];
        _reminderConferenceTextField.bordered = NO;
        _reminderConferenceTextField.editable = NO;
        _reminderConferenceTextField.stringValue = NSLocalizedString(@"FM_PWD_INVALID", @"Invalid Meeting Password");
        _reminderConferenceTextField.hidden = YES;
        [self.contentView addSubview:_reminderConferenceTextField];
    }
    
    return _reminderConferenceTextField;
}

- (NSImageView *)reminderConferenceImageView {
    if (!_reminderConferenceImageView) {
        _reminderConferenceImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        [_reminderConferenceImageView setImage:[NSImage imageNamed:@"icon_reminder"]];
        _reminderConferenceImageView.imageAlignment =  NSImageAlignTopLeft;
        _reminderConferenceImageView.imageScaling =  NSImageScaleAxesIndependently;
        _reminderConferenceImageView.hidden = YES;
        [self.contentView addSubview:_reminderConferenceImageView];
    }
    
    return _reminderConferenceImageView;
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
        _okButton.action = @selector(onInputPasscodePressed:);
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

- (CallResultReminderView *)reminderView {
    if(!_reminderView) {
        _reminderView = [[CallResultReminderView alloc] initWithFrame:CGRectMake(0, 0, 172, 40)];
        _reminderView.tipLabel.stringValue = NSLocalizedString(@"FM_NETWORK_EXCEPTION_REY_TRY", @"Network exception,Please check your network on try re-join");
        _reminderView.hidden = YES;
        
        [self.contentView addSubview:_reminderView];
    }
    
    return _reminderView;
}

@end
