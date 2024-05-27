#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcVideoStreamingEndWindowwDelegate <NSObject>

- (void)endVideoStreaming;

- (void)cancelEndingVideoStreaming;

@end

@interface FrtcVideoStreamingEndWindow : NSWindow

- (instancetype)initWithSize:(NSSize)size;

- (void)showWindowWithWindow:(NSWindow *)window;

- (void)adjustToSize:(NSSize)size;

@property (nonatomic, weak) id<FrtcVideoStreamingEndWindowwDelegate> endWindowDelegate;

@end

NS_ASSUME_NONNULL_END
