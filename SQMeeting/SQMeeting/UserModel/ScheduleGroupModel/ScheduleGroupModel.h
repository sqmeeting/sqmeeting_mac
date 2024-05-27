#import "JSONModel.h"
#import "ScheduleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleGroupModel : JSONModel

@property (nonatomic, copy) NSString<Optional>  *groupInfoKey;
@property (nonatomic, copy) NSString<Optional>  *groupMeetingUrl;

@property (nonatomic, strong) NSArray<ScheduleModel > *meeting_schedules;
@property (nonatomic, strong) NSArray<Optional>  *recurrenceDaysOfMonth;
@property (nonatomic, strong) NSArray<Optional>  *recurrenceDaysOfWeek;
@property (nonatomic, strong) NSString<Optional> *recurrenceEndDay;
@property (nonatomic, strong) NSString<Optional> *recurrenceEndTime;
@property (nonatomic, strong) NSString<Optional> *recurrenceInterval;
@property (nonatomic, strong) NSString<Optional> *recurrenceStartDay ;
@property (nonatomic, strong) NSString<Optional> *recurrenceStartTime;
@property (nonatomic, strong) NSNumber *total_page_num;
@property (nonatomic, strong) NSNumber *total_size;

@end

NS_ASSUME_NONNULL_END
