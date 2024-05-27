#import <Cocoa/Cocoa.h>
#import "FrtcLocalReminderTitleBarView.h"
#import "FrtcLocalReminderManagement.h"
#import "FrtcInConferenceAlertWindow.h"

NS_ASSUME_NONNULL_BEGIN

NSString * const FMeetingLocalReminderWindowEndTimeKey = @"com.fmeeting.local.reminder.window.end.time.key";


@protocol FrtcLocalReminderWindowControllerDelegate <NSObject>

- (void)setScheduledModelArray:(NSMutableArray<ReminderScheduleModel *> *)scheduledModelArray;

@end


@interface FrtcLocalReminderWindowController : NSWindowController <NSWindowDelegate, FrtcLocalReminderTitleBarViewDelegate, FrtcLocalReminderManagementDelegate, FrtcInConferenceAlertWindowDelegate>

@property (nonatomic, strong) NSMutableArray *scheduledModelArray; // ReminderScheduleModel
@property (nonatomic, strong) NSMutableArray *willShowScheduledModelArray;
// ReminderScheduleModel, willShowScheduledModelArray: except all data has been shown, ignored, or joined with reminder window's join button.

- (void)addReminderMeeting:(NSMutableArray *)meeting;

@end

NS_ASSUME_NONNULL_END
