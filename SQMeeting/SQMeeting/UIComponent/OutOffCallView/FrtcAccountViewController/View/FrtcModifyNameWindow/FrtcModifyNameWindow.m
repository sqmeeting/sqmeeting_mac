#import "FrtcModifyNameWindow.h"
#import "AppDelegate.h"
#import "FrtcMultiTypesButton.h"
#import "FrtcDefaultTextField.h"

@interface FrtcModifyNameWindow ()

@property (nonatomic, assign) NSSize        windowSize;
@property (nonatomic, assign) NSRect        windowFrame;
@property (nonatomic, strong) NSView        *parentView;
@property (nonatomic, assign) BOOL          defaultCenter;
@property (nonatomic, weak)   AppDelegate   *appDelegate;

@property (nonatomic, strong) NSTextField   *titleTextField;
@property (nonatomic, strong) FrtcDefaultTextField   *nameText;
@property (nonatomic, strong) FrtcMultiTypesButton      *saveUpdateButton;
@property (nonatomic, strong) FrtcMultiTypesButton      *cancelUpdateButton;

@end

@implementation FrtcModifyNameWindow

- (instancetype)initWithSize:(NSSize)size {
    self = [super init];
    if (self) {
        self.defaultCenter = YES;
        self.windowSize = size;
        self.releasedWhenClosed = NO;
        [self setupModifyNameWindowUI];
    }
    
    return self;
}

- (instancetype)initWithFrame:(NSRect)rect {
    self = [super init];
    if (self) {
        self.defaultCenter = NO;
        self.windowFrame = rect;
        self.windowSize = rect.size;
        [self setupModifyNameWindowUI];
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"FrtcUpdatePasswordWindow dealloc");
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
    
    [self.nameText.window makeFirstResponder:nil];
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

- (void)setupModifyNameWindowUI {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(16);
        make.top.mas_equalTo(self.contentView.mas_top).offset(20);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
  
    [self.nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(16);
        make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(15);
        make.width.mas_equalTo(258);
        make.height.mas_equalTo(36);
    }];

    [self.saveUpdateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-16);
        make.top.mas_equalTo(self.nameText.mas_bottom).offset(24);
        make.width.mas_equalTo(121);
        make.height.mas_equalTo(36);
    }];
    
    [self.cancelUpdateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(16);
        make.top.mas_equalTo(self.nameText.mas_bottom).offset(24);
        make.width.mas_equalTo(121);
        make.height.mas_equalTo(36);
    }];
}

#pragma mark --Class Interface--
- (void)setDisplayName:(NSString *)userName {
    self.nameText.stringValue = userName;
}

#pragma mark --FrtcMultiTypesButton Sender--
- (void)onSaveModifyUserName:(FrtcMultiTypesButton *)sender {
    if(self.modifyNameDelegate && [self.modifyNameDelegate respondsToSelector:@selector(saveDisplayName:)]) {
        [self.modifyNameDelegate saveDisplayName:self.nameText.stringValue];
    }
    
    [self orderOut:nil];
}

- (void)onCancelModifyUserName:(FrtcMultiTypesButton *)sender {
    [self orderOut:nil];
}

#pragma mark --lazy load--
- (NSTextField *)titleTextField {
    if (!_titleTextField){
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        //_titleTextField.accessibilityClearButton;
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:16 weight:NSFontWeightMedium];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"222222" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.stringValue = @"修改入会显示名字";
        [self.contentView addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (FrtcDefaultTextField *)nameText {
    if (!_nameText){
        _nameText = [[FrtcDefaultTextField alloc] initWithFrame:CGRectMake(0, 0, 332, 20)];
        _nameText.tag = 102;
        //_nameText.placeholderString = @"输入您的名字";
        _nameText.layer.borderColor = [NSColor colorWithString:@"#CCCCCC" andAlpha:1.0].CGColor;
        [self.contentView addSubview:_nameText];
    }
    
    return _nameText;
}

- (FrtcMultiTypesButton *)saveUpdateButton {
    if (!_saveUpdateButton) {
        _saveUpdateButton = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 158, 36) withTitle:NSLocalizedString(@"FM_SAVE", @"Save")];
        _saveUpdateButton.target = self;
        _saveUpdateButton.layer.cornerRadius = 4.0;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_SAVE", @"Save")];
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
        [_saveUpdateButton setAttributedTitle:attrTitle];
        _saveUpdateButton.action = @selector(onSaveModifyUserName:);
        [self.contentView addSubview:_saveUpdateButton];
    }
    
    return _saveUpdateButton;
}

- (FrtcMultiTypesButton*)cancelUpdateButton {
    if (!_cancelUpdateButton){
        _cancelUpdateButton = [[FrtcMultiTypesButton alloc] initSecondaryWithFrame:CGRectMake(0, 0, 158, 36) withTitle:NSLocalizedString(@"FM_CANCEL", @"Cancel")];
        _cancelUpdateButton.target = self;
        _cancelUpdateButton.layer.cornerRadius = 4.0;
        _cancelUpdateButton.bordered = NO;
        _cancelUpdateButton.layer.borderWidth = 0.0;
        _cancelUpdateButton.layer.backgroundColor = [NSColor colorWithRed:240/255.0 green:240/255.0 blue:245/255.0 alpha:1.0].CGColor;
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
        [_cancelUpdateButton setAttributedTitle:attrTitle];
        _cancelUpdateButton.action = @selector(onCancelModifyUserName:);
        _cancelUpdateButton.hover = NO;
        [self.contentView addSubview:_cancelUpdateButton];
    }
    return _cancelUpdateButton;
}

@end
