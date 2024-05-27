#import "FrtcCallWindowController.h"
#import "FrtcCallBarView.h"
#import "FrtcInCallSettingWindow.h"
#import "FrtcTitleBarView.h"
#import "FrtcPersonalViewController.h"
#import "FrtcParticipantsWindow.h"
#import "FrtcParticipantsViewController.h"
#import "FrtcMeetingDetailInfoWindow.h"
#import "FrtcDropCallWindow.h"
#import "FrtcAlertMainWindow.h"
#import "ParticipantsModel.h"
#import "FrtcMeetingInfoView.h"
#import "FrtcMediaStaticsView.h"
#import "FrtcGridModeView.h"
#import "FrtcMediaStaticsInstance.h"
#import "StaticsWindowController.h"
#import "FrtcContentAudioSettingViewController.h"
#import "FrtcMeetingManagement.h"
#import "FrtcMaskView.h"
#import "CallResultReminderView.h"
#import "FrtcStaticsViewController.h"
#import "FrtcReConnectCallWindow.h"
#import "FrtcExceptionWindow.h"
#import "FrtcReconnectMaskView.h"
#import "FrtcEnableMessageWindow.h"
#import "FrtcChangeNameWindow.h"
#import "FrtcVideoRecordingWindow.h"
#import "FrtcVideoRecordingMuteTipsWindow.h"
#import "FrtcVideoRecordingSuccessWindow.h"
#import "FrtcRequestUnMuteWindow.h"
#import "FrtcVideoRecordingEndWindow.h"
#import "FrtcVideoRecordingTipsView.h"
#import "FrtcVideoRecordingTips.h"
#import "FrtcVideoStreamingWindow.h"
#import "FrtcVideoStreamingMuteTipsWindow.h"
#import "FrtcVideoStreamingEndWindow.h"
#import "FrtcVideoRecordingReminderView.h"
#import "FrtcVideoStreamingUrlWindow.h"
#import "FrtcVideoRecordingSuccessView.h"
#import "FrtcRequestUnMuteView.h"
#import "FrtcStreamingUrlPopViewController.h"
#import "FrtcPopupViewController.h"
#import "RSFailureModel.h"
#import "FrtcRequestUnMuteListWindow.h"
#import "FrtcRequestUnMuteListViewController.h"
#import "FrtcPopover.h"
#import "FrtcMainWindow.h"
#import "FrtcSettingViewController.h"
#import "MeetingInformationView.h"
#import "MeetingMessageModel.h"
#import "FrtcContentViewController.h"
#import "FrtcContentWindowController.h"
#import <QuartzCore/QuartzCore.h>

typedef void (^ReCallBlock)();

@interface FrtcCallWindowController () <FrtcCallBarViewtDelegate, FrtcTitleBarViewDelegate, FrtcParticipantsViewControllerDelegate,
    FrtcDropCallWindowDelegate, FrtcMeetingInfoViewDelegate, FrtcMediaStaticsViewDelegate,
    FrtcContentAudioSettingViewControllerDelegate, FrtcGridModeViewDelegate,
    FrtcReConnectCallWindowDelegate, FrtcExceptionWindowDelegate, FrtcEnableMessageWindowDelegate,
    FrtcVideoRecordingWindowDelegate, FrtcVideoRecordingMuteTipsWindowDelegate, FrtcVideoRecordingEndWindowwDelegate,
    FrtcVideoRecordingTipsViewDelegate, FrtcVideoStreamingWindowDelegate, FrtcVideoStreamingMuteTipsWindowDelegate,
    FrtcVideoStreamingEndWindowwDelegate, FrtcStreamingUrlPopViewControllerDelegate, FrtcVideoRecordingSuccessViewDelegate, FrtcRequestUnMuteViewDelegate, FrtcRequestUnMuteListViewControllerDelegate, MeetingInformationViewDelegate, FrtcContentViewDelegate, FrtcContentWindowDelegate,NSPopoverDelegate>

@property (nonatomic, strong) NSView *view;;

@property (nonatomic, strong) FrtcCallBarView *callBarView;

@property (nonatomic, strong) FrtcTitleBarView *titleBarView;

@property (nonatomic, strong) FrtcMainWindow *callSettingWindow;

@property (nonatomic, strong) FrtcEnableMessageWindow *enableMessageWindow;

@property (nonatomic, strong) FrtcParticipantsWindow *participantsWindow;

@property (nonatomic, strong) FrtcMeetingDetailInfoWindow *infoWindow;

@property (nonatomic, strong) FrtcMeetingInfoView  *meetingView;

@property (nonatomic, strong) FrtcMediaStaticsView *staticsView;

@property (nonatomic, strong) FrtcGridModeView *gridModeView;

@property (nonatomic, strong) StaticsWindowController  *staticsWindowController;

@property (nonatomic, strong) FrtcStatisticalModel *staticsModel;

@property (nonatomic, strong) FrtcMaskView *maskView;

@property (nonatomic, strong) FrtcReconnectMaskView *reconnectMaskView;

@property (nonatomic, strong) CallResultReminderView *reminderView;

@property (nonatomic, strong) FrtcVideoStreamingUrlWindow *streamingUrlWindow;

@property (nonatomic, strong) MeetingInformationView *overlayView;

@property (nonatomic, strong) NSProgressIndicator *reConnectProgress;

@property (nonatomic, strong) NSPopover     *popover;

@property (nonatomic, copy)     NSMutableArray<NSString *> *rosterListArray;
@property (nonatomic, strong)   NSMutableArray<ParticipantsModel *> *modelArray;
@property (nonatomic, copy)     NSString *rosterNumber;

@property (strong, nonatomic) NSTimer   *meetingInfoTimer;
@property (strong, nonatomic) NSTimer   *staticsInfoTimer;
@property (strong, nonatomic) NSTimer   *reminderTipsTimer;
@property (strong, nonatomic) NSTimer   *overOneMinimuteTimer;

@property (assign, nonatomic, getter=isFullScreen) BOOL fullScreen;
@property (assign, nonatomic, getter=isMuteByServer) BOOL muteByServer;

@property (nonatomic, strong) NSTextField   *tipsTextField;

@property (nonatomic, strong) NSEvent *mDoubleEventMonitor;

@property (nonatomic, copy) ReCallBlock reCallBlock;

@property (nonatomic, strong) FrtcAlertMainWindow *alertWindow;

@property (nonatomic, strong) FrtcVideoRecordingTipsView *tipsHostView;

@property (nonatomic, strong) FrtcVideoRecordingTipsView *tipsStreamingView;

@property (nonatomic, strong) FrtcVideoRecordingTips *tipsView;

@property (nonatomic, strong) FrtcVideoRecordingTips *tipsViewForStreaming;

@property (nonatomic, strong) FrtcVideoRecordingSuccessWindow *videoRecordingSuccessfulWindow;

@property (nonatomic, strong) FrtcRequestUnMuteWindow *requestUnMuteWindow;

@property (nonatomic, copy)   NSString *streamingUrl;

@property (nonatomic, copy)   NSString *streamingPassword;

@property (nonatomic, strong) FrtcVideoRecordingReminderView *recordingTipsView;

@property (nonatomic, strong) FrtcVideoRecordingReminderView *streamingTipsView;

@property (nonatomic, strong) FrtcVideoRecordingSuccessView *recordingSuccessfulView;

@property (nonatomic, strong) FrtcRequestUnMuteView *requestUnMuteView;

@property (nonatomic, strong) FrtcStreamingUrlPopViewController *popViewController;

@property (nonatomic, strong) FrtcVideoRecordingWindow      *startVideoRecordingWindow;

@property (nonatomic, strong) FrtcVideoRecordingEndWindow   *endVideoRecordingWindow;

@property (nonatomic, strong) FrtcVideoStreamingWindow      *startVideoStreamingWindow;

@property (nonatomic, strong) FrtcVideoStreamingEndWindow   *endVideoStreamingWindow;

@property (nonatomic, strong) FrtcRequestUnMuteListWindow *requestListWindow;

@property (nonatomic, assign, getter=isRecordingMessage) BOOL recordingMessage;

@property (nonatomic, assign, getter=isAllowUserUnMuteByself) BOOL allowUserUnMuteByself;

@property (nonatomic, assign, getter=isAllowSelfUnmute) BOOL allowSelfUnmute;

@property (nonatomic, assign, getter=isAskForUnMuteBySelf) BOOL askForUnMuteBySelf;

@property (nonatomic, assign, getter=isAskForUnMuteOverOneMinimute) BOOL askForUnMuteOverOneMinimute;

@property (nonatomic, assign, getter=isPin) BOOL pin;

@property (nonatomic, assign, getter=isNewRequest) BOOL newRequest;

@property (nonatomic, assign, getter=isPopoverShow) BOOL popoverShow;

@property (nonatomic, copy) NSDictionary *params;

@property (nonatomic, copy) NSString *lastRecordStatus;

@property (nonatomic, strong) NSMutableDictionary *requestDictionary;

@property (nonatomic, strong) NSTrackingArea *trackingArea;

@property (nonatomic, strong) FrtcPopover *qucikPopover;

@property (nonatomic, strong) FrtcAlertMainWindow *askUnmuteWindow;

@property (nonatomic, strong) FrtcAlertMainWindow *alreadySentUnmuteRequestWindow;

@property (nonatomic, strong) FrtcAlertMainWindow *alreadyInCallWindow;

@property (nonatomic, strong) MeetingMessageModel *overlayMessageModel;

@property (nonatomic, assign, getter=isOverlayMessage)                BOOL overlayMessage;

@property (nonatomic, assign, getter=isOverlayMessageViewInitialized) BOOL overlayMessageViewInitialized;

@property (nonatomic, assign) BOOL sendContentAudioFlag;

@property (nonatomic, strong) FrtcContentWindowController       *contentWindowController;

@property (nonatomic, strong)   NSMutableArray *desktopListArray;



@end

@implementation FrtcCallWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    self.view = self.window.contentViewController.view;
    self.view.layer.masksToBounds = NO;
    
    [self addTrackingArea];
}

- (instancetype)initWithWindowNibName:(NSNibName)windowNibName {
    self = [super initWithWindowNibName:windowNibName];
    if (self) {
        
    }
    return self;
}

- (void)windowWillLoad {
    [super windowWillLoad];
}

- (void)awakeFromNib {
    //self.view.window.delegate = self;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.modelArray = [NSMutableArray array];
        self.desktopListArray = [NSMutableArray array];
        self.requestDictionary = [NSMutableDictionary dictionary];
        self.contentSendFlag = CallWindowSendContentFlagNone;
        self.muteByServer = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMidiaButtonStatus:) name:FMeetingUpInCallModelNotNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMuteAll:) name:FrtcMeetingMeetingOwnerMuteAll object:nil];
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"call window controller dealloc %@", self);
    [self.view removeTrackingArea:self.trackingArea];
    
    [self cancelOneMinimuteTimer];
    [self cancelTimer];
}

- (BOOL)windowShouldClose:(id)sender {
    [self endMeeting];
    return NO;
}

- (void)setupWindowLayout {
    [self updateTrackingArea];
    [self getStatics];
    
    [self.callBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(56);
    }];
    
    [self.titleBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top);
        make.height.mas_equalTo(32);
    }];
    
    [self.tipsHostView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(4);
        make.top.mas_equalTo(self.view.mas_top).offset(self.view.frame.size.height * 0.17);
        make.width.mas_equalTo(122);
        make.height.mas_equalTo(28);
    }];
    
    [self.tipsStreamingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(4);
        make.top.mas_equalTo(self.view.mas_top).offset(self.view.frame.size.height * 0.17);
        make.width.mas_equalTo(122);
        make.height.mas_equalTo(28);
    }];
    
    [self.recordingTipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(4);
        make.top.mas_equalTo(self.view.mas_top).offset(self.view.frame.size.height * 0.17);
        make.width.mas_equalTo(106);
        make.height.mas_equalTo(28);
    }];
    
    [self.streamingTipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(4);
        make.top.mas_equalTo(self.view.mas_top).offset(self.view.frame.size.height * 0.17);
        make.width.mas_equalTo(106);
        make.height.mas_equalTo(28);
    }];
    
    [self.tipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(82);
        make.top.mas_equalTo(self.tipsHostView.mas_bottom).offset(2);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(21);
    }];
    
    [self.tipsViewForStreaming mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(82);
        make.top.mas_equalTo(self.tipsHostView.mas_bottom).offset(2);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(21);
    }];
    
    [self.meetingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(12);
        make.top.mas_equalTo(self.titleBarView.mas_bottom).offset(0);
        make.width.mas_equalTo(240);
        make.height.mas_equalTo(144);
    }];
    
    [self.staticsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(100);
        make.top.mas_equalTo(self.titleBarView.mas_bottom).offset(1);
        make.width.mas_equalTo(260);
        make.height.mas_equalTo(197);
    }];
    
    [self.gridModeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-80);
        make.top.mas_equalTo(self.titleBarView.mas_bottom).offset(1);
        make.width.mas_equalTo(256);
        make.height.mas_equalTo(168);
    }];
    
    [self.recordingSuccessfulView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-4);
        make.bottom.mas_equalTo(self.callBarView.mas_top).offset(-4);
        make.width.mas_equalTo(244);
        make.height.mas_equalTo(170);
    }];
    
    if(self.isRecordingMessage) {
        [self updateRecordingUI:self.params withHeight:self.view.frame.size.height * 0.17];
        self.recordingMessage = NO;
    }
    
    [self.requestUnMuteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-4);
        make.bottom.mas_equalTo(self.callBarView.mas_top).offset(-4);
        make.width.mas_equalTo(224);
        make.height.mas_equalTo(94);
    }];
}

- (void)reMasTitleBarLayout:(BOOL)isShelterByMenu {
    if(isShelterByMenu) {
        [self.titleBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left);
            make.right.mas_equalTo(self.view.mas_right);
            make.top.mas_equalTo(self.view.mas_top).offset(25);
            make.height.mas_equalTo(32);
        }];
    } else {
        [self.titleBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left);
            make.right.mas_equalTo(self.view.mas_right);
            make.top.mas_equalTo(self.view.mas_top);
            make.height.mas_equalTo(32);
        }];
    }
}

- (void)onWindowSizeChanged:(NSSize)aSize {
    [self updateTrackingArea];
    
    self.overlayView.frame = CGRectMake(0, [[FrtcBaseImplement baseImpleSingleton] screenHeight] - 28 - 40, [[FrtcBaseImplement baseImpleSingleton] screenWidth], 40);
    [self.overlayView restart];
}

- (void)addTrackingArea {
    self.view = self.window.contentViewController.view;
    self.trackingArea = [[NSTrackingArea alloc] initWithRect: self.view.bounds
                                 options:(NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveAlways)
                                   owner:self
                                userInfo:nil];
    [self.view addTrackingArea:self.trackingArea];
}

- (void)updateTrackingArea {
    [self.view removeTrackingArea:self.trackingArea];
    [self addTrackingArea];
}

- (void)getStatics {
    __weak __typeof(self)weakSelf = self;
    
    [[FrtcMediaStaticsInstance sharedFrtcMediaStaticsInstance] startGetStatics:^(FrtcStatisticalModel * _Nonnull staticsModel, FrtcMediaStaticsModel * _Nonnull mediaStaticsModel) {
        __strong __typeof(&*weakSelf)strongSelf = weakSelf;
        
        strongSelf.mediaStaticModel = mediaStaticsModel;
        strongSelf.staticsModel     = staticsModel;
        
        [strongSelf updateMediaStatics:mediaStaticsModel];
        
        if([strongSelf.staticsWindowController.window isVisible]) {
            [(FrtcStaticsViewController *)(strongSelf.staticsWindowController.window.contentViewController) handleStaticsEvent:staticsModel];
        }
    }];
}


#pragma mark- --Notifiacation Observer
-(void)onMidiaButtonStatus:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    self.inCallModel = [userInfo valueForKey:FMeetingUpInCallModelKey];
    
    [ _callBarView.muteAudioButton setState:self.inCallModel.muteMicrophone ? NSControlStateValueOff :NSControlStateValueOn];
    _callBarView.muteAudioLabel.stringValue = self.inCallModel.muteMicrophone ? NSLocalizedString(@"FM_UN_MUTE", @"Unmute") : NSLocalizedString(@"FM_MUTE", @"Mute");
    
    [ _callBarView.videoMuteButton setState:self.inCallModel.muteCamera ? NSControlStateValueOff :NSControlStateValueOn];
    _callBarView.videoMuteLabel.stringValue = self.inCallModel.muteCamera ? NSLocalizedString(@"FM_OPEN_VIDEO", @"Start Video") : NSLocalizedString(@"FM_CLOSE_VIDEO", @"Stop Video");
    
    if([self.participantsWindow isVisible]) {
        ((FrtcParticipantsViewController *)(self.participantsWindow.contentViewController)).inCallModel = self.inCallModel;
        [((FrtcParticipantsViewController *)(self.participantsWindow.contentViewController)) handleRosterEvent:self.modelArray];
    }
}

-(void)receiveMuteAll:(NSNotification *)notification {
    if(self.callBarView.muteAudioButton.state == NSControlStateValueOff) {
        [self.callBarView.muteAudioButton setState:NSControlStateValueOn];
        [[FrtcCallInterface singletonFrtcCall] audioMute:NO];
    }
}

#pragma mark- --Interface Class
- (void)recordingStatus:(NSDictionary *)params isShareContent:(BOOL)shareContent {
    NSString *strRecording = params[@"recordingStatus"];
    
    if([strRecording isEqualToString:@"NOT_STARTED"]) {
        if(self.closedDelegate && [self.closedDelegate respondsToSelector:@selector(closedByUserCallWindow:)]) {
            [self.closedDelegate closedByUserCallWindow:NO];
        }
    }
    
    self.shareContent       = shareContent;
    self.recordingMessage   = YES;
    self.params             = params;
    
    if([self.window isVisible]) {
        [self updateRecordingUI:params withHeight:self.view.frame.size.height * 0.17];
        self.recordingMessage = NO;
    }
}

- (void)toastString:(NSString *)errorCode {
    NSString *errorMessage = @"";
    if ([errorCode isEqualToString:RECORDING_START_ERROR]) {
        errorMessage = NSLocalizedString(@"FM_VIDEO_RECORDING_START_ERROR", @"Start recording error");
        [self showReminderView:errorMessage];
    } else if ([errorCode isEqualToString:RECORDING_PARAM_ERROR]) {
        errorMessage = NSLocalizedString(@"FM_VIDEO_RECORDING_PARAM_ERROR", @"Recording parameter error");
        [self showReminderView:errorMessage];
    } else if ([errorCode isEqualToString:RECORDING_LICENSE_ERROR]) {
        errorMessage = NSLocalizedString(@"FM_VIDEO_RECORDING_LICENSE_ERROR", @"The service is not licensed or the license has expired.");
        [self showAlerWindow:NSLocalizedString(@"FM_VIDEO_RECORDING_FAILED_TITLE", @"Recording failed") withMessage:errorMessage];
    } else if ([errorCode isEqualToString:RECORDING_LICENSE_FULL_ERROR]) {
        errorMessage = NSLocalizedString(@"FM_VIDEO_RECORDING_LICENSE_FULL_ERROR", @"The recording users has reached the maximum, please upgrade the software license.");
        [self showAlerWindow:NSLocalizedString(@"FM_VIDEO_RECORDING_FAILED_TITLE", @"Recording failed") withMessage:errorMessage];
    } else if ([errorCode isEqualToString:RECORDING_SOURCE_FULL_ERROR]) {
        errorMessage = NSLocalizedString(@"FM_VIDEO_RECORDING_SOURCE_FULL_ERROR", @"The recording server resource is insufficient, please contact the system administrator.");
        [self showAlerWindow:NSLocalizedString(@"FM_VIDEO_RECORDING_FAILED_TITLE", @"Recording failed") withMessage:errorMessage];
    } else if ([errorCode isEqualToString:RECORDING_NOT_EXIT_ERROR]) {
        errorMessage = NSLocalizedString(@"FM_VIDEO_RECORDING_NOT_EXIT_ERROR", @"Recording and playing server error");
        [self showReminderView:errorMessage];
    } else if ([errorCode isEqualToString:RECORDING_NOT_REPEATE_ERROR]) {
        errorMessage = NSLocalizedString(@"FM_VIDEO_RECORDING_NOT_REPEATE_ERROR", @"Cannot start recording repeatedly");
        [self showReminderView:errorMessage];
    } else if ([errorCode isEqualToString:RECORDING_STOP_ERROR]) {
        errorMessage = NSLocalizedString(@"FM_VIDEO_RECORDING_STOP_ERROR", @"End recording error");
        [self showReminderView:errorMessage];
    } else if ([errorCode isEqualToString:RECORDING_STOP_PARAM_ERROR]) {
        errorMessage = NSLocalizedString(@"FM_VIDEO_RECORDING_STOP_PARAM_ERROR", @"End recording parameter error");
        [self showReminderView:errorMessage];
    } else if ([errorCode isEqualToString:STREAMING_START_ERROR]) {
        errorMessage = NSLocalizedString(@"FM_VIDEO_STREAMING_START_ERROR", @"Start live streaming error");
        [self showReminderView:errorMessage];
    } else if ([errorCode isEqualToString:STREAMING_PARAM_ERROR]) {
        errorMessage = NSLocalizedString(@"FM_VIDEO_STREAMING_PARAM_ERROR", @"Live streaming parameter error");
        [self showReminderView:errorMessage];
    } else if ([errorCode isEqualToString:STREAMING_LICENSE_ERROR]) {
        errorMessage = NSLocalizedString(@"FM_VIDEO_STREAMING_LICENSE_ERROR", @"The service is not licensed or the license has expired.");
        [self showAlerWindow:NSLocalizedString(@"FM_VIDEO_STREAMING_FAILED_TITLE", @"Live streaming failed") withMessage:errorMessage];
    } else if ([errorCode isEqualToString:STREAMING_LICENSE_FULL_ERROR]) {
        errorMessage = NSLocalizedString(@"FM_VIDEO_STREAMING_LICENSE_FULL_ERROR",@"The live streaming  users has reached the maximum, please upgrade the software license.");
        [self showAlerWindow:NSLocalizedString(@"FM_VIDEO_STREAMING_FAILED_TITLE", @"Live streaming failed") withMessage:errorMessage];
    } else if ([errorCode isEqualToString:STREAMING_SOURCE_FULL_ERROR]) {
        errorMessage = NSLocalizedString(@"FM_VIDEO_STREAMING_SOURCE_FULL_ERROR",@"The live streaming server resource is insufficient, please contact the system administrator.");
        [self showAlerWindow:NSLocalizedString(@"FM_VIDEO_STREAMING_FAILED_TITLE", @"Live streaming failed") withMessage:errorMessage];
    } else if ([errorCode isEqualToString:STREAMING_NOT_EXIT_ERROR]) {
        errorMessage = NSLocalizedString(@"FM_VIDEO_STREAMING_NOT_EXIT_ERROR",@"Live streaming server error");
        [self showReminderView:errorMessage];
    } else if ([errorCode isEqualToString:STREAMING_NOT_REPEATE_ERROR]) {
        errorMessage = NSLocalizedString(@"FM_VIDEO_STREAMING_NOT_REPEATE_ERROR",@"Cannot start live streaming repeatedly");
        [self showReminderView:errorMessage];
    } else if ([errorCode isEqualToString:STREAMING_STOP_ERROR]) {
        errorMessage = NSLocalizedString(@"FM_VIDEO_STREAMING_STOP_ERROR",@"End live streaming error");
        [self showReminderView:errorMessage];
    } else if ([errorCode isEqualToString:STREAMING_STOP_PARAM_ERROR]) {
        errorMessage = NSLocalizedString( @"FM_VIDEO_STREAMING_STOP_PARAM_ERROR",@"End live streaming parameter error");
        [self showReminderView:errorMessage];
    }
}

- (void)handleRecordingAndStreamingError:(NSError *)error {
    NSDictionary *erroInfo = error.userInfo;
    NSData *data = [erroInfo valueForKey:@"com.alamofire.serialization.response.error.data"];
    NSString *errorString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSError *error1 = nil;
    RSFailureModel *failureModel = [[RSFailureModel alloc] initWithString:errorString error:&error1];
    
   [self toastString:failureModel.errorCode];
}


- (void)updateRecordingUI:(NSDictionary *)params withHeight:(CGFloat)height {
    NSString *strRecording = params[@"recordingStatus"];
    NSString *strStreaming = params[@"liveStatus"];
    
    if(!self.isRecording && [strRecording isEqualToString:@"STARTED"]) {
        self.callBarView.videoRecordingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_STOP_RECORDING", @"End Record");
        [self.callBarView.videoRecordingButton setState:NSControlStateValueOn];
        
        NSString *reminderString;
        if([self.inCallModel.ownerID isEqualToString:self.inCallModel.userID] || self.inCallModel.isAuthority) {
            reminderString = NSLocalizedString(@"FM_VIDEO_RECORDING_START_REMINDER", @"Recording started with meeting layout of the host");
            self.tipsHostView.hidden = NO;
            
            if(self.isStreaming) {
                [self.tipsHostView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).offset(4);
                    make.top.mas_equalTo(self.tipsStreamingView.mas_bottom).offset(8);
                    make.width.mas_equalTo(122);
                    make.height.mas_equalTo(28);
                }];
            } else {
                [self.tipsHostView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).offset(4);
                    make.top.mas_equalTo(self.view.mas_top).offset(height);
                    make.width.mas_equalTo(122);
                    make.height.mas_equalTo(28);
                }];
            }
        } else {
            reminderString = NSLocalizedString(@"FM_VIDEO_RECORDING_START_REMINDER_BY_HOST", @"Recording started by the host");
            self.recordingTipsView.hidden = NO;
            
            if(self.isStreaming) {
                [self.recordingTipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).offset(4);
                    make.top.mas_equalTo(self.streamingTipsView.mas_bottom).offset(8);
                    make.width.mas_equalTo(106);
                    make.height.mas_equalTo(28);
                }];
            } else {
                [self.recordingTipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).offset(4);
                    make.top.mas_equalTo(self.view.mas_top).offset(height);
                    make.width.mas_equalTo(106);
                    make.height.mas_equalTo(28);
                }];
            }
        }
        [self showReminderView:reminderString];
        
        self.recording = YES;
        if(self.isShareContent) {
            self.recordingSuccessfulView.hidden = YES;
            
            if(self.requestUnMuteView.hidden == NO) {
                [self.requestUnMuteView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self.view.mas_right).offset(-4);
                    make.bottom.mas_equalTo(self.callBarView.mas_top).offset(-4);
                    make.width.mas_equalTo(224);
                    make.height.mas_equalTo(94);
                }];
            }
            if(self.closedDelegate && [self.closedDelegate respondsToSelector:@selector(showRecordingAndStreamingTips:)]) {
                [self.closedDelegate showRecordingAndStreamingTips:reminderString];
            }
        } else {
            self.recordingSuccessfulView.hidden = NO;
            if(self.requestUnMuteView.hidden == NO) {
                [self.requestUnMuteView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self.view.mas_right).offset(-4);
                    make.bottom.mas_equalTo(self.recordingSuccessfulView.mas_top).offset(-4);
                    make.width.mas_equalTo(224);
                    make.height.mas_equalTo(94);
                 }];
            }
            
            [self showReminderView:reminderString];
        }
        
    } else if(self.isRecording && [strRecording isEqualToString:@"NOT_STARTED"]) {
        [self.callBarView.videoRecordingButton setState:NSControlStateValueOff];
        self.callBarView.videoRecordingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_RECORDING", @"Record");
        
        NSString *reminderString;
        if([self.inCallModel.ownerID isEqualToString:self.inCallModel.userID] || self.inCallModel.isAuthority) {
            reminderString = NSLocalizedString(@"FM_VIDEO_RECORDING_STOP_REMINDER", @"Recording ended");
            
            
            self.tipsHostView.hidden = YES;
            if(self.isStreaming) {
                [self.tipsStreamingView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).offset(4);
                    make.top.mas_equalTo(self.view.mas_top).offset(height);
                    make.width.mas_equalTo(122);
                    make.height.mas_equalTo(28);
                }];
            }
        } else {
            reminderString = NSLocalizedString(@"FM_VIDEO_RECORDING_STOP_REMINDER_BY_HOST", @"Recording ended by the host");
            self.recordingTipsView.hidden = YES;
            
            if(self.isStreaming) {
                [self.streamingTipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).offset(4);
                    make.top.mas_equalTo(self.view.mas_top).offset(height);
                    make.width.mas_equalTo(106);
                    make.height.mas_equalTo(28);
                }];
            }
        }
        if(self.isShareContent) {
            if(self.closedDelegate && [self.closedDelegate respondsToSelector:@selector(showRecordingAndStreamingTips:)]) {
                [self.closedDelegate showRecordingAndStreamingTips:reminderString];
            }
        } else {
            [self showReminderView:reminderString];
        }
        
        self.recording = NO;
        self.recordingSuccessfulView.hidden = YES;
        
        if(self.requestUnMuteView.hidden == NO) {
            [self.requestUnMuteView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.view.mas_right).offset(-4);
                make.bottom.mas_equalTo(self.callBarView.mas_top).offset(-4);
                make.width.mas_equalTo(224);
                make.height.mas_equalTo(94);
            }];
        }
    }
    
    if(!self.isStreaming && [strStreaming isEqualToString:@"STARTED"]) {
        self.callBarView.videoStreamingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_STOP_STREAMING", @"End Live");
        [self.callBarView.videoStreamingButton setState:NSControlStateValueOn];
        
        NSString *reminderString;
        if([self.inCallModel.ownerID isEqualToString:self.inCallModel.userID] || self.inCallModel.isAuthority) {
            reminderString = NSLocalizedString(@"FM_VIDEO_STREAMING_START_REMINDER", @"Live started with meeting layout of the host");
            self.tipsStreamingView.hidden = NO;
            self.callBarView.inviteStreamingButton.hidden = NO;
            self.callBarView.inviteStreamingBackGroundView.hidden = NO;
            
            if(self.isRecording) {
                [self.tipsStreamingView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).offset(4);
                    make.top.mas_equalTo(self.tipsHostView.mas_bottom).offset(8);
                    make.width.mas_equalTo(122);
                    make.height.mas_equalTo(28);
                }];
            } else {
                [self.tipsStreamingView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).offset(4);
                    make.top.mas_equalTo(self.view.mas_top).offset(height);
                    make.width.mas_equalTo(122);
                    make.height.mas_equalTo(28);
                }];
            }
        } else {
            reminderString = NSLocalizedString(@"FM_VIDEO_STREAMING_START_REMINDER_BY_HOST", @"Live started by the host");
            
            self.streamingTipsView.hidden = NO;
            
            if(self.isRecording) {
                [self.streamingTipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).offset(4);
                    make.top.mas_equalTo(self.recordingTipsView.mas_bottom).offset(8);
                    make.width.mas_equalTo(106);
                    make.height.mas_equalTo(28);
                }];
            } else {
                [self.streamingTipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).offset(4);
                    make.top.mas_equalTo(self.view.mas_top).offset(height);
                    make.width.mas_equalTo(106);
                    make.height.mas_equalTo(28);
                }];
            }
        }
        
        if(self.isShareContent) {
            if(self.closedDelegate && [self.closedDelegate respondsToSelector:@selector(showRecordingAndStreamingTips:)]) {
                [self.closedDelegate showRecordingAndStreamingTips:reminderString];
            }
        } else {
            [self showReminderView:reminderString];
        }
        //[self showReminderView:reminderString];
        
        self.streaming = YES;
        self.streamingUrl       = params[@"liveMeetingUrl"];
        self.streamingPassword  = params[@"liveMeetingPassword"];
    } else if(self.isStreaming && [strStreaming isEqualToString:@"NOT_STARTED"]) {
        [self.callBarView.videoStreamingButton setState:NSControlStateValueOff];
        self.callBarView.videoStreamingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_STREAMING", @"Live");
        
        NSString *reminderString;
        if([self.inCallModel.ownerID isEqualToString:self.inCallModel.userID] || self.inCallModel.isAuthority) {
            self.tipsStreamingView.hidden = YES;
            reminderString = NSLocalizedString(@"FM_VIDEO_STREAMING_STOP_REMINDER", @"Live ended");
            
            self.callBarView.inviteStreamingButton.hidden = YES;
            self.callBarView.inviteStreamingBackGroundView.hidden = YES;
            
            if(self.isRecording) {
                [self.tipsHostView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).offset(4);
                    make.top.mas_equalTo(self.view.mas_top).offset(height);
                    make.width.mas_equalTo(122);
                    make.height.mas_equalTo(28);
                }];
            }
        } else {
            self.streamingTipsView.hidden = YES;
            reminderString = NSLocalizedString(@"FM_VIDEO_STREAMING_STOP_REMINDER_BY_HOST", @"Live ended by the host");
            
            if(self.isRecording) {
                [self.recordingTipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).offset(4);
                    make.top.mas_equalTo(self.view.mas_top).offset(height);
                    make.width.mas_equalTo(106);
                    make.height.mas_equalTo(28);
                }];
            }
        }
        
        if(self.isShareContent) {
            if(self.closedDelegate && [self.closedDelegate respondsToSelector:@selector(showRecordingAndStreamingTips:)]) {
                [self.closedDelegate showRecordingAndStreamingTips:reminderString];
            }
        } else {
            [self showReminderView:reminderString];
        }
    
        self.streaming = NO;
        self.streamingUrl = @"";
        self.streamingPassword = @"";
    }
}

- (void)showAlerWindow:(NSString *)title withMessage:(NSString *)errorMessage {
    FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:title withMessage:errorMessage preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:self.view.window];

    FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{

    }];
    [alertWindow addAction:action];
}

- (void)showReminderView:(NSString *)stringValue {
    if(![self.window isVisible]) {
        return;
    }
    
    NSString *reminderValue = stringValue;
    NSFont *font             = [NSFont systemFontOfSize:14.0f];
    NSDictionary *attributes = @{ NSFontAttributeName:font };
    CGSize size              = [reminderValue sizeWithAttributes:attributes];
    
    if([self.alertWindow isVisible]) {
        [self.reminderView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.centerY.mas_equalTo(self.view.mas_centerY).offset(100);
            make.width.mas_equalTo(size.width + 28);
            make.height.mas_equalTo(size.height + 20);
        }];
    } else {
        [self.reminderView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.centerY.mas_equalTo(self.view.mas_centerY);
            make.width.mas_equalTo(size.width + 28);
            make.height.mas_equalTo(size.height + 20);
        }];
    }
    
    self.reminderView.tipLabel.stringValue = reminderValue;
    self.reminderView.hidden = NO;
    [self runningTimer:2.0];
}

- (void)closeAllWindows {
    [self.callSettingWindow close];
    [self.participantsWindow close];
    [self.staticsWindowController close];
    [self.infoWindow close];
}

- (void)closeWinowByCloseButton {
    [self endMeeting];
}

- (void)reConnectCall {
    self.reconnectMaskView = [[FrtcReconnectMaskView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

    [self.view addSubview:self.reconnectMaskView
               positioned:NSWindowBelow
               relativeTo:self.callBarView];
}

-(void)bringSubviewToFront:(NSView *)subView {
    NSArray* subviewArray = [self.view subviews];
    NSView* currentTopView = [subviewArray objectAtIndex:0];
    
    if(subView != nil && subView != currentTopView) {
        [subView removeFromSuperview];
        [self.view addSubview:subView
                   positioned:NSWindowAbove
                   relativeTo:currentTopView];
        [self.view addSubview:subView];
        self.view.hidden = NO;
    }
}

- (void)stopReConnectCall {
    self.reCallBlock = nil;
    [self.reConnectProgress stopAnimation:self];
    self.reConnectProgress.hidden = YES;
    self.tipsTextField.hidden = YES;
    
    NSSize windowSize = NSMakeSize(291, 168);
    
    FrtcExceptionWindow *exceptionWindow = [[FrtcExceptionWindow alloc] initWithSize:windowSize];
    exceptionWindow.exceptionWindowDelegate = self;
    [exceptionWindow makeKeyAndOrderFront:self.maskView];
    [exceptionWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    [exceptionWindow center];
    
    [exceptionWindow setLevel:NSPopUpMenuWindowLevel];
}

- (void)reConnectCallByToastWindowWithReCallBlock:(void(^)(void))reCallBlock {
    if(!self.reCallBlock) {
        self.reCallBlock = reCallBlock;
        [self.reconnectMaskView removeFromSuperview];
        
        self.maskView.alphaValue = 0.7;
        [self.view addSubview:self.maskView];
    } else {
        [self.reConnectProgress stopAnimation:self];
        self.reConnectProgress.hidden = YES;
        self.tipsTextField.hidden = YES;
    }
    NSSize windowSize = NSMakeSize(291, 168);
    FrtcReConnectCallWindow *reConnectWindow = [[FrtcReConnectCallWindow alloc] initWithSize:windowSize];
    reConnectWindow.reConnectDelegate = self;

    [reConnectWindow makeKeyAndOrderFront:self.maskView];
    [reConnectWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    [reConnectWindow center];

    [reConnectWindow setLevel:NSPopUpMenuWindowLevel];
}

- (void)stopReConnectUI:(NSInteger)reConnectCount {
    //if(reConnectCount <= 3) {
        [self.reconnectMaskView removeFromSuperview];
    //} else {
        [self.maskView removeFromSuperview];
        [self.reConnectProgress stopAnimation:self];
        self.reConnectProgress.hidden = YES;
        self.tipsTextField.hidden     = YES;
    //}
}

- (void)updateRecordingAndStreamingUILocation:(BOOL)isShareContent {
    self.shareContent = isShareContent;
    if(isShareContent) {
        if([self.inCallModel.ownerID isEqualToString:self.inCallModel.userID] || self.inCallModel.isAuthority) {
            if(self.isRecording && self.isStreaming) {
                [self.tipsHostView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).offset(4);
                    make.top.mas_equalTo(self.view.mas_top).offset(10);
                    make.width.mas_equalTo(122);
                    make.height.mas_equalTo(28);
                }];
                
                [self.tipsStreamingView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).offset(4);
                    make.top.mas_equalTo(self.tipsHostView.mas_bottom).offset(8);
                    make.width.mas_equalTo(122);
                    make.height.mas_equalTo(28);
                }];
            } else if(self.isRecording && !self.isStreaming) {
                [self.tipsHostView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).offset(4);
                    make.top.mas_equalTo(self.view.mas_top).offset(10);
                    make.width.mas_equalTo(122);
                    make.height.mas_equalTo(28);
                }];
            } else if(!self.isRecording && self.isStreaming) {
                [self.tipsStreamingView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).offset(4);
                    make.top.mas_equalTo(self.view.mas_top).offset(10);
                    make.width.mas_equalTo(122);
                    make.height.mas_equalTo(28);
                }];
            }
           
        } else {
            if(self.isRecording && self.isStreaming) {
                [self.recordingTipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).offset(4);
                    make.top.mas_equalTo(self.view.mas_top).offset(10);
                    make.width.mas_equalTo(106);
                    make.height.mas_equalTo(28);
                }];
                
                [self.streamingTipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).offset(4);
                    make.top.mas_equalTo(self.recordingTipsView.mas_bottom).offset(8);
                    make.width.mas_equalTo(106);
                    make.height.mas_equalTo(28);
                }];
            } else if(self.isRecording && !self.isStreaming) {
                [self.recordingTipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).offset(4);
                    make.top.mas_equalTo(self.view.mas_top).offset(10);
                    make.width.mas_equalTo(106);
                    make.height.mas_equalTo(28);
                }];
            } else if(!self.isRecording && self.isStreaming) {
                [self.streamingTipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).offset(4);
                    make.top.mas_equalTo(self.view.mas_top).offset(10);
                    make.width.mas_equalTo(106);
                    make.height.mas_equalTo(28);
                }];
            }
        }
        self.recordingSuccessfulView.hidden = YES;
        
        if(self.requestUnMuteView.hidden == NO) {
            [self.requestUnMuteView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.view.mas_centerX);
                make.centerY.mas_equalTo(self.view.mas_centerY);
                make.width.mas_equalTo(224);
                make.height.mas_equalTo(94);
            }];
        }
    } else {
        if(self.requestUnMuteView.hidden == NO) {
            [self.requestUnMuteView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.view.mas_right).offset(-4);
                make.bottom.mas_equalTo(self.callBarView.mas_top).offset(-4);
                make.width.mas_equalTo(224);
                make.height.mas_equalTo(94);
            }];
        }
        
        if(self.params != nil && [self.params[@"recordingStatus"] isEqualToString:@"STARTED"]) {
            self.recordingSuccessfulView.hidden = self.isClosedByUser;
            
            if(self.isClosedByUser) {
                if(self.requestUnMuteView.hidden == NO) {
                    [self.requestUnMuteView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.right.mas_equalTo(self.view.mas_right).offset(-4);
                        make.bottom.mas_equalTo(self.callBarView.mas_top).offset(-4);
                        make.width.mas_equalTo(224);
                        make.height.mas_equalTo(94);
                    }];
                }
            } else {
                if(self.requestUnMuteView.hidden == NO) {
                    [self.requestUnMuteView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.right.mas_equalTo(self.view.mas_right).offset(-4);
                        make.bottom.mas_equalTo(self.recordingSuccessfulView.mas_top).offset(-4);
                        make.width.mas_equalTo(224);
                        make.height.mas_equalTo(94);
                    }];
                }
            }
        }
        
        if([self.inCallModel.ownerID isEqualToString:self.inCallModel.userID] || self.inCallModel.isAuthority) {
            if(self.isRecording && self.isStreaming) {
                [self.tipsHostView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).offset(4);
                    make.top.mas_equalTo(self.view.mas_top).offset(self.view.frame.size.height * 0.17);
                    make.width.mas_equalTo(122);
                    make.height.mas_equalTo(28);
                }];
                
                [self.tipsStreamingView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).offset(4);
                    make.top.mas_equalTo(self.tipsHostView.mas_bottom).offset(8);
                    make.width.mas_equalTo(122);
                    make.height.mas_equalTo(28);
                }];
            } else if(self.isRecording && !self.isStreaming) {
                [self.tipsHostView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).offset(4);
                    make.top.mas_equalTo(self.view.mas_top).offset(self.view.frame.size.height * 0.17);
                    make.width.mas_equalTo(122);
                    make.height.mas_equalTo(28);
                }];
            } else if(!self.isRecording && self.isStreaming) {
                [self.tipsStreamingView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).offset(4);
                    make.top.mas_equalTo(self.view.mas_top).offset(self.view.frame.size.height * 0.17);
                    make.width.mas_equalTo(122);
                    make.height.mas_equalTo(28);
                }];
            }
           
        } else {
            if(self.isRecording && self.isStreaming) {
                [self.recordingTipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).offset(4);
                    make.top.mas_equalTo(self.view.mas_top).offset(self.view.frame.size.height * 0.17);
                    make.width.mas_equalTo(106);
                    make.height.mas_equalTo(28);
                }];
                
                [self.streamingTipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).offset(4);
                    make.top.mas_equalTo(self.recordingTipsView.mas_bottom).offset(8);
                    make.width.mas_equalTo(106);
                    make.height.mas_equalTo(28);
                }];
            } else if(self.isRecording && !self.isStreaming) {
                [self.recordingTipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).offset(4);
                    make.top.mas_equalTo(self.view.mas_top).offset(self.view.frame.size.height * 0.17);
                    make.width.mas_equalTo(106);
                    make.height.mas_equalTo(28);
                }];
            } else if(!self.isRecording && self.isStreaming) {
                [self.streamingTipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).offset(4);
                    make.top.mas_equalTo(self.view.mas_top).offset(self.view.frame.size.height * 0.17);
                    make.width.mas_equalTo(106);
                    make.height.mas_equalTo(28);
                }];
            }
        }
    }
}

#pragma mark -- NSPopoverDelegate--
- (void)popoverDidShow:(NSNotification *)notification {
    self.popoverShow = YES;
}

- (void)popoverDidClose:(NSNotification *)notification {;
    self.popoverShow = NO;
}

#pragma mark- --FrtcContentWindowDelegate
- (void)onRleaseSelectContentWindow {
    self.contentWindowController = nil;
}

#pragma mark- --FrtcContentViewDelegate
- (void)onRleaseSelectContentWindowAndVC {
    [self.contentWindowController close];
    self.contentWindowController = nil;
}

- (void)onCollectionViewSelectChangedToShareDesktopWithDisplayID:(NSInteger)row {
    [self.contentWindowController close];

    NSNumber * numberSelectedDisplayID = [[_desktopListArray objectAtIndex:row] objectForKey:@"displayID"];
    uint32_t        nSelectedDisplayID = [numberSelectedDisplayID unsignedIntValue];
    
    if(self.closedDelegate && [self.closedDelegate respondsToSelector:@selector(sendContentWithDesktopID:withAppWinswoID:withContentType:withAppName:withConentAudio:)]) {
        [self.closedDelegate sendContentWithDesktopID:nSelectedDisplayID withAppWinswoID:0 withContentType:0 withAppName:@"" withConentAudio:self.sendContentAudioFlag];
    }
}

- (void)onCollectionViewSelectChangedToShareAppWithAppWindowID:(unsigned int)appWindowID
                                             withAppContentName:(NSString *)sourceAppContentName {
    [self.contentWindowController close];
    
    NSInteger row = 0;
    NSNumber * numberSelectedDisplayID = [[_desktopListArray objectAtIndex:row] objectForKey:@"displayID"];
    uint32_t        nSelectedDisplayID = [numberSelectedDisplayID unsignedIntValue];
    
    if(self.closedDelegate && [self.closedDelegate respondsToSelector:@selector(sendContentWithDesktopID:withAppWinswoID:withContentType:withAppName:withConentAudio:)]) {
        [self.closedDelegate sendContentWithDesktopID:nSelectedDisplayID withAppWinswoID:appWindowID withContentType:1 withAppName:sourceAppContentName withConentAudio:self.sendContentAudioFlag];
    }
    
}

- (void)onSendToAudioContent:(NSInteger)sendFlag {
    _sendContentAudioFlag = sendFlag;
}

#pragma mark --FrtcVideoRecordingSuccessViewDelegate--
- (void)closeByUser {
    self.closedByUser = YES;
    
    if(self.requestUnMuteView.hidden == NO) {
        [self.requestUnMuteView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.view.mas_right).offset(-4);
            make.bottom.mas_equalTo(self.callBarView.mas_top).offset(-4);
            make.width.mas_equalTo(224);
            make.height.mas_equalTo(94);
        }];
    }
    
    if(self.closedDelegate && [self.closedDelegate respondsToSelector:@selector(closedByUserCallWindow:)]) {
        [self.closedDelegate closedByUserCallWindow:YES];
    }
}
#pragma mark --FrtcGridModeViewDelegate--
- (void)selectGridMode:(BOOL)isGridMode {
    self.titleBarView.gridModeButton.title.stringValue = (isGridMode ? NSLocalizedString(@"FM_GALLERT_MODE", @"Gallery View") : NSLocalizedString(@"FM_PRESENTER_MODE", @"Presenter View"));
    [self.titleBarView updateGridModeButtonLayout:self.titleBarView.gridModeButton.title.stringValue];
    
    [self updataSettingComboxWithUserSelectMenuButtonGridMode:isGridMode];
}

- (void)updataButtonNameWithSettingComboxUserSelectGridMode:(BOOL)isGridMode {
    self.titleBarView.gridModeButton.title.stringValue = (isGridMode ? NSLocalizedString(@"FM_GALLERT_MODE", @"Gallery View") : NSLocalizedString(@"FM_PRESENTER_MODE", @"Presenter View"));
}

- (void)updataSettingComboxWithUserSelectMenuButtonGridMode:(BOOL)isGridMode {
    [self.callSettingWindow updataSettingComboxWithUserSelectMenuButtonGridMode:isGridMode];
}

#pragma mark --FrtcExceptionWindowDelegate--
- (void)endReconnectProcess {
    [[FrtcCallInterface singletonFrtcCall] endMeeting];
}

- (void)onInCallWindowInitializedState:(NSInteger)state {
    if(self.closedDelegate && [self.closedDelegate respondsToSelector:@selector(initializedState:)]) {
        [self.closedDelegate initializedState:state];
    }
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
        
        [self.streamingUrlWindow center];
    }
}

- (BOOL)isEnglish {
    NSString * language = [FMLanguageConfig userLanguage] ? : [NSLocale preferredLanguages].firstObject;
    
    if([language hasPrefix:@"en"]) {
        return YES;
    } else {
        return NO;
    }
}


#pragma mark --FrtcVideoRecordingTipsViewDelegate--
- (void)showTipsView:(BOOL)show withViewType:(TipsViewType)type {
    if(type == TipsRecording) {
        self.tipsView.title.stringValue = NSLocalizedString(@"FM_VIDEO_RECORDING_EDNED", @"End Recording");
        
        [self.tipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).offset(82);
            make.top.mas_equalTo(self.tipsHostView.mas_bottom).offset(2);
            make.width.mas_equalTo([self isEnglish] ? 100: 56);
            make.height.mas_equalTo(21);
        }];
        self.tipsView.hidden = !show;
    } else if(type == TipsStreaming) {
        self.tipsViewForStreaming.hidden = !show;
        self.tipsViewForStreaming.title.stringValue = NSLocalizedString(@"FM_VIDEO_STREAMING_EDNED", @"End Living");
        
        [self.tipsViewForStreaming mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).offset(82);
            make.top.mas_equalTo(self.tipsStreamingView.mas_bottom).offset(2);
            make.width.mas_equalTo([self isEnglish] ? 100: 56);
            make.height.mas_equalTo(21);
        }];
    }
}

- (void)stopVideoRecording:(TipsViewType)type {
    //__weak __typeof(self)weakSelf = self;
    
    if(type == TipsRecording) {
        if([self.endVideoRecordingWindow isVisible]) {
            return;
        }
        self.endVideoRecordingWindow = [[FrtcVideoRecordingEndWindow alloc] initWithSize:NSMakeSize(380, 180)];
        self.endVideoRecordingWindow.endWindowDelegate = self;
        
        [self.endVideoRecordingWindow showWindowWithWindow:self.view.window];
    } else {
        if([self.endVideoStreamingWindow isVisible]) {
            return;
        }
        self.endVideoStreamingWindow = [[FrtcVideoStreamingEndWindow alloc] initWithSize:NSMakeSize(320, 150)];
        self.endVideoStreamingWindow.endWindowDelegate = self;

        [self.endVideoStreamingWindow showWindowWithWindow:self.view.window];
    }
}
#pragma mark --FrtcVideoStreamingMuteTipsWindowDelegate--
- (void)unMuteStreaming {
    self.callBarView.videoStreamingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_STREAMING", @"Live");
    [self.callBarView.videoStreamingButton setState:NSControlStateValueOff];
    
    [self.callBarView.muteAudioButton setState:NSControlStateValueOn];
    self.callBarView.muteAudioLabel.stringValue = NSLocalizedString(@"FM_MUTE", @"Mute");
    [[FrtcCallInterface singletonFrtcCall] audioMute:NO];
}

- (void)startStreamingAnyway {
    __weak __typeof(self)weakSelf = self;
    
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcMeetingStartStreaming:self.inCallModel.userToken meetingNumber:self.inCallModel.conferenceNumber streamingPassword:@"" clientIdentifier:self.inCallModel.userIdentifier startStreamingSeccess:^{

    } startStreamingFailure:^(NSError * _Nonnull error) {
    }];
}

#pragma mark --FrtcVideoRecordingMuteTipsWindowDelegate--
- (void)unMute {
    self.callBarView.videoRecordingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_RECORDING", @"Record");
    [self.callBarView.videoRecordingButton setState:NSControlStateValueOff];
    
    [self.callBarView.muteAudioButton setState:NSControlStateValueOn];
    self.callBarView.muteAudioLabel.stringValue = NSLocalizedString(@"FM_MUTE", @"Mute");
    [[FrtcCallInterface singletonFrtcCall] audioMute:NO];
}

- (void)startRecordingAnyway {
    __weak __typeof(self)weakSelf = self;
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcMeetingStartRecording:self.inCallModel.userToken meetingNumber:self.inCallModel.conferenceNumber clientIdentifier:self.inCallModel.userIdentifier startRecordingSeccess:^{

    } startRecordingFailure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf handleRecordingAndStreamingError:error];
    }];
}

#pragma mark --FrtcVideoRecordingEndWindowwDelegate--
- (void)endVideoRecording {
    __weak __typeof(self)weakSelf = self;
    
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcMeetingStopRecording:self.inCallModel.userToken meetingNumber:self.inCallModel.conferenceNumber clientIdentifier:self.inCallModel.userIdentifier stopRecordingSuccessful:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.callBarView.videoRecordingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_RECORDING", @"Record");
        [strongSelf.callBarView.videoRecordingButton setState:NSControlStateValueOff];
    } stopRecordingFailure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf handleRecordingAndStreamingError:error];
    }];
}

- (void)cancelEndingVideoRecording {
    self.callBarView.videoRecordingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_STOP_RECORDING", @"End Record");
    [self.callBarView.videoRecordingButton setState:NSControlStateValueOn];
}

#pragma mark --FrtcVideoStreamingEndWindowwDelegate--
- (void)endVideoStreaming {
    __weak __typeof(self)weakSelf = self;
    
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcMeetingStopStreaming:self.inCallModel.userToken meetingNumber:self.inCallModel.conferenceNumber clientIdentifier:self.inCallModel.userIdentifier stopStreamingSuccessful:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        strongSelf.callBarView.videoStreamingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_STREAMING", @"Live");
        [strongSelf.callBarView.videoStreamingButton setState:NSControlStateValueOff];
        
        if([self.streamingUrlWindow isVisible]) {
            [self.streamingUrlWindow close];
        }
    } stopStreamingFailure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf handleRecordingAndStreamingError:error];
    }];
}

- (void)cancelEndingVideoStreaming {
    self.callBarView.videoStreamingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_STOP_STREAMING", @"End Live");
    [self.callBarView.videoStreamingButton setState:NSControlStateValueOn];
}

#pragma mark --FrtcVideoStreamingWindowDelegate--
- (void)startVideoStreamingWithPassword:(NSString *)password {
    __weak __typeof(self)weakSelf = self;
    
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcMeetingStartStreaming:self.inCallModel.userToken meetingNumber:self.inCallModel.conferenceNumber streamingPassword:password clientIdentifier:self.inCallModel.userIdentifier startStreamingSeccess:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.callBarView.videoStreamingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_STOP_STREAMING", @"End Live");
        [strongSelf.callBarView.videoStreamingButton setState:NSControlStateValueOn];
    } startStreamingFailure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf handleRecordingAndStreamingError:error];
    }];
}

- (void)cancelVideoStreaming {
    self.callBarView.videoStreamingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_STREAMING", @"Live");
    [self.callBarView.videoStreamingButton setState:NSControlStateValueOff];
}

#pragma mark --FrtcVideoRecordingWindowDelegate--
- (void)startVideoRecording {
    __weak __typeof(self)weakSelf = self;
    [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcMeetingStartRecording:self.inCallModel.userToken meetingNumber:self.inCallModel.conferenceNumber clientIdentifier:self.inCallModel.userIdentifier startRecordingSeccess:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;

        strongSelf.callBarView.videoRecordingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_STOP_RECORDING", @"End Record");
        [strongSelf.callBarView.videoRecordingButton setState:NSControlStateValueOn];
    } startRecordingFailure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf handleRecordingAndStreamingError:error];
    }];
}

- (void)cancelVideoRecording {
    self.callBarView.videoRecordingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_RECORDING", @"Record");
    [self.callBarView.videoRecordingButton setState:NSControlStateValueOff];
}

#pragma mark --FrtcReConnectCallWindowDelegate--
- (void)reConnectMeeting {
    self.reConnectProgress.hidden = NO;
    self.tipsTextField.hidden = NO;
    
    [self.reConnectProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(32);
    }];
    
    [self.reConnectProgress startAnimation:self];
    
    [self.tipsTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.reConnectProgress.mas_bottom).offset(10);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    self.reCallBlock();
}

- (void)endReConnectCall {
    [[FrtcCallInterface singletonFrtcCall] endMeeting];
}

- (void)setLectureArrayList:(NSMutableArray<NSString *> *)lectureList {
    self.lectureArray = lectureList;
    
    if([self.lectureArray count] != 0) {
        NSString *lectureUUID = self.lectureArray[0];
        
        if([lectureUUID isEqualToString:self.inCallModel.userIdentifier]) {
            [self showReminderView:NSLocalizedString(@"FM_ALREADY_SETED_LECTURE", @"You have been set as a speaker by the host")];
        }
    }
}

#pragma mark --FrtcRequestUnMuteListViewControllerDelegate--
- (void)agreeAll {
    self.newRequest = NO;
    self.callBarView.showNewComingView.hidden = YES;
    [self.requestDictionary removeAllObjects];
    self.requestUnMuteView.hidden = YES;
    
    if([self.participantsWindow isVisible]) {
        [(FrtcParticipantsViewController *)(self.participantsWindow.contentViewController) updateRequestCell:@"" isShow:NO isNewRequest:NO];
    }
}

- (void)agreeOneUserWithUUID:(NSString *)uuid {
    [self.requestDictionary removeObjectForKey:uuid];
    self.requestUnMuteView.hidden = YES;
    
    if([self.participantsWindow isVisible]) {
        if([self.requestDictionary allKeys].count == 0) {
            [(FrtcParticipantsViewController *)(self.participantsWindow.contentViewController) updateRequestCell:@"" isShow:NO isNewRequest:NO];
        } else {
            [(FrtcParticipantsViewController *)(self.participantsWindow.contentViewController) updateRequestCell:[self.requestDictionary allValues][0] isShow:YES isNewRequest:NO];
        }
    }
}

#pragma mark --FrtcRequestUnMuteViewDelegate--
- (void)ignoreRequest {
    [self showReminderView:NSLocalizedString(@"FM_TOAST_IGNORE", @"Ignored the request")];
    self.requestUnMuteView.hidden = YES;
    
    self.newRequest = NO;
    self.callBarView.showNewComingView.hidden = YES;
}

- (void)viewRequest {
    self.requestUnMuteView.hidden = YES;
    
    self.newRequest = NO;
    self.callBarView.showNewComingView.hidden = YES;
    
    if([self.requestListWindow isVisible]) {
        [self.requestListWindow makeKeyAndOrderFront:self];
    } else {
        self.requestListWindow = [[FrtcRequestUnMuteListWindow alloc] initWithSize:NSMakeSize(448, 463)];
        FrtcRequestUnMuteListViewController *requestUnMuteListViewController = [[FrtcRequestUnMuteListViewController alloc] init];
        requestUnMuteListViewController.delegate = self;
        requestUnMuteListViewController.inCallModel = self.inCallModel;
        [requestUnMuteListViewController popRequestUnmuteView:self.requestDictionary];

        self.requestListWindow.contentViewController = requestUnMuteListViewController;
        self.requestListWindow.titleVisibility       = NSWindowTitleHidden;
        [self.requestListWindow makeKeyAndOrderFront:self];
        [self.requestListWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
        [self.requestListWindow center];
    }
}

#pragma mark- --timer--
- (void)runningTimer:(NSTimeInterval)timeInterval {
    self.reminderTipsTimer = [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(reminderTipsEvent) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.reminderTipsTimer forMode:NSRunLoopCommonModes];
}

- (void)cancelTimer {
    if(_reminderTipsTimer != nil) {
        [_reminderTipsTimer invalidate];
        _reminderTipsTimer = nil;
    }
}

- (void)reminderTipsEvent {
    [self.reminderView setHidden:YES];
}

#pragma mark- --setter--
-(void)setReceivingContent:(BOOL)receivingContent {
    _receivingContent = receivingContent;
    
    if(!self.window.isVisible) {
        return;
    }
    if(self.isReceivingContent) {
        self.titleBarView.gridModeButton.hidden = YES;
    } else {
        self.titleBarView.gridModeButton.hidden = NO;
    }
}

#pragma mark- --Timer--
- (void)startMeetingTimer:(NSTimeInterval)timeInterval {
    self.meetingInfoTimer = [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(handleTimeInterval) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.meetingInfoTimer forMode:NSRunLoopCommonModes];
}

- (void)handleTimeInterval {
    self.meetingView.hidden = YES;
}

- (void)cancelMeetingInfoTimer {
    if(self.meetingInfoTimer != nil) {
        [self.meetingInfoTimer invalidate];
        self.meetingInfoTimer = nil;
    }
}

- (void)startStaticsTimer:(NSTimeInterval)timeInterval {
    self.staticsInfoTimer = [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(handleStaticsTimer) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.staticsInfoTimer forMode:NSRunLoopCommonModes];
}

- (void)handleStaticsTimer {
    self.staticsView.hidden = YES;
}

- (void)cancelStaticsInfoTimer {
    if(self.staticsInfoTimer != nil) {
        [self.staticsInfoTimer invalidate];
        self.staticsInfoTimer = nil;
    }
}

#pragma mark --One Minimute Timer--
- (void)startMinimuteTimer:(NSTimeInterval)timeInterval {
    self.overOneMinimuteTimer = [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(handleMinimuteEvent) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.overOneMinimuteTimer forMode:NSRunLoopCommonModes];
}

- (void)cancelOneMinimuteTimer {
    if(_overOneMinimuteTimer != nil) {
        [_overOneMinimuteTimer invalidate];
        _overOneMinimuteTimer = nil;
    }
}

- (void)handleMinimuteEvent {
    self.askForUnMuteOverOneMinimute = YES;
}

#pragma mark- --FrtcTitleBarViewDelegate--
- (void)popupMeetingInfo:(BOOL)show {
    if(show) {
        [self.meetingInfoTimer fire];
        [self cancelMeetingInfoTimer];
        self.meetingView.hidden = NO;
    } else {
        [self startMeetingTimer:2.0];
    }
}

- (void)popupStaticsInfo:(BOOL)show {
    if(show) {
        [self.staticsInfoTimer fire];
        [self cancelStaticsInfoTimer];
        self.staticsView.hidden = NO;
        [self.staticsView updateStatics:self.mediaStaticModel];
    } else {
        [self startStaticsTimer:2.0];
    }
}

- (void)enterFullScreen:(BOOL)isFullScreen {
    self.fullScreen = isFullScreen;
    
    if([self.window isVisible]) {
        [self.window toggleFullScreen:nil];
    }
}

- (void)openGridModeView {
    self.gridModeView.hidden = NO;
    
    NSString *layoutMode = [[FrtcUserDefault defaultSingleton] objectForKey:DEFAULT_LAYOUT];
    if([layoutMode isEqualToString:@"gallery"]) {
        [self.gridModeView.galleryBackgroundView updateBKColor:YES];
        [self.gridModeView.presenterBackgroundView updateBKColor:NO];
    } else {
        [self.gridModeView.galleryBackgroundView updateBKColor:NO];
        [self.gridModeView.presenterBackgroundView updateBKColor:YES];
    }
}

#pragma mark --FrtcEnableMessageWindowDelegate--
- (void)cancelMessage {
    [self.callBarView.enableTextButton setState:NSControlStateValueOff];
    
    self.callBarView.enableTexttLabel.stringValue = NSLocalizedString(@"FM_MESSAGE_BAR", @"Overlay");
}

- (void)startMessageSuccess {
    [self showReminderView:NSLocalizedString(@"FM_MESSAGE_ENABLE", @"Overlay started")];
}

#pragma mark- --FrtcMeetingInfoViewDelegate--
- (void)cursorIsInView:(BOOL)isInView {
    if(isInView) {
        [self.meetingInfoTimer fire];
        [self cancelMeetingInfoTimer];
        self.meetingView.hidden = NO;
    } else {
        self.meetingView.hidden = YES;
    }
}

#pragma mark- --FrtcMediaStaticsViewDelegate--
- (void)staticsViewCursorIsInView:(BOOL)isInView {
    if(isInView) {
        [self.staticsInfoTimer fire];
        [self cancelStaticsInfoTimer];
        self.staticsView.hidden = NO;
    } else {
        self.staticsView.hidden = YES;
    }
}

- (void)popupStaticsWindow {
    if(![self.staticsWindowController.window isVisible]) {
        FrtcStaticsViewController *staticsViewController = [[FrtcStaticsViewController alloc] init];
        staticsViewController.conferenceAlias = self.inCallModel.conferenceNumber;
        staticsViewController.conferenceName  = self.inCallModel.conferenceName;
        
        [(FrtcStaticsViewController *)(self.staticsWindowController.window.contentViewController) handleStaticsEvent:self.staticsModel];
        
        NSWindow *mainWindow = [NSWindow windowWithContentViewController:staticsViewController];
        self.staticsWindowController = [[StaticsWindowController alloc] initWithWindow:mainWindow];
        staticsViewController.view.window.windowController = self.staticsWindowController;
        
        self.staticsWindowController.window.contentMaxSize = NSSize(staticsViewController.view.frame.size);
        self.staticsWindowController.window.contentMinSize = NSSize(staticsViewController.view.frame.size);
    }
    [self.staticsWindowController.window makeKeyAndOrderFront:self];
    self.staticsWindowController.window.titleVisibility       = NSWindowTitleHidden;
    [self.staticsWindowController.window setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    [self.staticsWindowController.window center];
    [self.staticsWindowController showWindow:nil];
}

#pragma mark- --FrtcParticipantsViewControllerDelegate
- (void)showMeetingInfoWindow {
    [self showMeetingInfo];
}

- (void)muteAll {
    if(self.callBarView.muteAudioButton.state == NSControlStateValueOff) {
        [self.callBarView.muteAudioButton setState:NSControlStateValueOn];
        self.callBarView.muteAudioLabel.stringValue = @"静音";
        [[FrtcCallInterface singletonFrtcCall] audioMute:NO];
    }
}
- (void)muteBySelf:(BOOL)mute {
    [self muteAudioByUser:mute];
}

- (void)showAskForUnmuteList {
    self.newRequest = NO;
    self.callBarView.showNewComingView.hidden = YES;
    if([self.requestListWindow isVisible]) {
        [self.requestListWindow makeKeyAndOrderFront:self];
    } else {
        self.requestListWindow = [[FrtcRequestUnMuteListWindow alloc] initWithSize:NSMakeSize(448, 463)];
        FrtcRequestUnMuteListViewController *requestUnMuteListViewController = [[FrtcRequestUnMuteListViewController alloc] init];
        requestUnMuteListViewController.delegate = self;
        requestUnMuteListViewController.inCallModel = self.inCallModel;
        [requestUnMuteListViewController popRequestUnmuteView:self.requestDictionary];

        self.requestListWindow.contentViewController = requestUnMuteListViewController;
        self.requestListWindow.titleVisibility       = NSWindowTitleHidden;
        [self.requestListWindow makeKeyAndOrderFront:self];
        [self.requestListWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
        [self.requestListWindow center];
    }
}

#pragma mark- --FrtcDropCallWindowDelegate--
- (void)leaveMeeting {
    [[FrtcCallInterface singletonFrtcCall] endMeeting];
    [self cancelOneMinimuteTimer];
    self.askForUnMuteBySelf = NO;
}

- (void)endingMeeting {
    FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_STOP_MEETING_TITLE", @"Are sure to end the meeting?") withMessage:NSLocalizedString(@"FM_STOP_MEETING_MESSAGE", @"End meeting will dismiss all participants!") preferredStyle:FrtcWindowAlertStyleDefault withCurrentWindow:self.view.window];

    __weak __typeof(self)weakSelf = self;
    FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        [[FrtcCallInterface singletonFrtcCall] stopReConnect];
        [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcOwnerStopMeeting:strongSelf.inCallModel.userToken meetingNumber:strongSelf.inCallModel.conferenceNumber stopCompletionHandler:^{
            [strongSelf.maskView removeFromSuperview];
        } stopFailure:^(NSError * _Nonnull error) {
            if([error.localizedDescription isEqualToString:@"Request failed: unauthorized (401)"]) {
                FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_VERIFY_FAILURE", @"Verifyication failed") withMessage:NSLocalizedString(@"FM_RE_SIGN", @"Please sign in again") preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:self.window];

                FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{
                    
                }];
                [alertWindow addAction:action];
            }
        }];
        
        [strongSelf.callSettingWindow close];
        [strongSelf.participantsWindow close];
        strongSelf.askForUnMuteBySelf = NO;
        [strongSelf cancelOneMinimuteTimer];
        
    }];
    
    [alertWindow addAction:action];
    
    FrtcAlertAction *actionCancel = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_CANCEL", @"Cancel") style:FrtcWindowAlertActionStyleCancle handler:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.maskView removeFromSuperview];
    }];
    
    [alertWindow addAction:actionCancel];
}

- (void)cancelDropCall {
    [self.maskView removeFromSuperview];
}

#pragma mark --MeetingInformationViewDelegate--
- (void)repeateUpdateView {
    if(self.isOverlayMessage) {
        if([self.overlayMessageModel.type isEqualToString:@"global"]) {
            [self.overlayView setHidden:NO];
            CGFloat y = 0;
            
            if([self.overlayMessageModel.verticalPosition integerValue] == 0) {
                y = self.window.contentViewController.view.frame.size.height - 28 - 40;
            } else if([self.overlayMessageModel.verticalPosition integerValue] == 50) {
                y = self.window.contentViewController.view.frame.size.height / 2;
            } else if([self.overlayMessageModel.verticalPosition integerValue] == 100) {
                y = 56;
            }
            
            CGFloat width = self.window.contentViewController.view.frame.size.width;
            
            self.overlayView.frame = CGRectMake(0, y, width, 40);
            [self setUpOverlaymessage];
        }
    } else {
        [self.overlayView setHidden:YES];
    }
}

#pragma mark- --FrtcCallBarViewtDelegate--
- (void)showSettingWindow {
    if([self.callSettingWindow isVisible]) {
        [self.callSettingWindow makeKeyAndOrderFront:self];
    } else {
        FrtcSettingViewController *settingViewController = [[FrtcSettingViewController alloc] initWithloginStatus:NO];
        if(self.inCallModel.isLoginCall) {
            settingViewController.settingType = SettingTypeLoginCall;
        } else {
            settingViewController.settingType = SettingTypeGuestCall;
        }
    
        self.callSettingWindow = [[FrtcMainWindow alloc] initWithSize:NSMakeSize(640, 560)];
        self.callSettingWindow.contentViewController = settingViewController;
        self.callSettingWindow.titleVisibility       = NSWindowTitleHidden;
        [self.callSettingWindow makeKeyAndOrderFront:self];
        [self.callSettingWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
        [self.callSettingWindow center];
    }
}

- (void)enableMesage:(BOOL)enable {
    if(!enable) {
        
        __weak __typeof(self)weakSelf = self;
        [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcMeetingStopOverlayMessage:self.inCallModel.userToken meetingNumber:self.inCallModel.conferenceNumber clientIdentifier:self.inCallModel.userIdentifier stopMessageSuccessfulHandler:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf showReminderView:NSLocalizedString(@"FM_MESSAGE_DISABLE", @"Overlay stopped")];
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

    
    [self.enableMessageWindow showWindowWithWindow:self.view.window];
    self.enableMessageWindow.inCallModel = self.inCallModel;
}

- (void)showNameList {
    if([self.participantsWindow isVisible]) {
        [self.participantsWindow makeKeyAndOrderFront:self];
    } else {
        self.participantsWindow = [[FrtcParticipantsWindow alloc] initWithSize:NSMakeSize(388, 514)];
        FrtcParticipantsViewController *rosterListViewController = [[FrtcParticipantsViewController alloc] init];
        rosterListViewController.inCallModel = self.inCallModel;
        rosterListViewController.controllerDelegate = self;
        rosterListViewController.authority = self.inCallModel.authority;
        
        NSArray *array = [self.modelArray copy];
        
        [rosterListViewController handleRosterEvent:array];
        
        [rosterListViewController setLectureUUID:self.lectureArray];
        
        if([self.requestDictionary allKeys].count != 0) {
            NSString *name = [self.requestDictionary allValues][0];
            [rosterListViewController updateRequestCell:name isShow:YES isNewRequest:self.isNewRequest];
        }
        
        self.participantsWindow.contentViewController = rosterListViewController;
        self.participantsWindow.titleVisibility       = NSWindowTitleHidden;
 
        [self.participantsWindow makeKeyAndOrderFront:self];
        [self.participantsWindow setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
        [self.participantsWindow center];
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

- (void)endMeeting {
    self.maskView.alphaValue = 0.7;
    self.maskView.frame = NSMakeRect(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.maskView];
    
    NSSize windowSize;
    if([self.inCallModel.ownerID isEqualToString:self.inCallModel.userID] || self.inCallModel.isAuthority) {
        windowSize = NSMakeSize(240, 180);
    } else {
        windowSize = NSMakeSize(240, 150);
    }
    
    FrtcDropCallWindow *dropCallWindow = [[FrtcDropCallWindow alloc] initWithSize:windowSize];
    dropCallWindow.dropCallDelegate = self;
    dropCallWindow.titleVisibility  = NSWindowTitleHidden;
    
    [dropCallWindow showWindowWithWindow:self.view.window];

    [dropCallWindow setLevel:NSPopUpMenuWindowLevel];
}

- (void)showContentWindow {
    [self loadDesktopList];
        
    if ([[self.contentWindowController window] isVisible]) {
        [[self.contentWindowController window] makeKeyAndOrderFront:self];
    } else {
        FrtcContentViewController *contentViewController = [[FrtcContentViewController alloc] init];
        contentViewController.delegate = self;
        NSWindow *mainWindow = [NSWindow windowWithContentViewController:contentViewController];
        
        self.contentWindowController = [[FrtcContentWindowController alloc] initWithWindow:mainWindow];
        [self.contentWindowController.window setMovableByWindowBackground:YES];
        self.contentWindowController.window.titlebarAppearsTransparent = YES;
        self.contentWindowController.window.titleVisibility = NSWindowTitleHidden;
        self.contentWindowController.window.backgroundColor = [NSColor whiteColor];

        contentViewController.view.window.windowController = self.contentWindowController;
    
        [self.contentWindowController.window standardWindowButton:NSWindowZoomButton].enabled = NO;
        [self.contentWindowController.window standardWindowButton:NSWindowMiniaturizeButton].enabled = NO;
        
        self.contentWindowController.window.contentMaxSize = NSSize(contentViewController.view.frame.size);
        self.contentWindowController.window.contentMinSize = NSSize(contentViewController.view.frame.size);

        NSString *titleStr = NSLocalizedString(@"FM_SHARE_CONTENT", @"Share Content");
        self.contentWindowController.window.title = titleStr;
        self.contentWindowController.window.delegate = self.contentWindowController;
        self.contentWindowController.delegate = self;
    }
    
    [(FrtcContentViewController *)(self.contentWindowController.window.contentViewController) handleDesktopEvent:_desktopListArray];
    [self.contentWindowController.window makeKeyAndOrderFront:self];
    [self.contentWindowController.window center];
    [self.contentWindowController showWindow:nil];
}

- (void)poverContentAudio {
    if(!self.popover.isShown) {
        NSViewController *controller;
        
        controller = [[FrtcContentAudioSettingViewController alloc] init];
        ((FrtcContentAudioSettingViewController *)controller).delegate = self;
        
        self.popover = [[NSPopover alloc] init];
        self.popover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];
        
        self.popover.contentViewController = controller;
        self.popover.behavior = NSPopoverBehaviorTransient;
    
        [self.popover showRelativeToRect:self.callBarView.contentAudioBackGroundView.frame ofView:self.callBarView.superview preferredEdge:NSRectEdgeMaxY];
    }
}

- (void)showMuteBySelfAlert {
    if([self.askUnmuteWindow isVisible]) {
        return;
    }
    
    self.askUnmuteWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_ALREADY_MUTED", @"You are muted") withMessage:NSLocalizedString(@"FM_ALREADY_MUTED_DESCRIPTION", @"The host does not allow unmuting. you can reguest to do so.") preferredStyle:FrtcWindowAlertStyleDefault withCurrentWindow:self.view.window];

        __weak __typeof(self)weakSelf = self;
        FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_ASK_FOR_UN_MUTED", @"Ask to unmute") style:FrtcWindowAlertActionStyleOK handler:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcMeetingRequestUnmute:strongSelf.inCallModel.userToken meetingNumber:strongSelf.inCallModel.conferenceNumber clientIdentifier:strongSelf.inCallModel.userIdentifier requestUnmuteSuccessful:^{
                    [strongSelf showReminderView:NSLocalizedString(@"FM_ALREADY_SENDING_UN_MUTE_MESSAGE", @"The request of unmute has been sent")];
                    strongSelf.askForUnMuteBySelf = YES;
                    [strongSelf startMinimuteTimer:60];
                } requestUnmuteFailure:^(NSError * _Nonnull error) {
                    NSLog(@"The error is %@", error);
            }];
        }];
        
        [self.askUnmuteWindow addAction:action];

        FrtcAlertAction *actionCancel = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_CANCEL", @"Cancel") style:FrtcWindowAlertActionStyleCancle handler:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.askForUnMuteBySelf = NO;
        }];
        
        [self.askUnmuteWindow addAction:actionCancel];
}

- (void)updateDisplayRemoveEvent {
    if ([self.contentWindowController.window isVisible]) {
        [self loadDesktopList];
        [(FrtcContentViewController *)(self.contentWindowController.window.contentViewController) handleDesktopEvent:self.desktopListArray];
    }
}

- (void)loadDesktopList {
    [_desktopListArray removeAllObjects];
    
    NSMutableArray *monitorList = [NSMutableArray arrayWithArray:[[FrtcCall sharedFrtcCall] frtcGetMonitorList]];
    for (int i = 0; i < [monitorList count]; i++) {
        
        NSDictionary *dic = [monitorList objectAtIndex:i];
        NSNumber *indexNum = [dic objectForKey:@"index"];
        int index = [indexNum intValue];
        NSString *dskName = [NSString stringWithFormat:NSLocalizedString(@"FM_SHARE_DESKTOP", @"Desktop %d"), index+1];
        
        NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
        [d setValue:indexNum forKey:@"index"];
        [d setValue:[dic objectForKey:@"displayID"] forKey:@"displayID"];
        [d setValue:dskName forKey:@"name"];
        [d setValue:[dic objectForKey:@"x"] forKey:@"x"];
        [d setValue:[dic objectForKey:@"y"] forKey:@"y"];
        [d setValue:[dic objectForKey:@"width"] forKey:@"width"];
        [d setValue:[dic objectForKey:@"height"] forKey:@"height"];
        
        [_desktopListArray addObject:d];
    }
}

- (void)fullScreenState:(NSInteger)state {
    [self.titleBarView fullScreenState:state];
    
    CGFloat width = 0, baseHeight = 0;
    if(state == 1) {
        NSScreen *screen = [NSScreen mainScreen];
        NSDictionary *description = [screen deviceDescription];
        NSSize dispalyPixelSize = [[description objectForKey:NSDeviceSize] sizeValue];
        
        baseHeight  = dispalyPixelSize.height;
        width       = dispalyPixelSize.width;
    } else if(state == 0) {
        baseHeight = [[FrtcBaseImplement baseImpleSingleton] screenHeight];
        width = [[FrtcBaseImplement baseImpleSingleton] screenWidth];
    }
    
    CGFloat y = 0;
    
    if([self.overlayMessageModel.verticalPosition integerValue] == 0) {
        y = baseHeight - 28 - 40;
    } else if([self.overlayMessageModel.verticalPosition integerValue] <= 50
              && [self.overlayMessageModel.verticalPosition integerValue] > 0) {
        y = baseHeight / 2;
    } else if([self.overlayMessageModel.verticalPosition integerValue] == 100) {
        y = 56;
    }
    
    self.overlayView.frame = CGRectMake(0, y, width, 40);

    if(self.isOverlayMessage) {
        [self.overlayView restart];
    }
    
    if(!self.overlayView.isHidden) {
        if(self.overlayView.isStillnessInfo) {
            [self.overlayView reSetupStilnessLayout];
        }
    }
}

- (void)resetOverlayForContentType:(NSInteger)type {
    if(type == 1) {
        if (self.overlayView && ![self.overlayView isHidden]) {
            [self.overlayView stop];
            [self.overlayView setHidden:YES];
        }
    } else if(type == 2) {
        CGFloat y = 0;
        
        if([self.overlayMessageModel.verticalPosition integerValue] == 0) {
            y = [[FrtcBaseImplement baseImpleSingleton] screenHeight] - 28 - 40;
        } else if([self.overlayMessageModel.verticalPosition integerValue] <= 50
                  && [self.overlayMessageModel.verticalPosition integerValue] > 0) {
            y = [[FrtcBaseImplement baseImpleSingleton] screenHeight] / 2;
        } else if([self.overlayMessageModel.verticalPosition integerValue] == 100) {
            y = 56;
        }
        
        CGFloat width = [[FrtcBaseImplement baseImpleSingleton] screenWidth];
        
        self.overlayView.frame = CGRectMake(0, y, width, 40);
        
        if(self.overlayMessage) {
            [self.overlayView restart];
        }
        
        if(self.overlayView.isStillnessInfo) {
            [self.overlayView reSetupStilnessLayout];
        }
    }
}

- (void)resetOverLay {
    self.overlayMessageViewInitialized = YES;
    [self.overlayView setHidden:YES];
    
    if(self.overlayMessageModel == nil) {
        return;
    }
    
    CGFloat y = 0;
    
    if([self.overlayMessageModel.verticalPosition integerValue] == 0) {
        y = self.window.contentViewController.view.frame.size.height - 28 - 40;
    } else if([self.overlayMessageModel.verticalPosition integerValue] == 50) {
        y = self.window.contentViewController.view.frame.size.height / 2;
    } else if([self.overlayMessageModel.verticalPosition integerValue] == 100) {
        y = 56;
    }
    
    CGFloat width = self.window.contentViewController.view.frame.size.width;
    
    self.overlayView.frame = CGRectMake(0, y, width, 40);
    
    if (self.overlayMessage) {
        [self configOverlayMessageView];
    }
}
- (void)handleMeetingOverlayMessage:(NSString *)message {
    self.overlayMessageViewInitialized = YES;
    NSString *overLayMessageString = message;
    NSError *error = nil;
    self.overlayMessageModel = [[MeetingMessageModel alloc] initWithString:overLayMessageString error:&error];
    
    if([self.overlayMessageModel.enabledMessageOverlay boolValue]) {
        self.overlayMessage = YES;
        
        if([self.overlayMessageModel.type isEqualToString:@"global"]) {
            if (self.overlayMessageViewInitialized) {
                [self configOverlayMessageView];
            }
        }
    } else {
        self.overlayMessage = NO;
        
        if(self.overlayView.isStillnessInfo) {
           [self.overlayView setHidden:YES];
        } else {
            [self.overlayView stop];
        }
    }
}

-(void)configOverlayMessageView {
    if([self.overlayMessageModel.type isEqualToString:@"global"]) {
        [self configOverlayMessageViewFrame];
        if(self.overlayView.isHidden) {
            self.overlayView.hidden = NO;
            [self setUpOverlaymessage];
        } else {
            if(self.overlayView.isStillnessInfo) {
                [self setUpOverlaymessage];
            } else {
                if([self.overlayMessageModel.displaySpeed compare:@"static" options:NSCaseInsensitiveSearch] == 0) {
                    [self.overlayView stop];
               }
            }
        }
    }
}

- (void)setUpOverlaymessage {
    CGSize textSize = [self configMsgSiz];
    float duration = (textSize.width + self.overlayView.frame.size.width) / 80;
    
    self.overlayMessage = NO;
    
    [self.overlayView configMessageViewAnimation:duration];
}

- (CGSize)configMsgSiz {
    NSString *contentStr = [self.overlayMessageModel.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"\t" withString:@" "];

    if ([self.overlayMessageModel.displaySpeed compare:@"static" options:NSCaseInsensitiveSearch] == 0) {
        self.overlayView.stillnessInfo = YES;
    }
    else {
        self.overlayView.stillnessInfo = NO;
    }
    
    self.overlayView.infomationTextField.stringValue = contentStr;
    self.overlayView.cycleNumbers = [self.overlayMessageModel.displayRepetition floatValue];
    
    NSDictionary *attributes = @{NSFontAttributeName:[NSFont systemFontOfSize:16.0f]};
    CGSize textSize = [contentStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    textSize.width = ceil(textSize.width) + 10.0f;
    textSize.height = ceil(textSize.height);
    
    [self.overlayView setupViewSize:textSize];
    
    return textSize;
}

- (void)configOverlayMessageViewFrame {
    CGFloat y = 0;
    
    if([self.overlayMessageModel.verticalPosition integerValue] == 0) {
        y = self.window.contentViewController.view.frame.size.height - 28 - 40;
    } else if([self.overlayMessageModel.verticalPosition integerValue] <= 50
              && [self.overlayMessageModel.verticalPosition integerValue] > 0) {
        y = self.window.contentViewController.view.frame.size.height / 2;
    } else if([self.overlayMessageModel.verticalPosition integerValue] == 100) {
        y = 56;
    }
    
    CGFloat width = self.window.contentViewController.view.frame.size.width;
    
    self.overlayView.frame = CGRectMake(0, y, width, 40);
}

- (void)alreadyInCall {
    if([self.alreadyInCallWindow isVisible]) {
        return;
    }
    
    self.alreadyInCallWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:@"" withMessage:NSLocalizedString(@"FM_ALREADY_IN_MEETING", @"You are already in meeting") preferredStyle:FrtcWindowAlertStyleNoTitle withCurrentWindow:self.view.window];
   
    FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{

    }];
    
    [self.alreadyInCallWindow addAction:action];
 }

- (void)toastInfomation {
    FrtcAlertMainWindow *toastInCallWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:@"" withMessage:NSLocalizedString(@"FM_ADD_MEETING_LIST_IN_MEETING", @"Please end the current meeting before adding meeting") preferredStyle:FrtcWindowAlertStyleNoTitle withCurrentWindow:self.view.window];
   
    FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{

    }];
    
    [toastInCallWindow addAction:action];
}

- (void)alreadyShowMuteBySelfAlert {
    if([self.alreadySentUnmuteRequestWindow isVisible]) {
        return;
    }
    self.alreadySentUnmuteRequestWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_ALREADY_SEND_ASK_FOR", @"Requesting to be unmuted") withMessage:NSLocalizedString(@"FM_ALREADY_SEND_ASK_FOR_DESCRIPTION", @"You are asking the host to unmute, please wait.") preferredStyle:FrtcWindowAlertStyleOnly withCurrentWindow:self.view.window];

    FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_BUTTON_OK", @"OK") style:FrtcWindowAlertActionStyleOK handler:^{

    }];
    [self.alreadySentUnmuteRequestWindow addAction:action];
}

- (void)muteAudioByUser:(BOOL)isMute {
    if(isMute) {
        self.callBarView.muteAudioLabel.stringValue = NSLocalizedString(@"FM_UN_MUTE", @"Unmute");
        [[FrtcCallInterface singletonFrtcCall] audioMute:YES];
        [self showReminderView:NSLocalizedString(@"FM_YOU_YOUSELFMUTE", @"You are muted, please unmute before speaking")];
    } else {
        self.allowUserUnMuteByself = self.inCallModel.isAuthority ? YES : self.isAllowSelfUnmute;
        if(!self.isAllowUserUnMuteByself) {
            if(!self.isAskForUnMuteBySelf) {
                [self showMuteBySelfAlert];
                [self.callBarView.muteAudioButton setState:NSControlStateValueOff];
            } else if(self.isAskForUnMuteBySelf && self.isAskForUnMuteOverOneMinimute) {
                self.askForUnMuteOverOneMinimute = NO;
                [self showMuteBySelfAlert];
                [self.callBarView.muteAudioButton setState:NSControlStateValueOff];
            } else {
                [self alreadyShowMuteBySelfAlert];
                [self.callBarView.muteAudioButton setState:NSControlStateValueOff];
            }
        } else {
            self.callBarView.muteAudioLabel.stringValue = NSLocalizedString(@"FM_MUTE", @"Mute");
            [[FrtcCallInterface singletonFrtcCall] audioMute:NO];
        }
    }
}

- (void)updateOverlayMessageButtonState:(NSControlStateValue)stateVaule {
    [self.callBarView.enableTextButton setState:stateVaule];
    
    if(stateVaule == NSControlStateValueOn) {
        self.callBarView.enableTexttLabel.stringValue = NSLocalizedString(@"FM_UN_MESSAGE", @"Stop Message");
    } else {
        self.callBarView.enableTexttLabel.stringValue = NSLocalizedString(@"FM_MESSAGE_BAR", @"Overlay");
    }
}

- (void)showVideoRecordingWindow:(BOOL)show {
    if(show) {
        if([self.startVideoRecordingWindow isVisible]) {
            return;
        }
        
        self.startVideoRecordingWindow = [[FrtcVideoRecordingWindow alloc] initWithSize:NSMakeSize(380, 180)];
        self.startVideoRecordingWindow.startVideoRecordingDelegate = self;
        
        [self.startVideoRecordingWindow showWindowWithWindow:self.view.window];
    } else {
        if([self.endVideoRecordingWindow isVisible]) {
            return;
        }
        self.endVideoRecordingWindow = [[FrtcVideoRecordingEndWindow alloc] initWithSize:NSMakeSize(380, 180)];
        self.endVideoRecordingWindow.endWindowDelegate = self;
        
        [self.endVideoRecordingWindow showWindowWithWindow:self.view.window];
    }
}

- (void)showVideoStreamingWindow:(BOOL)show {
    if(show) {
        if([self.startVideoStreamingWindow isVisible]) {
            return;
        }
        self.startVideoStreamingWindow = [[FrtcVideoStreamingWindow alloc] initWithSize:NSMakeSize(380, 243)];
        self.startVideoStreamingWindow.startVideoStreamingDelegate = self;
        
        [self.startVideoStreamingWindow showWindowWithWindow:self.view.window];
    } else {
        if([self.endVideoStreamingWindow isVisible]) {
            return;
        }
        self.endVideoStreamingWindow = [[FrtcVideoStreamingEndWindow alloc] initWithSize:NSMakeSize(320, 150)];
        self.endVideoStreamingWindow.endWindowDelegate = self;

        [self.endVideoStreamingWindow showWindowWithWindow:self.view.window];
    }
}

- (void)showVideoStreamUrlWindow {
    if(!self.popover.isShown) {
        FrtcStreamingUrlPopViewController *controller = [[FrtcStreamingUrlPopViewController alloc] init];
        
        //FrtcPopupViewController *controller = [[FrtcPopupViewController alloc] initWithSection:2];
        controller.delegate = self;
        self.popover = [[NSPopover alloc] init];
        self.popover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];
        
        self.popover.contentViewController = controller;
        self.popover.behavior = NSPopoverBehaviorTransient;
        //self.popover.delegate = self;

        [self.popover showRelativeToRect:self.callBarView.inviteStreamingBackGroundView.frame ofView:self.callBarView.superview preferredEdge:NSRectEdgeMaxY];
    }
}

- (void)quickSelectAudioDevice {
    if([self.qucikPopover isShown]) {
        [self.qucikPopover performClose:nil];
    }
    
    FrtcPopupViewController *controller = [[FrtcPopupViewController alloc] initWithSection:2 withMeidaType:0];
    //controller.delegate = self;
    self.qucikPopover = [[FrtcPopover alloc] initWithPopoverType:0];
    self.qucikPopover.delegate = self;
    self.qucikPopover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];
    
    self.qucikPopover.contentViewController = controller;
    self.qucikPopover.behavior = NSPopoverBehaviorTransient;
    //popover.delegate = self;

    [self.qucikPopover showRelativeToRect:self.callBarView.muteAudioBackGroundView.frame ofView:self.callBarView.superview preferredEdge:NSRectEdgeMaxY];

}

- (void)quickSelectVideoDevice {
    if([self.qucikPopover isShown]) {
        [self.qucikPopover performClose:nil];
    }
   FrtcPopupViewController *controller = [[FrtcPopupViewController alloc] initWithSection:2 withMeidaType:1];
    //controller.delegate = self;
    self.qucikPopover    = [[FrtcPopover alloc] initWithPopoverType:1];
    self.qucikPopover.delegate = self;
    self.qucikPopover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];
    
    self.qucikPopover.contentViewController = controller;
    self.qucikPopover.behavior = NSPopoverBehaviorTransient;
    //self.popover.delegate = self;

    [self.qucikPopover showRelativeToRect:self.callBarView.videoMuteBackGroundView.frame ofView:self.callBarView.superview preferredEdge:NSRectEdgeMaxY];
}

#pragma mark- Mute By Server
- (void)muteByServer:(BOOL)mute allowUserUnmute:(BOOL)allowUserUnmute {
    self.allowUserUnMuteByself = self.inCallModel.isAuthority ? YES : allowUserUnmute;
    self.allowSelfUnmute = allowUserUnmute;
    
    if(mute) {
        if(![self.window isVisible]) {
            self.muteByServer = mute;
            //self.allowSelfUnmute = allowUserUnmute;
            return;
        }
        [self.callBarView.muteAudioButton setState:NSControlStateValueOff];
        [self showReminderView:NSLocalizedString(@"FM_YOU_YOUSELFUNMUTE", @"This meeting has been muted by host")];
    } else {
        [self cancelOneMinimuteTimer];
        self.askForUnMuteOverOneMinimute = NO;
        self.askForUnMuteBySelf = NO;
        
        if(![self.window isVisible]) {
            self.muteByServer = mute;
            return;
        }
        
        if(self.callBarView.muteAudioButton.state == NSControlStateValueOn) {
            return;
        }
        
        
        if([self.alertWindow isVisible]) {
            return;
        }
        
        FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_UN_MUTE", @"Unmute") withMessage:NSLocalizedString(@"FM_MUTE_REMINDER", @"Chairperson asks you unmute yourself.") preferredStyle:FrtcWindowAlertStyleDefault withCurrentWindow:self.view.window];
        self.alertWindow = alertWindow;
        
        __weak __typeof(self)weakSelf = self;
        FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_UNMUTE_NOW", @"Unmute") style:FrtcWindowAlertActionStyleOK handler:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.callBarView.muteAudioButton setState:NSControlStateValueOn];
            [[FrtcCallInterface singletonFrtcCall] audioMute:NO];
        }];
        
        [alertWindow addAction:action];
        
        FrtcAlertAction *actionCancel = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_STAY_MUTE", @"Keep Muted") style:FrtcWindowAlertActionStyleCancle handler:^{
        }];
        
        [alertWindow addAction:actionCancel];
    }
}

- (void)handleRequestUnmuteUser:(NSMutableDictionary *)nameDictionary {
    self.requestUnMuteView.hidden = NO;
    self.newRequest = YES;
    self.callBarView.showNewComingView.hidden = NO;
    
    if(self.recordingSuccessfulView.hidden == NO) {
        [self.requestUnMuteView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.view.mas_right).offset(-4);
            make.bottom.mas_equalTo(self.recordingSuccessfulView.mas_top).offset(-4);
            make.width.mas_equalTo(224);
            make.height.mas_equalTo(94);
        }];
    } else {
        if(self.isShareContent) {
            [self.requestUnMuteView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.view.mas_centerX);
                make.centerY.mas_equalTo(self.view.mas_centerY);
                make.width.mas_equalTo(224);
                make.height.mas_equalTo(94);
            }];
        } else {
            [self.requestUnMuteView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.view.mas_right).offset(-4);
                make.bottom.mas_equalTo(self.callBarView.mas_top).offset(-4);
                make.width.mas_equalTo(224);
                make.height.mas_equalTo(94);
            }];
        }
    }
    
    [self.requestDictionary setObject: [nameDictionary allValues][0] forKey:[nameDictionary allKeys][0]];
    [self.requestUnMuteView updateRequestName:[nameDictionary allValues][0]];
    
    if([self.requestListWindow isVisible]) {
        [(FrtcRequestUnMuteListViewController *)self.requestListWindow.contentViewController updateDictionary:self.requestDictionary];
    }
    
    if([self.participantsWindow isVisible]) {
        [(FrtcParticipantsViewController *)(self.participantsWindow.contentViewController) updateRequestCell:[nameDictionary allValues][0] isShow:YES isNewRequest:self.isNewRequest];
    }
}

- (void)handleAllowUnMuteNotify {
    self.askForUnMuteBySelf = NO;
   // self.allowUserUnMuteByself = YES;
    
    if(self.callBarView.muteAudioButton.state == NSControlStateValueOn) {
        return;
    }
    
    FrtcAlertMainWindow *alertWindow = [FrtcAlertMainWindow showAlertWindowWithTitle:NSLocalizedString(@"FM_ALLOW_UN_MUTE_TITLE", @"Reguest approved") withMessage:NSLocalizedString(@"FM_ALLOW_UN_MUTE_DESCRIPTION", @"he host has approved your request to be unmuted.") preferredStyle:FrtcWindowAlertStyleDefault withCurrentWindow:self.view.window];

        __weak __typeof(self)weakSelf = self;
        FrtcAlertAction *action = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_ALLOW_UN_MUTE_RIGHT_BUTTON", @"Keep Mute") style:FrtcWindowAlertActionStyleOK handler:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.callBarView.muteAudioButton setState:NSControlStateValueOn];
            [[FrtcCallInterface singletonFrtcCall] audioMute:NO];
            
        }];
        
        [alertWindow addAction:action];

        FrtcAlertAction *actionCancel = [FrtcAlertAction actionWithTitle:NSLocalizedString(@"FM_ALLOW_UN_MUTE_LEFT_BUTTON", @"Keep Mute") style:FrtcWindowAlertActionStyleCancle handler:^{
        }];
        
        [alertWindow addAction:actionCancel];
}

- (void)isPin:(BOOL)pin {
    if(pin && !self.isPin) {
        [self showReminderView:NSLocalizedString(@"FM_HAVE_ALREADY_PIN", @"Your screen has been fixed by the host")];
    }
    
    if(!pin && self.isPin) {
        [self showReminderView:NSLocalizedString(@"FM_HAVE_ALREADY_UN_PIN", @"Your screen has been unfixed by the host")];
    }
    
    self.pin = pin;
}

- (void)showRosterList {
    [self showNameList];
}

- (void)showSetting {
    [self showSettingWindow];
}

#pragma mark- Rost List Handler
- (void)setupRosterFullList:(NSMutableArray<NSString *> *)rosterListArray {
    if(rosterListArray.count == 0) {
        [self.modelArray enumerateObjectsUsingBlock:^(ParticipantsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(![obj.UUID isEqualToString:self.inCallModel.userIdentifier]) {
                [self.modelArray removeObject:obj];
            }
        }];
    } else {
        for(NSDictionary *dic in rosterListArray) {
            BOOL find = NO;
            ParticipantsModel *tempParticipantModel;
            
            for(ParticipantsModel *participantModel in self.modelArray) {
                tempParticipantModel = participantModel;
                
                if([participantModel.UUID isEqualToString:dic[@"uuid"]]) {
                    find = YES;
                    break;
                }
            }
            
            if(!find) {
                [self.modelArray removeObject:tempParticipantModel];
            }
        }
    }
}

- (void)setupRosterList:(NSMutableArray<NSString *> *)rosterListArray {
    [self.modelArray removeAllObjects];
    
    for(NSString *str in rosterListArray) {
        NSError *err;
        ParticipantsModel *participantModel = [[ParticipantsModel alloc] initWithString:str error:&err];
        
        if([participantModel.UUID isEqualToString:self.inCallModel.userIdentifier]) {
            if([participantModel.name isNotEqualTo:self.currentName]) {
                NSString *str1 = [NSString stringWithFormat:@"\"%@\"",participantModel.name];
                NSString *str = NSLocalizedString(@"FM_CHANGE_TIPS", @"The host modified your name");
                [NSString stringWithFormat:@"%@%@",str,str1];
                [self showReminderView: [NSString stringWithFormat:@"%@%@",str,str1]];
                self.currentName = participantModel.name;
            }
        }
        
        [self.modelArray addObject:participantModel];
    }
    
    if([self.participantsWindow isVisible]) {
        NSArray *copyArray = [self.modelArray copy];
        [(FrtcParticipantsViewController *)(self.participantsWindow.contentViewController) handleRosterEvent:copyArray];
    }
}

- (void)setBarViewHidden:(BOOL)hidden {
    self.callBarView.hidden  = hidden;
    self.titleBarView.hidden = hidden;
    
    self.contentSendFlag = hidden ? CallWindowSendContentFlagSending : CallWindowSendContentFlagNone;
    
    if(self.contentSendFlag == CallWindowSendContentFlagNone) {
        [self getStatics];
    }
}

- (void)updateMediaStatics:(FrtcMediaStaticsModel *)mediaStaticsModel {
    self.mediaStaticModel = mediaStaticsModel;
    [self.staticsView updateStatics:mediaStaticsModel];
}

#pragma mark- --Mouse Event--
- (void)mouseEntered:(NSEvent *)event {
    if(!self.isFullScreen) {
        if(self.contentSendFlag == CallWindowSendContentFlagNone) {
            self.callBarView.hidden  = NO;
            self.titleBarView.hidden = NO;
        }
    }
}

- (void)mouseExited:(NSEvent *)event {
    if(!self.isFullScreen) {
        if(!self.popover.isShown && !self.isPopoverShow) {
            if(self.gridModeView.isHidden) {
                self.callBarView.hidden  = YES;
                self.titleBarView.hidden = YES;
            }
            self.meetingView.hidden = YES;
            self.staticsView.hidden = YES;
            if([self.qucikPopover isShown]) {
                [self.qucikPopover performClose:nil];
            }
        }
    }
}

- (void)mouseDown:(NSEvent *)event {
    self.gridModeView.hidden = YES;
    
    if(self.isFullScreen) {
        if(self.callBarView.hidden == YES) {
            if(self.contentSendFlag == CallWindowSendContentFlagNone) {
                self.callBarView.hidden  = NO;
                self.titleBarView.hidden = NO;
            }
        } else {
            if(!self.popover.isShown) {
                if(self.gridModeView.isHidden) {
                    self.callBarView.hidden  = YES;
                    self.titleBarView.hidden = YES;
                }
                self.meetingView.hidden = YES;
                self.staticsView.hidden = YES;
            }
        }
    }
}

#pragma mark- --lazy load--
- (FrtcCallBarView *)callBarView {
    if(!_callBarView) {
        BOOL audioMute;
        if(self.muteByServer) {
            audioMute = YES;
            [self showReminderView:NSLocalizedString(@"FM_YOU_YOUSELFUNMUTE", @"This meeting has been muted by host")];
        } else {
            audioMute = self.inCallModel.muteMicrophone;
        }
        
        BOOL meetingOwner;
        if([self.inCallModel.ownerID isEqualToString:self.inCallModel.userID]) {
            meetingOwner = YES;
        } else {
            meetingOwner = NO;
        }
        
        _callBarView = [[FrtcCallBarView alloc] initWithAudoStatus:self.inCallModel.audioOnly withAuthority:self.inCallModel.isAuthority withMeetingOwner:meetingOwner];
        [ _callBarView.muteAudioButton setState:self.inCallModel.muteMicrophone ? NSControlStateValueOff :NSControlStateValueOn];
        _callBarView.muteAudioLabel.stringValue = audioMute ? NSLocalizedString(@"FM_UN_MUTE", @"Unmute") : NSLocalizedString(@"FM_MUTE", @"Mute");
        
        [ _callBarView.videoMuteButton setState:self.inCallModel.muteCamera ? NSControlStateValueOff :NSControlStateValueOn];
        _callBarView.videoMuteLabel.stringValue = self.inCallModel.muteCamera ? NSLocalizedString(@"FM_OPEN_VIDEO", @"Start Video") : NSLocalizedString(@"FM_CLOSE_VIDEO", @"Stop Video");
        
        _callBarView.callBarViewDelegate = self;
        [_callBarView setButtonState:audioMute ? NSControlStateValueOff :NSControlStateValueOn];
        [_callBarView setVideoButtonState:self.inCallModel.muteCamera ? NSControlStateValueOff :NSControlStateValueOn];
        
        _callBarView.rosterNumberTextField.stringValue = [NSString stringWithFormat:@"%ld",[FrtcInfoInstance sharedFrtcInfoInstance].rosterNumer];
        
        if(self.isRecording) {
            self.callBarView.videoRecordingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_STOP_RECORDING", @"End Record");
            [self.callBarView.videoRecordingButton setState:NSControlStateValueOn];
        } else {
            self.callBarView.videoRecordingLabel.stringValue = NSLocalizedString(@"FM_VIDEO_RECORDING", @"Record");
            [self.callBarView.videoRecordingButton setState:NSControlStateValueOff];
        }
        if([_callBarView.rosterNumberTextField.stringValue isEqualToString:@"1"]) {
            _callBarView.localMuteButton.enabled = NO;
            _callBarView.localMuteLabel.textColor = [NSColor colorWithString:@"#666666" andAlpha:0.3];
        }
        [self.view addSubview:_callBarView];
        
    }
    
    return _callBarView;
}

- (NSView *)view {
    if(!_view) {
        _view = self.window.contentViewController.view;
    }
    
    return _view;
}

- (FrtcTitleBarView *)titleBarView {
    if(!_titleBarView) {
        _titleBarView = [[FrtcTitleBarView alloc] init];
        _titleBarView.titleBarViewDelegate = self;
        self.isGridLayoutMode ? _titleBarView.gridModeButton.title.stringValue = NSLocalizedString(@"FM_GALLERT_MODE", @"Gallery View") : _titleBarView.gridModeButton.title.stringValue = NSLocalizedString(@"FM_PRESENTER_MODE", @"Presenter View");
        [_titleBarView updateGridModeButtonLayout:_titleBarView.gridModeButton.title.stringValue];
        [self.view addSubview:_titleBarView];
    }
    
    return _titleBarView;
}


- (FrtcMeetingInfoView *)meetingView {
    if(!_meetingView) {
        _meetingView= [[FrtcMeetingInfoView alloc] initWithFrame:NSMakeRect(0, 0, 240, 144)];
        _meetingView.meetingInfoDelegate = self;
        [self.window.contentViewController.view addSubview:_meetingView];
        _meetingView.hidden = YES;
        _meetingView.titleTextField.stringValue             = self.inCallModel.conferenceName;
        _meetingView.meetingNumberTextField.stringValue     = self.inCallModel.conferenceNumber;
        _meetingView.meetingPasswordTextField.stringValue   = self.inCallModel.conferencePassword;
        _meetingView.meetingOwnerTextField.stringValue      = self.inCallModel.ownerName;
    }
    
    return _meetingView;
}

- (FrtcMediaStaticsView *)staticsView {
    if(!_staticsView) {
        _staticsView = [[FrtcMediaStaticsView alloc] initWithFrame:NSMakeRect(0, 0, 260, 197)];
        _staticsView.mediaStaticsDelegate = self;
        [self.window.contentViewController.view addSubview:_staticsView];
        _staticsView.hidden = YES;
    }
    
    return _staticsView;
}

- (FrtcGridModeView *)gridModeView {
    if(!_gridModeView) {
        _gridModeView = [[FrtcGridModeView alloc] initWithFrame:NSMakeRect(0, 0, 256, 168)];
        _gridModeView.gridModeDelegate = self;
        [self.window.contentViewController.view addSubview:_gridModeView];
        _gridModeView.hidden = YES;
    }
    
    return _gridModeView;
}

- (FrtcMaskView *)maskView {
    if (!_maskView) {
        _maskView = [[FrtcMaskView alloc] initWithFrame:NSMakeRect(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _maskView.wantsLayer = YES;
        _maskView.layer.backgroundColor = [NSColor blackColor].CGColor;
    }
    return _maskView;
}

- (CallResultReminderView *)reminderView {
    if(!_reminderView) {
        _reminderView = [[CallResultReminderView alloc] initWithFrame:CGRectMake(0, 0, 172, 40)];
        _reminderView.tipLabel.stringValue = @"主持人已开启静音";
        _reminderView.hidden = YES;
        
        [self.view addSubview:_reminderView];
    }
    
    return _reminderView;
}

- (NSProgressIndicator *)reConnectProgress {
    if (!_reConnectProgress) {
        _reConnectProgress = [[NSProgressIndicator alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 32, 32)];
        _reConnectProgress.style = NSProgressIndicatorStyleSpinning;
        CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
        [lighten setDefaults];
        [lighten setValue:@1 forKey:@"inputBrightness"];
        [_reConnectProgress setContentFilters:[NSArray arrayWithObjects:lighten, nil]];
        [self.view addSubview:_reConnectProgress];
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
        _tipsTextField.stringValue = NSLocalizedString(@"FM_NETWORK_EXCEPTION", @"FR Network Exception");
        _tipsTextField.hidden = YES;
        [self.view addSubview:_tipsTextField];
    }
    
    return _tipsTextField;
}

- (FrtcVideoRecordingTipsView *)tipsHostView {
    if(!_tipsHostView) {
        _tipsHostView = [[FrtcVideoRecordingTipsView alloc] initWithFrame:NSMakeRect(0, 0, 122, 28)];
        _tipsHostView.hidden = YES;
        _tipsHostView.viewsType = TipsRecording;
        _tipsHostView.tipsViewDelegate = self;
        [self.view addSubview:_tipsHostView];
    }
    
    return _tipsHostView;
}

- (FrtcVideoRecordingTipsView *)tipsStreamingView {
    if(!_tipsStreamingView) {
        _tipsStreamingView = [[FrtcVideoRecordingTipsView alloc] initWithFrame:NSMakeRect(0, 0, 106, 28)];
        _tipsStreamingView.hidden = YES;
        _tipsStreamingView.viewsType = TipsStreaming;
        _tipsStreamingView.title.stringValue = NSLocalizedString(@"FM_VIDEO_STREAMING_TO_HOST", @"Living");
        [_tipsStreamingView.imageView setImage:[NSImage imageNamed:@"icon_streaming_tips"]];
        _tipsStreamingView.tipsViewDelegate = self;
        [self.view addSubview:_tipsStreamingView];
    }
    
    return _tipsStreamingView;
}

- (FrtcVideoRecordingTips *)tipsView {
    if(!_tipsView) {
        _tipsView = [[FrtcVideoRecordingTips alloc] initWithFrame:NSMakeRect(0, 0, 56, 21)];
        _tipsView.title.stringValue = NSLocalizedString(@"FM_VIDEO_RECORDING_EDNED", @"End Recording");
        _tipsView.hidden = YES;
        [self.view addSubview:_tipsView];
    }
    
    return _tipsView;
}

- (FrtcVideoRecordingTips *)tipsViewForStreaming {
    if(!_tipsViewForStreaming) {
        _tipsViewForStreaming = [[FrtcVideoRecordingTips alloc] initWithFrame:NSMakeRect(0, 0, 56, 21)];
        _tipsViewForStreaming.hidden = YES;
        _tipsViewForStreaming.title.stringValue = NSLocalizedString(@"FM_VIDEO_STREAMING_EDNED", @"End Living");
        [self.view addSubview:_tipsViewForStreaming];
    }
    
    return _tipsViewForStreaming;
}

- (FrtcVideoRecordingReminderView *)recordingTipsView {
    if(!_recordingTipsView) {
        _recordingTipsView = [[FrtcVideoRecordingReminderView alloc] initWithFrame:NSMakeRect(0, 0, 106, 28)];
        _recordingTipsView.title.stringValue = NSLocalizedString(@"FM_VIDEO_RECORDING_TO_USER", @"Recording");
        _recordingTipsView.hidden = YES;
        [self.view addSubview:_recordingTipsView];
    }
    
    return _recordingTipsView;
}

- (FrtcVideoRecordingReminderView *)streamingTipsView {
    if(!_streamingTipsView) {
        _streamingTipsView = [[FrtcVideoRecordingReminderView alloc] initWithFrame:NSMakeRect(0, 0, 106, 28)];
        _streamingTipsView.title.stringValue = NSLocalizedString(@"FM_VIDEO_STREAMING_TO_USER", @"Living");
        [_streamingTipsView.imageView setImage:[NSImage imageNamed:@"icon_streaming_tips"]];
        _streamingTipsView.hidden = YES;
        [self.view addSubview:_streamingTipsView];
    }
    
    return _streamingTipsView;
}

- (FrtcVideoRecordingSuccessView *)recordingSuccessfulView {
    if(!_recordingSuccessfulView) {
        _recordingSuccessfulView = [[FrtcVideoRecordingSuccessView alloc] initWithFrame:NSMakeRect(0, 0, 244, 170)];
        _recordingSuccessfulView.hidden = YES;
        _recordingSuccessfulView.closeDelegate = self;
        [self.view addSubview:_recordingSuccessfulView];
    }
    
    return _recordingSuccessfulView;
}

- (FrtcRequestUnMuteView *)requestUnMuteView {
    if(!_requestUnMuteView) {
        _requestUnMuteView = [[FrtcRequestUnMuteView alloc] initWithFrame:NSMakeRect(0, 0, 224, 94)];
        _requestUnMuteView.hidden = YES;
        _requestUnMuteView.requestUnMuteDelegate = self;
        [self.view addSubview:_requestUnMuteView];
    }
    
    return _requestUnMuteView;
}

- (MeetingInformationView *)overlayView {
    if(!_overlayView) {
        CGFloat width = self.window.contentViewController.view.frame.size.width;
        _overlayView = [[MeetingInformationView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
        _overlayView.delegate = self;
        _overlayView.hidden = YES;
        [self.view addSubview:_overlayView];
    }
    
    return _overlayView;
}

@end
