//
//  gm_desktop_capturer_test.hpp
//  TestWebrtc
//
//  Created by yingyong.Mao on 2022/2/17.
//

#ifndef gm_desktop_capturer_test_hpp
#define gm_desktop_capturer_test_hpp

#include <stdio.h>

#include "modules/desktop_capture/blank_detector_desktop_capturer_wrapper.h"

#include <memory>
#include <utility>

#include "modules/desktop_capture/desktop_capturer.h"
#include "modules/desktop_capture/desktop_frame.h"
#include "modules/desktop_capture/desktop_frame_generator.h"
#include "modules/desktop_capture/desktop_geometry.h"
#include "modules/desktop_capture/desktop_region.h"
#include "modules/desktop_capture/fake_desktop_capturer.h"
#include "test/gtest.h"

#include "api/video/video_frame.h" //for VideoFrame


using namespace webrtc_mac_capturer;

namespace webrtc_mac_capturer {

class Test {
public:
    Test() {
    };
    ~Test() {
    }
};


class GMDesktopCapturerTest : public DesktopCapturer::Callback {
public:
    GMDesktopCapturerTest() {};
    ~GMDesktopCapturerTest() {};

public:
    static void startCaptuer();
    
public:
    // DesktopCapturer::Callback interface.
    void OnCaptureResult(DesktopCapturer::Result result,
                      std::unique_ptr<DesktopFrame> frame) override;
    
    void OnFrame(const VideoFrame& video_frame);

protected:
    void PerfTest(DesktopCapturer* capturer);

    const int frame_width_ = 1024;
    const int frame_height_ = 768;
    std::unique_ptr<BlankDetectorDesktopCapturerWrapper> wrapper_;
    DesktopCapturer* capturer_ = nullptr;
    BlackWhiteDesktopFramePainter painter_;
    int num_frames_captured_ = 0;
    DesktopCapturer::Result last_result_ = DesktopCapturer::Result::SUCCESS;
    std::unique_ptr<DesktopFrame> last_frame_;

    PainterDesktopFrameGenerator frame_generator_;

};



}
#endif /* gm_desktop_capturer_test_hpp */
