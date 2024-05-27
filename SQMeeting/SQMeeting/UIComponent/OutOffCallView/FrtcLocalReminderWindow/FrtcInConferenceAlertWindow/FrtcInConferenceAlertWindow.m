#import "FrtcInConferenceAlertWindow.h"
#import "FrtcButtonMode.h"
#import "FrtcButton.h"

@interface FrtcInConferenceAlertWindow ()

@property (nonatomic, strong) NSTextField   *alertTextField;
@property (nonatomic, strong) NSImageView   *horizontalLine;
@property (nonatomic, strong) FrtcButton    *okButton;

@property (nonatomic, assign) NSSize        windowSize;
@property (nonatomic, assign) NSRect        windowFrame;
@property (nonatomic, strong) NSView        *parentView;

@property (nonatomic, assign) BOOL          defaultCenter;

@end


@implementation FrtcInConferenceAlertWindow

- (void)dealloc {
    //NSLog(@"[%s] ", __func__);

}

- (instancetype)initWithSize:(NSSize)size {
    self = [super init];
    
    if (self) {
        [self setDefaultCenter:YES];
        [self setWindowSize:size];
        [self setReleasedWhenClosed:YES];
        [self setStyleMask:[self styleMask] | NSWindowStyleMaskFullSizeContentView];
        [self setTitlebarAppearsTransparent:YES];
        [self setBackgroundColor:[NSColor whiteColor]];
        [self standardWindowButton:NSWindowZoomButton].enabled = NO;
        [self standardWindowButton:NSWindowCloseButton].enabled = NO;
        [self standardWindowButton:NSWindowMiniaturizeButton].enabled = NO;
        [[self standardWindowButton:NSWindowZoomButton] setHidden:YES];
        [[self standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
        [[self standardWindowButton:NSWindowCloseButton] setHidden:YES];
        [self setContentMaxSize:size];
        [self setContentMinSize:size];
        [self setContentSize:size];
        
        [self configurateWithHeight:size.height];
    }
    
    return self;
}

- (void)showWindowWithWindow:(NSWindow *)window {
    NSView* view = window.contentView;
    NSRect frameRelativeToWindow = [view convertRect:view.bounds toView:nil];
    NSPoint pointRelativeToScreen = [view.window convertRectToScreen:frameRelativeToWindow].origin;
    NSPoint pos = NSZeroPoint;
    if (self.defaultCenter) {
        pos.x = pointRelativeToScreen.x + (view.bounds.size.width-self.windowSize.width-view.frame.origin.x)/2;
        pos.y = pointRelativeToScreen.y + (view.bounds.size.height-self.windowSize.height-view.frame.origin.y)/2;
    } else {
        pos = self.frame.origin;
    }
    [self setFrame:NSMakeRect(0, 0, self.windowSize.width, self.windowSize.height) display:YES];
    [self setFrameOrigin:pos];
    [view.window addChildWindow:self ordered:NSWindowAbove];
    
    [self setParentView:view];
    [self makeKeyAndOrderFront:self.parentWindow];
}


#pragma mark --layout

- (void)configurateWithHeight:(CGFloat)height {
    [self.alertTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top).offset(20);
        make.width.mas_equalTo(262);
        make.height.mas_equalTo(80);
    }];

    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0);
        // make.width.mas_equalTo(262);
        make.left.mas_equalTo(self.contentView.mas_left).offset(0);
        make.right.mas_equalTo(self.contentView.mas_right).offset(0);
        make.height.mas_equalTo(48);
    }];
    
    [self.horizontalLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.okButton.mas_top).offset(-1);
        make.left.mas_equalTo(self.contentView.mas_left).offset(0);
        make.right.mas_equalTo(self.contentView.mas_right).offset(0);
        make.height.mas_equalTo(1);
    }];
}


#pragma mark --FrtcButton Event Sender--

- (void)onOkHandle:(FrtcButton *)sender {
    [self orderOut:nil];
    [self.parentWindow removeChildWindow:self];
    
    //[Note]: for local reminder alert window.
    if (self.okButtonDelegate && [self.okButtonDelegate respondsToSelector:@selector(okButtonClickedOnAlertWindow)]) {
        [self.okButtonDelegate okButtonClickedOnAlertWindow];
    }
}


#pragma mark --lazy getter--

- (NSTextField *)alertTextField {
    if (!_alertTextField) {
        _alertTextField = [[NSTextField alloc] initWithFrame:CGRectMake(10, 20, 262, 40)];
        _alertTextField.backgroundColor = [NSColor clearColor];
        _alertTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightMedium];
        _alertTextField.alignment = NSTextAlignmentLeft;
        _alertTextField.lineBreakMode = NSLineBreakByWordWrapping;
        _alertTextField.textColor = [NSColor colorWithString:@"#666666" andAlpha:1.0];
        _alertTextField.editable = NO;
        _alertTextField.bordered = NO;
        _alertTextField.wantsLayer = NO;
        _alertTextField.stringValue = NSLocalizedString(@"FM_MEETING_REMINDER_REPEAT_MEETING", @"in Conference");
        
        [self.contentView addSubview:_alertTextField];
    }
    
    return _alertTextField;
}

- (NSImageView *)horizontalLine {
    if (!_horizontalLine) {
        _horizontalLine = [[NSImageView alloc] initWithFrame:CGRectMake(0, 31, 262, 1)];
        [_horizontalLine setImage:[NSImage imageNamed:@"gray_line_content_select"]];
        _horizontalLine.imageAlignment =  NSImageAlignTopLeft;
        _horizontalLine.imageScaling =  NSImageScaleAxesIndependently;
        
        [self.contentView addSubview:_horizontalLine];
    }
    return _horizontalLine;
}

- (FrtcButton *)okButton {
    if (!_okButton) {
        FrtcButtonMode *normalMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#026FFE" andAlpha:1.0]
                                                         andborderColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0]
                                                  andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0]
                                                         andButtonTitle:NSLocalizedString(@"FM_BUTTON_OK", @"Ok")
                                                     andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        FrtcButtonMode *hoverMode = [FrtcButtonMode modelWithTileColor:[NSColor colorWithString:@"#333333" andAlpha:1.0]
                                                        andborderColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0]
                                                 andbackgroundacaColor:[NSColor colorWithString:@"#FFFFFF" andAlpha:1.0]
                                                        andButtonTitle:NSLocalizedString(@"FM_BUTTON_OK", @"Ok")
                                                    andButtonTitleFont:[NSFont systemFontOfSize:14 weight:NSFontWeightRegular]];
        
        _okButton = [[FrtcButton alloc] initWithFrame:NSMakeRect(0, 0, 200, 40) withNormalMode:normalMode withHoverMode:hoverMode];
        _okButton.target = self;
        _okButton.action = @selector(onOkHandle:);
        _okButton.hoverd = NO;
        
        [self.contentView addSubview:_okButton];
    }
    
    return _okButton;;
}

@end
