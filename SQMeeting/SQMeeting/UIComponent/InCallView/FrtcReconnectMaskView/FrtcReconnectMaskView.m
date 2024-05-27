#import "FrtcReconnectMaskView.h"
#import <QuartzCore/QuartzCore.h>

@interface FrtcReconnectMaskView ()

@property (nonatomic, strong) NSProgressIndicator *reConnectProgress;

@property (nonatomic, strong) NSTextField   *tipsTextField;

@end

@implementation FrtcReconnectMaskView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor blackColor].CGColor;
        self.alphaValue = 0.6;
        
        [self reconnectMaskViewLayout];
        [self startAnimation];
    }
    
    return self;
}

- (void)reconnectMaskViewLayout {
    [self.reConnectProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(32);
    }];
    
    [self.tipsTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.reConnectProgress.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)startAnimation {
    [self.reConnectProgress startAnimation:self];
}

#pragma mark --lazy load--
- (NSProgressIndicator *)reConnectProgress {
    if (!_reConnectProgress) {
        _reConnectProgress = [[NSProgressIndicator alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        _reConnectProgress.style = NSProgressIndicatorStyleSpinning;
        CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
        [lighten setDefaults];
        [lighten setValue:@1 forKey:@"inputBrightness"];
        [_reConnectProgress setContentFilters:[NSArray arrayWithObjects:lighten, nil]];
        [self addSubview:_reConnectProgress];
    }
    
    return _reConnectProgress;
}

- (NSTextField *)tipsTextField {
    if (!_tipsTextField){
        _tipsTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _tipsTextField.backgroundColor = [NSColor clearColor];
        _tipsTextField.font = [NSFont systemFontOfSize:18 weight:NSFontWeightRegular];
        _tipsTextField.alignment = NSTextAlignmentCenter;
        _tipsTextField.textColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0];
        _tipsTextField.editable = NO;
        _tipsTextField.bordered = NO;
        _tipsTextField.wantsLayer = NO;
        _tipsTextField.stringValue = NSLocalizedString(@"FM_NETWORK_EXCEPTION", @"Network exception, reconnecting…");
        [self addSubview:_tipsTextField];
    }
    
    return _tipsTextField;
}

@end
