//
//  gm_window_capturer_mac.hpp
//  TestWebrtc
//
//  Created by yingyong.Mao on 2022/2/24.
//

#ifndef gm_window_capturer_mac_h
#define gm_window_capturer_mac_h

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




class GMWindowCapturerMac : public DesktopCapturer, public DesktopCapturer::Callback {
public:
    explicit GMWindowCapturerMac(rtc::scoped_refptr<FullScreenWindowDetector> full_screen_window_detector,
                               rtc::scoped_refptr<DesktopConfigurationMonitor> configuration_monitor);
    
    ~GMWindowCapturerMac() override;
    
    // DesktopCapturer interface.
    void Start(Callback* callback) override;
    void CaptureFrame() override;
    bool GetSourceList(SourceList* sources) override;
    bool SelectSource(SourceId id) override;
    bool FocusOnSelectedSource() override;
    bool IsOccluded(const DesktopVector& pos) override;
    
private:
    //TODO: for test -yingyong -2022-2-28
public:
    int fps_ = 30;
    std::unique_ptr<GMWindowCapturerMac> winCapture_;
    dispatch_source_t        _captureAppContentTimer;         //[for share App content]: capture App Window.
    
    
public:
    static GMWindowCapturerMac* Create() {
        //2.[mac] Window captuer
        DesktopCaptureOptions options = webrtc_mac_capturer::DesktopCaptureOptions::CreateDefault();
        
        //        std::unique_ptr<GMWindowCapturerMac> winCapture(new GMWindowCapturerMac(options.full_screen_window_detector(),
        //                                                                            options.configuration_monitor()));
        
        GMWindowCapturerMac* winCapture = new GMWindowCapturerMac(options.full_screen_window_detector(),
                                                              options.configuration_monitor());
        
        webrtc_mac_capturer::DesktopCapturer::SourceList appWindowSourceList;
        winCapture->GetSourceList(&appWindowSourceList);
        //    winCapture->SelectSource(appWindowSourceList->front().id);
        
        for (int i = 0; i < appWindowSourceList.size(); ++i) {
            std::string title = (appWindowSourceList[i].title);
            NSLog(@"appWindowSourceList[i].title : %s", title.c_str() );
            
            if (title == "QQ影音") {
                NSLog(@"SelectSource: appWindowSourceList[i].id : %s", title.c_str() );
                NSLog(@"appWindowSourceList[i].id : %s", title.c_str() );
                
                winCapture->SelectSource(appWindowSourceList[i].id);
                break;
            }
        }
        
        winCapture->FocusOnSelectedSource();
        
        /*
         winCapture->Start(this);
         
         while (1) {
         //usleep(10);
         winCapture->CaptureFrame();
         }
         */
        
        return winCapture;
    }
    
    void StartCapture() {
        
        //        webrtc_mac_capturer::DesktopCapturer::SourceList appWindowSourceList;
        //        this->GetSourceList(&appWindowSourceList);
        //
        //        //this->SelectSource(appWindowSourceList.front().id);
        //
        //        NSLog(@"[GMWindowCapturerMac]: appWindowSourceList[0].id : %ld", appWindowSourceList[3].id);
        //        this->SelectSource(appWindowSourceList[3].id);
        //
        //        this->FocusOnSelectedSource();
        
        this->Start(this);
        
        
        
        
        
        
        //                while (1) {
        //                    //usleep(10);
        //                    this->CaptureFrame();
        //                }
        
        __block GMWindowCapturerMac* weak_appWindowCapture = this;
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        weak_appWindowCapture->_captureAppContentTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        NSTimeInterval timeIntervalInMicroSecond = 1000 / weak_appWindowCapture->fps_;
        
        NSLog(@"[Thread Running] capture: [adaptor->captureAppContent]: adaptor->_capability.framerate = %d", weak_appWindowCapture->fps_);
        
        NSTimeInterval delayTime = 1.0f;
        dispatch_source_set_timer(weak_appWindowCapture->_captureAppContentTimer, dispatch_walltime(NULL, 0), timeIntervalInMicroSecond * NSEC_PER_MSEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(weak_appWindowCapture->_captureAppContentTimer, ^{
            
            NSLog(@"[Thread Running] capture:  call captureAppContent() ");
            
            static uint64_t startCaptureTime = 0 ;
            static uint64_t captureTime = 0;
            static uint64_t lastEndCaptureLoopTime = 0;
            static uint64_t lastCaptureLoopTime = 0;
            
            lastCaptureLoopTime = getCPUTime() - lastEndCaptureLoopTime;
            NSLog(@"[Thread Running] capture: [adaptor->captureAppContent]: lastCaptureLoopTime = %llu", lastCaptureLoopTime);
            
            startCaptureTime = getCPUTime();
            weak_appWindowCapture->CaptureFrame();
            
            captureTime = getCPUTime() - startCaptureTime;
            NSLog(@"[Thread Running] capture: [adaptor->captureAppContent]: captureContentTime = %llu", captureTime);
            
            lastEndCaptureLoopTime = getCPUTime();
            
        });
        dispatch_resume(weak_appWindowCapture->_captureAppContentTimer);
    }
    
    uint64_t getCPUTimeInMicroseconds() {
        uint64_t time = mach_absolute_time();
        static mach_timebase_info_data_t kTimebaseInfo;
        
        if (kTimebaseInfo.denom == 0)
        {
            mach_timebase_info(&kTimebaseInfo);
        }
        
        long double ret = 1.l * time / 1000 * kTimebaseInfo.numer / kTimebaseInfo.denom;
        return ret;
    }
    
    uint64_t getCPUTime() {
        return getCPUTimeInMicroseconds() / 1000;
    }
    
    /*
     uint64_t getCPUTimeInMicroseconds() {
     uint64_t time = mach_absolute_time();
     static mach_timebase_info_data_t kTimebaseInfo;
     
     if (kTimebaseInfo.denom == 0) {
     mach_timebase_info(&kTimebaseInfo);
     }
     
     long double ret = 1.l * time / 1000 * kTimebaseInfo.numer / kTimebaseInfo.denom;
     return ret;
     }
     
     uint64_t getCPUTime() {
     return getCPUTimeInMicroseconds() / 1000;
     }
     
     static void createCaptureAppContentTimerThread() {
     
     dispatch_source_t        _captureAppContentTimer;         //[for share App content]: capture App Window.
     
     
     std::unique_ptr<GMWindowCapturerMac> appWindowCapture = GMWindowCapturerMac::Create();
     appWindowCapture->StartCapture();
     
     //        auto appWindowCapture = GMWindowCapturerMac::Create();
     //        appWindowCapture->StartCapture();
     
     
     //__block GMWindowCapturerMac* _weak_self = winCapture;
     //__block GMWindowCapturerMac* _weak_self = appWindowCapture;
     
     static int plus = 0;
     //static dispatch_source_t _timer = nil;
     //_weak_self->_captureAppContentTimer = nullptr;
     _captureAppContentTimer = nullptr;
     
     dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     
     //this->_captureAppContentTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
     _captureAppContentTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
     //NSTimeInterval timeIntervalInMicroSecond = 1000 / _weak_self->fps_;
     NSTimeInterval timeIntervalInMicroSecond = 1000 / appWindowCapture->fps_;
     
     NSLog(@"[Thread Running] capture: [adaptor->captureAppContent]: intervalInMS = %f", timeIntervalInMicroSecond);
     
     //NSLog(@"[Thread Running] capture: [adaptor->captureAppContent]: adaptor->_capability.framerate = %d", _weak_self->_capability.framerate);
     NSLog(@"[Thread Running] capture: [adaptor->captureAppContent]: adaptor->_capability.framerate = %d", appWindowCapture->fps_);
     
     NSTimeInterval delayTime = 1.0f;
     //dispatch_time_t startDelayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * 0));
     dispatch_source_set_timer(_captureAppContentTimer, dispatch_walltime(NULL, 0), timeIntervalInMicroSecond * NSEC_PER_MSEC, 0 * NSEC_PER_SEC);
     dispatch_source_set_event_handler(_captureAppContentTimer, ^{
     NSLog(@"[createCaptureAppContentTimerThread]: plus = %d", plus++);
     
     
     //TODO: -test -ymao -2022-1-18 -for minimize sharing app window
     //===begin========================================================
     //        if (_weak_self->_device->isAllWindowMinmized) {
     //            NSLog(@"[Thread Running] capture:  isAllWindowMinmized() ");
     //
     //            return;
     //        }
     
     //===end========================================================
     
     NSLog(@"[Thread Running] capture:  call captureAppContent() ");
     
     static uint64_t startCaptureTime = 0 ;
     static uint64_t captureTime = 0;
     static uint64_t lastEndCaptureLoopTime = 0;
     static uint64_t lastCaptureLoopTime = 0;
     
     lastCaptureLoopTime = getCPUTime() - lastEndCaptureLoopTime;
     NSLog(@"[Thread Running] capture: [adaptor->captureAppContent]: lastCaptureLoopTime = %llu", lastCaptureLoopTime);
     
     startCaptureTime = getCPUTime();
     //_weak_self->captureAppContent();
     appWindowCapture->CaptureFrame();
     
     captureTime = getCPUTime() - startCaptureTime;
     NSLog(@"[Thread Running] capture: [adaptor->captureAppContent]: captureContentTime = %llu", captureTime);
     
     lastEndCaptureLoopTime = getCPUTime();
     
     });
     dispatch_resume(_captureAppContentTimer);
     
     
     }
     */
    
    // DesktopCapturer::Callback interface.
    void OnCaptureResult(DesktopCapturer::Result result,
                         std::unique_ptr<DesktopFrame> desktopFrame) override {
        
        NSLog(@"[GMWindowCapturerMac]: OnCaptureResult : %d", __LINE__);
        
        
        static uint64_t startCaptureTime = 0 ;
        static uint64_t captureTime = 0;
        static uint64_t lastEndCaptureLoopTime = 0;
        static uint64_t lastCaptureLoopTime = 0;
        static int index = 0;
        
        ++index;
        
        lastCaptureLoopTime = clock();
        
        NSLog(@"[OnCaptureResult]: [%d] : lastCaptureLoopTime = %llu", index, lastCaptureLoopTime - lastEndCaptureLoopTime);
        lastEndCaptureLoopTime = lastCaptureLoopTime;
        
        if (result != DesktopCapturer::Result::SUCCESS) {
            return; // Obviously never called
        }
        
        int width = desktopFrame->size().width();
        int height = desktopFrame->size().height();
        
        NSLog(@"[OnCaptureResult]: [width, height] : [%d, %d]", width, height);
        
        
        
        //this->OnFrame(frame/*, width, height*/);
    }
    
    void OnFrame(const VideoFrame& video_frame) {
        
    }
    
private:
    Callback* callback_ = nullptr;
    
    // The window being captured.
    CGWindowID window_id_ = 0;
    
    rtc::scoped_refptr<FullScreenWindowDetector> full_screen_window_detector_;
    
    const rtc::scoped_refptr<DesktopConfigurationMonitor> configuration_monitor_;
    
    WindowFinderMac window_finder_;
    
    RTC_DISALLOW_COPY_AND_ASSIGN(GMWindowCapturerMac);
    
    
    
}; //end of class GMWindowCapturerMac





}  // end of namespace webrtc


#endif /* gm_window_capturer_mac_h */
