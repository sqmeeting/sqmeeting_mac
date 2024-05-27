/*
 *  Copyright (c) 2017 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */


#ifndef blank_detector_desktop_capturer_wrapper_unittest_h
#define blank_detector_desktop_capturer_wrapper_unittest_h

#include "modules/desktop_capture/blank_detector_desktop_capturer_wrapper_unittest.h"




namespace webrtc_mac_capturer {



void testDesktopCapturer() {
//    BlankDetectorDesktopCapturerWrapperTest *test = new BlankDetectorDesktopCapturerWrapperTest();
//    printf("test: %p", test);
}


//BlankDetectorDesktopCapturerWrapperTest::BlankDetectorDesktopCapturerWrapperTest() {
//  frame_generator_.size()->set(frame_width_, frame_height_);
//  frame_generator_.set_desktop_frame_painter(&painter_);
//  std::unique_ptr<DesktopCapturer> capturer(new FakeDesktopCapturer());
//  FakeDesktopCapturer* fake_capturer =
//      static_cast<FakeDesktopCapturer*>(capturer.get());
//  fake_capturer->set_frame_generator(&frame_generator_);
//  capturer_ = fake_capturer;
//  wrapper_.reset(new BlankDetectorDesktopCapturerWrapper(
//      std::move(capturer), RgbaColor(0, 0, 0, 0)));
//  wrapper_->Start(this);
//}

//
//BlankDetectorDesktopCapturerWrapperTest::
//    ~BlankDetectorDesktopCapturerWrapperTest() = default;
//

// Synonyms for CHECK_* that are used in some unittests.

#define ASSERT_EQ(val1, val2) EXPECT_EQ(val1, val2)


// Synonyms for CHECK_* that are used in some unittests.
#define EXPECT_EQ(val1, val2) CHECK_EQ(val1, val2)

#define CHECK_EQ(val1, val2) CHECK_OP(==, val1, val2)

#define CHECK_OP(op, val1, val2)                                        \
  do {                                                                  \
    if (!((val1) op (val2))) {                                          \
      fprintf(stderr, "Check failed: %s %s %s\n", #val1, #op, #val2);   \
      abort();                                                          \
    }                                                                   \
  } while (0)


//void BlankDetectorDesktopCapturerWrapperTest::OnCaptureResult(
//    DesktopCapturer::Result result,
//    std::unique_ptr<DesktopFrame> frame) {
//
//  last_result_ = result;
//  last_frame_ = std::move(frame);
//  num_frames_captured_++;
//}

//void BlankDetectorDesktopCapturerWrapperTest::PerfTest(DesktopCapturer* capturer) {
//
//    for (int i = 0; i < 10000; i++) {
//    capturer->CaptureFrame();
//    ASSERT_EQ(num_frames_captured_, i + 1);
//  }
//}

//TEST_F(BlankDetectorDesktopCapturerWrapperTest, ShouldDetectBlankFrame) {
//  wrapper_->CaptureFrame();
//  ASSERT_EQ(num_frames_captured_, 1);
//  ASSERT_EQ(last_result_, DesktopCapturer::Result::ERROR_TEMPORARY);
//  ASSERT_FALSE(last_frame_);
//}

//TEST_F(BlankDetectorDesktopCapturerWrapperTest, ShouldPassBlankDetection) {
//  painter_.updated_region()->AddRect(DesktopRect::MakeXYWH(0, 0, 100, 100));
//  wrapper_->CaptureFrame();
//  ASSERT_EQ(num_frames_captured_, 1);
//  ASSERT_EQ(last_result_, DesktopCapturer::Result::SUCCESS);
//  ASSERT_TRUE(last_frame_);
//
//  painter_.updated_region()->AddRect(
//      DesktopRect::MakeXYWH(frame_width_ - 100, frame_height_ - 100, 100, 100));
//  wrapper_->CaptureFrame();
//  ASSERT_EQ(num_frames_captured_, 2);
//  ASSERT_EQ(last_result_, DesktopCapturer::Result::SUCCESS);
//  ASSERT_TRUE(last_frame_);
//
//  painter_.updated_region()->AddRect(
//      DesktopRect::MakeXYWH(0, frame_height_ - 100, 100, 100));
//  wrapper_->CaptureFrame();
//  ASSERT_EQ(num_frames_captured_, 3);
//  ASSERT_EQ(last_result_, DesktopCapturer::Result::SUCCESS);
//  ASSERT_TRUE(last_frame_);
//
//  painter_.updated_region()->AddRect(
//      DesktopRect::MakeXYWH(frame_width_ - 100, 0, 100, 100));
//  wrapper_->CaptureFrame();
//  ASSERT_EQ(num_frames_captured_, 4);
//  ASSERT_EQ(last_result_, DesktopCapturer::Result::SUCCESS);
//  ASSERT_TRUE(last_frame_);
//
//  painter_.updated_region()->AddRect(DesktopRect::MakeXYWH(
//      (frame_width_ >> 1) - 50, (frame_height_ >> 1) - 50, 100, 100));
//  wrapper_->CaptureFrame();
//  ASSERT_EQ(num_frames_captured_, 5);
//  ASSERT_EQ(last_result_, DesktopCapturer::Result::SUCCESS);
//  ASSERT_TRUE(last_frame_);
//}
//
//TEST_F(BlankDetectorDesktopCapturerWrapperTest,
//       ShouldNotCheckAfterANonBlankFrameReceived) {
//  wrapper_->CaptureFrame();
//  ASSERT_EQ(num_frames_captured_, 1);
//  ASSERT_EQ(last_result_, DesktopCapturer::Result::ERROR_TEMPORARY);
//  ASSERT_FALSE(last_frame_);
//
//  painter_.updated_region()->AddRect(
//      DesktopRect::MakeXYWH(frame_width_ - 100, 0, 100, 100));
//  wrapper_->CaptureFrame();
//  ASSERT_EQ(num_frames_captured_, 2);
//  ASSERT_EQ(last_result_, DesktopCapturer::Result::SUCCESS);
//  ASSERT_TRUE(last_frame_);
//
//  for (int i = 0; i < 100; i++) {
//    wrapper_->CaptureFrame();
//    ASSERT_EQ(num_frames_captured_, i + 3);
//    ASSERT_EQ(last_result_, DesktopCapturer::Result::SUCCESS);
//    ASSERT_TRUE(last_frame_);
//  }
//}
//
//// There is no perceptible impact by using BlankDetectorDesktopCapturerWrapper.
//// i.e. less than 0.2ms per frame.
//// [ OK ] DISABLED_Performance (10210 ms)
//// [ OK ] DISABLED_PerformanceComparison (8791 ms)
//TEST_F(BlankDetectorDesktopCapturerWrapperTest, DISABLED_Performance) {
//  PerfTest(wrapper_.get());
//}
//
//TEST_F(BlankDetectorDesktopCapturerWrapperTest,
//       DISABLED_PerformanceComparison) {
//  capturer_->Start(this);
//  PerfTest(capturer_);
//}

}  // namespace webrtc_mac_capturer_mac_capturer

#endif /* blank_detector_desktop_capturer_wrapper_unittest_h */
