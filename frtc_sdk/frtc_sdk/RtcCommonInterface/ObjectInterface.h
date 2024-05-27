#ifndef ObjectInterface_h
#define ObjectInterface_h

#include "object_impl.h"
#include "content_audio_interface.h"
#include "util_mac.h"
#import "UserBasicInformation.h"
#import "FrtcCall.h"
#import <Foundation/Foundation.h>

typedef enum {
    kIdle = 0,
    kConnected,
    kDisconnected
} CallMeetingStatus;

typedef struct {
    NSMutableArray<UserBasicInformation *> *layout;
    bool bContent;
    NSString *activeMediaID;
    NSString *activeSpeakerUuId;
    NSString *cellCustomUUID;
} SDKLayoutInfo;

typedef void (^MeetingStatusCallBack)(CallMeetingStatus callMeetingStatus, int reason);
typedef void (^RequestPassWordCallBack)();
typedef void (^MeetingParamsCallBack)(NSString *uri, NSString *meetingID, NSString *displayName, NSString *ownerID, NSString *ownerName, NSString *meetingUrl, NSString * groupMeetingUrl, const long long scheduleStartTime,
                              const long long scheduleEndTime);
typedef void (^VideoFrozenBlock)(NSString *mediaID, BOOL bFrozen);
typedef void (^LayoutChangedBlock)(SDKLayoutInfo buffer);
typedef void (^WaterMaskCallBack)(NSString *waterMaskString);
typedef void (^VideoReceivedBlock)(NSString *mediaID);
typedef void (^AudioReceivedBlock)(NSString *mediaID);
typedef void (^ContentStreamRequestBlock)(NSString *mediaID, int width, int height, int framerate);
typedef void (^VideoRemovedBlock)(NSString *mediaID);
typedef void (^MicMeterBlock)(float meter);

@protocol ObjectInterfaceDelegate <NSObject>

@optional;
- (void)contentStateChanged:(BOOL)isSending;

- (void)muteStateChanged:(NSMutableArray *)array;

- (void)onVideoRemoved:(NSString *)mediaID;

@end

@interface ObjectInterface : NSObject {
    ObjectImpl *_impl;
    ContentAudioInterface *_audioCeObject;
    ShareAPP::ApplicationQueue _applicationQueue;
}

@property (nonatomic, copy) MeetingStatusCallBack statusCallBack;

@property (nonatomic, copy) RequestPassWordCallBack passwordBack;

@property (nonatomic, copy) MeetingParamsCallBack paramsCallBack;

@property (nonatomic ,copy) LayoutChangedBlock layoutChangedBlock;

@property (nonatomic, copy) WaterMaskCallBack waterMaskCallBack;

@property (nonatomic, copy) VideoReceivedBlock videoReceivedBlock;

@property (nonatomic, copy) AudioReceivedBlock audioReceivedBlock;

@property (nonatomic, copy) VideoFrozenBlock videoFrozenBlock;

@property (nonatomic, copy) ContentStreamRequestBlock contentRequestBlock;

@property (nonatomic, copy) VideoRemovedBlock videoRemovedBlock;

@property (nonatomic, copy) MicMeterBlock micMeterBlock;

@property (nonatomic, weak) id <ObjectInterfaceDelegate>  delegate;

@property (nonatomic, strong) NSMutableArray<NSString *> *rosterListArray;

@property (nonatomic, strong) NSMutableArray<NSString *> *tempRosterListArray;

@property (nonatomic, assign, getter = isSendAppContent) BOOL sendAppContent;

@property (nonatomic, copy) NSString *pinUUID;

@property (nonatomic, copy) NSString *lectureUUID;

@property (nonatomic, copy) NSString *disPlayName;

@property (nonatomic, assign) bool is_video_muted;

@property (nonatomic, assign) bool is_audio_muted;

@property (nonatomic, assign, getter=shareContentType) int shareContentType;

@property (nonatomic, assign, getter=isSendContentAudio) BOOL sendContentAudio;

@property (nonatomic, assign, getter=isSendingContent)   BOOL sendingContent;

@property (nonatomic, assign) uint32_t windowID;

@property (nonatomic, weak) id<FrtcCallDelegate> callDelegate;

+ (ObjectInterface*)sharedObjectInterface;

- (void)OnObjectMeetingJoinInfoCallBack:(const std::string&)meeting_name
                             meeting_id:(const std::string&)meeting_id
                           display_name:(const std::string&)display_name
                               owner_id:(const std::string&)owner_id
                             owner_name:(const std::string&)owner_name
                            meeting_url:(const std::string&)meeting_url
                      group_meeting_url:(const std::string&)group_meeting_url
                             start_time:(const long long )start_time
                               end_time:(const long long )end_time;

- (void)OnObjectMeetingStatusChangeCallBack:(RTC::MeetingStatus)status reason:(int)reason;

- (void)OnObjectParticipantCountCallBack:(int)parti_count;

- (void)OnObjectParticipantListCallBack:(const std::set<std::string> &)uuid_list;

- (void)OnObjectParticipantStatusChangeCallBack:(std::map<std::string, RTC::ParticipantStatus>)roster_list isFulllist:(bool)is_full;

- (void)OnObjectRequestVideoStreamCallBack:(const std::string&)msid width:(int)width height:(int)height framerate:(float)frame_rate;

- (void)OnObjectAddVideoStreamCallBack:(const std::string&)msid;

- (void)OnObjectDetectAudioMuteCallBack;

- (void)OnObjectTextOverlayCallBack:(RTC::TextOverlay *)text_overly;

- (void)OnObjectMeetingSessionStatusCallBack:(std::string)watermark_msg
                            recording_status:(std::string)recording_status
                            streaming_status:(std::string)streaming_status
                               streaming_url:(std::string)streaming_url
                               streaming_pwd:(std::string)streaming_pwd; 

- (void)OnObjectUnmuteRequestCallBack:(const std::map<std::string, std::string>&)parti_list;

- (void)OnObjectUnmuteAllowCallBack;

- (void)OnObjectMuteLockCallBack:(bool)muted allow_self_unmute:(bool)allow_self_unmute;

- (void)OnObjectContentStatusChangeCallBack:(BOOL)isSending;

- (void)OnObjectLayoutChangeCallBack:(const RTC::LayoutDescription&) layout;

- (void)OnObjectLayoutSettingCallBack:(int)max_cell_count lectures:(const std::vector<std::string>&) lectures;

- (void)OnObjectPasscodeRequestCallBack;

- (void)OnObjectDeleteVideoStreamCallBack:(const std::string&)msid;

- (void)audioReveived:(const std::string&)mediaID;

- (void)onContentPriorityChangeResponse:(std::string)status withKey:(std::string)transactionKey;

- (void)joinMeetingWithServerAddress:(NSString *)serverAddress
                     conferenceAlias:(NSString *)meetingAlias
                          clientName:(NSString *)displayName
                           userToken:(NSString *)userToken
                            callRate:(int)callRate
                     meetingPassword:(NSString *)meetingPassword
                             isLogin:(BOOL)isLogin
                              userId:(NSString *)userId
               meetingStatusCallBack:(void (^)(CallMeetingStatus callMeetingStatus, int reason))statusCallBack
               meetingParamsCallBack:(void (^)(NSString *conferenceName, NSString *meetingID, NSString *displayName, NSString *ownerID, NSString *ownerName, NSString *meetingUrl, NSString *groupMeetingUrl, const long long scheduleStartTime,
                                     const long long scheduleEndTime))paramsCallBack
             requestPasswordCallBack:(void(^)(void))passwordCallBack
             remoteLayoutChangeBlock:(void (^)(SDKLayoutInfo buffer))layoutChangedBlock
                   waterMaskCallBack:(void (^)(NSString *waterMaskString))waterMaskBlock
            remoteVideoReceivedBlock:(void (^)(NSString *mediaID))videoReceivedBlock
            remoteAudioReceivedBlock:(void (^)(NSString *mediaID))audioReceivedBlock
           contentStreamRequestBlock:(void (^)(NSString *mediaID, int width, int height, int framerate))contentRequestBlock
                    videoFrozenBlock:(void (^)(NSString *mediaID, BOOL bFrozen))videoFrozenBlock
                       micMeterBlock:(void (^)(float meter))micMeterBlock;

- (void)endMeetingWithCallIndex:(int)callIndex;


- (void)sendVideoFrameObject:(NSString *)mediaID
                 videoBuffer:(void *)buffer
                      length:(size_t)length
                       width:(size_t)width
                      height:(size_t)height
             videoSampleType:(RTC::VideoColorFormat)type;

- (void)receiveVideoFrameObject:(NSString *)mediaID
                         buffer:(void **)buffer
                         length:(unsigned int* )length
                          width:(unsigned int* )width
                         height:(unsigned int*)height;

- (void)resetVideoFrameObject:(NSString *)mediaID;

- (void)startSendContentStream:(NSString *)mediaID
                   videoBuffer:(void *)buffer
                        length:(size_t)length
                         width:(size_t)width
                        height:(size_t)height
                        stride:(size_t)stride
               videoSampleType:(RTC::VideoColorFormat)type;


- (void)sendAudioFrameObject:(void*)buffer
                      length:(unsigned int )length
                 sampleRatge:(unsigned int)sample_rate;

- (void)receiveAudioFrameObject:(void *)buffer
                     dataLength:(unsigned int)length
                     sampleRate:(unsigned int)sample_rate;

- (void)startSendContentObject;

- (void)stopSendContentObject;

- (void)setContentAudioObject:(bool)enable sameDevice:(bool)isSameDevice;

- (void)sendContentAudioFrameObject:(NSString *)mediaID
                        videoBuffer:(void *)buffer
                             length:(unsigned int)length
                         sampleRate:(unsigned int)sample_rate;

- (void)muteLocalVideoObject:(bool)muted;

- (void)shareContent:(BOOL)isShareContent
     withContentType:(int)shareContentType
       withDesktopID:(uint32_t)desktopId
        withWindowID:(unsigned int)appWindowID
  withAppContentName:(NSString *)sourceAppContentName
    withContentAudio:(BOOL)sendContentAudio;

- (void)SetCameraStreamMirrorObject:(bool)is_mirror;

- (void)sendContentAudioFrame:(short *)buffer sampleRate:(int)sampleRate;

- (void)clearContentAudio;

- (void)muteLocalAudioObject:(bool)muted;

- (void)setLayoutGridModeObject:(bool)gridMode;

- (void)setIntelligentNoiseReductionObject:(bool)enable;

- (void)setCameraCapabilityObject:(std::string)resolution_str;

- (void)verifyPasscodeObject:(NSString *)passcode;

- (NSString *)getMediaStatisticsObject;

- (NSInteger)startUploadLogsObject:(NSString *)metaData
                          fileName:(NSString *)fileName
                         fileCount:(int)fileCount;

- (NSString *)getUploadStatusObject:(int)tractionId;

- (void)cancelUploadLogsObject:(int)tractionId;

- (NSString *)onDeviceName;

- (int)getCPULevelObject;

- (NSString*)getVersion;

- (NSArray *)getApplicationList;



@end

#endif
