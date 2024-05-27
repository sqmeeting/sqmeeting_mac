#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FrtcScheduleFunctionControllerDelegate <NSObject>

- (void)deleteNonCurrentMeetingWithReservationID:(NSString *)reservationID withRecurrence:(BOOL)isRecurrence;

- (void)editSelectMeetingWitReservationID:(NSString *)reservationID withRecurrence:(BOOL)isRecurrence withRow:(NSInteger)row;

- (void)editCopyMeetingWitReservationID:(NSInteger )row withReservationID:(NSString *)reservationID;

- (void)viewDetailRecurrenceWithReservationID:(NSInteger)row;

- (void)removeDetailRecurrenceWithReservationID:(NSInteger)row;

@end

typedef NS_ENUM(NSUInteger, FrtcScheduleTagType) {
    FrtcScheduleRecurrence,
    FrtcScheduleNormal
};

@interface FrtcScheduleFunctionController : NSViewController

@property (nonatomic, assign, getter=isOverTime) BOOL overTime;

@property (nonatomic, copy) NSString *reservationID;

@property (nonatomic, weak) id<FrtcScheduleFunctionControllerDelegate> delegate;

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, copy) NSString *meetingType;

@property (nonatomic, assign, getter=isNeedView) BOOL needView;

@property (nonatomic, assign, getter=isAddMeeting) BOOL addMeeting;

@end

NS_ASSUME_NONNULL_END
