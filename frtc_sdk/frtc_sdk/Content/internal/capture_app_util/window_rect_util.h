#ifndef window_rect_util_hpp
#define window_rect_util_hpp

#import <Cocoa/Cocoa.h>
#include "AppWindowCapturing.h"

class AppWindowRectUtil
{
public:
    static bool IsFullScreenRect(const CGRect &rect);
    static bool WindowRectByScreenCutting(CGRect rect, std::vector<CGRect> &rect_array);
};

#endif
