#import "RecordingView.h"
#import "FrtcMultiTypesButton.h"

@interface RecordingView()

@property (nonatomic, strong) NSTextField               *recordingText;

@property (nonatomic, strong) NSTextField               *recordingDetailText;

@property (nonatomic, strong) FrtcMultiTypesButton                  *recordingViewButton;

@end

@implementation RecordingView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        [self configLabView];
    }
    
    return self;
}

- (void)configLabView {
    [self.recordingText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(23);
        make.left.mas_equalTo(24);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.recordingDetailText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.recordingText.mas_bottom).offset(6);
        make.left.mas_equalTo(24);
        make.width.mas_equalTo(354);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.recordingViewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.recordingDetailText.mas_centerY).offset(-6);
        make.left.mas_equalTo(self.recordingDetailText.mas_right).offset(8);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(28);
    }];
}

#pragma mark --Button Sender--
- (void)onViewBtnPressed:(FrtcMultiTypesButton *)sender {
    NSString *url = [[FrtcUserDefault defaultSingleton] objectForKey:STORAGE_SERVER_ADDRESS];
    NSString *urlString = [NSString stringWithFormat:@"https://%@", url];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:urlString]];
}

#pragma mark --Lazy Load--
- (NSTextField *)recordingText {
    if (!_recordingText) {
        _recordingText = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _recordingText.stringValue = NSLocalizedString(@"FM_VIDEO_RECORDING_FILES", @"Recorded files");
        _recordingText.bordered = NO;
        _recordingText.drawsBackground = NO;
        _recordingText.backgroundColor = [NSColor clearColor];
        _recordingText.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
        _recordingText.font = [NSFont systemFontOfSize:14];
        _recordingText.alignment = NSTextAlignmentLeft;
        _recordingText.editable = NO;
        [self addSubview:_recordingText];
    }
    
    return _recordingText;
}

- (NSTextField *)recordingDetailText {
    if (!_recordingDetailText) {
        _recordingDetailText = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _recordingDetailText.stringValue = NSLocalizedString(@"FM_VIDEO_RECORDING_FILES_DETAIL", @"Sign in to “SQ Meeting CE  Web portal- Meeting Recording” to check recorded files.");
        _recordingDetailText.bordered = NO;
        _recordingDetailText.drawsBackground = NO;
        _recordingDetailText.backgroundColor = [NSColor clearColor];
        _recordingDetailText.textColor = [NSColor colorWithString:@"999999" andAlpha:1.0];
        _recordingDetailText.font = [NSFont systemFontOfSize:13];
        _recordingDetailText.alignment = NSTextAlignmentLeft;
        _recordingDetailText.maximumNumberOfLines = 0;
        _recordingDetailText.editable = NO;
        [self addSubview:_recordingDetailText];
    }
    
    return _recordingDetailText;
}

- (FrtcMultiTypesButton *)recordingViewButton {
    if (!_recordingViewButton) {
        _recordingViewButton = [[FrtcMultiTypesButton alloc] initThirdWithFrame:CGRectMake(0, 0, 0, 0) withTitle:NSLocalizedString(@"FM_VIEW_ASK_FRO_UN_MUTE_LIST", @"View")];
        _recordingViewButton.target = self;
        _recordingViewButton.action = @selector(onViewBtnPressed:);
        
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_VIEW_ASK_FRO_UN_MUTE_LIST", @"View")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"026FFE" andAlpha:1.0] range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:12] range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
        [attrTitle fixAttributesInRange:range];
        [_recordingViewButton setAttributedTitle:attrTitle];
        _recordingViewButton.layer.cornerRadius = 4.0f;
        _recordingViewButton.layer.borderWidth = 1.0;
        _recordingViewButton.layer.masksToBounds = YES;
        _recordingViewButton.layer.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] whiteColor].CGColor;
        _recordingViewButton.layer.borderColor = [NSColor colorWithString:@"026FFE" andAlpha:1.0].CGColor;
        [self addSubview:_recordingViewButton];
    }
    
    return _recordingViewButton;
}

@end
