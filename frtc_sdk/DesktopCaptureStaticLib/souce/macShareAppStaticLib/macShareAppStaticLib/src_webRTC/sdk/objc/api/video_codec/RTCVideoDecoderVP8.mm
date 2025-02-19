/*
 *  Copyright (c) 2017 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 *
 */

#import <Foundation/Foundation.h>

#import "RTCMacros.h"
#import "RTCVideoDecoderVP8.h"
#import "RTCWrappedNativeVideoDecoder.h"

#include "modules/video_coding/codecs/vp8/include/vp8.h"

@implementation RTC_OBJC_TYPE (RTCVideoDecoderVP8)

+ (id<RTC_OBJC_TYPE(RTCVideoDecoder)>)vp8Decoder {
  return [[RTC_OBJC_TYPE(RTCWrappedNativeVideoDecoder) alloc]
      initWithNativeDecoder:std::unique_ptr<webrtc_mac_capturer::VideoDecoder>(webrtc_mac_capturer::VP8Decoder::Create())];
}

@end
