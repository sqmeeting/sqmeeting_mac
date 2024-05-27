#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "ContentSourceInfo.h"

NS_ASSUME_NONNULL_BEGIN

@class NSViewController;

FOUNDATION_EXPORT NSString * const FMeetingDeviceListChangedNotification;
FOUNDATION_EXPORT NSString * const FMeetingDeviceListInUseKey;

FOUNDATION_EXPORT NSString * const FMeetingCameraListChangedNotification;
FOUNDATION_EXPORT NSString * const FMeetingCameraListChangedKey;
FOUNDATION_EXPORT NSString * const FMeetingCameraListInUseKey;

NSString * const FMeetingAudioDeviceTransportTypeUnknown        = @"";
NSString * const FMeetingAudioDeviceTransportTypeBuiltIn        = @"bltn";
NSString * const FMeetingAudioDeviceTransportTypeAggregate      = @"grup";
NSString * const FMeetingAudioDeviceTransportTypeVirtual        = @"virt";
NSString * const FMeetingAudioDeviceTransportTypePCI            = @"pci ";
NSString * const FMeetingAudioDeviceTransportTypeUSB            = @"usb ";
NSString * const FMeetingAudioDeviceTransportTypeFireWire       = @"1394";
NSString * const FMeetingAudioDeviceTransportTypeBluetooth      = @"blue";
NSString * const FMeetingAudioDeviceTransportTypeBluetoothLE    = @"blea";
NSString * const FMeetingAudioDeviceTransportTypeHDMI           = @"hdmi";
NSString * const FMeetingAudioDeviceTransportTypeDisplayPort    = @"dprt";
NSString * const FMeetingAudioDeviceTransportTypeAirPlay        = @"airp";
NSString * const FMeetingAudioDeviceTransportTypeAVB            = @"eavb";
NSString * const FMeetingAudioDeviceTransportTypeThunderbolt    = @"thun";

/**
 Enum for Call state.
 */
typedef NS_ENUM(NSInteger, FRTCMeetingStatus) {
    MEETING_STATUS_IDLE,
    MEETING_STATUS_CONNECTE,
    MEETING_STATUS_DISCONNECTED,
};

typedef NS_ENUM(NSInteger, FRTCMeetingStatusReason) {
    MEETING_STATUS_SUCCESS,
    MEETING_STATUS_MEETINGNOTEXIST,
    MEETING_STATUS_REJECTED,
    MEETING_STATUS_NOANSWER,
    MEETING_STATUS_UNREACHABLE,
    MEETING_STATUS_HABGUP,
    MEETING_STATUS_ABORTED,
    MEETING_STATUS_LOSTCONNECTION,
    MEETING_STATUS_LOCKED,
    MEETING_STATUS_SERVERERROR,
    MEETING_STATUS_NOPERMISSION,
    MEETING_STATUS_AUTHFAILED,
    MEETING_STATUS_UNABLEPROCESS,
    MEETING_STATUS_FAILED,
    MEETING_STATUS_CONNECTED,
    MEETING_STATUS_STOP,
    MEETING_STATUS_INTERRUPT,
    MEETING_STATUS_REMOVE,
    MEETING_STATUS_PASSWORD_TOO_MANY_RETRIES,
    MEETING_STATUS_EXPIRED,
    MEETING_STATUS_NOT_STARTED,
    MEETING_STATUS_GUEST_UNALLOWED,
    MEETING_STATUS_PEOPLE_FULL,
    MEETING_STATUS_NO_LICENSE,
    MEETING_STATUS_LICENSE_MAX_LIMIT_REACHED,
    MEETING_STATUS_EXIT_EXCEPTION,
    MEETING_STATUS_END_ABNORMAL
};

typedef NS_ENUM(NSUInteger, FRTCSDKConfigParamKey) {
    FRTC_SAVE_SERVER_ADDRESS,
    FRTC_ENABLE_NOISE_REDUCTIION,
};

typedef struct {
    NSString *meeting_alias;
    NSString *display_name;
    NSString *user_token;
    NSString *meeting_password;
    NSString *meeting_url;
    NSString *user_id;
    
    int call_rate;
    BOOL audio_mute;
    BOOL video_mute;
    BOOL audio_only;
    BOOL grid_mode;
} FRTCMeetingParameters;

typedef struct {
    NSString *conferenceName;
    NSString *conferenceAlias;
    NSString *ownerID;
    NSString *ownerName;
    NSString *meetingUrl;
    NSString *groupMeetingUrl;
    long long scheduleStartTime;
    long long scheduleEndTime;
    BOOL isLoginCall;
} FRTCMeetingStatusReasonParam;


typedef NS_ENUM(NSInteger, FRTCShareContentType) {
    FRTCSDK_SHARE_CONTENT_IDLE = 0,
    FRTCSDK_SHARE_CONTENT_DESKTOP = 1,
    FRTCSDK_SHARE_CONTENT_APPLICATION = 2,
};

typedef void (^FRTCSDKCallCompletionHandler)(FRTCMeetingStatus callMeetingStatus,
                                             FRTCMeetingStatusReason reason,
                                             FRTCMeetingStatusReasonParam callReaultParam);

#pragma mark- class FrtcCall
@protocol FrtcCallDelegate <NSObject>

@optional

- (void)audioLevelMeter:(float)meter;

- (void)onMeetingMessage:(NSString *)message;

- (void)onParticipantsList:(NSMutableArray<NSString *> *)rosterListArray;

- (void)onParticipantsNumber:(NSInteger)participantsNumber;

- (void)onLectureList:(NSMutableArray<NSString *> *)lectureListArray;

- (void)onRecordStatus:(NSString *)recordingStatus liveStatus:(NSString *)liveStatus liveMeetingUrl:(NSString *)liveMeetingUrl liveMeetingPassword:(NSString *)liveMeetingPassword;

- (void)onPinStatus:(BOOL)pinStatus;

- (void)onMute:(BOOL)mute allowSelfUnmute:(BOOL)allowSelfUnmute;

- (void)onReceiveUnmuteRequest:(NSMutableDictionary *)requestUnmuteDictionary;

- (void)onReceiveAllowUnmute;

- (void)onContentPriorityChangeStatus:(NSString *)status;

- (void)onContentState:(NSInteger)state;

- (void)onMutedDetected;

- (void)onMenuShelterShow:(BOOL)isShelterByMenu;

- (void)onCloseWindow;

- (void)onScreenChange:(NSScreen *)screen withScreenSize:(NSSize)newSize;

- (void)onInCallWindowInitializedState:(NSInteger)initializedState;

- (void)onFullScreenState:(NSInteger)state;

@end

@interface FrtcCall : NSObject

+ (FrtcCall *)sharedFrtcCall;

@property (nonatomic, weak) id<FrtcCallDelegate> callDelegate;

- (void)frtcSetConfig:(FRTCSDKConfigParamKey)key withSDKConfigValue:(NSString *)value;

- (void)frtcMakeCall:(FRTCMeetingParameters)callParam
          controller:(NSWindowController * _Nonnull )controller
   completionHandler:(void (^)(FRTCMeetingStatus callMeetingStatus,
                               FRTCMeetingStatusReason reason,
                               FRTCMeetingStatusReasonParam callReaultParam))callCompletionHandler
  requestMeetingPasswordHandler:(void(^)(void))requestPasswordHandler;

- (void)frtcEndMeeting;

- (NSArray *)frtcGetMonitorList;

- (NSArray *)frtcGetApplicationList;

- (void)frtcShareContent:(BOOL)isShareContent
         withContentType:(FRTCShareContentType)shareContentType
           withDesktopID:(uint32_t)desktopId
            withWindowID:(unsigned int)appWindowID
      withAppContentName:(NSString *)sourceAppContentName
        withContentAudio:(BOOL)sendContentAudio;


- (void)frtcCameraList:(NSMutableArray*)pArray;

- (void)frtcSelectCamera:(NSString*)id;

- (void)frtcMicphoneList:(NSMutableArray*)pArray;

- (void)frtcSelectMic:(NSString*)id;

- (void)frtcSpeakerList:(NSMutableArray*)pArray;

- (void)frtcSelectSpeaker:(NSString*)id;

- (NSString *)frtcGetDefaultMicName;

- (NSString *)frtcGetDefaultSpeakerName;

- (void)frtcMuteLocalVideo:(BOOL)mute;

- (void)frtcMuteLocalAudio:(BOOL)mute;

- (NSString *)frtcGetCallStaticsInfomation;

- (NSString *)frtcGetVersion;

- (void)frtcSetGridLayoutMode:(BOOL)gridMode;

- (void)frtcEnableNoiseBlocker:(BOOL)isEnableNoiseBlocker;

- (void)frtcHideLocalPreview:(BOOL)hidden;

- (void)frtcSendCallPasscode:(NSString *)passcode;

- (NSString *)frtcGetClientUUID;

- (NSString *)parseUrl:(NSString *)url;

- (NSDictionary *)parseWebUrl:(NSString *)url;

- (void)frtcLogout;

- (void)saveUrl:(NSString *)url;

- (NSInteger)frtcStartUploadLogs:(NSString *)metaData
                        fileName:(NSString *)fileName
                       fileCount:(int)fileCount;

- (NSString *)frtcGetUploadStatus:(int)tractionId;

- (void)frtcCancelUploadLogs:(int)tractionId;

- (void)testMicphone:(BOOL)enable withHandler:(void (^)(float meter, BOOL testing))testMicHandler;

- (void)testSpeaker:(BOOL)enable withHandler:(void (^)(float meter, BOOL testing))testSpeakerHandler;

- (BOOL)isInCall;

- (void)setCameraStreamMirror:(BOOL)isMirror;

- (NSString *)getDefaultCamera;

NS_ASSUME_NONNULL_END

@end
