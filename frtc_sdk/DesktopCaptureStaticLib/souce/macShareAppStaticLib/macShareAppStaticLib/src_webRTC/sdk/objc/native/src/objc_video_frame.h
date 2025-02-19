/*
 *  Copyright 2018 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef SDK_OBJC_NATIVE_SRC_OBJC_VIDEO_FRAME_H_
#define SDK_OBJC_NATIVE_SRC_OBJC_VIDEO_FRAME_H_

#import "base/RTCVideoFrame.h"

#include "api/video/video_frame.h"

namespace webrtc_mac_capturer {

RTC_OBJC_TYPE(RTCVideoFrame) * ToObjCVideoFrame(const VideoFrame& frame);

}  // namespace webrtc_mac_capturer

#endif  // SDK_OBJC_NATIVE_SRC_OBJC_VIDEO_FRAME_H_
