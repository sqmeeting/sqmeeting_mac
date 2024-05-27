#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FrtcVideoRecordingSuccessWindowDelegate <NSObject>

- (void)closedByUser;

@end

@interface FrtcVideoRecordingSuccessWindow : NSWindow

- (instancetype)initWithSize:(NSSize)size;

- (void)showWindowWithWindow:(NSWindow *)window;

- (void)adjustToSize:(NSSize)size;

@property (nonatomic, weak) id<FrtcVideoRecordingSuccessWindowDelegate> closedDelegate;

@end

NS_ASSUME_NONNULL_END
