/*
 *  Copyright 2019 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include "rtc_base/experiments/stable_target_rate_experiment.h"

#include "api/transport/field_trial_based_config.h"
#include "rtc_base/experiments/rate_control_settings.h"

namespace webrtc_mac_capturer {
namespace {
constexpr char kFieldTrialName[] = "WebRTC-StableTargetRate";
}  // namespace

StableTargetRateExperiment::StableTargetRateExperiment(
    const WebRtcKeyValueConfig* const key_value_config,
    double default_video_hysteresis,
    double default_screenshare_hysteresis)
    : enabled_("enabled", false),
      video_hysteresis_factor_("video_hysteresis_factor",
                               default_video_hysteresis),
      screenshare_hysteresis_factor_("screenshare_hysteresis_factor",
                                     default_screenshare_hysteresis) {
  ParseFieldTrial(
      {&enabled_, &video_hysteresis_factor_, &screenshare_hysteresis_factor_},
      key_value_config->Lookup(kFieldTrialName));
}

StableTargetRateExperiment::StableTargetRateExperiment(
    const StableTargetRateExperiment&) = default;
StableTargetRateExperiment::StableTargetRateExperiment(
    StableTargetRateExperiment&&) = default;

StableTargetRateExperiment StableTargetRateExperiment::ParseFromFieldTrials() {
  FieldTrialBasedConfig config;
  return ParseFromKeyValueConfig(&config);
}

StableTargetRateExperiment StableTargetRateExperiment::ParseFromKeyValueConfig(
    const WebRtcKeyValueConfig* const key_value_config) {
  RateControlSettings rate_control =
      RateControlSettings::ParseFromKeyValueConfig(key_value_config);
  return StableTargetRateExperiment(
      key_value_config,
      rate_control.GetSimulcastHysteresisFactor(VideoCodecMode::kRealtimeVideo),
      rate_control.GetSimulcastHysteresisFactor(
          VideoCodecMode::kScreensharing));
}

bool StableTargetRateExperiment::IsEnabled() const {
  return enabled_.Get();
}

double StableTargetRateExperiment::GetVideoHysteresisFactor() const {
  return video_hysteresis_factor_.Get();
}

double StableTargetRateExperiment::GetScreenshareHysteresisFactor() const {
  return screenshare_hysteresis_factor_.Get();
}

}  // namespace webrtc_mac_capturer
