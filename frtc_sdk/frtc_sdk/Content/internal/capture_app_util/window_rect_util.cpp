#include "window_rect_util.h"

bool AppWindowRectUtil::IsFullScreenRect(const CGRect &rect)
{
    std::vector<CGDirectDisplayID> display_array(MAXINUM_DISPLAY_COUNT);
    uint32_t display_count = 0;
    
    CGError error_status = CGGetActiveDisplayList(MAXINUM_DISPLAY_COUNT, &display_array[0], &display_count);
    
    if (error_status != kCGErrorSuccess)
    {
        return false;
    }
    
    for (int i = 0; i < display_count; i++)
    {
        CGRect window_rect = CGDisplayBounds(display_array[i]);
        
        if(CGRectEqualToRect(rect, window_rect))
        {
            return true;
        }
    }
    
    return false;
}

bool AppWindowRectUtil::WindowRectByScreenCutting(CGRect rect, std::vector<CGRect> &rect_array)
{
    std::vector<CGDirectDisplayID> display_array(MAXINUM_DISPLAY_COUNT);
    
    uint32_t display_count = 0;
    CGError error_status = CGGetActiveDisplayList(MAXINUM_DISPLAY_COUNT, &display_array[0], &display_count);
    
    if (error_status != kCGErrorSuccess)
    {
        return false;
    }
    
    for (int i = 0; i < display_count; i++)
    {
        CGRect screen_rect      = CGDisplayBounds(display_array[i]);
        CGRect internal_rect    = CGRectIntersection(screen_rect, rect);
        
        if (CGRectIsEmpty(internal_rect))
        {
            continue;
        }
        
        rect_array.push_back(internal_rect);
    }
    
    return true;
}
