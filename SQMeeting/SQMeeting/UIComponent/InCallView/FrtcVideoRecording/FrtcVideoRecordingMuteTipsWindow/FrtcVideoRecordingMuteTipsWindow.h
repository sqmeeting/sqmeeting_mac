#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcVideoRecordingMuteTipsWindowDelegate <NSObject>

- (void)unMute;

- (void)startRecordingAnyway;

@end

@interface FrtcVideoRecordingMuteTipsWindow : NSWindow

- (instancetype)initWithSize:(NSSize)size;

- (void)showWindowWithWindow:(NSWindow *)window;

- (void)adjustToSize:(NSSize)size;

@property (nonatomic, weak) id<FrtcVideoRecordingMuteTipsWindowDelegate> reminderWindowDelegate;

@end

NS_ASSUME_NONNULL_END
