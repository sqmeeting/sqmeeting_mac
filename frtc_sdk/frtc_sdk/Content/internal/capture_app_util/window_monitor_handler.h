#ifndef window_monitor_handler_hpp
#define window_monitor_handler_hpp

#include "AppWindowCapturing.h"

class CaptureWindowStateObserver
{
public:
    CaptureWindowStateObserver();
    void AddObserver(AppWindowCapturing::IAppWindowCaptureObserver *observer);
    void RemoveObserver(AppWindowCapturing::IAppWindowCaptureObserver *observer);

    void WindowStandardState();
    void WindowMinmizedState();
    void WindowClosedState();
    
    bool _window_minimized;
    bool _window_closed;
    
private:
    void TriggerAllAPPWindowMinimized(bool is_minmized);
    void TriggerAllAPPWindowClosed();

public:
    int _window_closed_num;
    int _window_mimized_num;
    
    bool _is_all_window_minmized;
    bool _is_closed_all_window;

    std::vector<AppWindowCapturing::IAppWindowCaptureObserver *> _observers;
};
#endif
