/*
 *  Copyright 2016 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "RTCRtpParameters+Private.h"

#import "RTCRtcpParameters+Private.h"
#import "RTCRtpCodecParameters+Private.h"
#import "RTCRtpEncodingParameters+Private.h"
#import "RTCRtpHeaderExtension+Private.h"
#import "helpers/NSString+StdString.h"

@implementation RTC_OBJC_TYPE (RTCRtpParameters)

@synthesize transactionId = _transactionId;
@synthesize rtcp = _rtcp;
@synthesize headerExtensions = _headerExtensions;
@synthesize encodings = _encodings;
@synthesize codecs = _codecs;
@synthesize degradationPreference = _degradationPreference;

- (instancetype)init {
  webrtc_mac_capturer::RtpParameters nativeParameters;
  return [self initWithNativeParameters:nativeParameters];
}

- (instancetype)initWithNativeParameters:
    (const webrtc_mac_capturer::RtpParameters &)nativeParameters {
  if (self = [super init]) {
    _transactionId = [NSString stringForStdString:nativeParameters.transaction_id];
    _rtcp =
        [[RTC_OBJC_TYPE(RTCRtcpParameters) alloc] initWithNativeParameters:nativeParameters.rtcp];

    NSMutableArray *headerExtensions = [[NSMutableArray alloc] init];
    for (const auto &headerExtension : nativeParameters.header_extensions) {
      [headerExtensions addObject:[[RTC_OBJC_TYPE(RTCRtpHeaderExtension) alloc]
                                      initWithNativeParameters:headerExtension]];
    }
    _headerExtensions = headerExtensions;

    NSMutableArray *encodings = [[NSMutableArray alloc] init];
    for (const auto &encoding : nativeParameters.encodings) {
      [encodings addObject:[[RTC_OBJC_TYPE(RTCRtpEncodingParameters) alloc]
                               initWithNativeParameters:encoding]];
    }
    _encodings = encodings;

    NSMutableArray *codecs = [[NSMutableArray alloc] init];
    for (const auto &codec : nativeParameters.codecs) {
      [codecs
          addObject:[[RTC_OBJC_TYPE(RTCRtpCodecParameters) alloc] initWithNativeParameters:codec]];
    }
    _codecs = codecs;

    _degradationPreference = [RTC_OBJC_TYPE(RTCRtpParameters)
        degradationPreferenceFromNativeDegradationPreference:nativeParameters
                                                                 .degradation_preference];
  }
  return self;
}

- (webrtc_mac_capturer::RtpParameters)nativeParameters {
  webrtc_mac_capturer::RtpParameters parameters;
  parameters.transaction_id = [NSString stdStringForString:_transactionId];
  parameters.rtcp = [_rtcp nativeParameters];
  for (RTC_OBJC_TYPE(RTCRtpHeaderExtension) * headerExtension in _headerExtensions) {
    parameters.header_extensions.push_back(headerExtension.nativeParameters);
  }
  for (RTC_OBJC_TYPE(RTCRtpEncodingParameters) * encoding in _encodings) {
    parameters.encodings.push_back(encoding.nativeParameters);
  }
  for (RTC_OBJC_TYPE(RTCRtpCodecParameters) * codec in _codecs) {
    parameters.codecs.push_back(codec.nativeParameters);
  }
  if (_degradationPreference) {
    parameters.degradation_preference = [RTC_OBJC_TYPE(RTCRtpParameters)
        nativeDegradationPreferenceFromDegradationPreference:(RTCDegradationPreference)
                                                                 _degradationPreference.intValue];
  }
  return parameters;
}

+ (webrtc_mac_capturer::DegradationPreference)nativeDegradationPreferenceFromDegradationPreference:
    (RTCDegradationPreference)degradationPreference {
  switch (degradationPreference) {
    case RTCDegradationPreferenceDisabled:
      return webrtc_mac_capturer::DegradationPreference::DISABLED;
    case RTCDegradationPreferenceMaintainFramerate:
      return webrtc_mac_capturer::DegradationPreference::MAINTAIN_FRAMERATE;
    case RTCDegradationPreferenceMaintainResolution:
      return webrtc_mac_capturer::DegradationPreference::MAINTAIN_RESOLUTION;
    case RTCDegradationPreferenceBalanced:
      return webrtc_mac_capturer::DegradationPreference::BALANCED;
  }
}

+ (NSNumber *)degradationPreferenceFromNativeDegradationPreference:
    (absl::optional<webrtc_mac_capturer::DegradationPreference>)nativeDegradationPreference {
  if (!nativeDegradationPreference.has_value()) {
    return nil;
  }

  switch (*nativeDegradationPreference) {
    case webrtc_mac_capturer::DegradationPreference::DISABLED:
      return @(RTCDegradationPreferenceDisabled);
    case webrtc_mac_capturer::DegradationPreference::MAINTAIN_FRAMERATE:
      return @(RTCDegradationPreferenceMaintainFramerate);
    case webrtc_mac_capturer::DegradationPreference::MAINTAIN_RESOLUTION:
      return @(RTCDegradationPreferenceMaintainResolution);
    case webrtc_mac_capturer::DegradationPreference::BALANCED:
      return @(RTCDegradationPreferenceBalanced);
  }
}

@end
