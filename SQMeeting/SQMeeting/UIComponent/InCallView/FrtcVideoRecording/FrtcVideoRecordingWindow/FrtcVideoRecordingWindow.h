#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcVideoRecordingWindowDelegate <NSObject>

- (void)startVideoRecording;

- (void)cancelVideoRecording;

@end

@interface FrtcVideoRecordingWindow : NSWindow

- (instancetype)initWithSize:(NSSize)size;

- (void)showWindowWithWindow:(NSWindow *)window;

- (void)adjustToSize:(NSSize)size;

@property (nonatomic, weak) id<FrtcVideoRecordingWindowDelegate> startVideoRecordingDelegate;

@end

NS_ASSUME_NONNULL_END
