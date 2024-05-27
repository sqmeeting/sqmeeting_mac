#import "FrtcMediaStaticsInstance.h"

static FrtcMediaStaticsInstance *sharedFrtcMediaStaticsInstance = nil;

@interface FrtcMediaStaticsInstance  ()

@property (nonatomic, strong) NSTimer *staticsTimer;

@property (nonatomic, copy) FrtcMediaStaticsTimeBlock getMeidaStaticsBlock;

@end

@implementation FrtcMediaStaticsInstance

+ (FrtcMediaStaticsInstance *)sharedFrtcMediaStaticsInstance {
    if (sharedFrtcMediaStaticsInstance == nil) {
        @synchronized(self) {
            if (sharedFrtcMediaStaticsInstance == nil) {
                sharedFrtcMediaStaticsInstance = [[FrtcMediaStaticsInstance alloc] init];
            }
        }
    }
    
    return sharedFrtcMediaStaticsInstance;
}

- (void)startGetMediaStatics {
    [self startMeetingStaticsTimer:5.0];
}

- (void)stopGetMediaStatics {
    [self stopGetStatics];
}

- (void)getMediaStatics {
    NSString *str = [[FrtcCall sharedFrtcCall] frtcGetCallStaticsInfomation];
    
    NSError *err;
    
    FrtcStatisticalModel *staticsModel = [[FrtcStatisticalModel alloc] initWithString:str error:&err];
    FrtcMediaStaticsModel *mediaStaticsModel = [self getSignalStatus:staticsModel];
    
    if(self.getMeidaStaticsBlock) {
        self.getMeidaStaticsBlock(staticsModel, mediaStaticsModel);
    }
}

- (void)startMeetingStaticsTimer:(NSTimeInterval)timeInterval {
    __weak __typeof(self)weakSelf = self;
    self.staticsTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf getMediaStatics];
    }];
}

- (void)startGetStatics:(void (^)(FrtcStatisticalModel *staticsModel, FrtcMediaStaticsModel *mediaStaticsModel))getStaticsModelCompletionHandler {
    self.getMeidaStaticsBlock = getStaticsModelCompletionHandler;
}

- (void)stopGetStatics {
    if(self.staticsTimer != nil) {
        [self.staticsTimer invalidate];
        self.staticsTimer = nil;
    }
}

#pragma mark -- timer
- (int)getChannelAvgLostRate:(NSArray<MediaDetailModel *> *)mediaArray {
    MediaDetailModel *stat;
    NSInteger size = mediaArray.count;
    int count = 0;
    int avgLostRate = 0;

    if (size > 0) {
        for (int i = 0; i < size; i++) {
            stat = mediaArray[i];
            count += [(stat.packageLossRate) intValue];
        }
        
        avgLostRate = count / size;
    }

    return avgLostRate;
}

- (int)getChanelBitRate:(NSArray<MediaDetailModel *> *)mediaArray {
    MediaDetailModel *stat;
    NSInteger size = mediaArray.count;
    int count = 0;
    
    if (size > 0) {
        for (int i = 0; i < size; i++) {
            stat = mediaArray[i];
            count += [(stat.rtpActualBitRate) intValue];
        }
    }

    return count;
}

- (int)getChanelRTT:(NSArray<MediaDetailModel *> *)mediaArray {
    MediaDetailModel *stat;
    NSInteger size = mediaArray.count;
    int count = 0;
    
    if (size > 0) {
        for (int i = 0; i < size; i++) {
            stat = mediaArray[i];
            count += [(stat.roundTripTime) intValue];
        }
    }

    return count;
}

- (FrtcMediaStaticsModel *)getSignalStatus:(FrtcStatisticalModel *)model {
    int patxLoss = 0;
    int parxLoss = 0;
    int pvtxLoss = 0;
    int pvrxLoss = 0;
    int cvrxLoss = 0;
    int cvtxLoss = 0;
    
    int patxBitrate = 0;
    int parxBitrate = 0;
    int pvtxBitrate = 0;
    int pvrxBitrate = 0;
    int cvrxBitrate = 0;
    int cvtxBitrate = 0;
    
    int patxRTT = 0;
    int pvtxRTT = 0;
    int cvtxRTT = 0;

    parxLoss = [self getChannelAvgLostRate:model.mediaStatistics.apr];
    patxLoss = [self getChannelAvgLostRate:model.mediaStatistics.aps];
    pvrxLoss = [self getChannelAvgLostRate:model.mediaStatistics.vpr];
    pvtxLoss = [self getChannelAvgLostRate:model.mediaStatistics.vps];
    
    cvrxLoss = [self getChannelAvgLostRate:model.mediaStatistics.vcr];
    cvtxLoss = [self getChannelAvgLostRate:model.mediaStatistics.vcs];
    
    patxBitrate = [self getChanelBitRate:model.mediaStatistics.aps];
    parxBitrate = [self getChanelBitRate:model.mediaStatistics.apr];
    pvtxBitrate = [self getChanelBitRate:model.mediaStatistics.vps];
    pvrxBitrate = [self getChanelBitRate:model.mediaStatistics.vpr];
    cvrxBitrate = [self getChanelBitRate:model.mediaStatistics.vcr];
    cvtxBitrate = [self getChanelBitRate:model.mediaStatistics.vcs];
    
    patxRTT = [self getChanelRTT:model.mediaStatistics.aps];
    pvtxRTT = [self getChanelRTT:model.mediaStatistics.vps];
    cvtxRTT = [self getChanelRTT:model.mediaStatistics.vcs];
    
    FrtcMediaStaticsModel *mediaStaticsModel= [[FrtcMediaStaticsModel alloc] init];
    mediaStaticsModel.rttTime = patxRTT + pvtxRTT + cvtxRTT;
    
    mediaStaticsModel.upRate = patxBitrate + pvtxBitrate + cvtxBitrate;
    mediaStaticsModel.downRate = parxBitrate + pvrxBitrate + cvrxBitrate;
    
    mediaStaticsModel.audioUpRate = patxBitrate;
    mediaStaticsModel.audioUpPackLost = patxLoss;
    
    mediaStaticsModel.audioDownRate = parxBitrate;
    mediaStaticsModel.audioDownPackLost = parxLoss;
    
    mediaStaticsModel.videoUpRate = pvtxBitrate;
    mediaStaticsModel.videoUpPackLost = patxLoss;
    
    mediaStaticsModel.videoDownRate = pvrxBitrate;
    mediaStaticsModel.videoDownPackLost = pvrxLoss;
    
    mediaStaticsModel.contentUpRate = cvtxBitrate;
    mediaStaticsModel.contentUpPackLost = cvtxLoss;
    
    mediaStaticsModel.contentdownRate = cvrxBitrate;
    mediaStaticsModel.contentdownPackLost = cvrxLoss;
    
    mediaStaticsModel.callRate = model.signalStatistics.callRate;

    return mediaStaticsModel;
}

@end
