//
//  app_window_capturer_mac.cpp
//  TestWebrtc
//
//  Created by yingyong.Mao on 2022/3/1.
//

#include "app_window_capturer_mac.hpp"

namespace webrtc_mac_capturer {


std::unique_ptr<DesktopCapturer> DesktopCapturer::CreateRawWindowCapturer(const DesktopCaptureOptions& options) {
    
    return std::unique_ptr<DesktopCapturer>(new WindowCapturerMac(options.full_screen_window_detector(),
                                                                  options.configuration_monitor()));
}


WindowCapturerMac::WindowCapturerMac(rtc::scoped_refptr<FullScreenWindowDetector> full_screen_window_detector,
                                     rtc::scoped_refptr<DesktopConfigurationMonitor> configuration_monitor)
: full_screen_window_detector_(std::move(full_screen_window_detector)),
configuration_monitor_(std::move(configuration_monitor)),
window_finder_(configuration_monitor_) {
    
    //NSLog(@"[WindowCapturerMac] : WindowCapturerMac Enter");
    start_flag_ = false;
    NSLog(@"[WindowCapturerMac] : WindowCapturerMac: by default, set start_flag_[%p] = false", &start_flag_);

    //NSLog(@"[WindowCapturerMac] : WindowCapturerMac Leave");
}

WindowCapturerMac::~WindowCapturerMac() {
    NSLog(@"[WindowCapturerMac] : ~WindowCapturerMac Enter");

    if (nullptr != full_screen_window_detector_) {
        full_screen_window_detector_.release();
    }
//    if (nullptr != configuration_monitor_) {
//        configuration_monitor_
//    }
//    if (nullptr != window_finder_) {
//        window_finder_
//    }
    
    NSLog(@"[WindowCapturerMac] : ~WindowCapturerMac Leave");
}

void WindowCapturerMac::Start(Callback* callback) {
    if (start_flag_) {
        NSLog(@"[WindowCapturerMac] StartCapture: start_flag_[%p] = true, Capture already been running...", &start_flag_);
        
        RTC_LOG(WARNING) << "Capture already been running...";
        return;
    }
    start_flag_ = true;
    NSLog(@"[WindowCapturerMac] StartCapture: set start_flag_ = true");
    
    RTC_DCHECK(!callback_);
    RTC_DCHECK(callback);
    callback_ = callback;
}

void WindowCapturerMac::StopCapture() {
    NSLog(@"[WindowCapturerMac] : StopCapture Enter");
    start_flag_ = false;
    NSLog(@"[WindowCapturerMac] StopCapture: start_flag_[%p] = false, then stop share", &start_flag_);

//    if (NULL != ) {
//        delete ;
//         = NULL;
//    }
//    callback_ = nullptr;
    
    NSLog(@"[WindowCapturerMac] : StopCapture Leave");
}

void WindowCapturerMac::CaptureFrame() {
    TRACE_EVENT0("webrtc", "WindowCapturerMac::CaptureFrame");
    
    if (true != start_flag_) {
        NSLog(@"[WindowCapturerMac] CaptureFrame: start_flag_[%p] = false, means stop share, so return.", &start_flag_);
        return;
    }
    
    //NSLog(@"[WindowCapturerMac] CaptureFrame: start_flag_[%p] = true, is sharing.", &start_flag_);

    //TODO: -modified by yingyong.Mao -2022-2-24
    //if (!IsWindowValid(window_id_)) {
    if (!IsWindowValid((CGWindowID)window_id_)) {
        RTC_LOG(LS_ERROR) << "The window is not valid any longer.";
        //TODO: -yingyong.Mao -2022-3-22
        if (NULL != callback_) {
            callback_->OnCaptureResult(Result::ERROR_PERMANENT, nullptr);
        }
        return;
    }
    
    CGWindowID on_screen_window = window_id_;
    
    if (full_screen_window_detector_) {
        full_screen_window_detector_->UpdateWindowListIfNeeded(window_id_, [](DesktopCapturer::SourceList* sources) {
                                                                   
                                                                   // Not using webrtc_mac_capturer::GetWindowList(sources, true, false)
                                                                   // as it doesn't allow to have in the result window with
                                                                   // empty title along with titled window owned by the same pid.
                                                                   return webrtc_mac_capturer::GetWindowList([sources](CFDictionaryRef window) {
                                                                       
                                                                       WindowId window_id = GetWindowId(window);
                                                                       
                                                                       //if (window_id != kNullWindowId) {
                                                                           //sources->push_back(DesktopCapturer::Source{window_id, GetWindowTitle(window)});
                                                                       //}
                                                                       
                                                                       if (window_id != kNullWindowId) {
                                                                           //[Note]: WPS's window title maybe is empty, for fullscreen-detect, add those titles as WPS's ProcessName.
                                                                           std::string window_title = GetWindowTitle(window);
                                                                           const std::string owner_name = GetWindowOwnerName((CGWindowID)window_id);
                                                                           if (window_title.empty() && !(owner_name.empty()) && 0 == owner_name.compare("WPS Office")) {
                                                                               window_title = owner_name;
                                                                           }
                                                                           
                                                                           //NSLog(@"[%s][%d]: --- --- window_id: %ld, window_title: %s", __func__, __LINE__, window_id, window_title.c_str());
                                                                           sources->push_back(DesktopCapturer::Source{window_id, window_title});
                                                                       }
                                                                       
                                                                       return true;
                                                                   },
                                                                   true,
                                                                   false);
                                                               });
                
        //CGWindowID full_screen_window = full_screen_window_detector_->FindFullScreenWindow(window_id_);
        CGWindowID full_screen_window = (CGWindowID)full_screen_window_detector_->FindFullScreenWindow(window_id_);

        if (full_screen_window != kCGNullWindowID) {
            //NSLog(@"[%s] has a new full screen window: on_screen_window = full_screen_window: %d", __func__, full_screen_window);
            on_screen_window = full_screen_window;
        }
    }
    
    std::unique_ptr<DesktopFrame> frame = DesktopFrameCGImage::CreateForWindow(on_screen_window);
    if (!frame) {
        RTC_LOG(LS_WARNING) << "Temporarily failed to capture window.";
        //TODO: -yingyong.Mao -2022-3-22
        if (NULL != callback_) {
            callback_->OnCaptureResult(Result::ERROR_TEMPORARY, nullptr);
        }
        return;
    }
    
    frame->mutable_updated_region()->SetRect(DesktopRect::MakeSize(frame->size()));
    frame->set_top_left(GetWindowBounds(on_screen_window).top_left());
    
    float scale_factor = GetWindowScaleFactor(window_id_, frame->size());
    frame->set_dpi(DesktopVector(kStandardDPI * scale_factor, kStandardDPI * scale_factor));
    
    //TODO: -yingyong.Mao -2022-3-22
    if (start_flag_ && NULL != callback_) {
        //if (nullptr != callback_->OnCaptureResult) {
        
        
//            NSLog(@"[UseAppWindowCapturerMac]: [OnCaptureResult]: capture frame: [%d, %d] -> target i420: [%d, %d, %d]", width, height, target_width, target_height, target_framerate);

            callback_->OnCaptureResult(Result::SUCCESS, std::move(frame));
        //}
    }
}

bool WindowCapturerMac::GetSourceList(SourceList* sources) {
    return webrtc_mac_capturer::GetWindowList(sources, true, true);
}

bool WindowCapturerMac::SelectSource(SourceId id) {
    
    //TODO: -modified by yingyong.Mao -2022-2-24
    //if (!IsWindowValid(id)) return false;
    //window_id_ = id;
    
    if (!IsWindowValid((CGWindowID)id)) return false;
    window_id_ = (CGWindowID)id;
    return true;
}

bool WindowCapturerMac::FocusOnSelectedSource() {
    if (!window_id_)
        return false;
    
    CGWindowID ids[1];
    ids[0] = window_id_;
    CFArrayRef window_id_array =
    CFArrayCreate(nullptr, reinterpret_cast<const void**>(&ids), 1, nullptr);
    
    CFArrayRef window_array =
    CGWindowListCreateDescriptionFromArray(window_id_array);
    if (!window_array || 0 == CFArrayGetCount(window_array)) {
        // Could not find the window. It might have been closed.
        RTC_LOG(LS_INFO) << "Window not found";
        CFRelease(window_id_array);
        return false;
    }
    
    CFDictionaryRef window = reinterpret_cast<CFDictionaryRef>(CFArrayGetValueAtIndex(window_array, 0));
    CFNumberRef pid_ref = reinterpret_cast<CFNumberRef>(CFDictionaryGetValue(window, kCGWindowOwnerPID));
    
    int pid;
    CFNumberGetValue(pid_ref, kCFNumberIntType, &pid);
    
    // TODO(jiayl): this will bring the process main window to the front. We
    // should find a way to bring only the window to the front.
    bool result = [[NSRunningApplication runningApplicationWithProcessIdentifier: pid]
                   activateWithOptions: NSApplicationActivateIgnoringOtherApps];
    
    CFRelease(window_id_array);
    CFRelease(window_array);
    return result;
}

bool WindowCapturerMac::IsOccluded(const DesktopVector& pos) {
    DesktopVector sys_pos = pos;
    if (configuration_monitor_) {
        auto configuration = configuration_monitor_->desktop_configuration();
        sys_pos = pos.add(configuration.bounds.top_left());
    }
    return window_finder_.GetWindowUnderPoint(sys_pos) != window_id_;
}



}  // end of namespace webrtc_mac_capturer
