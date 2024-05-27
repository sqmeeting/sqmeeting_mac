#import "FrtcReConnectCallWindow.h"
#import "FrtcButtonMode.h"
#import "FrtcButton.h"

@interface FrtcReConnectCallWindow ()

@property (nonatomic, strong) NSTextField           *tipsTextField;

@property (nonatomic, strong) FrtcButton *leaveButton;
@property (nonatomic, strong) FrtcButton *reCallButton;

@end

@implementation FrtcReConnectCallWindow

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
        
        [self reConnectWindowLayout];
    }
    
    return self;
}

- (void)reConnectWindowLayout {
    [self.tipsTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top).offset(32);
        make.width.mas_equalTo(195);
        make.height.mas_equalTo(48);
    }];
    
    [self.leaveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.top.mas_equalTo(104);
        make.width.mas_equalTo(98);
        make.height.mas_equalTo(32);
    }];
    
    [self.reCallButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-40);
        make.top.mas_equalTo(104);
        make.width.mas_equalTo(98);
        make.height.mas_equalTo(32);
    }];
}

#pragma mark --Button Sender--
- (void)onReConnectMeeting:(FrtcButton *)sender {
    if(self.reConnectDelegate && [self.reConnectDelegate respondsToSelector:@selector(reConnectMeeting)]) {
        [self.reConnectDelegate reConnectMeeting];
    }
    
    [self orderOut:nil];
}

- (void)onEndMeeting:(FrtcButton *)sender {
    if(self.reConnectDelegate && [self.reConnectDelegate respondsToSelector:@selector(endReConnectCall)]) {
        [self.reConnectDelegate endReConnectCall];
    }
    
    [self orderOut:nil];
}

- (NSTextField *)tipsTextField {
    if (!_tipsTextField) {
        _tipsTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _tipsTextField.backgroundColor = [NSColor clearColor];
        _tipsTextField.font = [NSFont systemFontOfSize:15 weight:NSFontWeightRegular];
        _tipsTextField.alignment = NSTextAlignmentCenter;
        _tipsTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _tipsTextField.editable = NO;
        _tipsTextField.bordered = NO;
        _tipsTextField.wantsLayer = NO;
        _tipsTextField.stringValue = NSLocalizedString(@"FM_NETWORK_EXCEPTION_REY_TRY", @"Network exception,Please check your network on try re-join");
        [self.contentView addSubview:_tipsTextField];
    }
    
    return _tipsTextField;
}

- (FrtcButton *)reCallButton {
    if(!_reCallButton) {
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_RE_JOIN", @"Join Again") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_RE_JOIN", @"Join Again") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        _reCallButton = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 98, 32) withNormalMode:normalMode withHoverMode:hoverMode];
        _reCallButton.target = self;
        _reCallButton.action = @selector(onReConnectMeeting:);
        _reCallButton.hoverd = YES;
        
        [self.contentView addSubview:_reCallButton];
    }
    
    return _reCallButton;;
}

- (FrtcButton *)leaveButton {
    if(!_leaveButton) {
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#666666" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#CCCCCC" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_LEAVE_MEETING", @"Leave Meeting") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#666666" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#CCCCCC" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:0.06] andButtonTitle:NSLocalizedString(@"FM_LEAVE_MEETING", @"Leave Meeting") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        _leaveButton = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 98, 32) withNormalMode:normalMode withHoverMode:hoverMode];
        _leaveButton.target = self;
        _leaveButton.action = @selector(onEndMeeting:);
        _leaveButton.hoverd = YES;
        
        [self.contentView addSubview:_leaveButton];
    }
    
    return _leaveButton;;
}

@end
