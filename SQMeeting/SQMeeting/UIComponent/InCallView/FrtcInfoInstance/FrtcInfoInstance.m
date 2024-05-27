#import "FrtcInfoInstance.h"

NSString * const FMeetingUpRostListNotNotification = @"com.fmeeting.rostlist.update";
NSString * const FMeetingUpRostListKey = @"com.fmeeting.rostlist.update.key";

NSString * const FMeetingLectureListNotification = @"com.fmeeting.lecture.update";
NSString * const FMeetingLectureListKey = @"com.fmeeting.lecture.update.key";

NSString * const FMeetingUpInCallModelNotNotification = @"com.fmeeting.InCallModel.update";
NSString * const FMeetingUpInCallModelKey = @"com.fmeeting.InCallModel.update.key";

NSString * const FMeetingUpdateRosterNumberNotification = @"com.fmeeting.rosterNumber.update";
NSString * const FMeetingRosterNumberKey =  @"com.fmeeting.rosterNumber.update.key";

static FrtcInfoInstance *sharedFrtcInfoInstance = nil;

@interface FrtcInfoInstance ()

@property (nonatomic, copy)     NSMutableArray<NSString *> *rosterListArray;

@property (assign, nonatomic) NSInteger i;

@property (strong, nonatomic) NSTimer   *meetingTimer;

@property (copy, nonatomic) FrtcInfoInstanceMeetingTimeBlock meetingTimeBlock;

@end

@implementation FrtcInfoInstance

+ (FrtcInfoInstance *)sharedFrtcInfoInstance {
    if (sharedFrtcInfoInstance == nil) {
        @synchronized(self) {
            if (sharedFrtcInfoInstance == nil) {
                sharedFrtcInfoInstance = [[FrtcInfoInstance alloc] init];
            }
        }
    }
    
    return sharedFrtcInfoInstance;
}

- (instancetype)init {
    self = [super init];
    
    if(self) {
        self.modelArray = [NSMutableArray array];
    }
    
    return self;
}

- (void)setupRosterList:(NSMutableArray<NSString *> *)rosterListArray {
    [self.modelArray removeAllObjects];
    
    for(NSString *str in rosterListArray) {
        NSError *err;
        ParticipantsModel *participantModel = [[ParticipantsModel alloc] initWithString:str error:&err];
        
        [self.modelArray addObject:participantModel];
    }
    
    [self postNotification];
}

- (void)setupRosterFullList:(NSMutableArray<NSString *> *)rosterListArray {
    if(rosterListArray.count == 0) {
        [self.modelArray enumerateObjectsUsingBlock:^(ParticipantsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(![obj.UUID isEqualToString:self.inCallModel.userIdentifier]) {
                [self.modelArray removeObject:obj];
            }
        }];
    } else {
        for(NSDictionary *dic in rosterListArray) {
            BOOL find = NO;
            ParticipantsModel *tempParticipantModel;
            
            for(ParticipantsModel *participantModel in self.modelArray) {
                tempParticipantModel = participantModel;
                
                if([participantModel.UUID isEqualToString:dic[@"uuid"]]) {
                    find = YES;
                    break;
                }
            }
            
            if(!find) {
                [self.modelArray removeObject:tempParticipantModel];
            }
        }
    }
    
    [self postNotification];
}

- (void)setupLectureList:(NSMutableArray<NSString *> *)lectureListArray {
    NSDictionary *dic = [NSDictionary dictionaryWithObject:lectureListArray forKey:FMeetingLectureListKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FMeetingLectureListNotification object:nil userInfo:dic];
}

- (void)postNotification {
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.modelArray forKey:FMeetingUpRostListKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FMeetingUpRostListNotNotification object:nil userInfo:dic];
}

- (void)updateInCallModelStatus {
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.inCallModel forKey:FMeetingUpInCallModelKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FMeetingUpInCallModelNotNotification object:nil userInfo:dic];
}

- (void)updateRosterNumber:(NSInteger)rosterNumber {
    self.rosterNumer = rosterNumber;
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%ld", self.rosterNumer] forKey:FMeetingRosterNumberKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationNameOnMainThread:FMeetingUpdateRosterNumberNotification object:nil userInfo:dic];
}

- (void)handleTimeInterval {
    _i ++;
    NSTimeInterval timeInterval = (double)(self.i);
    int hour = (int)(timeInterval/3600);
    NSString *_hour;
    if(hour < 10) {
        _hour = [NSString stringWithFormat:@"0%d", hour];
    } else {
        _hour = [NSString stringWithFormat:@"%d", hour];
    }

    int minute = (int)(timeInterval - hour*3600)/60;
    NSString *_minute;
    if(minute < 10) {
        _minute = [NSString stringWithFormat:@"0%d", minute];
    } else {
        _minute = [NSString stringWithFormat:@"%d", minute];
    }
    
    int second = timeInterval - hour*3600 - minute*60;
    NSString *_second;
    if(second < 10) {
        _second = [NSString stringWithFormat:@"0%d", second];
    } else {
        _second = [NSString stringWithFormat:@"%d", second];
    }

    NSString *dural;
    if(hour == 0) {
        dural = [NSString stringWithFormat:@"%@:%@", _minute,_second];
    } else {
        dural = [NSString stringWithFormat:@"%@:%@:%@",_hour, _minute,_second];
    }
    
    self.meetingTimeBlock(dural);
}

- (void)startMeetingTimer:(NSTimeInterval)timeInterval {
    __weak __typeof(self)weakSelf = self;
    self.meetingTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf handleTimeInterval];
    }];
}

- (void)cancelMeetingDurationTimer {
    if(_meetingTimer != nil) {
        [_meetingTimer invalidate];
        _meetingTimer = nil;
    }
}

- (void)startTimer {
    _i = 0;
    [self startMeetingTimer:1];
}

- (void)stopTimer {
    [self cancelMeetingDurationTimer];
}

- (void)setupMeetingTime:(void (^)(NSString *meetingTime))meetingTimeBlock {
    self.meetingTimeBlock = meetingTimeBlock;
}

@end
