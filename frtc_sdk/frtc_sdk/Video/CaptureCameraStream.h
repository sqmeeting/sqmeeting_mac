#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#include "object_impl.h"
#import "DeviceObject.h"

#define FRAMERATE_IN_FIRST      0
#define RESOLUTION_IN_FIRST     1

typedef struct {
    int videoWidth;
    int videoHeight;
    int videoFramerate;
} CAMERA_CAPABILITY;

typedef struct {
    int videoWidth;
    int videoHeight;
    double maxFrameRateRange;
    int index;
} VideoDeviceCapa;

@interface CaptureCameraStream: NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, copy) NSString *mediaID;

@property (nonatomic, copy) NSString *nowUsedDeviceID;

@property (nonatomic, assign) int devicePreferenceSettings;

@property (nonatomic, assign) CAMERA_CAPABILITY cameraCapability;

+ (CaptureCameraStream *)SingletonInstance;

- (void)getVideoDeviceList:(NSMutableArray *)videoDeviceList;

- (void)switchCameraByDeviceID:(NSString *)deviceID;

- (BOOL)startCameraDeviceCapture;

- (void)stopCameraDeviceCapture;

- (NSString *)getCurrentCamereName;

- (void)addCamerationNotification:(NSNotification *)notification;

- (void)removeCameraNotification:(NSNotification *)notification;

- (void)startCaptureSession;

- (void)stopCaptureSession;

- (NSString *)getDefaultCameraName;

@end
