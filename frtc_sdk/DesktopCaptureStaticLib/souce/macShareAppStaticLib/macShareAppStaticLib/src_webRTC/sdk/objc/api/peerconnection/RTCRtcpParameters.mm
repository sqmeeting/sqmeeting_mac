/*
 *  Copyright 2018 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "RTCRtcpParameters+Private.h"

#import "helpers/NSString+StdString.h"

@implementation RTC_OBJC_TYPE (RTCRtcpParameters)

@synthesize cname = _cname;
@synthesize isReducedSize = _isReducedSize;

- (instancetype)init {
  webrtc_mac_capturer::RtcpParameters nativeParameters;
  return [self initWithNativeParameters:nativeParameters];
}

- (instancetype)initWithNativeParameters:(const webrtc_mac_capturer::RtcpParameters &)nativeParameters {
  if (self = [super init]) {
    _cname = [NSString stringForStdString:nativeParameters.cname];
    _isReducedSize = nativeParameters.reduced_size;
  }
  return self;
}

- (webrtc_mac_capturer::RtcpParameters)nativeParameters {
  webrtc_mac_capturer::RtcpParameters parameters;
  parameters.cname = [NSString stdStringForString:_cname];
  parameters.reduced_size = _isReducedSize;
  return parameters;
}

@end
