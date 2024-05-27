#import "FrtcManagement.h"
#import "SDKNetWorking.h"
#import "SDKUserDefault.h"
#import "FrtcUUID.h"
#import <CommonCrypto/CommonDigest.h>

#pragma mark --SHA1--
NSString * const salt           = @"49d88eb34f77fc9e81cbdc5190c7efdc";
NSString * const uselessToken   = @"uselessToken";

#pragma mark --Rest API URL--
NSString * const userLoginUrl               = @"/api/v1/user/sign_in";
NSString * const userLogoutUrl              = @"/api/v1/user/sign_out";
NSString * const userInfoUrl                = @"/api/v1/user/info";
NSString * const updatePasswordUrl          = @"/api/v1/user/password";
NSString * const scheduleMeetingUrl         = @"/api/v1/meeting_schedule";
NSString * const queryMeetingListUrl        = @"/api/v1/meeting_room";
NSString * const muteAllUrl                 = @"/api/v1/meeting/%@/mute_all";
NSString * const muteOneOrAll               = @"/api/v1/meeting/%@/mute";
NSString * const unmuteAllUrl               = @"/api/v1/meeting/%@/unmute_all";
NSString * const unmuteOneOrAll             = @"/api/v1/meeting/%@/unmute";
NSString * const stopMeetingUrl             = @"/api/v1/meeting/%@/stop";
NSString * const queryScheduledMeetingUrl   = @"/api/v1/meeting_schedule";
NSString * const deleteNonRecurrentMeeting  = @"/api/v1/meeting_schedule/%@";
NSString * const getAllUserListUrl          = @"/api/v1/user/public/users";
NSString * const createMeetingUrl           = @"/api/v1/meeting_schedule";
NSString * const getDetailMeetingUrl        = @"/api/v1/meeting_schedule/%@";
NSString * const getGroupMeetingUrl         = @"/api/v1/meeting_schedule/recurrence/%@";
NSString * const updateRecurrenceUrl        = @"/api/v1/meeting_schedule/recurrence/%@";
NSString * const changeNameForGuest         = @"/api/v1/meeting/%@";
NSString * const changeNameForLogin         = @"/api/v1/meeting/%@";
NSString * const setUserAsLecturer          = @"/api/v1/meeting/%@";
NSString * const removeUserFromMeeting      = @"/api/v1/meeting/%@/disconnect";
NSString * const startOverlayMessageUrl     = @"/api/v1/meeting/%@/overlay";
NSString * const starRecordingUrl           = @"/api/v1/meeting/%@/recording";
NSString * const stopRecordingUrl           = @"/api/v1/meeting/%@/recording";
NSString * const starStreamingUrl           = @"/api/v1/meeting/%@/live";
NSString * const stopStreamingUrl           = @"/api/v1/meeting/%@/live";
NSString * const requestUnmuteUrl           = @"/api/v1/meeting/%@/request_unmute";
NSString * const allowUnmuteUrl             = @"/api/v1/meeting/%@/allow_unmute";
NSString * const pinUserUrl                 = @"/api/v1/meeting/%@/pin";
NSString * const addMeetingListUrl          = @"/api/v1/meeting_list/add/%@";
NSString * const removeMeetingListUrl       = @"/api/v1/meeting_list/remove/%@";

static FrtcManagement *managementClient = nil;

@implementation FrtcManagement

+ (FrtcManagement *)sharedManagement {
    @synchronized(self) {
        if (managementClient == nil) {
            managementClient = [[FrtcManagement alloc] init];
        }
    }
    return managementClient;
}

- (instancetype)init {
    if (self = [super init]) {
        [[SDKUserDefault sharedSDKUserDefault] setSDKBoolObject:NO forKey:SKD_LOGIN_VALUE];
    }
    
    return self;
}

#pragma mark --config--
- (void)frtcSetSDKConfig:(FRTCSDKConfigKey)key
          withSDKConfigValue:(NSString *)value {
    
    if (key == FRTCSDK_SERVER_ADDRESS) {
        [[SDKUserDefault sharedSDKUserDefault] setSDKObject:value forKey:SKD_SERVER_ADDRESS];
    }
}


#pragma mark --login interface--
- (void)frtcLoginWithUserName:(NSString *)userName
                 withPassword:(NSString *)password
                 loginSuccess:(nullable void (^)(NSDictionary * userInfo))loginSuccess
                 loginFailure:(nullable void (^)(NSError *error))loginFailure {
    
    NSString *sha1SecretString = [self secretSha1String:password];
    NSDictionary *dict         = @{@"username":userName, @"secret" :sha1SecretString};
    
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingPOST:userLoginUrl
                                                 userToken:uselessToken
                                                parameters:dict
                                  requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
        
        [[SDKUserDefault sharedSDKUserDefault] setSDKBoolObject:YES forKey:SKD_LOGIN_VALUE];
        NSLog(@"%@", requestInfomation);
        loginSuccess(requestInfomation);
    } requestPOSTFailure:^(NSError * _Nonnull error) {
        loginFailure(error);
        NSLog(@"------------------------------------");
        NSLog(@"%@", error.localizedDescription);
        NSLog(@"------------------------------------");
        NSLog(@"%@", error.localizedFailureReason);
        NSLog(@"------------------------------------");
    }];
}

- (void)frtcLogoutWithUserToken:(NSString *)userToken
                  logoutSuccess:(nullable void (^)(NSDictionary * userInfo))logoutSuccess
                  logoutFailure:(nullable void (^)(NSError *error))logoutFailure {
    
    [[SDKUserDefault sharedSDKUserDefault] setSDKBoolObject:NO forKey:SKD_LOGIN_VALUE];
    
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingPOST:userLogoutUrl
                                                 userToken:userToken
                                                parameters:nil
                                  requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
        logoutSuccess(requestInfomation);
    } requestPOSTFailure:^(NSError * _Nonnull error) {
        logoutFailure(error);
    }];
}

- (void)frtcModifyUserPasswordWithUserToken:(NSString *)userToken
                                oldPassword:(NSString *)oldPassword
                                newPassword:(NSString *)newPassword
                    modifyCompletionHandler:(nullable void (^)(FRTCSDKModifyPasswordResult result))completionHandler {
    
    NSString *oldSecretString = [self secretSha1String:oldPassword];
    NSString *newSecretString = [self secretSha1String:newPassword];
    NSDictionary *dict = @{@"secret_old":oldSecretString, @"secret_new" :newSecretString};
    
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingPUT:updatePasswordUrl
                                                userToken:userToken
                                               parameters:dict
                                 requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
        
        completionHandler(FRTCSDK_MODIFY_PASSWORD_SUCCESS);
    } requestPOSTFailure:^(NSError * _Nonnull error) {
        completionHandler(FRTCSDK_MODIFY_PASSWORD_FAILED);
    }];
}

- (void)frtcGetLoginUserInfomation:(NSString *)userToken
                    getInfoSuccess:(nullable void (^)(NSDictionary * userInfo))getInfoSuccess
                    getInfoFailure:(nullable void (^)(NSError *error))getInfoFailure {
    
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingGET:userInfoUrl
                                                userToken:userToken
                                               parameters:nil
                                 requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
        
        [[SDKUserDefault sharedSDKUserDefault] setSDKBoolObject:YES forKey:SKD_LOGIN_VALUE];
        getInfoSuccess(requestInfomation);
    } requestPOSTFailure:^(NSError * _Nonnull error) {
        getInfoFailure(error);
    }];
}

#pragma mark --schedule meeting interface--
- (void)frtcScheduleMeetingWithUsertoken:(NSString *)usertoken
                             meetingName:(NSString *)meetingName
               scheduleCompletionHandler:(nullable void (^)(NSDictionary * meetingInfo))completionHandler
                         scheduleFailure:(nullable void (^)(NSError *error))scheduleFailure {
    
    NSDictionary *dict = @{@"meeting_type":@"instant", @"meeting_name" :meetingName};
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingPOST:scheduleMeetingUrl
                                                 userToken:usertoken
                                                parameters:dict
                                  requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
        
        completionHandler(requestInfomation);
    } requestPOSTFailure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
        NSLog(@"%@", error.localizedFailureReason);
        scheduleFailure(error);
    }];
}

- (void)frtcQueryMeetingRoomList:(NSString *)usertoken
         queryMeetingRoomSuccess:(nullable void (^)(NSDictionary * meetingRoom))querySuccess
         queryMeetingRoomFailure:(nullable void (^)(NSError *error))queryFailure {
    
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingGET:queryMeetingListUrl
                                                userToken:usertoken
                                               parameters:nil
                                 requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
        
        querySuccess(requestInfomation);
    } requestPOSTFailure:^(NSError * _Nonnull error) {
        queryFailure(error);
    }];
}

- (void)frtcGetScheduledMeeting:(NSString *)usertoken
            getScheduledHandler:(nullable void (^)(NSDictionary * scheduledMeetingInfo))completionHandler
            getScheduledFailure:(nullable void (^)(NSError *error))getScheduledFailure {
    
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingGET:queryScheduledMeetingUrl
                                                userToken:usertoken
                                               parameters:nil
                                 requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
        
        completionHandler(requestInfomation);
    } requestPOSTFailure:^(NSError * _Nonnull error) {
        getScheduledFailure(error);
    }];
}

- (void)frtcDeleteCurrentMeeting:(NSString *)userToken
               withReservationId:(NSString *)reservationId
                   withCancelALL:(BOOL)isCancelAll
            deleteCompletionHandler:(nullable void (^)(void))completionHandler
                      deleteFailure:(nullable void (^)(NSError *error))deleteFailure {
    
    NSString *str = [NSString stringWithFormat:deleteNonRecurrentMeeting, reservationId];
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingDELETE:str
                                                   userToken:userToken
                                                 isCancelAll:isCancelAll
                                                  parameters:nil
                                    requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
        completionHandler();
    } requestDELETEFailure:^(NSError * _Nonnull error) {
        deleteFailure(error);
    }];
}

- (void)frtcGetUserList:(NSString *)userToken
               withPage:(NSInteger)page
             withFilter:(NSString *)filter
      completionHandler:(nullable void (^)(NSDictionary * allUserListInfo))completionHandler
                failure:(nullable void (^)(NSError *error))getFailure {
    
    NSString *serverAddress = [[SDKUserDefault sharedSDKUserDefault] sdkObjectForKey:SKD_SERVER_ADDRESS];
    NSString *uuid          = [[FrtcUUID sharedUUID] getAplicationUUID];
    
    NSString *restfulUrl;
    if ([filter isEqualToString:@""]) {
        restfulUrl = [NSString stringWithFormat:@"https://%@%@?client_id=%@&token=%@&page_num=%ld&page_size=50", serverAddress, getAllUserListUrl, uuid, userToken, page];
    } else {
        restfulUrl = [NSString stringWithFormat:@"https://%@%@?client_id=%@&token=%@&page_num=%ld&page_size=50&filter=%@", serverAddress, getAllUserListUrl, uuid, userToken, page, filter];
    }
    NSLog(@"%@", restfulUrl);
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingGET:restfulUrl
                                               parameters:nil
                                 requestCompletionHandler:completionHandler
                                       requestPOSTFailure:getFailure];
}

- (void)frtcCreateMeeting:(NSString *)userToken
        withMeetingParams:(NSDictionary *)meetingParams
        completionHandler:(nullable void (^)(NSDictionary * meetingInfo))completionHandler
                  failure:(nullable void (^)(NSError *error))createFailure {
    
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingPOST:createMeetingUrl
                                                 userToken:userToken
                                                parameters:meetingParams
                                  requestCompletionHandler:completionHandler
                                        requestPOSTFailure:createFailure];
}

- (void)frtcGetScheduleMeetingDetailInformation:(NSString *)userToken
                              withReservationID:(NSString *)reservationID
                              completionHandler:(nullable void (^)(NSDictionary * meetingInfo))completionHandler
                                        failure:(nullable void (^)(NSError *error))getDetailInfoFailure {
    
    NSString *str = [NSString stringWithFormat:getDetailMeetingUrl, reservationID];
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingGET:str
                                                userToken:userToken
                                               parameters:nil
                                 requestCompletionHandler:completionHandler
                                       requestPOSTFailure:getDetailInfoFailure];
}

- (void)frtcGetScheduleMeetingGroupInformation:(NSString *)userToken
                              withGroupID:(NSString *)groupID
                              completionHandler:(nullable void (^)(NSDictionary * meetingInfo))completionHandler
                                       failure:(nullable void (^)(NSError *error))getDetailInfoFailure {
    NSString *str = [NSString stringWithFormat:getGroupMeetingUrl, groupID];
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingGET:str
                                                userToken:userToken
                                         searchUserFilter:@""
                                               parameters:nil
                                 requestCompletionHandler:completionHandler
                                       requestPOSTFailure:getDetailInfoFailure];

}

- (void)frtcUpdateScheduleMeeting:(NSString *)userToken
                withReservationID:(NSString *)reservationID
                withMeetingParams:(NSDictionary *)meetingParams
                completionHandler:(nullable void (^)(NSDictionary * meetingInfo))completionHandler
                          failure:(nullable void (^)(NSError *error))updateMeetingFailure {
    
    NSString *str = [NSString stringWithFormat:getDetailMeetingUrl, reservationID];
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingPOST:str
                                                 userToken:userToken
                                                parameters:meetingParams
                                  requestCompletionHandler:completionHandler
                                        requestPOSTFailure:updateMeetingFailure];
}

- (void)frtcUpdateRecurrenceScheduleMeeting:(NSString *)userToken
                          withReservationID:(NSString *)reservationID
                          withMeetingParams:(NSDictionary *)meetingParams
                          completionHandler:(nullable void (^)(NSDictionary * meetingInfo))completionHandler
                          failure:(nullable void (^)(NSError *error))updateMeetingFailure {
    
    NSString *str = [NSString stringWithFormat:updateRecurrenceUrl, reservationID];
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingPOST:str
                                                 userToken:userToken
                                                parameters:meetingParams
                                  requestCompletionHandler:completionHandler
                                        requestPOSTFailure:updateMeetingFailure];
}

- (void)frtcAddMeetingList:(NSString *)userToken
         meetingIdentifier:(NSString *)meetingIdentifier
         completionHandler:(nullable void (^)(NSDictionary * meetingInfo))completionHandler
                   failure:(nullable void (^)(NSError *error))addMeetingListFailure {
    NSString *str = [NSString stringWithFormat:addMeetingListUrl, meetingIdentifier];
    
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingPOST:str
                                                 userToken:userToken
                                                parameters:nil
                                  requestCompletionHandler:completionHandler
                                        requestPOSTFailure:addMeetingListFailure];
}

- (void)frtcRemoveMeetingList:(NSString *)userToken
         meetingIdentifier:(NSString *)meetingIdentifier
         completionHandler:(nullable void (^)(NSDictionary * meetingInfo))completionHandler
                      failure:(nullable void (^)(NSError *error))removeMeetingListFailure {
    NSString *str = [NSString stringWithFormat:removeMeetingListUrl, meetingIdentifier];
    
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingDELETE:str userToken:userToken parameters:nil requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
            completionHandler(requestInfomation);
        } requestDELETEFailure:^(NSError * _Nonnull error) {
            removeMeetingListFailure(error);
    }];
}

#pragma mark --meeting mute interface--
- (void)frtcMuteAllParticipants:(NSString *)usertoken
                  meetingNumber:(NSString *)meetingNumber
                           mute:(BOOL)allowSelfUnmute
       muteAllCompletionHandler:(nullable void (^)(void))completionHandler
                 muteAllFailure:(nullable void (^)(NSError *error))muteAllFailure {
    
    NSDictionary *dict = @{@"allow_self_unmute": [NSNumber numberWithBool:allowSelfUnmute]};
    NSString      *str = [NSString stringWithFormat:muteAllUrl, meetingNumber];
    
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingPOST:str
                                                 userToken:usertoken
                                                parameters:dict
                                  requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
        completionHandler();
    } requestPOSTFailure:^(NSError * _Nonnull error) {
        muteAllFailure(error);
    }];
}

- (void)frtcMuteParticipant:(NSString *)usertoken
              meetingNumber:(NSString *)meetingNumber
            allowSelfUnmute:(BOOL)allowSelfUnmute
            participantList:(NSArray<NSString *> *)participantList
      muteCompletionHandler:(nullable void (^)(void))completionHandler
             muteAllFailure:(nullable void (^)(NSError *error))muteAllFailure {
    
    NSDictionary *dict = @{@"allow_self_unmute": [NSNumber numberWithBool:allowSelfUnmute],
                           @"participants"     : participantList};
    NSString      *str = [NSString stringWithFormat:muteOneOrAll, meetingNumber];
    
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingPOST:str
                                                 userToken:usertoken
                                                parameters:dict
                                  requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
        completionHandler();
    } requestPOSTFailure:^(NSError * _Nonnull error) {
        muteAllFailure(error);
    }];
}

- (void)frtcUnMuteAllParticipants:(NSString *)usertoken
                    meetingNumber:(NSString *)meetingNumber
         muteAllCompletionHandler:(nullable void (^)(void))completionHandler
                   muteAllFailure:(nullable void (^)(NSError *error))muteAllFailure {
    NSString *str = [NSString stringWithFormat:unmuteAllUrl, meetingNumber];
    
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingPOST:str
                                                 userToken:usertoken
                                                parameters:nil
                                  requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
        completionHandler();
    } requestPOSTFailure:^(NSError * _Nonnull error) {
        muteAllFailure(error);
    }];
}

- (void)frtcUnMuteParticipant:(NSString *)usertoken
                meetingNumber:(NSString *)meetingNumber
              participantList:(NSArray<NSString *> *)participantList
        muteCompletionHandler:(nullable void (^)(void))completionHandler
               muteAllFailure:(nullable void (^)(NSError *error))muteAllFailure {
    
    NSDictionary *dict = @{@"participants":participantList};
    NSString      *str = [NSString stringWithFormat:unmuteOneOrAll, meetingNumber];
    
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingPOST:str
                                                 userToken:usertoken
                                                parameters:dict
                                  requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
        completionHandler();
    } requestPOSTFailure:^(NSError * _Nonnull error) {
        muteAllFailure(error);
    }];
}

- (void)frtcOwnerStopMeeting:(NSString *)usertoken
               meetingNumber:(NSString *)meetingNumber
       stopCompletionHandler:(nullable void (^)(void))completionHandler
          stopMeetingFailure:(nullable void (^)(NSError *error))stopMeetingFailure {
    
    NSString *str = [NSString stringWithFormat:stopMeetingUrl, meetingNumber];
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingPOST:str
                                                 userToken:usertoken
                                                parameters:nil
                                  requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
        completionHandler();
    } requestPOSTFailure:^(NSError * _Nonnull error) {
        stopMeetingFailure(error);
    }];
}

- (void)frtcChangeUserNameByGuest:(NSString *)meetingNumber
                      withNewName:(NSString *)newUserName
          changeSuccessfulHandler:(nullable void (^)(void))successfulHandler
                    changeFailure:(nullable void (^)(NSError *error))changeFailure {
    NSString *str = [NSString stringWithFormat:changeNameForGuest, meetingNumber];
    NSDictionary *dict = @{@"client_id":[[FrtcUUID sharedUUID] getAplicationUUID], @"display_name": newUserName};
    
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingPOST:str
                                                 userToken:@""
                                                parameters:dict
                                  requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
        successfulHandler();
    } requestPOSTFailure:^(NSError * _Nonnull error) {
        changeFailure(error);
    }];
}

- (void)frtcChangeUserNameByLoginUser:(NSString *)usertoken
                        meetingNumber:(NSString *)meetingNumber
                              newName:(NSString *)newName
                     clientIdentifier:(NSString *)clientIdentifier
              changeSuccessfulHandler:(nullable void (^)(void))successfulHandler
                        changeFailure:(nullable void (^)(NSError *error))changeFailure {
    NSString *str = [NSString stringWithFormat:changeNameForGuest, meetingNumber];
    NSString *newString = [NSString stringWithFormat:@"%@/participant",str];
    if(clientIdentifier == nil) {
        clientIdentifier = [[FrtcUUID sharedUUID] getAplicationUUID];
    }
    NSDictionary *dict = @{@"client_id":clientIdentifier, @"display_name": newName};
    
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingPOST:newString
                                                 userToken:usertoken
                                                parameters:dict
                                  requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
        successfulHandler();
    } requestPOSTFailure:^(NSError * _Nonnull error) {
        changeFailure(error);
    }];
}

- (void)frtcSetUserAsLecturer:(NSString *)usertoken
                meetingNumber:(NSString *)meetingNumber
             clientIdentifier:(NSString *)clientIdentifier
 setLecturerSuccessfulHandler:(nullable void (^)(void))successfulHandler
           setLecturerFailure:(nullable void (^)(NSError *error))changeFailure {
    NSString *str = [NSString stringWithFormat:setUserAsLecturer, meetingNumber];
    NSString *newString = [NSString stringWithFormat:@"%@/lecturer",str];
    
    NSDictionary *dict = @{@"lecturer":clientIdentifier};
    
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingPOST:newString
                                                 userToken:usertoken
                                                parameters:dict
                                  requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
        successfulHandler();
    } requestPOSTFailure:^(NSError * _Nonnull error) {
        changeFailure(error);
    }];
}

- (void)frtcUnSetLecture:(NSString *)usertoken
           meetingNumber:(NSString *)meetingNumber
        clientIdentifier:(NSString *)clientIdentifier
 unSetLecturerSuccessfulHandler:(nullable void (^)(void))successfulHandler
    unSetLecturerFailure:(nullable void (^)(NSError *error))changeFailure {
    NSString *str = [NSString stringWithFormat:setUserAsLecturer, meetingNumber];
    NSString *newString = [NSString stringWithFormat:@"%@/lecturer",str];
    
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingDELETE:newString userToken:usertoken parameters:nil requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
            successfulHandler();
        } requestDELETEFailure:^(NSError * _Nonnull error) {
            changeFailure(error);
    }];
}

- (void)frtcRmoveUserFromMeetingRoom:(NSString *)usertoken
                       meetingNumber:(NSString *)meetingNumber
                    clientIdentifier:(NSString *)clientIdentifier
      removeMeetingSuccessfulHandler:(nullable void (^)(void))successfulHandler
                removeMeetingFailure:(nullable void (^)(NSError *error))removeFailure {
    NSString *str = [NSString stringWithFormat:removeUserFromMeeting, meetingNumber];
    NSArray *array = @[clientIdentifier];
    NSDictionary *dict = @{@"participants":array};

    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingDELETE:str userToken:usertoken parameters:dict requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
            successfulHandler();
        } requestDELETEFailure:^(NSError * _Nonnull error) {
            removeFailure(error);
    }];
}

- (void)frtcStartOverlayMessage:(NSString *)usertoken
                  meetingNumber:(NSString *)meetingNumber
               clientIdentifier:(NSString *)clientIdentifier
       withMessageOverlayParams:(NSDictionary *)overlayMessageParams
  startMessageSuccessfulHandler:(nullable void (^)(void))successfulHandler
            startMessageFailure:(nullable void (^)(NSError *error))startFailure {
    NSString *str = [NSString stringWithFormat:startOverlayMessageUrl, meetingNumber];
    
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingPOST:str
                                                 userToken:usertoken
                                                parameters:overlayMessageParams
                                  requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
                                                successfulHandler();
                                        } requestPOSTFailure:^(NSError * _Nonnull error) {
                                                startFailure(error);
    }];
}

- (void)frtcStopOverlayMessage:(NSString *)usertoken
                 meetingNumber:(NSString *)meetingNumber
              clientIdentifier:(NSString *)clientIdentifier
  stopMessageSuccessfulHandler:(nullable void (^)(void))successfulHandler
            stopMessageFailure:(nullable void (^)(NSError *error))stopFailure {
    NSString *str = [NSString stringWithFormat:startOverlayMessageUrl, meetingNumber];
    
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingDELETE:str
                                                   userToken:usertoken
                                                  parameters:nil
                                    requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
                                            successfulHandler();
                                      } requestDELETEFailure:^(NSError * _Nonnull error) {
                                            stopFailure(error);
    }];
}

- (void)frtcStartRecording:(NSString *)usertoken
             meetingNumber:(NSString *)meetingNumber
          clientIdentifier:(NSString *)clientIdentifier
     startRecordingSeccess:(nullable void (^)(void))successfulHandler
     startRecordingFailure:(nullable void (^)(NSError *error))startRecordingFailure {
    NSString *str = [NSString stringWithFormat:starRecordingUrl, meetingNumber];
    NSDictionary *dict = @{@"meeting_number":meetingNumber};
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingPOST:str
                                                 userToken:usertoken
                                                parameters:dict
                                  requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
                                                successfulHandler();
                                        } requestPOSTFailure:^(NSError * _Nonnull error) {
                                            startRecordingFailure(error);
    }];
}

- (void)frtcStopRecording:(NSString *)usertoken
            meetingNumber:(NSString *)meetingNumber
         clientIdentifier:(NSString *)clientIdentifier
  stopRecordingSuccessful:(nullable void (^)(void))successfulHandler
     stopRecordingFailure:(nullable void (^)(NSError *error))stopRecordingFailure {
    NSString *str = [NSString stringWithFormat:starRecordingUrl, meetingNumber];
    NSDictionary *dict = @{@"meeting_number":meetingNumber};
    
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingDELETE:str
                                                   userToken:usertoken
                                                  parameters:dict
                                    requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
                                            successfulHandler();
                                      } requestDELETEFailure:^(NSError * _Nonnull error) {
                                          stopRecordingFailure(error);
    }];
}

- (void)frtcStartStreaming:(NSString *)usertoken
             meetingNumber:(NSString *)meetingNumber
         streamingPassword:(NSString *)password
          clientIdentifier:(NSString *)clientIdentifier
     startStreamingSeccess:(nullable void (^)(void))successfulHandler
     startStreamingFailure:(nullable void (^)(NSError *error))startStreamingFailure {
    NSString *str = [NSString stringWithFormat:starStreamingUrl, meetingNumber];
    NSDictionary *dict = @{@"meeting_number":meetingNumber, @"live_password": password};
    
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingPOST:str
                                                 userToken:usertoken
                                                parameters:dict
                                  requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
                                                successfulHandler();
                                        } requestPOSTFailure:^(NSError * _Nonnull error) {
                                            startStreamingFailure(error);
    }];
}

- (void)frtcStopStreaming:(NSString *)usertoken
            meetingNumber:(NSString *)meetingNumber
         clientIdentifier:(NSString *)clientIdentifier
  stopStreamingSuccessful:(nullable void (^)(void))successfulHandler
     stopStreamingFailure:(nullable void (^)(NSError *error))stopStreamingFailure {
    NSString *str = [NSString stringWithFormat:starStreamingUrl, meetingNumber];
    NSDictionary *dict = @{@"meeting_number":meetingNumber};
    
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingDELETE:str
                                                   userToken:usertoken
                                                  parameters:dict
                                    requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
                                            successfulHandler();
                                      } requestDELETEFailure:^(NSError * _Nonnull error) {
                                          stopStreamingFailure(error);
    }];
}

- (void)frtcRequestUnmute:(NSString *)usertoken
            meetingNumber:(NSString *)meetingNumber
         clientIdentifier:(NSString *)clientIdentifier
  requestUnmuteSuccessful:(nullable void (^)(void))successfulHandler
     requestUnmuteFailure:(nullable void (^)(NSError *error))requestUnmuteFailure {
    
    NSString *str = [NSString stringWithFormat:requestUnmuteUrl, meetingNumber];
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingPOST:str
                                                 userToken:usertoken
                                                parameters:nil
                                  requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
                                                successfulHandler();
                                        } requestPOSTFailure:^(NSError * _Nonnull error) {
                                            requestUnmuteFailure(error);
    }];
}

- (void)frtcAllowUnmute:(NSString *)usertoken
          meetingNumber:(NSString *)meetingNumber
       clientIdentifier:(NSArray  *)clientIdentifierArray
  allowUnmuteSuccessful:(nullable void (^)(void))successfulHandler
     allowUnmuteFailure:(nullable void (^)(NSError *error))allowUnmuteFailure {
    NSString *str = [NSString stringWithFormat:allowUnmuteUrl, meetingNumber];
    NSDictionary *dict = @{@"participants":clientIdentifierArray};
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingPOST:str
                                                 userToken:usertoken
                                                parameters:dict
                                  requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
                                                successfulHandler();
                                      } requestPOSTFailure:^(NSError * _Nonnull error) {
                                            allowUnmuteFailure(error);
    }];
}

- (void)frtcPin:(NSString *)usertoken
  meetingNumber:(NSString *)meetingNumber
clientIdentifier:(NSArray  *)clientIdentifierArray
  pinSuccessful:(nullable void (^)(void))successfulHandler
     pinFailure:(nullable void (^)(NSError *error))pinFailure {
    NSString *str = [NSString stringWithFormat:pinUserUrl, meetingNumber];
    NSDictionary *dict = @{@"participants":clientIdentifierArray};
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingPOST:str
                                                 userToken:usertoken
                                                parameters:dict
                                  requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
                                                successfulHandler();
                                      } requestPOSTFailure:^(NSError * _Nonnull error) {
                                                pinFailure(error);
    }];
}

- (void)frtcUnPin:(NSString *)usertoken
    meetingNumber:(NSString *)meetingNumber
  unPinSuccessful:(nullable void (^)(void))successfulHandler
     unPinFailure:(nullable void (^)(NSError *error))unPinFailure {
    NSString *str = [NSString stringWithFormat:pinUserUrl, meetingNumber];
    
    [[SDKNetWorking sharedSDKNetWorking] sdkNetWorkingDELETE:str
                                                   userToken:usertoken
                                                  parameters:nil
                                    requestCompletionHandler:^(NSDictionary * _Nonnull requestInfomation) {
                                            successfulHandler();
                                      } requestDELETEFailure:^(NSError * _Nonnull error) {
                                            unPinFailure(error);
    }];
}


#pragma mark --internal function--
- (NSString *)secretSha1String:(NSString *)password {
    
    NSString *shaResult = [password stringByAppendingString:salt];
    const char    *cstr = [shaResult cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:[shaResult length]];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

@end
