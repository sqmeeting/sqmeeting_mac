#include <string>
#include <deque>
#include "AppWindowCapturing.h"

namespace ShareAPP {

struct ApplicationWindowInfo {
    std::wstring _title;
    std::wstring processName;
    
    AppWindowCapturing::WDID _windowId;
    
    long _processId;
    bool _isShareable;
};

struct MonitorDeviceInfo {
    std::string _displayName;
    std::string _deviceName;
    unsigned int _index;
};

typedef std::deque<ApplicationWindowInfo> ApplicationQueue;
typedef std::deque<ApplicationWindowInfo>::iterator ApplicationIter;
typedef std::deque<MonitorDeviceInfo> MonitorQueue;
typedef std::deque<MonitorDeviceInfo>::iterator MonitorIter;

class SystemUtilMac {
public:
    static ApplicationQueue MacGetAppLicationList();
    static std::string MacGetCachesDirectory();
    static std::string MacGetApplicationSupportDirectory();
    static std::string MacGetApplicationName();
    static std::string MacGetApplicationDocumentDirectory();

private:
    SystemUtilMac() {}
    ~SystemUtilMac() {}
};
}
