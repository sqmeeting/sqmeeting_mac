/*
 *  Copyright (c) 2017 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include "test/mock_audio_decoder.h"

namespace webrtc_mac_capturer {

MockAudioDecoder::MockAudioDecoder() = default;
MockAudioDecoder::~MockAudioDecoder() {
  Die();
}

}  // namespace webrtc_mac_capturer
