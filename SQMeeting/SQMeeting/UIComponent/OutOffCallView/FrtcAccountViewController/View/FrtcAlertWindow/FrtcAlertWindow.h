#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcAlertWindowDelegate <NSObject>

- (void)logoutNotification;

@end

@interface FrtcAlertWindow : NSWindow

- (instancetype)initWithSize:(NSSize)size;

- (void)showWindow;

- (void)adjustToSize:(NSSize)size;

@property (nonatomic, weak) id<FrtcAlertWindowDelegate> frtcAlertWindowDelegate;

@end

NS_ASSUME_NONNULL_END
