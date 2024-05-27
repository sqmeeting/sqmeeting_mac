/*
 *  Copyright (c) 2016 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef TEST_FAKE_VIDEORENDERER_H_
#define TEST_FAKE_VIDEORENDERER_H_

#include "api/video/video_frame.h"
#include "api/video/video_sink_interface.h"

namespace webrtc_mac_capturer {
namespace test {

class FakeVideoRenderer : public rtc::VideoSinkInterface<webrtc_mac_capturer::VideoFrame> {
 public:
  void OnFrame(const webrtc_mac_capturer::VideoFrame& frame) override {}
};

}  // namespace test
}  // namespace webrtc_mac_capturer

#endif  // TEST_FAKE_VIDEORENDERER_H_
