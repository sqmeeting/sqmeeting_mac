/*
 *  Copyright 2016 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "RTCMediaSource+Private.h"

#include "rtc_base/checks.h"

@implementation RTC_OBJC_TYPE (RTCMediaSource) {
  RTC_OBJC_TYPE(RTCPeerConnectionFactory) * _factory;
  RTCMediaSourceType _type;
}

@synthesize nativeMediaSource = _nativeMediaSource;

- (instancetype)initWithFactory:(RTC_OBJC_TYPE(RTCPeerConnectionFactory) *)factory
              nativeMediaSource:(rtc::scoped_refptr<webrtc_mac_capturer::MediaSourceInterface>)nativeMediaSource
                           type:(RTCMediaSourceType)type {
  RTC_DCHECK(factory);
  RTC_DCHECK(nativeMediaSource);
  if (self = [super init]) {
    _factory = factory;
    _nativeMediaSource = nativeMediaSource;
    _type = type;
  }
  return self;
}

- (RTCSourceState)state {
  return [[self class] sourceStateForNativeState:_nativeMediaSource->state()];
}

#pragma mark - Private

+ (webrtc_mac_capturer::MediaSourceInterface::SourceState)nativeSourceStateForState:
    (RTCSourceState)state {
  switch (state) {
    case RTCSourceStateInitializing:
      return webrtc_mac_capturer::MediaSourceInterface::kInitializing;
    case RTCSourceStateLive:
      return webrtc_mac_capturer::MediaSourceInterface::kLive;
    case RTCSourceStateEnded:
      return webrtc_mac_capturer::MediaSourceInterface::kEnded;
    case RTCSourceStateMuted:
      return webrtc_mac_capturer::MediaSourceInterface::kMuted;
  }
}

+ (RTCSourceState)sourceStateForNativeState:
    (webrtc_mac_capturer::MediaSourceInterface::SourceState)nativeState {
  switch (nativeState) {
    case webrtc_mac_capturer::MediaSourceInterface::kInitializing:
      return RTCSourceStateInitializing;
    case webrtc_mac_capturer::MediaSourceInterface::kLive:
      return RTCSourceStateLive;
    case webrtc_mac_capturer::MediaSourceInterface::kEnded:
      return RTCSourceStateEnded;
    case webrtc_mac_capturer::MediaSourceInterface::kMuted:
      return RTCSourceStateMuted;
  }
}

+ (NSString *)stringForState:(RTCSourceState)state {
  switch (state) {
    case RTCSourceStateInitializing:
      return @"Initializing";
    case RTCSourceStateLive:
      return @"Live";
    case RTCSourceStateEnded:
      return @"Ended";
    case RTCSourceStateMuted:
      return @"Muted";
  }
}

@end
