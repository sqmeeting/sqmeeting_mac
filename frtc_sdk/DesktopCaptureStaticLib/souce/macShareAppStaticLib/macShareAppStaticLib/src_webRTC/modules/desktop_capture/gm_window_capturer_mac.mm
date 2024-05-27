//
//  gm_window_capturer_mac.mm
//  TestWebrtc
//
//  Created by yingyong.Mao on 2022/2/24.
//

#include "gm_window_capturer_mac.h"
namespace webrtc_mac_capturer {

//namespace {

// Returns true if the window exists.

//TODO: -modified by yingyong.Mao -2022-2-24
//bool IsWindowValid(CGWindowID id) {
bool IsWindowValidMac(CGWindowID id) {
    CFArrayRef window_id_array =
    CFArrayCreate(nullptr, reinterpret_cast<const void**>(&id), 1, nullptr);
    CFArrayRef window_array =
    CGWindowListCreateDescriptionFromArray(window_id_array);
    bool valid = window_array && CFArrayGetCount(window_array);
    
    //NSLog(@"window_id_array = %@, \n window_array = %@ \n", window_id_array, window_array);
    
    CFRelease(window_id_array);
    CFRelease(window_array);
    
    return valid;
}


GMWindowCapturerMac::GMWindowCapturerMac(rtc::scoped_refptr<FullScreenWindowDetector> full_screen_window_detector,
                                     rtc::scoped_refptr<DesktopConfigurationMonitor> configuration_monitor)
: full_screen_window_detector_(std::move(full_screen_window_detector)),
configuration_monitor_(std::move(configuration_monitor)),
window_finder_(configuration_monitor_) {}

GMWindowCapturerMac::~GMWindowCapturerMac() {}

bool GMWindowCapturerMac::GetSourceList(SourceList* sources) {
    return webrtc_mac_capturer::GetWindowList(sources, true, true);
}

bool GMWindowCapturerMac::SelectSource(SourceId id) {
    
    //TODO: -modified by yingyong.Mao -2022-2-24
    //if (!IsWindowValid(id)) return false;
    //window_id_ = id;
    
    if (!IsWindowValidMac((CGWindowID)id)) return false;
    window_id_ = (CGWindowID)id;
    return true;
}

bool GMWindowCapturerMac::FocusOnSelectedSource() {
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

bool GMWindowCapturerMac::IsOccluded(const DesktopVector& pos) {
    DesktopVector sys_pos = pos;
    if (configuration_monitor_) {
        auto configuration = configuration_monitor_->desktop_configuration();
        sys_pos = pos.add(configuration.bounds.top_left());
    }
    return window_finder_.GetWindowUnderPoint(sys_pos) != window_id_;
}

void GMWindowCapturerMac::Start(Callback* callback) {
    RTC_DCHECK(!callback_);
    RTC_DCHECK(callback);
    
    callback_ = callback;
}

void GMWindowCapturerMac::CaptureFrame() {
    TRACE_EVENT0("webrtc", "GMWindowCapturerMac::CaptureFrame");
    
    //TODO: -modified by yingyong.Mao -2022-2-24
    //if (!IsWindowValid(window_id_)) {
    if (!IsWindowValidMac((CGWindowID)window_id_)) {
        RTC_LOG(LS_ERROR) << "The window is not valid any longer.";
        callback_->OnCaptureResult(Result::ERROR_PERMANENT, nullptr);
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
                                                                       
                                                                       if (window_id != kNullWindowId) {
                                                                           sources->push_back(DesktopCapturer::Source{window_id, GetWindowTitle(window)});
                                                                       }
                                                                       return true;
                                                                   },
                                                                   true,
                                                                   false);
                                                               });
        
        //TODO: -modified by yingyong.Mao -2022-2-24
        
        //CGWindowID full_screen_window = full_screen_window_detector_->FindFullScreenWindow(window_id_);
        CGWindowID full_screen_window = (CGWindowID) full_screen_window_detector_->FindFullScreenWindow(window_id_);
        
        if (full_screen_window != kCGNullWindowID) on_screen_window = full_screen_window;
    }
    
    std::unique_ptr<DesktopFrame> frame = DesktopFrameCGImage::CreateForWindow(on_screen_window);
    if (!frame) {
        RTC_LOG(LS_WARNING) << "Temporarily failed to capture window.";
        callback_->OnCaptureResult(Result::ERROR_TEMPORARY, nullptr);
        return;
    }
    
    frame->mutable_updated_region()->SetRect(DesktopRect::MakeSize(frame->size()));
    frame->set_top_left(GetWindowBounds(on_screen_window).top_left());
    
    float scale_factor = GetWindowScaleFactor(window_id_, frame->size());
    frame->set_dpi(DesktopVector(kStandardDPI * scale_factor, kStandardDPI * scale_factor));
    
    callback_->OnCaptureResult(Result::SUCCESS, std::move(frame));
}


//}  // end of namespace

// static
//std::unique_ptr<DesktopCapturer> DesktopCapturer::CreateRawWindowCapturer(
std::unique_ptr<DesktopCapturer> DesktopCapturer::CreateRawWindowCapturer(const DesktopCaptureOptions& options) {
    return std::unique_ptr<DesktopCapturer>(new GMWindowCapturerMac(options.full_screen_window_detector(),
                                                                  options.configuration_monitor()));
}



}  // end of namespace webrtc
