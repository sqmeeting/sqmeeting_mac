#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN


/**
 Enum for local remider state.
 */
typedef NS_ENUM(NSInteger, FRTCLocalReminderState) {
    FRTCSDK_REMINDER_STATE_IDLE,
    FRTCSDK_REMINDER_STATE_IS_SHOWING,
    FRTCSDK_REMINDER_STATE_IS_JOINED,
    FRTCSDK_REMINDER_STATE_IS_END,
    FRTCSDK_REMINDER_STATE_IS_IGNORE,
};


@protocol ScheduleModel;
@interface ScheduleModel : JSONModel

@property (nonatomic, copy) NSString *meeting_name;
@property (nonatomic, copy) NSString *meeting_number;
@property (nonatomic, copy) NSString <Optional> *meetingInfoKey;
@property (nonatomic, copy) NSString <Optional> *groupInfoKey;
@property (nonatomic, copy) NSString <Optional> *groupMeetingUrl;
@property (nonatomic, copy) NSString <Optional> *meeting_password;
@property (nonatomic, copy) NSString *meeting_type;
@property (nonatomic, copy) NSString *owner_id;
@property (nonatomic, copy) NSString *owner_name;
@property (nonatomic, copy) NSString <Optional> *recurrence_gid;
@property (nonatomic, copy) NSString *recurrence_type;
@property (nonatomic, copy) NSString <Optional> *reservation_id;
@property (nonatomic, copy) NSString <Optional> *schedule_end_time;
@property (nonatomic, copy) NSString <Optional> *schedule_start_time;
@property (nonatomic, copy) NSString <Optional> *meeting_url;
@property (nonatomic, strong) NSNumber <Optional> *recurrenceInterval;
@property (nonatomic, strong) NSArray<Optional>  *recurrenceDaysOfMonth;
@property (nonatomic, strong) NSArray<Optional>  *recurrenceDaysOfWeek;
@property (nonatomic, strong) NSString<Optional> *recurrenceEndDay;
@property (nonatomic, strong) NSString<Optional> *recurrenceEndTime;
@property (nonatomic, strong) NSString<Optional> *recurrenceStartDay ;
@property (nonatomic, strong) NSString<Optional> *recurrenceStartTime;
@property (nonatomic, strong) NSArray<Optional, ScheduleModel > *recurrenceReservationList;
@property (nonatomic, strong) NSArray<Optional> *participantUsers;

@end


/**
 Class for local remider with state.
 */

@interface ReminderScheduleModel : ScheduleModel

//for local remider on window, show or not show.
@property (nonatomic, assign) FRTCLocalReminderState meeting_reminder_state;

@end

NS_ASSUME_NONNULL_END
