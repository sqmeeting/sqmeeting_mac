#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol ScreenCaptureFoundationOutputBufferDelegate <NSObject>

- (void)screenCaptureOutBuffer:(void *_Nonnull)buffer width:(size_t)width height:(size_t)height stride:(size_t)stride;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ScreenCaptureFoundation : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, weak) id<ScreenCaptureFoundationOutputBufferDelegate> delegate;

- (instancetype)initWithDisplayID: (CGDirectDisplayID)id;

- (void)configDirectDisplayID:(CGDirectDisplayID)displayID;

- (void)startCaptureScreen;

- (void)stopCaptureScreen;

@end

NS_ASSUME_NONNULL_END
