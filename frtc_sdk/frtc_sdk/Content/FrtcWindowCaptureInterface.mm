#import "FrtcWindowCaptureInterface.h"
#import "window_capture_impl.h"
#import "ScreenCaptureFoundation.h"
#import "ScreenCaptureRecorder.h"
#import "ObjectInterface.h"

#include "common_interface.h"

void outputContentBuffer(void* buffer,
                         int length, int width, int height, int stride,
                         RTC::VideoColorFormat type,
                         std::string mediaID)
{
    [[ObjectInterface sharedObjectInterface] startSendContentStream:[NSString       stringWithCString:mediaID.c_str()encoding:[NSString defaultCStringEncoding]]
                                                        videoBuffer:buffer
                                                             length:length
                                                              width:width
                                                             height:height
                                                             stride:stride
                                                    videoSampleType:type];
}


@interface FrtcWindowCaptureInterface() {
    AppWindowCaptureImpl *_appWindowCatpure;
}

@property (nonatomic, strong) ScreenCaptureFoundation *screenDesktopCapture;

@end


@implementation FrtcWindowCaptureInterface

+ (FrtcWindowCaptureInterface *)getInstance {
    static FrtcWindowCaptureInterface *captureInterfaceSingleton = nil;
    static dispatch_once_t once_taken = 0;
    dispatch_once(&once_taken, ^{
        captureInterfaceSingleton = [[FrtcWindowCaptureInterface alloc] init];
    });
    
    return captureInterfaceSingleton;
}

- (instancetype)init {
    self = [super init];
  
    _appWindowCatpure = AppWindowCaptureImpl::instance();
    _appWindowCatpure->configContentOutputCallback(outputContentBuffer);
    
    self.screenDesktopCapture = [[ScreenCaptureFoundation alloc] initWithDisplayID:CGMainDisplayID()];
    self.screenDesktopCapture.delegate = self;
    
    if(@available(macOS 13.0, *)) {
#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 130000
        [ScreenCaptureRecorder getInstance].delegate = self;
#endif
    }
    
    return self;
}

- (void)dealloc {
    if (_appWindowCatpure) {
        delete _appWindowCatpure;
        _appWindowCatpure = NULL;
    }
}

- (void)setMediaID:(std::string)mediaID {
    if (_appWindowCatpure) {
        _appWindowCatpure->mediaID = mediaID;
    }
}

- (void)screenCaptureOutBuffer:(void*_Nonnull) buffer width:(size_t) width height:(size_t)height stride:(size_t)stride {
    [[ObjectInterface sharedObjectInterface] startSendContentStream:[NSString stringWithCString:self.getMediaID.c_str()
                                                                             encoding:[NSString defaultCStringEncoding]]
                                              videoBuffer:buffer
                                                   length:width * height * 3 / 2
                                                    width:width
                                                   height:height
                                                   stride:0
                                          videoSampleType:RTC::VideoColorFormat::kNV12];
}

- (void)screenCaptureOutBuffer:(void*_Nonnull) buffer width:(size_t) width height:(size_t)height {
    [[ObjectInterface sharedObjectInterface] startSendContentStream:[NSString stringWithCString:self.getMediaID.c_str()
                                                                             encoding:[NSString defaultCStringEncoding]]
                                              videoBuffer:buffer
                                                   length:width * height * 4
                                                    width:width
                                                   height:height
                                                   stride:0
                                          videoSampleType:RTC::VideoColorFormat::kARGB];
}

- (std::string)getMediaID {
    if(_appWindowCatpure)
    {
        return _appWindowCatpure->mediaID;
    }
    else
    {
        return "";
    }
}

- (void)configDirectDisplayID:(CGDirectDisplayID)displayID {
    if (@available(macOS 13.0, *)) {
#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 130000
        [[ScreenCaptureRecorder getInstance] selectDisplayWithMonitorID:displayID];
#else
        [self.screenDesktopCapture configDirectDisplayID:displayID];
#endif
    } else {
        [self.screenDesktopCapture configDirectDisplayID:displayID];
    }
}

- (BOOL)configApplicationWindowID:(NSString *)windowID {
    const char * c1 = [windowID UTF8String];
    if (_appWindowCatpure) {
        _appWindowCatpure->configApplicationWindowID(c1);
    }
    
    return true;
}

- (void)configContentCapbilityLevel:(int)width height:(int) height framerate:(float)framerate {
    if (_appWindowCatpure) {
        _appWindowCatpure->configContentCapbilityLevel(width, height, framerate);
    }
}

- (BOOL)configApplicationName:(NSString *)sourceAppContentName {
    if (_appWindowCatpure) {
        std::string strSourceAppContentName = std::string([sourceAppContentName UTF8String]);
        _appWindowCatpure->configApplicationName(strSourceAppContentName);
    }
    
    return true;
}

- (void)startScreenCaptureSharingWithEnableContentAudio:(BOOL)enableConentAudio {
    if(@available(macOS 13.0, *)) {
#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 130000
        [[ScreenCaptureRecorder getInstance] startCaptureDisplayWithEnableContentAudio:enableConentAudio];
#else
        [self.screenDesktopCapture startCaptureScreen];
#endif
    } else {
        [self.screenDesktopCapture startCaptureScreen];
    }
}

- (void)startCaptureAudioWithWindowID:(uint32_t)windowID {
    if(@available(macOS 13.0, *)) {
#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 130000
        [[ScreenCaptureRecorder getInstance] startAppContentAudio:windowID];
#endif
    }
}

- (void)stopContentAudioBySharingApp {
    if(@available(macOS 13.0, *)) {
#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 130000
        [[ScreenCaptureRecorder getInstance] stop];
#endif
    }
}

- (void)startAppWindowCaptureSharing {
    if (_appWindowCatpure) {
        _appWindowCatpure->startAppWindowCapture();
    }
}

- (void)stopAppWindowCaptureSharing {
    if (_appWindowCatpure) {
        _appWindowCatpure->stopAppWindowCapture();
    }
}

- (void)stopScreenCapture {
    if(@available(macOS 13.0, *)) {
#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 130000
        [[ScreenCaptureRecorder getInstance] stop];
#endif
    } else {
        [self.screenDesktopCapture stopCaptureScreen];
    }
}

- (void)showShareIndicatorAndPrepareForAppShare {
    if (_appWindowCatpure) {
        _appWindowCatpure->showShareIndicatorAndPrepareForAppShare();
    }
}

- (void)stopShowShareIndicator {
    if (_appWindowCatpure) {
        _appWindowCatpure->stopShowShareIndicator();
    }
}

@end
