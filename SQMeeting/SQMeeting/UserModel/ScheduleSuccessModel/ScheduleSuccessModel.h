#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleSuccessModel : JSONModel

@property (nonatomic, copy) NSString *call_rate_type;
@property (nonatomic, strong) NSNumber *guest_dial_in;
@property (nonatomic, copy) NSArray  *invited_users_details;
@property (nonatomic, copy) NSString<Optional> *meeting_description;
@property (nonatomic, copy) NSString *meeting_name;
@property (nonatomic, copy) NSString *meeting_number;
@property (nonatomic, copy) NSString<Optional> *meeting_password;
@property (nonatomic, copy) NSString<Optional> *meeting_room_id;
@property (nonatomic, copy) NSString *meeting_type;
@property (nonatomic, copy) NSString *meeting_url;
@property (nonatomic, copy) NSString *mute_upon_entry;
@property (nonatomic, copy) NSString *owner_id;
@property (nonatomic, copy) NSString *owner_name;
@property (nonatomic, strong) NSArray<Optional>  *recurrenceDaysOfMonth;
@property (nonatomic, strong) NSArray<Optional>  *recurrenceDaysOfWeek;
@property (nonatomic, strong) NSString<Optional> *recurrenceEndDay;
@property (nonatomic, strong) NSString<Optional> *recurrenceEndTime;
@property (nonatomic, strong) NSString<Optional> *recurrenceInterval;
@property (nonatomic, strong) NSString<Optional> *recurrenceStartDay ;
@property (nonatomic, strong) NSString<Optional> *recurrenceStartTime;
@property (nonatomic, strong) NSString<Optional> *groupInfoKey;
@property (nonatomic, strong) NSString<Optional> *groupMeetingUrl;
@property (nonatomic, copy) NSString<Optional> *recurrence_gid;
@property (nonatomic, copy) NSString *recurrence_type;
@property (nonatomic, copy) NSString *reservation_id;
@property (nonatomic, copy) NSString *schedule_end_time;
@property (nonatomic, copy) NSString *schedule_start_time;
@property (nonatomic, copy) NSNumber *watermark;
@property (nonatomic, copy) NSString *watermark_type;
@property (nonatomic, strong) NSNumber<Optional> *time_to_join;

@end

NS_ASSUME_NONNULL_END
