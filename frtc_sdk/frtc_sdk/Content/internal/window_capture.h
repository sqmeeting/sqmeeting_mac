#pragma once

#include <vector>
#include <set>
#include <pthread.h>
#import <Foundation/Foundation.h>
#import "AppWindowCapturing.h"
#include "running_app_list.h"
#include "window_monitor_handler.h"
#include <mutex>

class BaseMutex {
public:
    BaseMutex(pthread_mutex_t &mutex)
        : mutex(mutex) {
        pthread_mutex_lock(&mutex);
    }

    ~BaseMutex() {
        pthread_mutex_unlock(&mutex);
    }
private:
    pthread_mutex_t &mutex;
};

class AppWindowCapture : public std::enable_shared_from_this<AppWindowCapture>
{
public:
    AppWindowCapture(std::vector<AppWindowCapturing::WDID> app_window_vector);

    ~AppWindowCapture();

    void StartShowShareIndicator();
    void StopShowShareIndicator();
    void CreateShareIndicatorForShareAppContentTimerThread();
    void CancelShareIndicatorForShareAppContentTimer(dispatch_source_t timer);
    
    void WindowListFromStandby();

    void AddObserver(AppWindowCapturing::IAppWindowCaptureObserver *observer);
    void RemoveObserver(AppWindowCapturing::IAppWindowCaptureObserver *observer);
    static int CoordinateTransformation(int y, int window_height);

private:
    void GreenBorderWindow();
    bool isPowerPointPlayMode(const AppWindowProperty *window_property);
    bool FoundStandbyAppWindow(AppWindowCapturing::WDID window_id);

private:
    bool IsOverlaped(const std::vector<CGRect> &top_rects, CGRect rect);
    bool IsOverlapedAllWindows(const std::vector<CGRect> &top_rects, const std::vector<CGRect> normal_rects);

private:
    std::vector<AppWindowProperty> _app_window_list;
    std::vector<AppWindowProperty> _standby_app_windows_list;
    
    RunningAppList _running_app_List;
    
    std::mutex     _mutex;
    pthread_mutex_t _mutex_t;
    
    std::vector<AppWindowCapturing::WDID> _display_green_window_list;
    
    uint32_t         _captured_window_id;
    CaptureBorderDisplay * _display_green_window;
    
    bool _stop_timer_thread;

    CaptureWindowStateObserver _state_observer;

public:
    dispatch_source_t        _share_app_green_border_window_timer;
};
