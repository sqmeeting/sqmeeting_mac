#include "running_app_list.h"
#include "string_util.h"

#include <algorithm>
#include <string>
#include <wchar.h>
#include <iostream>
#include <set>
#import <Cocoa/Cocoa.h>
#include <CoreFoundation/CoreFoundation.h>
#include <ApplicationServices/ApplicationServices.h>

using namespace AppWindowCapturing;
using namespace std;

bool RunningAppList::AnalysisRunningAppProperty(CFDictionaryRef app_window_info, AppWindowProperty& app_window_property)
{
    CGRect app_rect;
    CFDictionaryRef location = (CFDictionaryRef)CFDictionaryGetValue(app_window_info, kCGWindowBounds);
    CGRectMakeWithDictionaryRepresentation(location, &app_rect);
    
    CFStringRef app_process_name = (CFStringRef)CFDictionaryGetValue(app_window_info, kCGWindowOwnerName);
    std::wstring process_name_str = L"";
    if (app_process_name != NULL) 
    {
        process_name_str = SysCFStringRefToWide(app_process_name);
    }
    
    CFBooleanRef app_is_on_screen = (CFBooleanRef)CFDictionaryGetValue(app_window_info, kCGWindowIsOnscreen);

    bool on_screen_desktop = app_is_on_screen != 0 && CFBooleanGetValue(app_is_on_screen);
    
    CFNumberRef window_layer = (CFNumberRef)CFDictionaryGetValue(app_window_info, kCGWindowLayer);
    int app_window_layer = 0;
    CFNumberGetValue(window_layer, kCFNumberIntType, &app_window_layer);

    float window_alpha_value = 1.0;
    CFNumberRef window_alpha = (CFNumberRef)CFDictionaryGetValue(app_window_info, kCGWindowAlpha);
    if (window_alpha!= NULL)
    {
        CFNumberGetValue(window_alpha, kCFNumberFloatType, &window_alpha_value);
    }
    
    CFStringRef window_name = (CFStringRef)CFDictionaryGetValue(app_window_info, kCGWindowName);
    std::wstring app_window_name_str = L"";
    if (window_name != NULL) 
    {
        app_window_name_str = SysCFStringRefToWide(window_name);
    }
    
    CFNumberRef process_id_number = (CFNumberRef)CFDictionaryGetValue(app_window_info, kCGWindowOwnerPID);
    long app_window_process_Id = 0;
    CFNumberGetValue(process_id_number, kCFNumberIntType, &app_window_process_Id);
    
    CFNumberRef window_id_number = (CFNumberRef)CFDictionaryGetValue(app_window_info, kCGWindowNumber);
    long app_window_id = 0;
    CFNumberGetValue(window_id_number, kCGWindowIDCFNumberType, &app_window_id);
    
    AppWindowProperty window;
    window.app_window_name              = app_window_name_str;
    window.rect.x                       = app_rect.origin.x;
    window.rect.y                       = app_rect.origin.y;
    window.rect.width                   = app_rect.size.width;
    window.rect.height                  = app_rect.size.height;
    window.app_process_Id               = app_window_process_Id;
    window.app_process_name             = process_name_str;
    window.app_window_Id                = app_window_id;
    window.window_layer                 = app_window_layer;
    window.window_on_desktop            = on_screen_desktop;
    window.app_parent_Id                = kCGNullWindowID;
    window.window_layer_alpha_value     = window_alpha_value;
    
    app_window_property = window;
    
    return true;
}


bool RunningAppList::IfSkipAppProcess(const AppWindowProperty  &app_window_property)
{
    std::wstring app_process_name = app_window_property.app_process_name;
    std::transform(app_process_name.begin(), app_process_name.end(), app_process_name.begin(), static_cast<int (*)(int)>(std::tolower));
    return (app_process_name == L"finder"
            || app_process_name == L"dock"
            || app_process_name == L"window server"
            || app_process_name == L"systemuiserver"
            || app_process_name == L"loginwindo"
            || app_window_property.app_process_Id == getpid());
}

bool RunningAppList::IsAppOnFullScreen(const CGRect &rect)
{
    CGFloat height_window_menu = rect.origin.y;
    CGRect  basic_rect = CGRectMake(0, 0, rect.size.width, rect.size.height + height_window_menu);
    
    std::vector<CGDirectDisplayID> direct_display_id(MAXINUM_DISPLAY_COUNT);
    uint32_t direct_display_count = 0;
    
    CGError error = CGGetActiveDisplayList(MAXINUM_DISPLAY_COUNT, &direct_display_id[0], &direct_display_count);
    
    if (error != kCGErrorSuccess)
    {
        return false;
    }
    
    for (uint32_t i = 0; i < direct_display_count; i++) 
    {
        CGRect direct_display_rect = CGDisplayBounds(direct_display_id[i]);
        
        if (CGRectEqualToRect(basic_rect, direct_display_rect))
        {
            return true;
        }
    }
    
    return false;
}

bool RunningAppList::IfCouldSkipAppWindow(const AppWindowProperty& app_window)
{
    if (RunningAppList::IfSkipAppProcess(app_window))
    {
        return true;
    }
    
    const float clear_value = 0.001;
    if (app_window.window_layer_alpha_value < clear_value)
    {
        return true;
    }
    
    if (app_window.rect.width < 20 || app_window.rect.height < 20) 
    {
        return true;
    }
    
    std::wstring app_lower_process_name = app_window.app_process_name;
    std::transform(app_lower_process_name.begin(), app_lower_process_name.end(), app_lower_process_name.begin(), static_cast<int (*)(int)>(std::tolower));
    
    std::wstring app_lower_window_name = app_window.app_window_name;
    std::transform(app_lower_window_name.begin(), app_lower_window_name.end(), app_lower_window_name.begin(), static_cast<int (*)(int)>(std::tolower));
    
    if ((app_lower_window_name == L""
         || app_lower_window_name == L"microsoft excel"
         || app_lower_window_name == L"microsoft word")
        && (app_lower_process_name == L"microsoft word"
            || app_lower_process_name == L"microsoft excel")) 
    {
        
        return true;
    }
    
    return false;
}

bool RunningAppList::GetRunningAPPBasicInfo(bool display_on_desktop, bool select_app_window_hidden)
{
    _windows.clear();
    
    std::set<WDID> display_screen_window_ID;
    
    CFDealloc<CFArrayRef> runningAppsInfo(CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly | kCGWindowListExcludeDesktopElements, kCGNullWindowID));
    
    CFIndex count = CFArrayGetCount(runningAppsInfo);
    for (CFIndex i = 0; i < count; i++)
    {
        CFDictionaryRef appInfo = (const CFDictionaryRef)CFArrayGetValueAtIndex(runningAppsInfo, i);
        AppWindowProperty app_property;
        
        if (!RunningAppList::AnalysisRunningAppProperty(appInfo, app_property))
        {
            continue;
        }
        
        if (!select_app_window_hidden && RunningAppList::IfCouldSkipAppWindow(app_property))
        {
            continue;
        }
        
        display_screen_window_ID.insert(app_property.app_window_Id);
        this->_windows.push_back(app_property);
    }
    
    if (!display_on_desktop)
    {
        CFDealloc<CFArrayRef> allWindowsInfo(CGWindowListCopyWindowInfo(kCGWindowListOptionAll | kCGWindowListExcludeDesktopElements, kCGNullWindowID));
        
        count = CFArrayGetCount(allWindowsInfo);
        for (CFIndex i = 0; i < count; i++)
        {
            CFDictionaryRef windowInfo = (const CFDictionaryRef)CFArrayGetValueAtIndex(allWindowsInfo, i);
            AppWindowProperty window;
            if (!RunningAppList::AnalysisRunningAppProperty(windowInfo, window))
            {
                continue;
            }
            if (RunningAppList::IfCouldSkipAppWindow(window))
            {
                continue;
            }
            
            if (window.window_on_desktop)
            {
                continue;
            }
            
            if (display_screen_window_ID.find(window.app_window_Id) != display_screen_window_ID.end())
            {
                continue;
            }
            this->_windows.push_back(window);
        }
    }
    
    for (std::vector<AppWindowProperty>::iterator it = _windows.begin(); it != _windows.end(); it++)
    {
        for (std::vector<AppWindowProperty>::const_iterator itParent = it + 1; itParent != _windows.end(); itParent++) {

            if (it->app_process_Id != itParent->app_process_Id) 
            {
                continue;
            }
            
            if (it->window_layer != 0)
            {
                if (PointInWindow(itParent->rect, it->rect.x, it->rect.y))
                {
                    it->app_parent_Id = itParent->app_window_Id;
                    break;
                }
            }
            else 
            {
                if (std::abs((int)(itParent->rect.x + itParent->rect.x + itParent->rect.width - it->rect.x - it->rect.x - it->rect.width)) <= 5 &&
                    it->app_window_name == L"" && itParent->app_window_name != L"" &&
                    itParent->window_layer == 0 &&
                    itParent->rect.y <= it->rect.y) 
                {
                    it->app_parent_Id = itParent->app_window_Id;
                    break;
                }
            }
        }
    }
    
    return true;
}

void RunningAppList::GetUpperAppWindowVector(std::vector<AppWindowProperty> &upper_window_vector) const 
{
    upper_window_vector.clear();
    std::set<long> app_window_process_ids;
 
    for (std::vector<AppWindowProperty>::const_iterator it = _windows.begin(); it != _windows.end(); it++) 
    {
        if (it->window_layer == 0 && it->window_on_desktop) 
        {
            bool isAddedWindowId = false;
            
            for (std::vector<AppWindowProperty>::const_iterator it_windows = upper_window_vector.begin(); it_windows != upper_window_vector.end(); ++it_windows) 
            {
                if (it_windows->app_window_Id == it->app_window_Id)
                {
                    isAddedWindowId = true;
                }
            }
            
            if (false == isAddedWindowId)
            {
                app_window_process_ids.insert(it->app_process_Id);
                upper_window_vector.push_back(*it);
            }
        }
    }
    
    for (std::vector<AppWindowProperty>::const_iterator it = _windows.begin(); it != _windows.end(); it++) 
    {
        bool app_window_should_be_hidden = it->rect.x == 0 && it->rect.y == 0 && (it->rect.width < 50 || it->rect.width < 50);
        
        if (it->window_layer == 0 &&
            !it->window_on_desktop &&
            it->app_window_name != std::wstring(L"") &&
            !app_window_should_be_hidden)
        {
     
            bool isAddedWindowId = false;
            for (std::vector<AppWindowProperty>::const_iterator it_windows = upper_window_vector.begin(); it_windows != upper_window_vector.end(); ++it_windows)
            {
                if (it_windows->app_window_Id == it->app_window_Id) 
                {
                    isAddedWindowId = true;
                }
            }
            
            if (false == isAddedWindowId)
            {
                app_window_process_ids.insert(it->app_process_Id);
                upper_window_vector.push_back(*it);
            }
        }
    }
}

const AppWindowProperty* RunningAppList::APPWindowProperty(WDID app_window_id) const
{
    for (std::vector<AppWindowProperty>::const_iterator it = _windows.begin(); it != _windows.end(); it++) 
    {
        if (it->app_window_Id == app_window_id) 
        {
            return &(*it);
        }
    }
    
    return NULL;
}

bool RunningAppList::IsOneWindowUnderAnother(AppWindowCapturing::WDID app_window_id, AppWindowCapturing::WDID under_window_id) const
{
    int windowIndex = -1;
    for (size_t index = 0; index < _windows.size() - 1; index++) 
    {
        if (_windows[index].app_window_Id == app_window_id)
        {
            windowIndex = index;
            break;
        }
    }
    
    if (windowIndex == -1)
    {
        return false;
    }
    
    WDID actuallyBelowWindowId = _windows[windowIndex + 1].app_window_Id;
    
    return under_window_id == actuallyBelowWindowId;
}

void RunningAppList::GetAllAppWindowVector(std::vector<AppWindowProperty> &app_window_vector) const
{
    app_window_vector.clear();
    copy(_windows.begin(), _windows.end(), inserter(app_window_vector, app_window_vector.begin()));
}


