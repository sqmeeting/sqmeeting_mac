#ifndef WINDOW_CAPTURE_INTERFACE_H_
#define WINDOW_CAPTURE_INTERFACE_H_

#import <vector>
#import "window_capture.h"
#include "window_capture_impl.h"
#import "MacShareAppStaticLibClass.hpp"

class AutoMutex {
public:
    AutoMutex(pthread_mutex_t &mutex)
        : m(mutex) {
        pthread_mutex_lock(&m);
    }

    ~AutoMutex() {
        pthread_mutex_unlock(&m);
    }
private:
    pthread_mutex_t &m;
};

class WindowCaptureInterface : public AppWindowCapturing::IAppWindowCaptureObserver
{
public:
    static WindowCaptureInterface* getInstance();
    WindowCaptureInterface(AppWindowCaptureImpl *captureImpl);
    ~WindowCaptureInterface();
    
    bool configApplicationWindowID(const char *windowID);
    bool configApplicationName(std::string sourceAppContentName);
    
    bool startAppWindowCapture();
    bool stopAppWindowCapture();
    
    void showShareIndicatorAndPrepareForAppShare();
    void stopShowShareIndicator();
    
    virtual void CapturedWindowClosed();
    virtual void CapturedWindwoMinimizedStated(bool minmized);

    uint8_t * loadSharingAppPauseImage();

    void createCaptureAppContentTimerThread();
    void resumeCaptureAppContentTimer(dispatch_source_t timer);
    void suspendCaptureAppContentTimer(dispatch_source_t timer);
    void cancelCaptureAppContentTimer(dispatch_source_t timer);
    
private:
    pthread_mutex_t _lock;
    std::vector<AppWindowCapturing::WDID>   _appWinVec;
    std::shared_ptr<AppWindowCapture>  _device;
    AppWindowCaptureImpl *          _appCaptureImpl;
    WINDOW_CAPTURE_CAPS_LEVEL       _capsLevel;
    std::string                     _sourceAppContentName;
    unsigned int                    _sourceAppContentWindowID;

private:
    MacShareAppStaticLibClass *_macShareAppLib;
    bool _isSharingApp;
};

#endif
