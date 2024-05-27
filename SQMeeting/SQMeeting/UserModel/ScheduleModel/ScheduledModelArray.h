#import "JSONModel.h"
#import "ScheduleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduledModelArray : JSONModel

@property (nonatomic, strong) NSArray<ScheduleModel > *meeting_schedules;
@property (nonatomic, strong) NSNumber *total_page_num;
@property (nonatomic, strong) NSNumber *total_size;

@end

NS_ASSUME_NONNULL_END
