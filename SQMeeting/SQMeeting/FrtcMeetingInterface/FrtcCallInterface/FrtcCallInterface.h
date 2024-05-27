#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "FrtcCall.h"

NS_ASSUME_NONNULL_BEGIN

@interface FrtcCallInterface : NSObject

@property (nonatomic, assign, getter=isVoiceConference)       BOOL voiceConference;
@property (nonatomic, assign, getter=isInConference)          BOOL inConference;

+ (FrtcCallInterface *)singletonFrtcCall;

- (void)setupConfiguration;

- (void)frtcJoinMeetingWithCallParam:(FRTCMeetingParameters)param
                       withAuthority:(BOOL)authority
   withJoinMeetingSuccessfulCallBack:(void (^)())joinSuccessfulCallBack
       withJoinMeetingFailureCalBack:(void(^)(FRTCMeetingStatusReason reason))joinFailureCallBack
         withRequestPasswordCallBack:(void (^)(BOOL requestError))requestPasswordCallBack;

- (void)rePopupApp;

- (void)frtcSendPassword:(NSString *)password;

- (void)endMeeting;

- (void)stopReConnect;

- (void)videoMute:(BOOL)mute;

- (void)audioMute:(BOOL)mute;

- (void)switchGridMode:(BOOL)galleryMode;

- (void)hideLocalView:(BOOL)hide;

- (void)enableOrDisableReceiveMeetingReminder:(BOOL)enable;

- (void)toastInfomation;

@end

NS_ASSUME_NONNULL_END
