/*
 *  Copyright 2015 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "RTCVideoRendererAdapter+Private.h"
#import "base/RTCVideoFrame.h"

#include <memory>

#include "sdk/objc/native/api/video_frame.h"

namespace webrtc_mac_capturer {

class VideoRendererAdapter
    : public rtc::VideoSinkInterface<webrtc_mac_capturer::VideoFrame> {
 public:
  VideoRendererAdapter(RTCVideoRendererAdapter* adapter) {
    adapter_ = adapter;
    size_ = CGSizeZero;
  }

  void OnFrame(const webrtc_mac_capturer::VideoFrame& nativeVideoFrame) override {
    RTC_OBJC_TYPE(RTCVideoFrame)* videoFrame = NativeToObjCVideoFrame(nativeVideoFrame);

    CGSize current_size = (videoFrame.rotation % 180 == 0)
                              ? CGSizeMake(videoFrame.width, videoFrame.height)
                              : CGSizeMake(videoFrame.height, videoFrame.width);

    if (!CGSizeEqualToSize(size_, current_size)) {
      size_ = current_size;
      [adapter_.videoRenderer setSize:size_];
    }
    [adapter_.videoRenderer renderFrame:videoFrame];
  }

 private:
  __weak RTCVideoRendererAdapter *adapter_;
  CGSize size_;
};
}

@implementation RTCVideoRendererAdapter {
  std::unique_ptr<webrtc_mac_capturer::VideoRendererAdapter> _adapter;
}

@synthesize videoRenderer = _videoRenderer;

- (instancetype)initWithNativeRenderer:(id<RTC_OBJC_TYPE(RTCVideoRenderer)>)videoRenderer {
  NSParameterAssert(videoRenderer);
  if (self = [super init]) {
    _videoRenderer = videoRenderer;
    _adapter.reset(new webrtc_mac_capturer::VideoRendererAdapter(self));
  }
  return self;
}

- (rtc::VideoSinkInterface<webrtc_mac_capturer::VideoFrame> *)nativeVideoRenderer {
  return _adapter.get();
}

@end