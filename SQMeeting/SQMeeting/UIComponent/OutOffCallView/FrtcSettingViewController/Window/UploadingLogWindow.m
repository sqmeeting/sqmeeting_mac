#import "UploadingLogWindow.h"
#import "FrtcMultiTypesButton.h"
#import "FrtcCall.h"
#import "UploadLogStatusModel.h"

@interface UploadingLogWindow ()

@property (nonatomic, assign) NSSize        windowSize;

@property (nonatomic, assign) NSRect        windowFrame;

@property (nonatomic, strong) NSView        *parentView;

@property (nonatomic, assign) BOOL          defaultCenter;

@property (nonatomic, strong) NSTextField *titleTextField;

@property (nonatomic, strong) NSTextField *uplpadTextField;

@property (nonatomic, strong) NSTextField *uploadProgressField;

@property (nonatomic, strong) NSImageView *imageView;

@property (nonatomic, strong) NSProgressIndicator *uploadingIndicator;

@property (nonatomic, strong) FrtcMultiTypesButton    *cancelUploadButton;

@property (nonatomic, strong) FrtcMultiTypesButton    *successUploadButton;

@property (nonatomic, strong) FrtcMultiTypesButton    *cancelButton;

@property (nonatomic, strong) FrtcMultiTypesButton    *reUploadButton;

@property (nonatomic, strong) NSImageView *uploadSuccessImageView;

@property (nonatomic, strong) NSImageView *uploadFailureImageView;

@property (nonatomic, strong) NSTimer *showTimer;

@property (nonatomic, assign) double count;

@property (nonatomic, assign) NSInteger   uploadId;

@property (nonatomic, assign) NSInteger   timeValue;

@property (nonatomic, copy) NSString *loadInfo;

@end

@implementation UploadingLogWindow

- (instancetype)initWithSize:(NSSize)size {
    self = [super init];
    
    if(self) {
        self.defaultCenter = YES;
        self.windowSize = size;
        self.releasedWhenClosed = NO;
        
        self.contentView.wantsLayer = YES;
        self.contentView.layer.backgroundColor = [NSColor whiteColor].CGColor;
        
        self.styleMask = self.styleMask | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskClosable;
        self.titlebarAppearsTransparent = YES;
        self.backgroundColor = [NSColor whiteColor];
        [self standardWindowButton:NSWindowZoomButton].enabled = NO;
        [self standardWindowButton:NSWindowCloseButton].enabled = YES;
        [self standardWindowButton:NSWindowMiniaturizeButton].enabled = NO;
        [[self standardWindowButton:NSWindowZoomButton] setHidden:YES];
        [[self standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
        [[self standardWindowButton:NSWindowCloseButton] setHidden:NO];
        
        [self setEnableMessageWindowSetting];
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"FrtcMainWindow dealloc");
}

- (void)close {
    [super close];
    if(self.loadingDelegate && [self.loadingDelegate respondsToSelector:@selector(loadingClose)]) {
        [self.loadingDelegate loadingClose];
    }
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
    self.parentView = view;
    [self makeKeyAndOrderFront:self.parentWindow];
}

- (void)adjustToSize:(NSSize)size {
    NSRect frameRelativeToWindow = [self.parentView convertRect:self.parentView.bounds toView:nil];
    NSPoint pointRelativeToScreen = [self.parentView.window convertRectToScreen:frameRelativeToWindow].origin;
    NSPoint pos = NSZeroPoint;
    pos.x = pointRelativeToScreen.x + (self.parentView.bounds.size.width-size.width-self.parentView.frame.origin.x)/2;
    pos.y = pointRelativeToScreen.y + (self.parentView.bounds.size.height-size.height-self.parentView.frame.origin.y)/2;
    [self setFrame:NSMakeRect(0, 0, size.width, size.height) display:YES];
    [self setFrameOrigin:pos];
}

- (void)setEnableMessageWindowSetting {
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleTextField.mas_top).offset(55);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(67);
    }];
    
    [self.uplpadTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(29);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.uploadingIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.uplpadTextField.mas_bottom).offset(49);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(264);
        make.height.mas_equalTo(16);
    }];
    
    [self.uploadProgressField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.uploadingIndicator.mas_right).offset(8);
        make.centerY.mas_equalTo(self.uploadingIndicator.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    [self.uploadSuccessImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.uploadingIndicator.mas_right).offset(8);
        make.centerY.mas_equalTo(self.uploadingIndicator.mas_centerY);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.uploadFailureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.uploadingIndicator.mas_right).offset(8);
        make.centerY.mas_equalTo(self.uploadingIndicator.mas_centerY);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.cancelUploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.uploadingIndicator.mas_bottom).offset(32);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(111);
        make.height.mas_equalTo(32);
    }];
    
    [self.successUploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.uploadingIndicator.mas_bottom).offset(32);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(111);
        make.height.mas_equalTo(32);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.uploadingIndicator.mas_bottom).offset(32);
        make.left.mas_equalTo(self.contentView.mas_left).offset(75);
        make.width.mas_equalTo(111);
        make.height.mas_equalTo(32);
    }];
    
    [self.reUploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.uploadingIndicator.mas_bottom).offset(32);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-75);
        make.width.mas_equalTo(111);
        make.height.mas_equalTo(32);
    }];
    
}

- (void)upLoadLogProcess:(NSString *)logInfo {
    self.loadInfo = logInfo;
    self.uploadId = [[FrtcCall sharedFrtcCall] frtcStartUploadLogs:logInfo fileName:@"" fileCount:0];
    
    NSTimeInterval timeInterval = 0.5;
    [self runningTimer:timeInterval];
}

- (void)runningTimer:(NSTimeInterval)timeInterval {
    self.showTimer = [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(countTime) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.showTimer forMode:NSRunLoopCommonModes];
}

- (void)countTime {
    NSString  *logStatus = [[FrtcCall sharedFrtcCall] frtcGetUploadStatus:(int)(self.uploadId)];
    NSLog(@"status = %@",logStatus);
    
    NSError *error = nil;
    UploadLogStatusModel *logStatusModel = [[UploadLogStatusModel alloc] initWithString:logStatus error:&error];
    
    double status = [logStatusModel.progress doubleValue];
    [self.uploadingIndicator setDoubleValue:status];
    NSLog(@"d : %f",self.uploadingIndicator.doubleValue);
    
    self.uploadProgressField.stringValue = [NSString stringWithFormat:@"%ld%%", [logStatusModel.progress integerValue]];
    
    NSInteger speed = [logStatusModel.bitrate integerValue] / 1024 / 1024;
    
    NSString *uploadSpeed = [NSString stringWithFormat:@"%ld",speed];
    NSLog(@"----***%@***-----", uploadSpeed);

    NSString *stringValue = [NSString stringWithFormat:NSLocalizedString(@"FM_UPLOAD_LOG_NOW", @"Uploading，speed %@MB/s"), uploadSpeed];
    NSLog(@"######%@######", stringValue);
    self.uplpadTextField.stringValue = stringValue;

    
    NSLog(@"-----%@------", self.uplpadTextField.stringValue);
     
    if(status == 100) {
        [self cancelTimer];
        self.uploadSuccessImageView.hidden = NO;
        self.cancelUploadButton.hidden     = YES;
        self.successUploadButton.hidden    = NO;
        self.uploadProgressField.hidden = YES;
        self.uplpadTextField.stringValue = NSLocalizedString(@"FM_UPLOAD_LOG_SUCCESS", @"Uploaded succussfully");
    } else if(status < 0) {
        [self cancelTimer];
        self.cancelButton.hidden = NO;
        self.reUploadButton.hidden = NO;
        self.cancelUploadButton.hidden     = YES;
        self.uploadFailureImageView.hidden = NO;
        self.uploadProgressField.hidden = YES;
        self.uplpadTextField.stringValue = NSLocalizedString(@"FM_UPLOAD_LOG_FAILURE", @"Upload failed, please try again");
    }
}

- (void)cancelTimer {
    if(self.showTimer != nil) {
        [self.showTimer invalidate];
        self.showTimer = nil;
    }
}

#pragma mark --Button Sender--
- (void)onCancleUploadPressed:(FrtcMultiTypesButton *)sender {
    [[FrtcCall sharedFrtcCall] frtcCancelUploadLogs:(int)(self.uploadId)];
    [self cancelTimer];
    [self close];
}

- (void)onSuccessfulPressed:(FrtcMultiTypesButton *)sender {
    [self close];
}

- (void)onCancelPressed:(FrtcMultiTypesButton *)sender {
    [self close];
}

- (void)onreUploadBtnPressed:(FrtcMultiTypesButton *)sender {
    self.cancelButton.hidden = YES;
    self.reUploadButton.hidden = YES;
    self.cancelUploadButton.hidden     = NO;
    self.uploadFailureImageView.hidden = YES;
    self.uploadProgressField.hidden = NO;
    self.uploadId = [[FrtcCall sharedFrtcCall] frtcStartUploadLogs:self.loadInfo fileName:@"" fileCount:0];
    
    NSTimeInterval timeInterval = 0.5;
    [self runningTimer:timeInterval];
}

#pragma mark --Lazy Load--
- (NSTextField *)titleTextField {
    if (!_titleTextField) {
        _titleTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleTextField.backgroundColor = [NSColor clearColor];
        _titleTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightMedium];
        _titleTextField.alignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _titleTextField.bordered = NO;
        _titleTextField.editable = NO;
        _titleTextField.stringValue = NSLocalizedString(@"FM_UPLOAD_LOG", @"Upload Log");
        [self.contentView addSubview:_titleTextField];
    }
    
    return _titleTextField;
}

- (NSImageView *)imageView {
    if (!_imageView){
        _imageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 108, 108)];
        [_imageView setImage:[NSImage imageNamed:@"icon_upload_window"]];
        _imageView.imageAlignment = NSImageAlignTopLeft;
        _imageView.imageScaling = NSImageScaleAxesIndependently;
        [self.contentView addSubview:_imageView];
    }
    
    return _imageView;
}

- (NSTextField *)uplpadTextField {
    if (!_uplpadTextField) {
        _uplpadTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _uplpadTextField.backgroundColor = [NSColor clearColor];
        _uplpadTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightMedium];
        _uplpadTextField.alignment = NSTextAlignmentCenter;
        _uplpadTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _uplpadTextField.bordered = NO;
        _uplpadTextField.editable = NO;
        NSString *stringValue = [NSString stringWithFormat:NSLocalizedString(@"FM_UPLOAD_LOG_NOW", @"Uploading，speed %@MB/s"), @"0"];
        _uplpadTextField.stringValue = stringValue;
        [self.contentView addSubview:_uplpadTextField];
    }
    
    return _uplpadTextField;
}

- (NSTextField *)uploadProgressField {
    if (!_uploadProgressField) {
        _uploadProgressField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _uploadProgressField.backgroundColor = [NSColor clearColor];
        _uploadProgressField.font = [NSFont systemFontOfSize:12 weight:NSFontWeightSemibold];
        _uploadProgressField.alignment = NSTextAlignmentLeft;
        _uploadProgressField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _uploadProgressField.bordered = NO;
        _uploadProgressField.editable = NO;
        [self.contentView addSubview:_uploadProgressField];
    }
    
    return _uploadProgressField;
}

- (FrtcMultiTypesButton *)cancelUploadButton {
    if (!_cancelUploadButton) {
        _cancelUploadButton = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 88, 24) withTitle:NSLocalizedString(@"FM_CANCEL_UPLOAD_LOG", @"Cancel Upload")];
        _cancelUploadButton.target = self;
        _cancelUploadButton.layer.cornerRadius = 4.0;
        _cancelUploadButton.btnStyle = FR_BTN_SEVEN;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_CANCEL_UPLOAD_LOG", @"Cancel Upload")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#333333" andAlpha:1.0]
                          range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                          range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [_cancelUploadButton setAttributedTitle:attrTitle];
        _cancelUploadButton.layer.cornerRadius = 4.0f;
        _cancelUploadButton.layer.borderWidth = 1.0;
        _cancelUploadButton.layer.masksToBounds = YES;
        _cancelUploadButton.layer.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] whiteColor].CGColor;
        _cancelUploadButton.layer.borderColor = [NSColor colorWithString:@"CCCCCC" andAlpha:1.0].CGColor;
        _cancelUploadButton.action = @selector(onCancleUploadPressed:);
        [self.contentView addSubview:_cancelUploadButton];
    }
    
    return _cancelUploadButton;
}

- (FrtcMultiTypesButton *)successUploadButton {
    if (!_successUploadButton) {
        _successUploadButton = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 88, 24) withTitle:NSLocalizedString(@"FM_BACK", @"Back")];
        _successUploadButton.target = self;
        _successUploadButton.layer.cornerRadius = 4.0;
        _successUploadButton.btnStyle = FR_BTN_SEVEN;
        _successUploadButton.hidden = YES;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_BACK", @"Back")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#333333" andAlpha:1.0]
                          range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                          range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [_successUploadButton setAttributedTitle:attrTitle];
        _successUploadButton.layer.cornerRadius = 4.0f;
        _successUploadButton.layer.borderWidth = 1.0;
        _successUploadButton.layer.masksToBounds = YES;
        _successUploadButton.layer.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] whiteColor].CGColor;
        _successUploadButton.layer.borderColor = [NSColor colorWithString:@"CCCCCC" andAlpha:1.0].CGColor;
        _successUploadButton.action = @selector(onSuccessfulPressed:);
        [self.contentView addSubview:_successUploadButton];
    }
    
    return _successUploadButton;
}

- (FrtcMultiTypesButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[FrtcMultiTypesButton alloc] initFirstWithFrame:CGRectMake(0, 0, 88, 24) withTitle:NSLocalizedString(@"FM_CANCEL", @"Cancel")];
        _cancelButton.target = self;
        _cancelButton.layer.cornerRadius = 4.0;
        _cancelButton.btnStyle = FR_BTN_SEVEN;
        _cancelButton.hidden = YES;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_CANCEL", @"Cancel")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#333333" andAlpha:1.0]
                          range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                          range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [_cancelButton setAttributedTitle:attrTitle];
        _cancelButton.layer.cornerRadius = 4.0f;
        _cancelButton.layer.borderWidth = 1.0;
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.layer.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] whiteColor].CGColor;
        _cancelButton.layer.borderColor = [NSColor colorWithString:@"CCCCCC" andAlpha:1.0].CGColor;
        _cancelButton.action = @selector(onCancelPressed:);
        [self.contentView addSubview:_cancelButton];
    }
    
    return _cancelButton;
}

- (FrtcMultiTypesButton *)reUploadButton {
    if (!_reUploadButton) {
        _reUploadButton = [[FrtcMultiTypesButton alloc] initThirdWithFrame:CGRectMake(0, 0, 0, 0) withTitle:NSLocalizedString(@"FM_RE_UPLOAD_LOG_SUCCESS", @"Re-Upload")];
        _reUploadButton.target = self;
        _reUploadButton.action = @selector(onreUploadBtnPressed:);
        _reUploadButton.hidden = YES;
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_RE_UPLOAD_LOG_SUCCESS", @"Re-Upload")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"026FFE" andAlpha:1.0] range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:12] range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
        [attrTitle fixAttributesInRange:range];
        [_reUploadButton setAttributedTitle:attrTitle];
        _reUploadButton.layer.cornerRadius = 4.0f;
        _reUploadButton.layer.borderWidth = 1.0;
        _reUploadButton.layer.masksToBounds = YES;
        _reUploadButton.layer.backgroundColor = [[FrtcBaseImplement baseImpleSingleton] whiteColor].CGColor;
        _reUploadButton.layer.borderColor = [NSColor colorWithString:@"026FFE" andAlpha:1.0].CGColor;
        [self.contentView addSubview:_reUploadButton];
    }
    
    return _reUploadButton;
}

- (NSProgressIndicator *)uploadingIndicator {
    if(!_uploadingIndicator) {
        _uploadingIndicator = [[NSProgressIndicator alloc]initWithFrame:CGRectMake(0, 0, 264, 8)];
            //设置是精准的进度条还是模糊的指示器
        _uploadingIndicator.indeterminate = NO;
            //是否贝塞尔风格
        _uploadingIndicator.bezeled = YES;
        
        [_uploadingIndicator setUsesThreadedAnimation:YES];
            //设置控制器尺寸
        if(@available(macOS 11.0, *)) {
            _uploadingIndicator.controlSize = NSControlSizeLarge;
        } else {
            _uploadingIndicator.controlSize = NSControlSizeRegular;
        }
            //设置当前进度
        _uploadingIndicator.minValue = 0.0;

        _uploadingIndicator.maxValue = 100.0;

        _uploadingIndicator.doubleValue = 0.0;
        [_uploadingIndicator sizeToFit];
            //设置风格
        _uploadingIndicator.style = NSProgressIndicatorStyleBar;
            //设置是否当动画停止时隐藏
        _uploadingIndicator.displayedWhenStopped = YES;
        [self.contentView addSubview:_uploadingIndicator];
       
    }
    
    return _uploadingIndicator;
}

- (NSImageView *)uploadSuccessImageView {
    if (!_uploadSuccessImageView){
        _uploadSuccessImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_uploadSuccessImageView setImage:[NSImage imageNamed:@"icon_upload_success"]];
        _uploadSuccessImageView.imageAlignment = NSImageAlignTopLeft;
        _uploadSuccessImageView.hidden = YES;
        _uploadSuccessImageView.imageScaling = NSImageScaleAxesIndependently;
        [self.contentView addSubview:_uploadSuccessImageView];
    }
    
    return _uploadSuccessImageView;
}

- (NSImageView *)uploadFailureImageView {
    if (!_uploadFailureImageView){
        _uploadFailureImageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_uploadFailureImageView setImage:[NSImage imageNamed:@"icon_upload_failure"]];
        _uploadFailureImageView.imageAlignment = NSImageAlignTopLeft;
        _uploadFailureImageView.hidden = YES;
        _uploadFailureImageView.imageScaling = NSImageScaleAxesIndependently;
        [self.contentView addSubview:_uploadFailureImageView];
    }
    
    return _uploadFailureImageView;
}

@end
