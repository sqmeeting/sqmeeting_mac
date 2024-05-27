#include <list>
#import "DisplayBorderWindow.h"

struct AppWindowDisplayLocation {
    int x;
    int y;
    int width;
    int height;
    
    bool operator==(const AppWindowDisplayLocation& rhs) const
    {
        return x == rhs.x && y == rhs.y && width == rhs.width && height == rhs.height;
    }
};

class RunningAppList;

class CaptureBorderDisplay {
public:
    CaptureBorderDisplay(unsigned int app_window);
    ~CaptureBorderDisplay();
    void UpdateWindowState(const RunningAppList &windowListUtil);
    void CheckGreenWindowDisplay(bool is_display);
private:
    void ConfigWindowLocatiion(AppWindowDisplayLocation window_location);
    bool Display(bool display);
    
private:
    unsigned int _display_Id;
    std::list<AppWindowDisplayLocation> _windowLocationList;
    DisplayBorderWindow *_green_border_window;
    bool _window_display;
};
