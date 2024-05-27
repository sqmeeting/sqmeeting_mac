#import "FrtcExceptionWindow.h"
#import "FrtcButtonMode.h"
#import "FrtcButton.h"

@interface FrtcExceptionWindow()

@property (nonatomic, strong) NSTextField   *tipsTextField;

@property (nonatomic, strong) FrtcButton    *exitButton;

@end

@implementation FrtcExceptionWindow

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
        
        [self reExceptionWindowLayout];
    }
    
    return self;
}

- (void)reExceptionWindowLayout {
    [self.tipsTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top).offset(42);
        make.width.mas_equalTo(280);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top).offset(104);
        make.width.mas_equalTo(98);
        make.height.mas_equalTo(32);
    }];
}

- (void)onEndReconnectProcess:(FrtcButton *)sender {
    if(self.exceptionWindowDelegate && [self.exceptionWindowDelegate respondsToSelector:@selector(endReconnectProcess)]) {
        [self.exceptionWindowDelegate endReconnectProcess];
    }
    
    if(self.exceptionWindowDelegate && [self.exceptionWindowDelegate respondsToSelector:@selector(onInCallWindowInitializedState:)]) {
        [self.exceptionWindowDelegate onInCallWindowInitializedState:0];
    }
    
    [self orderOut:nil];
}

- (NSTextField *)tipsTextField {
    if (!_tipsTextField){
        _tipsTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _tipsTextField.backgroundColor = [NSColor clearColor];
        _tipsTextField.font = [NSFont systemFontOfSize:15 weight:NSFontWeightRegular];
        _tipsTextField.alignment = NSTextAlignmentCenter;
        _tipsTextField.maximumNumberOfLines = 2;
        _tipsTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _tipsTextField.editable = NO;
        _tipsTextField.bordered = NO;
        _tipsTextField.wantsLayer = NO;
        _tipsTextField.stringValue = NSLocalizedString(@"FM_NETWORK_EXCEPTION_REY_TRY", @"Network exception,Please check your network on try re-join");
        [self.contentView addSubview:_tipsTextField];
    }
    
    return _tipsTextField;
}

- (FrtcButton *)exitButton {
    if(!_exitButton) {
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#CCCCCC" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0] andborderColor:[NSColor colorWithString:@"#CCCCCC" andAlpha:1.0] andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0] andButtonTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        _exitButton = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 98, 32) withNormalMode:normalMode withHoverMode:hoverMode];
        _exitButton.target = self;
        _exitButton.action = @selector(onEndReconnectProcess:);
        _exitButton.hoverd = YES;
        
        [self.contentView addSubview:_exitButton];
    }
    
    return _exitButton;;
}

@end
