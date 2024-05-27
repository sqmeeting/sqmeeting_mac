#import "CaptureCameraStream.h"
#import "FrtcCall.h"
#import "ObjectInterface.h"
#include <string>
#include <list>

#define HIGH_DEFINITION_VIDEO_WIDTH    1920
#define HIGH_DEFINITION_VIDEO_HEIGHT   1080
#define MIN_PEOPLE_VIDEO_SIZE   ((HIGH_DEFINITION_VIDEO_WIDTH * HIGH_DEFINITION_VIDEO_HEIGHT) / 9 )

#define AREA_DIFFERENCE(x1,y1,x2,y2) ( x1 * y1 + x2 * y2 - 2 * fmin ( x1, x2 ) * fmin ( y1, y2 ))

#define IS_SAME_RATIO(x1,y1,x2,y2) (((x1) * (y2) == (x2) * (y1))? 1 : 0)

static void NV12ToI420(unsigned char *src_plane1,
                       int src_stride1,
                       unsigned char *src_plane2,
                       int src_stride2,
                       int width,
                       int height,
                       unsigned char *dest)
{
    unsigned char *y = dest;
    unsigned char *u = dest +  width * height;
    unsigned char *v = dest +  width * height * 5 / 4;

    if ( src_stride1 == 0)
    {
        src_stride1 = width;
    }

    if ( src_stride2 == 0)
    {
        src_stride2 = width;
    }

    if ( src_plane2 == NULL)
    {
        src_plane2 = src_plane1 + src_stride1 * height;
    }

    for ( int i = 0; i < height; i++)
    {
        memcpy(y, src_plane1, width);
        src_plane1 += src_stride1;
        y += width;
    }

    for (int i = 0; i < height / 2; i++)
    {
        for ( int j = 0; j < width / 2; j++ )
        {
            u[j] = src_plane2 [j * 2];
            v[j] = src_plane2 [j * 2 + 1];
        }

        u += width / 2;
        v += width / 2;
        src_plane2 += src_stride2;
    }
}

#pragma mark - CaptureCameraStream

@interface CaptureCameraStream()

@property (nonatomic, strong) AVCaptureDevice           *captureVideoDevice;
@property (nonatomic, strong) AVCaptureDeviceInput      *captureVideoDeviceDataInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput  *captureVideoDeviceDataOutput;
@property (nonatomic, strong) AVCaptureSession          *captureSession;
@property (nonatomic, strong) NSMutableArray            *cameraDeviceList;

- (bool)isValidCaptureDevice:(AVCaptureDevice *)device;
- (void)updateCamerasList;
- (NSArray *)videoDevices;

@end

@implementation CaptureCameraStream

+ (CaptureCameraStream *)SingletonInstance {
    static CaptureCameraStream *singletonInstance = nil;
    static dispatch_once_t once_taken = 0;
    dispatch_once(&once_taken, ^{
        singletonInstance = [[CaptureCameraStream alloc] init];
        
    });
    
    return singletonInstance;
}
- (void)addCamerationNotification:(NSNotification *)notification {
    if(![(AVCaptureDevice*)notification.object hasMediaType:AVMediaTypeVideo]
       &&![(AVCaptureDevice*)notification.object hasMediaType:AVMediaTypeMuxed]) {
        return;
    }
    
    [self updateCamerasList];
    [self notificatonToUICameraListChanged];
}

- (void)removeCameraNotification:(NSNotification *)notification {
    if(![(AVCaptureDevice*)notification.object hasMediaType:AVMediaTypeVideo]
       &&![(AVCaptureDevice*)notification.object hasMediaType:AVMediaTypeMuxed]) {
        return;
    }
    
    [self updateCamerasList];
    NSString *deviceId = ((AVCaptureDevice*)notification.object).localizedName;

    if([deviceId isEqualToString:self.nowUsedDeviceID]) {
        self.captureVideoDevice = [self getDeviceByDefault];
        if(self.captureVideoDevice) {
            self.nowUsedDeviceID = [self.captureVideoDevice localizedName];
        }
        if(self.captureSession.isRunning) {
            [self stopCameraDeviceCapture];
            [self startCameraDeviceCapture];
        }
    }
    
    [self notificatonToUICameraListChanged];
}

- (void)notificatonToUICameraListChanged {
    NSString *cameraName = [self getCurrentCamereName];

    NSDictionary *deviceInUse = [NSDictionary dictionaryWithObjectsAndKeys: cameraName, @"camera", nil];
  
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: deviceInUse, FMeetingCameraListInUseKey, nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:FMeetingCameraListChangedNotification
                                                            object:nil
                                                          userInfo:dic];
    });
}

- (instancetype)init {
    self = [super init];
    if(self) {
        self.mediaID = @"VPL_PREVIEW";
        self.cameraDeviceList = [[NSMutableArray alloc] init];
        self.nowUsedDeviceID = @"";
        
        [self videoDevices];
        [self setupClientDeviceCapabilityLevel];
    }

    self.devicePreferenceSettings = FRAMERATE_IN_FIRST;
    return self;
}

- (void)setupClientDeviceCapabilityLevel {
    int deviceCpuCapaLevel = [[ObjectInterface sharedObjectInterface] getCPULevelObject];
    
    if(deviceCpuCapaLevel == 1) {
        _cameraCapability.videoWidth  = 1920;
        _cameraCapability.videoHeight = 1080;
    } else if(deviceCpuCapaLevel == 2) {
        _cameraCapability.videoWidth  = 1280;
        _cameraCapability.videoHeight = 720;
    } else {
        _cameraCapability.videoWidth  = 960;
        _cameraCapability.videoHeight = 540;
    }
    _cameraCapability.videoFramerate  = 30;
}

- (void)videoDeviceCapabilityList:(std::list<VideoDeviceCapa> &)cameraCapaList {
    int i = 0;
    
    cameraCapaList.clear();
    for (AVCaptureDeviceFormat *deviceFormat in self.captureVideoDevice.formats) {
        CMFormatDescriptionRef formatDescription = deviceFormat.formatDescription;
        CMVideoDimensions videoDimensions = CMVideoFormatDescriptionGetDimensions((CMVideoFormatDescriptionRef)formatDescription);
                
        double minFrameRateRange = 1e+10;
        double maxFrameRateRange = 1e-10;
        for (AVFrameRateRange *range in deviceFormat.videoSupportedFrameRateRanges) {
            if (range.minFrameRate < minFrameRateRange) {
                minFrameRateRange = range.minFrameRate;
            }
            if (range.maxFrameRate > maxFrameRateRange) {
                maxFrameRateRange = range.maxFrameRate;
            }
        }

        VideoDeviceCapa capability;
        capability.videoWidth        = videoDimensions.width;
        capability.videoHeight       = videoDimensions.height;
        capability.index             = i;
        capability.maxFrameRateRange = maxFrameRateRange;
        
        cameraCapaList.push_back(capability);
        i++;
    }
}

- (void)substitutableMediaType:(std::list<VideoDeviceCapa>&)deviceCapaList neglectResolution:(BOOL)neglectResolution reudceHalfFrameRate:(BOOL)reduceFrameRate {
    deviceCapaList.clear();
    
    std::list<VideoDeviceCapa> deviceCapsList;
    [self videoDeviceCapabilityList:deviceCapsList];
    
    for(auto item:deviceCapsList) {
        int videoWidth = item.videoWidth;
        int videoHeight = item.videoHeight;
        int videoFramerate =(item.maxFrameRateRange > 30 ) ? 30 : item.maxFrameRateRange;
        
        if(0 == videoWidth || 0 == videoHeight || videoWidth * videoHeight > HIGH_DEFINITION_VIDEO_WIDTH * HIGH_DEFINITION_VIDEO_HEIGHT) {
            continue;
        }
        
        if(neglectResolution || ((videoWidth % 4 == 0) && (videoHeight % 4 == 0) && !reduceFrameRate) || ((videoWidth % 16 == 0) && (videoHeight % 16 == 0) && reduceFrameRate)) {
                BOOL bCondition = ((_cameraCapability.videoFramerate < 0) || (videoFramerate * 24 >= ((int)_cameraCapability.videoFramerate) * 8)) &&
                      (videoWidth * videoHeight <= _cameraCapability.videoHeight * _cameraCapability.videoWidth * 4) && (videoWidth* videoHeight >= MIN_PEOPLE_VIDEO_SIZE);

            if(reduceFrameRate) {
                bCondition = ((_cameraCapability.videoFramerate < 0) || (videoFramerate * 48 >= ((int)_cameraCapability.videoFramerate) * 8)) &&
                             (videoWidth * videoHeight <= _cameraCapability.videoHeight*_cameraCapability.videoWidth * 4) && (4 * videoWidth* videoHeight >= _cameraCapability.videoHeight*_cameraCapability.videoWidth);
            } else if(neglectResolution) {
                bCondition = YES;
            }
               
            if(bCondition) {
                deviceCapaList.push_back(item);
            }
        }
    }
}

- (int)findSubstitutableType {
    int selectIndex = -1;
    BOOL bSurforce4OrBook = NO;
    BOOL bInteCamera = NO;
    BOOL bHuddleCamHD = NO;
    int nHuddleCamHD_Idx = -1;
    
    std::list<VideoDeviceCapa> videoDeviceCapaList;

    [self substitutableMediaType:videoDeviceCapaList neglectResolution:NO reudceHalfFrameRate:NO];
    
    if(videoDeviceCapaList.empty()) {
        [self substitutableMediaType:videoDeviceCapaList neglectResolution:NO reudceHalfFrameRate:YES];
        if(videoDeviceCapaList.empty()) {
            [self substitutableMediaType:videoDeviceCapaList neglectResolution:YES reudceHalfFrameRate:NO];
        }
    }

    int bestIndex               = -1;
    int diff                    = -1;
    int frameDiff               = -1;
    int bestFrameSR             = 0;
    int bestFrameOtherW         = 0;
    int bestFrameOther          = 0;
    int minDiffSameRatio        = INT_MAX;
    int minFrameDiffSameRatio   = INT_MAX;
    int minDiffOtherW           = INT_MAX;
    int minDiffOther            = INT_MAX;
    int sameRitio               = 0;
    int bestResolutionH         = -1;
    int bestIndexSame           = -1;
    int bestIndexSameRatio      = -1;
    int  bestIndexSameW         = -1;
    int bestIndexOther          = -1;

    for (auto iter:videoDeviceCapaList) {
        sameRitio = IS_SAME_RATIO(_cameraCapability.videoWidth,_cameraCapability.videoHeight,iter.videoWidth,iter.videoHeight);
        if (iter.videoWidth <= HIGH_DEFINITION_VIDEO_WIDTH) {
            diff = AREA_DIFFERENCE(_cameraCapability.videoWidth,_cameraCapability.videoHeight,iter.videoWidth,iter.videoHeight);
            frameDiff = _cameraCapability.videoFramerate >= iter.maxFrameRateRange ? (_cameraCapability.videoFramerate - iter.maxFrameRateRange) : 0;
            
            if(selectIndex > -1 && bSurforce4OrBook && bInteCamera) {
                return selectIndex;
            }

            if (_cameraCapability.videoWidth == iter.videoWidth
                    && _cameraCapability.videoHeight == iter.videoHeight
                    && iter.maxFrameRateRange == _cameraCapability.videoFramerate) {
                bestIndexSame = iter.index;
                break;
            }
            else if(sameRitio
                && (diff < minDiffSameRatio || frameDiff < minFrameDiffSameRatio)) {
                minDiffSameRatio = fmin(minDiffSameRatio, diff);
                minFrameDiffSameRatio = fmin(minFrameDiffSameRatio, frameDiff);
                if (self.devicePreferenceSettings == FRAMERATE_IN_FIRST) {
                    if (bestFrameSR <= iter.maxFrameRateRange || iter.maxFrameRateRange >= _cameraCapability.videoFramerate) {
                        bestIndexSameRatio = iter.index;
                        bestFrameSR = iter.maxFrameRateRange;
                    }
                } else {
                    if(bestResolutionH < iter.videoHeight && iter.videoHeight <= _cameraCapability.videoHeight) {
                        bestIndexSameRatio = iter.index;
                        bestResolutionH = iter.videoHeight;
                    }
                }
            } else if (!sameRitio
                && _cameraCapability.videoWidth == iter.videoWidth
                && _cameraCapability.videoHeight < iter.videoHeight
                && diff < minDiffOtherW
                && (bestFrameOtherW <= iter.maxFrameRateRange || iter.maxFrameRateRange>= _cameraCapability.videoFramerate)) {
                minDiffOtherW = diff;
                 bestIndexSameW   = iter.index;
                bestFrameOtherW = iter.maxFrameRateRange;
            }
            else if (!sameRitio
                && diff < minDiffOther
                && (bestFrameOther <= iter.maxFrameRateRange || iter.maxFrameRateRange >= _cameraCapability.videoFramerate)) {
                minDiffOther = diff;
                bestIndexOther = iter.index;
                bestFrameOther = iter.maxFrameRateRange;
            }
            
        }
    }
    if (bestIndexSame != -1) {
        bestIndex = bestIndexSame;
        return bestIndex;
    }

    if (bestIndexSame == -1) {
        if (self.devicePreferenceSettings == RESOLUTION_IN_FIRST && bestIndexSameRatio > -1 && bestResolutionH > -1) {
            bestIndex = bestIndexSameRatio;
        } 
        else if(bestFrameSR >= bestFrameOtherW && bestFrameSR >= bestFrameOther ) {
            bestIndex = bestIndexSameRatio;
        } 
        else if( bestFrameSR >= _cameraCapability.videoFramerate) {
            bestIndex = bestIndexSameRatio;
        } 
        else if(bestFrameSR < bestFrameOtherW) {
            if(bestFrameOtherW >= bestFrameOther) {
                bestIndex =  bestIndexSameW  ;
            } 
            else if(bestFrameOtherW >= _cameraCapability.videoFramerate) {
                bestIndex =  bestIndexSameW  ;
            } 
            else {
                bestIndex = bestIndexOther;
            }
        } 
        else {
            bestIndex = bestIndexOther;
        }
    }

    if(bSurforce4OrBook && bInteCamera) {
        selectIndex = bestIndex;
    }

    if(bHuddleCamHD) {
        nHuddleCamHD_Idx = bestIndex;
    }
    
    return bestIndex;
}

- (void)selectBestResolution {
    int index = [self findSubstitutableType];
    
    if(index < 0 || index >= self.captureVideoDevice.formats.count) {
        return;
    }

    AVCaptureDeviceFormat *deviceFormat = self.captureVideoDevice.formats[index];
    CMFormatDescriptionRef formatDescription = deviceFormat.formatDescription;
    CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions((CMVideoFormatDescriptionRef)formatDescription);
    AVFrameRateRange *selectedFrameRateRange = nil;
    for (AVFrameRateRange *range in deviceFormat.videoSupportedFrameRateRanges) {
        if (selectedFrameRateRange == nil) {
            selectedFrameRateRange = range;
        }
        if (range.maxFrameRate >= _cameraCapability.videoFramerate * 0.9 &&
            range.maxFrameRate < selectedFrameRateRange.maxFrameRate) {
            selectedFrameRateRange = range;
        }
    }
    
    NSError *error;
    if ([self.captureVideoDevice lockForConfiguration:&error]) {
        [self.captureVideoDevice setActiveFormat:deviceFormat];
        [self.captureVideoDevice setActiveVideoMinFrameDuration:[selectedFrameRateRange minFrameDuration]];
        [self.captureVideoDevice unlockForConfiguration];
    }
    
    AVCaptureDeviceFormat *activeDeviceFormat = [self.captureVideoDevice activeFormat];
    formatDescription = activeDeviceFormat.formatDescription;
    dimensions = CMVideoFormatDescriptionGetDimensions((CMVideoFormatDescriptionRef)formatDescription);
    
    int height = 0;
    float frameRate = 0.0;
    [self getDeviceCapability:height withFrameRate:frameRate];
    
    std::string resolutionSring;
    [self createResolutionString:dimensions.height framerate:(int)frameRate strResolution:resolutionSring];
    
    [[ObjectInterface sharedObjectInterface] setCameraCapabilityObject:resolutionSring];
}

- (void)getDeviceCapability:(int &)height withFrameRate:(float &)frameRate {
    AVCaptureDeviceFormat *activeFormat = [self.captureVideoDevice activeFormat];
    CMFormatDescriptionRef formatDescription = activeFormat.formatDescription;
    CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions((CMVideoFormatDescriptionRef)formatDescription);
    height = dimensions.height;

    for (AVFrameRateRange *range in activeFormat.videoSupportedFrameRateRanges) {
        if (range.maxFrameRate >= frameRate ) {
            frameRate = range.maxFrameRate;
        }
    }
}

- (void)createResolutionString:(int)height framerate:(int)framerate strResolution:(std::string&)resolutionString {
    resolutionString.clear();
    
    if(framerate > 30)
        framerate = 30;
    
    if (height < 360) {
        resolutionString = resolutionString.append("180");
    } 
    else if (height < 540) {
        resolutionString = resolutionString.append("360");
    } 
    else if (height < 720) {
        resolutionString = resolutionString.append("540");
    } 
    else if (height < 1080) {
        resolutionString = resolutionString.append("720");
    } 
    else if (height >= 1080) {
        resolutionString = resolutionString.append("1080");
    }
    
    resolutionString = resolutionString.append("p");

    if (height > 180 && framerate < 30) {
        framerate = 30;
    }
    
    char rate[12] = { 0 };
    snprintf(rate, 12, "%d", framerate);
    resolutionString = resolutionString.append(rate);
}

- (bool)isValidCaptureDevice:(AVCaptureDevice *)device {
    AVCaptureDevice *captureDevice = (AVCaptureDevice *)device;
    for (AVCaptureDeviceFormat * fmt in captureDevice.formats) {
        if ([[fmt videoSupportedFrameRateRanges] count] > 0) {
            return true;
        }
    }
    
    return false;
}

- (NSString*) getCurrentCamereName {
    return self.nowUsedDeviceID;
}

- (void)updateCamerasList {
    [self willChangeValueForKey:@"videoDevices"];
    [self.cameraDeviceList removeAllObjects];
    NSArray *captureDevices = NULL;
    NSArray *videoDevices = NULL;
    NSArray *muxedDevices = NULL;
    
    if (@available(macOS 10.15, *)) {
        AVCaptureDeviceDiscoverySession *videoDeviceDiscoverySession = [AVCaptureDeviceDiscoverySession   discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera, AVCaptureDeviceTypeExternalUnknown]  mediaType:AVMediaTypeVideo
                position: AVCaptureDevicePositionUnspecified];
        videoDevices = [videoDeviceDiscoverySession devices];
        
        AVCaptureDeviceDiscoverySession *muxedDeviceDiscoverySession = [AVCaptureDeviceDiscoverySession   discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera, AVCaptureDeviceTypeExternalUnknown]  mediaType:AVMediaTypeMuxed
               position: AVCaptureDevicePositionUnspecified];
        muxedDevices = [muxedDeviceDiscoverySession devices];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        muxedDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeMuxed];
#pragma clang diagnostic pop
    }
    captureDevices = [videoDevices arrayByAddingObjectsFromArray: muxedDevices];
    
    for(AVCaptureDevice* captureDevice in captureDevices) {
        if ([self isValidCaptureDevice:captureDevice]) {
            [self.cameraDeviceList addObject:captureDevice];
        }
    }
    
    [self didChangeValueForKey:@"videoDevices"];
}


- (NSArray *)videoDevices {
    [self updateCamerasList];
    
    return self.cameraDeviceList;
}

- (void)getVideoDeviceList:(NSMutableArray *)videoDeviceList {
    [videoDeviceList removeAllObjects];
    
    [self videoDevices];
    int index = 0;
    AVCaptureDevice * device = nil;
    
    for (; index < [self.cameraDeviceList count]; index++) {
        device = [self.cameraDeviceList objectAtIndex:index];
        NSMutableDictionary *deviceInfo = [NSMutableDictionary dictionaryWithCapacity:2];
        [deviceInfo setObject:device.localizedName forKey:@"name"];
        [deviceInfo setObject:device.uniqueID forKey:@"id"];
        [videoDeviceList addObject:deviceInfo];
    }
}

- (void)switchCameraByDeviceID:(NSString *)deviceID {
    AVCaptureDevice  *cameraDevice;
    
    NSString *currentDeviceID = self.nowUsedDeviceID;
    self.nowUsedDeviceID = @"";
    
    for (int i = 0; i < [self.cameraDeviceList count]; i++) {
        cameraDevice = [self.cameraDeviceList objectAtIndex:i];
        if([cameraDevice.localizedName isEqualToString:deviceID]) {
            self.nowUsedDeviceID = deviceID;
            break;
        }
    }    
    
    if( [currentDeviceID isEqualToString:self.nowUsedDeviceID] == NO && self.captureSession.isRunning) {
        [self stopCameraDeviceCapture];
        [self startCameraDeviceCapture];
    }
}

- (NSString *)getDefaultCameraName {
    return [self getDeviceByDefault].localizedName;
}

- (AVCaptureDevice *)getDeviceByDefault {
    NSArray *captureDevices = nil;
    if (@available(macOS 10.15, *)) {
        AVCaptureDeviceDiscoverySession *captureDeviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera]
                                                                                                                                mediaType:AVMediaTypeVideo
                                                                                                                                 position: AVCaptureDevicePositionUnspecified];
        captureDevices = [captureDeviceDiscoverySession devices];
    } else {
#if __MAC_OS_X_VERSION_MAX_ALLOWED <= __MAC_10_15
        // Fallback on earlier versions
        captureDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
#endif
    }

    for(AVCaptureDevice *device in captureDevices) {
       return  device;
    }
    return nil;
}

- (AVCaptureDevice *)getDeviceByName:(NSString *)name {
    for (AVCaptureDevice *device in self.cameraDeviceList) {
        if ([[device localizedName] isEqualToString:name]) {
            return device;
        }
    }
    
    return  nil;
}

- (BOOL)startCameraDeviceCapture {
    if (self.captureSession.isRunning) {
        return YES;
    }
    
    NSError *error = nil;
    [self updateCamerasList];

    self.captureVideoDevice = [self getDeviceByName:self.nowUsedDeviceID];
    
    if(!self.captureVideoDevice) {
        self.captureVideoDevice = [self getDeviceByDefault];
        
        if( self.captureVideoDevice) {
            self.nowUsedDeviceID = [self.captureVideoDevice localizedName];
        }
    }
    
    
    self.captureVideoDeviceDataInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureVideoDevice error:&error];
    
    if(self.captureVideoDeviceDataInput == nil) {
        return NO;
    }
    
    self.captureVideoDeviceDataOutput = [[AVCaptureVideoDataOutput alloc] init];

    
    NSDictionary *settings = nil;
    
    bool supportNV12 = NO;
    
    NSArray *pixelFormatTypes = [self.captureVideoDeviceDataOutput availableVideoCVPixelFormatTypes];
    NSNumber* pixelfmt = [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange];
    
    for (NSNumber* fmtType in pixelFormatTypes) {
        if([fmtType unsignedIntegerValue] == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange ||
           [fmtType unsignedIntegerValue]  == kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange) {
            pixelfmt = fmtType;
            supportNV12 = YES;
        }
        
        if([fmtType unsignedIntegerValue] == kCVPixelFormatType_420YpCbCr8Planar ||
           [fmtType unsignedIntegerValue] == kCVPixelFormatType_420YpCbCr8PlanarFullRange) {
        }
    }
    
    if(!supportNV12) {
        return NO;
    }


    settings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] forKey:(NSString*)kCVPixelBufferPixelFormatTypeKey];

    if (!settings) {
        self.captureVideoDeviceDataInput = nil;
        return NO;
    }
    
    [self.captureVideoDeviceDataOutput setVideoSettings:settings];
    dispatch_queue_t inputQueue = dispatch_queue_create("com.fmeeting", NULL);
    dispatch_queue_t highPriority = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_set_target_queue(inputQueue, highPriority);
    [self.captureVideoDeviceDataOutput setSampleBufferDelegate:self queue:inputQueue];

    
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession beginConfiguration];
    
    if([self.captureSession canAddOutput:self.captureVideoDeviceDataOutput]) {
        [self.captureSession addOutput:self.captureVideoDeviceDataOutput];
    } else {
        return NO;
    }
    

    [self.captureSession addInput:self.captureVideoDeviceDataInput];

    if(self.captureVideoDeviceDataOutput.connections[0].isVideoMirroringSupported) {
        self.captureVideoDeviceDataOutput.connections[0].automaticallyAdjustsVideoMirroring = NO;
        self.captureVideoDeviceDataOutput.connections[0].videoMirrored = YES;
    }

    [self.captureSession commitConfiguration];
    [self.captureSession startRunning];
    
    [self selectBestResolution];
    
    return NO;
}

- (void)stopCameraDeviceCapture {
    if (self.captureSession.isRunning) {
        [self.captureSession stopRunning];
    }
    
    [self.captureVideoDeviceDataOutput setSampleBufferDelegate:nil queue:NULL];
    [self.captureSession removeInput:self.captureVideoDeviceDataInput];
    [self.captureSession removeOutput:self.captureVideoDeviceDataOutput];
    
    self.captureSession = nil;
    self.captureVideoDeviceDataInput = nil;
    self.captureVideoDeviceDataOutput = nil;
    self.captureVideoDevice = nil;
}

- (void)startCaptureSession {
    if(self.captureSession != nil) {
        [self.captureSession startRunning];
    } else {
        [self startCameraDeviceCapture];
    }
}

- (void)stopCaptureSession {
    if ([self.captureSession isRunning]) {
        [self.captureSession stopRunning];
    }
}

#pragma mark - CaptureCameraStream <AVCaptureVideoDataOutputSampleBufferDelegate>

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CVImageBufferRef videoFrame = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(videoFrame, 0);

    size_t bytesPerRowY = CVPixelBufferGetBytesPerRowOfPlane(videoFrame, 0);
    size_t bytesPerRowUV = CVPixelBufferGetBytesPerRowOfPlane(videoFrame, 1);
    uint8_t *baseAddrY = (uint8_t*)CVPixelBufferGetBaseAddressOfPlane(videoFrame, 0);
    size_t width = CVPixelBufferGetWidth(videoFrame);
    size_t height = CVPixelBufferGetHeight(videoFrame);
    uint8_t *baseAddrUV = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(videoFrame, 1);

    uint8_t* buffer = (uint8_t* )malloc(width * height * 3 / 2);
    
    NV12ToI420(baseAddrY,
               (int)bytesPerRowY,
               baseAddrUV,
               (int)bytesPerRowUV,
               (int)width,
               (int)height,
               buffer);
    
    if (self.mediaID) {
        [[ObjectInterface sharedObjectInterface] sendVideoFrameObject:self.mediaID videoBuffer:buffer length:(int) width * height * 3 / 2 width:width height:height videoSampleType:RTC::kI420];

    }
    
   free(buffer);
    
   CVPixelBufferUnlockBaseAddress(videoFrame, 0);
}

@end
