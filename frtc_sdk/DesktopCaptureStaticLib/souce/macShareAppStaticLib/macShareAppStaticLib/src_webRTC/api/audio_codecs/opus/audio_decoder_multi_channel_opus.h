/*
 *  Copyright (c) 2019 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef API_AUDIO_CODECS_OPUS_AUDIO_DECODER_MULTI_CHANNEL_OPUS_H_
#define API_AUDIO_CODECS_OPUS_AUDIO_DECODER_MULTI_CHANNEL_OPUS_H_

#include <memory>
#include <vector>

#include "absl/types/optional.h"
#include "api/audio_codecs/audio_codec_pair_id.h"
#include "api/audio_codecs/audio_decoder.h"
#include "api/audio_codecs/audio_format.h"
#include "api/audio_codecs/opus/audio_decoder_multi_channel_opus_config.h"
#include "rtc_base/system/rtc_export.h"

namespace webrtc_mac_capturer {

// Opus decoder API for use as a template parameter to
// CreateAudioDecoderFactory<...>().
struct RTC_EXPORT AudioDecoderMultiChannelOpus {
  using Config = AudioDecoderMultiChannelOpusConfig;
  static absl::optional<AudioDecoderMultiChannelOpusConfig> SdpToConfig(
      const SdpAudioFormat& audio_format);
  static void AppendSupportedDecoders(std::vector<AudioCodecSpec>* specs);
  static std::unique_ptr<AudioDecoder> MakeAudioDecoder(
      AudioDecoderMultiChannelOpusConfig config,
      absl::optional<AudioCodecPairId> codec_pair_id = absl::nullopt);
};

}  // namespace webrtc_mac_capturer

#endif  // API_AUDIO_CODECS_OPUS_AUDIO_DECODER_MULTI_CHANNEL_OPUS_H_
