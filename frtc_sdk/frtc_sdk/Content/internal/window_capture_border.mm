#import <Cocoa/Cocoa.h>
#import "window_capture.h"
#include "window_rect_util.h"
#import "window_capture_border.h"
#import "DisplayBorderView.h"
#import "DisplayBorderWindow.h"

using namespace AppWindowCapturing;
#define HISTORY_LOCATION_LIST_LENGTH 5

CaptureBorderDisplay::CaptureBorderDisplay(unsigned int app_window)
                    :_display_Id(app_window),
                     _windowLocationList(NULL),
                     _green_border_window(nullptr),
                     _window_display(false)
{
    NSRect windowRect = NSMakeRect(0.0f, 0.0f, 1.0f, 1.0f);
    _green_border_window = [[DisplayBorderWindow alloc] initWithContentRect:windowRect
                                                     styleMask:0
                                                       backing:NSBackingStoreBuffered
                                                         defer:YES];
    
    [_green_border_window setBackgroundColor:[NSColor clearColor]];
    [_green_border_window setOpaque:NO];
    [_green_border_window setReleasedWhenClosed:NO];
}

CaptureBorderDisplay::~CaptureBorderDisplay()
{
    Display(false);
    _green_border_window = nil;
}


void CaptureBorderDisplay::ConfigWindowLocatiion(AppWindowDisplayLocation window_location)
{
    window_location.y = AppWindowCapture::CoordinateTransformation(window_location.y, window_location.height);
    
    int width_border = 5;
    
    window_location.x           = window_location.x - width_border;
    window_location.y           = window_location.y - width_border;
    window_location.width       += width_border * 2;
    window_location.height      += width_border * 2;
    
    NSRect windowFrame = NSMakeRect(window_location.x, window_location.y, window_location.width, window_location.height);
    NSRect orignalRect = [_green_border_window frame];

    if (NSEqualRects(windowFrame, orignalRect)) 
    {
        return;
    }
    
    [_green_border_window setFrame:windowFrame display:YES];
}

bool CaptureBorderDisplay::Display(bool display)
{
    if(display == ([_green_border_window isVisible] == YES))
    {
        return false;
    }
    
    if(display)
    {
        [_green_border_window makeKeyWindow];
    } else if (!display)
    {
        [_green_border_window orderOut:_green_border_window];
    }
    return true;
}

void CaptureBorderDisplay::UpdateWindowState(const RunningAppList& windows)
{
    CGWindowID _window_display_id = (CGWindowID)_display_Id;
    const AppWindowProperty* windowInfo = windows.APPWindowProperty(_window_display_id);
    if (windowInfo == NULL)
    {
        this->Display(false);
        return;
    }
    
    AppWindowCapturing::WDID borderWindowId = [_green_border_window windowNumber];
    
    AppWindowDisplayLocation window_location;
    window_location.x        = windowInfo->rect.x;
    window_location.y        = windowInfo->rect.y;
    window_location.width    = windowInfo->rect.width;
    window_location.height   = windowInfo->rect.height;
    
    _windowLocationList.push_back(window_location);

    
    if (_windowLocationList.size() > HISTORY_LOCATION_LIST_LENGTH)
    {
        _windowLocationList.pop_front();
    }
    
    bool is_dragging_window = false;
    
    for (std::list<AppWindowDisplayLocation>::const_iterator it = _windowLocationList.begin(); it != _windowLocationList.end(); it++)
    {
        is_dragging_window |= !((*it) == window_location);
    }
    
    if (is_dragging_window)
    {
        this->Display(false);
    } 
    else
    {
        ConfigWindowLocatiion(window_location);
        
        CGRect rect = CGRectMake(window_location.x, window_location.y, window_location.width, window_location.height);
        
        if (AppWindowRectUtil::IsFullScreenRect(rect))
        {
            return;
        }
        
        this->Display(true);
        
        bool isImmediatlyBelow = windows.IsOneWindowUnderAnother(_window_display_id, borderWindowId);
        
        if (!isImmediatlyBelow)
        {
            [_green_border_window orderWindow:NSWindowBelow relativeTo:_window_display_id];
        }
    }
}


void CaptureBorderDisplay::CheckGreenWindowDisplay(bool is_display) 
{
    if (_window_display == is_display) {
        return;
    } 
    else
    {
        _window_display = is_display;
        
        if (!is_display)
        {
            [_green_border_window orderOut:_green_border_window];
        }
    }
}
