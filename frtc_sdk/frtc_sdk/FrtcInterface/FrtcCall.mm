#import "FrtcCall.h"
#import "FrtcMeetingViewController.h"
#import "ObjectInterface.h"
#import "DeviceObject.h"
#import "SDKUserDefault.h"
#import "GTMBase64.h"
#import "FrtcMeetingStatusMachineTransition.h"
#import <IOKit/pwr_mgt/IOPMLib.h>
#include "content_audio_interface.h"
#import "FrtcAESObject.h"
#import "FrtcUUID.h"
#import "AudioEngine.h"
#import "AudioDevice.h"

IOPMAssertionID sleepingID;

typedef void (^CallStateAction)();

NSString * const FMeetingDeviceListChangedNotification = @"com.fmeeting.device.list.change";
NSString * const FMeetingDeviceListChangedKey = @"com.fmeeting.device.list.changed.key";
NSString * const FMeetingDeviceListInUseKey = @"com.fmeeting.device.list.used.key";

NSString * const FMeetingCameraListChangedNotification = @"com.fmeeting.camera.list.change";
NSString * const FMeetingCameraListChangedKey = @"com.fmeeting.camera.list.changed.key";
NSString * const FMeetingCameraListInUseKey = @"com.fmeeting.camera.list.used.key";

NSString * const FMeetingContentShouldStopForAdminStopMeetingNotification = @"com.fmeeting.content.state.stop.for.admin.stop.meeting";
NSString * const FMeetingContentShouldStopForAdminStopMeetingKey = @"com.fmeeting.content.state.stop.for.admin.stop.key";

NSString * const key = @"aab7097c02c0493093755c734d150aaf";

NSString * const FMeetingWindowReseizeNotification = @"com.fmeeting.window.resizeed";

typedef void (^RequestMeetingPasswordHandler)();

@interface FrtcCall()<NSWindowDelegate>

@property (nonatomic, copy) NSMutableArray * _Nullable meetingStatusMachines;

@property (nonatomic, copy) FRTCSDKCallCompletionHandler completionHandler;
@property (nonatomic, copy) RequestMeetingPasswordHandler requestPasswordHandler;

@property (nonatomic, assign) FRTCMeetingStatus meetingStatus;

@property (nonatomic, strong) NSWindowController        *windowController;
@property (nonatomic, strong) FrtcMeetingViewController *meetingViewController;

@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *meetingName;
@property (nonatomic, copy) NSString *meetingAlias;
@property (nonatomic, copy) NSString *serverAddress;
@property (nonatomic, copy) NSString *ownerID;
@property (nonatomic, copy) NSString *ownerName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) long long scheduleStartTime;
@property (nonatomic, assign) long long scheduleEndTime;
@property (nonatomic, copy) NSString *meetingUrl;
@property (nonatomic, copy) NSString *groupMeetingUrl;

@property (nonatomic, assign, getter = isVideoMute) BOOL videoMute;
@property (nonatomic, assign, getter = isAudioMute) BOOL audioMute;
@property (nonatomic, assign, getter = isSignIn)    BOOL signIn;
@property (nonatomic, assign, getter = isAudioOnly) BOOL audioOnly;
@property (nonatomic, assign, getter = isGridMode)  BOOL gridMode;
@property (nonatomic, assign, getter = isReconnect) BOOL reconnect;

@property (nonatomic, assign) int reason;
@property (nonatomic, assign) CallMeetingStatus status;

@end

@implementation FrtcCall

+ (FrtcCall *)sharedFrtcCall {
    static FrtcCall *_sharedCall = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedCall = [[FrtcCall alloc] init];
    });
    
    return _sharedCall;
}

- (instancetype)init {
    if (self = [super init]) {
        _meetingStatus = MEETING_STATUS_IDLE;
        _meetingStatusMachines = [NSMutableArray array];
        
        [self setupCallStateTransition];
    }
    
    return self;
}

- (void)setupStateMachine:(FRTCMeetingStatus)theCurState newState:(FRTCMeetingStatus)theNewState andAction:(CallStateAction)theAction {
    FrtcMeetingStatusMachineTransition* transition = [[FrtcMeetingStatusMachineTransition alloc] initWithCurrentCallState:theCurState newCallState:theNewState andAction:theAction];
    
    [self.meetingStatusMachines addObject:transition];
}

- (void)setupCallStateTransition {
    __weak __typeof(self)weakSelf = self;
    
    [self setupStateMachine:MEETING_STATUS_IDLE
                   newState:MEETING_STATUS_IDLE
                  andAction:^{
        
    }];
    
    [self setupStateMachine:MEETING_STATUS_IDLE
                   newState:MEETING_STATUS_CONNECTE
                  andAction:^{
        [weakSelf callStatusFromIdleToConnect];
        
    }];
    
    [self setupStateMachine:MEETING_STATUS_IDLE
                   newState:MEETING_STATUS_DISCONNECTED
                  andAction:^{
        
        [weakSelf callStatusFromIdleToDisconnect];
    }];
    
    [self setupStateMachine:MEETING_STATUS_CONNECTE
                   newState:MEETING_STATUS_CONNECTE
                  andAction:^{
        
    }];
    
    [self setupStateMachine:MEETING_STATUS_CONNECTE
                   newState:MEETING_STATUS_DISCONNECTED
                  andAction:^{
        [weakSelf callStatusFromConnectToDisconnect];
    }];
    
    [self setupStateMachine:MEETING_STATUS_DISCONNECTED
                   newState:MEETING_STATUS_CONNECTE
                  andAction:^{
        
        [weakSelf callStatusFromDisconnectToConnect];
    }];
    
    [self setupStateMachine:MEETING_STATUS_DISCONNECTED
                   newState:MEETING_STATUS_DISCONNECTED
                  andAction:^{
        [weakSelf callStatueFromDisconnectToDisconnect];
    }];
}

- (void)frtcMakeCall:(FRTCMeetingParameters)callParam
          controller:(NSWindowController * _Nonnull )controller
   completionHandler:(void (^)(FRTCMeetingStatus callMeetingStatus, 
                               FRTCMeetingStatusReason reason,
                               FRTCMeetingStatusReasonParam callReaultParam))callCompletionHandler
requestMeetingPasswordHandler:(void(^)(void))requestPasswordHandler {
    [ObjectInterface sharedObjectInterface].callDelegate = self.callDelegate;
    
    if (callParam.meeting_password == nil) {
        callParam.meeting_password = @"";
    } else {
        self.password = callParam.meeting_password;
    }
    
    BOOL login =  [[SDKUserDefault sharedSDKUserDefault] sdkBoolObjectForKey:SKD_LOGIN_VALUE];
    
    self.reason = 0;
    self.status = kIdle;
    NSString *serverAddress = [[SDKUserDefault sharedSDKUserDefault] sdkObjectForKey:SKD_SERVER_ADDRESS];
    
    if (callParam.meeting_url != nil) {
        NSString * cipherString;
        NSDictionary *jsonDict;
        
        NSString *plainText     = callParam.meeting_url;
        NSData *afterDecodeData = [GTMBase64 decodeString:plainText];
        cipherString            = [[NSString alloc] initWithData:afterDecodeData encoding:NSUTF8StringEncoding];
        
        if(cipherString != nil) {
            jsonDict = [NSJSONSerialization JSONObjectWithData:afterDecodeData options:NSJSONReadingMutableLeaves error:nil];
        } else {
            NSData *afterDesData = [[FrtcAESObject sharedAESObject] AES256DecryptWithKey:key withData:afterDecodeData];
            
            cipherString  =[[NSString alloc] initWithData:afterDesData encoding:NSUTF8StringEncoding];
            if(cipherString == nil) {
                FRTCMeetingStatusReason result = MEETING_STATUS_MEETINGNOTEXIST;
                self.completionHandler(MEETING_STATUS_DISCONNECTED, result, [self generateErrorCallResultParam]);
                return;
            }
            
            jsonDict = [NSJSONSerialization JSONObjectWithData:afterDesData options:NSJSONReadingMutableLeaves error:nil];
        }
        
        callParam.meeting_alias     = jsonDict[@"meeting_number"];
        NSString *tempServerAddress = jsonDict[@"server_address"];
        NSString *password          = jsonDict[@"meeting_passwd"];
        
        if(password != nil) {
            callParam.meeting_password = password;
        } else {
            callParam.meeting_password = @"";
        }
        
        if(login) {
            if([tempServerAddress isEqualToString:serverAddress]) {
                [[SDKUserDefault sharedSDKUserDefault] setSDKBoolObject:NO forKey:SKD_IF_URL_CALL];
            } else {
                login = NO;
                [[SDKUserDefault sharedSDKUserDefault] setSDKBoolObject:YES forKey:SKD_IF_URL_CALL];
                [[SDKUserDefault sharedSDKUserDefault] setSDKObject:tempServerAddress forKey:SKD_URL_VALUE];
            }
        } else {
            [[SDKUserDefault sharedSDKUserDefault] setSDKBoolObject:YES forKey:SKD_IF_URL_CALL];
            [[SDKUserDefault sharedSDKUserDefault] setSDKObject:tempServerAddress forKey:SKD_URL_VALUE];
        }
        
        if(![tempServerAddress isEqualToString:serverAddress]) {
            serverAddress = tempServerAddress;
        }
    } else {
        [[SDKUserDefault sharedSDKUserDefault] setSDKBoolObject:NO forKey:SKD_IF_URL_CALL];
    }
    
    self.signIn = login;
    
    if (![controller isEqualTo:self.windowController]) {
        self.meetingViewController              = [[FrtcMeetingViewController alloc] init];
        self.meetingViewController.callDelegate = self.callDelegate;
        self.windowController                   = controller;
        self.windowController.window.delegate   = self;
        self.reconnect                          = NO;
    } else {
        self.reconnect                          = YES;
    }
    
    self.meetingViewController.gallery = self.isGridMode;
    self.meetingAlias                  = callParam.meeting_alias;
    self.displayName                   = callParam.display_name;
    self.videoMute                     = callParam.video_mute;
    self.audioMute                     = callParam.audio_mute;
    self.audioOnly                     = callParam.audio_only;
    self.completionHandler             = callCompletionHandler;
    self.requestPasswordHandler        = requestPasswordHandler;
    
    __weak __typeof(self)weakSelf = self;
    
    if (self.isAudioOnly) {
        callParam.call_rate = 64;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[ObjectInterface sharedObjectInterface] joinMeetingWithServerAddress:serverAddress
                                                              conferenceAlias:callParam.meeting_alias
                                                                   clientName:callParam.display_name
                                                                    userToken:callParam.user_token
                                                                     callRate:callParam.call_rate
                                                              meetingPassword:callParam.meeting_password 
                                                                      isLogin:login 
                                                                       userId:callParam.user_id 
                                                        meetingStatusCallBack:^(CallMeetingStatus callMeetingStatus, int reason) {
            if (weakSelf.status == kDisconnected) {
                return;
            }
            
            weakSelf.status = callMeetingStatus;
            weakSelf.reason = reason;
            [weakSelf callStateTransition:callMeetingStatus];
            
            if (callMeetingStatus == kDisconnected) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:FMeetingContentShouldStopForAdminStopMeetingNotification object:nil userInfo:nil];
                });
            }
        } meetingParamsCallBack:^(NSString *conferenceName, NSString *meetingID, NSString *displayName, NSString *ownerID, NSString *ownerName, NSString *meetingUrl, NSString *groupMeeingUrl, const long long scheduleStartTime,
                          const long long scheduleEndTime) {
            weakSelf.meetingName     = conferenceName;
            weakSelf.ownerID         = ownerID;
            weakSelf.ownerName       = ownerName;
            weakSelf.meetingUrl      = meetingUrl;
            weakSelf.groupMeetingUrl = groupMeeingUrl;
            
            weakSelf.scheduleStartTime = scheduleStartTime;
            weakSelf.scheduleEndTime   = scheduleEndTime;
        } requestPasswordCallBack:^{
            if (weakSelf.isReconnect) {
                [[ObjectInterface sharedObjectInterface] verifyPasscodeObject:weakSelf.password];
                return;
            }
            weakSelf.requestPasswordHandler();
        } remoteLayoutChangeBlock:^(SDKLayoutInfo buffer) {
            [weakSelf.meetingViewController layoutUpdate:buffer];
        } waterMaskCallBack:^(NSString *waterMaskString) {
            [weakSelf.meetingViewController onWaterPrint:waterMaskString];
        } remoteVideoReceivedBlock:^(NSString *mediaID) {
            [weakSelf.meetingViewController remoteVideoReceived:mediaID];
        } remoteAudioReceivedBlock:^(NSString *mediaID) {
            [weakSelf.meetingViewController remoteAudioReceived:mediaID];
        } contentStreamRequestBlock:^(NSString *mediaID, int width, int height, int framerate) {
    
        } videoFrozenBlock:^(NSString *mediaID, BOOL bFrozen) {
            [weakSelf.meetingViewController onVideoFrozen:mediaID videoFrozen:bFrozen];
        } micMeterBlock:^(float meter) {
            if([weakSelf.callDelegate respondsToSelector:@selector(audioLevelMeter:)]) {
                [weakSelf.callDelegate audioLevelMeter:meter];
            }
        }];
    });
}

- (void)frtcEndMeeting {
    [self.windowController close];
    [[ObjectInterface sharedObjectInterface] endMeetingWithCallIndex:0];
}

- (void)frtcSendCallPasscode:(NSString *)passcode {
    self.password = passcode;
    [[ObjectInterface sharedObjectInterface] verifyPasscodeObject:passcode];
}

- (NSString *)frtcGetVersion {
    NSString *version = [[ObjectInterface sharedObjectInterface] getVersion];
    return version;
}

- (void)frtcMuteLocalVideo:(BOOL)mute {
    [[ObjectInterface sharedObjectInterface] muteLocalVideoObject:mute];
    [(FrtcMeetingViewController *)self.windowController.window.contentViewController stopLocalRender:mute];
}

- (void)frtcMuteLocalAudio:(BOOL)mute {
    self.audioMute = mute;
    [[ObjectInterface sharedObjectInterface] muteLocalAudioObject:mute];
    
    if (!mute) {
        [[ObjectInterface sharedObjectInterface] setContentAudioObject:true sameDevice:true];
    } else {
        [[ObjectInterface sharedObjectInterface] setContentAudioObject:false sameDevice:false];
    }
}

- (void)frtcShareContent:(BOOL)isShareContent
         withContentType:(FRTCShareContentType)shareContentType
           withDesktopID:(uint32_t)desktopId
            withWindowID:(unsigned int)appWindowID
      withAppContentName:(NSString *)sourceAppContentName
        withContentAudio:(BOOL)sendContentAudio {
    
    if(sendContentAudio) {
        if(self.isAudioMute) {
            [[ObjectInterface sharedObjectInterface] setContentAudioObject:false sameDevice:false];
        } else {
            [[ObjectInterface sharedObjectInterface] setContentAudioObject:true sameDevice:true];
        }
    }
    
    ((FrtcMeetingViewController *)self.windowController.window.contentViewController).sharingWithAudio = sendContentAudio;
    
    [[ObjectInterface sharedObjectInterface] shareContent:isShareContent withContentType:(int)shareContentType withDesktopID:desktopId withWindowID:appWindowID withAppContentName:sourceAppContentName withContentAudio:sendContentAudio];
}

- (NSArray *)frtcGetMonitorList {
    return [[DeviceObjectClient sharedDeviceObject] getDisplayScreenArray];
}

- (NSString *)frtcGetCallStaticsInfomation {
    return [[ObjectInterface sharedObjectInterface] getMediaStatisticsObject];
}

- (void)frtcSetConfig:(FRTCSDKConfigParamKey)key withSDKConfigValue:(NSString *)value {
    if (key == FRTC_SAVE_SERVER_ADDRESS) {
        self.serverAddress = value;
    } else if (key == FRTC_ENABLE_NOISE_REDUCTIION) {
        [[ObjectInterface sharedObjectInterface] setIntelligentNoiseReductionObject:([value isEqualToString:@"true"])];
    }
}

- (void)frtcCameraList:(NSMutableArray *)pArray {
    [[DeviceObjectClient sharedDeviceObject] getCameraArray:pArray];
}

- (void)frtcSelectCamera:(NSString*)id {
    [[DeviceObjectClient sharedDeviceObject] switchCameraByDeviceID:id];
}

- (void)frtcMicphoneList:(NSMutableArray *)pArray {
    [[DeviceObjectClient sharedDeviceObject] getMicphoneArray:pArray];
}

- (void)frtcSelectMic:(NSString *)id {
    [AudioEngine sharedAudioEngine].currentMicphoneName = id;
    [[DeviceObjectClient sharedDeviceObject] switchMicphoneByDeviceID:id];
}

- (void)frtcSpeakerList:(NSMutableArray*)pArray {
    [[DeviceObjectClient sharedDeviceObject] getSpeakerArray:pArray];
}

- (void)frtcSelectSpeaker:(NSString*)id {
    [AudioEngine sharedAudioEngine].currentDeviceName = id;
    [[DeviceObjectClient sharedDeviceObject] switchSpeakerByDeviceID:id];
}

- (NSString *)frtcGetDefaultMicName {
    NSString *defaultMicName = [[DeviceObjectClient sharedDeviceObject] getDefaultMicName];
    return defaultMicName;
}

- (NSString *)frtcGetDefaultSpeakerName {
    NSString *defaultSpeakerName = [[DeviceObjectClient sharedDeviceObject] getDefaultSpeakerName];
    return defaultSpeakerName;
}

- (void)frtcEnableNoiseBlocker:(BOOL)isEnableNoiseBlocker {
    [[ObjectInterface sharedObjectInterface] setIntelligentNoiseReductionObject:isEnableNoiseBlocker ? true : false];
}

#pragma mark --Internal Function--
- (FRTCMeetingStatusReasonParam)generateErrorCallResultParam {
    FRTCMeetingStatusReasonParam callReaultParam;
    
    callReaultParam.conferenceName    = @"error";
    callReaultParam.conferenceAlias   = @"error";
    callReaultParam.ownerID           = @"error";
    callReaultParam.ownerName         = @"error";
    callReaultParam.meetingUrl        = @"error";
    callReaultParam.groupMeetingUrl   = @"error";
    callReaultParam.scheduleEndTime   = 0;
    callReaultParam.scheduleStartTime = 0;
    callReaultParam.isLoginCall       = self.isSignIn;
    
    return callReaultParam;
}

- (FRTCMeetingStatusReasonParam)generateSuccessCallResultParam {
    FRTCMeetingStatusReasonParam callReaultParam;
 
    callReaultParam.conferenceName    = self.meetingName;
    callReaultParam.conferenceAlias   = self.meetingAlias;
    callReaultParam.ownerID           = self.ownerID;
    callReaultParam.ownerName         = self.ownerName;
    callReaultParam.meetingUrl        = self.meetingUrl;
    callReaultParam.groupMeetingUrl   = self.groupMeetingUrl;
    callReaultParam.scheduleEndTime   = self.scheduleEndTime;
    callReaultParam.scheduleStartTime = self.scheduleStartTime;
    callReaultParam.isLoginCall       = self.isSignIn;
    
    return callReaultParam;
}

- (FRTCMeetingStatusReason)meetingStatusReason:(int)reason {
    FRTCMeetingStatusReason result;
    if (reason == 0) {
        result = MEETING_STATUS_SUCCESS;
    } else if(reason == 2) {
        result = MEETING_STATUS_ABORTED;
    } else if (reason == 3) {
        result = MEETING_STATUS_END_ABNORMAL;
    } else if (reason == 4) {
        result =  MEETING_STATUS_EXPIRED;
    } else if (reason == 5) {
        result = MEETING_STATUS_PEOPLE_FULL;
    } else if (reason == 6) {
        result =  MEETING_STATUS_INTERRUPT;
    } else if (reason == 7) {
        result = MEETING_STATUS_LOCKED;
    } else if (reason == 8) {
        result = MEETING_STATUS_MEETINGNOTEXIST;
    } else if (reason == 9) {
        result =  MEETING_STATUS_NOT_STARTED;
    } else if (reason == 10) {
        result =  MEETING_STATUS_STOP;
    } else if (reason == 11) {
        result = MEETING_STATUS_AUTHFAILED;
    } else if (reason == 14) {
        result =  MEETING_STATUS_PASSWORD_TOO_MANY_RETRIES;
    } else if (reason == 15) {
        result =  MEETING_STATUS_GUEST_UNALLOWED;
    } else if (reason == 17) {
        result = MEETING_STATUS_LICENSE_MAX_LIMIT_REACHED;
    } else if (reason == 18) {
        result = MEETING_STATUS_NO_LICENSE;
    } else if (reason == 19) {
        result =  MEETING_STATUS_REMOVE;
    } else if (reason == 20) {
        result = MEETING_STATUS_SERVERERROR;
    } else if (reason == 21) {
        result = MEETING_STATUS_REJECTED;
    } else {
        result = MEETING_STATUS_FAILED;
    }
    return result;
}

#pragma mark -- window delegate

- (void)windowWillClose:(NSNotification *)notification {
    [[ObjectInterface sharedObjectInterface] endMeetingWithCallIndex:0];
}

- (NSArray *)frtcGetApplicationList {
    return [[ObjectInterface sharedObjectInterface] getApplicationList];
}

- (void)prohibitDesktopSleep {
    CFStringRef reasonForActivity= CFSTR("Describe Activity Type");
    IOPMAssertionCreateWithName(kIOPMAssertionTypeNoDisplaySleep,
                                                   kIOPMAssertionLevelOn, reasonForActivity, &sleepingID);
}

- (void)AllowDesktopSleep {
    IOPMAssertionRelease(sleepingID);
}

- (void)frtcSetGridLayoutMode:(BOOL)gridMode {
    [[ObjectInterface sharedObjectInterface] setLayoutGridModeObject:gridMode ? true : false];
    if (self.meetingStatus == MEETING_STATUS_CONNECTE) {
        [self.meetingViewController switchLayout:gridMode];
    }
    
    self.gridMode = gridMode;
}

- (void)frtcHideLocalPreview:(BOOL)hidden {
    [self.meetingViewController disappearLocal:hidden];
}

- (NSString *)frtcGetClientUUID {
    return [[FrtcUUID sharedUUID] getAplicationUUID];
}

- (NSDictionary *)parseWebUrl:(NSString *)url {
    NSString *plainText = url;
    NSString * cipherString;
    NSDictionary *jsonDict;
    
    NSData *afterDecodeData = [GTMBase64 decodeString:plainText];
    
    cipherString  =[[NSString alloc] initWithData:afterDecodeData encoding:NSUTF8StringEncoding];
    if(cipherString != nil) {
        jsonDict = [NSJSONSerialization JSONObjectWithData:afterDecodeData options:NSJSONReadingMutableLeaves error:nil];
    } else {
        NSData *afterDesData = [[FrtcAESObject sharedAESObject] AES256DecryptWithKey:key withData:afterDecodeData];
        cipherString  =[[NSString alloc] initWithData:afterDesData encoding:NSUTF8StringEncoding];
        if(cipherString == nil) {
            return nil;
        }
        
        jsonDict = [NSJSONSerialization JSONObjectWithData:afterDesData options:NSJSONReadingMutableLeaves error:nil];
    }
    
    return jsonDict;
}

- (NSString *)parseUrl:(NSString *)url {
    NSString *plainText = url;
    NSString * cipherString;
    NSDictionary *jsonDict;
    
    NSData *afterDecodeData = [GTMBase64 decodeString:plainText];
    
    cipherString  =[[NSString alloc] initWithData:afterDecodeData encoding:NSUTF8StringEncoding];
    if(cipherString != nil) {
        jsonDict = [NSJSONSerialization JSONObjectWithData:afterDecodeData options:NSJSONReadingMutableLeaves error:nil];
        NSString *tempServerAddress = jsonDict[@"server_address"];
        
        return tempServerAddress;
    } else {
        NSData *afterDesData = [[FrtcAESObject sharedAESObject] AES256DecryptWithKey:key withData:afterDecodeData];
        cipherString  =[[NSString alloc] initWithData:afterDesData encoding:NSUTF8StringEncoding];
        if(cipherString == nil) {
            return nil;
        }
        
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:afterDesData options:NSJSONReadingMutableLeaves error:nil];
        NSString *tempServerAddress = jsonDict[@"server_address"];
        
        return tempServerAddress;
    }
}

- (void)frtcLogout {
    [[SDKUserDefault sharedSDKUserDefault] setSDKBoolObject:NO forKey:SKD_LOGIN_VALUE];
}

- (void)saveUrl:(NSString *)url {
    [[SDKUserDefault sharedSDKUserDefault] setSDKObject:url forKey:SKD_SERVER_ADDRESS];
}

- (NSInteger)frtcStartUploadLogs:(NSString *)metaData
                        fileName:(NSString *)fileName
                       fileCount:(int)fileCount {
    return [[ObjectInterface sharedObjectInterface] startUploadLogsObject:metaData fileName:fileName fileCount:fileCount];
}

- (NSString *)frtcGetUploadStatus:(int)tractionId {
    return [[ObjectInterface sharedObjectInterface] getUploadStatusObject:tractionId];
}

- (void)frtcCancelUploadLogs:(int)tractionId {
    [[ObjectInterface sharedObjectInterface] cancelUploadLogsObject:tractionId];
}

- (void)testMicphone:(BOOL)enable withHandler:(void (^)(float meter, BOOL testing))testMicHandler {
        if(enable) {
            [[DeviceObjectClient sharedDeviceObject] enableAudioUnitCoreGraph];
        } else {
            if(![self isInCall]) {
                [[DeviceObjectClient sharedDeviceObject] disableAudioUnitCoreGraph];
            }
        }
    
    [[DeviceObjectClient sharedDeviceObject] testMic:enable withHandler:^(float meter, BOOL testing) {
        NSLog(@"Test the mic meter to ui");
        if([self.callDelegate respondsToSelector:@selector(audioLevelMeter:)]) {
            [self.callDelegate audioLevelMeter:meter];
        }
        testMicHandler(meter, testing);
    }];
}

- (void)testSpeaker:(BOOL)enable withHandler:(void (^)(float meter, BOOL testing))testSpeakerHandler {
    if(enable) {
        [[AudioEngine sharedAudioEngine] playWithHandler:testSpeakerHandler];
    } else {
        [[AudioEngine sharedAudioEngine] stopPlay];
    }
}

- (BOOL)isInCall {
    if(self.meetingStatus == MEETING_STATUS_CONNECTE) {
        return YES;
    } else {
        return NO;
    }
}

- (void)setCameraStreamMirror:(BOOL)isMirror {
    bool mirror;
    
    if(isMirror) {
        mirror = true;
    } else {
        mirror = false;
    }
    
    [[ObjectInterface sharedObjectInterface] SetCameraStreamMirrorObject:mirror];
}

- (NSString *)getDefaultCamera {
    return [[DeviceObjectClient sharedDeviceObject] getDefaultCameraName];
}

- (void)callStatusFromIdleToConnect {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.isAudioMute) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void) {
                [[DeviceObjectClient sharedDeviceObject] enableAudioUnitCoreGraph];
            });
        } else {
            [[DeviceObjectClient sharedDeviceObject] enableAudioUnitCoreGraph];
        }
        
        [self callStateChangedToConnected];
        FRTCMeetingStatusReason reason = MEETING_STATUS_CONNECTED;
        self.completionHandler(MEETING_STATUS_CONNECTE, reason, [self generateSuccessCallResultParam]);
    });
}

- (void)callStatusFromIdleToDisconnect {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[DeviceObjectClient sharedDeviceObject] disableCameraWork];
        self.meetingViewController = nil;
        FRTCMeetingStatusReason result = [self meetingStatusReason:self.reason];
        self.completionHandler(MEETING_STATUS_DISCONNECTED, result, [self generateErrorCallResultParam]);
    });
}

- (void)callStatusFromConnectToDisconnect {
    [[SDKUserDefault sharedSDKUserDefault] setSDKBoolObject:NO forKey:SKD_IF_URL_CALL];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        FRTCMeetingStatusReason result = [self meetingStatusReason:self.reason];
        [[DeviceObjectClient sharedDeviceObject] disableAudioUnitCoreGraph];
        
        if(result != MEETING_STATUS_END_ABNORMAL) {
            [self.meetingViewController stopVideoRender];
            [self.windowController close];
            [self AllowDesktopSleep];
            [[DeviceObjectClient sharedDeviceObject] disableCameraWork];
            
            if(self.callDelegate && [self.callDelegate respondsToSelector:@selector(onInCallWindowInitializedState:)]) {
                [self.callDelegate onInCallWindowInitializedState:0];
            }
            
            self.windowController = nil;
            self.meetingViewController = nil;
        }
        
        self.completionHandler(MEETING_STATUS_DISCONNECTED, result,[self generateErrorCallResultParam]);
    });
}

- (void)callStatusFromDisconnectToConnect {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.isAudioMute) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
                [[DeviceObjectClient sharedDeviceObject] enableAudioUnitCoreGraph];
            });
        } else {
            [[DeviceObjectClient sharedDeviceObject] enableAudioUnitCoreGraph];
        }

        [self callStateChangedToConnected];
        FRTCMeetingStatusReason reason = MEETING_STATUS_CONNECTED;
        self.completionHandler(MEETING_STATUS_CONNECTE, reason, [self generateSuccessCallResultParam]);
    });
}

- (void)callStatueFromDisconnectToDisconnect {
    [[SDKUserDefault sharedSDKUserDefault] setSDKBoolObject:NO forKey:SKD_IF_URL_CALL];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        FRTCMeetingStatusReason result = [self meetingStatusReason:self.reason];
        self.completionHandler(MEETING_STATUS_DISCONNECTED, result, [self generateErrorCallResultParam]);
    });
}

- (void)callStateChangedToConnected {
    if (!self.isAudioOnly && !self.isVideoMute) {
        [[DeviceObjectClient sharedDeviceObject] enableCameraWork];
    }
    
    self.meetingViewController.displayName     = self.displayName;
    self.meetingViewController.videoMute       = self.isVideoMute;
    self.meetingViewController.audioMute       = self.isAudioMute;
    self.meetingViewController.presenterLayout = !self.gridMode;
    
    if (self.isReconnect) {
        return;
    }
    
    NSWindow *mainWindow                        = [NSWindow windowWithContentViewController:self.meetingViewController];
    self.windowController.window                = mainWindow;
    self.meetingViewController.view.window.windowController = self.windowController;
    
    [self.windowController.window makeKeyAndOrderFront:self];
    [self.windowController.window setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    [self.windowController.window center];
    [self.windowController showWindow:nil];

    [self prohibitDesktopSleep];
    
    if(self.callDelegate && [self.callDelegate respondsToSelector:@selector(onInCallWindowInitializedState:)]) {
        [self.callDelegate onInCallWindowInitializedState:1];
    }
}

- (void)callStateTransition:(CallMeetingStatus)callMeetingStatus {
    for (FrtcMeetingStatusMachineTransition* transition in self.meetingStatusMachines) {
        if(transition.currentStatus == self.meetingStatus && transition.newMeetingStatus == static_cast<FRTCMeetingStatus>(callMeetingStatus)) {
            self.meetingStatus = transition.newMeetingStatus;
            transition.action();
            break;
        }
    }
}

@end


