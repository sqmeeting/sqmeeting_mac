#import "ShareToolBarAdaptor.h"
#import "FrtcShareContentToolBar.h"
#import "AppDelegate.h"
#import "FrtcParticipantsWindow.h"
#import "FrtcParticipantsViewController.h"
#import "FrtcInCallSettingWindow.h"
#import "FrtcMeetingDetailInfoWindow.h"
#import "FrtcMediaStaticsViewWindow.h"
#import "FrtcMediaStaticsView.h"
#import "StaticsWindowController.h"
#import "FrtcStaticsViewController.h"
#import "FrtcVideoRecordingSuccessWindow.h"
#import "FrtcEnableMessageWindow.h"
#import "FrtcMeetingManagement.h"

#import "FrtcVideoRecordingWindow.h"
#import "FrtcVideoRecordingEndWindow.h"
#import "FrtcVideoStreamingWindow.h"
#import "FrtcVideoStreamingUrlWindow.h"
#import "FrtcVideoStreamingWindow.h"
#import "FrtcVideoStreamingEndWindow.h"
#import "FrtcStreamingUrlPopViewController.h"

#import "FrtcPopupViewController.h"
#import "FrtcPopover.h"

#define kSharingBarHiddenHeight (SHARING_BAR_BORDER_WIDTH * 2 + 2)
#define SHOW_HIDE_BAR_ANIMATION_STEP 2
#define kOneStepMovedHeight TOOL_BAR_HEIGHT / SHOW_HIDE_BAR_ANIMATION_STEP

@interface ShareToolBarAdaptor() <ContentToolBarDelegate, FrtcParticipantsViewControllerDelegate, FrtcParticipantsViewControllerDelegate, FrtcMediaStaticsViewWindowDelegate, FrtcVideoRecordingSuccessWindowDelegate, FrtcEnableMessageWindowDelegate, FrtcEnableMessageWindowDelegate, FrtcVideoRecordingWindowDelegate, FrtcVideoRecordingEndWindowwDelegate, FrtcVideoStreamingWindowDelegate, FrtcVideoStreamingEndWindowwDelegate, FrtcStreamingUrlPopViewControllerDelegate, NSPopoverDelegate>

@property (nonatomic, assign) NSSize  screenSize;
@property (nonatomic, assign) NSPoint origin;
@property (nonatomic, assign) CGFloat menuHeight;

@property (nonatomic, strong) FrtcParticipantsWindow            *participantsWindow;
@property (nonatomic, strong) FrtcInCallSettingWindow           *callSettingWindow;
@property (nonatomic, strong) FrtcMeetingDetailInfoWindow       *infoWindow;
@property (nonatomic, strong) FrtcMediaStaticsViewWindow        *staticsViewWindow;
@property (nonatomic, strong) StaticsWindowController           *staticsWindowController;
@property (nonatomic, strong) FrtcVideoRecordingSuccessWindow   *recordingSuccessWindow;
@property (nonatomic, strong) FrtcEnableMessageWindow           *enableMessageWindow;

@property (nonatomic, strong) FrtcVideoRecordingWindow          *startVideoRecordingWindow;
@property (nonatomic, strong) FrtcVideoRecordingEndWindow       *endVideoRecordingWindow;
@property (nonatomic, strong) FrtcVideoStreamingWindow          *startVideoStreamingWindow;
@property (nonatomic, strong) FrtcVideoStreamingEndWindow       *endVideoStreamingWindow;
@property (nonatomic, strong) FrtcVideoStreamingUrlWindow       *streamingUrlWindow;

@property (nonatomic, strong) NSPopover     *popover;

@property (nonatomic, strong) FrtcStatisticalModel *staticsModel;

@property (nonatomic, assign) NSInteger barWidth;

@property (nonatomic, assign, getter=isRecording) BOOL recording;

@property (nonatomic, assign, getter=isStreaming) BOOL streaming;

@property (nonatomic, copy) NSString *streamingUrl;

@property (nonatomic, copy) NSString *streamingPassword;

@property (nonatomic, strong) NSMutableDictionary *requestDictionary;

@property (nonatomic, assign, getter=isNewRequest) BOOL newRequest;

@property (nonatomic, assign, getter=isPopoverShow) BOOL popoverShow;

@end

@implementation ShareToolBarAdaptor

int i = 1;
int j = 1;

#pragma dealloc or init function
- (instancetype)init {
    if (self = [super init]) {
        [self getScreenParam];
        _contentControlToolBar = [[FrtcShareContentToolBar alloc] init];
        _contentControlToolBar.shareBarDelegate = self;
        _requestDictionary = [NSMutableDictionary dictionary];
        [self addTrackingAreaForSharingHandle];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMidiaButtonStatus:) name:FMeetingUpInCallModelNotNotification object:nil];
        __weak __typeof(self)weakSelf = self;
        [[FrtcInfoInstance sharedFrtcInfoInstance] setupMeetingTime:^(NSString * _Nonnull meetingTime) {
            weakSelf.contentControlToolBar.timeTextField.stringValue = meetingTime;
        }];
    }
    return self;
}

- (void)dealloc {
    [self removeTrackingAreaForSharingHandle];
    [self stopHideTimer];
    [self stopShowTimer];
    [self stopDisplayTimer];
}

- (void)onMeetingStatusChangedFrom:(MeetingStatus)oldStatus to:(MeetingStatus)newStatus {
    if (oldStatus == MEETING_STAT_PLAYING && newStatus != MEETING_STAT_PLAYING) {
        [self showOrHideAllSharingWindow:NO];
        
        [self stopHideTimer];
        [self stopShowTimer];
        [self stopDisplayTimer];
    }
    
    if (oldStatus != MEETING_STAT_PLAYING && newStatus == MEETING_STAT_PLAYING) {
        [self showOrHideAllSharingWindow:YES];
        [self startDisplayTimer];
    }
}

- (void)handleRequestUnmuteUser:(NSMutableDictionary *)nameDictionary {
    self.newRequest = YES;
    
    [self.requestDictionary setObject: [nameDictionary allValues][0] forKey:[nameDictionary allKeys][0]];
    
    if([self.participantsWindow isVisible]) {
        [(FrtcParticipantsViewController *)(self.participantsWindow.contentViewController) updateRequestCell:[nameDictionary allValues][0] isShow:YES isNewRequest:self.isNewRequest];
    }
}

- (void)recordingStatus:(NSDictionary *)params {
    self.params = params;
    NSString *strRecording = params[@"recordingStatus"];
    
    if([strRecording isEqualToString:@"STARTED"]) {
        if(!self.isColsedByUser) {
            [self showRecordingSuccess:YES];
        }
    } else {
        [self showRecordingSuccess:NO];
    }
}

#pragma show or hide releted windows
- (void)showRecordingSuccess:(BOOL)isShow {
    if(isShow) {
        if(self.isColsedByUser) {
            return;
        }
        
        NSString *strRecording = self.params[@"recordingStatus"];
        
        if(self.params == nil || ![strRecording isEqualToString:@"STARTED"]) {
            return;
        }
        
        if([self.recordingSuccessWindow isVisible]) {
            [self.recordingSuccessWindow makeKeyAndOrderFront:self];
        } else {
            self.recordingSuccessWindow = [[FrtcVideoRecordingSuccessWindow alloc] initWithSize:NSMakeSize(244, 170)];
            self.recordingSuccessWindow.titleVisibility       = NSWindowTitleHidden;
            self.recordingSuccessWindow.closedDelegate        = self;
            [self.recordingSuccessWindow makeKeyAndOrderFront:self];
            [self.recordingSuccessWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
            [self.recordingSuccessWindow center];
        }
    } else {
        if([self.recordingSuccessWindow isVisible]) {
            [self.recordingSuccessWindow close];
        }
    }
}

- (void)showOrHideMainWindow:(BOOL) show {
    if (show) {
        NSApplication* app = [NSApplication sharedApplication];
        NSWindow *mainWindow = ((AppDelegate*)(app.delegate)).window;
        [mainWindow orderBack:nil];
        [mainWindow makeKeyAndOrderFront:nil];
    } else {
        NSApplication* app = [NSApplication sharedApplication];
        NSWindow *mainWindow = ((AppDelegate*)(app.delegate)).window;
        [mainWindow orderOut:nil];
    }
}

- (void)showOrHideAllSharingWindow:(BOOL)show {
    if (show) {
        [self getScreenParam];
        NSRect sharingBarFrame  = NSMakeRect(self.origin.x + self.screenSize.width/2 - self.barWidth/2, self.origin.y + self.screenSize.height - TOOL_BAR_HEIGHT - self.menuHeight, self.barWidth, TOOL_BAR_HEIGHT);
        [_contentControlToolBar setFrame:sharingBarFrame display:YES];
        _contentControlToolBar.nameTextField.stringValue = self.inCallModel.conferenceName;
        [_contentControlToolBar orderBack:nil];
        [_contentControlToolBar reBackLayout];
        
    } else {
        [_contentControlToolBar orderOut:nil];
    }
    
}

- (void)updatecontentControlToolBarInCallModel:(FrtcInCallModel *)incallModel {
    self.inCallModel = incallModel;
    BOOL meetingOwner;
    if([self.inCallModel.ownerID isEqualToString:self.inCallModel.userID]) {
        meetingOwner = YES;
    } else {
        meetingOwner = NO;
    }
     
    if(!self.inCallModel.authority) {
        if(meetingOwner) {
            BOOL enableLab = [[FrtcUserDefault defaultSingleton] boolObjectForKey:ENABLE_LAB_FEATURE];
            if(!enableLab) {
                self.barWidth = 672;
            } else {
                self.barWidth = 752;
            }
        } else {
            self.barWidth = 496;
        }
    } else {
        BOOL enableLab = [[FrtcUserDefault defaultSingleton] boolObjectForKey:ENABLE_LAB_FEATURE];
        if(!enableLab) {
            self.barWidth = 672;
        } else {
            self.barWidth = 832;
        }
    }
    [_contentControlToolBar updateLayout:incallModel.authority meetingOwner:meetingOwner];
    
    [_contentControlToolBar.muteAudioButton setState:self.inCallModel.muteMicrophone ? NSControlStateValueOff :NSControlStateValueOn];
    _contentControlToolBar.muteAudioLabel.stringValue = self.inCallModel.muteMicrophone ? NSLocalizedString(@"FM_UN_MUTE", @"Unmute") : NSLocalizedString(@"FM_MUTE", @"Mute");
    
    [_contentControlToolBar.videoMuteButton setState:self.inCallModel.muteCamera ? NSControlStateValueOff :NSControlStateValueOn];
    _contentControlToolBar.videoMuteLabel.stringValue = self.inCallModel.muteCamera ? NSLocalizedString(@"FM_OPEN_VIDEO", @"Start Video") : NSLocalizedString(@"FM_CLOSE_VIDEO", @"Stop Video");
    [self updateRecordingUI:self.params withHeight:0];
}

#pragma mark -- FrtcVideoRecordingSuccessWindowDelegate
- (void)closedByUser {
    self.colsedByUser = YES;
    
    if(self.closedDelegate && [self.closedDelegate respondsToSelector:@selector(closedByUser:)]) {
        [self.closedDelegate closedByUser:YES];
    }
}

#pragma mark ---Notifiacation Observer
-(void)onMidiaButtonStatus:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    self.inCallModel = [userInfo valueForKey:FMeetingUpInCallModelKey];
    
    [self updatecontentControlToolBarInCallModel:self.inCallModel];
}

#pragma mark --ContentToolBarDelegate--
- (void)stopShareContent {
    if([self.participantsWindow isVisible]) {
        [self.participantsWindow close];
    }
    
    if([self.staticsViewWindow isVisible]) {
        [self.staticsViewWindow close];
    }
    
    if([self.callSettingWindow isVisible]) {
        [self.callSettingWindow close];
    }
    
    if([self.infoWindow isVisible]) {
        [self.infoWindow close];
    }
}

- (void)showStatics {
    if([self.staticsViewWindow isVisible]) {
        [self.staticsViewWindow makeKeyAndOrderFront:self];
    } else {
        self.staticsViewWindow = [[FrtcMediaStaticsViewWindow alloc] initWithSize:NSMakeSize(260, 237)];
        self.staticsViewWindow.staticsWindowDelegate = self;
        self.staticsViewWindow.titleVisibility       = NSWindowTitleHidden;
        [self.staticsViewWindow makeKeyAndOrderFront:self];
        [self.staticsViewWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
        [self.staticsViewWindow center];
    }
}

- (void)showRosterWindow {
    if(self.closedDelegate && [self.closedDelegate respondsToSelector:@selector(closedByUser:)]) {
        [self.closedDelegate showRosterList];
    }
}

- (void)showSettingWindow {
    if(self.closedDelegate && [self.closedDelegate respondsToSelector:@selector(showSetting)]) {
        [self.closedDelegate showSetting];
    }
}

- (void)showMeetingInfo {
    if([self.infoWindow isVisible]) {
        [self.infoWindow makeKeyAndOrderFront:self];
    } else {
        self.infoWindow = [[FrtcMeetingDetailInfoWindow alloc] initWithSize:NSMakeSize(388, 383)];
        [self.infoWindow setupMeetingInfo:self.inCallModel];
        [self.infoWindow makeKeyAndOrderFront:self];
        [self.infoWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
        self.infoWindow.titleVisibility       = NSWindowTitleHidden;
        
        [self.infoWindow center];
    }
}

- (void)showStartOverLayMessage:(BOOL)show {
    if(!show) {
        //__weak __typeof(self)weakSelf = self;
        [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcMeetingStopOverlayMessage:self.inCallModel.userToken meetingNumber:self.inCallModel.conferenceNumber clientIdentifier:self.inCallModel.userIdentifier stopMessageSuccessfulHandler:^{
//            __strong __typeof(weakSelf)strongSelf = weakSelf;
//            [strongSelf showReminderView:NSLocalizedString(@"FM_MESSAGE_DISABLE", @"Overlay stopped")];
        } stopMessageFailure:^(NSError * _Nonnull error) {
            NSLog(@"");
        }];
        
        [self.enableMessageWindow close];
        return;
    }
    
    if([self.enableMessageWindow isVisible]) {
        return;
    }
    
    self.enableMessageWindow = [[FrtcEnableMessageWindow alloc] initWithSize:NSMakeSize(400, 405)];
    self.enableMessageWindow.messageWindwoDelegate = self;
    self.enableMessageWindow.titleVisibility       = NSWindowTitleHidden;
    
    self.enableMessageWindow.inCallModel = self.inCallModel;
    [self.enableMessageWindow makeKeyAndOrderFront:self];
    self.enableMessageWindow.contentMaxSize = NSMakeSize(400, 405);
    self.enableMessageWindow.contentMinSize = NSMakeSize(400, 405);
    [self.enableMessageWindow setContentSize:NSMakeSize(400, 405)];
    [self.enableMessageWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    [self.enableMessageWindow center];
}


- (void)showVideoRecordingWindow:(BOOL)show {
    if(show) {
        if([self.startVideoRecordingWindow isVisible]) {
            return;
        }
        
        self.startVideoRecordingWindow = [[FrtcVideoRecordingWindow alloc] initWithSize:NSMakeSize(380, 180)];
        self.startVideoRecordingWindow.startVideoRecordingDelegate = self;
        [self.startVideoRecordingWindow makeKeyAndOrderFront:self];
        
        self.startVideoRecordingWindow.contentMaxSize = NSMakeSize(380, 180);
        self.startVideoRecordingWindow.contentMinSize = NSMakeSize(380, 180);
        [self.startVideoRecordingWindow setContentSize:NSMakeSize(380, 180)];
        [self.startVideoRecordingWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
        [self.startVideoRecordingWindow center];
    } else {
        if([self.endVideoRecordingWindow isVisible]) {
            return;
        }
        self.endVideoRecordingWindow = [[FrtcVideoRecordingEndWindow alloc] initWithSize:NSMakeSize(380, 180)];
        self.endVideoRecordingWindow.endWindowDelegate = self;
        [self.endVideoRecordingWindow makeKeyAndOrderFront:self];
        
        self.endVideoRecordingWindow.contentMaxSize = NSMakeSize(380, 180);
        self.endVideoRecordingWindow.contentMinSize = NSMakeSize(380, 180);
        [self.endVideoRecordingWindow setContentSize:NSMakeSize(380, 180)];
        [self.endVideoRecordingWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
        [self.endVideoRecordingWindow center];
    }
}

- (void)showVideoStreamingWindow:(BOOL)show {
    if(show) {
        if([self.startVideoStreamingWindow isVisible]) {
            return;
        }
        self.startVideoStreamingWindow = [[FrtcVideoStreamingWindow alloc] initWithSize:NSMakeSize(380, 243)];
        self.startVideoStreamingWindow.startVideoStreamingDelegate = self;
        
        [self.startVideoStreamingWindow makeKeyAndOrderFront:self];
        self.startVideoStreamingWindow.contentMaxSize = NSMakeSize(380, 243);
        self.startVideoStreamingWindow.contentMinSize = NSMakeSize(380, 243);
        [self.startVideoStreamingWindow setContentSize:NSMakeSize(380, 243)];
        [self.startVideoStreamingWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
        [self.startVideoStreamingWindow center];
    } else {
        if([self.endVideoStreamingWindow isVisible]) {
            return;
        }
        self.endVideoStreamingWindow = [[FrtcVideoStreamingEndWindow alloc] initWithSize:NSMakeSize(320, 150)];
        self.endVideoStreamingWindow.endWindowDelegate = self;

        [self.endVideoStreamingWindow makeKeyAndOrderFront:self];
        self.endVideoStreamingWindow.contentMaxSize = NSMakeSize(320, 150);
        self.endVideoStreamingWindow.contentMinSize = NSMakeSize(320, 150);
        [self.endVideoStreamingWindow setContentSize:NSMakeSize(320, 150)];
        [self.endVideoStreamingWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
        [self.endVideoStreamingWindow center];
    }
}

- (void)showVideoStreamUrlWindow {
    if(!self.popover.isShown) {
        FrtcStreamingUrlPopViewController *controller = [[FrtcStreamingUrlPopViewController alloc] init];
        controller.delegate = self;
        self.popover = [[NSPopover alloc] init];
        self.popover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];

        self.popover.contentViewController = controller;
        self.popover.behavior = NSPopoverBehaviorTransient;
        //self.popover.delegate = self;

        [self.popover showRelativeToRect:self.contentControlToolBar.inviteStreamingBackGroundView.frame ofView:self.contentControlToolBar.contentView.superview preferredEdge:NSRectEdgeMaxY];
    }
}

- (void)quickSelectAudioDevice {
    FrtcPopupViewController *controller = [[FrtcPopupViewController alloc] initWithSection:2 withMeidaType:0];
    //controller.delegate = self;
    FrtcPopover *popover = [[FrtcPopover alloc] init];
    popover.delegate = self;
    popover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];
    
    popover.contentViewController = controller;
    popover.behavior = NSPopoverBehaviorTransient;
    //self.popover.delegate = self;

    [popover showRelativeToRect:self.contentControlToolBar.selectAudioDeviceBackGroundView.frame ofView:self.contentControlToolBar.contentView.superview preferredEdge:NSRectEdgeMaxY];
}

- (void)quickSelectVideoDevice {
    FrtcPopupViewController *controller = [[FrtcPopupViewController alloc] initWithSection:2 withMeidaType:1];
    //controller.delegate = self;
    FrtcPopover *popover = [[FrtcPopover alloc] init];
    popover.delegate = self;
    popover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];
    
    popover.contentViewController = controller;
    popover.behavior = NSPopoverBehaviorTransient;
    //self.popover.delegate = self;

    [popover showRelativeToRect:self.contentControlToolBar.selectVideoDeviceBackGroundView.frame ofView:self.contentControlToolBar.contentView.superview preferredEdge:NSRectEdgeMaxY];
}

#pragma mark --NSPopoverDelegate
- (void)popoverDidShow:(NSNotification *)notification {
    self.popoverShow = YES;
}

- (void)popoverDidClose:(NSNotification *)notification {;
    self.popoverShow = NO;
}

#pragma mark --FrtcParticipantsViewControllerDelegate--
- (void)showMeetingInfoWindow {
    [self showMeetingInfo];
}

#pragma mark --FrtcMediaStaticsViewWindowDelegate--
- (void)pupupDetailStaticWindow {
    if(![self.staticsWindowController.window isVisible]) {
        FrtcStaticsViewController *staticsViewController = [[FrtcStaticsViewController alloc] init];
        staticsViewController.conferenceAlias = self.inCallModel.conferenceNumber;
        staticsViewController.conferenceName = self.inCallModel.conferenceName;
                
        NSWindow *mainWindow = [NSWindow windowWithContentViewController:staticsViewController];
        self.staticsWindowController = [[StaticsWindowController alloc] initWithWindow:mainWindow];
        staticsViewController.view.window.windowController = self.staticsWindowController;
        
        self.staticsWindowController.window.contentMaxSize = NSSize(staticsViewController.view.frame.size);
        self.staticsWindowController.window.contentMinSize = NSSize(staticsViewController.view.frame.size);

        [(FrtcStaticsViewController *)(self.staticsWindowController.window.contentViewController) handleStaticsEvent:self.staticsModel];
    }
    [self.staticsWindowController.window makeKeyAndOrderFront:self];
    self.staticsWindowController.window.titleVisibility       = NSWindowTitleHidden;
    [self.staticsWindowController.window setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    [self.staticsWindowController.window center];
    [self.staticsWindowController showWindow:nil];
}

- (void)handleStaticsEvent:(FrtcStatisticalModel *)staticsModel {
    self.staticsModel = staticsModel;
    
    if([self.staticsWindowController.window isVisible]) {
        [(FrtcStaticsViewController *)(self.staticsWindowController.window.contentViewController) handleStaticsEvent:staticsModel];
    }
}

#pragma mark --FrtcEnableMessageWindowDelegate--
- (void)startMessageSuccess {
   // [self showReminderView:NSLocalizedString(@"FM_MESSAGE_ENABLE", @"Overlay started")];
    printf("\n success");
}

#pragma mark --FrtcVideoRecordingWindowDelegate--
- (void)startVideoRecording {
    __weak __typeof(self)weakSelf = self;
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcMeetingStartRecording:self.inCallModel.userToken meetingNumber:self.inCallModel.conferenceNumber clientIdentifier:self.inCallModel.userIdentifier startRecordingSeccess:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;

        strongSelf.contentControlToolBar.videoRecordingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_STOP_RECORDING", @"End Record");
        [strongSelf.contentControlToolBar.videoRecordingButton setState:NSControlStateValueOn];
    } startRecordingFailure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
       // [strongSelf handleRecordingAndStreamingError:error];
    }];
}

- (void)cancelVideoRecording {
    self.contentControlToolBar.videoRecordingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_RECORDING", @"Record");
    [self.contentControlToolBar.videoRecordingButton setState:NSControlStateValueOff];
}

#pragma mark --FrtcVideoRecordingEndWindowwDelegate--
- (void)endVideoRecording {
    __weak __typeof(self)weakSelf = self;
    
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcMeetingStopRecording:self.inCallModel.userToken meetingNumber:self.inCallModel.conferenceNumber clientIdentifier:self.inCallModel.userIdentifier stopRecordingSuccessful:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.contentControlToolBar.videoRecordingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_RECORDING", @"Record");
        [strongSelf.contentControlToolBar.videoRecordingButton setState:NSControlStateValueOff];
    } stopRecordingFailure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        //[strongSelf handleRecordingAndStreamingError:error];
    }];
}

- (void)cancelEndingVideoRecording {
    self.contentControlToolBar.videoRecordingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_STOP_RECORDING", @"End Record");
    [self.contentControlToolBar.videoRecordingButton setState:NSControlStateValueOn];
}

#pragma mark --FrtcVideoStreamingWindowDelegate--
- (void)startVideoStreamingWithPassword:(NSString *)password {
    __weak __typeof(self)weakSelf = self;
    
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcMeetingStartStreaming:self.inCallModel.userToken meetingNumber:self.inCallModel.conferenceNumber streamingPassword:password clientIdentifier:self.inCallModel.userIdentifier startStreamingSeccess:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.contentControlToolBar.videoStreamingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_STOP_STREAMING", @"End Live");
        [strongSelf.contentControlToolBar.videoStreamingButton setState:NSControlStateValueOn];
    } startStreamingFailure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        //[strongSelf handleRecordingAndStreamingError:error];
    }];
}

- (void)cancelVideoStreaming {
    self.contentControlToolBar.videoStreamingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_STREAMING", @"Live");
    [self.contentControlToolBar.videoStreamingButton setState:NSControlStateValueOff];
}

#pragma mark --FrtcVideoStreamingEndWindowwDelegate--
- (void)endVideoStreaming {
    __weak __typeof(self)weakSelf = self;
    
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcMeetingStopStreaming:self.inCallModel.userToken meetingNumber:self.inCallModel.conferenceNumber clientIdentifier:self.inCallModel.userIdentifier stopStreamingSuccessful:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        strongSelf.contentControlToolBar.videoStreamingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_STREAMING", @"Live");
        [strongSelf.contentControlToolBar.videoStreamingButton setState:NSControlStateValueOff];
        
        if([self.streamingUrlWindow isVisible]) {
            [self.streamingUrlWindow close];
        }
    } stopStreamingFailure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        //[strongSelf handleRecordingAndStreamingError:error];
    }];
}

- (void)cancelEndingVideoStreaming {
    self.contentControlToolBar.videoStreamingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_STOP_STREAMING", @"End Live");
    [self.contentControlToolBar.videoStreamingButton setState:NSControlStateValueOn];
}

#pragma mark --FrtcStreamingUrlPopViewControllerDelegate--
- (void)popupStreamingWindow {
    if([self.streamingUrlWindow isVisible]) {
        [self.streamingUrlWindow makeKeyAndOrderFront:self];
    } else {
        self.streamingUrlWindow = [[FrtcVideoStreamingUrlWindow alloc] initWithSize:NSMakeSize(348, 276)];
        FrtcMeetingStreamingModel *model = [[FrtcMeetingStreamingModel alloc] init];
        model.conferenceName    = self.inCallModel.conferenceName;
        model.clientName        = self.inCallModel.clientName;
        model.streamingUrl      = self.streamingUrl;
        model.streamingPassword = self.streamingPassword;
          
        
        [self.streamingUrlWindow setupStreamingUrlInfo:model];
        [self.streamingUrlWindow makeKeyAndOrderFront:self];
        [self.streamingUrlWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
        self.streamingUrlWindow.titleVisibility       = NSWindowTitleHidden;
        
        [self.streamingUrlWindow makeKeyAndOrderFront:self];
        self.streamingUrlWindow.contentMaxSize = NSMakeSize(348, 276);
        self.streamingUrlWindow.contentMinSize = NSMakeSize(348, 276);
        [self.streamingUrlWindow setContentSize:NSMakeSize(348, 276)];
       // [self.streamingUrlWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
        [self.streamingUrlWindow center];
    }
}

#pragma timer and timer event handler
- (void)mouseEntered:(NSEvent *)event {
    if ([self.displayTimer isValid] || [self.hideTimer isValid]) {
        NSLog(@"display Timer or hide Timer is valid");
        return;
    }
    [self startShowTimer];
}

- (void)mouseExited:(NSEvent *)event {
}

- (void)startShowTimer {
    //NSLog(@"enter start Show Timer");
    
    if ([self.showTimer isValid]) {
        NSLog(@"start Show timer is valid");
        return;
    }
    
    __block typeof(self) weakSelf = self;
    self.showTimer = [NSTimer scheduledTimerWithTimeInterval:0.06 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [weakSelf showTimerSelector];
    }];
}

- (void)stopShowTimer {
    if (nil != self.showTimer &&  [self.showTimer isValid]) {
        [self.showTimer invalidate];
        self.showTimer = nil;
        i = 1;
    }
}

- (void)showTimerSelector {
    [self getScreenParam];
    for (i = 1; i <= SHOW_HIDE_BAR_ANIMATION_STEP; i++) {
        [self.contentControlToolBar reBackLayout];
        
        [self.contentControlToolBar setFrame:NSMakeRect(self.origin.x + self.screenSize.width/2 - self.barWidth/2, self.origin.y + self.screenSize.height - self.menuHeight - i * kOneStepMovedHeight, self.barWidth, i * kOneStepMovedHeight) display:TRUE];
    }
    
    [self stopShowTimer];
    [self startDisplayTimer];
}

- (void)startHideTimer {
    if ([self.hideTimer isValid]) {
        return;
    }
    
    __block typeof(self) weakSelf = self;
    self.hideTimer = [NSTimer scheduledTimerWithTimeInterval:0.6 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf hideTimerSelector];
    }];
}

- (void)stopHideTimer {
    if (nil != self.hideTimer &&  [self.hideTimer isValid]) {
        [self.hideTimer invalidate];
        self.hideTimer = nil;
        j = 1;
    }
}

- (void)hideTimerSelector {
    [self getScreenParam];
    if ([self mouseInRegion] || self.isPopoverShow) {
        return;
    }
    
    for (j = 1; j <= SHOW_HIDE_BAR_ANIMATION_STEP; j++) {
        if (j == SHOW_HIDE_BAR_ANIMATION_STEP) {
            NSLog(@"Do nothing");
        } else {
            CGFloat height;
            
            if(self.menuHeight != 0) {
                height = self.menuHeight;
            } else {
                height = 50;
            }
            [self.contentControlToolBar setFrame:NSMakeRect(self.origin.x + self.screenSize.width / 2 - 200 / 2, self.origin.y + self.screenSize.height - height, 200, 30) display:TRUE];
            
            [self.contentControlToolBar reLayout];
        }
    }
    
    [self stopHideTimer];
}

- (void)startDisplayTimer {
    if ([self.displayTimer isValid]) {
        return;
    }
    
    __block typeof(self) weakSelf = self;
    self.displayTimer = [NSTimer scheduledTimerWithTimeInterval:5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf displayTimerSelector];
    }];
}

- (void)stopDisplayTimer {
    if (nil != self.displayTimer &&  [self.displayTimer isValid]) {
        [self.displayTimer invalidate];
        self.displayTimer = nil;
    }
}

- (void)displayTimerSelector {
    [self stopDisplayTimer];
    [self startHideTimer];
}

- (void)getScreenParam {
    NSApplication* app = [NSApplication sharedApplication];
    self.menuHeight = [[app mainMenu] menuBarHeight];
    
    NSArray *screens = [NSScreen screens];
    for (NSInteger index = 0; index < [screens count]; index++){
        NSScreen *screen = [screens objectAtIndex:index];
        NSDictionary* screenDictionary = [screen deviceDescription];
        NSNumber* screenID = [screenDictionary objectForKey:@"NSScreenNumber"];
        CGDirectDisplayID aID = [screenID unsignedIntValue];
        if (aID == self.screenID) {
            self.screenSize = screen.frame.size;
            self.origin = screen.frame.origin;
            break;
        }
    }
}

- (BOOL)mouseInRegion {
    return [self mouseInWindowRect:self.contentControlToolBar.frame];
}

- (BOOL)mouseInWindowRect:(NSRect) rect {
    NSPoint mouseLoc = [NSEvent mouseLocation];
    return NSPointInRect(mouseLoc, rect);
}

- (void)addTrackingAreaForSharingHandle {
    [self removeTrackingAreaForSharingHandle];
    self.littleBarTrackingRectTag = [_contentControlToolBar.contentView addTrackingRect:_contentControlToolBar.contentView.bounds owner:self userData:NULL assumeInside:NO];
}

- (void)removeTrackingAreaForSharingHandle {
    if(self.littleBarTrackingRectTag == 0) {
        return;
    }
    
    [self.contentControlToolBar.contentView removeTrackingRect:self.littleBarTrackingRectTag];
}

- (void)updateRecordingUI:(NSDictionary *)params withHeight:(CGFloat)height {
    NSString *strRecording = params[@"recordingStatus"];
    NSString *strStreaming = params[@"liveStatus"];
    
    if(!self.isRecording && [strRecording isEqualToString:@"STARTED"]) {
        self.contentControlToolBar.videoRecordingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_STOP_RECORDING", @"End Record");
        [self.contentControlToolBar.videoRecordingButton setState:NSControlStateValueOn];
        self.recording = YES;
    } else if(self.isRecording && [strRecording isEqualToString:@"NOT_STARTED"]) {
        [self.contentControlToolBar.videoRecordingButton setState:NSControlStateValueOff];
        self.contentControlToolBar.videoRecordingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_RECORDING", @"Record");
        
        self.recording = NO;
    }
    
    if(!self.isStreaming && [strStreaming isEqualToString:@"STARTED"]) {
        self.contentControlToolBar.videoStreamingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_STOP_STREAMING", @"End Live");
        [self.contentControlToolBar.videoStreamingButton setState:NSControlStateValueOn];
        
        self.streaming = YES;
        self.streamingUrl       = params[@"liveMeetingUrl"];
        self.streamingPassword  = params[@"liveMeetingPassword"];
        self.contentControlToolBar.inviteStreamingButton.hidden = NO;
        self.contentControlToolBar.inviteStreamingBackGroundView.hidden = NO;
    } else if(self.isStreaming && [strStreaming isEqualToString:@"NOT_STARTED"]) {
        self.contentControlToolBar.videoStreamingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_STREAMING", @"Live");
        [self.contentControlToolBar.videoStreamingButton setState:NSControlStateValueOff];
        self.streaming = NO;
        self.streamingUrl = @"";
        self.streamingPassword = @"";
        self.contentControlToolBar.inviteStreamingButton.hidden = YES;
        self.contentControlToolBar.inviteStreamingBackGroundView.hidden = YES;
    }
}

@end
