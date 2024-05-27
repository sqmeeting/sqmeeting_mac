#import "FrtcContentAudioSettingViewController.h"

@interface FrtcContentAudioSettingViewController ()

@property (nonatomic, strong) NSImageView *shareSettingImageView;
@property (nonatomic, strong) NSTextField *shareSettingTextField;

@property (nonatomic, strong) NSButton *shareSettingButton;

@end

@implementation FrtcContentAudioSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:0.88].CGColor;
    [self contentAudioSettingLayout];
}

#pragma mark- --Button Sender--
- (void)onEnableContentAudio:(NSButton *)sender {
    NSLog(@"[Content Audio][FrtcContentAudioSettingViewController] -onEnableContentAudio: -> [self.delegate sendContentAudio: ]");
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendContentAudio:)]) {
        [self.delegate sendContentAudio:sender.state == NSControlStateValueOn ? YES: NO];
    }
}

#pragma mark- --FrtcContentAudioSettingViewController Layout--

- (void)contentAudioSettingLayout {
    [self.shareSettingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.top.mas_equalTo(self.view.mas_top).offset(13);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(12);
    }];
    
    [self.shareSettingTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shareSettingImageView.mas_right).offset(3);
        make.centerY.mas_equalTo(self.shareSettingImageView.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.shareSettingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.top.mas_equalTo(self.view.mas_top).offset(37);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

#pragma mark- --Lazy Load--
- (NSImageView *)shareSettingImageView {
    if(!_shareSettingImageView) {
        _shareSettingImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        _shareSettingImageView.image = [NSImage imageNamed:@"icon-share-setting"];
        [self.view addSubview:_shareSettingImageView];
    }
    
    return _shareSettingImageView;
}

- (NSTextField *)shareSettingTextField {
    if(!_shareSettingTextField) {
        _shareSettingTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _shareSettingTextField.backgroundColor = [NSColor clearColor];
        _shareSettingTextField.font = [NSFont systemFontOfSize:12 weight:NSFontWeightMedium];
        _shareSettingTextField.alignment = NSTextAlignmentLeft;
        _shareSettingTextField.textColor = [NSColor colorWithString:@"#666666" andAlpha:1.0];
        _shareSettingTextField.stringValue = @"共享设置";
        _shareSettingTextField.bordered = NO;
        _shareSettingTextField.editable = NO;
        [self.view addSubview:_shareSettingTextField];
    }
        
    return _shareSettingTextField;
}

- (NSButton *)shareSettingButton {
    if (!_shareSettingButton) {
        _shareSettingButton = [self checkButton:@"同时共享电脑声音" aciton:@selector(onEnableContentAudio:)];
    }
    
    return _shareSettingButton;
}

#pragma mark- -- internal function --
- (NSButton *)checkButton:(NSString *)buttonTile aciton:(SEL)action {
    int btnWidth = 360;
    int btnHeight = 16;
    NSButton *checkButton = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, btnWidth, btnHeight)];
    [checkButton setButtonType:NSButtonTypeSwitch];
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:buttonTile];
    NSUInteger len = [attrTitle length];
    NSRange range = NSMakeRange(0, len);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#222222" andAlpha:1.0]
                      range:range];
    [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:12]
                      range:range];
    
    [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                      range:range];
    [attrTitle fixAttributesInRange:range];
    [checkButton setAttributedTitle:attrTitle];
    attrTitle = nil;
    [checkButton setNeedsDisplay:YES];
    
    checkButton.target = self;
    checkButton.action = action;
    [self.view addSubview:checkButton];
    
    return checkButton;
}

@end
