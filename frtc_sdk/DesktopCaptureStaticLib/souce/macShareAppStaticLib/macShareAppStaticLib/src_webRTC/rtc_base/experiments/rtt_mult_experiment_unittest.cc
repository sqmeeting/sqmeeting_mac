/*
 *  Copyright 2018 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include "rtc_base/experiments/rtt_mult_experiment.h"

#include "test/field_trial.h"
#include "test/gtest.h"

namespace webrtc_mac_capturer {

TEST(RttMultExperimentTest, RttMultDisabledByDefault) {
  EXPECT_FALSE(RttMultExperiment::RttMultEnabled());
}

TEST(RttMultExperimentTest, RttMultEnabledByFieldTrial) {
  webrtc_mac_capturer::test::ScopedFieldTrials field_trials(
      "WebRTC-RttMult/Enabled-0.60,100.0/");
  EXPECT_TRUE(RttMultExperiment::RttMultEnabled());
}

TEST(RttMultExperimentTest, RttMultTestValue) {
  webrtc_mac_capturer::test::ScopedFieldTrials field_trials(
      "WebRTC-RttMult/Enabled-0.60,100.0/");
  EXPECT_EQ(0.6f, RttMultExperiment::GetRttMultValue()->rtt_mult_setting);
  EXPECT_EQ(100.0f, RttMultExperiment::GetRttMultValue()->rtt_mult_add_cap_ms);
}

TEST(RttMultExperimentTest, RttMultTestMalformedEnabled) {
  webrtc_mac_capturer::test::ScopedFieldTrials field_trials(
      "WebRTC-RttMult/Enable-0.60,100.0/");
  EXPECT_FALSE(RttMultExperiment::RttMultEnabled());
  EXPECT_FALSE(RttMultExperiment::GetRttMultValue());
}

TEST(RttMultExperimentTest, RttMultTestValueOutOfBoundsPositive) {
  webrtc_mac_capturer::test::ScopedFieldTrials field_trials(
      "WebRTC-RttMult/Enabled-1.5,2100.0/");
  EXPECT_EQ(1.0f, RttMultExperiment::GetRttMultValue()->rtt_mult_setting);
  EXPECT_EQ(2000.0f, RttMultExperiment::GetRttMultValue()->rtt_mult_add_cap_ms);
}

TEST(RttMultExperimentTest, RttMultTestValueOutOfBoundsNegative) {
  webrtc_mac_capturer::test::ScopedFieldTrials field_trials(
      "WebRTC-RttMult/Enabled--0.5,-100.0/");
  EXPECT_EQ(0.0f, RttMultExperiment::GetRttMultValue()->rtt_mult_setting);
  EXPECT_EQ(0.0f, RttMultExperiment::GetRttMultValue()->rtt_mult_add_cap_ms);
}

TEST(RttMultExperimentTest, RttMultTestMalformedValue) {
  webrtc_mac_capturer::test::ScopedFieldTrials field_trials(
      "WebRTC-RttMult/Enabled-0.25,10a0.0/");
  EXPECT_NE(100.0f, RttMultExperiment::GetRttMultValue()->rtt_mult_add_cap_ms);
}

}  // namespace webrtc_mac_capturer
