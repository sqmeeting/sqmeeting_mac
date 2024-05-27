#import "FrtcRequestUnMuteDetailCell.h"
#import "StaticsTextField.h"
#import "FrtcMultiTypesButton.h"

@interface FrtcRequestUnMuteDetailCell()

@property (nonatomic, strong) StaticsTextField *nameLabel;

@property (nonatomic, strong) StaticsTextField *statusLabel;

@property (nonatomic, strong) NSImageView *peopleImageView;

@property (nonatomic, strong) FrtcMultiTypesButton      *agreeUnMuteButton;

@property (nonatomic, strong) NSView *lineView;

@end

@implementation FrtcRequestUnMuteDetailCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)init {
    if(self = [super init]) {
        [self configStaticTagTypeCell];
        self.wantsLayer = YES;
    }
    
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if(self = [super initWithFrame:frameRect]) {
        [self configStaticTagTypeCell];
        self.wantsLayer = YES;
    }
    
    return self;
}

- (void)configStaticTagTypeCell {
    [self.peopleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(16);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.peopleImageView.mas_right).offset(8);
        make.width.mas_equalTo(216);
        make.height.mas_equalTo(20);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(279);
        make.width.mas_equalTo(84);
        make.height.mas_equalTo(20);
    }];
    
    [self.agreeUnMuteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(-16);
        make.width.mas_equalTo(47.67);
        make.height.mas_equalTo(24);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(self.mas_left);
        make.width.mas_equalTo(448);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark --Class Interface--
- (void)updateCellName:(NSString *)name {
    NSLog(@"------update Cell Name is %@--------", name);
    self.nameLabel.stringValue = name;
}

#pragma mark -- Button Senser--
- (void)onAgreeUnMutePressed {
    if(self.delegate && [self.delegate respondsToSelector:@selector(agreeUnMuteWithRow:)]) {
        [self.delegate agreeUnMuteWithRow:self.row];
    }
}

- (StaticsTextField *)textField1 {
    StaticsTextField *testField = [[StaticsTextField alloc] init];
    testField.font = [NSFont systemFontOfSize:13 weight:NSFontWeightMedium];
    testField.backgroundColor = [NSColor clearColor];
    testField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
    testField.editable = NO;
    testField.bordered = NO;
    
    testField.alignment = NSTextAlignmentLeft;
        
    return testField;
}

- (StaticsTextField *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [self textField1];
        _nameLabel.stringValue = @"limeimei12444424536400000012345";
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_nameLabel];
    }
    
    return _nameLabel;
}

- (StaticsTextField *)statusLabel {
    if(!_statusLabel) {
        _statusLabel = [self textField1];
        _statusLabel.stringValue = NSLocalizedString(@"FM_ASK_FOR_UN_MUTE", @"Unmute");
        [self addSubview:_statusLabel];
    }
    
    return _statusLabel;
}

- (NSImageView *)peopleImageView {
    if (!_peopleImageView) {
        _peopleImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_peopleImageView setImage:[NSImage imageNamed:@"icon_unmute_people"]];
        _peopleImageView.imageAlignment =  NSImageAlignTopLeft;
        _peopleImageView.imageScaling =  NSImageScaleAxesIndependently;
        [self addSubview:_peopleImageView];
    }
    
    return _peopleImageView;
}

- (FrtcMultiTypesButton *)agreeUnMuteButton {
    if (!_agreeUnMuteButton) {
        _agreeUnMuteButton = [[FrtcMultiTypesButton alloc] initSixWithFrame:CGRectMake(0, 0, 0, 0) withTitle:NSLocalizedString(@"FM_ASK_FOR_UN_MUTE_AGREE", @"Agree")];
        _agreeUnMuteButton.target = self;
        _agreeUnMuteButton.action = @selector(onAgreeUnMutePressed);
        
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_ASK_FOR_UN_MUTE_AGREE", @"Agree")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"026FFE" andAlpha:1.0] range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14] range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
        [attrTitle fixAttributesInRange:range];
        [_agreeUnMuteButton setAttributedTitle:attrTitle];
        _agreeUnMuteButton.layer.cornerRadius = 4.0f;
        _agreeUnMuteButton.layer.borderWidth = 1.0;
        _agreeUnMuteButton.layer.masksToBounds = YES;
        _agreeUnMuteButton.layer.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] whiteColor].CGColor;
        _agreeUnMuteButton.layer.borderColor = [NSColor colorWithString:@"#CCCCCC" andAlpha:1.0].CGColor;
        [self addSubview:_agreeUnMuteButton];
    }
    
    return _agreeUnMuteButton;
}

- (NSView *)lineView {
    if(!_lineView) {
        _lineView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 1, 448)];
        _lineView.wantsLayer = YES;
        _lineView.layer.backgroundColor = [NSColor colorWithString:@"#D7DADD" andAlpha:1].CGColor;
        [self addSubview:_lineView];
    }
    
    return _lineView;
}
    
@end
