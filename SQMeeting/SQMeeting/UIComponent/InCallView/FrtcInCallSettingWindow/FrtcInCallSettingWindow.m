#import "FrtcInCallSettingWindow.h"
#import "MediaSettingView.h"

@interface FrtcInCallSettingWindow ()

@property (nonatomic, strong) NSTextField *titleTextField;
@property (nonatomic, strong) MediaSettingView  *mediaSettingView;
@property (nonatomic, strong) NSView        *lineView;

@end

@implementation FrtcInCallSettingWindow


- (instancetype)initWithSize:(NSSize)size {
    self = [super init];
    
    if(self) {
        self.releasedWhenClosed = NO;
        self.styleMask = self.styleMask | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskClosable;
        self.titlebarAppearsTransparent = YES;
        self.backgroundColor = [NSColor whiteColor];
        [self standardWindowButton:NSWindowZoomButton].enabled = NO;
        [self standardWindowButton:NSWindowCloseButton].enabled = YES;
        [self standardWindowButton:NSWindowMiniaturizeButton].enabled = NO;
        [[self standardWindowButton:NSWindowZoomButton] setHidden:YES];
        [[self standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
        [[self standardWindowButton:NSWindowCloseButton] setHidden:NO];
        self.contentMaxSize = size;
        self.contentMinSize = size;
        [self setContentSize:size];
        
        //[self mediaSettingView];
        [self setInCallWindowSetting];
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"FrtcMainWindow dealloc");
}

#pragma mark --layout--
- (void)setInCallWindowSetting {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(7);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(42);
        make.width.mas_equalTo(410);
        make.height.mas_equalTo(1);
    }];
    
    [self.mediaSettingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_top).offset(1);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.width.mas_equalTo(410);
        make.height.mas_equalTo(310);
    }];
}

#pragma mark --Lazy Load--
- (NSTextField *)titleTextField {
    if (!_titleTextField){
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:16 weight:NSFontWeightMedium];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.stringValue = NSLocalizedString(@"FM_SETTING", @"Settings");
        [self.contentView addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (NSView *)lineView {
    if(!_lineView) {
        _lineView = [[NSView alloc] initWithFrame:CGRectMake(0, 42, 410, 1)];
        _lineView.wantsLayer = YES;
        _lineView.layer.backgroundColor = [NSColor colorWithString:@"#F0F0F5" andAlpha:1.0].CGColor;
        [self.contentView addSubview:_lineView];
    }
    
    return _lineView;
}

- (MediaSettingView *)mediaSettingView {
    if(!_mediaSettingView) {
        _mediaSettingView = [[MediaSettingView alloc] initWithFrame:CGRectMake(0, 42, 410, 310)];
        _mediaSettingView.wantsLayer = YES;
        _mediaSettingView.layer.backgroundColor = [NSColor whiteColor].CGColor;
        [self.contentView addSubview:_mediaSettingView];
    }
    
    return _mediaSettingView;
}

- (void)updataSettingComboxWithUserSelectMenuButtonGridMode:(BOOL)isGridMode {
    [self.mediaSettingView updataSettingComboxWithUserSelectMenuButtonGridMode:isGridMode];
}

@end
