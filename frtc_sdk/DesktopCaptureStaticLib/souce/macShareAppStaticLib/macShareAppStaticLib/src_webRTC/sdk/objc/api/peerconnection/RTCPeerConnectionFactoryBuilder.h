/*
 *  Copyright 2018 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "RTCPeerConnectionFactory.h"

#include "api/scoped_refptr.h"

namespace webrtc_mac_capturer {

class AudioDeviceModule;
class AudioEncoderFactory;
class AudioDecoderFactory;
class VideoEncoderFactory;
class VideoDecoderFactory;
class AudioProcessing;

}  // namespace webrtc_mac_capturer

NS_ASSUME_NONNULL_BEGIN

@interface RTCPeerConnectionFactoryBuilder : NSObject

+ (RTCPeerConnectionFactoryBuilder *)builder;

- (RTC_OBJC_TYPE(RTCPeerConnectionFactory) *)createPeerConnectionFactory;

- (void)setVideoEncoderFactory:(std::unique_ptr<webrtc_mac_capturer::VideoEncoderFactory>)videoEncoderFactory;

- (void)setVideoDecoderFactory:(std::unique_ptr<webrtc_mac_capturer::VideoDecoderFactory>)videoDecoderFactory;

- (void)setAudioEncoderFactory:(rtc::scoped_refptr<webrtc_mac_capturer::AudioEncoderFactory>)audioEncoderFactory;

- (void)setAudioDecoderFactory:(rtc::scoped_refptr<webrtc_mac_capturer::AudioDecoderFactory>)audioDecoderFactory;

- (void)setAudioDeviceModule:(rtc::scoped_refptr<webrtc_mac_capturer::AudioDeviceModule>)audioDeviceModule;

- (void)setAudioProcessingModule:(rtc::scoped_refptr<webrtc_mac_capturer::AudioProcessing>)audioProcessingModule;

@end

NS_ASSUME_NONNULL_END
