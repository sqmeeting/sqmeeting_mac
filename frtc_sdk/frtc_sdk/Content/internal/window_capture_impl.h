#pragma once

#import <Foundation/Foundation.h>
#include <pthread.h>
#include "DeviceObject.h"

typedef void (*CaptureAppWindowDataCallback)(void *buffer, int length, int width, int height, int stride, RTC::VideoColorFormat fromat, std::string mediaID);

typedef struct {
    int    width;
    int    height;
    int    framerate;
} WINDOW_CAPTURE_CAPS_LEVEL;


class WindowCaptureInterface;

class AppWindowCaptureImpl {
public:
    AppWindowCaptureImpl();
    ~AppWindowCaptureImpl();
    static AppWindowCaptureImpl *instance();

public:
    WINDOW_CAPTURE_CAPS_LEVEL      _capbility_level;

    WindowCaptureInterface*    deviceAdaptor;
    CaptureAppWindowDataCallback    appWindowDataCallBack;
    std::string mediaID;
    
public:
    BOOL startAppWindowCapture();
    void stopAppWindowCapture();
    
    void showShareIndicatorAndPrepareForAppShare();
    void stopShowShareIndicator();
    
    bool configApplicationWindowID(const char *windowID);
    bool configApplicationName(std::string sourceAppContentName);

    void configContentOutputCallback(CaptureAppWindowDataCallback callBack);
    void configContentCapbilityLevel(int width ,int height , float framerate);
};
