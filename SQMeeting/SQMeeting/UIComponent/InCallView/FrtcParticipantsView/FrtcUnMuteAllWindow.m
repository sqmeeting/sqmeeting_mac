#import "FrtcUnMuteAllWindow.h"

#import "FrtcMultiTypesButton.h"

@interface FrtcUnMuteAllWindow ()

@property (nonatomic, strong) NSTextField *titleTextField;

@property (nonatomic, strong) FrtcMultiTypesButton *muteAllButton;

@property (nonatomic, strong) FrtcMultiTypesButton *cancelButton;

@end

@implementation FrtcUnMuteAllWindow

- (instancetype)initWithSize:(NSSize)size {
    self = [super init];
    
    if(self) {
        self.releasedWhenClosed = NO;
        self.styleMask = self.styleMask | NSWindowStyleMaskFullSizeContentView;
        self.titlebarAppearsTransparent = YES;
        
        self.backgroundColor = [NSColor whiteColor];
        
        [self standardWindowButton:NSWindowZoomButton].enabled = NO;
        [self standardWindowButton:NSWindowCloseButton].enabled = NO;
        [self standardWindowButton:NSWindowMiniaturizeButton].enabled = NO;
        
        [[self standardWindowButton:NSWindowZoomButton] setHidden:YES];
        [[self standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
        [[self standardWindowButton:NSWindowCloseButton] setHidden:YES];
        
        self.contentMaxSize = size;
        self.contentMinSize = size;
        [self setContentSize:size];
        
        [self muteAllWindowlayout];
    }
    
    return self;
}

#pragma mark --Layout--
- (void)muteAllWindowlayout {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top).offset(12);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.muteAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(18);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.muteAllButton.mas_bottom).offset(16);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark --Button Sender--
- (void)onUnMuteAll:(FrtcMultiTypesButton *)sender {
    if(self.unMuteAllDelegate && [self.unMuteAllDelegate respondsToSelector:@selector(unMuteAll)]) {
        [self.unMuteAllDelegate unMuteAll];
    }
    
    [self orderOut:nil];
}

- (void)onCancelBtnPressed:(FrtcMultiTypesButton *)sender {
    [self orderOut:nil];
}

#pragma mark --Lazy Load--
- (NSTextField *)titleTextField {
    if (!_titleTextField){
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightSemibold];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.stringValue = NSLocalizedString(@"FM_UNMUTE_PARTICIPANTS", @"Unmute All");;
        [self.contentView addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (FrtcMultiTypesButton *)muteAllButton {
    if(!_muteAllButton) {
        _muteAllButton = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 240, 40) withTitle:NSLocalizedString(@"FM_MEETING_ASK_UNMUTE", @"Unmute All")];
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_MEETING_ASK_UNMUTE", @"Unmute All")];
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
        [_muteAllButton setAttributedTitle:attrTitle];
        _muteAllButton.target = self;
        _muteAllButton.action = @selector(onUnMuteAll:);
        _muteAllButton.layer.cornerRadius = 4.0f;
        [self.contentView addSubview:_muteAllButton];
    }
    
    return _muteAllButton;
}

- (FrtcMultiTypesButton *)cancelButton {
    if(!_cancelButton) {
        _cancelButton = [[FrtcMultiTypesButton alloc] initSecondaryWithFrame:CGRectMake(0, 0, 0, 0) withTitle:NSLocalizedString(@"FM_CANCEL", @"Cancel")];
        _cancelButton.target = self;
        _cancelButton.action = @selector(onCancelBtnPressed:);
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_CANCEL", @"Cancel")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[[FrtcBaseImplement baseImpleSingleton] baseColor]
                          range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                          range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [_cancelButton setAttributedTitle:attrTitle];
        _cancelButton.layer.cornerRadius = 4.0f;
        [self.contentView addSubview:_cancelButton];
    }
    
    return _cancelButton;
}

@end
