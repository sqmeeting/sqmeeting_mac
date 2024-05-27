#import "AboutSettingView.h"
#import "FrtcRtfViewController.h"
#import "FrtcMainWindow.h"

@interface AboutSettingView ()

@property (nonatomic, strong) NSImageView               *logoView;

@property (nonatomic, strong) NSTextField               *versionText;

@end

@implementation AboutSettingView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)init {
    self = [super init];
    
    if(self) {
        [self configAboutView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        [self configAboutView];
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"------AboutSettingView dealloc------");
}

- (void)onTestBtnPressed:(NSButton *)sender {
    FrtcRtfViewController *meetingDetailViewController = [[FrtcRtfViewController alloc] initWithNibName:nil bundle:nil];
    
    FrtcMainWindow *meetingDetailWindow = [[FrtcMainWindow alloc] initWithSize:NSMakeSize(440, 724)];
    meetingDetailWindow.contentViewController = meetingDetailViewController;
    [meetingDetailWindow makeKeyAndOrderFront:self];
    [meetingDetailWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    [meetingDetailWindow center];
}

- (void)configAboutView {
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(85);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(88);
        make.height.mas_equalTo(88);
     }];
    
    [self.versionText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
}

#pragma mark --lazy load function--
- (NSImageView *)logoView {
    if (!_logoView){
        _logoView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 108, 108)];
        [_logoView setImage:[NSImage imageNamed:@"icon-logo"]];
        _logoView.imageAlignment = NSImageAlignTopLeft;
        _logoView.imageScaling = NSImageScaleAxesIndependently;
        [self addSubview:_logoView];
    }
    
    return _logoView;
}

- (NSTextField *)versionText {
    if (!_versionText){
        _versionText = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _versionText.stringValue = NSLocalizedString(@"FM_COPYRIGHT", @"版本：version + build");
        _versionText.bordered = NO;
        _versionText.drawsBackground = NO;
        _versionText.backgroundColor = [NSColor clearColor];
        _versionText.textColor = [NSColor colorWithString:@"222222" andAlpha:1.0];
        _versionText.font = [NSFont systemFontOfSize:14];
        _versionText.alignment = NSTextAlignmentLeft;
        _versionText.editable = NO;
        [self addSubview:_versionText];
    }
    
    return _versionText;
}

@end
