#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcInputPasswordWindowDelegate <NSObject>

- (void)sendPasscode:(NSString *)passcode;

- (void)cancelSendPasscode;

@end

@interface FrtcInputPasswordWindow : NSWindow

- (instancetype)initWithSize:(NSSize)size;

- (void)showWindow;

- (void)adjustToSize:(NSSize)size;

- (void)displayToast;

@property (nonatomic, weak) id<FrtcInputPasswordWindowDelegate> inputPasscodeDelegate;

@end

NS_ASSUME_NONNULL_END
