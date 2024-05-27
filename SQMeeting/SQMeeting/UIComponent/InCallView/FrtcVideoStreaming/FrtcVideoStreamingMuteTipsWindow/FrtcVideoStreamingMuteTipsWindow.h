#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcVideoStreamingMuteTipsWindowDelegate <NSObject>

- (void)unMuteStreaming;

- (void)startStreamingAnyway;

@end

@interface FrtcVideoStreamingMuteTipsWindow : NSWindow

- (instancetype)initWithSize:(NSSize)size;

- (void)showWindowWithWindow:(NSWindow *)window;

- (void)adjustToSize:(NSSize)size;

@property (nonatomic, weak) id<FrtcVideoStreamingMuteTipsWindowDelegate> reminderWindowDelegate;

@end

NS_ASSUME_NONNULL_END
