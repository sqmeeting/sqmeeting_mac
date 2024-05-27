/*
 *  Copyright (c) 2017 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef API_TEST_MOCK_VIDEO_DECODER_FACTORY_H_
#define API_TEST_MOCK_VIDEO_DECODER_FACTORY_H_

#include <memory>
#include <vector>

#include "api/video_codecs/sdp_video_format.h"
#include "api/video_codecs/video_decoder_factory.h"
#include "test/gmock.h"

namespace webrtc_mac_capturer {

class MockVideoDecoderFactory : public webrtc_mac_capturer::VideoDecoderFactory {
 public:
  ~MockVideoDecoderFactory() override { Die(); }

  MOCK_METHOD(std::vector<webrtc_mac_capturer::SdpVideoFormat>,
              GetSupportedFormats,
              (),
              (const, override));
  MOCK_METHOD(std::unique_ptr<webrtc_mac_capturer::VideoDecoder>,
              CreateVideoDecoder,
              (const webrtc_mac_capturer::SdpVideoFormat&),
              (override));
  MOCK_METHOD(void, Die, ());
};
}  // namespace webrtc_mac_capturer

#endif  // API_TEST_MOCK_VIDEO_DECODER_FACTORY_H_
