//
//  use_app_window_capturer_mac.hpp
//  TestWebrtc
//
//  Created by yingyong.Mao on 2022/3/2.
//

#ifndef use_app_window_capturer_mac_hpp
#define use_app_window_capturer_mac_hpp

#include <stdio.h>
#include "common.h"
#include "modules/desktop_capture/app_window_capturer_mac.hpp"

//[bug fix]: share App, sometimes remote content is black.
#define  MAX_CAPTURE_FAILED_COUNT 30

using namespace std;
using namespace rtc;
using namespace webrtc_mac_capturer;


class BassClass {
public:
    BassClass() {};
    ~BassClass() {};
};


typedef void (*ContentOutputCallback)(void *buffer,
                                      int length,
                                      int width,
                                      int height,
                                      int stride,
                                      Capture_VideoSampleType type,
                                      std::string sourceID);

#pragma mark- UseAppWindowCapturerMac

class UseAppWindowCapturerMac : public std::enable_shared_from_this<UseAppWindowCapturerMac>,
                                public DesktopCapturer::Callback
{
public:
    //std::unique_ptr<WindowCapturerMac> winCapture_;
    dispatch_source_t        _captureAppContentTimer;         //[for share App content]: capture App Window.
    
    ContentOutputCallback    contentOutputCB;
    
    void setContentOutputCallback(ContentOutputCallback cb);
    
public:
    //std::unique_ptr<webrtc_mac_capturer::DesktopCapturer> dc_;
    WindowCapturerMac * appWindowCapture_;
    //std::unique_ptr<WindowCapturerMac> appWindowCapture_;
    //int fps_ = 30;
    size_t fps_ = 30; //will use this->capability.framerate.
    std::string window_title_;
    std::atomic_bool start_flag_;
    //RefCountedObject
    //SourceState state_;
    
private:
    //uint8_t * yuvByteBuffer_;
    //uint8_t * yuvByteBuffer_scaled_dst_;
    uint8_t * yuvByteBuffer_pauseImage = nullptr; //for pause image while sharing app is minimized.
    uint8_t * imageData_pauseImage_Ptr = nullptr;

    void i420Scale(uint8_t *srcYuvData, uint8_t *dstYuvData, int width, int height, int dstWidth, int dstHeight);
    CONTENT_CAPS_STRUCT capability;
    std::string sourceAppContentName;
    unsigned int sourceAppContentWindowID;
    
    NSImage * sharingAppPauseImage_;

    //TODO: -yingyong.Mao -2022-4-15
    std::shared_ptr<UseAppWindowCapturerMac>  _device;
    std::mutex     _theLock;
    
    
public:
    static std::shared_ptr<UseAppWindowCapturerMac> getInstance();
    void releaseInstance();
    UseAppWindowCapturerMac();
    ~UseAppWindowCapturerMac();
    
public:
    void StartCapture();
    void StopCapture();
    void setCapability(CONTENT_CAPS_STRUCT capability);
    void setAppContentName(std::string sourceAppContentName, unsigned int sourceAppContentWindowID);
    //================================================
    //for thread
    void createCaptureAppContentTimerThread();
    void resumeCaptureAppContentTimer(dispatch_source_t timer);
    void suspendCaptureAppContentTimer(dispatch_source_t timer);
    void cancelCaptureAppContentTimer(dispatch_source_t timer);
    
private:
    // DesktopCapturer::Callback interface.
    // Called after a frame has been captured. `frame` is not nullptr if and
    // only if `result` is SUCCESS.
    //    void OnCaptureResult_without_scale(DesktopCapturer::Result result, std::unique_ptr<DesktopFrame> frame);
    void OnCaptureResult(DesktopCapturer::Result result, std::unique_ptr<DesktopFrame> frame)override;
    
    void OnCaptureResult_scale_2(DesktopCapturer::Result result, std::unique_ptr<DesktopFrame> frame);
    void OnCaptureResult_old(DesktopCapturer::Result result, std::unique_ptr<DesktopFrame> frame);
    //2022-3-10  can work success!
    //[scale-1 the DesktopFrame] : scale the DesktopFrame, but cutted, not right, only show the top-left rec.
    //DesktopCapturer::Callback interface.
    void OnCaptureResult_scale_1_DesktopFrame_scale(DesktopCapturer::Result result, std::unique_ptr<DesktopFrame> frame);
    //    void OnCaptureResult(DesktopCapturer::Result result, std::unique_ptr<DesktopFrame> frame) override;
    
    
    void OnFrame(const VideoFrame& video_frame);
    //    void OnCallBack(void *buffer,
    //                    int length,
    //                    int width,
    //                    int height,
    //                    Capture_VideoSampleType type,
    //                    std::string sourceID,
    //                    UseAppWindowCapturerMac * thisObj);
    
    void OnFrameYUV420Buffer(uint8_t * yuvBuffer,
                             int length,
                             int width,
                             int height,
                             int stride,
                             Capture_VideoSampleType type,
                             std::string sourceID);
    
    void getByteFromI42Buffer(int width,
                              int height);
    
    
public:
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
    
	//[bug fix]: share App, sometimes remote content is black.
    //for show pause-pic after capture failed (get buffer empty) for 15 frame.
    int nCountCaptureEmpty;
};

#endif /* use_app_window_capturer_mac_hpp */
