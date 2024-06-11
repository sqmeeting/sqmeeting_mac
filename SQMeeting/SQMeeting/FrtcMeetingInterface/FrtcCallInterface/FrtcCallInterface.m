#import "FrtcCallInterface.h"
#import "Masonry.h"
#import "AppDelegate.h"
#import "FrtcUserDefault.h"
#import "FrtcBaseImplement.h"
#import "FrtcVerticalCenterTextFieldCell.h"
#import "MeetingMessageModel.h"
#import "FrtcTipsView.h"
#import "FrtcContentViewController.h"
#import "FrtcContentWindowController.h"
#import "ShareToolBarAdaptor.h"
#import "FrtcScreenBorderWindow.h"
#import "ParticipantsModel.h"
#import "AppListModel.h"
#import "MeetingDetailModel.h"
#import "FrtcPersistence.h"
#import "FrtcCallWindowController.h"
#import "FrtcMediaStaticsModel.h"
#import "FrtcMediaStaticsInstance.h"
#import "FrtcLocalReminderManagement.h"

typedef void (^JoinMeetingSuccessfulCallBack)();
typedef void (^JoinMeetingFailureCallBack)(FRTCMeetingStatusReason reason);
typedef void (^RequestPasswordCallBack)(BOOL requestError);

static FrtcCallInterface *singletonFrtcCall = nil;

@interface FrtcCallInterface()<FrtcCallWindowControllerDelegate, contentControlToolBarResponderDelegate, FrtcCallDelegate>

@property (nonatomic, strong) FrtcTipsView                      *tipsView;

@property (nonatomic, strong) MeetingDetailModel                *detailMeetingInfoModel;

@property (nonatomic, strong) ShareToolBarAdaptor            *contentControlToolBarResponder;
@property (nonatomic, strong) FrtcScreenBorderWindow         *sharingFrameWindow;

@property (strong, nonatomic) NSTimer               *tipsTimer;
@property (strong, nonatomic) NSTimer               *reConnectMeetingTimer;

@property (nonatomic, assign, getter=isSendingContent)                BOOL sendingContent;
@property (nonatomic, assign, getter=isFullScreen)                    BOOL fullScreen;
@property (nonatomic, assign, getter=isMuteMic)                       BOOL muteMic;
@property (nonatomic, assign, getter=isMuteCam)                       BOOL muteCam;
@property (nonatomic, assign, getter=isGallery)                       BOOL gallery;
@property (nonatomic, assign, getter=isAcceptedShared)                BOOL acceptedShared;
@property (nonatomic, assign, getter=shareContentType)                FRTCShareContentType shareContentType;
@property (nonatomic, assign, getter=sharingDesktopID)                int sharingDesktopID;

@property (nonatomic, assign, getter=isActuallyCallWindowDisplay)     BOOL actuallyCallWindowDisplay;
@property (nonatomic, assign, getter=isReConnect)                     BOOL reConnect;

@property (nonatomic, assign, getter=isConnecting)                    BOOL connecting;

@property (nonatomic, copy) NSString *joinMeetingName;
@property (nonatomic, copy) NSString *meetingName;
@property (nonatomic, copy) NSString *meetingNumber;

@property (nonatomic, copy) NSString *meetingPassword;
@property (nonatomic, copy) NSString *meetingPasswordForReconnect;

@property (nonatomic) FRTCMeetingStatus callMeetingStatus;
@property (nonatomic) NSInteger reConnectCount;

@property (nonatomic, strong)   NSMutableArray<NSString *> *participantsList;
@property (nonatomic, copy)     NSDictionary *params;

@property (nonatomic, strong) FrtcCallWindowController *windowController;

@property (nonatomic, assign, getter=isSharedWithAudio) BOOL sharedWithAudio;
@property (nonatomic, assign, getter=isClosedByUser) BOOL closedByUser;

@property (nonatomic, copy) JoinMeetingSuccessfulCallBack successfulCallBack;
@property (nonatomic, copy) JoinMeetingFailureCallBack failureCallBack;
@property (nonatomic, copy) RequestPasswordCallBack requestPasswordCallBack;

@property (nonatomic, assign) BOOL wantToSwitchGridModeWhenReceivingContent;


@property (nonatomic, copy) NSString *overlayMessage;

@end




@implementation FrtcCallInterface

+ (FrtcCallInterface *)singletonFrtcCall{
    if (singletonFrtcCall == nil) {
        @synchronized(self) {
            if (singletonFrtcCall == nil) {
                singletonFrtcCall = [[FrtcCallInterface alloc] init];
            }
        }
    }
    
    return singletonFrtcCall;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configNotification];
        
        _participantsList = [NSMutableArray array];
        
        _callMeetingStatus = MEETING_STATUS_IDLE;
        
        _contentControlToolBarResponder = [[ShareToolBarAdaptor alloc] init];
        _contentControlToolBarResponder.closedDelegate = self;
        _sharingFrameWindow = [[FrtcScreenBorderWindow alloc] init];
        
        _sharedWithAudio = NO;
        _sendingContent = NO;
        
        _shareContentType = FRTCSDK_SHARE_CONTENT_IDLE;
       
        self.connecting = NO;
        [FrtcCall sharedFrtcCall].callDelegate = self;
        
        [self setupConfiguration];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark --FrtcCallDelegate--
- (void)audioLevelMeter:(float)meter {
    NSDictionary *userInfo = @{FrtcMeetingAudioMeteKey :[NSNumber numberWithFloat:meter]};
    [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FrtcMeetingAudioMeterNotification object:nil userInfo:userInfo];
}

- (void)onMeetingMessage:(NSString *)message {
    if(self.windowController.contentViewController == nil) {
            self.overlayMessage = message;
            
            return;
    }
    
    [self.windowController handleMeetingOverlayMessage:message];
}

- (void)onParticipantsList:(NSMutableArray<NSString *> *)participantsList {
    self.participantsList = participantsList;
    [self.windowController setupRosterList:self.participantsList];
    [[FrtcInfoInstance sharedFrtcInfoInstance] setupRosterList:self.participantsList];
}

- (void)onParticipantsNumber:(NSInteger)participantsNumber {
    [[FrtcInfoInstance sharedFrtcInfoInstance] updateRosterNumber:participantsNumber];
}

- (void)onLectureList:(NSMutableArray<NSString *> *)lectureListArray {
    [self.windowController setLectureArrayList:lectureListArray];
    [[FrtcInfoInstance sharedFrtcInfoInstance] setupLectureList:lectureListArray];
}

- (void)onRecordStatus:(NSString *)recordingStatus liveStatus:(NSString *)liveStatus liveMeetingUrl:(NSString *)liveMeetingUrl liveMeetingPassword:(NSString *)liveMeetingPassword {
    NSDictionary *dic = @{@"recordingStatus":recordingStatus,
                               @"liveStatus":liveStatus,
                           @"liveMeetingUrl":liveMeetingUrl,
                      @"liveMeetingPassword":liveMeetingPassword
    };
    
    self.params = dic;
    
    [self.windowController recordingStatus:dic isShareContent:self.isSendingContent];
    
    if(self.isSendingContent) {
        [self.contentControlToolBarResponder recordingStatus:dic];
    }
    
    self.contentControlToolBarResponder.params = dic;
    [self.contentControlToolBarResponder updateRecordingUI:self.params withHeight:0];
}

- (void)onPinStatus:(BOOL)pinStatus {
    [self.windowController isPin:pinStatus];
}

- (void)onMute:(BOOL)mute allowSelfUnmute:(BOOL)allowSelfUnmute {
    [self.windowController muteByServer:mute allowUserUnmute:allowSelfUnmute] ;
    if(mute) {
        [self audioMute:YES];
    }
}

- (void)onReceiveUnmuteRequest:(NSMutableDictionary *)requestUnmuteDictionary {
    [self.windowController handleRequestUnmuteUser:requestUnmuteDictionary];
    
    if(self.isSendingContent) {
        [self.contentControlToolBarResponder handleRequestUnmuteUser:requestUnmuteDictionary];
    }
}

- (void)onReceiveAllowUnmute {
    [self.windowController handleAllowUnMuteNotify];
}

- (void)onContentPriorityChangeStatus:(NSString *)status {
    if ([status isEqualToString:@"Rejected"]) {
        self.tipsView.descriptionLabel.stringValue = NSLocalizedString(@"FM_SHARE_CONTENT_LIMITED", @"You have no permission to share content.");
        if (self.tipsView.isHidden  || self.tipsView.animator.alphaValue == 0) {
            [self runTipsTimer:5.0];
            [self addSubViewWithAnimation:self.tipsView];
        }
        else {
            [self cancelTipsTimer];
            [self runTipsTimer:5.0];
            [self addSubViewWithAnimation:self.tipsView];
        }
    }
}

- (void)onContentState:(NSInteger)state {
    NSInteger sharingContent = state;
    
    //1.sharingContent is 1(YES), wants to share, and current is sharing, so return.
    if (1 == sharingContent && self.isSendingContent) {
        return;
    }
    
    //0.sharingContent is 0(NO), wants to stop share, and current is not sharing, so return.
    if (0 == sharingContent && !self.isSendingContent) {
        return;
    }
    
    //2.sharingContent is 2, wants to receive content.
    if(2 == sharingContent) {
        self.acceptedShared = YES;
        self.windowController.receivingContent = YES;
        return;
    } else if(3 == sharingContent) {
        //3.sharingContent is 3, wants to stop receive content.
        self.acceptedShared = NO;
        self.windowController.receivingContent = NO;
    
        return;
    }
    
    if (1 == sharingContent) {
        //1.sharingContent is 1, wants to share, then start share.

        [self.windowController resetOverlayForContentType:1];
        self.sendingContent = YES;

        [self.contentControlToolBarResponder onMeetingStatusChangedFrom:MEETING_STAT_CONNECTED to:MEETING_STAT_PLAYING];
        
        if (FRTCSDK_SHARE_CONTENT_DESKTOP == self.shareContentType || FRTCSDK_SHARE_CONTENT_APPLICATION == self.shareContentType) {
            if(FRTCSDK_SHARE_CONTENT_APPLICATION == self.shareContentType) {
                [self.sharingFrameWindow updateBackGroundView:1];
            } else {
                [self.sharingFrameWindow updateBackGroundView:0];
            }
        }
        [self.sharingFrameWindow displayBorderWindow:YES];
        
        [self.windowController setBarViewHidden:YES];
        [self.windowController updateRecordingAndStreamingUILocation:YES];
        self.contentControlToolBarResponder.params = self.params;
        [self.contentControlToolBarResponder updateRecordingUI:self.params withHeight:0];
        [self.contentControlToolBarResponder showRecordingSuccess:YES];
        self.windowController.window.level = NSFloatingWindowLevel;
    } else {
        //2.sharingContent is not 1, wants to stop share, then stop share.
      
        if (self.isSendingContent) {
            self.sendingContent = NO;
            [self shareContent:NO];
        }
        
        self.sharedWithAudio = NO;
        _shareContentType = FRTCSDK_SHARE_CONTENT_IDLE;
        self.sendingContent = NO;
        
       
        [self.windowController setBarViewHidden:NO];
        [self.contentControlToolBarResponder onMeetingStatusChangedFrom:MEETING_STAT_PLAYING to:MEETING_STAT_CONNECTED];
        [self.sharingFrameWindow displayBorderWindow:NO];
        [self.windowController updateRecordingAndStreamingUILocation:NO];
        [self.contentControlToolBarResponder showRecordingSuccess:NO];
        self.windowController.window.level = NSNormalWindowLevel;
    }
}

- (void)onMutedDetected {
    self.tipsView.descriptionLabel.stringValue = NSLocalizedString(@"FM_AUDIO_MUTE_REMINDER", @"Your are muted.");
    if (self.tipsView.isHidden  || self.tipsView.animator.alphaValue == 0) {
        [self runTipsTimer:5.0];
        [self addSubViewWithAnimation:self.tipsView];
    } else {
        [self cancelTipsTimer];
        [self runTipsTimer:5.0];
        [self addSubViewWithAnimation:self.tipsView];
    }
}

- (void)onMenuShelterShow:(BOOL)isShelterByMenu {
    [self.windowController reMasTitleBarLayout:isShelterByMenu];
}

- (void)onCloseWindow {
    [self.windowController closeWinowByCloseButton];
}

- (void)onScreenChange:(NSScreen *)screen withScreenSize:(NSSize)newSize {
    [self.windowController onWindowSizeChanged:newSize];
    
   
    if (self.isSendingContent) {
       [self.contentControlToolBarResponder onMeetingStatusChangedFrom:MEETING_STAT_PLAYING to:MEETING_STAT_CONNECTED];
        [self.contentControlToolBarResponder onMeetingStatusChangedFrom:MEETING_STAT_CONNECTED to:MEETING_STAT_PLAYING];
        
        if (FRTCSDK_SHARE_CONTENT_DESKTOP == self.shareContentType) {
            [self.sharingFrameWindow displayBorderWindow:YES];
        }
    }
}

- (void)onInCallWindowInitializedState:(NSInteger)initializedState {
    NSInteger initialized = initializedState;
    AppDelegate * appDelegate = (AppDelegate*)[NSApplication sharedApplication].delegate;
    
    if (1 == initialized) {
        if(appDelegate) {
            [appDelegate meetingStatus:YES];
        }
    } else {
        if(appDelegate) {
            self.callMeetingStatus = MEETING_STATUS_DISCONNECTED;
            [self.tipsView setHidden:YES];
            [appDelegate meetingStatus:NO];
        }
    }
}

- (void)onFullScreenState:(NSInteger)state {
    if(state == 1) {
        self.fullScreen = YES;
        
    } else {
        self.fullScreen = NO;
    }
    
    [self.windowController fullScreenState:state];
}

#pragma mark --init function--
- (void)setupConfiguration {
    self.sendingContent       = NO;
    self.reConnect              = NO;
    self.tipsView.alphaValue    = 0;
    [self.tipsView setHidden:YES];
}

- (void)rePopupApp {
    [self.windowController.window makeKeyAndOrderFront:self];
}

#pragma mark- --FrtcCallWindowControllerDelegate
- (void)closedByUserCallWindow:(BOOL)close {
    self.contentControlToolBarResponder.colsedByUser = close;
}

- (void)showRecordingAndStreamingTips:(NSString *)tips {
    [self.sharingFrameWindow showReminderView:tips];
}

- (void)initializedState:(NSInteger)state {
    [self onInCallWindowInitializedState:state];
}

- (void)sendContentWithDesktopID:(uint32_t)selectID withAppWinswoID:(unsigned int)appWindowID withContentType:(NSInteger)type withAppName:(NSString *)name withConentAudio:(BOOL)isSendContentAudio {
    self.sharedWithAudio = isSendContentAudio;
    
    [self.contentControlToolBarResponder setScreenID:selectID];
    [self.sharingFrameWindow setScreenID:selectID];
    
    if(type == 0) {
        _shareContentType = FRTCSDK_SHARE_CONTENT_DESKTOP;
    } else {
        _shareContentType = FRTCSDK_SHARE_CONTENT_APPLICATION;
    }
    
    [[FrtcCall sharedFrtcCall] frtcShareContent:YES
                                  withContentType:_shareContentType
                                    withDesktopID:selectID
                                     withWindowID:appWindowID
                               withAppContentName:name
                                 withContentAudio:self.isSharedWithAudio];
}

#pragma mark --contentControlToolBarResponderDelegate
- (void)closedByUser:(BOOL)closed {
    self.windowController.closedByUser = closed;
}

- (void)showRosterList {
    [self.windowController showRosterList];
}

- (void)showSetting {
    [self.windowController showSetting];
}


- (void)videoMute:(BOOL)mute{
    self.muteCam = mute;
    if([FrtcInfoInstance sharedFrtcInfoInstance].inCallModel) {
        [FrtcInfoInstance sharedFrtcInfoInstance].inCallModel.muteCamera = mute;
        [[FrtcInfoInstance sharedFrtcInfoInstance] updateInCallModelStatus];
    }
    [[FrtcCall sharedFrtcCall] frtcMuteLocalVideo:mute];
}

- (void)audioMute:(BOOL)mute {
    self.muteMic = mute;
    if([FrtcInfoInstance sharedFrtcInfoInstance].inCallModel) {
        [FrtcInfoInstance sharedFrtcInfoInstance].inCallModel.muteMicrophone = mute;
        [[FrtcInfoInstance sharedFrtcInfoInstance] updateInCallModelStatus];
    }
    
    [[FrtcCall sharedFrtcCall] frtcMuteLocalAudio:mute];
    
    if (!mute) {
        [self cancelTipsTimer];
        [self removeFromSuperViewWithAnimation:self.tipsView];
    }
}

- (void)shareContent:(BOOL)isShareContent {
    if (!isShareContent) {
        [[FrtcCall sharedFrtcCall] frtcShareContent:isShareContent
                                      withContentType:_shareContentType
                                        withDesktopID:0
                                         withWindowID:0
                                   withAppContentName:@""
                                     withContentAudio:NO];
        
        _sharedWithAudio = NO;

        _shareContentType = FRTCSDK_SHARE_CONTENT_IDLE;
        return;
    }
}


- (void)endMeeting {
    [self stopSharingContent];
    self.acceptedShared     = NO;
    [self cancelReConnectTimer];
    [[FrtcCall sharedFrtcCall] frtcEndMeeting];
    
    if(self.isReConnect) {
        [self onInCallWindowInitializedState:0];
        self.reConnect = NO;
    }
}

- (void)stopReConnect {
    if(self.isReConnect) {
        [self.windowController close];
        [self onInCallWindowInitializedState:0];
        self.reConnect = NO;
    }
    [self cancelReConnectTimer];
}

- (void)switchGridMode:(BOOL)galleryMode {
    if (self.isAcceptedShared) {
        [self wantToSwitchGridModeWhenReceivingContent:galleryMode];
        return;
    }
    
    [[FrtcCall sharedFrtcCall] frtcSetGridLayoutMode:galleryMode];
    if (galleryMode) {
        [[FrtcUserDefault defaultSingleton] setObject:@"gallery" forKey:DEFAULT_LAYOUT];
    } else {
        [[FrtcUserDefault defaultSingleton] setObject:@"presenter" forKey:DEFAULT_LAYOUT];
    }
    
    self.gallery = galleryMode;
    
    //[Note]: only change the button title of GrideBackGroundView.
    [self.windowController updataButtonNameWithSettingComboxUserSelectGridMode:galleryMode];
}

- (void)wantToSwitchGridModeWhenReceivingContent:(BOOL)galleryMode {
    self.wantToSwitchGridModeWhenReceivingContent = galleryMode;
}

- (void)switchGridModeAsUserSelectGridModeWhenReceivingContent {
    NSString *layouMode     = [[FrtcUserDefault defaultSingleton] objectForKey:DEFAULT_LAYOUT];
    
    if ([layouMode isEqualToString:@"gallery"] && (YES == self.wantToSwitchGridModeWhenReceivingContent)) {
        //self.gallery = YES;
        return;
    } else if ([layouMode isEqualToString:@"presenter"] && (NO == self.wantToSwitchGridModeWhenReceivingContent)) {
        //self.gallery = NO;
        return;
    } else {
        [self switchGridMode:self.wantToSwitchGridModeWhenReceivingContent];
    }
}

- (void)removeFromSuperViewWithAnimation:(NSView *)view {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.5;
        view.animator.alphaValue = 0;
    }
    completionHandler:^{
        //view.hidden = YES;
    }];
}

- (void)addSubViewWithAnimation:(NSView *)view {
    view.animator.alphaValue = 0;
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.5;
        view.animator.alphaValue = 1;
    }
    completionHandler:^{
    }];
}

- (void)runTipsTimer:(NSTimeInterval)timeInterval {
    self.tipsTimer = [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(tipsTimerEvent) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.tipsTimer forMode:NSRunLoopCommonModes];
}

- (void)cancelTipsTimer {
    if(_tipsTimer != nil) {
        [_tipsTimer invalidate];
        _tipsTimer = nil;
    }
}

- (void)tipsTimerEvent {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeFromSuperViewWithAnimation:self.tipsView];
    });
}

- (void)cancelReConnectTimer {
    if(self.reConnectMeetingTimer != nil) {
        [self.reConnectMeetingTimer invalidate];
        self.reConnectMeetingTimer = nil;
    }
}

- (NSString *)dateTimeFromUtcTimeString:(NSTimeInterval )time1 withTimeForMatter:(NSString *)timeFormatter {
    NSTimeInterval time = time1 / 1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:timeFormatter];
    NSString *TimeDateString = [dateFormatter stringFromDate: detailDate];
    
    return TimeDateString;
}

- (void)makeCallWithParam:(FRTCMeetingParameters)param withAuthority:(BOOL)authority {
    __block int inputPasswordTimes = 0;
    __weak __typeof(self)weakSelf = self;
    
    [[FrtcCall sharedFrtcCall] frtcMakeCall:param
                                   controller:self.windowController
                            completionHandler:^(FRTCMeetingStatus callMeetingStatus,
                                                FRTCMeetingStatusReason reason,
                                                FRTCMeetingStatusReasonParam callReaultParam
                                                ) 
     {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.callMeetingStatus  = callMeetingStatus;
        strongSelf.connecting = NO;
    
        if (callMeetingStatus == MEETING_STATUS_CONNECTE) {
            [[FrtcMediaStaticsInstance sharedFrtcMediaStaticsInstance] startGetMediaStatics];
            
            strongSelf.detailMeetingInfoModel.meetingNumber    = param.meeting_alias;
            strongSelf.detailMeetingInfoModel.meetingName      = callReaultParam.conferenceName;
            strongSelf.detailMeetingInfoModel.meetingStartTime = [[FrtcBaseImplement baseImpleSingleton] currentTimeString];
            strongSelf.detailMeetingInfoModel.meetingPassword  = param.meeting_password;
            strongSelf.detailMeetingInfoModel.meetingNumber    = callReaultParam.conferenceAlias;
            strongSelf.detailMeetingInfoModel.ownerName        = callReaultParam.ownerName;
            
            strongSelf.meetingNumber       = param.meeting_alias;
            strongSelf.meetingName         = callReaultParam.conferenceName;
            strongSelf.joinMeetingName     = param.display_name;
            
            FrtcInCallModel *model = [[FrtcInCallModel alloc] init];
            
            model.ownerID               = callReaultParam.ownerID;
            model.meetingUrl            = callReaultParam.meetingUrl;
            model.groupMeetingUrl       = callReaultParam.groupMeetingUrl;
            model.scheduleStartTime     = [self dateTimeFromUtcTimeString:callReaultParam.scheduleStartTime withTimeForMatter:@"yyyy-MM-dd HH:mm"];
            model.scheduleEndTime       = [self dateTimeFromUtcTimeString:callReaultParam.scheduleEndTime withTimeForMatter:@"yyyy-MM-dd HH:mm"];
            model.ownerName             = callReaultParam.ownerName ? callReaultParam.ownerName : @"";
            model.conferenceName        = callReaultParam.conferenceName;
            model.conferenceNumber      = callReaultParam.conferenceAlias;
            model.muteCamera            = param.video_mute;
            model.muteMicrophone        = param.audio_mute;
            model.clientName            = param.display_name;
            model.userID                = param.user_id;
            model.userToken             = param.user_token ? param.user_token : @"";
            model.conferencePassword    = param.meeting_password ? param.meeting_password : (strongSelf.meetingPassword ? strongSelf.meetingPassword : @"");
            model.conferenceStartTime   = strongSelf.detailMeetingInfoModel.meetingStartTime;
            model.authority             = callReaultParam.isLoginCall ? authority : NO;
            model.audioOnly             = param.audio_only;
            model.loginCall             = callReaultParam.isLoginCall;
            model.userIdentifier        = [[FrtcCall sharedFrtcCall] frtcGetClientUUID];
            strongSelf.detailMeetingInfoModel.meetingPassword = param.meeting_password ? param.meeting_password : (strongSelf.meetingPassword ? strongSelf.meetingPassword : @"");
            
            [FrtcInfoInstance sharedFrtcInfoInstance].inCallModel = model;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.windowController.inCallModel = model;
                strongSelf.windowController.currentName = model.clientName;
                
                [strongSelf.windowController resetOverLay];
                [strongSelf.contentControlToolBarResponder updatecontentControlToolBarInCallModel:model];
                
                if(strongSelf.overlayMessage != nil) {
                    [strongSelf.windowController handleMeetingOverlayMessage:strongSelf.overlayMessage];
                    strongSelf.overlayMessage = nil;
                }
                
                if ([strongSelf isEnglish]) {
                    strongSelf.windowController.window.title = @"SQ Meeting CE ";
                } else {
                    strongSelf.windowController.window.title = @"神旗CE";
                }
                if(!strongSelf.isReConnect) {
                    [strongSelf.windowController setupWindowLayout];
                }
                strongSelf.actuallyCallWindowDisplay = YES;
                strongSelf.inConference = YES;
                [[FrtcInfoInstance sharedFrtcInfoInstance] startTimer];
                
                if(strongSelf.isReConnect) {
                    [strongSelf.windowController stopReConnectUI:self.reConnectCount];
                    strongSelf.reConnectCount = 0;
                    strongSelf.reConnect = NO;
                    [strongSelf cancelReConnectTimer];
                    [strongSelf stopSharingContent];
                    [strongSelf audioMute:strongSelf.isMuteMic];
                    [strongSelf videoMute:param.video_mute];
                }
                strongSelf.successfulCallBack();
            });
        } else {
            strongSelf.actuallyCallWindowDisplay = NO;
            strongSelf.inConference = NO;
            [[FrtcMediaStaticsInstance sharedFrtcMediaStaticsInstance] stopGetMediaStatics];
            [[FrtcInfoInstance sharedFrtcInfoInstance] stopTimer];
            
            if (callMeetingStatus == MEETING_STATUS_DISCONNECTED) {
                [strongSelf.contentControlToolBarResponder onMeetingStatusChangedFrom:MEETING_STAT_PLAYING to:MEETING_STAT_IDLE];
                [strongSelf.sharingFrameWindow displayBorderWindow:NO];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.windowController closeAllWindows];
                [[NSNotificationCenter defaultCenter] postNotificationName:FMeetingCallCloseNotification object:nil userInfo:nil];
                
                if (reason != MEETING_STATUS_EXIT_EXCEPTION && !strongSelf.isReConnect) {
                    strongSelf.windowController = nil;
                }
            });
            
            if (reason == MEETING_STATUS_END_ABNORMAL || strongSelf.isReConnect) {
                FRTCMeetingParameters callParam = param;
                callParam.meeting_password  = strongSelf.meetingPasswordForReconnect;
                callParam.video_mute        = strongSelf.isMuteCam;
                callParam.audio_mute        = strongSelf.isMuteMic;
                callParam.display_name      = strongSelf.windowController.currentName;
                
                if (strongSelf.reConnectCount == 5) {
                    [strongSelf.windowController stopReConnectCall];
                    strongSelf.reConnect = NO;
                    strongSelf.reConnectCount = 0;
                    return;
                }
                
                if (strongSelf.reConnectCount >= 3) {
                    [strongSelf cancelReConnectTimer];
                    [strongSelf.windowController reConnectCallByToastWindowWithReCallBlock:^{
                        strongSelf.reConnectCount++;
                        [strongSelf makeCallWithParam:callParam withAuthority:authority];
                    }];
                    
                    return;
                }
                
                if (!strongSelf.isReConnect) {
                    [strongSelf.windowController reConnectCall];
                }
                
                strongSelf.reConnect = YES;
         
                self.reConnectMeetingTimer = [NSTimer scheduledTimerWithTimeInterval:15.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
                    strongSelf.reConnectCount++;
                    [strongSelf makeCallWithParam:callParam withAuthority:authority];
                }];
                
                return;
            }
            
            strongSelf.detailMeetingInfoModel.meetingEndTime = [[FrtcBaseImplement baseImpleSingleton] currentTimeString];
            
            if (strongSelf.detailMeetingInfoModel.meetingStartTime != nil) {
                if(callReaultParam.isLoginCall) {
                    [[FrtcPersistence sharedUserPersistence] saveMeeting:strongSelf.detailMeetingInfoModel];
                }
            }
            
            strongSelf.detailMeetingInfoModel = nil;
            strongSelf.failureCallBack(reason);
        }
        
        strongSelf.meetingPassword = nil;
    } requestMeetingPasswordHandler:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        BOOL requestError = NO;
        if (inputPasswordTimes == 0) {
            inputPasswordTimes = 1;
            requestError = NO;
        } else {
            requestError = YES;
        }
        strongSelf.requestPasswordCallBack(requestError);
    }];
}

- (void)frtcJoinMeetingWithCallParam:(FRTCMeetingParameters)param
                       withAuthority:(BOOL)authority
   withJoinMeetingSuccessfulCallBack:(void (^)())joinSuccessfulCallBack
       withJoinMeetingFailureCalBack:(void(^)(FRTCMeetingStatusReason reason))joinFailureCallBack
         withRequestPasswordCallBack:(void (^)(BOOL requestError))requestPasswordCallBack {
    
    /*
     *防止多次入会 所以在此加了一个判断，主要是为了防止url多次入会
     */
    if([self.windowController.window isVisible]) {
        [self.windowController alreadyInCall];
        return;
    }
    
    self.successfulCallBack         = joinSuccessfulCallBack;
    self.failureCallBack            = joinFailureCallBack;
    self.requestPasswordCallBack    = requestPasswordCallBack;
    
    FrtcCallWindowController *windowController = [[FrtcCallWindowController alloc] init];
    self.windowController   = windowController;
   
    self.muteMic          = param.audio_mute;
    self.muteCam          = param.video_mute;
    self.windowController.closedDelegate = self;
    NSString *layouMode     = [[FrtcUserDefault defaultSingleton] objectForKey:DEFAULT_LAYOUT];
    
    if([layouMode isEqualToString:@"gallery"]) {
        self.gallery = YES;
    } else {
        self.gallery = NO;
    }

    self.windowController.gridLayoutMode = self.gallery;
    [[FrtcCall sharedFrtcCall] frtcSetGridLayoutMode:self.isGallery];
    
    self.windowController.closedByUser = NO;
    self.contentControlToolBarResponder.colsedByUser = NO;
   
    self.voiceConference      = param.audio_only;
    self.joinMeetingName      = param.display_name;
    [_participantsList removeAllObjects];

    [self setupConfiguration];
    
    [self makeCallWithParam:param withAuthority:authority];
}

#pragma mark- -- notification

- (void)configNotification {
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
 
    [nc addObserver:self selector:@selector(onUserStopContent:) name:FMeetingUserStopContentNotification object:nil];
    
    [nc addObserver:self selector:@selector(onUserAppShareAllWindowClosed:) name:FMeetingUserAppShareAllWindowClosedNotification object:nil];

    [nc addObserver:self selector:@selector(onContentShouldStopForAdminStopMeeting:) name:FMeetingContentShouldStopForAdminStopMeetingNotification object:nil];
    
    [nc addObserver:self selector:@selector(onDisplayPluginOrOut:) name:FMeetingDisplayAddRemoveNotification object:nil];
   
}

- (void)onDisplayPluginOrOut:(NSNotification *)notification {
    NSDictionary    * userInfo = notification.userInfo;
    NSNumber * numberAddRemoveDisplayID = [userInfo valueForKey:FMeetingDisplayAddRemoveKey];
    int    nAddRemoveDisplayID = [numberAddRemoveDisplayID intValue];

    if (FRTCSDK_SHARE_CONTENT_APPLICATION == _shareContentType) {
        return;
    } else if (FRTCSDK_SHARE_CONTENT_DESKTOP == _shareContentType) {
        if (_sharingDesktopID == nAddRemoveDisplayID) {
            [self.windowController updateDisplayRemoveEvent];
            if (self.isSendingContent) {
                [self shareContent:NO];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:FMeetingDisplayChangedNotification object:nil userInfo:nil];
        }
        return;
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

- (void)stopSharingContent {
    _sharedWithAudio = NO;
    [self shareContent:NO];
    _shareContentType = FRTCSDK_SHARE_CONTENT_IDLE;
}

- (void)onUserStopContent:(NSNotification *)notification {
    [self stopSharingContent];
}

- (void)onUserAppShareAllWindowClosed:(NSNotification *)notification {
    [self stopSharingContent];
}

- (void)onContentShouldStopForAdminStopMeeting:(NSNotification *)notification {
    [self stopSharingContent];
}

- (void)onCloseWindow:(NSNotification *)notification {
    [self.windowController closeWinowByCloseButton];
}

- (void)frtcSendPassword:(NSString *)password {
    self.meetingPassword = password;
    self.meetingPasswordForReconnect = password;
    [[FrtcCall sharedFrtcCall] frtcSendCallPasscode:password];
}

- (void)hideLocalView:(BOOL)hide {
    [[FrtcCall sharedFrtcCall] frtcHideLocalPreview:hide];
}

#pragma mark- - getter
- (MeetingDetailModel *)detailMeetingInfoModel {
    if (!_detailMeetingInfoModel) {
        _detailMeetingInfoModel = [[MeetingDetailModel alloc] init];
    }
    
    return _detailMeetingInfoModel;
}


#pragma mark- - settingsUI enable/disable Receive Reminder
- (void)enableOrDisableReceiveMeetingReminder:(BOOL)enable {
    NSLog(@"[%s][Receive reminder]: user select: enable: %@", __func__, enable?@"YES":@"NO");
    [[FrtcLocalReminderManagement sharedInstance] enableOrDisableReceiveMeetingReminder:enable];
}

- (void)toastInfomation {
    [self.windowController toastInfomation];
}

@end
