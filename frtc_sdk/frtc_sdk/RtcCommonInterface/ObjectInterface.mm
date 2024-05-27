#import <Foundation/Foundation.h>
#import "ObjectInterface.h"
#import "FrtcCall.h"
#import "FrtcUUID.h"
#import "ContentSourceInfo.h"
#import "DeviceObject.h"
#import <Accelerate/Accelerate.h>

static ObjectInterface *sdkContext = nil;

@implementation ObjectInterface

+ (ObjectInterface*)sharedObjectInterface {
    @synchronized(self) {
        if (sdkContext == nil) {
            sdkContext = [[ObjectInterface alloc] init];
        }
    }
    
    return sdkContext;
}

- (id)init {
    if (self = [super init]) {
        _impl = new ObjectImpl();
        
        if (!_impl) {
            self = nil;
        }
        
        if(self != nil) {
            _impl->Init((__bridge void *)self, [[[FrtcUUID sharedUUID] getAplicationUUID] UTF8String]);
        }
        
        self.rosterListArray = [NSMutableArray array];
        self.tempRosterListArray = [NSMutableArray array];
    }
    
    return self;
}

- (void)OnObjectMeetingJoinInfoCallBack:(const std::string&)meeting_name
                             meeting_id:(const std::string&)meeting_id
                           display_name:(const std::string&)display_name
                               owner_id:(const std::string&)owner_id
                             owner_name:(const std::string&)owner_name
                            meeting_url:(const std::string&)meeting_url
                      group_meeting_url:(const std::string&)group_meeting_url
                             start_time:(const long long )start_time
                               end_time:(const long long )end_time {
    if(self.paramsCallBack) {
        self.paramsCallBack([self transferToString:meeting_name],
                           [self transferToString:meeting_id],
                           [self transferToString:display_name],
                           [self transferToString:owner_id],
                           [self transferToString:owner_name],
                           [self transferToString:meeting_url],
                           [self transferToString:group_meeting_url],
                           start_time,
                           end_time);
    }
}

- (void)OnObjectMeetingStatusChangeCallBack:(RTC::MeetingStatus)status reason:(int)reason {
    self.statusCallBack(static_cast<CallMeetingStatus>(status), reason);
}

- (void)OnObjectParticipantCountCallBack:(int)parti_count {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.callDelegate && [self.callDelegate respondsToSelector:@selector(onParticipantsNumber:)]) {
            [self.callDelegate onParticipantsNumber:parti_count];
        }
    });
}

- (void)OnObjectParticipantListCallBack:(const std::set<std::string> &)uuid_list {
    @autoreleasepool {
        @synchronized (self.rosterListArray) {
            [self.rosterListArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSData *data = [obj dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:&err];
                
                BOOL find = NO;
                for(std::set<std::string>::const_iterator it = uuid_list.begin();it != uuid_list.end();it++) {
                    NSString *uuid = [NSString stringWithCString:(*it).c_str() encoding:NSUTF8StringEncoding];
                    
                    if([uuid isEqualToString:((NSString *)dic[@"UUID"])] ) {
                        find = YES;
                        break;
                    }
                }
                
                if(!find && ![dic[@"UUID"] isEqualToString:[[FrtcUUID sharedUUID] getAplicationUUID]]) {
                    [self.rosterListArray removeObject:obj];
                }
            }];
            
            for(int i = 0; i < self.rosterListArray.count; i++) {
                NSString *str = self.rosterListArray[i];
                NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:NSJSONReadingMutableContainers
                                                                             error:&err];
                
                if(![[dic allKeys] containsObject:@"pin"]) {
                    [dic setObject:[NSNumber numberWithBool:NO] forKey:@"pin"];
                }
                
                if(![[dic allKeys] containsObject:@"lecture"]) {
                    [dic setObject:[NSNumber numberWithBool:NO] forKey:@"lecture"];
                }
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:0];
                NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                self.rosterListArray[i] = dataStr;
            }
            
            [self.tempRosterListArray removeAllObjects];
            
            for(NSString *str in self.rosterListArray) {
                [self.tempRosterListArray addObject:str];
            }
        }
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(self.rosterListArray) {
            [self onParticipants];
        }
    });
}

- (void)OnObjectParticipantStatusChangeCallBack:(std::map<std::string, RTC::ParticipantStatus>)roster_list isFulllist:(bool)is_full {
    @synchronized(self.rosterListArray) {
        @autoreleasepool {
            if(is_full) {
                [self.rosterListArray removeAllObjects];
                
                NSString *displayName   = self.disPlayName;
                NSInteger i             = 0;
                NSInteger indexPin      = 0;
                NSInteger indexLecture  = 0;
                
                for(std::map<std::string, RTC::ParticipantStatus>::iterator item = roster_list.begin(); item != roster_list.end(); item++) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    std::string key = item->first;
                    NSString *uuid = [NSString stringWithCString:(key).c_str() encoding:NSUTF8StringEncoding];
                    dic[@"UUID"] = uuid;
                    
                    std::string display_name = item->second.display_name;
                    NSString *displayName = [NSString stringWithCString:(display_name).c_str() encoding:NSUTF8StringEncoding];
                    dic[@"name"] = displayName;
                    
                    std::string user_Id = item->second.user_id;
                    NSString *userID = [NSString stringWithCString:(user_Id).c_str() encoding:NSUTF8StringEncoding];
                    dic[@"userId"] = userID;
                    
                    NSString *muteAudio = item->second.audio_mute? @"true" : @"false";
                    NSString *muteVideo = item->second.video_mute? @"true" : @"false";
                    dic[@"muteAudio"] = muteAudio;
                    dic[@"muteVideo"] = muteVideo;
                    
                    if([dic[@"UUID"] isEqualToString:[[FrtcUUID sharedUUID] getAplicationUUID]]) {
                        displayName = dic[@"name"];
                        self.disPlayName = displayName;
                        i++;
                        continue;
                    }
                    
                    if(![[dic allKeys] containsObject:@"pin"]) {
                        [dic setObject:[NSNumber numberWithBool:NO] forKey:@"pin"];
                    }
                    
                    if([dic[@"UUID"] isEqualToString:self.pinUUID]) {
                        [dic setObject:[NSNumber numberWithBool:YES] forKey:@"pin"];
                        indexPin = i;
                    }
                    
                    if(![[dic allKeys] containsObject:@"lecture"]) {
                        [dic setObject:[NSNumber numberWithBool:NO] forKey:@"lecture"];
                    }
                    
                    if([dic[@"UUID"] isEqualToString:self.lectureUUID]) {
                        [dic setObject:[NSNumber numberWithBool:YES] forKey:@"lecture"];
                        indexLecture = i;
                    }
                    
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:0];
                    NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    [self.rosterListArray addObject:dataStr];
                    i++;
                }
                
                NSDictionary *dic = @{@"muteAudio":self.is_audio_muted ? @"true" :@"false",
                                      @"userId"   :@"",
                                      @"UUID"     :[[FrtcUUID sharedUUID] getAplicationUUID],
                                      @"pin"      :[[[FrtcUUID sharedUUID] getAplicationUUID] isEqualToString:self.pinUUID] ? @YES : @NO,
                                      @"lecture"  :[[[FrtcUUID sharedUUID] getAplicationUUID] isEqualToString:self.lectureUUID] ? @YES : @NO,
                                      @"name"     :displayName,
                                      @"muteVideo":self.is_video_muted ? @"true" :@"false"
                };
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:0];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                [self.rosterListArray insertObject:jsonString atIndex:0];
                
                if(indexLecture != 0) {
                    indexLecture += 1;
                    NSString *lectureString = self.rosterListArray[indexLecture];
                    [self.rosterListArray removeObjectAtIndex:indexLecture];
                    [self.rosterListArray insertObject:lectureString atIndex:1];
                }
                
                if(indexPin != 0) {
                    indexPin += 1;
                    NSString *pinString = self.rosterListArray[indexPin];
                    [self.rosterListArray removeObjectAtIndex:indexPin];
                    
                    if(indexLecture != 0) {
                        [self.rosterListArray insertObject:pinString atIndex:2];
                    } else {
                        [self.rosterListArray insertObject:pinString atIndex:1];
                    }
                }
            } else {
                for(std::map<std::string, RTC::ParticipantStatus>::iterator item = roster_list.begin(); item != roster_list.end(); item++) {
                    NSString *displayName = self.disPlayName;
                    
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    std::string key = item->first;
                    NSString *uuid = [NSString stringWithCString:(key).c_str() encoding:NSUTF8StringEncoding];
                    dic[@"UUID"] = uuid;
                    
                    std::string display_name = item->second.display_name;
                    NSString *name = [NSString stringWithCString:(display_name).c_str() encoding:NSUTF8StringEncoding];
                    dic[@"name"] = name;
                    
                    std::string user_Id = item->second.user_id;
                    NSString *userID = [NSString stringWithCString:(user_Id).c_str() encoding:NSUTF8StringEncoding];
                    dic[@"userId"] = userID;
                    
                    NSString *muteAudio = item->second.audio_mute? @"true" : @"false";
                    NSString *muteVideo = item->second.video_mute? @"true" : @"false";
                    dic[@"muteAudio"] = muteAudio;
                    dic[@"muteVideo"] = muteVideo;
                    
                    if([dic[@"UUID"] isEqualToString:[[FrtcUUID sharedUUID] getAplicationUUID]]) {
                        displayName = dic[@"name"];
                        self.disPlayName = displayName;
                        dic[@"muteAudio"] = self.is_audio_muted ? @"true" :@"false";
                        dic[@"muteVideo"] = self.is_video_muted ? @"true" :@"false";
                    }
                    
                    if(![[dic allKeys] containsObject:@"pin"]) {
                        [dic setObject:[NSNumber numberWithBool:NO] forKey:@"pin"];
                    }
                    
                    if([dic[@"UUID"] isEqualToString:self.pinUUID]) {
                        [dic setObject:[NSNumber numberWithBool:YES] forKey:@"pin"];
                    }
                    
                    if(![[dic allKeys] containsObject:@"lecture"]) {
                        [dic setObject:[NSNumber numberWithBool:NO] forKey:@"lecture"];
                    }
                    
                    if([dic[@"UUID"] isEqualToString:self.lectureUUID]) {
                        [dic setObject:[NSNumber numberWithBool:YES] forKey:@"lecture"];
                    }
                    
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:0];
                    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    
                    BOOL find = NO;
                    int index = 0;
                    
                    for(int i = 0; i < self.rosterListArray.count; i++) {
                        NSData *data = [self.rosterListArray[i] dataUsingEncoding:NSUTF8StringEncoding];
                        NSError *err;
                        NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:NSJSONReadingMutableContainers
                                                                                  error:&err];
                        
                        if([tempDic[@"UUID"] isEqualToString:dic[@"UUID"]]) {
                            index = i;
                            find = YES;
                            break;
                        }
                    }
                    
                    if(find) {
                        [self.rosterListArray replaceObjectAtIndex:index withObject:jsonString];
                    } else {
                        [self.rosterListArray addObject:jsonString];
                    }
                }
            }
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(self.rosterListArray) {
            [self onParticipants];
            
            if([self.delegate respondsToSelector:@selector(muteStateChanged:)] ) {
                [self.delegate muteStateChanged:self.rosterListArray];
            }
        }
    });
}

- (void)OnObjectRequestVideoStreamCallBack:(const std::string&)msid width:(int)width height:(int)height framerate:(float)frame_rate {
    if(msid.rfind("VCS", 0) == 0) {
        self.contentRequestBlock([NSString stringWithCString:msid.c_str() encoding:NSUTF8StringEncoding], width, height, frame_rate);
        
        [[DeviceObjectClient sharedDeviceObject] configContentMediaId:msid];
        
        frame_rate = frame_rate > 100.f ? frame_rate/100.f : frame_rate;
        
        [[DeviceObjectClient sharedDeviceObject] configContentCapbilityLevel:width height:height framerate:frame_rate];
       
        if (FRTCSDK_SHARE_CONTENT_APPLICATION == self.shareContentType) {
            [[DeviceObjectClient sharedDeviceObject] startAppWindowCapture];
        } else if (FRTCSDK_SHARE_CONTENT_DESKTOP == self.shareContentType) {
            [[DeviceObjectClient sharedDeviceObject] startDesktopScreenCapture:self.isSendContentAudio];
        }
        
        if(self.isSendContentAudio) {
            if (@available(macOS 13.0, *)) {
#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 130000
                if(self.shareContentType == FRTCSDK_SHARE_CONTENT_APPLICATION) {
                    [[DeviceObjectClient sharedDeviceObject] 
                     startAppContentAudioWithWindowID:self.windowID];
                }
#else
                [self setupVirtualAudioDevice];
#endif
            } else {
                [self setupVirtualAudioDevice];
            }
        }
    }
}

- (void)OnObjectAddVideoStreamCallBack:(const std::string&)msid {
    self.videoReceivedBlock([NSString stringWithFormat:@"%s", msid.c_str()]);
}

- (void)OnObjectDetectAudioMuteCallBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.callDelegate && [self.callDelegate respondsToSelector:@selector(onMutedDetected)]) {
            [self.callDelegate onMutedDetected];
        }
    });
}

- (void)OnObjectTextOverlayCallBack:(RTC::TextOverlay *)text_overly {
    NSDictionary *dic = @{
        @"color"                    : [self transferToString:text_overly->color],
        @"content"                  : [self transferToString:text_overly->text],
        @"displaySpeed"             : [self transferToString:text_overly->display_speed],
        @"font"                     : [self transferToString:text_overly->font],
        @"type"                     : [self transferToString:text_overly->text_overlay_type],
        @"backgroundTransparency"   : @(text_overly->background_transparency),
        @"displayRepetition"        : @(text_overly->display_repetition),
        @"fontSize"                 : @(text_overly->font_size),
        @"verticalPosition"         : @(text_overly->vertical_position),
        @"enabledMessageOverlay"    : [NSNumber numberWithBool:text_overly->enabled ? YES : NO]
    };
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:0];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.callDelegate && [self.callDelegate respondsToSelector:@selector(onMeetingMessage:)]) {
            [self.callDelegate onMeetingMessage:jsonString];
        }
    });
}

- (void)OnObjectMeetingSessionStatusCallBack:(std::string)watermark_msg
                            recording_status:(std::string)recording_status
                            streaming_status:(std::string)streaming_status
                               streaming_url:(std::string)streaming_url
                               streaming_pwd:(std::string)streaming_pwd {
    NSString *contentWaterMessage = [NSString stringWithCString:watermark_msg.c_str() encoding:NSUTF8StringEncoding];
    self.waterMaskCallBack(contentWaterMessage);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.callDelegate && [self.callDelegate respondsToSelector:@selector(onRecordStatus:liveStatus:liveMeetingUrl:liveMeetingPassword:)]) {
            [self.callDelegate onRecordStatus:[NSString stringWithCString:recording_status.c_str() encoding:NSUTF8StringEncoding]
                                   liveStatus:[NSString stringWithCString:streaming_status.c_str() encoding:NSUTF8StringEncoding]
                               liveMeetingUrl:[NSString stringWithCString:streaming_url.c_str() encoding:NSUTF8StringEncoding]
                          liveMeetingPassword:[NSString stringWithCString:streaming_pwd.c_str() encoding:NSUTF8StringEncoding]];
        }
    });
}

- (void)OnObjectUnmuteRequestCallBack:(const std::map<std::string, std::string>&)parti_list {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    for(std::map<std::string, std::string>::const_iterator item = parti_list.begin(); item != parti_list.end(); item++) {
        [dictionary setObject:[NSString stringWithCString:(item->second).c_str() encoding:NSUTF8StringEncoding] forKey:[NSString stringWithCString:(item->first).c_str() encoding:NSUTF8StringEncoding]];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.callDelegate && [self.callDelegate respondsToSelector:@selector(onReceiveUnmuteRequest:)]) {
            [self.callDelegate onReceiveUnmuteRequest:dictionary];
        }
    });
}

- (void)OnObjectUnmuteAllowCallBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.callDelegate && [self.callDelegate respondsToSelector:@selector(onReceiveAllowUnmute)]) {
            [self.callDelegate onReceiveAllowUnmute];
        }
    });
}

- (void)OnObjectMuteLockCallBack:(bool)muted allow_self_unmute:(bool)allow_self_unmute {
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL mute = muted ? YES : NO;
        BOOL allowSelfUnMute = allow_self_unmute ? YES : NO;
        if(self.callDelegate && [self.callDelegate respondsToSelector:@selector(onMute:allowSelfUnmute:)]) {
            [self.callDelegate onMute:mute allowSelfUnmute:allowSelfUnMute];
        }
    });
}

- (void)OnObjectContentStatusChangeCallBack:(BOOL)isSending {
    if([self.delegate respondsToSelector:@selector(contentStateChanged:)] ) {
        [self.delegate contentStateChanged:isSending];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.callDelegate && [self.callDelegate respondsToSelector:@selector(onContentState:)]) {
            [self.callDelegate onContentState:isSending ? 1 : 0];
        }
    });
    
    if (isSending && self.sendingContent) {
        return;
    }
    if (!isSending && !self.sendingContent) {
        return;
    }
    self.sendingContent = isSending;
}

- (void)OnObjectLayoutChangeCallBack:(const RTC::LayoutDescription&)layout {
    std::vector<RTC::LayoutCell> layoutCells = layout.layout_cells;
    NSMutableArray<UserBasicInformation *> *layoutItem = [NSMutableArray array];
    
    for(std::vector<RTC::LayoutCell>::iterator iter = layoutCells.begin();iter != layoutCells.end();iter++) {
        UserBasicInformation *infoItem  = [[UserBasicInformation alloc] init];
        infoItem.mediaID           = [self transferToString:iter->msid];
        infoItem.userDisplayName        = [self transferToString:iter->display_name];
        infoItem.userUUID               = [self transferToString:iter->uuid];
        infoItem.resolutionHeight       = (NSInteger)iter->height;
        infoItem.resolutionWidth        = (NSInteger)iter->width;
        
        [layoutItem addObject:infoItem];
    }
    
    SDKLayoutInfo sdkLayoutInfo;
    sdkLayoutInfo.layout = layoutItem;
    sdkLayoutInfo.activeMediaID = [self transferToString:layout.active_speaker_msid];
    sdkLayoutInfo.activeSpeakerUuId     = [self transferToString:layout.active_speaker_uuid];
    sdkLayoutInfo.cellCustomUUID        = [self transferToString:layout.pin_speaker_uuid];
    sdkLayoutInfo.bContent              = layout.has_content;
    
    self.layoutChangedBlock(sdkLayoutInfo);
    
    @autoreleasepool {
        NSString *pinUUID = [self transferToString:layout.pin_speaker_uuid];
        self.pinUUID = pinUUID;
        
        if([pinUUID isEqualToString:[[FrtcUUID sharedUUID] getAplicationUUID]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(self.callDelegate && [self.callDelegate respondsToSelector:@selector(onPinStatus:)]) {
                    [self.callDelegate onPinStatus:YES];
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(self.callDelegate && [self.callDelegate respondsToSelector:@selector(onPinStatus:)]) {
                    [self.callDelegate onPinStatus:NO];
                }
            });
        }
        
        @synchronized(self.rosterListArray) {
            NSMutableArray *array = [self.rosterListArray mutableCopy];
            NSInteger pinIndex = 0;
            for(int i = 0; i < array.count; i++) {
                NSString *str = array[i];
                NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:NSJSONReadingMutableContainers
                                                                             error:&err];
                
                if([((NSString *)dic[@"UUID"]) isEqualToString:pinUUID]) {
                    [dic setObject:[NSNumber numberWithBool:YES] forKey:@"pin"];
                    pinIndex = i;
                } else {
                    [dic setObject:[NSNumber numberWithBool:NO] forKey:@"pin"];
                }
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:0];
                NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
             
                [self.rosterListArray replaceObjectAtIndex:i withObject:dataStr];
            }
            
            if(pinIndex != 0) {
                NSString *pinString = self.rosterListArray[pinIndex];
                [self.rosterListArray removeObjectAtIndex:pinIndex];
                if(self.rosterListArray.count > 1) {
                    NSString *str = self.rosterListArray[1];
                    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                    NSError *err;
                    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:&err];
                    
                    if([((NSNumber *)dic[@"lecture"]) boolValue]) {
                        if(self.rosterListArray.count == 2) {
                            [self.rosterListArray addObject:pinString];
                        } else {
                            [self.rosterListArray insertObject:pinString atIndex:2];
                        }
                    } else {
                        [self.rosterListArray insertObject:pinString atIndex:1];
                    }
                } else {
                    [self.rosterListArray addObject:pinString];
                }
            }
        }
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(self.rosterListArray) {
            if(self.rosterListArray.count > 0) {
                //NSLog(@"The roster list array is %@", self.rosterListArray[0]);
            } else if(self.rosterListArray.count == 0 && ![self.pinUUID isEqualToString:@""]){
                NSLog(@"have no user");
                NSDictionary *dic = @{@"muteAudio":self.is_audio_muted ? @"true" :@"false",
                                      @"userId"   :@"",
                                      @"UUID"     :[[FrtcUUID sharedUUID] getAplicationUUID],
                                      @"pin"      :[[[FrtcUUID sharedUUID] getAplicationUUID] isEqualToString:self.pinUUID] ? @YES : @NO,
                                      @"lecture"  :[[[FrtcUUID sharedUUID] getAplicationUUID] isEqualToString:self.lectureUUID] ? @YES : @NO,
                                      @"name"     :self.disPlayName,
                                      @"muteVideo":self.is_video_muted ? @"true" :@"false"
                };
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:0];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
                [self.rosterListArray insertObject:jsonString atIndex:0];
            }
            
            [self onParticipants];
        }
    });
}

- (void)OnObjectLayoutSettingCallBack:(int)max_cell_count lectures:(const std::vector<std::string>&) lectures {
    NSMutableArray<NSString *> *lectureListArray = [NSMutableArray array];
    
    for(std::vector<std::string>::const_iterator iter = lectures.begin();iter < lectures.end(); iter++) {
        [lectureListArray addObject:[NSString stringWithCString:(*iter).c_str() encoding:NSUTF8StringEncoding]];
    }
    
    if(lectureListArray.count != 0) {
        self.lectureUUID = lectureListArray[0];
    } else {
        self.lectureUUID = @"";
    }
        
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.callDelegate && [self.callDelegate respondsToSelector:@selector(onLectureList:)]) {
            [self.callDelegate onLectureList:lectureListArray];
        }
    });
    
    @synchronized(self.rosterListArray) {
        NSMutableArray *array = [self.rosterListArray mutableCopy];
        NSInteger indexLecture = 0;
        for(int i = 0; i < array.count; i++) {
            NSString *str = array[i];
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:&err];
            
            if([((NSString *)dic[@"UUID"]) isEqualToString:self.lectureUUID]) {
                [dic setObject:[NSNumber numberWithBool:YES] forKey:@"lecture"];
                indexLecture = i;
            } else {
                [dic setObject:[NSNumber numberWithBool:NO] forKey:@"lecture"];
            }
            
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:0];
            NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
            [self.rosterListArray replaceObjectAtIndex:i withObject:dataStr];
        }
        
        if(indexLecture != 0) {
            NSString *lectureString = self.rosterListArray[indexLecture];;
            [self.rosterListArray removeObjectAtIndex:indexLecture];
            [self.rosterListArray insertObject:lectureString atIndex:1];
        }
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(self.rosterListArray) {
            [self onParticipants];
        }
    });
}

- (void)OnObjectPasscodeRequestCallBack {
    self.passwordBack();
}

- (void)OnObjectDeleteVideoStreamCallBack:(const std::string&)msid {
    if([self.delegate respondsToSelector:@selector(onVideoRemoved:)] ) {
        [self.delegate onVideoRemoved:[NSString stringWithFormat:@"%s", msid.c_str()]];
    }
}

- (void)setupVirtualAudioDevice {
    if(_audioCeObject == NULL) {
        _audioCeObject = new ContentAudioInterface();
        _audioCeObject->Initialize((__bridge void *)self);
        _audioCeObject->StartContentAudio();
    }
}

- (void)clearVirtualAudioDevice {
    if(_audioCeObject != NULL) {
        _audioCeObject->StopContentAudio();
        delete _audioCeObject;
        _audioCeObject = NULL;
    }
}

- (void)clearContentAudio {
    if(self.isSendContentAudio) {
        if (@available(macOS 13.0, *)) {
            if(self.shareContentType == FRTCSDK_SHARE_CONTENT_APPLICATION) {
                [[DeviceObjectClient sharedDeviceObject] stopAppContentAudio];
            }
        } else {
            [self clearVirtualAudioDevice];
        }
        [self setContentAudioObject:false sameDevice:false];
    }
}

- (void)audioReveived:(const std::string&)mediaID {
    self.audioReceivedBlock([NSString stringWithCString:mediaID.c_str() encoding:NSUTF8StringEncoding]);
}


- (void)onContentPriorityChangeResponse:(std::string) status withKey:(std::string)transactionKey {
    NSString *sta = [NSString stringWithCString:status.c_str() encoding:NSUTF8StringEncoding];

    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.callDelegate && [self.callDelegate respondsToSelector:@selector(onContentPriorityChangeStatus:)]) {
            [self.callDelegate onContentPriorityChangeStatus:sta];
        }
    });
}

- (void)onParticipants {
    if(self.callDelegate && [self.callDelegate respondsToSelector:@selector(onParticipantsList:)]) {
        [self.callDelegate onParticipantsList:self.rosterListArray];
    }
}

- (void)sendPasscode:(NSString *)passcode {
    _impl->VerifyPasscodeImpl([passcode UTF8String]);
}

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
                   waterMaskCallBack:(void (^)(NSString *waterMaskString))waterMaskCallBack
            remoteVideoReceivedBlock:(void (^)(NSString *mediaID))videoReceivedBlock
            remoteAudioReceivedBlock:(void (^)(NSString *mediaID))audioReceivedBlock
           contentStreamRequestBlock:(void (^)(NSString *mediaID, int width, int height, int framerate))contentRequestBlock
                    videoFrozenBlock:(void (^)(NSString *mediaID, BOOL bFrozen))videoFrozenBlock
                       micMeterBlock:(void (^)(float meter))micMeterBlock {
    
    self.statusCallBack      = statusCallBack;
    self.paramsCallBack      = paramsCallBack;
    self.passwordBack        = passwordCallBack;
    self.layoutChangedBlock  = layoutChangedBlock;
    self.waterMaskCallBack   = waterMaskCallBack;
    self.videoReceivedBlock  = videoReceivedBlock;
    self.audioReceivedBlock  = audioReceivedBlock;
    self.contentRequestBlock = contentRequestBlock;
    self.videoFrozenBlock    = videoFrozenBlock;
    self.micMeterBlock       = micMeterBlock;
    self.disPlayName         = displayName;
    
    
    if (isLogin) {
        _impl->JoinMeetingLoginImpl([serverAddress UTF8String],[meetingAlias UTF8String],[displayName UTF8String], [userToken UTF8String], [meetingPassword UTF8String], callRate, [userId UTF8String]);
    } else {
        _impl->JoinMeetingNoLoginImpl([serverAddress UTF8String], [meetingAlias UTF8String], [displayName UTF8String], [meetingPassword UTF8String], callRate);
    }
}

- (void)endMeetingWithCallIndex:(int)callIndex {
    _impl->EndMeetingImpl(callIndex);
    
    NSString *mediaID = @"VPL_PREVIEW";
    [self resetVideoFrameObject:mediaID];
    
    [[DeviceObjectClient sharedDeviceObject] disableAudioUnitCoreGraph];
    [[DeviceObjectClient sharedDeviceObject] disableCameraWork];
    
    if(self.isSendingContent) {
        if (FRTCSDK_SHARE_CONTENT_APPLICATION == _shareContentType) {
            [[DeviceObjectClient sharedDeviceObject] stopAppWindowCapture];
        } else if (FRTCSDK_SHARE_CONTENT_DESKTOP == _shareContentType) {
            [[DeviceObjectClient sharedDeviceObject] stopDesktopScreenCapture];
        }
        self.shareContentType = FRTCSDK_SHARE_CONTENT_IDLE;
        [self stopSendContentObject];
    }
}

- (void)sendVideoFrameObject:(NSString *)mediaID
                 videoBuffer:(void *)buffer
                      length:(size_t)length 
                       width:(size_t)width
                      height:(size_t)height
             videoSampleType:(RTC::VideoColorFormat)type {
    _impl->SendVideoFrameImpl([mediaID UTF8String], buffer, (unsigned int)length, (unsigned int)width, (unsigned int)height, type, false);
}

- (void)receiveVideoFrameObject:(NSString *)mediaID
                         buffer:(void **)buffer
                         length:(unsigned int* )length
                          width:(unsigned int* )width
                         height:(unsigned int*) height {
    std::string temp_media_id = [mediaID UTF8String];
    _impl->ReceiveVideoFrameImpl(temp_media_id, buffer, length, width, height);
}

- (void)resetVideoFrameObject:(NSString *)mediaID {
    std::string temp_media_id = [mediaID UTF8String];
    _impl->ResetVideoFrameImpl(temp_media_id);
}

- (void)sendAudioFrameObject:(void *)buffer
                      length:(unsigned int )length
                 sampleRatge:(unsigned int)sample_rate {
    _impl->SendAudioFrameImpl(buffer, length, sample_rate);
    
    float meter = 0;
    [self parseMicAudio:(unsigned char *)buffer numFrames:length / 2 enegry:&meter];
    self.micMeterBlock(meter * 6);
}

- (void)receiveAudioFrameObject:(void *)buffer dataLength:(unsigned int)length sampleRate:(unsigned int)sample_rate {
    _impl->ReceiveAudioFrameImpl(buffer, length, sample_rate);
}

- (void)startSendContentObject {
    _impl->StartSendContentImpl();
}

- (void)stopSendContentObject {
    _impl->StopSendContentImpl();
}

- (void)setContentAudioObject:(bool)enable sameDevice:(bool)isSameDevice {
    _impl->SetContentAudioImpl(enable, isSameDevice);
}

- (void)sendContentAudioFrameObject:(NSString *)mediaID
                        videoBuffer:(void *)buffer
                             length:(unsigned int)length
                         sampleRate:(unsigned int)sample_rate {
    _impl->SendContentAudioFrameImpl([mediaID UTF8String], buffer, length, sample_rate);
}

- (void)verifyPasscodeObject:(NSString *)passcode {
    _impl->VerifyPasscodeImpl([passcode UTF8String]);
}

- (void)muteLocalVideoObject:(bool)muted {
    self.is_video_muted = muted;
    _impl->MuteLocalVideoImpl(muted);
}

- (void)muteLocalAudioObject:(bool)muted {
    self.is_audio_muted = muted;
    _impl->MuteLocalAudioImpl(muted);
}

- (void)setLayoutGridModeObject:(bool)gridMode {
    _impl->SetLayoutGridModeImpl(gridMode);
}

- (void)setIntelligentNoiseReductionObject:(bool) enable {
    _impl->SetIntelligentNoiseReductionImpl(enable);
}

- (void)SetCameraStreamMirrorObject:(bool)is_mirror {
    _impl->SetCameraStreamMirrorImpl(is_mirror);
}

- (void)setCameraCapabilityObject:(std::string)resolution_str {
    return _impl->SetCameraCapabilityImpl(resolution_str);
}

- (NSString *)getMediaStatisticsObject {
    std::string staticsString = _impl->GetMediaStatisticsImpl();
    return  [NSString stringWithCString:staticsString.c_str() encoding:NSUTF8StringEncoding];
}

- (NSInteger)startUploadLogsObject:(NSString *)metaData
                          fileName:(NSString *)fileName
                         fileCount:(int)fileCount {
    return _impl->StartUploadLogsImpl([metaData UTF8String], [fileName UTF8String], fileCount);
}

- (NSString *)getUploadStatusObject:(int)tractionId {
    std::string logString = _impl->GetUploadStatusImpl(tractionId);

    return [NSString stringWithCString:logString.c_str() encoding:NSUTF8StringEncoding];;
}

- (void)cancelUploadLogsObject:(int)tractionId {
    _impl->CancelUploadLogsImpl(tractionId);
}

- (void)startSendContentStream:(NSString *)mediaID
                   videoBuffer:(void *)buffer
                        length:(size_t)length
                         width:(size_t)width height:(size_t)height
                        stride:(size_t)stride
               videoSampleType:(RTC::VideoColorFormat)type {
    _impl->SendVideoFrameImpl([mediaID UTF8String], buffer, (unsigned int)length, (unsigned int)width, (unsigned int)height, type, true, (unsigned int)stride);
}


- (bool)parseMicAudio:(unsigned char *)pData numFrames:(int)nNumFrames enegry:(float *)meter {
    if(pData == 0x00) {
        *meter = 0.0;
        return false;
    }

    int nNumChannels = 1;
    float temp_energy = 0.0f;
    if (nNumChannels == 1 ) {
        short* pF = (short*)pData;
        for (int i = 0; i < nNumFrames; ++i) {
            float e = (float)pF[i];
            if (e < 0) e = -e;
            if (e > 32767) e = 32767;
            temp_energy += e;
        }
    }
    
    temp_energy *= (1. / nNumFrames);
    temp_energy /= 32767.0f;

    if (meter) {
        *meter = temp_energy;
    }

    return true;
}

- (void)shareContent:(BOOL)isShareContent
     withContentType:(int)shareContentType
       withDesktopID:(uint32_t)desktopId
        withWindowID:(unsigned int)appWindowID
  withAppContentName:(NSString *)sourceAppContentName
    withContentAudio:(BOOL)sendContentAudio {
    if (!isShareContent) {
        if (FRTCSDK_SHARE_CONTENT_APPLICATION == self.shareContentType) {
            [[DeviceObjectClient sharedDeviceObject] stopAppWindowCapture];
        } else if (FRTCSDK_SHARE_CONTENT_DESKTOP == self.shareContentType) {
            [[DeviceObjectClient sharedDeviceObject] stopDesktopScreenCapture];
        }
        
        [self stopSendContentObject];
    } else {
        if (FRTCSDK_SHARE_CONTENT_DESKTOP == shareContentType) {
            self.shareContentType = FRTCSDK_SHARE_CONTENT_DESKTOP;
            [[DeviceObjectClient sharedDeviceObject] configDirectDisplayID:desktopId];
            [self startSendContentObject];
            self.sendContentAudio = sendContentAudio;
        } else if (FRTCSDK_SHARE_CONTENT_APPLICATION == shareContentType) {
            self.shareContentType = FRTCSDK_SHARE_CONTENT_APPLICATION;
            self.windowID         = appWindowID;
            NSString *appWindows = [NSString stringWithFormat:@"%d", appWindowID];
            [[DeviceObjectClient sharedDeviceObject] configApplicationWindowID:appWindows]; //for Indicator window.
            [[DeviceObjectClient sharedDeviceObject] configApplicationName:sourceAppContentName]; //for app content capture lib.
        
            [self startSendContentObject];
            self.sendContentAudio = sendContentAudio;
       
            [[DeviceObjectClient sharedDeviceObject] showShareIndicatorAndPrepareForAppShare];
        }
    }
}

- (void)sendContentAudioFrame:(short *)buffer sampleRate:(int)sampleRate {
    NSString *mediaID = @"_parxSourceID";
    [self sendContentAudioFrameObject:mediaID videoBuffer:buffer length:960 sampleRate:48000];
}

- (NSString *)onDeviceName {
    return [[NSHost currentHost] localizedName];
}


- (int)getCPULevelObject {
    return _impl->GetCPULevelImpl();
}



- (NSString*)getVersion {
   std::string ver = _impl->GetSDKVersion();
    return  [NSString stringWithCString:ver.c_str() encoding:NSUTF8StringEncoding];
}

- (NSArray *)getApplicationList {
    _applicationQueue = ShareAPP::SystemUtilMac::MacGetAppLicationList();
    
    NSMutableArray *applicationArray = [NSMutableArray array];
    for (ShareAPP::ApplicationIter iter = _applicationQueue.begin(); iter != _applicationQueue.end(); ++iter) {
        ContentSourceInfo *sourceInfo = [[ContentSourceInfo alloc] init];
        sourceInfo.contentType = 1;
        sourceInfo.contentKey = (unsigned int)iter->_windowId;
        NSRunningApplication *app = [NSRunningApplication runningApplicationWithProcessIdentifier:(pid_t)iter->_processId];
        if (app != nil) {
            sourceInfo.contentIcon = [app icon];
        } else {
            sourceInfo.contentIcon = nil;
        }
        sourceInfo.contentShareable = (BOOL)iter->_isShareable;
        sourceInfo.processId = (pid_t)iter->_processId;
        NSString *applicationName = [[NSString alloc] initWithBytes:iter->_title.data()
                                                              length:iter->_title.size() * sizeof(wchar_t)
                                                            encoding:NSUTF32LittleEndianStringEncoding];
        sourceInfo.contentName = applicationName;
        sourceInfo.processName = [[NSString alloc] initWithBytes:iter->processName.data()
                                                           length:iter->processName.size() * sizeof(wchar_t)
                                                         encoding:NSUTF32LittleEndianStringEncoding];

        
        [applicationArray addObject:sourceInfo];
    }

    return applicationArray;
}



- (NSString *)transferToString:(std::string)string {
    return [NSString stringWithCString:string.c_str() encoding:NSUTF8StringEncoding];
}


@end
