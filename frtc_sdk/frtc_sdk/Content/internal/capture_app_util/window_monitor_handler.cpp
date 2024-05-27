#include "window_monitor_handler.h"
#include <algorithm>
#include <vector>
#include <map>

using namespace AppWindowCapturing;
using namespace std;

CaptureWindowStateObserver::CaptureWindowStateObserver()
                           :_window_closed_num(0),
                            _window_mimized_num(0),
                            _is_all_window_minmized(false),
                            _is_closed_all_window(false),
                            _window_minimized(false),
                            _window_closed(false)
{ 
}

void CaptureWindowStateObserver::WindowStandardState()
{
    _window_closed_num = 0;
    _window_mimized_num = 0;
  
    _is_all_window_minmized = false;
    if (_window_minimized != _is_all_window_minmized)
    {
        _window_minimized = _is_all_window_minmized;
        TriggerAllAPPWindowMinimized(_is_all_window_minmized);
    }
}

void CaptureWindowStateObserver::WindowMinmizedState()
{
    _window_closed_num = 0;
    _is_all_window_minmized    = true;
    
    if (_window_minimized != _is_all_window_minmized)
    {
        _window_minimized = _is_all_window_minmized;
        TriggerAllAPPWindowMinimized(_is_all_window_minmized);
    }
}

void CaptureWindowStateObserver::WindowClosedState() {
    ++_window_closed_num;
    
    if (_window_closed_num > 20)
    {
        _window_closed = true;
        TriggerAllAPPWindowClosed();
        _window_closed_num = 0;
    }
}

void CaptureWindowStateObserver::TriggerAllAPPWindowMinimized(bool is_minmized)
{
    for_each(_observers.begin(), _observers.end(),
             bind2nd(mem_fn(&AppWindowCapturing::IAppWindowCaptureObserver::CapturedWindwoMinimizedStated), is_minmized));
}

void CaptureWindowStateObserver::TriggerAllAPPWindowClosed()
{
    if (_is_closed_all_window)
    {
        return;
    }
    
    for_each(_observers.begin(), _observers.end(), mem_fn(&IAppWindowCaptureObserver::CapturedWindowClosed));
    
    _is_closed_all_window = true;
}

void CaptureWindowStateObserver::AddObserver(IAppWindowCaptureObserver *observer)
{
    _observers.push_back(observer);
}

void CaptureWindowStateObserver::RemoveObserver(IAppWindowCaptureObserver *observer)
{
    (void)std::remove(_observers.begin(), _observers.end(), observer);
}

