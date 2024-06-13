#import "FrtcMeetingManagement.h"
#import "ScheduledModelArray.h"
#import "ScheduleSuccessModel.h"

static FrtcMeetingManagement *sharedFrtcMeetingManagement = nil;

@implementation FrtcMeetingManagement

+ (FrtcMeetingManagement *)sharedFrtcMeetingManagement {
    if (sharedFrtcMeetingManagement == nil) {
        @synchronized(self) {
            if (sharedFrtcMeetingManagement == nil) {
                sharedFrtcMeetingManagement = [[FrtcMeetingManagement alloc] init];
            }
        }
    }
    
    return sharedFrtcMeetingManagement;
}

- (void)frtcLoginWithUserName:(NSString *)userName
                 withPassword:(NSString *)password
                 loginSuccess:(nullable void (^)(LoginModel *model))loginSuccess
                 loginFailure:(nullable void (^)(NSError *error))loginFailure {
    [[FrtcManagement sharedManagement] frtcLoginWithUserName:userName withPassword:password loginSuccess:^(NSDictionary * _Nonnull userInfo) {
        [[FrtcUserDefault defaultSingleton] setObject:userInfo[@"user_token"] forKey:USER_TOKEN];
        
        LoginModel *model = [[LoginModel alloc] init];
        
        model.department = userInfo[@"department"];
        model.email      = userInfo[@"email"];
        model.firstname  = userInfo[@"firstname"];
        model.lastname   = userInfo[@"lastname"];
        
        model.mobile     = userInfo[@"mobile"];
        model.role       = userInfo[@"role"];
        model.user_id    = userInfo[@"user_id"];
        model.user_token = userInfo[@"user_token"];
        model.username   = userInfo[@"username"];
        model.realName   = userInfo[@"real_name"];
        model.passwordExpiredTime = userInfo[@"password_expired_time"];
        model.securityLevel = userInfo[@"security_level"];
         
        loginSuccess(model);
    } loginFailure:loginFailure];
}

- (void)frtcGetLoginUserInfomation:(NSString *)userToken
                    getInfoSuccess:(nullable void (^)(LoginModel *model))getInfoSuccess
                    getInfoFailure:(nullable void (^)(NSError *error))getInfoFailure {
    [[FrtcManagement sharedManagement] frtcGetLoginUserInfomation:userToken getInfoSuccess:^(NSDictionary * _Nonnull userInfo) {
        [[FrtcUserDefault defaultSingleton] setObject:userInfo[@"user_token"] forKey:USER_TOKEN];
        
        NSLog(@"********************");
        NSLog(@"%@", userInfo);
        NSLog(@"********************");
        LoginModel *model = [[LoginModel alloc] init];
        
        model.department = userInfo[@"department"];
        model.email      = userInfo[@"email"];
        model.firstname  = userInfo[@"firstname"];
        model.lastname   = userInfo[@"lastname"];
        model.mobile     = userInfo[@"mobile"];
        model.role       = userInfo[@"role"];
        model.user_id    = userInfo[@"user_id"];
        model.user_token = userInfo[@"user_token"];
        model.username   = userInfo[@"username"];
        model.realName   = userInfo[@"real_name"];
        model.passwordExpiredTime = userInfo[@"password_expired_time"];
        model.securityLevel = userInfo[@"security_level"];
    
        getInfoSuccess(model);
    } getInfoFailure:getInfoFailure];
}

- (void)frtcLogoutWithUserToken:(NSString *)userToken
                  logoutSuccess:(nullable void (^)(NSDictionary * userInfo))logoutSuccess
                  logoutFailure:(nullable void (^)(NSError *error))logoutFailure {
    [[FrtcManagement sharedManagement] frtcLogoutWithUserToken:userToken logoutSuccess:^(NSDictionary * _Nonnull userInfo) {
        [[FrtcUserDefault defaultSingleton] setObject:@"" forKey:USER_TOKEN];
        logoutSuccess(userInfo);
    } logoutFailure:^(NSError * _Nonnull error) {
        logoutFailure(error);
    }];
}

- (void)frtcUpdatePasswordWithUserToken:(NSString *)userToken
                            oldPassword:(NSString *)oldPassword
                            newPassword:(NSString *)newPassword
                modifyCompletionHandler:(nullable void (^)(FRTCSDKModifyPasswordResult result))completionHandler {
    [[FrtcManagement sharedManagement] frtcModifyUserPasswordWithUserToken:userToken oldPassword:oldPassword newPassword:newPassword modifyCompletionHandler:completionHandler];
}

- (void)frtcSetupMeetingWithUsertoken:(NSString *)usertoken
                          meetingName:(NSString *)meetingName
            scheduleCompletionHandler:(nullable void (^)(SetupMeetingModel * model))completionHandler
                      scheduleFailure:(nullable void (^)(NSError *error))scheduleFailure {
    [[FrtcManagement sharedManagement] frtcScheduleMeetingWithUsertoken:usertoken meetingName:meetingName scheduleCompletionHandler:^(NSDictionary * _Nonnull meetingInfo) {
            SetupMeetingModel *model = [[SetupMeetingModel alloc] init];
        
            model.meetingName       = meetingInfo[@"meeting_name"];
            model.meetingNumber     = meetingInfo[@"meeting_number"];
            model.meetingPassword   = meetingInfo[@"meeting_password"];
            model.meetingType       = meetingInfo[@"meeting_type"];
            model.ownerID           = meetingInfo[@"owner_id"];
            model.ownerName         = meetingInfo[@"owner_name"];
        
            completionHandler(model);
        } scheduleFailure:^(NSError * _Nonnull error) {
            scheduleFailure(error);
    }];
}

- (void)frtcMuteParticipant:(NSString *)usertoken
              meetingNumber:(NSString *)meetingNumber
            allowSelfUnmute:(BOOL)allowSelfUnmute
            participantList:(NSArray<NSString *> *)participantList
      muteCompletionHandler:(nullable void (^)(void))completionHandler
             muteAllFailure:(nullable void (^)(NSError *error))muteAllFailure {
    
    [[FrtcManagement sharedManagement] frtcMuteParticipant:usertoken meetingNumber:meetingNumber allowSelfUnmute:allowSelfUnmute participantList:participantList muteCompletionHandler:^{
            completionHandler();
        } muteAllFailure:^(NSError * _Nonnull error) {
            muteAllFailure(error);
    }];
}

- (void)frtcMuteAllParticipants:(NSString *)usertoken
                  meetingNumber:(NSString *)meetingNumber
                           mute:(BOOL)allowSelfUnmute
       muteAllCompletionHandler:(nullable void (^)(void))completionHandler
                 muteAllFailure:(nullable void (^)(NSError *error))muteAllFailure {
    [[FrtcManagement sharedManagement] frtcMuteAllParticipants:usertoken meetingNumber:meetingNumber mute:allowSelfUnmute muteAllCompletionHandler:^{
            completionHandler();
        } muteAllFailure:^(NSError * _Nonnull error) {
            muteAllFailure(error);
    }];
}

- (void)frtcUnMuteAllParticipants:(NSString *)usertoken
                    meetingNumber:(NSString *)meetingNumber
         muteAllCompletionHandler:(nullable void (^)(void))completionHandler
                   muteAllFailure:(nullable void (^)(NSError *error))muteAllFailure {
    [[FrtcManagement sharedManagement] frtcUnMuteAllParticipants:usertoken meetingNumber:meetingNumber muteAllCompletionHandler:^{
            completionHandler();
        } muteAllFailure:^(NSError * _Nonnull error) {
            muteAllFailure(error);
    }];
}

- (void)frtcUnMuteParticipant:(NSString *)usertoken
                meetingNumber:(NSString *)meetingNumber
              participantList:(NSArray<NSString *> *)participantList
        muteCompletionHandler:(nullable void (^)(void))completionHandler
               muteAllFailure:(nullable void (^)(NSError *error))muteAllFailure {
    [[FrtcManagement sharedManagement] frtcUnMuteParticipant:usertoken meetingNumber:meetingNumber participantList:participantList muteCompletionHandler:^{
            completionHandler();
        } muteAllFailure:^(NSError * _Nonnull error) {
            muteAllFailure(error);
    }];
}

- (void)frtcOwnerStopMeeting:(NSString *)usertoken
               meetingNumber:(NSString *)meetingNumber
       stopCompletionHandler:(nullable void (^)(void))completionHandler
                 stopFailure:(nullable void (^)(NSError *error))stopMeetingFailure {
    [[FrtcManagement sharedManagement] frtcOwnerStopMeeting:usertoken meetingNumber:meetingNumber stopCompletionHandler:^{
            completionHandler();
        } stopMeetingFailure:^(NSError * _Nonnull error) {
            stopMeetingFailure(error);
    }];
}



- (void)frtcGetAllUserList:(NSString *)userToken
                  withPage:(NSInteger)page
                withFilter:(NSString *)filter
         completionHandler:(nullable void (^)(UserListModel * allUserListModel))completionHandler
                   failure:(nullable void (^)(NSError *error))getFailure {
    [[FrtcManagement sharedManagement] frtcGetUserList:userToken withPage:page withFilter:filter completionHandler:^(NSDictionary * _Nonnull allUserListInfo) {
        NSLog(@"--------------------------------");
        NSLog(@"%@", allUserListInfo);
        NSLog(@"--------------------------------");
        NSError *error = nil;
        UserListModel *userListModel =[[UserListModel alloc] initWithDictionary:allUserListInfo error:&error];
        completionHandler(userListModel);
        } failure:^(NSError * _Nonnull error) {
    }];
}

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
                  failure:(nullable void (^)(NSError *error))createFailure {
    NSDictionary *meetingParams;
    if([meetingType isEqualToString:@"recurrence"]) {
        meetingParams = @{
            @"meeting_type"         :   meetingType,
            @"meeting_name"         :   meetingName,
            @"meeting_description"  :   meetingDescription,
            @"schedule_start_time"  :   startTime,
            @"schedule_end_time"    :   endTime,
            @"meeting_room_id"      :   meetingRoomID,
            @"call_rate_type"       :   callRateType,
            @"meeting_password"     :   password,
            @"invited_users"        :   inviteUsers,
            @"mute_upon_entry"      :   muteUponEntry,
            @"guest_dial_in"        :   [NSNumber numberWithBool:guestDialIn],
            @"watermark"            :   [NSNumber numberWithBool:waterMask],
            @"watermark_type"       :   waterMarkType,
            @"time_to_join"         :   [NSNumber numberWithInteger:timeToJoin],
            @"recurrence_type"      :   recurrenceType,
            @"recurrenceDaysOfWeek" :   recurrenceDaysOfWeek,
            @"recurrenceDaysOfMonth":   recurrenceDaysOfMonth,
            @"recurrenceInterval"   :   [NSNumber numberWithInteger:interval],
            @"recurrenceStartTime"  :   startRecurrenceTime,
            @"recurrenceEndTime"    :   endRecurrenceTime,
            @"recurrenceStartDay"   :   startRecurrenceDay,
            @"recurrenceEndDay"     :   endRecurrenceDay
        };
    } else {
        meetingParams = @{
            @"meeting_type"         :   meetingType,
            @"meeting_name"         :   meetingName,
            @"meeting_description"  :   meetingDescription,
            @"schedule_start_time"  :   startTime,
            @"schedule_end_time"    :   endTime,
            @"meeting_room_id"      :   meetingRoomID,
            @"call_rate_type"       :   callRateType,
            @"meeting_password"     :   password,
            @"invited_users"        :   inviteUsers,
            @"mute_upon_entry"      :   muteUponEntry,
            @"guest_dial_in"        :   [NSNumber numberWithBool:guestDialIn],
            @"watermark"            :   [NSNumber numberWithBool:waterMask],
            @"watermark_type"       :   waterMarkType,
            @"time_to_join"         :   [NSNumber numberWithInteger:timeToJoin],
        };
    }

    [[FrtcManagement sharedManagement] frtcCreateMeeting:userToken withMeetingParams:meetingParams completionHandler:^(NSDictionary * _Nonnull meetingInfo) {
            NSLog(@"%@", meetingInfo);
            completionHandler(meetingInfo);
        } failure:^(NSError * _Nonnull error) {
            createFailure(error);
    }];
}

- (void)frtcGetScheduleMeetingDetailInformation:(NSString *)userToken
                              withReservationID:(NSString *)reservationID
                              completionHandler:(nullable void (^)(ScheduleSuccessModel * meetingDetailModel))completionHandler
                                        failure:(nullable void (^)(NSError *error))getDetailInfoFailure {
    [[FrtcManagement sharedManagement] frtcGetScheduleMeetingDetailInformation:userToken withReservationID:reservationID completionHandler:^(NSDictionary * _Nonnull meetingInfo) {
        NSError *error = nil;
        //UserDetailModel *userListModel =[[UserDetailModel alloc] initWithDictionary:meetingInfo error:&error];
        ScheduleSuccessModel *successful =[[ScheduleSuccessModel alloc] initWithDictionary:meetingInfo error:&error];
        completionHandler(successful);
    } failure:^(NSError * _Nonnull error) {
        getDetailInfoFailure(error);
    }];
}

- (void)frtcGetScheduleMeetingGroupInformation:(NSString *)userToken
                                   withGroupID:(NSString *)groupID
                             completionHandler:(nullable void (^)(ScheduleGroupModel *scheduleGroupModel))completionHandler
                                       failure:(nullable void (^)(NSError *error))getDetailInfoFailure {
    [[FrtcManagement sharedManagement] frtcGetScheduleMeetingGroupInformation:userToken withGroupID:groupID completionHandler:^(NSDictionary * _Nonnull meetingInfo) {
            NSLog(@"%@", meetingInfo);
        NSError *error = nil;
        ScheduleGroupModel *groupModel =[[ScheduleGroupModel alloc] initWithDictionary:meetingInfo error:&error];
            completionHandler(groupModel);
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
    }];
}

- (void)frtcUpdateMeetingTime:(NSString *)userToken
            withReservationID:(NSString *)reservationID
                withStartTime:(NSString *)startTime
                  withEndTime:(NSString *)endTime 
            completionHandler:(nullable void (^)(NSDictionary * meetingInfo))completionHandler
                      failure:(nullable void (^)(NSError *error))updateMeetingFailure {
    NSDictionary *meetingParams = @{
        @"schedule_start_time"  :   startTime,
        @"schedule_end_time"    :   endTime,
    };
    
    [[FrtcManagement sharedManagement] frtcUpdateScheduleMeeting:userToken withReservationID:reservationID withMeetingParams:meetingParams completionHandler:^(NSDictionary * _Nonnull meetingInfo) {
            completionHandler(meetingInfo);
        } failure:^(NSError * _Nonnull error) {
            updateMeetingFailure(error);
    }];
    
}

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
                  failure:(nullable void (^)(NSError *error))updateMeetingFailure {
    NSDictionary *meetingParams;
    if([updateType isEqualToString:@"recurrence"]) {
        meetingParams = @{
            @"meeting_type"         :   meetingType,
            @"meeting_name"         :   meetingName,
            @"meeting_description"  :   meetingDescription,
            @"schedule_start_time"  :   startTime,
            @"schedule_end_time"    :   endTime,
            @"meeting_room_id"      :   meetingRoomID,
            @"call_rate_type"       :   callRateType,
            @"meeting_password"     :   password,
            @"invited_users"        :   inviteUsers,
            @"mute_upon_entry"      :   muteUponEntry,
            @"guest_dial_in"        :   [NSNumber numberWithBool:guestDialIn],
            @"watermark"            :   [NSNumber numberWithBool:waterMask],
            @"watermark_type"       :   waterMarkType,
            @"time_to_join"         :   [NSNumber numberWithInteger:timeToJoin],
            @"recurrence_type"      :   recurrenceType,
            @"recurrenceDaysOfWeek" :   recurrenceDaysOfWeek,
            @"recurrenceDaysOfMonth":   recurrenceDaysOfMonth,
            @"recurrenceInterval"   :   [NSNumber numberWithInteger:interval],
            @"recurrenceStartTime"  :   startRecurrenceTime,
            @"recurrenceEndTime"    :   endRecurrenceTime,
            @"recurrenceStartDay"   :   startRecurrenceDay,
            @"recurrenceEndDay"     :   endRecurrenceDay
        };
        
        [[FrtcManagement sharedManagement] frtcUpdateRecurrenceScheduleMeeting:userToken withReservationID:reservationID withMeetingParams:meetingParams completionHandler:^(NSDictionary * _Nonnull meetingInfo) {
                completionHandler(meetingInfo);
            } failure:^(NSError * _Nonnull error) {
                updateMeetingFailure(error);
        }];
    } else {
        meetingParams = @{
            @"meeting_type"         :   meetingType,
            @"meeting_name"         :   meetingName,
            @"meeting_description"  :   meetingDescription,
            @"schedule_start_time"  :   startTime,
            @"schedule_end_time"    :   endTime,
            @"meeting_room_id"      :   meetingRoomID,
            @"call_rate_type"       :   callRateType,
            @"meeting_password"     :   password,
            @"invited_users"        :   inviteUsers,
            @"mute_upon_entry"      :   muteUponEntry,
            @"guest_dial_in"        :   [NSNumber numberWithBool:guestDialIn],
            @"watermark"            :   [NSNumber numberWithBool:waterMask],
            @"watermark_type"       :   waterMarkType,
            @"time_to_join"         :   [NSNumber numberWithInteger:timeToJoin]
        };
        [[FrtcManagement sharedManagement] frtcUpdateScheduleMeeting:userToken withReservationID:reservationID withMeetingParams:meetingParams completionHandler:^(NSDictionary * _Nonnull meetingInfo) {
                completionHandler(meetingInfo);
            } failure:^(NSError * _Nonnull error) {
                updateMeetingFailure(error);
        }];
    }
}

- (void)frtcGetScheduledMeeting:(NSString *)usertoken
            getScheduledHandler:(nullable void (^)(ScheduledModelArray * shceduleModleArray))completionHandler
            getScheduledFailure:(nullable void (^)(NSError *error))getScheduledFailure {
    [[FrtcManagement sharedManagement] frtcGetScheduledMeeting:usertoken getScheduledHandler:^(NSDictionary * _Nonnull scheduledMeetingInfo) {
        NSError *error = nil;
        ScheduledModelArray *shceduleMoel = [[ScheduledModelArray alloc] initWithDictionary:scheduledMeetingInfo error:&error];

        completionHandler(shceduleMoel);
        } getScheduledFailure:^(NSError * _Nonnull error) {
            getScheduledFailure(error);
    }];
}

- (void)frtcDeleteCurrentMeeting:(NSString *)userToken
               withReservationId:(NSString *)reservationId
                   withCancelALL:(BOOL)isCancelAll
         deleteCompletionHandler:(nullable void (^)(void))completionHandler
                   deleteFailure:(nullable void (^)(NSError *error))deleteFailure {
    [[FrtcManagement sharedManagement] frtcDeleteCurrentMeeting:userToken withReservationId:reservationId withCancelALL:isCancelAll
        deleteCompletionHandler:^{
            completionHandler();
        } deleteFailure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)frtcAddMeetingListFromUrl:(NSString *)userToken
                meetingIdentifier:(NSString *)meetingIdentifier
                completionHandler:(nullable void (^)(NSDictionary * meetingInfo))completionHandler
                          failure:(nullable void (^)(NSError *error))addMeetingListFailure {
    [[FrtcManagement sharedManagement] frtcAddMeetingList:userToken meetingIdentifier:meetingIdentifier completionHandler:^(NSDictionary * _Nonnull meetingInfo) {
            completionHandler(meetingInfo);
    } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
    }];
}

- (void)frtcRemoveMeetingListFromUrl:(NSString *)userToken
                   meetingIdentifier:(NSString *)meetingIdentifier
                   completionHandler:(nullable void (^)(NSDictionary * meetingInfo))completionHandler
                             failure:(nullable void (^)(NSError *error))removeMeetingListFailure {
    [[FrtcManagement sharedManagement] frtcRemoveMeetingList:userToken meetingIdentifier:meetingIdentifier completionHandler:^(NSDictionary * _Nonnull meetingInfo) {
            completionHandler(meetingInfo);
        } failure:^(NSError * _Nonnull error) {
            removeMeetingListFailure(error);
    }];
}

- (void)frtcQueryMeetingRoomList:(NSString *)usertoken
         queryMeetingRoomSuccess:(nullable void (^)(MeetingRooms * meetingRooms))querySuccess
         queryMeetingRoomFailure:(nullable void (^)(NSError *error))queryFailure {
    [[FrtcManagement sharedManagement] frtcQueryMeetingRoomList:usertoken queryMeetingRoomSuccess:^(NSDictionary * _Nonnull meetingRoom) {
            NSError *error = nil;
            MeetingRooms *meetingRooms = [[MeetingRooms alloc] initWithDictionary:meetingRoom error:&error];
            querySuccess(meetingRooms);
        } queryMeetingRoomFailure:^(NSError * _Nonnull error) {
            
    }];
}

- (void)frtcChangeUserNameByGuestClient:(NSString *)meetingNumber
                        withNewUserName:(NSString *)userName
            changeNameSuccessfulHandler:(nullable void (^)(void))successfulHandler
                      changeNameFailure:(nullable void (^)(NSError *error))changeFailure {
    [[FrtcManagement sharedManagement] frtcChangeUserNameByGuest:meetingNumber withNewName:userName  changeSuccessfulHandler:^{
            successfulHandler();
        } changeFailure:^(NSError * _Nonnull error) {
            changeFailure(error);
    }];
}

- (void)frtcChangeUserNameByLoginUser:(NSString *)usertoken
                        meetingNumber:(NSString *)meetingNumber
                              newName:(NSString *)newName
                     clientIdentifier:(NSString *)clientIdentifier
              changeSuccessfulHandler:(nullable void (^)(void))successfulHandler
                        changeFailure:(nullable void (^)(NSError *error))changeFailure {
    [[FrtcManagement sharedManagement] frtcChangeUserNameByLoginUser:usertoken meetingNumber:meetingNumber newName:newName clientIdentifier:clientIdentifier changeSuccessfulHandler:^{
            successfulHandler();
        } changeFailure:^(NSError * _Nonnull error) {
            changeFailure(error);
    }];
}

- (void)frtcMeetingSetUserAsLecturer:(NSString *)usertoken
                       meetingNumber:(NSString *)meetingNumber
                          clientUUID:(NSString *)clientIdentifier
        setLecturerSuccessfulHandler:(nullable void (^)(void))successfulHandler
                  setLecturerFailure:(nullable void (^)(NSError *error))setMeetingLectureFailure {
    [[FrtcManagement sharedManagement] frtcSetUserAsLecturer:usertoken meetingNumber:meetingNumber clientIdentifier:clientIdentifier setLecturerSuccessfulHandler:^{
            successfulHandler();
        } setLecturerFailure:^(NSError * _Nonnull error) {
            setMeetingLectureFailure(error);
    }];
}

- (void)frtcMeetingUnSetUserAsLecturer:(NSString *)usertoken
                         meetingNumber:(NSString *)meetingNumber
                            clientUUID:(NSString *)clientIdentifier
          setLecturerSuccessfulHandler:(nullable void (^)(void))successfulHandler
                    setLecturerFailure:(nullable void (^)(NSError *error))setMeetingLectureFailure {
    [[FrtcManagement sharedManagement] frtcUnSetLecture:usertoken meetingNumber:meetingNumber clientIdentifier:clientIdentifier unSetLecturerSuccessfulHandler:^{
            successfulHandler();
        } unSetLecturerFailure:^(NSError * _Nonnull error) {
            setMeetingLectureFailure(error);
    }];
}

- (void)frtcMeetingRmoveUserFromMeetingRoom:(NSString *)usertoken
                              meetingNumber:(NSString *)meetingNumber
                           clientIdentifier:(NSString *)clientIdentifier
             removeMeetingSuccessfulHandler:(nullable void (^)(void))successfulHandler
                       removeMeetingFailure:(nullable void (^)(NSError *error))removeFailure {
    [[FrtcManagement sharedManagement] frtcRmoveUserFromMeetingRoom:usertoken meetingNumber:meetingNumber clientIdentifier:clientIdentifier removeMeetingSuccessfulHandler:^{
            successfulHandler();
        } removeMeetingFailure:^(NSError * _Nonnull error) {
            removeFailure(error);
    }];
}

- (void)frtcMeetingStartOverlayMessage:(NSString *)usertoken
                         meetingNumber:(NSString *)meetingNumber
                      clientIdentifier:(NSString *)clientIdentifier
                 overlayMessageContent:(NSString *)content
                                repeat:(NSInteger)repeat
                              position:(NSInteger)position
                                scroll:(BOOL)isScroll
         startMessageSuccessfulHandler:(nullable void (^)(void))successfulHandler
                   startMessageFailure:(nullable void (^)(NSError *error))startFailure {
    NSDictionary *params = @{ @"content" : content,
                              @"repeat"  : [NSNumber numberWithInteger:repeat],
                              @"position": [NSNumber numberWithInteger:position],
                              @"enable_scroll": [NSNumber numberWithBool:isScroll]
                            };
    [[FrtcManagement sharedManagement] frtcStartOverlayMessage:usertoken meetingNumber:meetingNumber clientIdentifier:clientIdentifier withMessageOverlayParams:params startMessageSuccessfulHandler:^{
            successfulHandler();
        } startMessageFailure:^(NSError * _Nonnull error) {
            startFailure(error);
    }];
}

- (void)frtcMeetingStopOverlayMessage:(NSString *)usertoken
                        meetingNumber:(NSString *)meetingNumber
                     clientIdentifier:(NSString *)clientIdentifier
         stopMessageSuccessfulHandler:(nullable void (^)(void))successfulHandler
                   stopMessageFailure:(nullable void (^)(NSError *error))stopFailure {
    [[FrtcManagement sharedManagement] frtcStopOverlayMessage:usertoken meetingNumber:meetingNumber clientIdentifier:clientIdentifier stopMessageSuccessfulHandler:^{
            successfulHandler();
        } stopMessageFailure:^(NSError * _Nonnull error) {
            stopFailure(error);
    }];
}

- (void)frtcMeetingStartRecording:(NSString *)usertoken
                    meetingNumber:(NSString *)meetingNumber
                 clientIdentifier:(NSString *)clientIdentifier
            startRecordingSeccess:(nullable void (^)(void))successfulHandler
            startRecordingFailure:(nullable void (^)(NSError *error))startRecordingFailure {
    [[FrtcManagement sharedManagement] frtcStartRecording:usertoken meetingNumber:meetingNumber clientIdentifier:clientIdentifier startRecordingSeccess:^{
            successfulHandler();
        } startRecordingFailure:^(NSError * _Nonnull error) {
            startRecordingFailure(error);
    }];
}

- (void)frtcMeetingStopRecording:(NSString *)usertoken
                   meetingNumber:(NSString *)meetingNumber
                clientIdentifier:(NSString *)clientIdentifier
         stopRecordingSuccessful:(nullable void (^)(void))successfulHandler
            stopRecordingFailure:(nullable void (^)(NSError *error))stopRecordingFailure {
    [[FrtcManagement sharedManagement] frtcStopRecording:usertoken meetingNumber:meetingNumber clientIdentifier:clientIdentifier stopRecordingSuccessful:^{
            successfulHandler();
        } stopRecordingFailure:^(NSError * _Nonnull error) {
            stopRecordingFailure(error);
    }];
}

- (void)frtcMeetingStartStreaming:(NSString *)usertoken
                    meetingNumber:(NSString *)meetingNumber
                streamingPassword:(NSString *)password
                 clientIdentifier:(NSString *)clientIdentifier
            startStreamingSeccess:(nullable void (^)(void))successfulHandler
            startStreamingFailure:(nullable void (^)(NSError *error))startStreamingFailure {
    [[FrtcManagement sharedManagement] frtcStartStreaming:usertoken meetingNumber:meetingNumber streamingPassword:password clientIdentifier:clientIdentifier startStreamingSeccess:^{
            successfulHandler();
        } startStreamingFailure:^(NSError * _Nonnull error) {
            startStreamingFailure(error);
    }];
}

- (void)frtcMeetingStopStreaming:(NSString *)usertoken
                   meetingNumber:(NSString *)meetingNumber
                clientIdentifier:(NSString *)clientIdentifier
         stopStreamingSuccessful:(nullable void (^)(void))successfulHandler
            stopStreamingFailure:(nullable void (^)(NSError *error))stopStreamingFailure {
    [[FrtcManagement sharedManagement] frtcStopStreaming:usertoken meetingNumber:meetingNumber clientIdentifier:clientIdentifier stopStreamingSuccessful:^{
            successfulHandler();
        } stopStreamingFailure:^(NSError * _Nonnull error) {
            stopStreamingFailure(error);
    }];
}

- (void)frtcMeetingRequestUnmute:(NSString *)usertoken
                   meetingNumber:(NSString *)meetingNumber
                clientIdentifier:(NSString *)clientIdentifier
         requestUnmuteSuccessful:(nullable void (^)(void))successfulHandler
            requestUnmuteFailure:(nullable void (^)(NSError *error))requestUnmuteFailure {
    [[FrtcManagement sharedManagement] frtcRequestUnmute:usertoken meetingNumber:meetingNumber clientIdentifier:clientIdentifier requestUnmuteSuccessful:^{
            successfulHandler();
        } requestUnmuteFailure:^(NSError * _Nonnull error) {
            requestUnmuteFailure(error);
    }];
}

- (void)frtcMeetingAllowUnmute:(NSString *)usertoken
                 meetingNumber:(NSString *)meetingNumber
              clientIdentifier:(NSArray  *)clientIdentifierArray
         allowUnmuteSuccessful:(nullable void (^)(void))successfulHandler
            allowUnmuteFailure:(nullable void (^)(NSError *error))allowUnmuteFailure {
    [[FrtcManagement sharedManagement] frtcAllowUnmute:usertoken meetingNumber:meetingNumber clientIdentifier:clientIdentifierArray allowUnmuteSuccessful:^{
            successfulHandler();
        } allowUnmuteFailure:^(NSError * _Nonnull error) {
            allowUnmuteFailure(error);
    }];
}

- (void)frtcMeetingPin:(NSString *)usertoken
         meetingNumber:(NSString *)meetingNumber
      clientIdentifier:(NSArray *)clientIdentifierArray
         pinSuccessful:(nullable void (^)(void))successfulHandler
            pinFailure:(nullable void (^)(NSError *error))pinFailure {
    [[FrtcManagement sharedManagement] frtcPin:usertoken meetingNumber:meetingNumber clientIdentifier:clientIdentifierArray pinSuccessful:^{
            successfulHandler();
        } pinFailure:^(NSError * _Nonnull error) {
            pinFailure(error);
    }];
}

- (void)frtcMeetingUnPin:(NSString *)usertoken
           meetingNumber:(NSString *)meetingNumber
         unPinSuccessful:(nullable void (^)(void))successfulHandler
            unPinFailure:(nullable void (^)(NSError *error))unPinFailure {
    [[FrtcManagement sharedManagement] frtcUnPin:usertoken meetingNumber:meetingNumber unPinSuccessful:^{
            successfulHandler();
        } unPinFailure:^(NSError * _Nonnull error) {
            unPinFailure(error);
    }];
}


@end
