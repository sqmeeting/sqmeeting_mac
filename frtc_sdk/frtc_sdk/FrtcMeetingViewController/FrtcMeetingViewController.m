#import "FrtcMeetingViewController.h"
#import "MeetingUserInformation.h"
#import "MeetingLayoutContext.h"
#import "FrtcMTKView.h"
#import "DeviceObject.h"
#import "MeetingBackground.h"
#import "FrtcSDKBundle.h"
#import "LocationContext.h"
#import "ScreenSizeUtil.h"

#define WIDHT  [[ScreenSizeUtil sharedSizeUtil] disPlayWidth:self.currentScreen]
#define HEIGHT [[ScreenSizeUtil sharedSizeUtil] disPlayHeight:self.currentScreen]
#define SCREEN_SIZE [[ScreenSizeUtil sharedSizeUtil] screenSize:self.currentScreen]
#define CURRENT_SIZE [[ScreenSizeUtil sharedSizeUtil] currentScreenSize:self.currentScreen]
#define RATIO [[ScreenSizeUtil sharedSizeUtil] screenRation:self.currentScreen]

@interface FrtcMeetingViewController ()< ObjectInterfaceDelegate, NSWindowDelegate> {
    ObjectImpl* _impl;
}

@property (nonatomic, strong) MeetingBackground *videoViewContainer;

@property (nonatomic, assign, getter=isFullScreen) BOOL fullScreen;

@property (nonatomic, assign, getter=isContentLayoutReady) BOOL contentLayoutReady;

@property (nonatomic, assign, getter=isReturnToFullScreen) BOOL returnToFullScreen;

@property (nonatomic, assign, getter=isExitFromeFullScreen) BOOL exitFromeFullScreen;

@property (nonatomic, assign, getter=isWaterMask) BOOL waterMask;

@property (nonatomic) NSSize fullScreenSize;

@property (nonatomic, strong) NSEvent *mDoubleEventMonitor;

@property (nonatomic, strong) NSScreen *currentScreen;

@property (nonatomic, assign) NSSize currentScreenSize;

@property (nonatomic, assign, getter = isContent)               BOOL content;

@property (nonatomic, assign, getter = isSendingContent)        BOOL sendingContent;

@property (nonatomic, assign, getter = isLocalViewHiddenByUser) BOOL localViewHiddenByUser;

@end

@implementation FrtcMeetingViewController

- (id)init {
    NSBundle *myBundle = [FrtcSDKBundle bundle];
    if(self = [super initWithNibName:@"FrtcMeetingViewController" bundle:myBundle]) {
        [ObjectInterface sharedObjectInterface].delegate = self;

        self.waterMask = NO;
        self.presenterLayout = YES;
        [self.view.window setLevel:NSMainMenuWindowLevel + 2];
    }

    return self;
}

- (void)dealloc {
    NSLog(@"---------dealloc----------");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidResizeNotification object:nil];
}

- (void)refreshCurrentLayout {
    [self.videoViewContainer refreshCurrentLayout];
}

- (void)setPresenterLayout:(BOOL)presenterLayout {
    _presenterLayout = presenterLayout;
    self.videoViewContainer.presenterLayout = presenterLayout;
    
    if(!self.isContent) {
        self.gallery         = !presenterLayout;
        [self.videoViewContainer switchLayout:!presenterLayout];
    }
}

- (void)setDisplayName:(NSString *)displayName {
    _displayName = displayName;
    self.videoViewContainer.displayName = _displayName;
}

- (void)switchLayout:(BOOL)isGallery {
    [self.videoViewContainer switchLayout:isGallery];
    self.gallery            = isGallery;
    self.presenterLayout    = !isGallery;
}

- (void)windowDidEnterFullScreen:(NSNotification *)notification {
    NSScreen *currentScreen = [self.view.window screen];
    NSRect frame = currentScreen.visibleFrame;
    
    if(SCREEN_SIZE.height > frame.size.height) {
        if(self.callDelegate && [self.callDelegate respondsToSelector:@selector(onMenuShelterShow:)]) {
            [self.callDelegate onMenuShelterShow:YES];
        }
    }
}

- (void)test:(NSNotification *)aNotification {
    if([[aNotification object] isEqual:self.view.window]) {
        if(self.view.window.occlusionState == 8194) {
            printf("\n test test test test test");
        } else {
            printf("\n not test not test not test not test");
        }
    }
}

- (void)windowWillEnterFullScreen:(NSNotification *)notification {
    [self fullScreenNotification:1];
    self.fullScreen = YES;
    self.videoViewContainer.fullScreen = YES;
}

- (void)windowWillExitFullScreen:(NSNotification *)notification {
    [self fullScreenNotification:0];
    self.fullScreen = NO;
    self.videoViewContainer.fullScreen = NO;
    self.exitFromeFullScreen = YES;
}

- (void)windowDidExitFullScreen:(NSNotification *)notification {
    if(self.callDelegate && [self.callDelegate respondsToSelector:@selector(onMenuShelterShow:)]) {
        [self.callDelegate onMenuShelterShow:NO];
    }
}

- (void)quitFullScreenMode {
    self.videoViewContainer.remoteViewHidden = NO;
    if(self.isContentLayoutReady) {
        return;
    }
    
    CGFloat titleBarHeight = [self titleBarHeight];
    CGRect rect;
    for(NSScreen* screen in [NSScreen screens]) {
        if([[self.view.window screen] isEqualTo:screen]) {
            CGFloat x = screen.frame.origin.x + ([screen frame].size.width - WIDHT) / 2;
            CGFloat y = screen.frame.origin.y + ([screen frame].size.height - (HEIGHT + titleBarHeight)) / 2;
            
            CGFloat width = WIDHT;
            CGFloat height = HEIGHT + titleBarHeight;
            
            rect =  CGRectMake(x, y, width, height);
            
            break;
        }
    }
    
    self.contentLayoutReady = NO;
    self.view.frame = NSMakeRect(0, 0, WIDHT, HEIGHT);
    
    [self.videoViewContainer setFrame:CGRectMake(0, 0, WIDHT, HEIGHT)];
    [self.view.window setFrame:rect display:YES animate:YES];

    if(self.mDoubleEventMonitor) {
        [NSEvent removeMonitor:self.mDoubleEventMonitor];
        self.mDoubleEventMonitor = nil;
    }

    if(!self.isPresenterLayout) {
        [[MeetingLayoutContext shareIstance] switchLayoutByStrategy:MEETING_LAYOUT_GALLERY_LAYOUT];
    }
    
    [self refreshCurrentLayout];
    
    if(self.isWaterMask) {
        [self.videoViewContainer.contentVideoView renewWaterPrinting];
    }
}

- (void)transferFullScreenMode {
    CGFloat width  = SCREEN_SIZE.width;
    CGFloat height = SCREEN_SIZE.height;
    CGFloat x = width / height;
    CGFloat y = 16.0 / 9.0;
    
    NSSize fullScreenSize;
    if(x > y) {
        fullScreenSize = NSMakeSize(16 * height / 9, height);
    } else {
        fullScreenSize = NSMakeSize(width, 9 * width / 16);
    }
    
    self.fullScreenSize = fullScreenSize;
    self.videoViewContainer.currentSize    = CURRENT_SIZE;
    self.videoViewContainer.screenSize     = SCREEN_SIZE;
    self.videoViewContainer.fullScreenSize = fullScreenSize;
    
    [self.view setFrame:CGRectMake(0, 0, width, height)];
    [self.videoViewContainer setFrame:CGRectMake(0, 0, width, height)];
    
    if(!self.isPresenterLayout) {
        [[MeetingLayoutContext shareIstance] switchLayoutByStrategy:MEETING_LAYOUT_FULL_SCREEN_GALLERY_LAYOUT];
    }
    
    [self refreshCurrentLayout];
    
    if(self.isWaterMask) {
        [self.videoViewContainer.contentVideoView renewWaterPrinting];
    }
    
    __weak typeof(self) weakSelf = self;
    self.mDoubleEventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask: NSEventMaskLeftMouseUp
        handler:^NSEvent*_Nullable(NSEvent* event) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;

        if (event.clickCount == 2) {
            NSMutableArray *viewArray = [[MeetingLayoutContext shareIstance] participantsList];
            if(viewArray.count == 1) {
                return nil;
            }
            
            if(!strongSelf.isPresenterLayout) {
                return nil;
            }
            
            if(strongSelf.videoViewContainer.isRemoteViewHidden) {
                strongSelf.videoViewContainer.remoteViewHidden = NO;
            } else {
                strongSelf.videoViewContainer.remoteViewHidden = YES;
            }
        }
        [strongSelf refreshCurrentLayout];
        return event;
    }];
}

- (void)windowDidMove:(NSNotification *)notification {
    if([[notification object] isEqual:self.view.window]) {
        NSScreen *screen = [self.view.window screen];
        if(![self.currentScreen isEqualTo:screen]) {
            self.currentScreen = screen;
            CGFloat titleBarHeight = [self titleBarHeight];
            CGRect rect;
          
            for(NSScreen* screen in [NSScreen screens]) {
                if([[self.view.window screen] isEqualTo:screen]) {
                    if(self.isSendingContent) {
                        
                        CGFloat x = screen.frame.origin.x + screen.frame.size.width - 320 * RATIO;
                        CGFloat y = 60;
                        CGFloat width = 320 * RATIO;
                        CGFloat height = 180 * RATIO + titleBarHeight;
                        
                        rect = CGRectMake(x, y, width, height);
                        titleBarHeight = [self titleBarHeight];
                        
                        self.contentLayoutReady = YES;
                        self.view.frame = NSMakeRect(0, 0, 320 * RATIO, 180 * RATIO);
                        [self.videoViewContainer setFrame:CGRectMake(0, 0, 320 * RATIO, 180 * RATIO)];
                    } else {
                        CGFloat x = screen.frame.origin.x + ([screen frame].size.width - WIDHT) / 2;
                        CGFloat y = screen.frame.origin.y + ([screen frame].size.height - (HEIGHT + titleBarHeight)) / 2;
                        CGFloat width = WIDHT;
                        CGFloat height = HEIGHT + titleBarHeight;
                        
                        rect = CGRectMake(x, y, width, height);
                     
                        self.contentLayoutReady = NO;
                        self.view.frame = NSMakeRect(0, 0, WIDHT, HEIGHT);
                        [self.videoViewContainer setFrame:CGRectMake(0, 0, WIDHT, HEIGHT)];
                    }
        
                    break;
                }
            }

            NSValue *valueNewSize = [NSValue valueWithSize:NSMakeSize(WIDHT, HEIGHT)];
           
            if(self.callDelegate && [self.callDelegate respondsToSelector:@selector(onScreenChange:withScreenSize:)]) {
                [self.callDelegate onScreenChange:self.currentScreen withScreenSize:[valueNewSize sizeValue]];
            }
            [self.view.window setFrame:[screen frame] display:YES animate:YES];
            
            [self refreshCurrentLayout];
        }
    }
}

- (void)windowDidResize:(NSNotification *)aNotification {
    if([[aNotification object] isEqual:self.view.window]) {
        if(self.fullScreen) {
            [self transferFullScreenMode];
        } else {
            if(self.isExitFromeFullScreen) {
                self.exitFromeFullScreen = NO;
                [[self.view.window standardWindowButton:NSWindowMiniaturizeButton] setEnabled:YES];
                [self quitFullScreenMode];
            }
        }
    }
}

- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize {
    if(!self.isFullScreen) {
        if(self.isSendingContent) {
            return NSMakeSize(320 * RATIO , 180 * RATIO + 22);
        } else {
            return NSMakeSize(WIDHT, HEIGHT + 22);
        }
    } else {
        return frameSize;
    }
}

- (void)fullScreenNotification:(NSInteger)state {
    if(self.callDelegate && [self.callDelegate respondsToSelector:@selector(onFullScreenState:)]) {
        [self.callDelegate onFullScreenState:state];
    }
}

- (BOOL)windowShouldZoom:(NSWindow *)window toFrame:(NSRect)newFrame {
    return NO;
}

- (void)windowWillClose:(NSNotification *)notification {
    if([[notification object] isEqual:self.view.window]) {
        [self endMeeting];
    }
}

- (BOOL)windowShouldClose:(id)sender {
    if(self.callDelegate && [self.callDelegate respondsToSelector:@selector(onCloseWindow)]) {
        [self.callDelegate onCloseWindow];
    }
    return NO;
}

- (void)viewDidAppear {
    [super viewDidAppear];
    self.currentScreen = [self.view.window screen];
    self.view.window.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentScreenSize = SCREEN_SIZE;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResize:)  name:NSWindowDidResizeNotification  object:self];
    
    self.view.frame = NSMakeRect(0, 0, WIDHT, HEIGHT);
    self.videoViewContainer = [[MeetingBackground alloc] initWithFrame:CGRectMake(0, 0, WIDHT, HEIGHT)];
    self.videoViewContainer.screenSize      = SCREEN_SIZE;
    self.videoViewContainer.currentSize     = CURRENT_SIZE;
    self.videoViewContainer.fullScreenSize  = [self fullScreenSize];
    self.videoViewContainer.ratio           = RATIO;
    
    self.videoViewContainer.imageScaling = NSImageScaleAxesIndependently;
    [self.view addSubview:self.videoViewContainer];
    

    self.fullScreen = NO;
    self.contentLayoutReady = NO;
    self.returnToFullScreen = NO;
  
    _shareContentType = FRTCSDK_SHARE_CONTENT_IDLE;
    
    self.sendingContent = NO;
    if(self.isPresenterLayout) {
        [[MeetingLayoutContext shareIstance] switchLayoutByStrategy:MEETING_LAYOUT_PRESENTER_LAYOUT];
    } else {
        [[MeetingLayoutContext shareIstance] switchLayoutByStrategy:MEETING_LAYOUT_GALLERY_LAYOUT];
    }
}

- (void)endMeeting {
    [[ObjectInterface sharedObjectInterface] endMeetingWithCallIndex:0];
}

#pragma mark - Class Interface
- (void)stopLocalRender:(BOOL)stop {
    [self.videoViewContainer stopLocalRender:stop];
}

- (void)disappearLocal:(BOOL)disapper {
    [self.videoViewContainer disappearLocal:disapper];
}

- (void)clearContentAudio {
    [[ObjectInterface sharedObjectInterface] clearContentAudio];
}

#pragma mark --Remote Notification
- (void)muteStateChanged:(NSMutableArray *)array {
    [self.videoViewContainer muteStateChanged:array];
}

- (void)onWaterPrint:(NSString *)waterPrint {
    NSData *jsonData = [waterPrint dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(!err) {
        self.waterMask = [(NSNumber *)dic[@"enable"] boolValue];
    }
    
    [self.videoViewContainer onWaterPrint:waterPrint];
    self.videoViewContainer.displayName = self.displayName;
}

- (void)callStateChanged:(CallMeetingStatus)callStated {
    if(callStated == kDisconnected) {
        [[MeetingLayoutContext shareIstance] refreshParticipants];
    }
}

- (void)contentStateChanged:(BOOL)isSending {
    if (isSending && self.sendingContent) {
        return;
    }
    if (!isSending && !self.sendingContent) {
        return;
    }
    
    self.sendingContent = isSending;
    self.videoViewContainer.sendingContent = isSending;
    
    if (isSending){
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.isFullScreen) {
                [self.view.window toggleFullScreen:nil];
            }
            
            [[self.view.window standardWindowButton:NSWindowMiniaturizeButton] setEnabled:YES];
            [[self.view.window standardWindowButton:NSWindowZoomButton] setEnabled:NO];
           
            
            CGFloat titleBarHeight = [self titleBarHeight];
            CGRect rect;
    
            for(NSScreen* screen in [NSScreen screens]) {
                if([[self.view.window screen] isEqualTo:screen]) {
                    CGFloat x = screen.frame.origin.x + screen.frame.size.width- 320 * RATIO;
                    CGFloat y = screen.frame.origin.y + 60;
                    
                    CGFloat width  = 320 * RATIO;
                    CGFloat height = 180 * RATIO + titleBarHeight;
                    rect = CGRectMake(x, y, width, height);
                }
            }
            
            self.videoViewContainer.contentVideoView.hidden = YES;
            self.videoViewContainer.contentLayoutReady = YES;
            [self.view.window setFrame:rect display:YES animate:YES];
            
            self.contentLayoutReady = YES;
            
            self.view.frame = NSMakeRect(0, 0, 320 * RATIO, 180 * RATIO);
            [self.videoViewContainer setFrame:CGRectMake(0, 0, 320 * RATIO, 180 * RATIO)];

            [self refreshCurrentLayout];
        });
    }
    else {
        [self clearContentAudio];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self.view.window standardWindowButton:NSWindowZoomButton] setEnabled:YES];
            [[self.view.window standardWindowButton:NSWindowMiniaturizeButton] setEnabled:YES];
            
            CGFloat titleBarHeight = [self titleBarHeight];
            CGRect rect;
            for(NSScreen* screen in [NSScreen screens]) {
                if([[self.view.window screen] isEqualTo:screen]) {
                    CGFloat x = screen.frame.origin.x + ([screen frame].size.width - WIDHT) / 2;
                    CGFloat y = screen.frame.origin.y + ([screen frame].size.height - (HEIGHT + titleBarHeight)) / 2;
                    CGFloat width  = WIDHT;
                    CGFloat height = HEIGHT + titleBarHeight;
                    
                    rect =  CGRectMake(x, y, width, height);
                    
                    break;
                }
            }
            
            self.contentLayoutReady = NO;
            self.videoViewContainer.contentLayoutReady = NO;
            self.view.frame = NSMakeRect(0, 0, WIDHT, HEIGHT);
            
            [self.videoViewContainer setFrame:CGRectMake(0, 0, WIDHT, HEIGHT)];
            [self.view.window setFrame:rect display:YES animate:YES];
            [self refreshCurrentLayout];
            [self.view.window makeKeyAndOrderFront:self];
        });
    }
}

- (void)layoutUpdate:(SDKLayoutInfo)buffer {
    [self.videoViewContainer layoutUpdate:buffer];
    
    bool isContent = buffer.bContent;
    if(isContent && !self.isSendingContent) {
        if(!self.content) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.content = YES;
                self.presenterLayout = YES;
                
                if(self.callDelegate && [self.callDelegate respondsToSelector:@selector(onContentState:)]) {
                    [self.callDelegate onContentState:2];
                }
            });
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.content) {
                if(self.callDelegate && [self.callDelegate respondsToSelector:@selector(onContentState:)]) {
                    [self.callDelegate onContentState:3];
                }
            }
            self.content = NO;
            if(self.isGallery) {
                self.presenterLayout = NO;
                self.videoViewContainer.presenterLayout = NO;
            }
        });
    }
}

- (void)onVideoFrozen:(NSString *)mediaId videoFrozen:(BOOL)bFrozen {
    [self.videoViewContainer onVideoFrozen:mediaId videoFrozen:bFrozen];
}

- (CGFloat)titleBarHeight {
    return self.view.window.frame.size.height - ((NSView *)self.view.window.contentView).frame.size.height;
}

- (void)stopVideoRender {
    [self.videoViewContainer stopVideoRender];
}

- (void)remoteVideoReceived:(NSString *)mediaID {
    [self.videoViewContainer remoteMediaID:mediaID];
}

- (void)remoteAudioReceived:(NSString *)mediaID {
   
}

- (void)onVideoRemoved:(NSString *)mediaID {

}


@end
