//
//  blank_detector_desktop_capturer_wrapper_unittest.h
//  TestWebrtc
//
//  Created by yingyong.Mao on 2022/2/17.
//



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

namespace webrtc_mac_capturer {

class BlankDetectorDesktopCapturerWrapperTest
//    : public ::testing::Test,
      : public DesktopCapturer::Callback {


public:
  BlankDetectorDesktopCapturerWrapperTest() {
      frame_generator_.size()->set(frame_width_, frame_height_);
      frame_generator_.set_desktop_frame_painter(&painter_);
      std::unique_ptr<DesktopCapturer> capturer(new FakeDesktopCapturer());
      FakeDesktopCapturer* fake_capturer = static_cast<FakeDesktopCapturer*>(capturer.get());
      fake_capturer->set_frame_generator(&frame_generator_);
      capturer_ = fake_capturer;
      wrapper_.reset(new BlankDetectorDesktopCapturerWrapper(std::move(capturer), RgbaColor(0, 0, 0, 0)));
      wrapper_->Start(this);
  };
          
  //~BlankDetectorDesktopCapturerWrapperTest() override;

 ~BlankDetectorDesktopCapturerWrapperTest();

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

 private:
  // DesktopCapturer::Callback interface.
  void OnCaptureResult(DesktopCapturer::Result result,
                       std::unique_ptr<DesktopFrame> frame) override;

  PainterDesktopFrameGenerator frame_generator_;
          
          

};

}
