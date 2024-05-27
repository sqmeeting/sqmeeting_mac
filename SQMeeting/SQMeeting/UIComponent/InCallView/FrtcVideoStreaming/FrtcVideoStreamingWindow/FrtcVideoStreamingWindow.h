#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcVideoStreamingWindowDelegate <NSObject>

- (void)startVideoStreamingWithPassword:(NSString *)password;

- (void)cancelVideoStreaming;

@end

@interface FrtcVideoStreamingWindow : NSWindow

- (instancetype)initWithSize:(NSSize)size;

- (void)showWindowWithWindow:(NSWindow *)window;

- (void)adjustToSize:(NSSize)size;

@property (nonatomic, weak) id<FrtcVideoStreamingWindowDelegate> startVideoStreamingDelegate;

@end

NS_ASSUME_NONNULL_END
