#import <Cocoa/Cocoa.h>
#import "FrtcDefaultTextField.h"
#import "UserDetailModel.h"
#import "MeetingRooms.h"
#import "ScheduleSuccessModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ScheduleViewDelegate <NSObject>

- (void)showInviteView;

- (void)updateUserListVie:(NSArray *)selectedUserList;

- (void)scheduleMeetingComplete:(BOOL)isSuccess withScheduleSuccessModel:(ScheduleSuccessModel *)model;

- (void)updateScheduleMeetingComplete:(BOOL)isSuccess;

- (void)enableScheduleButton:(BOOL)enable;

- (void)showReminderView;

- (void)showTimeReminderValue:(NSString *)value;

@end

@interface ScheduleView : NSView

@property (nonatomic, weak) id<ScheduleViewDelegate> delegate;

- (void)scheduleMeeting;

- (void)updateSelectUsers:(NSArray<NSString *> *)userList;

- (void)updateScheduleView:(ScheduleSuccessModel *)meetingInfoModel withRecurrence:(BOOL)isRecurrence;

- (void)setMeetingRooms:(MeetingRooms *)meetingRooms;

- (void)setAuthority:(BOOL)authority;

- (BOOL)compareTime;

@property (nonatomic, strong) FrtcDefaultTextField  *meetingDetailObject;

@property (nonatomic, strong) MeetingRooms *meetingRooms;

@property (nonatomic, assign, getter=isAuthority) BOOL authority;


@end

NS_ASSUME_NONNULL_END
