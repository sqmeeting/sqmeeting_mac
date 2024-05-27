#import <Foundation/Foundation.h>
#import "DeviceObject.h"
#import "ScreenCaptureFoundation.h"
#import "ScreenCaptureRecorder.h"
NS_ASSUME_NONNULL_BEGIN

@interface FrtcWindowCaptureInterface : NSObject<ScreenCaptureFoundationOutputBufferDelegate
#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 130000
, ScreenCaptureRecorderOutputBufferDelegate
#endif
>

+ (FrtcWindowCaptureInterface *)getInstance;

- (void)configDirectDisplayID:(CGDirectDisplayID)displayID;
- (BOOL)configApplicationWindowID:(NSString *)windowID;
- (BOOL)configApplicationName:(NSString *)sourceAppContentName;
- (void)configContentCapbilityLevel:(int)width height:(int) height framerate:(float)framerate;

- (void)startScreenCaptureSharingWithEnableContentAudio:(BOOL)enableConentAudio;
- (void)startCaptureAudioWithWindowID:(uint32_t)windowID;
- (void)stopContentAudioBySharingApp;
- (void)stopScreenCapture;

- (void)startAppWindowCaptureSharing;
- (void)stopAppWindowCaptureSharing;

- (void)showShareIndicatorAndPrepareForAppShare;
- (void)stopShowShareIndicator;

- (void)setMediaID:(std::string)mediaID;
- (std::string)getMediaID;

@end

NS_ASSUME_NONNULL_END
