/*
 *  Copyright 2015 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "RTCVideoSource+Private.h"

#include "pc/video_track_source_proxy.h"
#include "rtc_base/checks.h"
#include "sdk/objc/native/src/objc_video_track_source.h"

static webrtc_mac_capturer::ObjCVideoTrackSource *getObjCVideoSource(
    const rtc::scoped_refptr<webrtc_mac_capturer::VideoTrackSourceInterface> nativeSource) {
  webrtc_mac_capturer::VideoTrackSourceProxy *proxy_source =
      static_cast<webrtc_mac_capturer::VideoTrackSourceProxy *>(nativeSource.get());
  return static_cast<webrtc_mac_capturer::ObjCVideoTrackSource *>(proxy_source->internal());
}

// TODO(magjed): Refactor this class and target ObjCVideoTrackSource only once
// RTCAVFoundationVideoSource is gone. See http://crbug/webrtc/7177 for more
// info.
@implementation RTC_OBJC_TYPE (RTCVideoSource) {
  rtc::scoped_refptr<webrtc_mac_capturer::VideoTrackSourceInterface> _nativeVideoSource;
}

- (instancetype)initWithFactory:(RTC_OBJC_TYPE(RTCPeerConnectionFactory) *)factory
              nativeVideoSource:
                  (rtc::scoped_refptr<webrtc_mac_capturer::VideoTrackSourceInterface>)nativeVideoSource {
  RTC_DCHECK(factory);
  RTC_DCHECK(nativeVideoSource);
  if (self = [super initWithFactory:factory
                  nativeMediaSource:nativeVideoSource
                               type:RTCMediaSourceTypeVideo]) {
    _nativeVideoSource = nativeVideoSource;
  }
  return self;
}

- (instancetype)initWithFactory:(RTC_OBJC_TYPE(RTCPeerConnectionFactory) *)factory
              nativeMediaSource:(rtc::scoped_refptr<webrtc_mac_capturer::MediaSourceInterface>)nativeMediaSource
                           type:(RTCMediaSourceType)type {
  RTC_NOTREACHED();
  return nil;
}

- (instancetype)initWithFactory:(RTC_OBJC_TYPE(RTCPeerConnectionFactory) *)factory
                signalingThread:(rtc::Thread *)signalingThread
                   workerThread:(rtc::Thread *)workerThread {
  rtc::scoped_refptr<webrtc_mac_capturer::ObjCVideoTrackSource> objCVideoTrackSource(
      new rtc::RefCountedObject<webrtc_mac_capturer::ObjCVideoTrackSource>());

  return [self initWithFactory:factory
             nativeVideoSource:webrtc_mac_capturer::VideoTrackSourceProxy::Create(
                                   signalingThread, workerThread, objCVideoTrackSource)];
}

- (NSString *)description {
  NSString *stateString = [[self class] stringForState:self.state];
  return [NSString stringWithFormat:@"RTC_OBJC_TYPE(RTCVideoSource)( %p ): %@", self, stateString];
}

- (void)capturer:(RTC_OBJC_TYPE(RTCVideoCapturer) *)capturer
    didCaptureVideoFrame:(RTC_OBJC_TYPE(RTCVideoFrame) *)frame {
  getObjCVideoSource(_nativeVideoSource)->OnCapturedFrame(frame);
}

- (void)adaptOutputFormatToWidth:(int)width height:(int)height fps:(int)fps {
  getObjCVideoSource(_nativeVideoSource)->OnOutputFormatRequest(width, height, fps);
}

#pragma mark - Private

- (rtc::scoped_refptr<webrtc_mac_capturer::VideoTrackSourceInterface>)nativeVideoSource {
  return _nativeVideoSource;
}

@end
