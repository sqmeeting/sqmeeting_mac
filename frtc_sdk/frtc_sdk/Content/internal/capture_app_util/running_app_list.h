#ifndef running_app_list_hpp
#define running_app_list_hpp

#include "AppWindowCapturing.h"

typedef struct CF_BRIDGED_TYPE(id) CGContext *CGContextRef;
typedef struct CF_BRIDGED_TYPE(id) CGImage *CGImageRef;
typedef const struct  CF_BRIDGED_TYPE(id) __CFDictionary *CFDictionaryRef;

struct APPWindowRect 
{
    int x;
    int y;
    int width;
    int height;
};

inline bool PointInWindow(APPWindowRect rect, int x, int y)
{
    return (x > rect.x && x < rect.x + rect.width &&
            y > rect.y && y < rect.y + rect.height);
}

struct AppWindowProperty 
{
    std::wstring app_window_name;
    std::wstring app_process_name;
   
    long app_parent_Id;
    long app_window_Id;
    
    APPWindowRect rect;
    long app_process_Id;

    int window_layer;
    bool window_on_desktop;
    float window_layer_alpha_value;
};

template <typename T> class CFDealloc
{
public:
    CFDealloc(T object)
        : _object(object) {
    }

    operator T() {
        return _object;
    }

    ~CFDealloc() {
        if (_object != NULL) {
            CFRelease(_object);
        }
    }

private:
    T _object;
};

inline bool operator==(const AppWindowProperty &left, const AppWindowProperty &right) 
{
    return left.app_window_Id == right.app_window_Id;
}


class CaptureBorderDisplay;

class RunningAppList {
public:
    bool GetRunningAPPBasicInfo(bool display_on_desktop = false, bool excludeSelfAndTechHiddenWindow = false);
    
    const AppWindowProperty * APPWindowProperty(AppWindowCapturing::WDID app_window_id) const;
    bool IsOneWindowUnderAnother(AppWindowCapturing::WDID app_window_id, AppWindowCapturing::WDID under_window_id) const;
    
    void GetAllAppWindowVector(std::vector<AppWindowProperty> &app_window_vector) const;
    void GetUpperAppWindowVector(std::vector<AppWindowProperty> &upper_window_vector) const;
    
    static bool IfCouldSkipAppWindow(const AppWindowProperty &app_window);
    static bool IfSkipAppProcess(const AppWindowProperty  &app_window_property);
    static bool IsAppOnFullScreen(const CGRect &rect);
    
private:
    bool AnalysisRunningAppProperty(CFDictionaryRef app_window_info, AppWindowProperty& app);

private:
    std::vector<AppWindowProperty> _windows;
};

#endif /* running_app_list_hpp */
