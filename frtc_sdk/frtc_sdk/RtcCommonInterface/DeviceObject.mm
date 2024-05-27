#import "DeviceObject.h"
#import "FrtcAudioClient.h"
#import "CaptureCameraStream.h"
#import "FrtcWindowCaptureInterface.h"
#import "FrtcCall.h"

static DeviceObjectClient* _deviceContext = nil;

@implementation DeviceObjectClient

+ (DeviceObjectClient *)sharedDeviceObject {
    static DeviceObjectClient *_sharedDeviceObject = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedDeviceObject = [[DeviceObjectClient alloc] init];
    });
    
    return _sharedDeviceObject;
}

+ (void)releaseInstance {
    if (_deviceContext != nil) {
        [_deviceContext removeListenerToStopCheckMicDataSource];
        _deviceContext = nil;
    }
}

- (instancetype) init {
    self = [super init];
    if (self) {
        [self regesterNotificationForAVDevicesChange];
    }
    
    return self;
}


#pragma mark- --Audio Device changed Event Observer and Handler-

- (void)regesterNotificationForAVDevicesChange {
    // [Notification-1].for USB Audio and Video devices.
    // If plug-in/out a USB audio device, macOS maybe NOT select to use it automatically.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(processAddDeviceEventWithNotification:)
                                                 name:AVCaptureDeviceWasConnectedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(processRemoveDeviceEventWithNotification:)
                                                 name:AVCaptureDeviceWasDisconnectedNotification
                                               object:nil];
    
    // 2.for PlugIn/Out and USB Audio devices(headset, include USB).
    // If plug-in a new device, macOS will automatically select to use it as default audio output and input.
   // [self addListenerToCheckMicByDataSource];
}

- (void)removeListenerToStopCheckMicDataSource {
    AudioObjectPropertyAddress propertyAddress = {kAudioHardwarePropertyDevices, kAudioObjectPropertyScopeGlobal, kAudioObjectPropertyElementMaster};
    propertyAddress.mSelector = kAudioHardwarePropertyDevices;
    AudioObjectRemovePropertyListener(kAudioObjectSystemObject, &propertyAddress, &objectListenerProc, (__bridge void * _Nullable)(self));
}

- (void)addListenerToCheckMicByDataSource {
    NSLog(@"[content audio][DeviceObjectClient][PlugIn Audio Device] -checkMicByDataSource");
    
    // Setting RunLoop to NULL here instructs HAL to manage its own thread for notifications.
    // This was the default behaviour on OS X 10.5 and earlier,
    // but now must be explicitly specified.
    // HAL would otherwise try to use the main thread to issue notifications.
    AudioObjectPropertyAddress propertyAddress = {kAudioHardwarePropertyRunLoop, kAudioObjectPropertyScopeGlobal, kAudioObjectPropertyElementMaster};
    CFRunLoopRef runLoop = NULL;
    UInt32 size = sizeof(CFRunLoopRef);
    int aoerr = AudioObjectSetPropertyData(kAudioObjectSystemObject, &propertyAddress, 0, NULL, size, &runLoop);
    if (aoerr != noErr) {
        NSLog(@"[content audio][DeviceObjectClient][PlugIn Audio Device] -objectListenerProc, Error aoerr : %s", (const char*)&aoerr);
        return;
    }
    
    // 1.Listen for any device Hardware changes(include plug in/out).
    propertyAddress.mSelector = kAudioHardwarePropertyDevices;
    AudioObjectAddPropertyListener(kAudioObjectSystemObject, &propertyAddress, &objectListenerProc, (__bridge void * _Nullable)(self));
    // 2.Listen for default input and output devices on macOS.
    propertyAddress.mSelector = kAudioHardwarePropertyDefaultInputDevice;
    AudioObjectAddPropertyListener(kAudioObjectSystemObject, &propertyAddress, &objectListenerProc, (__bridge void * _Nullable)(self));
    propertyAddress.mSelector = kAudioHardwarePropertyDefaultOutputDevice;
    AudioObjectAddPropertyListener(kAudioObjectSystemObject, &propertyAddress, &objectListenerProc, (__bridge void * _Nullable)(self));
}

OSStatus objectListenerProc(AudioObjectID objectId,
                            UInt32 numberAddresses,
                            const AudioObjectPropertyAddress addresses[],
                            void* clientData) {
    implObjectListenerProc(objectId, numberAddresses, addresses);
    
    return 0;
}

OSStatus implObjectListenerProc(const AudioObjectID objectId,
                                const UInt32 numberAddresses,
                                const AudioObjectPropertyAddress addresses[]) {
    for (UInt32 i = 0; i < numberAddresses; i++) {
        if (addresses[i].mSelector == kAudioHardwarePropertyDevices) {
            HandleDeviceChange();
        }
    
        if (addresses[i].mSelector == kAudioHardwarePropertyDefaultInputDevice) {
            HandleDeviceChange();
        }
    
        if (addresses[i].mSelector == kAudioHardwarePropertyDefaultOutputDevice) {
            HandleDeviceChange();
        }
    }

    return 0;
}

static void HandleDeviceChange() {
    NSString *micphoneName       = [[FrtcAudioClient audioClientSingleton] getNowUsedMicphoneDevice];
    NSString *speakerName        = [[FrtcAudioClient audioClientSingleton] getNowUsedSpeakerDevice];
    NSString *defaultMicName     = [[FrtcAudioClient audioClientSingleton] systemSelectDefaultMicphone];
    NSString *defaultSpeakerName = [[FrtcAudioClient audioClientSingleton] systemSelectDefaultSpeaker];

    NSDictionary *deviceInUse = [NSDictionary dictionaryWithObjectsAndKeys: micphoneName, @"micphone", speakerName, @"speaker", defaultMicName, @"defaultMicName", defaultSpeakerName, @"defaultSpeakerName", nil];
    NSLog(@"[content audio][DeviceObjectClient][PlugIn Audio Device] -HandleDeviceChange: The default mic is %@, the default speaker is %@, the current micName is %@, the current speaker name is %@", defaultMicName, defaultSpeakerName, micphoneName, speakerName);
    
    NSLog(@"[content audio][DeviceObjectClient][PlugIn Audio Device] -HandleDeviceChange: -> post FMeetingDeviceListChangedNotification");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: deviceInUse, FMeetingDeviceListInUseKey, nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:FMeetingDeviceListChangedNotification
                                                            object:nil
                                                          userInfo:dic];
    });
    return;
}

// [Notification-1].for USB Audio and Video devices.
// If plug-in/out a USB audio device, macOS maybe NOT select to use it automatically.

- (void)processAddDeviceEventWithNotification:(NSNotification *)notification {
    if ([notification.name isEqualToString:AVCaptureDeviceWasConnectedNotification] &&
        [notification.object isKindOfClass:AVCaptureDevice.class]) {
        
        //1.Add Event: refreshDevices
        [[CaptureCameraStream SingletonInstance] addCamerationNotification:notification];
        [[FrtcAudioClient audioClientSingleton] newAudioDeviceNotification:notification];
        
        HandleDeviceChange();
    }
}

- (void)processRemoveDeviceEventWithNotification:(NSNotification *)notification {
    if ([notification.name isEqualToString:AVCaptureDeviceWasDisconnectedNotification] &&
        [notification.object isKindOfClass:AVCaptureDevice.class]) {
        
        //1.Remove Event: refreshDevices
        [[CaptureCameraStream SingletonInstance] removeCameraNotification:notification];
        [[FrtcAudioClient audioClientSingleton] unpluggingAudioDeviceNotification:notification];
        
        HandleDeviceChange();
    }
}


#pragma mark- --AudioCapture API-
- (void)enableAudioUnitCoreGraph {
    [[FrtcAudioClient audioClientSingleton] enableAudioUnitCoreGraph];
}

- (void)testMic:(BOOL)enable withHandler:(void (^)(float meter, BOOL testing))testMicHandler {
    [[FrtcAudioClient audioClientSingleton] testAudioMicphone:enable withHandler:testMicHandler];
}

- (void)disableAudioUnitCoreGraph {
    [[FrtcAudioClient audioClientSingleton] disableAudioUnitCoreGraph];
}

- (void)getMicphoneArray:(NSMutableArray *)array {
    [[FrtcAudioClient audioClientSingleton] getDeviceInputMicArray:array];
}

- (void)switchMicphoneByDeviceID:(NSString *)id {
    [[FrtcAudioClient audioClientSingleton] switchMicphoneByDeviceID:id];
}

- (void)getSpeakerArray:(NSMutableArray *)array {
    [[FrtcAudioClient audioClientSingleton] getDeviceOutputSpeakerList:array];
}

- (void)switchSpeakerByDeviceID:(NSString *)id {
    [[FrtcAudioClient audioClientSingleton] switchSpeakerByDeviceID:id];
}

- (NSString *)getDefaultMicName {
    NSString *defaultMicName = [[FrtcAudioClient audioClientSingleton] systemSelectDefaultMicphone];
    return defaultMicName;
}

- (NSString *)getDefaultSpeakerName {
    NSString *defaultSpeakerName = [[FrtcAudioClient audioClientSingleton] systemSelectDefaultSpeaker];
    return defaultSpeakerName;
}

- (void)startUnitSourceChan {
    [[FrtcAudioClient audioClientSingleton] startAudioUnitInputDevice];
}

- (void)startUnitSinkChan {
    [[FrtcAudioClient audioClientSingleton] startAudioUnitOutputDevice];
}


#pragma mark- --CaptureCameraStream API-
- (void)setCameraMediaId:(NSString *)mediaId {
    [CaptureCameraStream SingletonInstance].mediaID = mediaId;
}

- (void)enableCameraWork {
    [[CaptureCameraStream SingletonInstance] startCameraDeviceCapture];
}

- (void)disableCameraWork {
    [[CaptureCameraStream SingletonInstance] stopCameraDeviceCapture];
}

- (void)enableCapture {
    [[CaptureCameraStream SingletonInstance] startCaptureSession];
}

- (void)disableCapture {
    [[CaptureCameraStream SingletonInstance] stopCaptureSession];
}

- (void)getCameraArray:(NSMutableArray *)array {
    [[CaptureCameraStream SingletonInstance] getVideoDeviceList:array];
}

- (void)switchCameraByDeviceID:(NSString*) id {
    [[CaptureCameraStream SingletonInstance] switchCameraByDeviceID:id];
}

- (NSString *)getDefaultCameraName {
    return [[CaptureCameraStream SingletonInstance] getDefaultCameraName];
}

#pragma mark- --Share content-
- (void)startDesktopScreenCapture:(BOOL)enableContentAudio {
    [[FrtcWindowCaptureInterface getInstance] startScreenCaptureSharingWithEnableContentAudio:enableContentAudio];
}

- (void)startAppContentAudioWithWindowID:(uint32_t)windowID {
    [[FrtcWindowCaptureInterface getInstance] startCaptureAudioWithWindowID:windowID];
}

- (void)stopAppContentAudio {
    [[FrtcWindowCaptureInterface getInstance] stopContentAudioBySharingApp];
}

- (void)startAppWindowCapture {
    [[FrtcWindowCaptureInterface getInstance] startAppWindowCaptureSharing];
}

- (void)stopDesktopScreenCapture {
    [[FrtcWindowCaptureInterface getInstance] stopScreenCapture];
}

- (void)stopAppWindowCapture {
    [[FrtcWindowCaptureInterface getInstance] stopAppWindowCaptureSharing];
}

- (void)configContentMediaId:(std::string)mediaId {
    [[FrtcWindowCaptureInterface getInstance] setMediaID:mediaId];
}

- (void)configDirectDisplayID:(CGDirectDisplayID)displayID {
    [[FrtcWindowCaptureInterface getInstance] configDirectDisplayID:displayID];
}

- (BOOL)configApplicationWindowID:(NSString*)windowID {
    return [[FrtcWindowCaptureInterface getInstance] configApplicationWindowID:windowID];
}

- (BOOL)configApplicationName:(NSString *) sourceAppContentName {
    return [[FrtcWindowCaptureInterface getInstance] configApplicationName:sourceAppContentName];
}

- (void)configContentCapbilityLevel:(int)width height:(int) height framerate:(float)framerate {
    [[FrtcWindowCaptureInterface getInstance] configContentCapbilityLevel:width height:height framerate:framerate];
}


#pragma mark- --Sharing App Indicator window
- (void)showShareIndicatorAndPrepareForAppShare {
    [[FrtcWindowCaptureInterface getInstance] showShareIndicatorAndPrepareForAppShare];
}

- (void)stopShowShareIndicator {
    [[FrtcWindowCaptureInterface getInstance] stopShowShareIndicator];
}

- (NSArray *)getDisplayScreenArray {
    NSMutableArray *displayArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    NSArray *screens = [NSScreen screens];
    for (NSInteger index = 0; index < [screens count]; index++) {
        NSScreen *screen = [screens objectAtIndex:index];
        NSDictionary* screenDictionary = [screen deviceDescription];
        NSNumber* screenID = [screenDictionary objectForKey:@"NSScreenNumber"];
        CGDirectDisplayID aID = [screenID unsignedIntValue];
        
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        
        [dictionary setValue:[NSNumber numberWithInteger:index] forKey:@"index"];
        [dictionary setValue:[NSNumber numberWithUnsignedInt:aID] forKey:@"displayID"];
        [dictionary setValue:[NSNumber numberWithFloat:screen.frame.origin.x]  forKey:@"x"];
        [dictionary setValue:[NSNumber numberWithFloat:screen.frame.origin.y]  forKey:@"y"];
        [dictionary setValue:[NSNumber numberWithFloat:screen.frame.size.width]  forKey:@"width"];
        [dictionary setValue:[NSNumber numberWithFloat:screen.frame.size.height]  forKey:@"height"];
        
        [displayArray addObject:dictionary];
    }
    
    return displayArray;
}

@end
