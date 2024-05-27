#import "MeetingBackground.h"
#import "DeviceObject.h"
#import "MeetingUserInformation.h"
#import "MeetingLayoutContext.h"
#import "LocationContext.h"
#import "MeetingUserInformation.h"
#import "MeetingLayoutContext.h"
#import "ObjectInterface.h"

@interface MeetingBackground ()<MeetingLayoutContextDelegate>

@property (nonatomic, strong) FrtcMTKView *localVideoView;

@property (nonatomic, strong) NSImageView *muteCameraBackgroundView;

@property (nonatomic, copy)   NSMutableArray *remotePeopleVideoViewList;

@property (nonatomic, strong) NSMutableArray *remotePeoplemediaID;

@property (nonatomic, assign, getter=isReturnToFullScreen) BOOL returnToFullScreen;

@property (nonatomic, assign, getter=isExitFromeFullScreen) BOOL exitFromeFullScreen;

@property (nonatomic, assign, getter=isWaterMask) BOOL waterMask;

@property (nonatomic, copy)   NSString *cellCustomUUID;

@property (nonatomic, assign) NSSize currentScreenSize;

@property (nonatomic, assign, getter = isContent) BOOL content;

@property (nonatomic, assign, getter = isLocalViewHiddenByUser) BOOL localViewHiddenByUser;

@property (nonatomic, copy)     NSString *activeSpeakerMediaID;

@property (nonatomic, copy) NSMutableArray<NSString *> *rosterListArray;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) NSInteger remotePeopleCount;


@end

@implementation MeetingBackground

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (BOOL)isFlipped {
    return YES;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor blackColor].CGColor;
        self.presenterLayout = YES;
        
        self.remotePeoplemediaID = [NSMutableArray array];
        
        self.remotePeopleCount = 0;
        
        [MeetingLayoutContext shareIstance].delegate = self;
        
        CGFloat width  = frameRect.size.width;
        CGFloat height = frameRect.size.height;
        CGRect localRect = CGRectMake(0, height / 12, width, height * 0.8);
        localRect = CGRectMake(0, 0, width, height * 0.8);
        
        self.width = width;
        self.height = height;
        
        NSString *mediaID = @"VPL_PREVIEW";
        self.presenterLayout = YES;
        
        localRect = CGRectMake(0, height / 12, width, height * 0.8);
        self.localVideoView = [[FrtcMTKView alloc] initWithFrame:localRect mediaID:mediaID];
        [self.localVideoView configVideoColorFormat:RTC::kI420];
        
        [[DeviceObjectClient sharedDeviceObject] setCameraMediaId:mediaID];
        [self.localVideoView setVideoRenderMediaID:mediaID];
        [self.localVideoView initiateVideoRendering];
       
        [self.localVideoView setHidden:NO];
        _remotePeopleVideoViewList = [[NSMutableArray alloc] initWithCapacity:9];

        for(int i = 0; i < 9; i++) {
            FrtcMTKView *remoteVideoView;
            remoteVideoView = [[FrtcMTKView alloc] initWithFrame:CGRectMake(0, 0, width, height * 0.8) mediaID:@"remote"];
            [remoteVideoView configVideoColorFormat:RTC::kI420];
            [self addSubview:remoteVideoView];
            [remoteVideoView setHidden:YES];
            [_remotePeopleVideoViewList addObject:remoteVideoView];
        }
        
        [self.contentVideoView setHidden:true];
      
        if(self.isVideoMute) {
            [self.localVideoView endupVideoRendering];
        }
        
        [self addSubview:self.localVideoView];
    }
    
    return self;
}

- (void)muteStateChanged:(NSMutableArray *)array {
    self.rosterListArray = array;
    for(NSString *str in _rosterListArray) {
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
        if(!err) {
            for(int i = 0; i < _remotePeopleVideoViewList.count; i++) {
                FrtcMTKView *view = _remotePeopleVideoViewList[i];
                if(!view.isHidden && [view.userUUID isEqualToString:dic[@"UUID"]]) {
                    BOOL mute;
                    
                    if([dic[@"muteAudio"] isEqualToString:@"true"]) {
                        [view updateSiteNameView:YES];
                        mute = YES;
                    } else {
                        [view updateSiteNameView:NO];
                        mute = NO;
                    }
                    
                    view.siteNameTextField.stringValue = dic[@"name"];
                    view.userNameView.nameLabel.stringValue = dic[@"name"];
                    
                    if(!self.contentVideoView.hidden && [self.contentVideoView.userNameView.nameLabel.stringValue isEqualToString:view.userNameView.nameLabel.stringValue]) {
                        [self.contentVideoView updateSiteNameView:mute];
                    }
                }
            }
        }
    }
}

- (FrtcMTKView *)getVideoViewControllerByViewId :(NSString *)mediaID {
    for (int i = 0; i < [self.remotePeopleVideoViewList count]; i++) {
        FrtcMTKView *view = self.remotePeopleVideoViewList[i];
        if([view.mediaID isEqualToString:mediaID]) {
            return view;
        }
    }
    
    for(int i = 0; i < [self.remotePeopleVideoViewList count]; i++) {
        FrtcMTKView *view = self.remotePeopleVideoViewList[i];
        if(view.hidden) {
            [view setVideoRenderMediaID:mediaID];
            return view;
        }
    }
    
    return NULL;
}

extern SDKMeetingLayout sdkMeetingLayoutDescription[MEETING_LAYOUT_NUMBER];

- (void)updateRemoteUserNumber:(MeetingLayoutNumber)number withUserArray:(NSMutableArray *)userArray {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if(self.isSendingContent) {
        self.contentVideoView.hidden = YES;
    }
    CGRect localRect;
    
    if(self.isVideoMute) {
        self.muteCameraBackgroundView.frame = CGRectMake(0, 0, localRect.size.width, localRect.size.height);
    }
    
    [self remoteViewHiddenOrNot:userArray];
    [self layoutRemoteView:userArray layoutMode:number];
#pragma clang diagnostic pop
}

- (void)remoteViewHiddenOrNot:(NSMutableArray *)viewArray {
    for (int i = 0; i < _remotePeopleVideoViewList.count; i++) {
        BOOL bFind = NO;
        FrtcMTKView *view = _remotePeopleVideoViewList[i];

        for (int j = 0; j < [viewArray count]; j++ ) {
            MeetingUserInformation *videoInfo = [viewArray objectAtIndex:j];
            if ([view.mediaID isEqualToString:videoInfo.mediaID]) {
                bFind = YES;
                break;
            }
        }

        if (!bFind) {
            [view setHidden:YES];
            [view displayMuteViews:YES];
            [view endupVideoRendering];
        } else {
            [view setHidden:NO];
            [view initiateVideoRendering];
        }
    }
}

- (void)layoutRemoteView:(NSMutableArray *)layoutInfo layoutMode:(MeetingLayoutNumber)number {
    for (int i = 0; i < [layoutInfo count]; i++) {
        MeetingUserInformation *videoInfo = [layoutInfo objectAtIndex:i];

        FrtcMTKView  *remoteMVV;
        if(videoInfo.userType == USER_TYPE_REMOTE) {
            remoteMVV = [self getVideoViewControllerByViewId:videoInfo.mediaID];
        }
        
        if([self.remotePeoplemediaID containsObject:videoInfo.mediaID]) {
            [remoteMVV displayMuteViews:NO];
            [remoteMVV initiateVideoRendering];
        }
        
        LocationContext *locationContext    = [[LocationContext alloc] init];
        locationContext.currentScreenSize   = self.screenSize;
        locationContext.resolutionSize      = self.currentSize;
        locationContext.fullScreenSize      = self.fullScreenSize;
        locationContext.fullScreenView      = self.isFullScreen;
        locationContext.scacleProportion    = self.ratio;
        locationContext.layoutUserCount     = layoutInfo.count;
        locationContext.readySharingContent = self.isContentLayoutReady;
        
        LocationStrategy strategy;
        if(self.isPresenterLayout) {
            strategy = LOCATION_PRESENTER;
        } else {
            strategy = LOCATION_GALLERY;
        }
        
        CGRect rect = [locationContext computeUserLocationWithLayout:strategy withUserInfo:videoInfo withMeetingNumber:number withIndex:i];
        
        if(videoInfo.userType == USER_TYPE_LOCAL) {
            [self.localVideoView setFrame:rect];
        } else if(videoInfo.userType == USER_TYPE_CONTENT) {
            [self.contentVideoView setFrame:rect];
        } else if(videoInfo.userType == USER_TYPE_REMOTE) {
            if(i != 0) {
                if(self.isFullScreen) {
                    [remoteMVV removeFromSuperview];
                    [self addSubview:remoteMVV];
                }
            }

            [remoteMVV setFrame:rect];
        }

        remoteMVV.userNameView.nameLabel.stringValue = [NSString stringWithFormat:@"%@", videoInfo.strDisplayName];
        remoteMVV.siteNameTextField.stringValue = [NSString stringWithFormat:@"%@", videoInfo.strDisplayName];
        remoteMVV.userUUID = videoInfo.strUUID;
        for(NSString *str in self.rosterListArray) {
            NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:&err];
            if(!err) {
                for(int i = 0; i < _remotePeopleVideoViewList.count; i++) {
                    FrtcMTKView *view = _remotePeopleVideoViewList[i];
                    if(!view.isHidden && [view.userUUID isEqualToString:dic[@"UUID"]]) {
                        BOOL mute;
                        
                        if([dic[@"muteAudio"] isEqualToString:@"true"]) {
                            mute = YES;
                            [view updateSiteNameView:YES];
                        } else {
                            [view updateSiteNameView:NO];
                            mute = NO;
                        }
                        
                        if(!self.contentVideoView.hidden && [self.contentVideoView.userNameView.nameLabel.stringValue isEqualToString:view.userNameView.nameLabel.stringValue]) {
                            [self.contentVideoView updateSiteNameView:mute];
                        }
                    }
                }
            }
        }
        [remoteMVV.userNameView configNewUserNameView:videoInfo.isPin];
        [remoteMVV.userMuteView updatePin:videoInfo.isPin];
        
        if(videoInfo.resolutionWidth == -2) {
            [remoteMVV displayMuteViews:YES];
            [remoteMVV endupVideoRendering];
        }
       
        if(self.isRemoteViewHidden) {
            if(i != 0) {
                [remoteMVV setHidden:YES];
            }
            [self.localVideoView setHidden:YES];
        } else {
            [remoteMVV setHidden:NO];
            if(!self.isLocalViewHiddenByUser) {
                [self.localVideoView setHidden:NO];
            }
        }
        if(self.content) {
            if(videoInfo.isActive) {
                [remoteMVV setRemoteUserActivitySpeakerStatus:YES];
            } else {
                [remoteMVV setRemoteUserActivitySpeakerStatus:NO];
            }
        } else {
            if(self.isSendingContent) {
                if(videoInfo.isActive) {
                    [remoteMVV setRemoteUserActivitySpeakerStatus:YES];
                } else {
                    [remoteMVV setRemoteUserActivitySpeakerStatus:NO];
                }
            } else {
                if(self.isPresenterLayout) {
                    [remoteMVV setRemoteUserActivitySpeakerStatus:NO];
                } else {
                    if(layoutInfo.count == 2) {
                        [remoteMVV setRemoteUserActivitySpeakerStatus:NO];
                    } else {
                        if(videoInfo.isActive) {
                            [remoteMVV setRemoteUserActivitySpeakerStatus:YES];
                        } else {
                            [remoteMVV setRemoteUserActivitySpeakerStatus:NO];
                        }
                    }
                }
            }
        }
        
        if(![self.cellCustomUUID isEqualToString:@""]) {
            if(videoInfo.isActive && videoInfo.isPin) {
                [remoteMVV setRemoteUserActivitySpeakerStatus:NO];
            } else {
                if(videoInfo.isActive) {
                    [remoteMVV setRemoteUserActivitySpeakerStatus:YES];
                }
            }
        }
    }
    
    if(self.isFullScreen) {
        [self.localVideoView removeFromSuperview];
        [self addSubview:self.localVideoView];
    }
}

- (void)layoutUpdate:(SDKLayoutInfo)buffer {
    NSMutableArray<UserBasicInformation *> *layout = buffer.layout;
    self.remotePeopleCount = layout.count;
    
    bool isContent = buffer.bContent;
    if(isContent && !self.isSendingContent) {
        if(!self.content) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CGRect localRect = CGRectMake(0, self.height / 12,self.width, self.height * 0.8);
                localRect = CGRectMake(0, 0, self.width, self.height * 0.8);
                
                if(self.contentVideoView) {
                    [self.contentVideoView removeFromSuperview];
                    self.contentVideoView = nil;
                }
                FrtcMTKView *contentVideoView =  [[FrtcMTKView alloc] initWithFrame:localRect mediaID:@"content"];
                [contentVideoView configVideoColorFormat:RTC::kI420];
                self.contentVideoView = contentVideoView;
                [self addSubview:self.contentVideoView];
                [self.contentVideoView setHidden:NO];
                
                [[MeetingLayoutContext shareIstance] switchLayoutByStrategy:MEETING_LAYOUT_PRESENTER_LAYOUT];
                self.presenterLayout = YES;
                
                self.content = YES;
            });
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.contentVideoView setHidden:YES];
            if(self.content) {
                [self.contentVideoView displayMuteViews:YES];
                [self.contentVideoView endupVideoRendering];
                [self.contentVideoView setHidden:YES];
            }
            self.content = NO;
            if(self.isGallery) {
                self.presenterLayout = NO;
                self.remoteViewHidden = NO;
                if(self.isFullScreen) {
                    [[MeetingLayoutContext shareIstance] switchLayoutByStrategy:MEETING_LAYOUT_FULL_SCREEN_GALLERY_LAYOUT];
                } else {
                    [[MeetingLayoutContext shareIstance] switchLayoutByStrategy:MEETING_LAYOUT_GALLERY_LAYOUT];
                }
            }
        });
    }

    self.activeSpeakerMediaID = buffer.activeMediaID;
    self.cellCustomUUID = buffer.cellCustomUUID;
    NSMutableArray *svcLayoutInfo = [NSMutableArray array];
    
    for(int i = 0; i < layout.count; i++) {
        UserBasicInformation *valueItem = layout[i];
        MeetingUserInformation *videoInfo = [[MeetingUserInformation alloc] init];
        
        if([valueItem.mediaID containsString:@"VCR"]) {
            [self.contentVideoView setVideoRenderMediaID: valueItem.mediaID];
            videoInfo.userType          = USER_TYPE_CONTENT;
            videoInfo.mediaID           = valueItem.mediaID;
            videoInfo.maxResolution     = NO;
            videoInfo.strDisplayName    = valueItem.userDisplayName;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                videoInfo.resolutionHeight = self.width;
                videoInfo.resolutionWidth = self.height * 0.8;
                self.contentVideoView.userNameView.nameLabel.stringValue = [NSString stringWithFormat:@"%@", videoInfo.strDisplayName];
                self.contentVideoView.siteNameTextField.stringValue = @"";
                
            });
            
            [svcLayoutInfo insertObject:videoInfo atIndex:0];
        } else {
            videoInfo.mediaID = valueItem.mediaID;
            if([videoInfo.mediaID isEqualToString:self.activeSpeakerMediaID]) {
                videoInfo.active = YES;
            } else {
                videoInfo.active = NO;
            }
            videoInfo.userType          = USER_TYPE_REMOTE;
            videoInfo.resolutionHeight  = valueItem.resolutionHeight;
            videoInfo.resolutionWidth   = valueItem.resolutionWidth;
            videoInfo.strDisplayName    = valueItem.userDisplayName;
            videoInfo.strUUID           = valueItem.userUUID;
            videoInfo.removed           = NO;
            videoInfo.pin               = [self userPinStatus:valueItem.userUUID];
            
            BOOL isMax;
            if(i == 0) {
                isMax = YES;
            } else {
                isMax = NO;
            }
            
            videoInfo.maxResolution = isMax;
            [svcLayoutInfo addObject:videoInfo];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MeetingUserInformation *localUserInfo  = [[MeetingUserInformation alloc] init];
        localUserInfo.mediaID   = @"VPL_PREVIEW";
        localUserInfo.userType       = USER_TYPE_LOCAL;
        if(layout.count == 0) {
            localUserInfo.resolutionWidth   = self.width;
            localUserInfo.resolutionHeight  = self.height * 0.8;
        } else {
            localUserInfo.resolutionWidth   = 0.25 * self.width;
            localUserInfo.resolutionHeight  = 0.17 * self.height * 0.8;
        }
        [svcLayoutInfo addObject:localUserInfo];
        [[MeetingLayoutContext shareIstance] updateMeetingUserList:svcLayoutInfo];
    });
}

- (BOOL)userPinStatus:(NSString *)userUUID {
    if([userUUID isEqualToString:self.cellCustomUUID]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)remoteMediaID:(NSString *)mediaID {
    if(![_remotePeoplemediaID containsObject:mediaID]) {
        [_remotePeoplemediaID addObject:mediaID];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        if([mediaID containsString:@"VCR"]) {
            [self.contentVideoView setVideoRenderMediaID:mediaID];
            [self.contentVideoView initiateVideoRendering];
            [self.contentVideoView displayMuteViews:NO];

            if(self.isWaterMask) {
                [self.contentVideoView setupWaterMark:self.displayName];
            }
        } else {
            FrtcMTKView * view= [self getVideoViewControllerByViewId:mediaID];
            
            [view displayMuteViews:NO];
            [view initiateVideoRendering];
        }
    });
}

- (void)onWaterPrint:(NSString *)waterPrint {
    NSData *jsonData = [waterPrint dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(!err) {
        self.waterMask = [(NSNumber *)dic[@"enable"] boolValue];
    }
}

- (void)stopLocalRender:(BOOL)stop {
    if (stop) {
        [self.localVideoView displayMuteViews:stop];
        [self.localVideoView endupVideoRendering];
        [[DeviceObjectClient sharedDeviceObject] disableCapture];
    } else {
        [self.localVideoView initiateVideoRendering];
        [[DeviceObjectClient sharedDeviceObject] enableCapture];
        __weak typeof(self) weakSelf = self;
        
        [NSTimer scheduledTimerWithTimeInterval:1.7 repeats:NO block:^(NSTimer * _Nonnull timer) {
            [weakSelf.localVideoView displayMuteViews:stop];
        }];
    }
}

- (void)refreshCurrentLayout {
    NSMutableArray *viewArray = [[MeetingLayoutContext shareIstance] participantsList];
    MeetingLayoutNumber number = [[MeetingLayoutContext shareIstance] meetingNumber];
    
    if(viewArray.count == 0) {
        MeetingUserInformation *newVideoInfo = [[MeetingUserInformation alloc] init];
        newVideoInfo.mediaID = @"VPL_PREVIEW";
        newVideoInfo.userType = USER_TYPE_LOCAL;
        [viewArray addObject:newVideoInfo];
        number = MEETING_LAYOUT_NUMBER_1;
    }
    
    [self updateRemoteUserNumber:number withUserArray:viewArray];
}

- (void)switchLayout:(BOOL)isGallery {
    self.gallery            = isGallery;
    self.presenterLayout    = !isGallery;
    if(self.isPresenterLayout) {
        [[MeetingLayoutContext shareIstance] switchLayoutByStrategy:MEETING_LAYOUT_PRESENTER_LAYOUT];
    } else {
        self.remoteViewHidden = NO;
        if(self.isFullScreen) {
            [[MeetingLayoutContext shareIstance] switchLayoutByStrategy:MEETING_LAYOUT_FULL_SCREEN_GALLERY_LAYOUT];
        } else {
            [[MeetingLayoutContext shareIstance] switchLayoutByStrategy:MEETING_LAYOUT_GALLERY_LAYOUT];
        }
    }
    
    [self refreshCurrentLayout];
}

- (void)onVideoFrozen:(NSString *)mediaId videoFrozen:(BOOL)bFrozen {
    FrtcMTKView * view = [self getVideoViewControllerByViewId:mediaId];
    if(bFrozen) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [view displayMuteViews:YES];
        });
       
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [view displayMuteViews:NO];
        });
    }
}

- (void)stopVideoRender {
    [self.localVideoView endupVideoRendering];
    [self.contentVideoView endupVideoRendering];
       
    for (int i = 0; i < [_remotePeopleVideoViewList count]; i++) {
        FrtcMTKView *view = _remotePeopleVideoViewList[i];
        [view endupVideoRendering];
    }
}

- (void)disappearLocal:(BOOL)disapper {
    self.localViewHiddenByUser = disapper;
    [self.localVideoView setHidden:disapper];
}


@end
