#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcDropCallWindowDelegate <NSObject>

- (void)leaveMeeting;

- (void)endingMeeting;

- (void)cancelDropCall;

@end

@interface FrtcDropCallWindow : NSWindow

- (instancetype)initWithSize:(NSSize)size;

@property (nonatomic, weak) id<FrtcDropCallWindowDelegate> dropCallDelegate;

@property (nonatomic, assign, getter=isAuthority) BOOL authority;

- (void)showWindowWithWindow:(NSWindow *)window;

@end

NS_ASSUME_NONNULL_END
