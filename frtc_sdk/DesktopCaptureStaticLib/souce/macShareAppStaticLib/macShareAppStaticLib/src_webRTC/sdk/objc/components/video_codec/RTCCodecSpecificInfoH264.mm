/*
 *  Copyright 2017 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "RTCCodecSpecificInfoH264+Private.h"

#import "RTCH264ProfileLevelId.h"

// H264 specific settings.
@implementation RTC_OBJC_TYPE (RTCCodecSpecificInfoH264)

@synthesize packetizationMode = _packetizationMode;

- (webrtc_mac_capturer::CodecSpecificInfo)nativeCodecSpecificInfo {
  webrtc_mac_capturer::CodecSpecificInfo codecSpecificInfo;
  codecSpecificInfo.codecType = webrtc_mac_capturer::kVideoCodecH264;
  codecSpecificInfo.codecSpecific.H264.packetization_mode =
      (webrtc_mac_capturer::H264PacketizationMode)_packetizationMode;

  return codecSpecificInfo;
}

@end
