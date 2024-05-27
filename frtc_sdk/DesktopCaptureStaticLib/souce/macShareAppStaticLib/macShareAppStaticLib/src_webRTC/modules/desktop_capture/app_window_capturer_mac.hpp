//
//  app_window_capturer_mac.hpp
//  TestWebrtc
//
//  Created by yingyong.Mao on 2022/3/1.
//

#ifndef app_window_capturer_mac_hpp
#define app_window_capturer_mac_hpp

#include <stdio.h>


#include <ApplicationServices/ApplicationServices.h>
#include <Cocoa/Cocoa.h>
#include <CoreFoundation/CoreFoundation.h>

#include <utility>

//#include "api/scoped_refptr.h"
#include "modules/desktop_capture/desktop_capture_options.h"
#include "modules/desktop_capture/desktop_capturer.h"
#include "modules/desktop_capture/desktop_frame.h"
#include "modules/desktop_capture/mac/desktop_configuration.h"
#include "modules/desktop_capture/mac/desktop_configuration_monitor.h"
#include "modules/desktop_capture/mac/desktop_frame_cgimage.h"
#include "modules/desktop_capture/mac/window_list_utils.h"
#include "modules/desktop_capture/window_finder_mac.h"
#include "rtc_base/checks.h"
#include "rtc_base/constructor_magic.h"
#include "rtc_base/logging.h"
#include "rtc_base/trace_event.h"

#include "api/video/video_frame.h" //for VideoFrame
#include "modules/desktop_capture/desktop_capture_options.h" //for DesktopCaptureOptions

#import <Foundation/Foundation.h>
#include <mach/mach_time.h> //for getCPUTime()

namespace webrtc_mac_capturer {

//namespace {

class WindowCapturerMac : public DesktopCapturer {
public:
    explicit WindowCapturerMac(rtc::scoped_refptr<FullScreenWindowDetector> full_screen_window_detector,
                               rtc::scoped_refptr<DesktopConfigurationMonitor> configuration_monitor);
    
    ~WindowCapturerMac() override;
    
    // DesktopCapturer interface.
    void Start(Callback* callback) override;
    void StopCapture();
    void CaptureFrame() override;
    bool GetSourceList(SourceList* sources) override;
    bool SelectSource(SourceId id) override;
    bool FocusOnSelectedSource() override;
    bool IsOccluded(const DesktopVector& pos) override;

    // Returns true if the window exists.
    bool IsWindowValid(CGWindowID id) {
        CFArrayRef window_id_array = CFArrayCreate(nullptr, reinterpret_cast<const void**>(&id), 1, nullptr);
        CFArrayRef window_array = CGWindowListCreateDescriptionFromArray(window_id_array);
        bool valid = window_array && CFArrayGetCount(window_array);
        CFRelease(window_id_array);
        CFRelease(window_array);
        return valid;
    }
    
    std::unique_ptr<DesktopCapturer> CreateRawWindowCapturer(const DesktopCaptureOptions& options);
    

    
private:
    //std::atomic_bool start_flag_;
    bool start_flag_;

    Callback* callback_ = nullptr;
    
    // The window being captured.
    CGWindowID window_id_ = 0;
    
    rtc::scoped_refptr<FullScreenWindowDetector> full_screen_window_detector_;
    
    const rtc::scoped_refptr<DesktopConfigurationMonitor> configuration_monitor_;
    
    WindowFinderMac window_finder_;
    
    RTC_DISALLOW_COPY_AND_ASSIGN(WindowCapturerMac);
};



//} //end of namespace

}  // end of namespace webrtc_mac_capturer

#endif /* app_window_capturer_mac_hpp */
