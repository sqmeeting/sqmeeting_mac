#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FrtcInCallModel : NSObject

@property (nonatomic, copy) NSString *conferenceNumber;
@property (nonatomic, copy) NSString *clientName;
@property (nonatomic, copy) NSString *conferenceName;
@property (nonatomic, copy) NSString *ownerID;
@property (nonatomic, copy) NSString *ownerName;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userToken;
@property (nonatomic, copy) NSString *conferenceStartTime;
@property (nonatomic, copy) NSString *conferencePassword;
@property (nonatomic, copy) NSString *meetingUrl;
@property (nonatomic, copy) NSString *groupMeetingUrl;
@property (nonatomic, copy) NSString *scheduleStartTime;
@property (nonatomic, copy) NSString *scheduleEndTime;
@property (nonatomic, copy) NSString *userIdentifier;
@property (nonatomic, copy) NSString *meetingType;
@property (nonatomic, assign) NSInteger recurrenceInterval;

@property (nonatomic, assign, getter=isMuteMicrophone) BOOL muteMicrophone;
@property (nonatomic, assign, getter=isMuteCamera)     BOOL muteCamera;
@property (nonatomic, assign, getter=isAuthority)      BOOL authority;
@property (nonatomic, assign, getter=isAudioOnly)      BOOL audioOnly;
@property (nonatomic, assign, getter=isLoginCall)      BOOL loginCall;

@end

NS_ASSUME_NONNULL_END
