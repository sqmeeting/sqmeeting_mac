#import <Cocoa/Cocoa.h>

#import "ScheduleModel.h"
#import "ScheduledModelArray.h"

#import "FrtcLocalReminderWindowController.h"
#import "FrtcLocalReminderTableCellView.h"

NS_ASSUME_NONNULL_BEGIN


@protocol FrtcLocalReminderTableViewControllerDelegate <NSObject>

- (void)joinTheConferenceWithScheduleModel:(ScheduleModel *)scheduleModel;

@end

@interface FrtcLocalReminderTableViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource, FrtcLocalReminderWindowControllerDelegate, FrtcLocalReminderTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSTableView *tableView;
@property (nonatomic, strong) NSScrollView *scrollView;

//@property (nonatomic, strong) ScheduledModelArray *scheduledModelArray;
@property (nonatomic, strong) NSMutableArray<ReminderScheduleModel *> *scheduledModelArray;

@property (nonatomic, weak) id<FrtcLocalReminderTableViewControllerDelegate> localReminderJoinConferenceDelegate;


- (void)showFrame;
- (void)refreshList;

@end

NS_ASSUME_NONNULL_END
