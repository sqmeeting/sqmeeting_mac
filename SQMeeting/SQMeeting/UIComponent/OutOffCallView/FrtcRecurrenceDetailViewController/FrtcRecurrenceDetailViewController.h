#import <Cocoa/Cocoa.h>
#import "ScheduleModel.h"
#import "ScheduleGroupModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcRecurrenceDetailViewControllerDelegate <NSObject>

@optional
- (void)updateScheduleList;

- (void)joinMeetingWithRow:(NSInteger)row;

- (void)updateScheduleMeeting:(NSString *)reversionID withRecurrence:(BOOL)isRecurrence withRow:(NSInteger)row;

- (void)popupDetailViewController:(NSInteger)row withIndex:(NSInteger)index;

- (void)removeAddMeetingSuccess;

@end

@interface FrtcRecurrenceDetailViewController : NSViewController

@property (nonatomic, strong) NSTextField   *titleTextField;

@property (nonatomic, strong) ScheduleModel *scheduleModel;

@property (nonatomic, weak) id<FrtcRecurrenceDetailViewControllerDelegate> delegate;

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, assign, getter=isInvite) BOOL invite;

@property (nonatomic, assign, getter=isAddMeeting) BOOL addMeeting;

@property (nonatomic, copy) NSString *groupID;

@property (nonatomic, strong) ScheduleGroupModel *groupModel;

- (void)reloadDataByMeetingGroupID:(NSString *)groupID;

@end

NS_ASSUME_NONNULL_END
