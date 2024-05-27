#import "FrtcMediaStaticsViewWindow.h"
#import "FrtcMediaStaticsView.h"
#import "FrtcStatisticalModel.h"
#import "FrtcMediaStaticsModel.h"
#import "FrtcMediaStaticsInstance.h"

@interface FrtcMediaStaticsViewWindow () <FrtcMediaStaticsViewDelegate>

@property (nonatomic, strong) NSTextField *titleTextField;
@property (nonatomic, strong) FrtcMediaStaticsView  *mediaSettingView;
@property (nonatomic, strong) NSView        *lineView;
@property (nonatomic, strong) FrtcStatisticalModel *staticsModel;
@property (nonatomic, strong) FrtcMediaStaticsModel *mediaStaticModel;

@end

@implementation FrtcMediaStaticsViewWindow

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
        [self setStaticsViewWindowSetting];
        [self getStatics];
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"FrtcMainWindow dealloc");
}

#pragma mark --FrtcMediaStaticsViewDelegate--
- (void)popupStaticsWindow {
    if(self.staticsWindowDelegate && [self.staticsWindowDelegate respondsToSelector:@selector(pupupDetailStaticWindow)]) {
        [self.staticsWindowDelegate pupupDetailStaticWindow];
    }
}

#pragma mark --getStatics--
- (void)getStatics {
    __weak __typeof(self)weakSelf = self;
    
    [[FrtcMediaStaticsInstance sharedFrtcMediaStaticsInstance] startGetStatics:^(FrtcStatisticalModel * _Nonnull staticsModel, FrtcMediaStaticsModel * _Nonnull mediaStaticsModel) {
        __strong __typeof(&*weakSelf)strongSelf = weakSelf;
        
        strongSelf.mediaStaticModel = mediaStaticsModel;
        strongSelf.staticsModel     = staticsModel;
        
        [strongSelf updateMediaStatics:mediaStaticsModel];
        
        if(strongSelf.staticsWindowDelegate && [strongSelf.staticsWindowDelegate respondsToSelector:@selector(handleStaticsEvent:)]) {
            [strongSelf.staticsWindowDelegate handleStaticsEvent:staticsModel];
        }
    }];
}

- (void)updateMediaStatics:(FrtcMediaStaticsModel *)mediaStaticsModel {
    self.mediaStaticModel = mediaStaticsModel;
    [self.mediaSettingView updateStatics:mediaStaticsModel];
}

#pragma mark --layout--
- (void)setStaticsViewWindowSetting {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];

    [self.mediaSettingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.width.mas_equalTo(260);
        make.height.mas_equalTo(197);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mediaSettingView.mas_top).offset(1);
        make.width.mas_equalTo(260);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark --Lazy Load--
- (NSTextField *)titleTextField {
    if (!_titleTextField){
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:13 weight:NSFontWeightMedium];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"#222222" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.stringValue = NSLocalizedString(@"FM_STATISTICS", @"Participants");
        [self.contentView addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (NSView *)lineView {
    if(!_lineView) {
        _lineView = [[NSView alloc] initWithFrame:CGRectMake(0, 42, 380, 1)];
        _lineView.wantsLayer = YES;
        _lineView.layer.backgroundColor = [NSColor colorWithString:@"#F0F0F5" andAlpha:1.0].CGColor;
        [self.contentView addSubview:_lineView];
    }
    
    return _lineView;
}

- (FrtcMediaStaticsView *)mediaSettingView {
    if(!_mediaSettingView) {
        _mediaSettingView = [[FrtcMediaStaticsView alloc] initWithFrame:CGRectMake(0, 10, 260, 197)];
        _mediaSettingView.wantsLayer = YES;
        _mediaSettingView.mediaStaticsDelegate = self;
        _mediaSettingView.layer.backgroundColor = [NSColor whiteColor].CGColor;
        [self.contentView addSubview:_mediaSettingView];
    }
    
    return _mediaSettingView;
}

@end
