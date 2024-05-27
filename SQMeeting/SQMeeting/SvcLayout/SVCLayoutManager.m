//
//  SVCLayoutManager.m
//  TestDemo
//
//  Created by 徐亚飞 on 2020/6/8.
//  Copyright © 2020 徐亚飞. All rights reserved.
//

#import "SVCLayoutManager.h"
#import "SVCVideoInfo.h"

static SVCLayoutManager *sharedSVCLayoutManager = nil;

SVCLayoutDetail gSvcLayoutDetail[SVC_LAYOUT_MODE_NUMBER] = {0};

void prepareSVCLayoutDetail()
{
    for (SVCLayoutModeType mode = SVC_LAYOUT_MODE_1X1; mode < SVC_LAYOUT_MODE_NUMBER ; )
    {
        switch (mode) {
            case SVC_LAYOUT_MODE_1X1:
                gSvcLayoutDetail[mode] = (SVCLayoutDetail){1, YES, {{0, 0, 1.0, 0.83},
                    {0.4, 0.83, 0.2, 0.17}}};
                mode = SVC_LAYOUT_MODE_1X2;
                break;
            case SVC_LAYOUT_MODE_1X2:
                gSvcLayoutDetail[mode] = (SVCLayoutDetail){2, YES, {{0, 0, 1.0, 0.83},
                    {0.3, 0.83, 0.2, 0.17},
                    {0.5, 0.83, 0.2, 0.17}} };
                mode = SVC_LAYOUT_MODE_1X3;
                break;
           
            case SVC_LAYOUT_MODE_1X3:
                gSvcLayoutDetail[mode]=(SVCLayoutDetail){3, YES, {{0, 0, 1.0, 0.83},
                    {0.2, 0.83, 0.2, 0.17},
                    {0.4, 0.83, 0.2, 0.17},
                    {0.6, 0.83, 0.2, 0.17}}};
                mode = SVC_LAYOUT_MODE_1X4;
                break;
            
            case SVC_LAYOUT_MODE_1X4:
                gSvcLayoutDetail[mode] = (SVCLayoutDetail){4, YES, {{0, 0, 1.0, 0.83},
                    {0.1, 0.83, 0.2, 0.17},
                    {0.3, 0.83, 0.2, 0.17},
                    {0.5, 0.83, 0.2, 0.17},
                    {0.7, 0.83, 0.2, 0.17}} };
                mode = SVC_LAYOUT_MODE_1X5;
                break;
                
            case SVC_LAYOUT_MODE_1X5:
                gSvcLayoutDetail[mode] = (SVCLayoutDetail){4, YES, {{0, 0, 1.0, 0.83},
                    {0.0, 0.83, 0.2, 0.17},
                    {0.2, 0.83, 0.2, 0.17},
                    {0.4, 0.83, 0.2, 0.17},
                    {0.6, 0.83, 0.2, 0.17},
                    {0.8, 0.83, 0.2, 0.17}
                } };
                mode = SVC_LAYOUT_MODE_NUMBER;
                break;
       
            default:
                break;
        }
    }
}

@implementation SVCLayoutManager

- (id)init {
    self = [super init];
    if (self) {
        _svcLayoutMode = SVC_LAYOUT_MODE_1X1;
        _svcVideoList = [[NSMutableArray alloc] init];
        prepareSVCLayoutDetail();
    }
    return self;
}

#pragma mark - public functions
+ (SVCLayoutManager *)getInstance {
    if (sharedSVCLayoutManager == nil) {
        @synchronized(self) {
            if (sharedSVCLayoutManager == nil) {
                sharedSVCLayoutManager = [[SVCLayoutManager alloc] init];
            }
        }
    }
    
    return sharedSVCLayoutManager;
}

- (void) figureOutLayoutMode_phone {
    NSInteger svcVideoCount = [_svcVideoList count];
    if(svcVideoCount == 2) {
        _svcLayoutMode = SVC_LAYOUT_MODE_1X1;
    } else if(svcVideoCount == 3) {
        _svcLayoutMode = SVC_LAYOUT_MODE_1X2;
    } else if(svcVideoCount == 4) {
        _svcLayoutMode = SVC_LAYOUT_MODE_1X3;
    } else if(svcVideoCount == 5) {
        _svcLayoutMode = SVC_LAYOUT_MODE_1X4;
    } else if(svcVideoCount == 6) {
        _svcLayoutMode = SVC_LAYOUT_MODE_1X5;
    }
    
}

-(NSString *)videoType:(VideoType)type {
    if(type == VIDEO_TYPE_REMOTE) {
        return @"VIDEO_TYPE_REMOTE";
    } else if(type == VIDEO_TYPE_LOCAL) {
        return @"VIDEO_TYPE_LOCAL";
    } else if(type == VIDEO_TYPE_CONTENT) {
        return @"VIDEO_TYPE_CONTENT";
    } else {
        return @"VIDEO_TYPE_INVALID";
    }
}

-(void)svcRefreshLayoutList:(NSMutableArray *)videoLayoutInfo {
    NSMutableArray *removeArray = [NSMutableArray array];
    NSLog(@"-----Begin to dump layou information--------@");
    
    NSLog(@"old Layout information");
    for(SVCVideoInfo *videoInfo in _svcVideoList) {
        printf("\n%s and info type is %s\n", [videoInfo.dataSourceID UTF8String], [[self videoType:videoInfo.eVideoType] UTF8String]);
    }
    printf("\n");
    NSLog(@"New Layout information");
    for(SVCVideoInfo *videoInfo in videoLayoutInfo) {
         printf("\n%s and info type is %s\n", [videoInfo.dataSourceID UTF8String], [[self videoType:videoInfo.eVideoType] UTF8String]);
    }
    for (int j = (int)[_svcVideoList count] - 1; j >= 0; j--) {
        SVCVideoInfo *videoInfo = [_svcVideoList objectAtIndex:j];
        
        BOOL bFind = NO;
        for (int i = 0; i < videoLayoutInfo.count; i++) {
            SVCVideoInfo * videoParam = (SVCVideoInfo *)videoLayoutInfo[i];
            if ([videoParam.dataSourceID isEqualToString:videoInfo.dataSourceID ]) {
        
                videoInfo.resolution_height = videoParam.resolution_height;
                videoInfo.resolution_width = videoParam.resolution_width;
                bFind = YES;
                break;
            }
        }
        
        if (!bFind) {
            //[_svcVideoList removeObject:videoInfo];
            videoInfo.removed = YES;
            NSLog(@"can not find the informaiton");
            [removeArray addObject:[NSNumber numberWithInt:j]];
        }
    }
    printf("\n****print the remove number*****\n");
    printf("The remove Array count is %ld\n", removeArray.count);
    for(int i = 0; i < removeArray.count; i++) {
        NSNumber *number = removeArray[i];
        printf("%d ", [number intValue]);
    }

    printf("\n");
    
    if(_svcVideoList.count == 0) {
        [_svcVideoList addObjectsFromArray:videoLayoutInfo];
    }

    // add video which not in videoInfoList
    for (int i = 0; i < videoLayoutInfo.count; i++) {
        BOOL bFind = NO;
        SVCVideoInfo * videoParam = (SVCVideoInfo *)videoLayoutInfo[i];
        for (SVCVideoInfo *videoInfo in _svcVideoList) {
            if ([videoInfo.dataSourceID isEqualToString:videoParam.dataSourceID]) {
                bFind = YES;
                break;
            }
        }
        
        if (!bFind) {
            SVCVideoInfo *newVideoInfo = [[SVCVideoInfo alloc] init];//WithSSRCId:videoParam->ssrc VideoType:VIDEO_TYPE_REMOTE displayName:[NSString stringWithCString:videoParam->displayName encoding:NSUTF8StringEncoding]  viewId:videoParam->viewId];
            newVideoInfo.dataSourceID = videoParam.dataSourceID;
            newVideoInfo.strDisplayName = videoParam.strDisplayName;
            newVideoInfo.resolution_width = videoParam.resolution_width;
            newVideoInfo.resolution_height = videoParam.resolution_height;
            newVideoInfo.eVideoType = videoParam.eVideoType;
            newVideoInfo.removed = videoParam.isRemoved;
            
            if(removeArray.count == 0) {
                [_svcVideoList addObject:newVideoInfo];
            } else {
                [_svcVideoList replaceObjectAtIndex:[(NSNumber *)removeArray[0] intValue]  withObject:newVideoInfo];
                [removeArray removeObjectAtIndex:0];
            }
        }
    }
    
    for(int i = 0; i < removeArray.count; i++) {
        [_svcVideoList removeObjectAtIndex:[(NSNumber *)removeArray[i] intValue]];
    }
    
    [removeArray removeAllObjects];
    NSLog(@"RE-New Layout information");
       for(SVCVideoInfo *videoInfo in _svcVideoList) {
            printf("\n%s and the video info type is %s\n", [videoInfo.dataSourceID UTF8String], [[self videoType:videoInfo.eVideoType] UTF8String] );
       }
    
    printf("\n");
    
    for(int i = 0; i < removeArray.count; i++) {
        [_svcVideoList removeObjectAtIndex:[(NSNumber *)removeArray[i] intValue]];
    }
    
    for(int i = 0; i < _svcVideoList.count; i++) {
        SVCVideoInfo * tempVideoInfo = (SVCVideoInfo *)_svcVideoList[i];
        
        if(i == 0 && tempVideoInfo.eVideoType == VIDEO_TYPE_CONTENT) {
            break;
        }
        
        if(tempVideoInfo.eVideoType == VIDEO_TYPE_CONTENT) {
            SVCVideoInfo * videoInfo = _svcVideoList[0];
            _svcVideoList[0] = tempVideoInfo;
            _svcVideoList[i] = videoInfo;
            break;
        }
    }
    
    NSLog(@"RE-RE New Layout information");
       for(SVCVideoInfo *videoInfo in _svcVideoList) {
            printf("\n%s and the video info type is %s\n", [videoInfo.dataSourceID UTF8String], [[self videoType:videoInfo.eVideoType] UTF8String] );
       }
    
    printf("\n");
    
    for(int i = 0; i < _svcVideoList.count; i++) {
        SVCVideoInfo * tempVideoInfo = (SVCVideoInfo *)_svcVideoList[i];
        
        if((i == _svcVideoList.count - 1) && tempVideoInfo.eVideoType == VIDEO_TYPE_LOCAL) {
            break;
        }
        
        if(tempVideoInfo.eVideoType == VIDEO_TYPE_LOCAL) {
            SVCVideoInfo * videoInfo = _svcVideoList[_svcVideoList.count - 1];
            _svcVideoList[i] = videoInfo;
            _svcVideoList[_svcVideoList.count - 1] = tempVideoInfo;
            break;
        }
    }
    
    NSLog(@"RE-RE-RE New Layout information");
       for(SVCVideoInfo *videoInfo in _svcVideoList) {
            printf("\n%s and the video info type is %s\n", [videoInfo.dataSourceID UTF8String], [[self videoType:videoInfo.eVideoType] UTF8String] );
       }
    
    printf("\n");
    [self figureOutLayoutMode_phone];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate refreshLayoutMode:self.svcLayoutMode Views:self.svcVideoList];
    });
}

@end
