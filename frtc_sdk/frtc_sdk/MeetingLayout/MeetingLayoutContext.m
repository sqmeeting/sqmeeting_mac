#import "MeetingLayoutContext.h"
#import "MeetingUserInformation.h"
#import "PresenterLayout.h"
#import "GalleryLayout.h"
#import "FullScreenGalleryLayout.h"

static MeetingLayoutContext *sharedMeetingLayoutContext = nil;

@interface MeetingLayoutContext ()

@property (nonatomic, strong) BaseLayout *meetingLayoutStrategy;

@end

@implementation MeetingLayoutContext

- (id)init {
    self = [super init];
    if (self) {
        _meetingNumber = MEETING_LAYOUT_NUMBER_1;
        _participantsList = [[NSMutableArray alloc] init];
        self.meetingLayoutStrategy = [[PresenterLayout alloc] init];
    }
    return self;
}

#pragma mark - public functions
+ (MeetingLayoutContext *)shareIstance {
    if (sharedMeetingLayoutContext == nil) {
        @synchronized(self) {
            if (sharedMeetingLayoutContext == nil) {
                sharedMeetingLayoutContext = [[MeetingLayoutContext alloc] init];
            }
        }
    }
    
    return sharedMeetingLayoutContext;
}

- (void)switchLayoutByStrategy:(MeetingLayoutStrategy)strategy {
    if(strategy == MEETING_LAYOUT_PRESENTER_LAYOUT) {
        self.meetingLayoutStrategy = [[PresenterLayout alloc] init];
        self.galleryLayout = NO;
    } else if(strategy == MEETING_LAYOUT_GALLERY_LAYOUT) {
        self.meetingLayoutStrategy = [[GalleryLayout alloc] init];
        self.galleryLayout = YES;
    } else if(strategy == MEETING_LAYOUT_FULL_SCREEN_GALLERY_LAYOUT) {
        self.meetingLayoutStrategy = [[FullScreenGalleryLayout alloc] init];
        self.galleryLayout = YES;
    }
    
    [self.meetingLayoutStrategy layoutStrategy];
    
}

- (void)updateUserNumber {
    NSInteger svcVideoCount = [_participantsList count];
    if(svcVideoCount == 2) {
        _meetingNumber = MEETING_LAYOUT_NUMBER_1;
    } else if(svcVideoCount == 3) {
        _meetingNumber = MEETING_LAYOUT_NUMBER_2;
    } else if(svcVideoCount == 4) {
        _meetingNumber = MEETING_LAYOUT_NUMBER_3;
    } else if(svcVideoCount == 5) {
        _meetingNumber = MEETING_LAYOUT_NUMBER_4;
    } else if(svcVideoCount == 6) {
        _meetingNumber = MEETING_LAYOUT_NUMBER_5;
    } else if(svcVideoCount == 7) {
        _meetingNumber = MEETING_LAYOUT_NUMBER_6;
    } else if(svcVideoCount == 8) {
        _meetingNumber = MEETING_LAYOUT_NUMBER_7;
    } else if(svcVideoCount == 9) {
        _meetingNumber = MEETING_LAYOUT_NUMBER_8;
    } else if(svcVideoCount == 10) {
        _meetingNumber = MEETING_LAYOUT_NUMBER_9;
    }
}

- (void)refreshParticipants {
    [_participantsList removeAllObjects];
}

- (void)updateMeetingUserList:(NSMutableArray *)meetingUserList {
    NSMutableArray *removeArray = [NSMutableArray array];

    for (int j = (int)[_participantsList count] - 1; j >= 0; j--) {
        MeetingUserInformation *videoInfo = [_participantsList objectAtIndex:j];
        
        BOOL bFind = NO;
        for (int i = 0; i < meetingUserList.count; i++) {
            MeetingUserInformation * videoParam = (MeetingUserInformation *)meetingUserList[i];
            if ([videoParam.mediaID isEqualToString:videoInfo.mediaID]) {
                videoInfo.resolutionHeight = videoParam.resolutionHeight;
                videoInfo.resolutionWidth  = videoParam.resolutionWidth;
                videoInfo.active           = videoParam.isActive;
                videoInfo.maxResolution    = videoParam.isMaxResolution;
                videoInfo.pin              = videoParam.pin;
                videoInfo.removed          = NO;
                videoInfo.strUUID          = videoParam.strUUID;
                videoInfo.strDisplayName   = videoParam.strDisplayName;
                bFind = YES;
                break;
            }
        }
        
        if (!bFind) {
            videoInfo.removed = YES;
            [removeArray addObject:[NSNumber numberWithInt:j]];
        }
    }
    
    if(_participantsList.count == 0) {
        [_participantsList addObjectsFromArray:meetingUserList];
    }

    for (int i = 0; i < meetingUserList.count; i++) {
        BOOL bFind = NO;
        MeetingUserInformation * videoParam = (MeetingUserInformation *)meetingUserList[i];
        for (MeetingUserInformation *videoInfo in _participantsList) {
            if ([videoInfo.mediaID isEqualToString:videoParam.mediaID]) {
                bFind = YES;
                videoInfo.active = videoParam.isActive;
                break;
            }
        }
        
        if (!bFind) {
            MeetingUserInformation *newVideoInfo = [[MeetingUserInformation alloc] init];
            newVideoInfo.mediaID          = videoParam.mediaID;
            newVideoInfo.strDisplayName   = videoParam.strDisplayName;
            newVideoInfo.resolutionWidth  = videoParam.resolutionWidth;
            newVideoInfo.resolutionHeight = videoParam.resolutionHeight;
            newVideoInfo.userType         = videoParam.userType;
            newVideoInfo.removed          = videoParam.isRemoved;
            newVideoInfo.active           = videoParam.isActive;
            newVideoInfo.maxResolution    = videoParam.maxResolution;
            newVideoInfo.pin              = videoParam.pin;
            newVideoInfo.strUUID          = videoParam.strUUID;
            
            if(removeArray.count == 0) {
                [_participantsList addObject:newVideoInfo];
            } else {
                [_participantsList replaceObjectAtIndex:[(NSNumber *)removeArray[0] intValue]  withObject:newVideoInfo];
                [removeArray removeObjectAtIndex:0];
            }
        }
    }
    
    for(int i = 0; i < removeArray.count; i++) {
        [_participantsList removeObjectAtIndex:[(NSNumber *)removeArray[i] intValue]];
    }
    
    [removeArray removeAllObjects];
    
    for(int i = 0; i < removeArray.count; i++) {
        [_participantsList removeObjectAtIndex:[(NSNumber *)removeArray[i] intValue]];
    }
    
    for(int i = 0; i < _participantsList.count; i++) {
        MeetingUserInformation * tempVideoInfo = (MeetingUserInformation *)_participantsList[i];
        
        if(i == 0 && tempVideoInfo.userType == USER_TYPE_CONTENT) {
            break;
        }
        
        if(tempVideoInfo.userType == USER_TYPE_CONTENT) {
            MeetingUserInformation * videoInfo = _participantsList[0];
            _participantsList[0] = tempVideoInfo;
            _participantsList[i] = videoInfo;
            break;
        }
    }
    
    for(int i = 0; i < _participantsList.count; i++) {
        MeetingUserInformation * tempVideoInfo = (MeetingUserInformation *)_participantsList[i];
        
        if((i == _participantsList.count - 1) && tempVideoInfo.userType == USER_TYPE_LOCAL) {
            break;
        }
        
        if(tempVideoInfo.userType == USER_TYPE_LOCAL) {
            MeetingUserInformation * videoInfo = _participantsList[_participantsList.count - 1];
            _participantsList[i] = videoInfo;
            _participantsList[_participantsList.count - 1] = tempVideoInfo;
            break;
        }
    }
    
    [self updateUserNumber];
    
    for(int i = 0; i < _participantsList.count;i++) {
        if(self.isGalleryLayout)
            break;
        MeetingUserInformation * tempVideoInfo = (MeetingUserInformation *)_participantsList[i];
        if(i == 0 && tempVideoInfo.userType == USER_TYPE_CONTENT) {
            //NSLog(@"i == 0 && tempVideoInfo.eVideoType == VIDEO_TYPE_CONTENT");
            break;
        }
        
        if(i == 0 && (tempVideoInfo.isActive == YES || tempVideoInfo.isMaxResolution == YES)) {
            if(tempVideoInfo.isMaxResolution == YES) {
                //NSLog(@"need check if have the active speaker");
            } else {
                break;
            }
        }
        
        if(tempVideoInfo.isActive || tempVideoInfo.isMaxResolution) {
            MeetingUserInformation * videoInfo = _participantsList[0];
            _participantsList[0] = tempVideoInfo;
            _participantsList[i] = videoInfo;
            if(tempVideoInfo.isActive) {
                break;
            }
        }
    }
    
    for(int i = 0; i < _participantsList.count;i++) {
        MeetingUserInformation * tempVideoInfo = (MeetingUserInformation *)_participantsList[i];
        
        if(i == 0 && tempVideoInfo.userType == USER_TYPE_CONTENT) {
            for(int j = 1; j < _participantsList.count; j++) {
                MeetingUserInformation * tempVideoInfo = (MeetingUserInformation *)_participantsList[j];
                if(j == 1 && tempVideoInfo.isPin) {
                    break;
                }
                
                if(tempVideoInfo.isPin) {
                    MeetingUserInformation * videoInfo = _participantsList[1];
                    _participantsList[1] = tempVideoInfo;
                    _participantsList[j] = videoInfo;
                    break;
                }
            }
            break;
        }
        
        if(i == 0 && tempVideoInfo.isPin) {
            break;
        }
        
        if(tempVideoInfo.isPin) {
            MeetingUserInformation * videoInfo = _participantsList[0];
            _participantsList[0] = tempVideoInfo;
            _participantsList[i] = videoInfo;
            break;
        }
    }
    
    [self.delegate updateRemoteUserNumber:self.meetingNumber withUserArray:self.participantsList];
}

@end
