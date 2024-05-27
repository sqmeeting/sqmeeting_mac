#import <Cocoa/Cocoa.h>
#import <dispatch/dispatch.h>
#import <wchar.h>
#import <iostream>
#import "window_capture_interface.h"
#import "common.h"

int RGB2YUV_YR[256], RGB2YUV_YG[256], RGB2YUV_YB[256];
int RGB2YUV_UR[256], RGB2YUV_UG[256], RGB2YUV_UBVR[256];
int RGB2YUV_VG[256], RGB2YUV_VB[256];

int ConvertRGBA2YUV(int w,int h,unsigned char *bmp,unsigned char *yuv)
{
    unsigned char *u,*v,*y,*uu,*vv;
    unsigned char *pu1,*pu2,*pu3,*pu4;
    unsigned char *pv1,*pv2,*pv3,*pv4;
    unsigned char *r,*g,*b;
    int i,j;

    uu = (unsigned char *)malloc(sizeof(unsigned char) * (w * h));
    if(uu == NULL)
    {
        return 0;
    }
    
    vv = (unsigned char *)malloc(sizeof(unsigned char) * (w * h));
    if( vv== NULL)
    {
        free(uu);
        return 0;
    }
    
    y = yuv;
    u = uu;
    v = vv;

    r = bmp;
    g = bmp+1;
    b = bmp+2;

    for(i = 0;i < h;i++)
    {
        for(j = 0;j < w;j++)
        {
            *y++ = (RGB2YUV_YR[*r]   + RGB2YUV_YG[*g] + RGB2YUV_YB[*b]   + 1048576)>>16;
            *u++ = (-RGB2YUV_UR[*r]  - RGB2YUV_UG[*g] + RGB2YUV_UBVR[*b] + 8388608)>>16;
            *v++ = (RGB2YUV_UBVR[*r] - RGB2YUV_VG[*g] - RGB2YUV_VB[*b]   + 8388608)>>16;

            r += 4;
            g += 4;
            b += 4;
        }
    }
    
    u = yuv + w * h;
    v= u + (w * h) / 4;
    // For U
    pu1 = uu;
    pu2 = pu1 + 1;
    pu3 = pu1 + w;
    pu4 = pu3 + 1;
    // For V
    pv1 = vv;
    pv2 = pv1 + 1;
    pv3 = pv1 + w;
    pv4 = pv3 + 1;
    // Do sampling....
    for(i = 0; i < h; i += 2)
    {
        for(j = 0;j < w;j += 2)
        {
            *u++ = (*pu1 + *pu2 + *pu3 + *pu4)>>2;
            *v++ = (*pv1 + *pv2 + *pv3 + *pv4)>>2;
            pu1 += 2;
            pu2 += 2;
            pu3 += 2;
            pu4 += 2;
            pv1 += 2;
            pv2 += 2;
            pv3 += 2;
            pv4 += 2;
        }
        pu1 += w;
        pu2 += w;
        pu3 += w;
        pu4 += w;
        pv1 += w;
        pv2 += w;
        pv3 += w;
        pv4 += w;
    }
    free(uu);
    free(vv);
    
    return 1;
}

void outputAppWindowContentBuffer(void *buffer, int length, int width, int height, int stride, Capture_VideoSampleType type, std::string mediaID)
{
    AppWindowCaptureImpl *appWindowCapture = AppWindowCaptureImpl::instance();
    
    if (appWindowCapture && appWindowCapture->appWindowDataCallBack  && appWindowCapture->mediaID.rfind("VCS", 0) == 0)
    {
        if (0 >= length) 
        {
            return;
        }
        
        appWindowCapture->appWindowDataCallBack(
                                         buffer, 
                                         length,
                                         width,
                                         height,
                                         stride,
                                         static_cast<RTC::VideoColorFormat>(type),
                                         appWindowCapture->mediaID);
            
        if (!mediaID.empty()) 
        {
            if (0 == mediaID.compare("1"))
            {
                if (buffer != nullptr) {
                    free(buffer);
                    buffer = nullptr;
                }
            }
        }
    }
}


#pragma mark- loca pause-png for sharing app pause


uint8_t * WindowCaptureInterface::loadSharingAppPauseImage() {
    static uint8_t *imageData_pauseImage = NULL;
   
    NSImage *srcImage = [NSImage imageNamed:@"shariing-app-content-pause.png"];
    CGImageRef cgImage = [srcImage CGImageForProposedRect:NULL context:NULL hints:NULL];
    
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(cgImage);
    CGColorSpaceRef colorRef = CGColorSpaceCreateDeviceRGB();
    
    float width = srcImage.size.width;
    float height = srcImage.size.height;
    float uiYUV420Len = (width * height * 3) / 2;

    imageData_pauseImage = (uint8_t *) malloc(width * height * 4);
    
    CGContextRef imageContext = CGBitmapContextCreate(imageData_pauseImage,
                                                      width, height,
                                                      8, static_cast<size_t>(width * 4),
                                                      colorRef, alphaInfo);

    CGContextDrawImage(imageContext, CGRectMake(0, 0, width, height), cgImage);
    CGContextRelease(imageContext);
    CGColorSpaceRelease(colorRef);
    
    uint8_t * yuvByteBuffer = (uint8 *)malloc(uiYUV420Len);
    //ConvertRGBA2YUV(width, height, (unsigned char *)imageData_pauseImage, (unsigned char *)yuvByteBuffer);

    return yuvByteBuffer;
}

void WindowCaptureInterface::createCaptureAppContentTimerThread() {
    if (NULL == _macShareAppLib) {
        _macShareAppLib = MacShareAppStaticLibClass::getInstance();
    }
    _macShareAppLib->setCapability(_capsLevel.width, 
                                   _capsLevel.height, 
                                   _capsLevel.framerate);

    _macShareAppLib->setAppWinContentOutputCallback(outputAppWindowContentBuffer);
    
    _macShareAppLib->setAppContentName(_sourceAppContentName, _sourceAppContentWindowID);
    _macShareAppLib->startAppWindowCapturerMac();
}

WindowCaptureInterface::WindowCaptureInterface(AppWindowCaptureImpl *captureImpl) :
                    _device(NULL),
                    _appCaptureImpl(captureImpl),
                    _macShareAppLib(nullptr),
                    _isSharingApp(false),
                    _sourceAppContentWindowID(0)
{
}

WindowCaptureInterface::~WindowCaptureInterface() {
    stopAppWindowCapture();
}

bool WindowCaptureInterface::configApplicationWindowID(const char *windowID) {
    _sourceAppContentWindowID = atoi(windowID);
    
    bool success = false;
    
    {
        AutoMutex winIDLock(this->_lock);
        if (windowID) {
            int index = 0;
            char *temp = (char*)malloc(strlen(windowID)+1);
            _appWinVec.clear();
            index = 0;
            while(*windowID && *windowID != ',') {
                temp[index++] = *windowID++;
            }
            temp[index] = '\0';
            AppWindowCapturing::WDID wId = (AppWindowCapturing::WDID)atoi(temp);
            _appWinVec.push_back(wId);
            windowID++;
            free(temp);
            success = true;
        } else {
            _appWinVec.clear();
            success = true;
        }
    }
    return success;
}

bool WindowCaptureInterface::configApplicationName(std::string sourceAppContentName) {
    {
        AutoMutex winIDLock(this->_lock);
        _sourceAppContentName = sourceAppContentName;
    }
  
    return true;
}

bool WindowCaptureInterface::startAppWindowCapture() {
    if (_isSharingApp) 
    {
        return false;
    }
    
    {
        AutoMutex winIDLock(this->_lock);
        
        WINDOW_CAPTURE_CAPS_LEVEL capability = _appCaptureImpl->_capbility_level;
        _capsLevel.width = capability.width;
        _capsLevel.height = capability.height;
        _capsLevel.framerate = capability.framerate;
        
        this->createCaptureAppContentTimerThread();
    }
    
    return true;
}

bool WindowCaptureInterface::stopAppWindowCapture() {
    {
        AutoMutex winIDLock(this->_lock);
        if (NULL != _macShareAppLib) {
            _macShareAppLib->stopAppWindowCapturerMac();
            _macShareAppLib->releaseInstance();
            _macShareAppLib = NULL;
        }
        
        if (_device != NULL) {
            _device->RemoveObserver(this);
            _device->StopShowShareIndicator();
            _device.reset();
        }
        
        _capsLevel.width     = 0;
        _capsLevel.height    = 0;
        _capsLevel.framerate = 0;
    }
   
    
    _isSharingApp = false;

    return true;
}

#pragma mark- --Sharing App Indicator window
void WindowCaptureInterface::showShareIndicatorAndPrepareForAppShare() {
    if (nullptr == _device && _appWinVec.size() > 0)
    {
        _device = std::make_shared<AppWindowCapture>(_appWinVec);
        _device->AddObserver(this);
        _device->StartShowShareIndicator();
    }
    if (nullptr != _device) 
    {
        _device->StartShowShareIndicator();
    }
}

void WindowCaptureInterface::stopShowShareIndicator() 
{
    if (nullptr != _device) 
    {
        _device->StopShowShareIndicator();
    }
}

void WindowCaptureInterface::CapturedWindowClosed() 
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:FMeetingUserAppShareAllWindowClosedNotification
                                                            object:nil
                                                          userInfo:nil];
    });
    return;
}

void WindowCaptureInterface::CapturedWindwoMinimizedStated(bool minmized) 
{
    static bool currentMinimized = false;
    
    if (currentMinimized == minmized)
    {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary* userInfo = nil;
        userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithBool:minmized], FMeetingUserAppShareAllWindowMinimizedStatusChangedKey, nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:FMeetingUserAppShareAllWindowMinimizedStatusChangedNotification
                                                            object:nil
                                                          userInfo:userInfo];
    });
    
    return;
}


