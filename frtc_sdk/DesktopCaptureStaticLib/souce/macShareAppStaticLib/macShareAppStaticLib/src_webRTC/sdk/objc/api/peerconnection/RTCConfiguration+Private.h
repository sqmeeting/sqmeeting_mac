/*
 *  Copyright 2015 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "RTCConfiguration.h"

#include "api/peer_connection_interface.h"

NS_ASSUME_NONNULL_BEGIN

@interface RTC_OBJC_TYPE (RTCConfiguration)
()

    + (webrtc_mac_capturer::PeerConnectionInterface::IceTransportsType)nativeTransportsTypeForTransportPolicy
    : (RTCIceTransportPolicy)policy;

+ (RTCIceTransportPolicy)transportPolicyForTransportsType:
        (webrtc_mac_capturer::PeerConnectionInterface::IceTransportsType)nativeType;

+ (NSString *)stringForTransportPolicy:(RTCIceTransportPolicy)policy;

+ (webrtc_mac_capturer::PeerConnectionInterface::BundlePolicy)nativeBundlePolicyForPolicy:
        (RTCBundlePolicy)policy;

+ (RTCBundlePolicy)bundlePolicyForNativePolicy:
        (webrtc_mac_capturer::PeerConnectionInterface::BundlePolicy)nativePolicy;

+ (NSString *)stringForBundlePolicy:(RTCBundlePolicy)policy;

+ (webrtc_mac_capturer::PeerConnectionInterface::RtcpMuxPolicy)nativeRtcpMuxPolicyForPolicy:
        (RTCRtcpMuxPolicy)policy;

+ (RTCRtcpMuxPolicy)rtcpMuxPolicyForNativePolicy:
        (webrtc_mac_capturer::PeerConnectionInterface::RtcpMuxPolicy)nativePolicy;

+ (NSString *)stringForRtcpMuxPolicy:(RTCRtcpMuxPolicy)policy;

+ (webrtc_mac_capturer::PeerConnectionInterface::TcpCandidatePolicy)nativeTcpCandidatePolicyForPolicy:
        (RTCTcpCandidatePolicy)policy;

+ (RTCTcpCandidatePolicy)tcpCandidatePolicyForNativePolicy:
        (webrtc_mac_capturer::PeerConnectionInterface::TcpCandidatePolicy)nativePolicy;

+ (NSString *)stringForTcpCandidatePolicy:(RTCTcpCandidatePolicy)policy;

+ (webrtc_mac_capturer::PeerConnectionInterface::CandidateNetworkPolicy)nativeCandidateNetworkPolicyForPolicy:
        (RTCCandidateNetworkPolicy)policy;

+ (RTCCandidateNetworkPolicy)candidateNetworkPolicyForNativePolicy:
        (webrtc_mac_capturer::PeerConnectionInterface::CandidateNetworkPolicy)nativePolicy;

+ (NSString *)stringForCandidateNetworkPolicy:(RTCCandidateNetworkPolicy)policy;

+ (rtc::KeyType)nativeEncryptionKeyTypeForKeyType:(RTCEncryptionKeyType)keyType;

+ (webrtc_mac_capturer::SdpSemantics)nativeSdpSemanticsForSdpSemantics:(RTCSdpSemantics)sdpSemantics;

+ (RTCSdpSemantics)sdpSemanticsForNativeSdpSemantics:(webrtc_mac_capturer::SdpSemantics)sdpSemantics;

+ (NSString *)stringForSdpSemantics:(RTCSdpSemantics)sdpSemantics;

/**
 * RTCConfiguration struct representation of this RTCConfiguration.
 * This is needed to pass to the underlying C++ APIs.
 */
- (nullable webrtc_mac_capturer::PeerConnectionInterface::RTCConfiguration *)createNativeConfiguration;

- (instancetype)initWithNativeConfiguration:
        (const webrtc_mac_capturer::PeerConnectionInterface::RTCConfiguration &)config NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
