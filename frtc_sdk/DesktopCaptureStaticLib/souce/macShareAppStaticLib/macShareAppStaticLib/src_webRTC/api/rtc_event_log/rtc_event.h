/*
 *  Copyright (c) 2017 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef API_RTC_EVENT_LOG_RTC_EVENT_H_
#define API_RTC_EVENT_LOG_RTC_EVENT_H_

#include <cstdint>

namespace webrtc_mac_capturer {

// This class allows us to store unencoded RTC events. Subclasses of this class
// store the actual information. This allows us to keep all unencoded events,
// even when their type and associated information differ, in the same buffer.
// Additionally, it prevents dependency leaking - a module that only logs
// events of type RtcEvent_A doesn't need to know about anything associated
// with events of type RtcEvent_B.
class RtcEvent {
 public:
  // Subclasses of this class have to associate themselves with a unique value
  // of Type. This leaks the information of existing subclasses into the
  // superclass, but the *actual* information - rtclog::StreamConfig, etc. -
  // is kept separate.
  enum class Type {
    AlrStateEvent,
    RouteChangeEvent,
    RemoteEstimateEvent,
    AudioNetworkAdaptation,
    AudioPlayout,
    AudioReceiveStreamConfig,
    AudioSendStreamConfig,
    BweUpdateDelayBased,
    BweUpdateLossBased,
    DtlsTransportState,
    DtlsWritableState,
    IceCandidatePairConfig,
    IceCandidatePairEvent,
    ProbeClusterCreated,
    ProbeResultFailure,
    ProbeResultSuccess,
    RtcpPacketIncoming,
    RtcpPacketOutgoing,
    RtpPacketIncoming,
    RtpPacketOutgoing,
    VideoReceiveStreamConfig,
    VideoSendStreamConfig,
    GenericPacketSent,
    GenericPacketReceived,
    GenericAckReceived,
    FrameDecoded
  };

  RtcEvent();
  virtual ~RtcEvent() = default;

  virtual Type GetType() const = 0;

  virtual bool IsConfigEvent() const = 0;

  int64_t timestamp_ms() const { return timestamp_us_ / 1000; }
  int64_t timestamp_us() const { return timestamp_us_; }

 protected:
  explicit RtcEvent(int64_t timestamp_us) : timestamp_us_(timestamp_us) {}

  const int64_t timestamp_us_;
};

}  // namespace webrtc_mac_capturer

#endif  // API_RTC_EVENT_LOG_RTC_EVENT_H_
