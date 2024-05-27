#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 Enum for Login result.
 */
typedef NS_ENUM(NSInteger, FRTCSDKLoginResult) {
    FRTCSDK_LOGIN_SUCCESS,
    FRTCSDK_LOGIN_ERROR_PASSWORD,
    FRTCSDK_LOGIN_SERVER_NOT_REACHABLE
};

/**
 Enum for Set sdk config key.Currently only supports configuring server addresses
 */
typedef NS_ENUM(NSUInteger, FRTCSDKConfigKey) {
    FRTCSDK_SERVER_ADDRESS,
};

/**
 Enum for Modify user password  result.
 */
typedef NS_ENUM(NSInteger, FRTCSDKModifyPasswordResult) {
    FRTCSDK_MODIFY_PASSWORD_SUCCESS,
    FRTCSDK_MODIFY_PASSWORD_FAILED
};

@interface FrtcManagement : NSObject

+ (FrtcManagement *)sharedManagement;

#pragma mark- --config--
/**
 Setting configuration parameters.For macOS, currently only supports configuring server addresses.
 
 @param key  reference enum definition.
 @param value .The type of NSString
 
 */
- (void)frtcSetSDKConfig:(FRTCSDKConfigKey)key
      withSDKConfigValue:(NSString *)value;

#pragma mark- --login--
/**
 User login through user name and password.
 
 @param userName .
 @param password .
 @param loginSuccess  a block tell user that login succcess
 @param loginFailure  a block tell user that login failure
 
 */
- (void)frtcLoginWithUserName:(NSString *)userName
                 withPassword:(NSString *)password
                 loginSuccess:(nullable void (^)(NSDictionary * userInfo))loginSuccess
                 loginFailure:(nullable void (^)(NSError *error))loginFailure;


/**
 Get User InfoMation by UserToken.
 
 @param userToken .
 @param getInfoSuccess  a block tell user that get info succcess
 @param getInfoFailure  a block tell user that get info failure
 
 */
- (void)frtcGetLoginUserInfomation:(NSString *)userToken
                    getInfoSuccess:(nullable void (^)(NSDictionary * userInfo))getInfoSuccess
                    getInfoFailure:(nullable void (^)(NSError *error))getInfoFailure;
/**
 User log out.
 
 @param userToken .
 @param logoutSuccess  a block tell user that logout succcess
 @param logoutFailure  a block tell user that logout failure
 
 */
- (void)frtcLogoutWithUserToken:(NSString *)userToken
                  logoutSuccess:(nullable void (^)(NSDictionary * userInfo))logoutSuccess
                  logoutFailure:(nullable void (^)(NSError *error))logoutFailure;

/**
 Modify User  Password.
 
 @param userToken .
 @param oldPassword Client should pass old password to interface function
 @param newPassword Client should pass new password to interface function
 @param completionHandler  a block tell user that Modify Password succcess or failure
 
 */
- (void)frtcModifyUserPasswordWithUserToken:(NSString *)userToken
                                oldPassword:(NSString *)oldPassword
                                newPassword:(NSString *)newPassword
                    modifyCompletionHandler:(nullable void (^)(FRTCSDKModifyPasswordResult result))completionHandler;

#pragma mark- --Call Meeting--
/**
 Schedule a  Meeting.
 
 @param usertoken .Client need pass the usertoken to sdk
 @param meetingName .Client make a meeting name, and the name length is less than 48 characters.
 @param completionHandler  a block tell user that schedule a meeting succcess.
 @param scheduleFailure a block tell user that schedule a meeting failure.
 
 */
- (void)frtcScheduleMeetingWithUsertoken:(NSString *)usertoken
                             meetingName:(NSString *)meetingName
               scheduleCompletionHandler:(nullable void (^)(NSDictionary * meetingInfo))completionHandler
                         scheduleFailure:(nullable void (^)(NSError *error))scheduleFailure;

/**
 Query Meeting Room List.
 
 @param usertoken .Client need pass the usertoken to sdk
 @param querySuccess  A block tell user that query meeting room succcess and include call room infomation.
 @param queryFailure  A block tell user that query a meeting room failure.
 
 */
- (void)frtcQueryMeetingRoomList:(NSString *)usertoken
         queryMeetingRoomSuccess:(nullable void (^)(NSDictionary * meetingRoom))querySuccess
         queryMeetingRoomFailure:(nullable void (^)(NSError *error))queryFailure;

/**
 Get Scheduled Meeting List.
 
 @param usertoken .Client need pass the usertoken to sdk
 @param completionHandler  A block tell user that query shcedule meeting list  succcess and include all meeting list.
 @param getScheduledFailure  A block tell user that query scheduled meeting list failure.
 
 */
- (void)frtcGetScheduledMeeting:(NSString *)usertoken
            getScheduledHandler:(nullable void (^)(NSDictionary * scheduledMeetingInfo))completionHandler
            getScheduledFailure:(nullable void (^)(NSError *error))getScheduledFailure;

/**
 Delete Non-Current Meeting.
 
 @param userToken .Client need pass the usertoken to sdk
 @param reservationId .Client need pass the schedule meeting reservationId to sdk
 @param completionHandler  A block tell user that delete meeting room succcess and include call room infomation.
 @param deleteFailure  A block tell user that delete a meeting  failure.
 
 */
- (void)frtcDeleteCurrentMeeting:(NSString *)userToken
               withReservationId:(NSString *)reservationId
                   withCancelALL:(BOOL)isCancelAll
            deleteCompletionHandler:(nullable void (^)(void))completionHandler
                      deleteFailure:(nullable void (^)(NSError *error))deleteFailure;

/**
 Get User List
 
 @param userToken .Client need pass the usertoken to sdk
 @param page Which page to get user List
 @param filter serach key word. if do not serach ,the filter should be ""
 @param completionHandler  A block tell user that get all user list  succcess .
 @param getFailure  A block tell user that get user list  failure.
 
 */
- (void)frtcGetUserList:(NSString *)userToken
               withPage:(NSInteger)page
             withFilter:(NSString *)filter
      completionHandler:(nullable void (^)(NSDictionary * allUserListInfo))completionHandler
                failure:(nullable void (^)(NSError *error))getFailure;

/**
 Create Schedule Meeting
 
 @param userToken Client need pass the usertoken to sdk
 @param meetingParams Client need pass the create meeting params.
 @param completionHandler  A block tell user that get all user list  succcess .
 @param createFailure  A block tell user that create meeting  failure.
 
 */
- (void)frtcCreateMeeting:(NSString *)userToken
        withMeetingParams:(NSDictionary *)meetingParams
        completionHandler:(nullable void (^)(NSDictionary * meetingInfo))completionHandler
                  failure:(nullable void (^)(NSError *error))createFailure;

/**
 Get One Schedule Meeting Detail Information
 
 @param userToken Client need pass the usertoken to sdk
 @param reservationID Client need pass the create meeting params.
 @param completionHandler  A block tell user that get all user list  succcess .
 @param getDetailInfoFailure  A block tell user that create meeting  failure.
 
 */
- (void)frtcGetScheduleMeetingDetailInformation:(NSString *)userToken
                              withReservationID:(NSString *)reservationID
                              completionHandler:(nullable void (^)(NSDictionary * meetingInfo))completionHandler
                                        failure:(nullable void (^)(NSError *error))getDetailInfoFailure;

- (void)frtcGetScheduleMeetingGroupInformation:(NSString *)userToken
                                   withGroupID:(NSString *)groupID
                              completionHandler:(nullable void (^)(NSDictionary * meetingInfo))completionHandler
                                        failure:(nullable void (^)(NSError *error))getDetailInfoFailure;

/**
 Upate One Schedule Meeting  Information
 
 @param userToken Client need pass the usertoken to sdk
 @param reservationID Client need pass the create meeting params.
 @param meetingParams Client need pass the create meeting params.
 @param completionHandler  A block tell user that get all user list succcess .
 @param updateMeetingFailure  A block tell user that create meeting failure.
 
 */
- (void)frtcUpdateScheduleMeeting:(NSString *)userToken
                withReservationID:(NSString *)reservationID
                withMeetingParams:(NSDictionary *)meetingParams
                completionHandler:(nullable void (^)(NSDictionary * meetingInfo))completionHandler
                          failure:(nullable void (^)(NSError *error))updateMeetingFailure;

- (void)frtcUpdateRecurrenceScheduleMeeting:(NSString *)userToken
                          withReservationID:(NSString *)reservationID
                          withMeetingParams:(NSDictionary *)meetingParams
                          completionHandler:(nullable void (^)(NSDictionary * meetingInfo))completionHandler
                                    failure:(nullable void (^)(NSError *error))updateMeetingFailure;

- (void)frtcAddMeetingList:(NSString *)userToken
         meetingIdentifier:(NSString *)meetingIdentifier
         completionHandler:(nullable void (^)(NSDictionary * meetingInfo))completionHandler
                   failure:(nullable void (^)(NSError *error))addMeetingListFailure;

- (void)frtcRemoveMeetingList:(NSString *)userToken
         meetingIdentifier:(NSString *)meetingIdentifier
         completionHandler:(nullable void (^)(NSDictionary * meetingInfo))completionHandler
                   failure:(nullable void (^)(NSError *error))removeMeetingListFailure;


#pragma mark- --Mute Participants--
/**
 Mute All Participants
 
 @param usertoken .Client need pass the usertoken to sdk
 @param meetingNumber  Current Meeting Number.
 @param allowSelfUnmute  Allow user if they can unmute by themself.
 @param completionHandler  A block tell user that query meeting room succcess and include call room infomation.
 @param muteAllFailure  A block tell user that query a meeting room failure.
 
 */
- (void)frtcMuteAllParticipants:(NSString *)usertoken
                  meetingNumber:(NSString *)meetingNumber
                           mute:(BOOL)allowSelfUnmute
       muteAllCompletionHandler:(nullable void (^)(void))completionHandler
                 muteAllFailure:(nullable void (^)(NSError *error))muteAllFailure;


/**
 Mute One or All Participants.
 
 @param usertoken .Client need pass the usertoken to sdk
 @param meetingNumber  Current Meeting Number.
 @param allowSelfUnmute  Allow user if they can unmute by themself.
 @param participantList One or Some User will be muted.
 @param completionHandler  A block tell user that query meeting room succcess and include call room infomation.
 @param muteAllFailure  A block tell user that query a meeting room failure.
 
 */
- (void)frtcMuteParticipant:(NSString *)usertoken
              meetingNumber:(NSString *)meetingNumber
            allowSelfUnmute:(BOOL)allowSelfUnmute
            participantList:(NSArray<NSString *> *)participantList
      muteCompletionHandler:(nullable void (^)(void))completionHandler
             muteAllFailure:(nullable void (^)(NSError *error))muteAllFailure;

/**
 Unmute All Participants
 
 @param usertoken .Client need pass the usertoken to sdk
 @param meetingNumber  Current Meeting Number.
 @param completionHandler  A block tell user that query meeting room succcess and include call room infomation.
 @param muteAllFailure  A block tell user that query a meeting room failure.
 
 */
- (void)frtcUnMuteAllParticipants:(NSString *)usertoken
                    meetingNumber:(NSString *)meetingNumber
         muteAllCompletionHandler:(nullable void (^)(void))completionHandler
                   muteAllFailure:(nullable void (^)(NSError *error))muteAllFailure;

/**
 Unmute One or All Participants.
 
 @param usertoken .Client need pass the usertoken to sdk
 @param meetingNumber  Current Meeting Number.
 @param participantList One or Some User will be muted.
 @param completionHandler  A block tell user that query meeting room succcess and include call room infomation.
 @param muteAllFailure  A block tell user that query a meeting room failure.
 
 */
- (void)frtcUnMuteParticipant:(NSString *)usertoken
                meetingNumber:(NSString *)meetingNumber
              participantList:(NSArray<NSString *> *)participantList
        muteCompletionHandler:(nullable void (^)(void))completionHandler
               muteAllFailure:(nullable void (^)(NSError *error))muteAllFailure;

/**
 As Meeting Owner Could Stop The Meeting .
 
 @param usertoken .Client need pass the usertoken to sdk
 @param meetingNumber  Current Meeting Number.
 @param completionHandler  A block tell user that query meeting room succcess and include call room infomation.
 @param stopMeetingFailure  A block tell user that query a meeting room failure.
 
 */
- (void)frtcOwnerStopMeeting:(NSString *)usertoken
               meetingNumber:(NSString *)meetingNumber
       stopCompletionHandler:(nullable void (^)(void))completionHandler
          stopMeetingFailure:(nullable void (^)(NSError *error))stopMeetingFailure;

/**
 As a guest in the Meeting Could Modify your own name
 
 @param meetingNumber  Current Meeting Number.
 @param newUserName .Client need pass the usertoken to sdk
 @param successfulHandler  A block tell user that modify your own name.
 @param changeFailure  A block tell user that modify your own name failure.
 
 */
- (void)frtcChangeUserNameByGuest:(NSString *)meetingNumber
                      withNewName:(NSString *)newUserName
          changeSuccessfulHandler:(nullable void (^)(void))successfulHandler
                    changeFailure:(nullable void (^)(NSError *error))changeFailure;

/**
 As a Sign in User in the Meeting Modify names
 
 @param usertoken .Client need pass the usertoken to sdk
 @param meetingNumber  Current Meeting Number.
 @param newName .New Name for the user.
 @param successfulHandler  A block tell user that modify your own name.
 @param changeFailure  A block tell user that modify your own name failure.
 
 */
- (void)frtcChangeUserNameByLoginUser:(NSString *)usertoken
                        meetingNumber:(NSString *)meetingNumber
                              newName:(NSString *)newName
                     clientIdentifier:(NSString *)clientIdentifier
              changeSuccessfulHandler:(nullable void (^)(void))successfulHandler
                        changeFailure:(nullable void (^)(NSError *error))changeFailure;

- (void)frtcSetUserAsLecturer:(NSString *)usertoken
                meetingNumber:(NSString *)meetingNumber
             clientIdentifier:(NSString *)clientIdentifier
      setLecturerSuccessfulHandler:(nullable void (^)(void))successfulHandler
                setLecturerFailure:(nullable void (^)(NSError *error))changeFailure;

- (void)frtcUnSetLecture:(NSString *)usertoken
           meetingNumber:(NSString *)meetingNumber
        clientIdentifier:(NSString *)clientIdentifier
 unSetLecturerSuccessfulHandler:(nullable void (^)(void))successfulHandler
           unSetLecturerFailure:(nullable void (^)(NSError *error))changeFailure;

- (void)frtcRmoveUserFromMeetingRoom:(NSString *)usertoken
                       meetingNumber:(NSString *)meetingNumber
                    clientIdentifier:(NSString *)clientIdentifier
      removeMeetingSuccessfulHandler:(nullable void (^)(void))successfulHandler
                removeMeetingFailure:(nullable void (^)(NSError *error))removeFailure;

- (void)frtcStartOverlayMessage:(NSString *)usertoken
                  meetingNumber:(NSString *)meetingNumber
               clientIdentifier:(NSString *)clientIdentifier
       withMessageOverlayParams:(NSDictionary *)overlayMessageParams
  startMessageSuccessfulHandler:(nullable void (^)(void))successfulHandler
            startMessageFailure:(nullable void (^)(NSError *error))startFailure;

- (void)frtcStopOverlayMessage:(NSString *)usertoken
                 meetingNumber:(NSString *)meetingNumber
              clientIdentifier:(NSString *)clientIdentifier
  stopMessageSuccessfulHandler:(nullable void (^)(void))successfulHandler
            stopMessageFailure:(nullable void (^)(NSError *error))stopFailure;

- (void)frtcStartRecording:(NSString *)usertoken
             meetingNumber:(NSString *)meetingNumber
          clientIdentifier:(NSString *)clientIdentifier
     startRecordingSeccess:(nullable void (^)(void))successfulHandler
     startRecordingFailure:(nullable void (^)(NSError *error))startRecordingFailure;

- (void)frtcStopRecording:(NSString *)usertoken
            meetingNumber:(NSString *)meetingNumber
         clientIdentifier:(NSString *)clientIdentifier
  stopRecordingSuccessful:(nullable void (^)(void))successfulHandler
     stopRecordingFailure:(nullable void (^)(NSError *error))stopRecordingFailure;

- (void)frtcStartStreaming:(NSString *)usertoken
             meetingNumber:(NSString *)meetingNumber
         streamingPassword:(NSString *)password
          clientIdentifier:(NSString *)clientIdentifier
     startStreamingSeccess:(nullable void (^)(void))successfulHandler
     startStreamingFailure:(nullable void (^)(NSError *error))startStreamingFailure;

- (void)frtcStopStreaming:(NSString *)usertoken
            meetingNumber:(NSString *)meetingNumber
         clientIdentifier:(NSString *)clientIdentifier
  stopStreamingSuccessful:(nullable void (^)(void))successfulHandler
     stopStreamingFailure:(nullable void (^)(NSError *error))stopStreamingFailure;

- (void)frtcRequestUnmute:(NSString *)usertoken
            meetingNumber:(NSString *)meetingNumber
         clientIdentifier:(NSString *)clientIdentifier
  requestUnmuteSuccessful:(nullable void (^)(void))successfulHandler
     requestUnmuteFailure:(nullable void (^)(NSError *error))requestUnmuteFailure;

- (void)frtcAllowUnmute:(NSString *)usertoken
          meetingNumber:(NSString *)meetingNumber
       clientIdentifier:(NSArray  *)clientIdentifierArray
  allowUnmuteSuccessful:(nullable void (^)(void))successfulHandler
     allowUnmuteFailure:(nullable void (^)(NSError *error))allowUnmuteFailure;

- (void)frtcPin:(NSString *)usertoken
  meetingNumber:(NSString *)meetingNumber
clientIdentifier:(NSArray *)clientIdentifierArray
  pinSuccessful:(nullable void (^)(void))successfulHandler
     pinFailure:(nullable void (^)(NSError *error))pinFailure;

- (void)frtcUnPin:(NSString *)usertoken
    meetingNumber:(NSString *)meetingNumber
  unPinSuccessful:(nullable void (^)(void))successfulHandler
     unPinFailure:(nullable void (^)(NSError *error))unPinFailure;



@end

NS_ASSUME_NONNULL_END
