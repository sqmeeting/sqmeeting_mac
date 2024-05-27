#import "FrtcRequestUnMuteView.h"
#import "FrtcMultiTypesButton.h"

@interface FrtcRequestUnMuteView ()

@property (nonatomic, strong) NSTextField   *nameTextField;
@property (nonatomic, strong) NSTextField   *titleTextField;

@property (nonatomic, strong) FrtcMultiTypesButton      *ignoreButton;
@property (nonatomic, strong) FrtcMultiTypesButton      *okButton;

@end

@implementation FrtcRequestUnMuteView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupRequestUnMuteWindow];
        self.wantsLayer = YES;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.0;
        self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
       // self.window.isOpaque = NO;
    }
    
    return self;
}

- (void)setupRequestUnMuteWindow {
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(14);
        make.left.mas_equalTo(self.mas_left).offset(4);
        make.width.mas_lessThanOrEqualTo(108);
        //make.width.mas_equalTo(width);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(14);
        make.left.mas_equalTo(self.nameTextField.mas_right).offset(-5);
        make.right.mas_equalTo(-4);
        //make.width.mas_lessThanOrEqualTo(108);
        make.height.mas_greaterThanOrEqualTo(0);
     }];

    [self.ignoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.bottom.mas_equalTo(-14);
        make.width.mas_equalTo(88);
        make.height.mas_equalTo(24);
    }];
    
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.bottom.mas_equalTo(-14);
        make.width.mas_equalTo(88);
        make.height.mas_equalTo(24);
    }];
}

#pragma mark --Class Interface
- (void)updateRequestName:(NSString *)name {
    self.nameTextField.stringValue = name;
    
    NSString *reminderValue = self.nameTextField.stringValue;
    NSFont *font             = [NSFont systemFontOfSize:13.0f];
    NSDictionary *attributes = @{ NSFontAttributeName:font };
    CGSize size              = [reminderValue sizeWithAttributes:attributes];
    
    CGFloat width;
    if(size.width >= 105) {
        size.width = 105;
        _nameTextField.lineBreakMode = NSLineBreakByTruncatingTail;
        width = 105;
        
        [self.nameTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(14);
            make.left.mas_equalTo(self.mas_left).offset(4);
            make.width.mas_equalTo(width);
            make.height.mas_greaterThanOrEqualTo(0);
         }];
            
        self.titleTextField.hidden = NO;
        [self.titleTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(14);
            make.left.mas_equalTo(self.nameTextField.mas_right).offset(-5);
            make.right.mas_equalTo(-4);
            make.height.mas_greaterThanOrEqualTo(0);
         }];
    } else {
        NSString *string = [NSString stringWithFormat:@"%@%@", name,NSLocalizedString(@"FM_TOAST_ASK_FOR_UNMUTE", @"ask to unmute")];
        
        self.nameTextField.stringValue = string;
        
        [self.nameTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(14);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_greaterThanOrEqualTo(108);
            make.height.mas_greaterThanOrEqualTo(0);
         }];
        
        self.titleTextField.hidden = YES;
    }
}

#pragma mark -- Button Sender --
- (void)onViewRequestPressed:(FrtcMultiTypesButton *)sender {
    if(self.requestUnMuteDelegate && [self.requestUnMuteDelegate respondsToSelector:@selector(viewRequest)]) {
        [self.requestUnMuteDelegate viewRequest];
    }
}

- (void)onIgnoreBtnPressed:(FrtcMultiTypesButton *)sender {
    if(self.requestUnMuteDelegate && [self.requestUnMuteDelegate respondsToSelector:@selector(ignoreRequest)]) {
        [self.requestUnMuteDelegate ignoreRequest];
    }
}

#pragma mark --lazy load--
- (NSTextField *)nameTextField {
    if (!_nameTextField){
        _nameTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _nameTextField.backgroundColor = [NSColor clearColor];
        _nameTextField.font = [NSFont systemFontOfSize:13 weight:NSFontWeightSemibold];
        _nameTextField.alignment = NSTextAlignmentRight;
        _nameTextField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
        //_nameTextField.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameTextField.bordered = NO;
        _nameTextField.editable = NO;
        _nameTextField.stringValue = @"糖七七";
        _nameTextField.maximumNumberOfLines = 1;
        [self addSubview:_nameTextField];
    }
    
    return _nameTextField;
}

- (NSTextField *)titleTextField {
    if (!_titleTextField){
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:13 weight:NSFontWeightSemibold];
        _titleTextField.alignment = NSTextAlignmentLeft;
        _titleTextField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];;
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.stringValue = NSLocalizedString(@"FM_TOAST_ASK_FOR_UNMUTE", @"ask to unmute");
        [self addSubview:_titleTextField];
    }
    
    return _titleTextField;
}


- (FrtcMultiTypesButton *)okButton {
    if (!_okButton){
        _okButton = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 88, 24) withTitle:NSLocalizedString(@"FM_TOAST_BUTTON_MONITOR", @"View")];
        _okButton.target = self;
        _okButton.layer.cornerRadius = 4.0;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_TOAST_BUTTON_MONITOR", @"View")];
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
        _okButton.action = @selector(onViewRequestPressed:);
        [self addSubview:_okButton];
    }
    
    return _okButton;
}

- (FrtcMultiTypesButton*)ignoreButton {
    if (!_ignoreButton){
        _ignoreButton = [[FrtcMultiTypesButton alloc] initSecondaryWithFrame:CGRectMake(0, 0, 88, 24) withTitle:NSLocalizedString(@"FM_TOAST_BUTTON_IGNORE", @"Ignore")];
        _ignoreButton.target = self;
        _ignoreButton.hover = NO;
        _ignoreButton.layer.cornerRadius = 4.0;
        _ignoreButton.bordered = NO;
        _ignoreButton.layer.borderWidth = 0.0;
        _ignoreButton.layer.backgroundColor = [NSColor colorWithRed:240/255.0 green:240/255.0 blue:245/255.0 alpha:1.0].CGColor;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_TOAST_BUTTON_IGNORE", @"Ignore")];
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
        [_ignoreButton setAttributedTitle:attrTitle];
        _ignoreButton.action = @selector(onIgnoreBtnPressed:);
        [self addSubview:_ignoreButton];
    }
    return _ignoreButton;
}

//调整行间距
//- (NSString *)atttibutedStringForString:(NSString *)string  {
//
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//
//    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
//
//    return attributedString;
//
//}

@end
