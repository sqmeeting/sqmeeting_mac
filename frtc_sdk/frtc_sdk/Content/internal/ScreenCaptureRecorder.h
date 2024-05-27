#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 130000  // __MAC_13_0
#import <ScreenCaptureKit/ScreenCaptureKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface SCContentInfo : NSObject

@property (nonatomic, assign) pid_t processId;

@end

@protocol ScreenCaptureRecorderOutputBufferDelegate <NSObject>

- (void)screenCaptureOutBuffer: (void*_Nonnull) buffer width:(size_t) width height:(size_t)height;

@end

API_AVAILABLE(macos(13.0))
API_AVAILABLE(macos(13.0))
API_AVAILABLE(macos(13.0))
@interface ScreenCaptureRecorder : NSObject<SCStreamOutput>

+ (ScreenCaptureRecorder *)getInstance;

@property (nonatomic, weak) id<ScreenCaptureRecorderOutputBufferDelegate> delegate;

- (void)start;

- (void)startShareAppWithEnableContentAudio:(BOOL)enableContentAudio;

- (void)startAppContentAudio:(uint32_t)appWindowID;

- (void)selectCGWindowID:(CGWindowID)windowID;

- (void)startCaptureDisplayWithEnableContentAudio:(BOOL)enableContentAudio;

- (void)selectDisplayWithMonitorID:(CGDirectDisplayID)pMonitorID;

- (void)stop;

- (void)getWindowList:(SCShareableContent *)shareableContent;

- (void)getApplicationList:(SCShareableContent *)sharebleContent;

- (void)stream:(SCStream *)stream didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer ofType:(SCStreamOutputType)type;

- (NSArray *)getshareableApplicationList;

@property SCStream *scstream;

@end

NS_ASSUME_NONNULL_END

#endif
