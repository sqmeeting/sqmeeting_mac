/*
 *  Copyright 2015 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "RTCPeerConnection.h"

#include "api/peer_connection_interface.h"

NS_ASSUME_NONNULL_BEGIN

namespace webrtc_mac_capturer {

/**
 * These objects are created by RTCPeerConnectionFactory to wrap an
 * id<RTCPeerConnectionDelegate> and call methods on that interface.
 */
class PeerConnectionDelegateAdapter : public PeerConnectionObserver {
 public:
  PeerConnectionDelegateAdapter(RTC_OBJC_TYPE(RTCPeerConnection) * peerConnection);
  ~PeerConnectionDelegateAdapter() override;

  void OnSignalingChange(PeerConnectionInterface::SignalingState new_state) override;

  void OnAddStream(rtc::scoped_refptr<MediaStreamInterface> stream) override;

  void OnRemoveStream(rtc::scoped_refptr<MediaStreamInterface> stream) override;

  void OnTrack(rtc::scoped_refptr<RtpTransceiverInterface> transceiver) override;

  void OnDataChannel(rtc::scoped_refptr<DataChannelInterface> data_channel) override;

  void OnRenegotiationNeeded() override;

  void OnIceConnectionChange(PeerConnectionInterface::IceConnectionState new_state) override;

  void OnStandardizedIceConnectionChange(
      PeerConnectionInterface::IceConnectionState new_state) override;

  void OnConnectionChange(PeerConnectionInterface::PeerConnectionState new_state) override;

  void OnIceGatheringChange(PeerConnectionInterface::IceGatheringState new_state) override;

  void OnIceCandidate(const IceCandidateInterface *candidate) override;

  void OnIceCandidatesRemoved(const std::vector<cricket::Candidate> &candidates) override;

  void OnIceSelectedCandidatePairChanged(const cricket::CandidatePairChangeEvent &event) override;

  void OnAddTrack(rtc::scoped_refptr<RtpReceiverInterface> receiver,
                  const std::vector<rtc::scoped_refptr<MediaStreamInterface>> &streams) override;

  void OnRemoveTrack(rtc::scoped_refptr<RtpReceiverInterface> receiver) override;

 private:
  __weak RTC_OBJC_TYPE(RTCPeerConnection) * peer_connection_;
};

}  // namespace webrtc_mac_capturer

@interface RTC_OBJC_TYPE (RTCPeerConnection)
()

    /** The factory used to create this RTCPeerConnection */
    @property(nonatomic, readonly) RTC_OBJC_TYPE(RTCPeerConnectionFactory) *
    factory;

/** The native PeerConnectionInterface created during construction. */
@property(nonatomic, readonly) rtc::scoped_refptr<webrtc_mac_capturer::PeerConnectionInterface>
    nativePeerConnection;

/** Initialize an RTCPeerConnection with a configuration, constraints, and
 *  delegate.
 */
- (nullable instancetype)initWithFactory:(RTC_OBJC_TYPE(RTCPeerConnectionFactory) *)factory
                           configuration:(RTC_OBJC_TYPE(RTCConfiguration) *)configuration
                             constraints:(RTC_OBJC_TYPE(RTCMediaConstraints) *)constraints
                                delegate:
                                    (nullable id<RTC_OBJC_TYPE(RTCPeerConnectionDelegate)>)delegate;

/** Initialize an RTCPeerConnection with a configuration, constraints,
 *  delegate and PeerConnectionDependencies.
 */
- (nullable instancetype)
    initWithDependencies:(RTC_OBJC_TYPE(RTCPeerConnectionFactory) *)factory
           configuration:(RTC_OBJC_TYPE(RTCConfiguration) *)configuration
             constraints:(RTC_OBJC_TYPE(RTCMediaConstraints) *)constraints
            dependencies:(std::unique_ptr<webrtc_mac_capturer::PeerConnectionDependencies>)dependencies
                delegate:(nullable id<RTC_OBJC_TYPE(RTCPeerConnectionDelegate)>)delegate
    NS_DESIGNATED_INITIALIZER;

+ (webrtc_mac_capturer::PeerConnectionInterface::SignalingState)nativeSignalingStateForState:
        (RTCSignalingState)state;

+ (RTCSignalingState)signalingStateForNativeState:
        (webrtc_mac_capturer::PeerConnectionInterface::SignalingState)nativeState;

+ (NSString *)stringForSignalingState:(RTCSignalingState)state;

+ (webrtc_mac_capturer::PeerConnectionInterface::IceConnectionState)nativeIceConnectionStateForState:
        (RTCIceConnectionState)state;

+ (webrtc_mac_capturer::PeerConnectionInterface::PeerConnectionState)nativeConnectionStateForState:
        (RTCPeerConnectionState)state;

+ (RTCIceConnectionState)iceConnectionStateForNativeState:
        (webrtc_mac_capturer::PeerConnectionInterface::IceConnectionState)nativeState;

+ (RTCPeerConnectionState)connectionStateForNativeState:
        (webrtc_mac_capturer::PeerConnectionInterface::PeerConnectionState)nativeState;

+ (NSString *)stringForIceConnectionState:(RTCIceConnectionState)state;

+ (NSString *)stringForConnectionState:(RTCPeerConnectionState)state;

+ (webrtc_mac_capturer::PeerConnectionInterface::IceGatheringState)nativeIceGatheringStateForState:
        (RTCIceGatheringState)state;

+ (RTCIceGatheringState)iceGatheringStateForNativeState:
        (webrtc_mac_capturer::PeerConnectionInterface::IceGatheringState)nativeState;

+ (NSString *)stringForIceGatheringState:(RTCIceGatheringState)state;

+ (webrtc_mac_capturer::PeerConnectionInterface::StatsOutputLevel)nativeStatsOutputLevelForLevel:
        (RTCStatsOutputLevel)level;

@end

NS_ASSUME_NONNULL_END
