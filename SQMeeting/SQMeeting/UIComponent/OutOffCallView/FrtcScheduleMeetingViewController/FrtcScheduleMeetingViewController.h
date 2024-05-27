#import <Cocoa/Cocoa.h>
#import "UserDetailModel.h"
#import "MeetingRooms.h"
#import "ScheduleSuccessModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol FrtcScheduleMeetingViewControllerDelegate <NSObject>

@optional
- (void)scheduleMeetingComplete:(BOOL)isSuccess withScheduleSuccessModel:(nonnull ScheduleSuccessModel *)model;

- (void)updateScheduleMeetingComplete:(BOOL)isSuccess;

@end

@interface FrtcScheduleMeetingViewController : NSViewController

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, strong) MeetingRooms *meetingRooms;

@property (nonatomic, weak) id<FrtcScheduleMeetingViewControllerDelegate> delegate;

@property (nonatomic, assign, getter=isAuthority) BOOL authority;

@property (nonatomic, assign, getter=isUpdateView) BOOL updateView;

- (void)updateScheduleView:(ScheduleSuccessModel *)meetingDetailInfoModel withRecurrence:(BOOL)isRecurrence;

- (void)updateScheduleButtonName;


@end

NS_ASSUME_NONNULL_END
