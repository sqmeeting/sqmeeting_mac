//
//  gm_desktop_capturer_test.cpp
//  TestWebrtc
//
//  Created by yingyong.Mao on 2022/2/17.
//

#include "gm_desktop_capturer_test.hpp"

#include "rtc_base/time_utils.h" //for namespace rtc


#include "api/video/i420_buffer.h"
#include "common_video/libyuv/include/webrtc_libyuv.h" //for VideoType
#include "third_party/libyuv/include/libyuv.h"

#include "api/video/video_frame.h"

using namespace webrtc_mac_capturer;
using namespace rtc;

//GMDesktopCapturerTest::GMDesktopCapturerTest() {
//
//}

//void CaptureThread() {
//    webrtc_mac_capturer::DesktopCaptureOptions opts = DesktopCaptureOptions::CreateDefault();
//    opts.set_allow_use_magnification_api(true);  //设置过滤窗口选项
//    // 使用 DesktopAndCursorComposer 可以采集鼠标
//    std::unique_ptr<webrtc_mac_capturer::DesktopCapturer> capturer =
//        std::unique_ptr<webrtc_mac_capturer::DesktopCapturer>(
//            new webrtc_mac_capturer::DesktopAndCursorComposer(
//                webrtc_mac_capturer::DesktopCapturer::CreateScreenCapturer(opts), opts));
//​
//    // 设置开始采集状态
//    capturer->Start(this);
//​
//    // 设置要过滤的窗口
//    for (auto source : _excludeWindowList) {
//      capturer->SetExcludedWindow(source.id);
//    }
//​
//    while (_isrunning) {
//      webrtc_mac_capturer::SleepMs(_msPerFrame);
//      // 采集桌面图像
//      capturer->CaptureFrame();
//    }
//  }



void GMDesktopCapturerTest::OnCaptureResult(
     DesktopCapturer::Result result,
     std::unique_ptr<DesktopFrame> desktopFrame) {
    
    printf("\n [OnCaptureResult] : %d \n", __LINE__);
    
    static uint64_t startCaptureTime = 0 ;
    static uint64_t captureTime = 0;
    static uint64_t lastEndCaptureLoopTime = 0;
    static uint64_t lastCaptureLoopTime = 0;
    static int index = 0;
    
    ++index;
    
    lastCaptureLoopTime = clock();

    printf("\n [OnCaptureResult]: [%d] : lastCaptureLoopTime = %llu \n", index, lastCaptureLoopTime - lastEndCaptureLoopTime);
    lastEndCaptureLoopTime = lastCaptureLoopTime;

    if (result != DesktopCapturer::Result::SUCCESS) {
        return; // Obviously never called
    }

    int width = desktopFrame->size().width();
    int height = desktopFrame->size().height();

    printf("\n [OnCaptureResult]: [width, height] : [%d, %d] \n", width, height);

    
   rtc::scoped_refptr<I420Buffer> res_i420_frame = I420Buffer::Create(width, height);

//    libyuv::ConvertToI420(VideoType::kARGB,
//                      desktopFrame->data(),
//                      0, 0,
//                      width, height,
//                      0,
//                      webrtc_mac_capturer::kVideoRotation_0,
//                      res_i420_frame);

    const int conversionResult = libyuv::ConvertToI420(desktopFrame->data(), 11,
                                                       res_i420_frame.get()->MutableDataY(),
                                                       res_i420_frame.get()->StrideY(),
                                                       res_i420_frame.get()->MutableDataU(),
                                                       res_i420_frame.get()->StrideU(),
                                                       res_i420_frame.get()->MutableDataV(),
                                                       res_i420_frame.get()->StrideV(), 0, 0,  // No Cropping
                                                       width, height,
                                                       width, height, //target_width, target_height,
                                                       libyuv::kRotate0,
                                                       libyuv::FOURCC_ARGB);
                                                       
                                                        

    
    
    VideoFrame frame = VideoFrame(res_i420_frame, 0, 0, kVideoRotation_0);
    this->OnFrame(frame/*, width, height*/);
}

void GMDesktopCapturerTest::OnFrame(const VideoFrame& video_frame) {
  //task_queue_->PostTask(ToQueuedTask([this]() { CheckStats(); }));
}

//    ret = libyuv::ConvertToI420(
//                                desktopFrame.get(), 0, desktopFrame.get()->MutableDataY(),
//        res_i420_buffer.get()->StrideY(), res_i420_buffer.get()->MutableDataU(),
//        res_i420_buffer.get()->StrideU(), res_i420_buffer.get()->MutableDataV(),
//        res_i420_buffer.get()->StrideV(), 0, 0, width_, height_,
//        res_i420_buffer->width(), res_i420_buffer->height(), libyuv::kRotate0,
//        ConvertVideoType(VideoType::kRGB24));
//
//    int stride = width;
//    uint8_t* yplane = desktopFrame->();
//    uint8_t* uplane = desktopFrame->MutableDataU();
//    uint8_t* vplane = desktopFrame->MutableDataV();
//    libyuv::ConvertToI420(desktopframe->data(),0,
//                          yplane,stride,
//                          uplane,(stride+1)/2,
//                          vplane,(stride+1)/2,
//                          0,0,
//                          width,height,
//                          width,height,
//                          libyuv::kRotate0,libyuv::FOURCC_ARGB);
//    webrtc_mac_capturer::VideoFrame frame=webrtc_mac_capturer::VideoFrame(buffer,0,0,webrtc_mac_capturer::kVideoRotation_0);
//    this->OnFrame(frame);

void GMDesktopCapturerTest::PerfTest(DesktopCapturer* capturer) {

}

void GMDesktopCapturerTest::startCaptuer() {
    printf("[GMDesktopCapturerTest]: Enter \n");
  
//    cricket::VideoFormat supported;
//    if (GetBestCaptureFormat(capture_format, &supported))
//    SetCaptureFormat(&supported);
//    SetCaptureState(cricket::CS_RUNNING);
//    auto options = DesktopCaptureOptions::CreateDefault();
//    options.set_allow_directx_capturer(true);
//    capturer = DesktopCapturer::CreateScreenCapturer(options);
    
    
    //DesktopCapturer *screen_capture_ = DesktopCapturer::Create(DesktopCaptureOptions::CreateDefault());
//    screen_capture_->SelectScreen(0);
//
//    bool ImageCaptureThreadFunc(void* param)
//    {undefined
//    webrtc_mac_capturer::DesktopCapturer* capture = static_castwebrtc_mac_capturer::DesktopCapturer*(param);
//    capture->Capture(webrtc_mac_capturer::DesktopRegion(webrtc_mac_capturer::DesktopRect()));
//    Sleep(100);
//    return true;
//    }

    printf("[GMDesktopCapturerTest]: Leave \n");
}


