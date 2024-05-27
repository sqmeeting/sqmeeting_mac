#include "util_mac.h"
#include "window_capture.h"
#import <Foundation/Foundation.h>

namespace ShareAPP {

ApplicationQueue SystemUtilMac::MacGetAppLicationList() {
    ApplicationQueue queue;
    
    std::vector<AppWindowProperty> windowInfoList;
    RunningAppList runningList;
    if (runningList.GetRunningAPPBasicInfo()) {
        runningList.GetUpperAppWindowVector(windowInfoList);
    }
    
    if (windowInfoList.size() > 0) {
        std::vector<AppWindowProperty>::const_iterator iter = windowInfoList.begin();
        while (iter != windowInfoList.end()) {
            bool isFullScreen = false;
            CGRect cgRect = CGRectMake(iter->rect.x, iter->rect.y, iter->rect.width, iter->rect.height);
            isFullScreen = runningList.IsAppOnFullScreen(cgRect);
            
            if (!iter->window_on_desktop) {
                if (!isFullScreen ) {
                    iter++;
                    continue;
                }
            }
                        
            ApplicationWindowInfo info;
            info._windowId = iter->app_window_Id;
            info._isShareable = iter->window_on_desktop;
     
            info.processName = iter->app_process_name;
            info._processId  = iter->app_process_Id;
            info._title = iter->app_window_name.empty() ? iter->app_process_name : iter->app_window_name;
            
            queue.push_back(info);
            iter++;
        }
    }
    
    return queue;
}
    
std::string SystemUtilMac::MacGetCachesDirectory()
{
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                            NSUserDomainMask,
                                                            YES);
    return std::string([[pathList objectAtIndex:0] UTF8String]);
}
    
std::string SystemUtilMac::MacGetApplicationSupportDirectory()
{
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,
                                                            NSUserDomainMask,
                                                            YES);
    return std::string([[pathList objectAtIndex:0] UTF8String]);
}

std::string SystemUtilMac::MacGetApplicationDocumentDirectory()
{
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask,
                                                            YES);
    return std::string([[pathList objectAtIndex:0] UTF8String]);
}
    
std::string SystemUtilMac::MacGetApplicationName()
{
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
    if (nil == appName)
    {
        appName = [[NSProcessInfo processInfo] processName];
    }
    return std::string([appName UTF8String]);
}
    
}

