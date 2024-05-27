#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleDetailModel : NSObject

@property (nonatomic, copy) NSString *meeting_name;
@property (nonatomic, copy) NSString *meeting_number;
@property (nonatomic, copy) NSString *meeting_type;
@property (nonatomic, copy) NSString *recurrence_gid;
@property (nonatomic, copy) NSString *recurrence_type;
@property (nonatomic, copy) NSString *reservation_id;
@property (nonatomic, copy) NSString *schedule_end_time;
@property (nonatomic, copy) NSString *schedule_start_time;
@property (nonatomic, strong) NSNumber *recurrenceInterval;

@end

NS_ASSUME_NONNULL_END
