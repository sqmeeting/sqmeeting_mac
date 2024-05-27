#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcCancelMeetingWindowDelegate <NSObject>

- (void)cancelMeetingWithCancelRecurrence:(BOOL)cancelAll withReservationID:(NSString *)reservationID;

@end

@interface FrtcCancelMeetingWindow : NSWindow

- (instancetype)initWithSize:(NSSize)size;

- (void)showWindow;

- (void)adjustToSize:(NSSize)size;

- (void)showWindowWithWindow:(NSWindow *)window;

@property (nonatomic, weak) id<FrtcCancelMeetingWindowDelegate> cancelMeetingDelegate;

@property (nonatomic, copy) NSString *reservationID;

@end

NS_ASSUME_NONNULL_END
