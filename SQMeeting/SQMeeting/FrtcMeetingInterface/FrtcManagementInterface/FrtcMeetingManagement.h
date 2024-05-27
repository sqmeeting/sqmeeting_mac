#import <Foundation/Foundation.h>
#import "FrtcManagement.h"
#import "LoginModel.h"
#import "SetupMeetingModel.h"
#import "ScheduledModelArray.h"
#import "UserListModel.h"
#import "UserDetailModel.h"
#import "MeetingRooms.h"
#import "ScheduleSuccessModel.h"
#import "ScheduleGroupModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FrtcMeetingManagement : NSObject

+ (FrtcMeetingManagement *)sharedFrtcMeetingManagement;

#pragma mark --login--
- (void)frtcLoginWithUserName:(NSString *)userName
                 withPassword:(NSString *)password
                 loginSuccess:(nullable void (^)(LoginModel *model))loginSuccess
                 loginFailure:(nullable void (^)(NSError *error))loginFailure;

- (void)frtcGetLoginUserInfomation:(NSString *)userToken
                    getInfoSuccess:(nullable void (^)(LoginModel *model))getInfoSuccess
                    getInfoFailure:(nullable void (^)(NSError *error))getInfoFailure;

- (void)frtcLogoutWithUserToken:(NSString *)userToken
                  logoutSuccess:(nullable void (^)(NSDictionary * userInfo))logoutSuccess
                  logoutFailure:(nullable void (^)(NSError *error))logoutFailure;

- (void)frtcUpdatePasswordWithUserToken:(NSString *)userToken
                            oldPassword:(NSString *)oldPassword
                            newPassword:(NSString *)newPassword
                modifyCompletionHandler:(nullable void (^)(FRTCSDKModifyPasswordResult result))completionHandler;

- (void)frtcGetAllUserList:(NSString *)userToken
                  withPage:(NSInteger)page
                withFilter:(NSString *)filter
         completionHandler:(nullable void (^)(UserListModel * allUserListModel))completionHandler
                   failure:(nullable void (^)(NSError *error))getFailure;

- (void)frtcSetupMeetingWithUsertoken:(NSString *)usertoken
                          meetingName:(NSString *)meetingName
            scheduleCompletionHandler:(nullable void (^)(SetupMeetingModel * model))completionHandler
                      scheduleFailure:(nullable void (^)(NSError *error))scheduleFailure;

- (void)frtcGetScheduledMeeting:(NSString *)usertoken
            getScheduledHandler:(nullable void (^)(ScheduledModelArray * shceduleModleArray))completionHandler
            getScheduledFailure:(nullable void (^)(NSError *error))getScheduledFailure;

- (void)frtcDeleteCurrentMeeting:(NSString *)userToken
               withReservationId:(NSString *)reservationId
                   withCancelALL:(BOOL)isCancelAll
         deleteCompletionHandler:(nullable void (^)(void))completionHandler
                   deleteFailure:(nullable void (^)(NSError *error))deleteFailure;


- (void)frtcCreateMeeting:(NSString *)userToken
          withMeetingType:(NSString *)meetingType
          withMeetingName:(NSString *)meetingName
   wtihMeetingDescription:(NSString *)meetingDescription
            withStartTime:(NSString *)startTime
              withEndTime:(NSString *)endTime
        withMeetingRoomID:(NSString *)meetingRoomID
         withCallRateType:(NSString *)callRateType
      withMeetingPassword:(NSString *)password
           withInviteUser:(NSArray<NSString *> *)inviteUsers
        withMuteUponEntry:(NSString *)muteUponEntry
          withGuestDialIn:(BOOL)guestDialIn
           withTimeToJoin:(NSInteger)timeToJoin
            withWaterMark:(BOOL)waterMask
        withWaterMarkType:(NSString *)waterMarkType
       withRecurrenceType:(NSString *)recurrenceType
   withRecurrenceInterval:(NSInteger)interval
  withRecurrenceStartTime:(NSString *)startRecurrenceTime
    withRecurrenceEndTime:(NSString *)endRecurrenceTime
   withRecurrenceStartDay:(NSString *)startRecurrenceDay
     withRecurrenceEndDay:(NSString *)endRecurrenceDay
withrecurrenceDaysOfMonth:(NSMutableArray *)recurrenceDaysOfMonth
 withrecurrenceDaysofWeek:(NSMutableArray *)recurrenceDaysOfWeek
        completionHandler:(nullable void (^)(NSDictionary * meetingInfo))completionHandler
                  failure:(nullable void (^)(NSError *error))createFailure;

- (void)frtcGetScheduleMeetingDetailInformation:(NSString *)userToken
                              withReservationID:(NSString *)reservationID
                              completionHandler:(nullable void (^)(ScheduleSuccessModel * meetingDetailModel))completionHandler
                                        failure:(nullable void (^)(NSError *error))getDetailInfoFailure;


- (void)frtcGetScheduleMeetingGroupInformation:(NSString *)userToken
                              withGroupID:(NSString *)groupID
                              completionHandler:(nullable void (^)(ScheduleGroupModel *scheduleGroupModel))completionHandler
                                       failure:(nullable void (^)(NSError *error))getDetailInfoFailure;

- (void)frtcUpdateMeetingTime:(NSString *)userToken
            withReservationID:(NSString *)reservationID
                withStartTime:(NSString *)startTime
                  withEndTime:(NSString *)endTime 
            completionHandler:(nullable void (^)(NSDictionary * meetingInfo))completionHandler
                      failure:(nullable void (^)(NSError *error))updateMeetingFailure;

- (void)frtcUpdateMeeting:(NSString *)userToken
        withReservationID:(NSString *)reservationID
           withUpdateType:(NSString *)updateType
          withMeetingType:(NSString *)meetingType
          withMeetingName:(NSString *)meetingName
   wtihMeetingDescription:(NSString *)meetingDescription
            withStartTime:(NSString *)startTime
              withEndTime:(NSString *)endTime
        withMeetingRoomID:(NSString *)meetingRoomID
         withCallRateType:(NSString *)callRateType
      withMeetingPassword:(NSString *)password
           withInviteUser:(NSArray<NSString *> *)inviteUsers
        withMuteUponEntry:(NSString *)muteUponEntry
          withGuestDialIn:(BOOL)guestDialIn
           withTimeToJoin:(NSInteger)timeToJoin
            withWaterMark:(BOOL)waterMask
        withWaterMarkType:(NSString *)waterMarkType
       withRecurrenceType:(NSString *)recurrenceType
   withRecurrenceInterval:(NSInteger)interval
  withRecurrenceStartTime:(NSString *)startRecurrenceTime
    withRecurrenceEndTime:(NSString *)endRecurrenceTime
   withRecurrenceStartDay:(NSString *)startRecurrenceDay
     withRecurrenceEndDay:(NSString *)endRecurrenceDay
withrecurrenceDaysOfMonth:(NSMutableArray *)recurrenceDaysOfMonth
 withrecurrenceDaysofWeek:(NSMutableArray *)recurrenceDaysOfWeek
        completionHandler:(nullable void (^)(NSDictionary * meetingInfo))completionHandler
                  failure:(nullable void (^)(NSError *error))updateMeetingFailure;

- (void)frtcAddMeetingListFromUrl:(NSString *)userToken
                meetingIdentifier:(NSString *)meetingIdentifier
                completionHandler:(nullable void (^)(NSDictionary * meetingInfo))completionHandler
                          failure:(nullable void (^)(NSError *error))addMeetingListFailure;

- (void)frtcRemoveMeetingListFromUrl:(NSString *)userToken
                   meetingIdentifier:(NSString *)meetingIdentifier
                   completionHandler:(nullable void (^)(NSDictionary * meetingInfo))completionHandler
                             failure:(nullable void (^)(NSError *error))removeMeetingListFailure;

- (void)frtcMuteParticipant:(NSString *)usertoken
              meetingNumber:(NSString *)meetingNumber
            allowSelfUnmute:(BOOL)allowSelfUnmute
            participantList:(NSArray<NSString *> *)participantList
      muteCompletionHandler:(nullable void (^)(void))completionHandler
             muteAllFailure:(nullable void (^)(NSError *error))muteAllFailure;

- (void)frtcMuteAllParticipants:(NSString *)usertoken
                  meetingNumber:(NSString *)meetingNumber
                           mute:(BOOL)allowSelfUnmute
       muteAllCompletionHandler:(nullable void (^)(void))completionHandler
                 muteAllFailure:(nullable void (^)(NSError *error))muteAllFailure;

- (void)frtcUnMuteAllParticipants:(NSString *)usertoken
                    meetingNumber:(NSString *)meetingNumber
         muteAllCompletionHandler:(nullable void (^)(void))completionHandler
                   muteAllFailure:(nullable void (^)(NSError *error))muteAllFailure;

- (void)frtcUnMuteParticipant:(NSString *)usertoken
                meetingNumber:(NSString *)meetingNumber
              participantList:(NSArray<NSString *> *)participantList
        muteCompletionHandler:(nullable void (^)(void))completionHandler
               muteAllFailure:(nullable void (^)(NSError *error))muteAllFailure;

- (void)frtcOwnerStopMeeting:(NSString *)usertoken
               meetingNumber:(NSString *)meetingNumber
       stopCompletionHandler:(nullable void (^)(void))completionHandler
                 stopFailure:(nullable void (^)(NSError *error))stopMeetingFailure;

- (void)frtcQueryMeetingRoomList:(NSString *)usertoken
     queryMeetingRoomSuccess:(nullable void (^)(MeetingRooms * meetingRooms))querySuccess
     queryMeetingRoomFailure:(nullable void (^)(NSError *error))queryFailure;

- (void)frtcChangeUserNameByGuestClient:(NSString *)meetingNumber
                        withNewUserName:(NSString *)userName
            changeNameSuccessfulHandler:(nullable void (^)(void))successfulHandler
                      changeNameFailure:(nullable void (^)(NSError *error))changeFailure;

- (void)frtcChangeUserNameByLoginUser:(NSString *)usertoken
                        meetingNumber:(NSString *)meetingNumber
                              newName:(NSString *)newName
                     clientIdentifier:(NSString *)clientIdentifier
              changeSuccessfulHandler:(nullable void (^)(void))successfulHandler
                        changeFailure:(nullable void (^)(NSError *error))changeFailure;

- (void)frtcMeetingSetUserAsLecturer:(NSString *)usertoken
                       meetingNumber:(NSString *)meetingNumber
                          clientUUID:(NSString *)clientIdentifier
        setLecturerSuccessfulHandler:(nullable void (^)(void))successfulHandler
                  setLecturerFailure:(nullable void (^)(NSError *error))setMeetingLectureFailure;

- (void)frtcMeetingUnSetUserAsLecturer:(NSString *)usertoken
                       meetingNumber:(NSString *)meetingNumber
                          clientUUID:(NSString *)clientIdentifier
        setLecturerSuccessfulHandler:(nullable void (^)(void))successfulHandler
                  setLecturerFailure:(nullable void (^)(NSError *error))setMeetingLectureFailure;

- (void)frtcMeetingRmoveUserFromMeetingRoom:(NSString *)usertoken
                              meetingNumber:(NSString *)meetingNumber
                           clientIdentifier:(NSString *)clientIdentifier
             removeMeetingSuccessfulHandler:(nullable void (^)(void))successfulHandler
                       removeMeetingFailure:(nullable void (^)(NSError *error))removeFailure;

- (void)frtcMeetingStartOverlayMessage:(NSString *)usertoken
                         meetingNumber:(NSString *)meetingNumber
                      clientIdentifier:(NSString *)clientIdentifier
                 overlayMessageContent:(NSString *)content
                                repeat:(NSInteger)repeat
                              position:(NSInteger)position
                                scroll:(BOOL)isScroll
         startMessageSuccessfulHandler:(nullable void (^)(void))successfulHandler
                   startMessageFailure:(nullable void (^)(NSError *error))startFailure;

- (void)frtcMeetingStopOverlayMessage:(NSString *)usertoken
                        meetingNumber:(NSString *)meetingNumber
                     clientIdentifier:(NSString *)clientIdentifier
         stopMessageSuccessfulHandler:(nullable void (^)(void))successfulHandler
                   stopMessageFailure:(nullable void (^)(NSError *error))stopFailure;

- (void)frtcMeetingStartRecording:(NSString *)usertoken
                    meetingNumber:(NSString *)meetingNumber
                 clientIdentifier:(NSString *)clientIdentifier
            startRecordingSeccess:(nullable void (^)(void))successfulHandler
            startRecordingFailure:(nullable void (^)(NSError *error))startRecordingFailure;

- (void)frtcMeetingStopRecording:(NSString *)usertoken
                   meetingNumber:(NSString *)meetingNumber
                clientIdentifier:(NSString *)clientIdentifier
         stopRecordingSuccessful:(nullable void (^)(void))successfulHandler
            stopRecordingFailure:(nullable void (^)(NSError *error))stopRecordingFailure;

- (void)frtcMeetingStartStreaming:(NSString *)usertoken
                    meetingNumber:(NSString *)meetingNumber
                streamingPassword:(NSString *)password
                 clientIdentifier:(NSString *)clientIdentifier
            startStreamingSeccess:(nullable void (^)(void))successfulHandler
            startStreamingFailure:(nullable void (^)(NSError *error))startStreamingFailure;

- (void)frtcMeetingStopStreaming:(NSString *)usertoken
                   meetingNumber:(NSString *)meetingNumber
                clientIdentifier:(NSString *)clientIdentifier
         stopStreamingSuccessful:(nullable void (^)(void))successfulHandler
            stopStreamingFailure:(nullable void (^)(NSError *error))stopStreamingFailure;

- (void)frtcMeetingRequestUnmute:(NSString *)usertoken
                   meetingNumber:(NSString *)meetingNumber
                clientIdentifier:(NSString *)clientIdentifier
         requestUnmuteSuccessful:(nullable void (^)(void))successfulHandler
            requestUnmuteFailure:(nullable void (^)(NSError *error))requestUnmuteFailure;

- (void)frtcMeetingAllowUnmute:(NSString *)usertoken
                 meetingNumber:(NSString *)meetingNumber
              clientIdentifier:(NSArray  *)clientIdentifierArray
         allowUnmuteSuccessful:(nullable void (^)(void))successfulHandler
            allowUnmuteFailure:(nullable void (^)(NSError *error))allowUnmuteFailure;

- (void)frtcMeetingPin:(NSString *)usertoken
         meetingNumber:(NSString *)meetingNumber
      clientIdentifier:(NSArray *)clientIdentifierArray
         pinSuccessful:(nullable void (^)(void))successfulHandler
            pinFailure:(nullable void (^)(NSError *error))pinFailure;

- (void)frtcMeetingUnPin:(NSString *)usertoken
           meetingNumber:(NSString *)meetingNumber
         unPinSuccessful:(nullable void (^)(void))successfulHandler
            unPinFailure:(nullable void (^)(NSError *error))unPinFailure;

@end

NS_ASSUME_NONNULL_END
