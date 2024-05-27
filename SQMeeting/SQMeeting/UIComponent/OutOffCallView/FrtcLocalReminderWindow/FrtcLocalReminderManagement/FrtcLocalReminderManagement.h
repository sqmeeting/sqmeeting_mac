#import <Foundation/Foundation.h>
#import "ScheduledModelArray.h"

NS_ASSUME_NONNULL_BEGIN


@protocol FrtcLocalReminderManagementDelegate <NSObject>

- (void)showOrHideMeetingReminderWindow:(BOOL)enable;

@end

@protocol FrtcLocalReminderManagementJoinMeetingDelegate <NSObject>

- (void)joinTheConferenceWithScheduleModel:(ScheduleModel *)scheduleModel;
- (void)enableOrDisableReceiveReminder:(BOOL)enable;

@end


@interface FrtcLocalReminderManagement : NSObject

@property (nonatomic, strong) ScheduledModelArray *scheduledModelArray;
//@property (nonatomic, strong) ScheduledModelArray *reminderShowScheduledModelArray;
@property (nonatomic, strong) NSArray<ScheduleModel *> *reminderShowScheduledModelArray;

@property (nonatomic, strong) NSMutableArray *upcomingMeetingArray; //all upcoming meetings.
@property (nonatomic, strong) NSMutableArray *upcomingAlertTimeArray; //all alert time, for the upcomingMeetingArray.
@property (nonatomic, strong) NSMutableDictionary *upcomingAlertTimeMeetingsDict; //key: alertTime; value: meetings at the same time of alertTime.
@property (nonatomic, strong) NSTimer *alertTimer;

@property (nonatomic, assign, getter = isEnableReceiveReminder) BOOL enableReceiveReminder;

@property (nonatomic, weak) id<FrtcLocalReminderManagementDelegate> reminderWindowDelegate;
@property (nonatomic, weak) id<FrtcLocalReminderManagementJoinMeetingDelegate> reminderWindowJoinMeetingDelegate;

+ (instancetype)sharedInstance;
+ (void)releaseInstance;

- (void)setScheduledModelArrayForShowOnPopWindow:(ScheduledModelArray *) aScheduledModelArray;
- (void)enableOrDisableReceiveMeetingReminder:(BOOL)enable;

@end

NS_ASSUME_NONNULL_END
