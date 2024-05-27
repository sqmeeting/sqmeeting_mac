#import "VideoSettingView.h"
#import "FrtcPopUpButton.h"
#import <AVFoundation/AVFoundation.h>

@interface VideoSettingView ()

@property (nonatomic, strong) NSView       *preview;
@property (nonatomic, strong) NSArray <AVCaptureDevice *> *devices;
@property (nonatomic, strong) AVCaptureDevice             *captureDevice;
@property (nonatomic, strong) AVCaptureSession            *captureSession;
@property (nonatomic, strong) AVCaptureDeviceInput        *captureInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput    *captureOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer  *previewLayer;

@property (nonatomic, strong) NSTextField                 *textField;

@property (nonatomic, strong) FrtcPopUpButton             *cameraComboBox;
@property (nonatomic, strong) FrtcPopUpButton             *videoLayoutCombox;
@property (nonatomic, strong) NSButton                    *mirrorBtn;

@property (nonatomic, strong) NSTextField                 *layoutTextField;

@property (nonatomic, strong) NSButton                    *gpuSpeedButton;

@property (nonatomic, strong) NSTextField                 *descriptionTextField;

@property (nonatomic, assign, getter=isMirrored) BOOL mirrored;

@property (nonatomic, copy) NSString* currentCameraID;

@end

@implementation VideoSettingView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)viewWillDraw {
    [super viewWillDraw];

    [self loadVideoDevice];
}

- (instancetype)init {
    self = [super init];
    
    if(self) {
        //[self configLogView];
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor whiteColor].CGColor;
    }
    
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        [self configVideoView];
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor whiteColor].CGColor;
  
        [self addNotification];
        [self updateDeviceList];
        NSString *defaultCamera = [[FrtcUserDefault defaultSingleton] objectForKey:DEFAULT_CAMERA];
        self.currentCameraID = defaultCamera;
        self.mirrored = [[FrtcUserDefault defaultSingleton] boolObjectForKey:ENABLE_CAMREA_MIRROR];
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"------VideoSettingView dealloc------");
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addNotification {
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(onDeviceListChaned:) name:FMeetingCameraListChangedNotification object:nil];
    [nc addObserver:self selector:@selector(onDisplayChanged:) name:FMeetingDisplayChangedNotification object:nil];
}

- (void)showLocalVideoView {
    [self showPreviewWithDevice:[self getDeviceByName:self.currentCameraID] In:self.preview];
}

- (void)configVideoView {
    [self.preview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(23);
        make.left.mas_equalTo(23);
        make.width.mas_equalTo(408);
        make.height.mas_equalTo(229.5);
     }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.preview.mas_bottom).offset(17);
        make.left.mas_equalTo(23);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.cameraComboBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
        make.top.mas_equalTo(self.textField.mas_bottom).offset(8);
        make.width.mas_greaterThanOrEqualTo(286);
        make.height.mas_greaterThanOrEqualTo(32);
     }];
    
    [self.mirrorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cameraComboBox.mas_bottom).offset(16);
        make.left.mas_equalTo(26);
        make.width.mas_greaterThanOrEqualTo(101);
        make.height.mas_greaterThanOrEqualTo(20);
     }];
    
    [self.layoutTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mirrorBtn.mas_bottom).offset(24);
        make.left.mas_equalTo(23);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
    
    [self.videoLayoutCombox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
        make.top.mas_equalTo(self.layoutTextField.mas_bottom).offset(8);
        make.width.mas_greaterThanOrEqualTo(286);
        make.height.mas_greaterThanOrEqualTo(32);
     }];
    
    [self.gpuSpeedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
        make.top.mas_equalTo(self.videoLayoutCombox.mas_bottom).offset(20);
        make.width.mas_greaterThanOrEqualTo(84);
        make.height.mas_greaterThanOrEqualTo(20);
     }];
    
    [self.descriptionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gpuSpeedButton.mas_right).offset(8);
        make.centerY.mas_equalTo(self.gpuSpeedButton.mas_centerY);
        make.width.mas_equalTo(250);
        make.height.mas_greaterThanOrEqualTo(0);
     }];
}

- (AVCaptureDevice *)getDeviceByName:(NSString *)name {
    for (AVCaptureDevice *device in self.devices) {
        if ([[device localizedName] isEqualToString:name]) {
            return device;
        }
    }
    
    return  nil;
}

- (void)updateDeviceList {
    if (@available(macOS 10.15, *)) {
        AVCaptureDeviceDiscoverySession *deviceSession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera,AVCaptureDeviceTypeExternalUnknown] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionUnspecified];
        self.devices = deviceSession.devices;
    } else{
        self.devices = [AVCaptureDevice devices];
    }
}

- (void)showPreviewWithDevice:(AVCaptureDevice *)device In:(NSView *)view {
    BOOL hasCamera = NO;
    for (AVCaptureDevice *device in self.devices) {
        if([device hasMediaType:AVMediaTypeVideo]){
            hasCamera = YES;
        }
    }
    if(!hasCamera){
        NSLog(@"无可用的摄像头！！！");
        return;
    }
    //macOS 10.14以后才可以使用，10.14之前直接使用
     if (@available(macOS 10.14, *)) {
         AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
         if(authStatus == AVAuthorizationStatusAuthorized) {
             NSLog(@"已授权");
             [self showWithDevice:device In:view];
         } else if(authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted){
             NSLog(@"拒绝使用");
             NSAlert *alert = [[NSAlert alloc] init];
             [alert setMessageText:@"是否允许程序使用摄像头开启灯效预览"];
             [alert addButtonWithTitle:@"是"];
             [alert addButtonWithTitle:@"否"];
             [alert beginSheetModalForWindow:[NSApp mainWindow] completionHandler:^(NSModalResponse returnCode) {
                 if(returnCode == NSAlertFirstButtonReturn){
                     [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"x-apple.systempreferences:com.apple.preference.security?Privacy_Camera"]];
                 }else if(returnCode == NSAlertSecondButtonReturn){
                    //取消
                 }
             }];
             return;
         } else if(authStatus == AVAuthorizationStatusNotDetermined) {
             //第一次调用状态是NotDetermined, 去获得授权
             [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                 NSLog(@"获取授权成功");
                 dispatch_sync(dispatch_get_main_queue(), ^{
                     [self showWithDevice:device In:view];
                 });
             }];
             return;
         }
     } else {
         [self showWithDevice:device In:view];
     }
}

- (void)showWithDevice:(AVCaptureDevice *)device In:(NSView *)view {
    [self configWithDevice:device];
    [self.previewLayer setFrame:view.bounds];
    view.wantsLayer = true;
    [view.layer insertSublayer:self.previewLayer atIndex:0];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    if(self.previewLayer.connection.isVideoMirroringSupported) {
        self.previewLayer.connection.automaticallyAdjustsVideoMirroring = NO;
        self.previewLayer.connection.videoMirrored = self.isMirrored;
    }
    [self.captureSession commitConfiguration];
    [self.captureSession startRunning];
}

- (void)configWithDevice:(AVCaptureDevice *)device {
    if (self.captureSession.isRunning) {
        [self.captureSession stopRunning];
    }
    self.captureDevice = [AVCaptureDevice deviceWithUniqueID:device.uniqueID];
    self.captureSession = [[AVCaptureSession alloc] init] ;
    self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    self.captureInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:nil];
    if([self.captureSession canAddInput:self.captureInput]) {
        [self.captureSession addInput:self.captureInput];
    }
    self.captureOutput = [[AVCaptureVideoDataOutput alloc] init];
  
    NSDictionary *settings =  [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] forKey:(NSString*)kCVPixelBufferPixelFormatTypeKey];
    
    [self.captureOutput setVideoSettings:settings];
    
    AVCaptureConnection *videoOutConn = [self.captureOutput connectionWithMediaType:AVMediaTypeVideo];
    videoOutConn.videoMirrored = NO;
    if([self.captureSession canAddOutput:self.captureOutput]) {
        [self.captureSession addOutput:self.captureOutput];
    }

    self.previewLayer =[AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
}

- (void)loadVideoDevice {
    NSString *defaultCamera = [[FrtcUserDefault defaultSingleton] objectForKey:DEFAULT_CAMERA];
    NSString* curSel = [self.cameraComboBox titleOfSelectedItem];
    
    NSLog(@"The defaultCamera is %@, the curSel is %@", defaultCamera, curSel);
    
    NSMutableArray* camList = [[NSMutableArray alloc] init];
    NSLog(@"go to get camera list");
    [[FrtcCall sharedFrtcCall] frtcCameraList:camList];
    NSLog(@"end to get camera list");
    [self.cameraComboBox removeAllItems];

    BOOL found = NO;
    for (NSMutableDictionary *deviceInfo in camList) {
        NSString *devName = [deviceInfo valueForKey:@"name"];
        [[self cameraComboBox] addItemWithTitle:devName];
        if ([defaultCamera isEqualToString:devName]) {
            found = YES;
        }
    }
    
    NSColor *textColor = [[FrtcBaseImplement baseImpleSingleton] baseColor];;
    NSArray *itemArray = [self.cameraComboBox itemArray];
    int i = 0;
    NSDictionary *attributes = [NSDictionary
                                dictionaryWithObjectsAndKeys:
                                textColor, NSForegroundColorAttributeName,
                                [NSFont systemFontOfSize: [NSFont systemFontSize]],
                                NSFontAttributeName, nil];

    for (i = 0; i < [itemArray count]; i++) {
        NSMenuItem *item = [itemArray objectAtIndex:i];

        NSAttributedString *as = [[NSAttributedString alloc]
                 initWithString:[item title]
                 attributes:attributes];

        [item setAttributedTitle:as];
    }
    
    if (found) {
        NSLog(@"found is true");
        NSInteger index = [self.cameraComboBox indexOfItemWithTitle:defaultCamera];
        [self.cameraComboBox selectItemAtIndex:index];
        
        if( [curSel isEqualToString:defaultCamera] == false && self.captureSession.isRunning) {
            self.currentCameraID = defaultCamera;
            NSLog(@"camera changed from %@ to %@", curSel, defaultCamera);
            [self stop];
            [self start];
            
        }
    } else if(curSel) {
        NSLog(@"111111111");
        NSInteger index = [self.cameraComboBox indexOfItemWithTitle:curSel];
        if(index != -1) {
            NSLog(@"222222222");
            [self.cameraComboBox selectItemAtIndex:index];
        } else {
            NSLog(@"33333333333");
            NSString *defaultCamera = [[FrtcCall sharedFrtcCall] getDefaultCamera];
            for (NSMutableDictionary *camInfo in camList) {
                NSString *devName = [camInfo valueForKey:@"name"];
                if ([devName isEqualToString:defaultCamera]){
                    NSInteger index = [self.cameraComboBox indexOfItemWithTitle:devName];
                    [self.cameraComboBox selectItemAtIndex:index];
                    [self onVideoListSelChange];
                    break;
                }
            }
        }
    }
}

#pragma mark -- notification
- (void)onDeviceListChaned:(NSNotification *)notification {
    NSLog(@"receive the on device list changed");
    NSDictionary *userInfo = notification.userInfo;
    NSDictionary *inUseDev = [userInfo valueForKey:FMeetingCameraListInUseKey];
    NSString *inuseCamera  = [inUseDev valueForKey:@"camera"];

    [[FrtcUserDefault defaultSingleton] setObject:inuseCamera forKey:DEFAULT_CAMERA];
    [self loadVideoDevice];
}

#pragma mark -- popbutton select changed handler
- (void)onVideoListSelChange {
    NSString *title = [self.cameraComboBox titleOfSelectedItem];
    [[FrtcUserDefault defaultSingleton] setObject:title forKey:DEFAULT_CAMERA];
    [[FrtcCall sharedFrtcCall] frtcSelectCamera:title];
    
    int index = 0;
    NSLog(@"select camera id is: %@", title);
    AVCaptureDevice * device = nil;
    NSString *old_deviceName = self.currentCameraID;
    self.currentCameraID = @"";
    for (; index < [self.devices count]; index++) {
        device = [self.devices objectAtIndex:index];
        
        if([device.localizedName isEqualToString:title]) {
            self.currentCameraID = title;
            break;
        }
    }
    
    if( [old_deviceName isEqualToString:self.currentCameraID] == false && self.captureSession.isRunning) {
        NSLog(@"camera changed from %@ to %@", old_deviceName, title);
        [self stop];
        [self start];
        
    }
}

- (void)stop {
    if (self.captureSession.isRunning) {
        [self.captureSession stopRunning];
    }
    
    [self.captureSession removeInput:self.captureInput];
    [self.captureSession removeOutput:self.captureOutput];
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if(hidden) {
        [self stop];
    } else {
        
    }
}

- (void)updataSettingComboxWithUserSelectMenuButtonGridMode:(BOOL)isGridMode {
    if(isGridMode) { // gallery
        [self.videoLayoutCombox selectItemAtIndex:1];
    } else { // presentor
        [self.videoLayoutCombox selectItemAtIndex:0];
    }
}

- (void)start {
    self.captureDevice = [AVCaptureDevice deviceWithUniqueID:[self getDeviceByName:self.currentCameraID].uniqueID];
    self.captureSession = [[AVCaptureSession alloc] init] ;
    self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;// AVCaptureSessionPresetPhoto;
    self.captureInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:nil];
    if([self.captureSession canAddInput:self.captureInput]){
        [self.captureSession addInput:self.captureInput];
    }
    self.captureOutput = [[AVCaptureVideoDataOutput alloc] init];
  
    NSDictionary *settings =  [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] forKey:(NSString*)kCVPixelBufferPixelFormatTypeKey];
    
    [self.captureOutput setVideoSettings:settings];
    if([self.captureSession canAddOutput:self.captureOutput]){
        [self.captureSession addOutput:self.captureOutput];
    }
    
    self.previewLayer =[AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    [self.previewLayer setFrame:self.preview.bounds];
    self.preview.wantsLayer = true;
    [self.preview.layer insertSublayer:self.previewLayer atIndex:0];
    
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    if(self.previewLayer.connection.isVideoMirroringSupported) {
        self.previewLayer.connection.automaticallyAdjustsVideoMirroring = NO;
        self.previewLayer.connection.videoMirrored = self.isMirrored;
    }
    
    [self.captureSession commitConfiguration];
    [self.captureSession startRunning];
}

- (void)onDisplayChanged:(NSNotification *)notification {
    [self loadVideoDevice];
}

- (void)onLayoutListSelChange {
    NSString *title = [self.videoLayoutCombox titleOfSelectedItem];
    if ([title isEqualToString:NSLocalizedString(@"FM_GALLERT_MODE", @"Gallery View")]) {
        [[FrtcCallInterface singletonFrtcCall] switchGridMode:YES];
    } else {
        [[FrtcCallInterface singletonFrtcCall] switchGridMode:NO];
    }
}

#pragma mark --onMirrorBtnPressed
- (void)onMirrorBtnPressed:(NSButton *)sender {
    if(sender.state == NSControlStateValueOn) {
        [[FrtcUserDefault defaultSingleton] setBoolObject:YES forKey:ENABLE_CAMREA_MIRROR];
        if(self.previewLayer.connection.isVideoMirroringSupported) {
            self.previewLayer.connection.automaticallyAdjustsVideoMirroring = NO;
            self.previewLayer.connection.videoMirrored = YES;
        }
        [[FrtcCall sharedFrtcCall] setCameraStreamMirror:YES];
    } else {
        [[FrtcUserDefault defaultSingleton] setBoolObject:NO forKey:ENABLE_CAMREA_MIRROR];
        
        if(self.previewLayer.connection.isVideoMirroringSupported) {
            self.previewLayer.connection.automaticallyAdjustsVideoMirroring = NO;
            self.previewLayer.connection.videoMirrored = NO;
        }
        [[FrtcCall sharedFrtcCall] setCameraStreamMirror:NO];
    }
}

- (void)onGPUSpeedBtnPressed:(NSButton *)sender {
    
}

- (NSView *)preview {
    if(!_preview) {
        _preview = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 408, 229)];
        _preview.wantsLayer = YES;
        _preview.layer.backgroundColor = [NSColor blackColor].CGColor;
        [self addSubview:_preview];
    }
    
    return _preview;
}

- (NSTextField *)textField {
    if (!_textField) {
        _textField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _textField.bordered = NO;
        _textField.drawsBackground = NO;
        _textField.backgroundColor = [NSColor clearColor];
        _textField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _textField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightSemibold];
        _textField.alignment = NSTextAlignmentLeft;
        _textField.maximumNumberOfLines = 0;
        _textField.editable = NO;
        _textField.stringValue = NSLocalizedString(@"FM_CAMERA", @"Camera");
        
        [self addSubview:_textField];
    }
    
    return _textField;
}

- (FrtcPopUpButton *)videoLayoutCombox {
    if (!_videoLayoutCombox) {
        _videoLayoutCombox = [[FrtcPopUpButton alloc] init];
        [_videoLayoutCombox setFontWithString:@"222222" alpha:1 size:14 andType:SFProDisplayRegular];
        [_videoLayoutCombox setTarget:self];
        [_videoLayoutCombox setAction:@selector(onLayoutListSelChange)];
        [[self videoLayoutCombox] addItemWithTitle:NSLocalizedString(@"FM_PRESENTER_MODE", @"Presenter View")];
        [[self videoLayoutCombox] addItemWithTitle:NSLocalizedString(@"FM_GALLERT_MODE", @"Gallery View")];
        [self addSubview:_videoLayoutCombox];
    }
    return  _videoLayoutCombox;
}

- (FrtcPopUpButton *)cameraComboBox {
    if (!_cameraComboBox) {
        _cameraComboBox = [[FrtcPopUpButton alloc] init];
        [_cameraComboBox setFontWithString:@"222222" alpha:1 size:14 andType:SFProDisplayRegular];
        [_cameraComboBox setTarget:self];
        [_cameraComboBox setAction:@selector(onVideoListSelChange)];
        [self  addSubview:_cameraComboBox];
    }
    return  _cameraComboBox;
}

- (NSButton *)mirrorBtn {
    if (!_mirrorBtn) {
        _mirrorBtn = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, 36, 16)];
        [_mirrorBtn setButtonType:NSButtonTypeSwitch];
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_CAMERA_MIRRO", @"Video Mirroring")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#333333" andAlpha:1.0]
                          range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                          range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [_mirrorBtn setAttributedTitle:attrTitle];
        attrTitle = nil;
        [_mirrorBtn setNeedsDisplay:YES];
        
        BOOL enableMirror = [[FrtcUserDefault defaultSingleton] boolObjectForKey:ENABLE_CAMREA_MIRROR];
        if (enableMirror) {
            [_mirrorBtn setState:NSControlStateValueOn];
            [[FrtcCall sharedFrtcCall] setCameraStreamMirror:YES];
        } else {
            [_mirrorBtn setState:NSControlStateValueOff];
            [[FrtcCall sharedFrtcCall] setCameraStreamMirror:NO];
        }
        
        _mirrorBtn.target = self;
        _mirrorBtn.action = @selector(onMirrorBtnPressed:);
        [self addSubview:_mirrorBtn];
    }
    
    return _mirrorBtn;
}

- (NSTextField *)layoutTextField {
    if (!_layoutTextField) {
        _layoutTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _layoutTextField.bordered = NO;
        _layoutTextField.drawsBackground = NO;
        _layoutTextField.backgroundColor = [NSColor clearColor];
        _layoutTextField.textColor = [NSColor colorWithString:@"#333333" andAlpha:1.0];
        _layoutTextField.font = [NSFont systemFontOfSize:14 weight:NSFontWeightSemibold];
        _layoutTextField.alignment = NSTextAlignmentLeft;
        _layoutTextField.maximumNumberOfLines = 0;
        _layoutTextField.editable = NO;
        _layoutTextField.stringValue = NSLocalizedString(@"PAM_VIDEO_LAYOUT", @"Video Layout");
        
        [self addSubview:_layoutTextField];
    }
    
    return _layoutTextField;
}

- (NSButton *)gpuSpeedButton {
    if (!_gpuSpeedButton) {
        _gpuSpeedButton = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, 36, 16)];
        [_gpuSpeedButton setButtonType:NSButtonTypeSwitch];
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FM_GPU_SPEED", @"Disable hardware rendering")];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithString:@"#333333" andAlpha:1.0]
                          range:range];
        [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:14]
                          range:range];
        
        [attrTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                          range:range];
        [attrTitle fixAttributesInRange:range];
        [_gpuSpeedButton setAttributedTitle:attrTitle];
        attrTitle = nil;
        [_gpuSpeedButton setNeedsDisplay:YES];
        
        BOOL enableMirror = [[FrtcUserDefault defaultSingleton] boolObjectForKey:ENABLE_CAMREA_MIRROR];
        if (enableMirror) {
            [_gpuSpeedButton setState:NSControlStateValueOn];
        } else {
            [_gpuSpeedButton setState:NSControlStateValueOff];
        }
        
        _gpuSpeedButton.target = self;
        _gpuSpeedButton.action = @selector(onGPUSpeedBtnPressed:);
        [self addSubview:_gpuSpeedButton];
    }
    
    return _gpuSpeedButton;
}

- (NSTextField *)descriptionTextField {
    if (!_descriptionTextField) {
        _descriptionTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _descriptionTextField.bordered = NO;
        _descriptionTextField.drawsBackground = NO;
        _descriptionTextField.backgroundColor = [NSColor clearColor];
        _descriptionTextField.textColor = [NSColor colorWithString:@"#999999" andAlpha:1.0];
        _descriptionTextField.font = [NSFont systemFontOfSize:12 weight:NSFontWeightRegular];
        _descriptionTextField.alignment = NSTextAlignmentLeft;
        _descriptionTextField.maximumNumberOfLines = 2;
        _descriptionTextField.editable = NO;
        _descriptionTextField.stringValue = NSLocalizedString(@"FM_GPU_SPEED_DESCRIPTION", @"If your divine flag is working properly, please do not change this option!");
        
        [self addSubview:_descriptionTextField];
    }
    
    return _descriptionTextField;
}

@end
