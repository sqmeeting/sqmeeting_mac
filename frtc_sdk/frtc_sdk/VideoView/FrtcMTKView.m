#import "FrtcMTKView.h"
#import "FrtcMTKRender.h"
#import "FrtcSDKBundle.h"
#import "FrtcCall.h"

@interface FrtcMTKView()

@property (nonatomic, strong) NSTextField *waterPrintingTextField;

@property (nonatomic, assign, getter = isRendering) BOOL inRendering;

@property (nonatomic, strong) NSImageView* backgroundMute;

@property (nonatomic, strong) FrtcMTKRender *videoRender;

@property (nonatomic, copy)   NSString *bundleDirectory;

@end

@implementation FrtcMTKView

- (instancetype)initWithFrame:(NSRect)frameRect mediaID:(NSString *)mediaID {
    if(self = [super initWithFrame:frameRect]) {
        self.mediaID = mediaID;
        
        if([mediaID isEqualToString:@"VPL_PREVIEW"]) {
            self.bundleDirectory = [FrtcSDKBundle bundlePath:@"local_preview_off.png"];
            self.userNameView.hidden = YES;
            self.userMuteView.hidden = YES;
        } else {
            self.bundleDirectory = [FrtcSDKBundle bundlePath:@"call_camera_off.png"];
        }
        
        self.userMuteView = [[FrtcUserMuteView alloc] initWithFrame:CGRectMake(0, frameRect.size.height - 30, 30, 30)];
        [self addSubview:self.userMuteView];
        
        NSFont *font             = [NSFont systemFontOfSize:24.0f];
        NSDictionary *attributes = @{ NSFontAttributeName:font};
        CGSize size              = [self.siteNameTextField.stringValue sizeWithAttributes:attributes];
        
        self.siteNameTextField.frame = NSMakeRect(0, self.frame.size.height / 2 -  size.height / 2, self.frame.size.width, size.height);
        
        _videoRender = [[FrtcMTKRender alloc] initWithMetalKitView:self];
        self.delegate = _videoRender;
        
        [self addNotification];
    }
        
    return self;
}

- (void)addNotification {
    self.postsFrameChangedNotifications = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewRectTransformation:) name:NSViewFrameDidChangeNotification object:self];
}

- (void)viewRectTransformation:(NSNotification*) notification {
    self.backgroundMute.frame    = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.userNameView.frame     = CGRectMake(0, self.frame.size.height - 24, 300, 24);
    self.userMuteView.frame     = CGRectMake(0, self.frame.size.height - 30, 30, 30);
    
    NSFont *font             = [NSFont systemFontOfSize:24.0f];
    NSDictionary *attributes = @{ NSFontAttributeName:font };
    CGSize size              = [self.siteNameTextField.stringValue sizeWithAttributes:attributes];
    
    CGFloat x = 0;
    CGFloat y = self.frame.size.height / 2 -  size.height / 2;
    CGFloat width = self.frame.size.width;
    CGFloat height = size.height;
    
    self.siteNameTextField.frame = NSMakeRect(x, y, width, height);
}

- (void)dealloc {
    NSLog(@"---------------metal video view----------dealloc");
}

- (BOOL)isFlipped {
    return YES;
}

- (BOOL)acceptsFirstResponder {
    return YES;

}

- (void)awakeFromNib {
    NSTrackingAreaOptions options = (NSTrackingActiveAlways
                                     | NSTrackingInVisibleRect
                                     | NSTrackingMouseEnteredAndExited
                                     | NSTrackingMouseMoved);

    NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:[self bounds]
                                                        options:options
                                                          owner:self
                                                       userInfo:nil];
    [self addTrackingArea:area];
}


- (BOOL)acceptsFirstMouse:(nullable NSEvent *)event {
    return YES;
}

-(void)setupWaterMark:(NSString *)waterMarkInfomation {
    NSString *temp = waterMarkInfomation;
    for(int i = 0; i < 10; i++) {
        waterMarkInfomation = [waterMarkInfomation stringByAppendingFormat:@" %@", temp];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.waterPrintingTextField.stringValue = waterMarkInfomation;
    });
}

- (void)updateSiteNameView:(BOOL)userMute {
    [self.userNameView updateMuteView:userMute];
    [self.userMuteView updateMuteView:userMute];
}

-(NSString*)mediaID {
    return self.videoRender.mediaID;
}

#pragma mark- public functions
- (void)setVideoRenderMediaID:(NSString *)renderMeidaID {
    self.videoRender.mediaID = renderMeidaID;
}

-(void)displayMuteViews:(BOOL)isDisplay {
    if(isDisplay) {
        self.backgroundMute.hidden = NO;
        if(![self.mediaID isEqualToString:@"VPL_PREVIEW"]) {
            self.backgroundMute.hidden    = NO;
            self.siteNameTextField.hidden = NO;
            self.userMuteView.hidden      = NO;
        }
    } else {
        self.backgroundMute.hidden    = YES;
        self.siteNameTextField.hidden = YES;
        self.userMuteView.hidden      = YES;
    }
}

- (void)initiateVideoRendering {
    if(!self.inRendering) {
        self.inRendering = true;
        [self.videoRender initiateVideoRendering];
    }
}

-(void)endupVideoRendering {
    if(self.inRendering) {
        self.inRendering = NO;
        [self.videoRender endupVideoRendering];
    }
}

- (void)renewWaterPrinting {
    CGFloat x = 0;
    CGFloat y = self.frame.size.height - 110;
    CGFloat width = self.frame.size.width + 250;
    CGFloat height = 110;
    
    self.waterPrintingTextField.frame = CGRectMake(x, y, width, height);
}

- (void)configVideoColorFormat:(RTC::VideoColorFormat)format {
    [self.videoRender configVideoColorFormat:format];
}

- (void)setRemoteUserActivitySpeakerStatus:(BOOL)isActivity {
    if(isActivity) {
        self.layer.borderWidth = 2.0;
        self.layer.borderColor = [NSColor greenColor].CGColor;
    } else {
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [NSColor blackColor].CGColor;
    }
}

- (NSTextField *)siteNameTextField {
    if (!_siteNameTextField){
        _siteNameTextField = [[NSTextField alloc] init];
        _siteNameTextField.bordered = NO;
        _siteNameTextField.drawsBackground = NO;
        _siteNameTextField.backgroundColor = [NSColor clearColor];
        _siteNameTextField.textColor = [NSColor whiteColor];
        _siteNameTextField.maximumNumberOfLines = 1;
        _siteNameTextField.font = [NSFont systemFontOfSize:24.0];
        _siteNameTextField.alignment = NSTextAlignmentCenter;
        _siteNameTextField.editable = NO;
        _siteNameTextField.lineBreakMode = NSLineBreakByTruncatingTail;
        _siteNameTextField.maximumNumberOfLines = 1;
        [self addSubview:_siteNameTextField];
    }
    
    return _siteNameTextField;
}

- (NSTextField *)waterPrintingTextField {
    if (!_waterPrintingTextField) {
        _waterPrintingTextField = [[NSTextField alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 110, self.frame.size.width + 250, 110)];;
        _waterPrintingTextField.editable = NO;
        _waterPrintingTextField.bordered = NO;
        _waterPrintingTextField.backgroundColor = [NSColor clearColor];
        _waterPrintingTextField.alignment = NSTextAlignmentCenter;
        _waterPrintingTextField.maximumNumberOfLines = 1.0;
        _waterPrintingTextField.font = [NSFont systemFontOfSize:100.0];
        _waterPrintingTextField.font = [NSFont systemFontOfSize:28.0];
        _waterPrintingTextField.wantsLayer = YES;
        _waterPrintingTextField.lineBreakMode = NSLineBreakByCharWrapping;
        _waterPrintingTextField.textColor = [NSColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:0.16];
        [_waterPrintingTextField rotateByAngle:-25];
        
        [self addSubview:_waterPrintingTextField];
    }
    
    return _waterPrintingTextField;
}

- (FrtcMeetingUserView *)userNameView {
    if(!_userNameView) {
        _userNameView = [[FrtcMeetingUserView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 24, 300, 24)];
        [self addSubview:self.userNameView];
    }
    
    return _userNameView;
}


- (NSImageView *)backgroundMute {
    if(!_backgroundMute) {
        _backgroundMute = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:self.bundleDirectory];
        [_backgroundMute setImage:image];
        _backgroundMute.imageScaling = NSImageScaleAxesIndependently;
        [self addSubview:_backgroundMute];
    }
    
    return _backgroundMute;
}

@end
