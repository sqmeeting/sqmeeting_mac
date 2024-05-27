#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

#define WINDOW_TITLE_BAR_HIGHT    32
#define WINDOW_BUTTON_BAR_HIGHT   42
#define WINDOW_TITLE_BAR_AND_BUTTON_BAR_HEIGHT   (WINDOW_TITLE_BAR_HIGHT + WINDOW_BUTTON_BAR_HIGHT)

#define REMINDER_CELL_HIGHT 60

#define TABLE_VIEW_BAR_HIGHT_MIN (REMINDER_CELL_HIGHT * 1) //1 reminder
#define TABLE_VIEW_BAR_HIGHT_MAX (REMINDER_CELL_HIGHT * 4) //4 reminder


@protocol FrtcLocalReminderTableViewCellDelegate <NSObject>

- (void)removeCallHistoryAtRow:(NSInteger)row;

- (void)joinMeetingAtRow:(NSInteger)row;

@end


@interface FrtcLocalReminderTableCellView : NSTableCellView

@property (nonatomic, strong) NSTextField   *titleLabel;
@property (nonatomic, strong) NSTextField   *subtitleLabel;

@property (nonatomic, strong) NSImageView   *reminderImageView;
@property (nonatomic, strong) NSTextField   *meetingNameTextField;
@property (nonatomic, strong) NSTextField   *timeAndOwnerTextField;

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, weak)   id<FrtcLocalReminderTableViewCellDelegate> delegate;

- (void)updateLayout;

@end

NS_ASSUME_NONNULL_END
