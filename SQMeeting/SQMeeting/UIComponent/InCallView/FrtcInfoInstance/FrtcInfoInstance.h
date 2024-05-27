#import <Foundation/Foundation.h>
#import "ParticipantsModel.h"
#import "FrtcInCallModel.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const FMeetingUpRostListNotNotification;
FOUNDATION_EXPORT NSString * const FMeetingUpRostListKey;

FOUNDATION_EXPORT NSString * const FMeetingUpdateRosterNumberNotification;
FOUNDATION_EXPORT NSString * const FMeetingRosterNumberKey;

FOUNDATION_EXPORT NSString * const FMeetingLectureListNotification;
FOUNDATION_EXPORT NSString * const FMeetingLectureListKey;

FOUNDATION_EXPORT NSString * const FMeetingUpInCallModelNotNotification;
FOUNDATION_EXPORT NSString * const FMeetingUpInCallModelKey;

typedef void (^FrtcInfoInstanceMeetingTimeBlock)(NSString *meetingTime);

@interface FrtcInfoInstance : NSObject

@property (nonatomic, strong)   NSMutableArray<ParticipantsModel *> *modelArray;

@property (nonatomic, strong)   FrtcInCallModel *inCallModel;

@property (nonatomic, assign)   NSInteger rosterNumer;

+ (FrtcInfoInstance *)sharedFrtcInfoInstance;

- (void)setupRosterList:(NSMutableArray<NSString *> *)rosterListArray;

- (void)setupLectureList:(NSMutableArray<NSString *> *)lectureListArray;

- (void)setupRosterFullList:(NSMutableArray<NSString *> *)rosterListArray;

- (void)updateInCallModelStatus;

- (void)updateRosterNumber:(NSInteger)rosterNumber;

- (void)startTimer;

- (void)stopTimer;

- (void)setupMeetingTime:(void (^)(NSString *meetingTime))meetingTimeBlock;

@end

NS_ASSUME_NONNULL_END
