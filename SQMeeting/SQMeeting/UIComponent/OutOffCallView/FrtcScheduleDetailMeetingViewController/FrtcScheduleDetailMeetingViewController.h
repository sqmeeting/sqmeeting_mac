#import <Cocoa/Cocoa.h>
#import "ScheduleModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol FrtcScheduleDetailMeetingViewControllerDelegate <NSObject>

- (void)joinMeeting:(NSInteger)row;

- (void)deleteMeetingWithReservationID:(NSString *)reservationID;

- (void)updateScheduleMeetingWhenDeleteSuccess;

- (void)updateScheduleMeetingWithRecurrence:(BOOL)isRecurrence withReversionID:(NSString *)reversionID withRow:(NSInteger)row;

- (void)popupRecurrenceDetailView:(NSInteger)row withInvite:(BOOL)isInvite;

- (void)removeMeetingSuccess;

@end

@interface FrtcScheduleDetailMeetingViewController : NSViewController

@property (nonatomic, strong) ScheduleModel *scheduleModel;

@property (nonatomic, assign, getter=isOvertime) BOOL overtime;

@property (nonatomic, assign, getter=isInvite) BOOL invite;

@property (nonatomic, assign, getter=isAddMeeting) BOOL addMeeting;

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, assign) NSInteger remainMeetings;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *reversionID;

@property (nonatomic, copy) NSString *currentReservationID;

@property (nonatomic, weak) id<FrtcScheduleDetailMeetingViewControllerDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
