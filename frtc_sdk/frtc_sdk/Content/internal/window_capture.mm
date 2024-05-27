#include <algorithm>
#include <string>
#include <wchar.h>
#include <iostream>
#import <Cocoa/Cocoa.h>
#include <CoreFoundation/CoreFoundation.h>
#include <ApplicationServices/ApplicationServices.h>
#include "window_capture_border.h"
#include "window_capture.h"
#include "window_rect_util.h"
#include "window_monitor_handler.h"

using namespace AppWindowCapturing;

using namespace std;

void AppWindowCapture::StartShowShareIndicator() 
{
    if (nullptr != _share_app_green_border_window_timer)
    {
        return;
    } 
    else
    {
        CreateShareIndicatorForShareAppContentTimerThread();
    }
}

void AppWindowCapture::StopShowShareIndicator() 
{
    std::lock_guard<std::mutex> timerLock(_mutex);
    _stop_timer_thread = true;
    
    if (nullptr != _share_app_green_border_window_timer) 
    {
        CancelShareIndicatorForShareAppContentTimer(_share_app_green_border_window_timer);
    }
    
    _share_app_green_border_window_timer = nullptr;
    
    if (nullptr != _display_green_window)
    {
        delete _display_green_window;
        _display_green_window = nullptr;
    }
}


void AppWindowCapture::CancelShareIndicatorForShareAppContentTimer(dispatch_source_t timer)
{
    if (nullptr != timer) 
    {
        dispatch_source_cancel(timer);
    }
    
    timer = nullptr;
}

void AppWindowCapture::CreateShareIndicatorForShareAppContentTimerThread() 
{
    if (nullptr == _display_green_window)
    {
        CGWindowID windowID = _captured_window_id; ;
        _display_green_window = new CaptureBorderDisplay(windowID);
       
    }
  
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _share_app_green_border_window_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    NSTimeInterval timeIntervalInMicroSecond = 30;
  
    dispatch_source_set_timer(_share_app_green_border_window_timer, dispatch_walltime(NULL, 0), timeIntervalInMicroSecond * NSEC_PER_MSEC, 0 * NSEC_PER_SEC);
    
    std::weak_ptr<AppWindowCapture> weakSelf(shared_from_this());
    
    dispatch_source_set_event_handler(_share_app_green_border_window_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            std::shared_ptr<AppWindowCapture> sp(weakSelf.lock());
            if (!sp) 
            {
                return;
            }
            
            std::lock_guard<std::mutex> timerLock(_mutex);
            
            if (!_stop_timer_thread)
            {
                WindowListFromStandby();
                GreenBorderWindow();
            }
        });
    });
    
    dispatch_resume(_share_app_green_border_window_timer);
}

AppWindowCapture::AppWindowCapture(std::vector<WDID> app_window_vector)
                :_stop_timer_thread(false),
                 _share_app_green_border_window_timer(nullptr),
                 _display_green_window(nullptr)
{
    _state_observer._window_closed    = false;
    _state_observer._window_minimized = false;
    _state_observer._is_closed_all_window = false;
    
    for (std::vector<WDID>::const_iterator window_it = app_window_vector.begin(); window_it != app_window_vector.end(); window_it++)
    {
        _captured_window_id = (uint32_t)(*window_it);
    }
    
    RunningAppList util;
    util.GetRunningAPPBasicInfo();
    
    for (std::vector<WDID>::const_iterator window_it = app_window_vector.begin(); window_it != app_window_vector.end(); ++window_it)
    {
        const AppWindowProperty *app_window_property = util.APPWindowProperty(*window_it);
        
        if (NULL != app_window_property)
        {
            _standby_app_windows_list.push_back(*app_window_property);
        }
    }
}

AppWindowCapture::~AppWindowCapture() 
{
}

void AppWindowCapture::GreenBorderWindow()
{
    @autoreleasepool {
        if (_state_observer._window_closed || _state_observer._window_minimized)
        {
            _display_green_window->CheckGreenWindowDisplay(false);
            return;
        } 
        else
        {
            _display_green_window->CheckGreenWindowDisplay(true);
        }
        
        RunningAppList util;
        util.GetRunningAPPBasicInfo();
        
        if (nullptr != _display_green_window)
        {
            _display_green_window->UpdateWindowState(util);
        }
    }
}


void AppWindowCapture::WindowListFromStandby()
{
    _running_app_List.GetRunningAPPBasicInfo();
    std::set<long> window_process_id_set;
    
    long app_process_id = 0;
    
    for (std::vector<AppWindowProperty>::const_iterator it = _standby_app_windows_list.begin(); it != _standby_app_windows_list.end(); it++)
    {
        app_process_id = it->app_process_Id;
        window_process_id_set.insert(it->app_process_Id);
    }
    
    std::vector<AppWindowProperty> window_property_vector;
    _running_app_List.GetAllAppWindowVector(window_property_vector);
    
    BaseMutex lock(_mutex_t);
    _display_green_window_list.clear();
    _app_window_list.clear();
    
    std::vector<CGRect> window_rect_vector;
  
    
    bool capturing_app_window_closed = true;
    for (std::vector<AppWindowProperty>::const_iterator it = window_property_vector.begin(); it != window_property_vector.end(); it++)
    {
        int window_id = it->app_window_Id;
        int capturing_app_windowid = _captured_window_id;
        if (window_id > 0 &&
            _captured_window_id > 0 &&
            window_id == capturing_app_windowid)
        {
            capturing_app_window_closed = false;
            break;
        }
    }
    if (capturing_app_window_closed)
    {
        _state_observer.WindowClosedState();
        return;
    }
    
    for (std::vector<AppWindowProperty>::const_iterator it = window_property_vector.begin(); it != window_property_vector.end(); it++)
    {
        int window_id = it->app_window_Id;
        int capturing_app_window_id = _captured_window_id;
        if (window_id > 0 &&
            _captured_window_id > 0 &&
            window_id == capturing_app_window_id)
        {
            if (!it->window_on_desktop &&
                !isPowerPointPlayMode((const AppWindowProperty *)&(*it)))
            {
                _state_observer.WindowMinmizedState();
                return;
            }
        }
    }
    
    std::vector<AppWindowProperty> window_property_capturing_process;
    for (std::vector<AppWindowProperty>::const_iterator it = window_property_vector.begin(); it != window_property_vector.end(); it++)
    {
        if (app_process_id == it->app_process_Id && false == it->app_window_name.empty())
        {
            window_property_capturing_process.push_back(*it);
        }
    }
    
    
    window_property_vector.clear();
    window_property_vector = window_property_capturing_process;
    
    bool capture_window_not_closed = false;
    for (std::vector<AppWindowProperty>::const_iterator it = window_property_vector.begin(); it != window_property_vector.end(); it++)
    {
        if (find(_app_window_list.begin(), _app_window_list.end(), *it) != _app_window_list.end()) 
        {
            continue;
        }
        
       
        if (window_process_id_set.find(it->app_process_Id) == window_process_id_set.end() &&
            !FoundStandbyAppWindow(it->app_window_Id) &&
            !FoundStandbyAppWindow(it->app_parent_Id) &&
            !isPowerPointPlayMode((const AppWindowProperty *)&(*it)))
        {
            continue;
        }
        
        capture_window_not_closed = true;
        
        if (!it->window_on_desktop)
        {
            continue;
        }
        
        CGRect rect = CGRectMake(it->rect.x, it->rect.y, it->rect.width, it->rect.height);
        
        std::vector<CGRect> app_splite_window_rect_vector;
        if (AppWindowRectUtil::WindowRectByScreenCutting(rect, app_splite_window_rect_vector)) 
        {
            if (IsOverlapedAllWindows(window_rect_vector, app_splite_window_rect_vector)) 
            {
                continue;
            }
        }
        
        window_rect_vector.push_back(rect);
        _app_window_list.push_back(*it);
        
        if (it->app_parent_Id == 0)
        {
            _display_green_window_list.push_back(it->app_window_Id);
        }
    }
    
    if (!capture_window_not_closed && (_app_window_list.size() == 0))
    {
        _state_observer.WindowClosedState();
    }
    else if (_app_window_list.size() == 0)
    {
        _state_observer.WindowMinmizedState();
    } 
    else
    {
        _state_observer.WindowStandardState();
    }

    return;
}

bool AppWindowCapture::isPowerPointPlayMode(const AppWindowProperty *window_property)
{
    std::wstring powerpoint_window_name;
    
    for (std::vector<AppWindowProperty>::const_iterator it = _standby_app_windows_list.begin(); it != _standby_app_windows_list.end(); ++it)
    {
        std::wstring speciallowerProcessName = it->app_process_name;
        std::transform(speciallowerProcessName.begin(),
                       speciallowerProcessName.end(),
                       speciallowerProcessName.begin(),
                       static_cast<int (*)(int)>(std::tolower));
        
        if (L"microsoft powerpoint" == speciallowerProcessName) 
        {
            powerpoint_window_name = L"["+it->app_window_name+L"]";
        }
    }
    
    if (powerpoint_window_name == L"")
    {
        return false;
    }
    
    std::wstring lower_process_name = window_property->app_process_name;
    std::transform(lower_process_name.begin(), lower_process_name.end(), lower_process_name.begin(), static_cast<int (*)(int)>(std::tolower));
    
    if (window_property->rect.x == 0 && window_property->rect.y == 0)
    {
        if (lower_process_name == L"microsoft powerpoint") 
        {
            if (std::wstring::npos != window_property->app_window_name.find(powerpoint_window_name))
            {
                return true;
            }
        }
    }
    
    return false;
}

bool AppWindowCapture::FoundStandbyAppWindow(AppWindowCapturing::WDID window_id)
{
    for (std::vector<AppWindowProperty>::const_iterator it = _standby_app_windows_list.begin(); it != _standby_app_windows_list.end(); ++it)
    {
        if(window_id == it->app_window_Id)
        {
            return true;
        }
    }
    
    return false;
}

int AppWindowCapture::CoordinateTransformation(int y, int window_height) 
{
    CGRect display_rect = CGDisplayBounds(CGMainDisplayID());

    return  display_rect.size.height - y - window_height;
}

bool AppWindowCapture::IsOverlapedAllWindows(const std::vector<CGRect> &top_rects, const std::vector<CGRect> normal_rects)
{
    bool overlayed = true;
    for (std::vector<CGRect>::const_iterator rect_iterator = normal_rects.begin(); rect_iterator != normal_rects.end(); rect_iterator++)
    {
        overlayed = overlayed && IsOverlaped(top_rects, *rect_iterator);
    }
    
    return overlayed;
}

bool AppWindowCapture::IsOverlaped(const std::vector<CGRect> &top_rects, CGRect rect)
{
    bool overlayed = false;
    
    for (std::vector<CGRect>::const_iterator rect_iterator = top_rects.begin(); rect_iterator != top_rects.end(); ++rect_iterator)
    {
        overlayed = overlayed || CGRectContainsRect(*rect_iterator, rect);
    }
    
    return overlayed;
}

void AppWindowCapture::AddObserver(IAppWindowCaptureObserver *observer)
{
    _state_observer.AddObserver(observer);
}


void AppWindowCapture::RemoveObserver(IAppWindowCaptureObserver *observer)
{
    _state_observer.RemoveObserver(observer);
}


