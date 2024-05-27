#pragma once
#include <string>
#include <vector>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CGImage.h>

namespace AppWindowCapturing
{

typedef long WDID;

#define MAXINUM_DISPLAY_COUNT 100

class IAppWindowCaptureObserver
{
public:
    virtual ~IAppWindowCaptureObserver(){}
    virtual void CapturedWindowClosed() = 0;
    virtual void CapturedWindwoMinimizedStated(bool minmized) = 0;
};
}

