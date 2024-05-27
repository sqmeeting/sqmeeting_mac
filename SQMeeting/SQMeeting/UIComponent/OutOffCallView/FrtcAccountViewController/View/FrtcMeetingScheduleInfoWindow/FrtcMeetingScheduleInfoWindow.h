#import <Cocoa/Cocoa.h>
#import "ScheduleSuccessModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FrtcMeetingScheduleInfoWindow : NSWindow

- (instancetype)initWithSize:(NSSize)size withSuccessfulSchedule:(BOOL)isSchedule;

- (void)showWindow;

- (void)showWindowWithWindow:(NSWindow *)window;

- (void)adjustToSize:(NSSize)size;

- (void)setupMeetingInfo:(ScheduleSuccessModel *)model;

@property (nonatomic, assign, getter=isScheduleSuccess) BOOL scheduleSuccess;

@end

NS_ASSUME_NONNULL_END
