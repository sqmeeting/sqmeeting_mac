/*
 *  Copyright 2018 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include "sdk/objc/native/api/video_capturer.h"

#include "absl/memory/memory.h"
#include "api/video_track_source_proxy_factory.h"
#include "rtc_base/ref_counted_object.h"
#include "sdk/objc/native/src/objc_video_track_source.h"

namespace webrtc_mac_capturer {

rtc::scoped_refptr<webrtc_mac_capturer::VideoTrackSourceInterface> ObjCToNativeVideoCapturer(
    RTC_OBJC_TYPE(RTCVideoCapturer) * objc_video_capturer,
    rtc::Thread *signaling_thread,
    rtc::Thread *worker_thread) {
  RTCObjCVideoSourceAdapter *adapter = [[RTCObjCVideoSourceAdapter alloc] init];
  rtc::scoped_refptr<webrtc_mac_capturer::ObjCVideoTrackSource> objc_video_track_source(
      new rtc::RefCountedObject<webrtc_mac_capturer::ObjCVideoTrackSource>(adapter));
  rtc::scoped_refptr<webrtc_mac_capturer::VideoTrackSourceInterface> video_source =
      webrtc_mac_capturer::CreateVideoTrackSourceProxy(signaling_thread, worker_thread, objc_video_track_source);

  objc_video_capturer.delegate = adapter;

  return video_source;
}

}  // namespace webrtc_mac_capturer
