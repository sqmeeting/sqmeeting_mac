#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <sys/time.h>
#include <errno.h>
#import <Cocoa/Cocoa.h>
#include "window_capture_interface.h"
#include "window_capture_impl.h"

static AppWindowCaptureImpl* shareContentCapture = NULL;

AppWindowCaptureImpl* AppWindowCaptureImpl::instance()
{
    if ( !shareContentCapture )
    {
        shareContentCapture = new AppWindowCaptureImpl();
    }
    
    return  shareContentCapture;
}

AppWindowCaptureImpl::AppWindowCaptureImpl() 
{
    _capbility_level.width          = 1920;
    _capbility_level.height         = 1080;
    _capbility_level.framerate      = 15;
 
    deviceAdaptor = new WindowCaptureInterface(this);
}

AppWindowCaptureImpl::~AppWindowCaptureImpl()
{
    free(deviceAdaptor);
    deviceAdaptor = NULL;
}

void AppWindowCaptureImpl::configContentCapbilityLevel(int width ,int height, float framerate)
{
    _capbility_level.width     = width;
    _capbility_level.height    = height;
    _capbility_level.framerate = framerate;
}

bool AppWindowCaptureImpl::configApplicationWindowID(const char *windowID)
{
    if (deviceAdaptor)
    {
        return deviceAdaptor->configApplicationWindowID(windowID);
    }
    
    return false;
}

bool AppWindowCaptureImpl::configApplicationName(std::string sourceAppContentName)
{
    if (deviceAdaptor)
    {
        return deviceAdaptor->configApplicationName(sourceAppContentName);
    }
    
    return false;
}

void AppWindowCaptureImpl::configContentOutputCallback(CaptureAppWindowDataCallback callBack)
{
    appWindowDataCallBack = callBack;
}

BOOL AppWindowCaptureImpl::startAppWindowCapture()
{
    if (!deviceAdaptor)
    {
        return false;
    }
  
    deviceAdaptor->startAppWindowCapture();
    
    return true;
}

void AppWindowCaptureImpl::stopAppWindowCapture()
{
    if (!deviceAdaptor)
    {
        return;
    }
    
    deviceAdaptor->stopAppWindowCapture();
}

void AppWindowCaptureImpl::showShareIndicatorAndPrepareForAppShare()
{
    if (nullptr != deviceAdaptor)
    {
        deviceAdaptor->showShareIndicatorAndPrepareForAppShare();
    }
}

void AppWindowCaptureImpl::stopShowShareIndicator()
{
    if (nullptr != deviceAdaptor)
    {
        deviceAdaptor->stopShowShareIndicator();
    }
}

