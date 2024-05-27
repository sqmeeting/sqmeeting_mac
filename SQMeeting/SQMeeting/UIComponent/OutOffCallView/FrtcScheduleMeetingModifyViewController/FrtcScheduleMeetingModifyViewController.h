#import <Cocoa/Cocoa.h>
#import "ScheduleModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ModifySingleMeetingDelegate <NSObject>

- (void)modifyMeetingSuccess:(BOOL)isSuccess;

@end

@interface FrtcScheduleMeetingModifyViewController : NSViewController

@property (nonatomic, strong) ScheduleModel *scheduleModel;

@property (nonatomic, strong) ScheduleModel *scheduleModelArray;

@property (nonatomic, strong) NSTextField *frequencyTextField;

@property (nonatomic, strong) NSString *strVaule;

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, weak) id<ModifySingleMeetingDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
