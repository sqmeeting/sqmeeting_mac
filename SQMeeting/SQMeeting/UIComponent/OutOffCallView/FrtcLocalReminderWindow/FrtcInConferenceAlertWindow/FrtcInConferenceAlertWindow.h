#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcInConferenceAlertWindowDelegate <NSObject>

- (void)okButtonClickedOnAlertWindow;

@end


@interface FrtcInConferenceAlertWindow : NSWindow

@property (nonatomic, weak) id<FrtcInConferenceAlertWindowDelegate> okButtonDelegate;

- (instancetype)initWithSize:(NSSize)size;
- (void)showWindowWithWindow:(NSWindow *)window;

@end

NS_ASSUME_NONNULL_END
