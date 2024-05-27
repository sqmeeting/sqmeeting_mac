#import "LabView.h"

@interface LabView ()

@property (nonatomic, strong) NSButton      *enableLabFeatureBtn;

@property (nonatomic, strong) NSTextField   *detailText;

@end

@implementation LabView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)init {
    self = [super init];
    
    if(self) {
        [self configLabView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        [self configLabView];
    }
    
    return self;
}

- (void)configLabView {
    [self.enableLabFeatureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(31);
        make.left.mas_equalTo(26);
        make.width.mas_greaterThanOrEqualTo(84);
        make.height.mas_greaterThanOrEqualTo(20);
     }];
    
    [self.detailText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.enableLabFeatureBtn.mas_bottom).offset(8);
        make.left.mas_equalTo(26);
        make.width.mas_equalTo(429);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
}

#pragma mark --Button Sender--
- (void)enableLabFeature:(NSButton *)sender {
    BOOL enableLabFeature;
    
    if(sender.state == NSControlStateValueOn) {
        [[FrtcUserDefault defaultSingleton] setBoolObject:YES forKey:ENABLE_LAB_FEATURE];
        enableLabFeature = YES;
    } else {
        [[FrtcUserDefault defaultSingleton] setBoolObject:NO forKey:ENABLE_LAB_FEATURE];
        enableLabFeature = NO;
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(enableLabFeature:)]) {
        [self.delegate enableLabFeature:enableLabFeature];
    }
}

#pragma mark --Lazy Load
- (NSButton *)enableLabFeatureBtn {
    if (!_enableLabFeatureBtn) {
        _enableLabFeatureBtn = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, 36, 16)];
        [_enableLabFeatureBtn setButtonType:NSButtonTypeSwitch];
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_SETTING_ENABLE_LIVE_FEATURE", @"Lab Feature")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[[FrtcBaseImplement baseImpleSingleton] baseColor]
                          range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                          range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [_enableLabFeatureBtn setAttributedTitle:attrTitle];
        attrTitle = nil;
        [_enableLabFeatureBtn setNeedsDisplay:YES];
        
        BOOL enableLab = [[FrtcUserDefault defaultSingleton] boolObjectForKey:ENABLE_LAB_FEATURE];
        if (enableLab) {
            [_enableLabFeatureBtn setState:NSControlStateValueOn];
        } else {
            [_enableLabFeatureBtn setState:NSControlStateValueOff];
        }
    
        _enableLabFeatureBtn.target = self;
        _enableLabFeatureBtn.action = @selector(enableLabFeature:);
        [self addSubview:_enableLabFeatureBtn];
    }
    
    return _enableLabFeatureBtn;
}

- (NSTextField *)detailText {
    if (!_detailText){
        _detailText = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _detailText.stringValue = NSLocalizedString(@"FM_SETTING_LIVE_FEATURE_DESCRIPTION", @"After opening, you can experience recording, live broadcast and other experimental functions");
        _detailText.bordered = NO;
        _detailText.drawsBackground = NO;
        _detailText.backgroundColor = [NSColor clearColor];
        _detailText.textColor = [NSColor colorWithString:@"#999999" andAlpha:1.0];
        _detailText.font = [NSFont fontWithSFProDisplay:12 andType:SFProDisplayRegular];
        _detailText.maximumNumberOfLines = 0;
        _detailText.alignment = NSTextAlignmentLeft;
        _detailText.editable = NO;
        [self addSubview:_detailText];
    }
    
    return _detailText;
}

@end
