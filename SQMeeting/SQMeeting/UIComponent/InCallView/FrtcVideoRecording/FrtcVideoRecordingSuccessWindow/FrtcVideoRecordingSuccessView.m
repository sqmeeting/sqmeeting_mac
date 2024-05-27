#import "FrtcVideoRecordingSuccessView.h"
#import "FrtcMultiTypesButton.h"

@interface FrtcVideoRecordingSuccessView ()

@property (nonatomic, strong) NSTextField   *titleTextField;
@property (nonatomic, strong) NSTextField   *descriptionTextField;

@property (nonatomic, strong) FrtcMultiTypesButton      *okButton;

@end

@implementation FrtcVideoRecordingSuccessView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupVideoRecordingSuccessView];
        self.wantsLayer = YES;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.0;
        self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
       // self.window.isOpaque = NO;
    }
    
    return self;
}

- (void)setupVideoRecordingSuccessView {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.mas_equalTo(self.mas_centerX);
         make.top.mas_equalTo(self.mas_top).offset(16);
         make.width.mas_greaterThanOrEqualTo(0);
         make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.descriptionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.mas_equalTo(self.mas_centerX);
         make.top.mas_equalTo(self.titleTextField.mas_bottom).offset(5);
         make.width.mas_equalTo(212);
         make.height.mas_greaterThanOrEqualTo(0);
     }];
   
    
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-16);
        make.width.mas_equalTo(104);
        make.height.mas_equalTo(32);
    }];
}

#pragma mark --Button Sender--
- (void)onOKBtnPressed {
    //[self close];
    self.hidden = YES;
    
    if(self.closeDelegate && [self.closeDelegate respondsToSelector:@selector(closeByUser)]) {
        [self.closeDelegate closeByUser];
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
        [self addSubview:_titleTextField];
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
        [self addSubview:_descriptionTextField];
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
        [self addSubview:_okButton];
    }
    
    return _okButton;
}

@end
