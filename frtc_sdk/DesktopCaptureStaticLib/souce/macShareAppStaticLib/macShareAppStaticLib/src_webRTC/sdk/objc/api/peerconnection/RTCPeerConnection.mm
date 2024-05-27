/*
 *  Copyright 2015 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "RTCPeerConnection+Private.h"

#import "RTCConfiguration+Private.h"
#import "RTCDataChannel+Private.h"
#import "RTCIceCandidate+Private.h"
#import "RTCLegacyStatsReport+Private.h"
#import "RTCMediaConstraints+Private.h"
#import "RTCMediaStream+Private.h"
#import "RTCMediaStreamTrack+Private.h"
#import "RTCPeerConnectionFactory+Private.h"
#import "RTCRtpReceiver+Private.h"
#import "RTCRtpSender+Private.h"
#import "RTCRtpTransceiver+Private.h"
#import "RTCSessionDescription+Private.h"
#import "base/RTCLogging.h"
#import "helpers/NSString+StdString.h"

#include <memory>

#include "api/jsep_ice_candidate.h"
#include "api/rtc_event_log_output_file.h"
#include "api/set_local_description_observer_interface.h"
#include "api/set_remote_description_observer_interface.h"
#include "rtc_base/checks.h"
#include "rtc_base/numerics/safe_conversions.h"

NSString *const kRTCPeerConnectionErrorDomain = @"org.webrtc.RTC_OBJC_TYPE(RTCPeerConnection)";
int const kRTCPeerConnnectionSessionDescriptionError = -1;

namespace {

class SetSessionDescriptionObserver : public webrtc_mac_capturer::SetLocalDescriptionObserverInterface,
                                      public webrtc_mac_capturer::SetRemoteDescriptionObserverInterface {
 public:
  SetSessionDescriptionObserver(RTCSetSessionDescriptionCompletionHandler completionHandler) {
    completion_handler_ = completionHandler;
  }

  virtual void OnSetLocalDescriptionComplete(webrtc_mac_capturer::RTCError error) override {
    OnCompelete(error);
  }

  virtual void OnSetRemoteDescriptionComplete(webrtc_mac_capturer::RTCError error) override {
    OnCompelete(error);
  }

 private:
  void OnCompelete(webrtc_mac_capturer::RTCError error) {
    RTC_DCHECK(completion_handler_ != nil);
    if (error.ok()) {
      completion_handler_(nil);
    } else {
      // TODO(hta): Add handling of error.type()
      NSString *str = [NSString stringForStdString:error.message()];
      NSError *err = [NSError errorWithDomain:kRTCPeerConnectionErrorDomain
                                         code:kRTCPeerConnnectionSessionDescriptionError
                                     userInfo:@{NSLocalizedDescriptionKey : str}];
      completion_handler_(err);
    }
    completion_handler_ = nil;
  }
  RTCSetSessionDescriptionCompletionHandler completion_handler_;
};

}  // anonymous namespace

namespace webrtc_mac_capturer {

class CreateSessionDescriptionObserverAdapter
    : public CreateSessionDescriptionObserver {
 public:
  CreateSessionDescriptionObserverAdapter(void (^completionHandler)(
      RTC_OBJC_TYPE(RTCSessionDescription) * sessionDescription, NSError *error)) {
    completion_handler_ = completionHandler;
  }

  ~CreateSessionDescriptionObserverAdapter() override { completion_handler_ = nil; }

  void OnSuccess(SessionDescriptionInterface *desc) override {
    RTC_DCHECK(completion_handler_);
    std::unique_ptr<webrtc_mac_capturer::SessionDescriptionInterface> description =
        std::unique_ptr<webrtc_mac_capturer::SessionDescriptionInterface>(desc);
    RTC_OBJC_TYPE(RTCSessionDescription) *session =
        [[RTC_OBJC_TYPE(RTCSessionDescription) alloc] initWithNativeDescription:description.get()];
    completion_handler_(session, nil);
    completion_handler_ = nil;
  }

  void OnFailure(RTCError error) override {
    RTC_DCHECK(completion_handler_);
    // TODO(hta): Add handling of error.type()
    NSString *str = [NSString stringForStdString:error.message()];
    NSError* err =
        [NSError errorWithDomain:kRTCPeerConnectionErrorDomain
                            code:kRTCPeerConnnectionSessionDescriptionError
                        userInfo:@{ NSLocalizedDescriptionKey : str }];
    completion_handler_(nil, err);
    completion_handler_ = nil;
  }

 private:
  void (^completion_handler_)(RTC_OBJC_TYPE(RTCSessionDescription) * sessionDescription,
                              NSError *error);
};

PeerConnectionDelegateAdapter::PeerConnectionDelegateAdapter(RTC_OBJC_TYPE(RTCPeerConnection) *
                                                             peerConnection) {
  peer_connection_ = peerConnection;
}

PeerConnectionDelegateAdapter::~PeerConnectionDelegateAdapter() {
  peer_connection_ = nil;
}

void PeerConnectionDelegateAdapter::OnSignalingChange(
    PeerConnectionInterface::SignalingState new_state) {
  RTCSignalingState state =
      [[RTC_OBJC_TYPE(RTCPeerConnection) class] signalingStateForNativeState:new_state];
  RTC_OBJC_TYPE(RTCPeerConnection) *peer_connection = peer_connection_;
  [peer_connection.delegate peerConnection:peer_connection
                   didChangeSignalingState:state];
}

void PeerConnectionDelegateAdapter::OnAddStream(
    rtc::scoped_refptr<MediaStreamInterface> stream) {
  RTC_OBJC_TYPE(RTCPeerConnection) *peer_connection = peer_connection_;
  RTC_OBJC_TYPE(RTCMediaStream) *mediaStream =
      [[RTC_OBJC_TYPE(RTCMediaStream) alloc] initWithFactory:peer_connection.factory
                                           nativeMediaStream:stream];
  [peer_connection.delegate peerConnection:peer_connection
                              didAddStream:mediaStream];
}

void PeerConnectionDelegateAdapter::OnRemoveStream(
    rtc::scoped_refptr<MediaStreamInterface> stream) {
  RTC_OBJC_TYPE(RTCPeerConnection) *peer_connection = peer_connection_;
  RTC_OBJC_TYPE(RTCMediaStream) *mediaStream =
      [[RTC_OBJC_TYPE(RTCMediaStream) alloc] initWithFactory:peer_connection.factory
                                           nativeMediaStream:stream];

  [peer_connection.delegate peerConnection:peer_connection
                           didRemoveStream:mediaStream];
}

void PeerConnectionDelegateAdapter::OnTrack(
    rtc::scoped_refptr<RtpTransceiverInterface> nativeTransceiver) {
  RTC_OBJC_TYPE(RTCPeerConnection) *peer_connection = peer_connection_;
  RTC_OBJC_TYPE(RTCRtpTransceiver) *transceiver =
      [[RTC_OBJC_TYPE(RTCRtpTransceiver) alloc] initWithFactory:peer_connection.factory
                                           nativeRtpTransceiver:nativeTransceiver];
  if ([peer_connection.delegate
          respondsToSelector:@selector(peerConnection:didStartReceivingOnTransceiver:)]) {
    [peer_connection.delegate peerConnection:peer_connection
              didStartReceivingOnTransceiver:transceiver];
  }
}

void PeerConnectionDelegateAdapter::OnDataChannel(
    rtc::scoped_refptr<DataChannelInterface> data_channel) {
  RTC_OBJC_TYPE(RTCPeerConnection) *peer_connection = peer_connection_;
  RTC_OBJC_TYPE(RTCDataChannel) *dataChannel =
      [[RTC_OBJC_TYPE(RTCDataChannel) alloc] initWithFactory:peer_connection.factory
                                           nativeDataChannel:data_channel];
  [peer_connection.delegate peerConnection:peer_connection
                        didOpenDataChannel:dataChannel];
}

void PeerConnectionDelegateAdapter::OnRenegotiationNeeded() {
  RTC_OBJC_TYPE(RTCPeerConnection) *peer_connection = peer_connection_;
  [peer_connection.delegate peerConnectionShouldNegotiate:peer_connection];
}

void PeerConnectionDelegateAdapter::OnIceConnectionChange(
    PeerConnectionInterface::IceConnectionState new_state) {
  RTCIceConnectionState state =
      [RTC_OBJC_TYPE(RTCPeerConnection) iceConnectionStateForNativeState:new_state];
  [peer_connection_.delegate peerConnection:peer_connection_ didChangeIceConnectionState:state];
}

void PeerConnectionDelegateAdapter::OnStandardizedIceConnectionChange(
    PeerConnectionInterface::IceConnectionState new_state) {
  if ([peer_connection_.delegate
          respondsToSelector:@selector(peerConnection:didChangeStandardizedIceConnectionState:)]) {
    RTCIceConnectionState state =
        [RTC_OBJC_TYPE(RTCPeerConnection) iceConnectionStateForNativeState:new_state];
    [peer_connection_.delegate peerConnection:peer_connection_
        didChangeStandardizedIceConnectionState:state];
  }
}

void PeerConnectionDelegateAdapter::OnConnectionChange(
    PeerConnectionInterface::PeerConnectionState new_state) {
  if ([peer_connection_.delegate
          respondsToSelector:@selector(peerConnection:didChangeConnectionState:)]) {
    RTCPeerConnectionState state =
        [RTC_OBJC_TYPE(RTCPeerConnection) connectionStateForNativeState:new_state];
    [peer_connection_.delegate peerConnection:peer_connection_ didChangeConnectionState:state];
  }
}

void PeerConnectionDelegateAdapter::OnIceGatheringChange(
    PeerConnectionInterface::IceGatheringState new_state) {
  RTCIceGatheringState state =
      [[RTC_OBJC_TYPE(RTCPeerConnection) class] iceGatheringStateForNativeState:new_state];
  RTC_OBJC_TYPE(RTCPeerConnection) *peer_connection = peer_connection_;
  [peer_connection.delegate peerConnection:peer_connection
                didChangeIceGatheringState:state];
}

void PeerConnectionDelegateAdapter::OnIceCandidate(
    const IceCandidateInterface *candidate) {
  RTC_OBJC_TYPE(RTCIceCandidate) *iceCandidate =
      [[RTC_OBJC_TYPE(RTCIceCandidate) alloc] initWithNativeCandidate:candidate];
  RTC_OBJC_TYPE(RTCPeerConnection) *peer_connection = peer_connection_;
  [peer_connection.delegate peerConnection:peer_connection
                   didGenerateIceCandidate:iceCandidate];
}

void PeerConnectionDelegateAdapter::OnIceCandidatesRemoved(
    const std::vector<cricket::Candidate>& candidates) {
  NSMutableArray* ice_candidates =
      [NSMutableArray arrayWithCapacity:candidates.size()];
  for (const auto& candidate : candidates) {
    std::unique_ptr<JsepIceCandidate> candidate_wrapper(
        new JsepIceCandidate(candidate.transport_name(), -1, candidate));
    RTC_OBJC_TYPE(RTCIceCandidate) *ice_candidate =
        [[RTC_OBJC_TYPE(RTCIceCandidate) alloc] initWithNativeCandidate:candidate_wrapper.get()];
    [ice_candidates addObject:ice_candidate];
  }
  RTC_OBJC_TYPE(RTCPeerConnection) *peer_connection = peer_connection_;
  [peer_connection.delegate peerConnection:peer_connection
                    didRemoveIceCandidates:ice_candidates];
}

void PeerConnectionDelegateAdapter::OnIceSelectedCandidatePairChanged(
    const cricket::CandidatePairChangeEvent &event) {
  const auto &selected_pair = event.selected_candidate_pair;
  auto local_candidate_wrapper = std::make_unique<JsepIceCandidate>(
      selected_pair.local_candidate().transport_name(), -1, selected_pair.local_candidate());
  RTC_OBJC_TYPE(RTCIceCandidate) *local_candidate = [[RTC_OBJC_TYPE(RTCIceCandidate) alloc]
      initWithNativeCandidate:local_candidate_wrapper.release()];
  auto remote_candidate_wrapper = std::make_unique<JsepIceCandidate>(
      selected_pair.remote_candidate().transport_name(), -1, selected_pair.remote_candidate());
  RTC_OBJC_TYPE(RTCIceCandidate) *remote_candidate = [[RTC_OBJC_TYPE(RTCIceCandidate) alloc]
      initWithNativeCandidate:remote_candidate_wrapper.release()];
  RTC_OBJC_TYPE(RTCPeerConnection) *peer_connection = peer_connection_;
  NSString *nsstr_reason = [NSString stringForStdString:event.reason];
  if ([peer_connection.delegate
          respondsToSelector:@selector
          (peerConnection:didChangeLocalCandidate:remoteCandidate:lastReceivedMs:changeReason:)]) {
    [peer_connection.delegate peerConnection:peer_connection
                     didChangeLocalCandidate:local_candidate
                             remoteCandidate:remote_candidate
                              lastReceivedMs:event.last_data_received_ms
                                changeReason:nsstr_reason];
  }
}

void PeerConnectionDelegateAdapter::OnAddTrack(
    rtc::scoped_refptr<RtpReceiverInterface> receiver,
    const std::vector<rtc::scoped_refptr<MediaStreamInterface>> &streams) {
  RTC_OBJC_TYPE(RTCPeerConnection) *peer_connection = peer_connection_;
  if ([peer_connection.delegate respondsToSelector:@selector(peerConnection:
                                                             didAddReceiver:streams:)]) {
    NSMutableArray *mediaStreams = [NSMutableArray arrayWithCapacity:streams.size()];
    for (const auto &nativeStream : streams) {
      RTC_OBJC_TYPE(RTCMediaStream) *mediaStream =
          [[RTC_OBJC_TYPE(RTCMediaStream) alloc] initWithFactory:peer_connection.factory
                                               nativeMediaStream:nativeStream];
      [mediaStreams addObject:mediaStream];
    }
    RTC_OBJC_TYPE(RTCRtpReceiver) *rtpReceiver =
        [[RTC_OBJC_TYPE(RTCRtpReceiver) alloc] initWithFactory:peer_connection.factory
                                             nativeRtpReceiver:receiver];

    [peer_connection.delegate peerConnection:peer_connection
                              didAddReceiver:rtpReceiver
                                     streams:mediaStreams];
  }
}

void PeerConnectionDelegateAdapter::OnRemoveTrack(
    rtc::scoped_refptr<RtpReceiverInterface> receiver) {
  RTC_OBJC_TYPE(RTCPeerConnection) *peer_connection = peer_connection_;
  if ([peer_connection.delegate respondsToSelector:@selector(peerConnection:didRemoveReceiver:)]) {
    RTC_OBJC_TYPE(RTCRtpReceiver) *rtpReceiver =
        [[RTC_OBJC_TYPE(RTCRtpReceiver) alloc] initWithFactory:peer_connection.factory
                                             nativeRtpReceiver:receiver];
    [peer_connection.delegate peerConnection:peer_connection didRemoveReceiver:rtpReceiver];
  }
}

}  // namespace webrtc_mac_capturer

@implementation RTC_OBJC_TYPE (RTCPeerConnection) {
  RTC_OBJC_TYPE(RTCPeerConnectionFactory) * _factory;
  NSMutableArray<RTC_OBJC_TYPE(RTCMediaStream) *> *_localStreams;
  std::unique_ptr<webrtc_mac_capturer::PeerConnectionDelegateAdapter> _observer;
  rtc::scoped_refptr<webrtc_mac_capturer::PeerConnectionInterface> _peerConnection;
  std::unique_ptr<webrtc_mac_capturer::MediaConstraints> _nativeConstraints;
  BOOL _hasStartedRtcEventLog;
}

@synthesize delegate = _delegate;
@synthesize factory = _factory;

- (nullable instancetype)initWithFactory:(RTC_OBJC_TYPE(RTCPeerConnectionFactory) *)factory
                           configuration:(RTC_OBJC_TYPE(RTCConfiguration) *)configuration
                             constraints:(RTC_OBJC_TYPE(RTCMediaConstraints) *)constraints
                                delegate:(id<RTC_OBJC_TYPE(RTCPeerConnectionDelegate)>)delegate {
  NSParameterAssert(factory);
  std::unique_ptr<webrtc_mac_capturer::PeerConnectionDependencies> dependencies =
      std::make_unique<webrtc_mac_capturer::PeerConnectionDependencies>(nullptr);
  return [self initWithDependencies:factory
                      configuration:configuration
                        constraints:constraints
                       dependencies:std::move(dependencies)
                           delegate:delegate];
}

- (nullable instancetype)
    initWithDependencies:(RTC_OBJC_TYPE(RTCPeerConnectionFactory) *)factory
           configuration:(RTC_OBJC_TYPE(RTCConfiguration) *)configuration
             constraints:(RTC_OBJC_TYPE(RTCMediaConstraints) *)constraints
            dependencies:(std::unique_ptr<webrtc_mac_capturer::PeerConnectionDependencies>)dependencies
                delegate:(id<RTC_OBJC_TYPE(RTCPeerConnectionDelegate)>)delegate {
  NSParameterAssert(factory);
  NSParameterAssert(dependencies.get());
  std::unique_ptr<webrtc_mac_capturer::PeerConnectionInterface::RTCConfiguration> config(
      [configuration createNativeConfiguration]);
  if (!config) {
    return nil;
  }
  if (self = [super init]) {
    _observer.reset(new webrtc_mac_capturer::PeerConnectionDelegateAdapter(self));
    _nativeConstraints = constraints.nativeConstraints;
    CopyConstraintsIntoRtcConfiguration(_nativeConstraints.get(), config.get());

    webrtc_mac_capturer::PeerConnectionDependencies deps = std::move(*dependencies.release());
    deps.observer = _observer.get();
    auto result = factory.nativeFactory->CreatePeerConnectionOrError(*config, std::move(deps));

    if (!result.ok()) {
      return nil;
    }
    _peerConnection = result.MoveValue();
    _factory = factory;
    _localStreams = [[NSMutableArray alloc] init];
    _delegate = delegate;
  }
  return self;
}

- (NSArray<RTC_OBJC_TYPE(RTCMediaStream) *> *)localStreams {
  return [_localStreams copy];
}

- (RTC_OBJC_TYPE(RTCSessionDescription) *)localDescription {
  // It's only safe to operate on SessionDescriptionInterface on the signaling thread.
  return _peerConnection->signaling_thread()->Invoke<RTC_OBJC_TYPE(RTCSessionDescription) *>(
      RTC_FROM_HERE, [self] {
        const webrtc_mac_capturer::SessionDescriptionInterface *description =
            _peerConnection->local_description();
        return description ?
            [[RTC_OBJC_TYPE(RTCSessionDescription) alloc] initWithNativeDescription:description] :
            nil;
      });
}

- (RTC_OBJC_TYPE(RTCSessionDescription) *)remoteDescription {
  // It's only safe to operate on SessionDescriptionInterface on the signaling thread.
  return _peerConnection->signaling_thread()->Invoke<RTC_OBJC_TYPE(RTCSessionDescription) *>(
      RTC_FROM_HERE, [self] {
        const webrtc_mac_capturer::SessionDescriptionInterface *description =
            _peerConnection->remote_description();
        return description ?
            [[RTC_OBJC_TYPE(RTCSessionDescription) alloc] initWithNativeDescription:description] :
            nil;
      });
}

- (RTCSignalingState)signalingState {
  return [[self class]
      signalingStateForNativeState:_peerConnection->signaling_state()];
}

- (RTCIceConnectionState)iceConnectionState {
  return [[self class] iceConnectionStateForNativeState:
      _peerConnection->ice_connection_state()];
}

- (RTCPeerConnectionState)connectionState {
  return [[self class] connectionStateForNativeState:_peerConnection->peer_connection_state()];
}

- (RTCIceGatheringState)iceGatheringState {
  return [[self class] iceGatheringStateForNativeState:
      _peerConnection->ice_gathering_state()];
}

- (BOOL)setConfiguration:(RTC_OBJC_TYPE(RTCConfiguration) *)configuration {
  std::unique_ptr<webrtc_mac_capturer::PeerConnectionInterface::RTCConfiguration> config(
      [configuration createNativeConfiguration]);
  if (!config) {
    return NO;
  }
  CopyConstraintsIntoRtcConfiguration(_nativeConstraints.get(),
                                      config.get());
  return _peerConnection->SetConfiguration(*config).ok();
}

- (RTC_OBJC_TYPE(RTCConfiguration) *)configuration {
  webrtc_mac_capturer::PeerConnectionInterface::RTCConfiguration config =
    _peerConnection->GetConfiguration();
  return [[RTC_OBJC_TYPE(RTCConfiguration) alloc] initWithNativeConfiguration:config];
}

- (void)close {
  _peerConnection->Close();
}

- (void)addIceCandidate:(RTC_OBJC_TYPE(RTCIceCandidate) *)candidate {
  std::unique_ptr<const webrtc_mac_capturer::IceCandidateInterface> iceCandidate(
      candidate.nativeCandidate);
  _peerConnection->AddIceCandidate(iceCandidate.get());
}
- (void)addIceCandidate:(RTC_OBJC_TYPE(RTCIceCandidate) *)candidate
      completionHandler:(void (^)(NSError *_Nullable error))completionHandler {
  RTC_DCHECK(completionHandler != nil);
  _peerConnection->AddIceCandidate(
      candidate.nativeCandidate, [completionHandler](const auto &error) {
        if (error.ok()) {
          completionHandler(nil);
        } else {
          NSString *str = [NSString stringForStdString:error.message()];
          NSError *err = [NSError errorWithDomain:kRTCPeerConnectionErrorDomain
                                             code:static_cast<NSInteger>(error.type())
                                         userInfo:@{NSLocalizedDescriptionKey : str}];
          completionHandler(err);
        }
      });
}
- (void)removeIceCandidates:(NSArray<RTC_OBJC_TYPE(RTCIceCandidate) *> *)iceCandidates {
  std::vector<cricket::Candidate> candidates;
  for (RTC_OBJC_TYPE(RTCIceCandidate) * iceCandidate in iceCandidates) {
    std::unique_ptr<const webrtc_mac_capturer::IceCandidateInterface> candidate(
        iceCandidate.nativeCandidate);
    if (candidate) {
      candidates.push_back(candidate->candidate());
      // Need to fill the transport name from the sdp_mid.
      candidates.back().set_transport_name(candidate->sdp_mid());
    }
  }
  if (!candidates.empty()) {
    _peerConnection->RemoveIceCandidates(candidates);
  }
}

- (void)addStream:(RTC_OBJC_TYPE(RTCMediaStream) *)stream {
  if (!_peerConnection->AddStream(stream.nativeMediaStream)) {
    RTCLogError(@"Failed to add stream: %@", stream);
    return;
  }
  [_localStreams addObject:stream];
}

- (void)removeStream:(RTC_OBJC_TYPE(RTCMediaStream) *)stream {
  _peerConnection->RemoveStream(stream.nativeMediaStream);
  [_localStreams removeObject:stream];
}

- (nullable RTC_OBJC_TYPE(RTCRtpSender) *)addTrack:(RTC_OBJC_TYPE(RTCMediaStreamTrack) *)track
                                         streamIds:(NSArray<NSString *> *)streamIds {
  std::vector<std::string> nativeStreamIds;
  for (NSString *streamId in streamIds) {
    nativeStreamIds.push_back([streamId UTF8String]);
  }
  webrtc_mac_capturer::RTCErrorOr<rtc::scoped_refptr<webrtc_mac_capturer::RtpSenderInterface>> nativeSenderOrError =
      _peerConnection->AddTrack(track.nativeTrack, nativeStreamIds);
  if (!nativeSenderOrError.ok()) {
    RTCLogError(@"Failed to add track %@: %s", track, nativeSenderOrError.error().message());
    return nil;
  }
  return [[RTC_OBJC_TYPE(RTCRtpSender) alloc] initWithFactory:self.factory
                                              nativeRtpSender:nativeSenderOrError.MoveValue()];
}

- (BOOL)removeTrack:(RTC_OBJC_TYPE(RTCRtpSender) *)sender {
  bool result = _peerConnection->RemoveTrack(sender.nativeRtpSender);
  if (!result) {
    RTCLogError(@"Failed to remote track %@", sender);
  }
  return result;
}

- (nullable RTC_OBJC_TYPE(RTCRtpTransceiver) *)addTransceiverWithTrack:
    (RTC_OBJC_TYPE(RTCMediaStreamTrack) *)track {
  return [self addTransceiverWithTrack:track
                                  init:[[RTC_OBJC_TYPE(RTCRtpTransceiverInit) alloc] init]];
}

- (nullable RTC_OBJC_TYPE(RTCRtpTransceiver) *)
    addTransceiverWithTrack:(RTC_OBJC_TYPE(RTCMediaStreamTrack) *)track
                       init:(RTC_OBJC_TYPE(RTCRtpTransceiverInit) *)init {
  webrtc_mac_capturer::RTCErrorOr<rtc::scoped_refptr<webrtc_mac_capturer::RtpTransceiverInterface>> nativeTransceiverOrError =
      _peerConnection->AddTransceiver(track.nativeTrack, init.nativeInit);
  if (!nativeTransceiverOrError.ok()) {
    RTCLogError(
        @"Failed to add transceiver %@: %s", track, nativeTransceiverOrError.error().message());
    return nil;
  }
  return [[RTC_OBJC_TYPE(RTCRtpTransceiver) alloc]
           initWithFactory:self.factory
      nativeRtpTransceiver:nativeTransceiverOrError.MoveValue()];
}

- (nullable RTC_OBJC_TYPE(RTCRtpTransceiver) *)addTransceiverOfType:(RTCRtpMediaType)mediaType {
  return [self addTransceiverOfType:mediaType
                               init:[[RTC_OBJC_TYPE(RTCRtpTransceiverInit) alloc] init]];
}

- (nullable RTC_OBJC_TYPE(RTCRtpTransceiver) *)
    addTransceiverOfType:(RTCRtpMediaType)mediaType
                    init:(RTC_OBJC_TYPE(RTCRtpTransceiverInit) *)init {
  webrtc_mac_capturer::RTCErrorOr<rtc::scoped_refptr<webrtc_mac_capturer::RtpTransceiverInterface>> nativeTransceiverOrError =
      _peerConnection->AddTransceiver(
          [RTC_OBJC_TYPE(RTCRtpReceiver) nativeMediaTypeForMediaType:mediaType], init.nativeInit);
  if (!nativeTransceiverOrError.ok()) {
    RTCLogError(@"Failed to add transceiver %@: %s",
                [RTC_OBJC_TYPE(RTCRtpReceiver) stringForMediaType:mediaType],
                nativeTransceiverOrError.error().message());
    return nil;
  }
  return [[RTC_OBJC_TYPE(RTCRtpTransceiver) alloc]
           initWithFactory:self.factory
      nativeRtpTransceiver:nativeTransceiverOrError.MoveValue()];
}

- (void)restartIce {
  _peerConnection->RestartIce();
}

- (void)offerForConstraints:(RTC_OBJC_TYPE(RTCMediaConstraints) *)constraints
          completionHandler:(RTCCreateSessionDescriptionCompletionHandler)completionHandler {
  RTC_DCHECK(completionHandler != nil);
  rtc::scoped_refptr<webrtc_mac_capturer::CreateSessionDescriptionObserverAdapter>
      observer(new rtc::RefCountedObject
          <webrtc_mac_capturer::CreateSessionDescriptionObserverAdapter>(completionHandler));
  webrtc_mac_capturer::PeerConnectionInterface::RTCOfferAnswerOptions options;
  CopyConstraintsIntoOfferAnswerOptions(constraints.nativeConstraints.get(), &options);

  _peerConnection->CreateOffer(observer, options);
}

- (void)answerForConstraints:(RTC_OBJC_TYPE(RTCMediaConstraints) *)constraints
           completionHandler:(RTCCreateSessionDescriptionCompletionHandler)completionHandler {
  RTC_DCHECK(completionHandler != nil);
  rtc::scoped_refptr<webrtc_mac_capturer::CreateSessionDescriptionObserverAdapter>
      observer(new rtc::RefCountedObject
          <webrtc_mac_capturer::CreateSessionDescriptionObserverAdapter>(completionHandler));
  webrtc_mac_capturer::PeerConnectionInterface::RTCOfferAnswerOptions options;
  CopyConstraintsIntoOfferAnswerOptions(constraints.nativeConstraints.get(), &options);

  _peerConnection->CreateAnswer(observer, options);
}

- (void)setLocalDescription:(RTC_OBJC_TYPE(RTCSessionDescription) *)sdp
          completionHandler:(RTCSetSessionDescriptionCompletionHandler)completionHandler {
  RTC_DCHECK(completionHandler != nil);
  rtc::scoped_refptr<webrtc_mac_capturer::SetLocalDescriptionObserverInterface> observer(
      new rtc::RefCountedObject<::SetSessionDescriptionObserver>(completionHandler));
  _peerConnection->SetLocalDescription(sdp.nativeDescription, observer);
}

- (void)setLocalDescriptionWithCompletionHandler:
    (RTCSetSessionDescriptionCompletionHandler)completionHandler {
  RTC_DCHECK(completionHandler != nil);
  rtc::scoped_refptr<webrtc_mac_capturer::SetLocalDescriptionObserverInterface> observer(
      new rtc::RefCountedObject<::SetSessionDescriptionObserver>(completionHandler));
  _peerConnection->SetLocalDescription(observer);
}

- (void)setRemoteDescription:(RTC_OBJC_TYPE(RTCSessionDescription) *)sdp
           completionHandler:(RTCSetSessionDescriptionCompletionHandler)completionHandler {
  RTC_DCHECK(completionHandler != nil);
  rtc::scoped_refptr<webrtc_mac_capturer::SetRemoteDescriptionObserverInterface> observer(
      new rtc::RefCountedObject<::SetSessionDescriptionObserver>(completionHandler));
  _peerConnection->SetRemoteDescription(sdp.nativeDescription, observer);
}

- (BOOL)setBweMinBitrateBps:(nullable NSNumber *)minBitrateBps
          currentBitrateBps:(nullable NSNumber *)currentBitrateBps
              maxBitrateBps:(nullable NSNumber *)maxBitrateBps {
  webrtc_mac_capturer::BitrateSettings params;
  if (minBitrateBps != nil) {
    params.min_bitrate_bps = absl::optional<int>(minBitrateBps.intValue);
  }
  if (currentBitrateBps != nil) {
    params.start_bitrate_bps = absl::optional<int>(currentBitrateBps.intValue);
  }
  if (maxBitrateBps != nil) {
    params.max_bitrate_bps = absl::optional<int>(maxBitrateBps.intValue);
  }
  return _peerConnection->SetBitrate(params).ok();
}

- (BOOL)startRtcEventLogWithFilePath:(NSString *)filePath
                      maxSizeInBytes:(int64_t)maxSizeInBytes {
  RTC_DCHECK(filePath.length);
  RTC_DCHECK_GT(maxSizeInBytes, 0);
  RTC_DCHECK(!_hasStartedRtcEventLog);
  if (_hasStartedRtcEventLog) {
    RTCLogError(@"Event logging already started.");
    return NO;
  }
  FILE *f = fopen(filePath.UTF8String, "wb");
  if (!f) {
    RTCLogError(@"Error opening file: %@. Error: %d", filePath, errno);
    return NO;
  }
  // TODO(eladalon): It would be better to not allow negative values into PC.
  const size_t max_size = (maxSizeInBytes < 0) ? webrtc_mac_capturer::RtcEventLog::kUnlimitedOutput :
                                                 rtc::saturated_cast<size_t>(maxSizeInBytes);

  _hasStartedRtcEventLog = _peerConnection->StartRtcEventLog(
      std::make_unique<webrtc_mac_capturer::RtcEventLogOutputFile>(f, max_size));
  return _hasStartedRtcEventLog;
}

- (void)stopRtcEventLog {
  _peerConnection->StopRtcEventLog();
  _hasStartedRtcEventLog = NO;
}

- (RTC_OBJC_TYPE(RTCRtpSender) *)senderWithKind:(NSString *)kind streamId:(NSString *)streamId {
  std::string nativeKind = [NSString stdStringForString:kind];
  std::string nativeStreamId = [NSString stdStringForString:streamId];
  rtc::scoped_refptr<webrtc_mac_capturer::RtpSenderInterface> nativeSender(
      _peerConnection->CreateSender(nativeKind, nativeStreamId));
  return nativeSender ? [[RTC_OBJC_TYPE(RTCRtpSender) alloc] initWithFactory:self.factory
                                                             nativeRtpSender:nativeSender] :
                        nil;
}

- (NSArray<RTC_OBJC_TYPE(RTCRtpSender) *> *)senders {
  std::vector<rtc::scoped_refptr<webrtc_mac_capturer::RtpSenderInterface>> nativeSenders(
      _peerConnection->GetSenders());
  NSMutableArray *senders = [[NSMutableArray alloc] init];
  for (const auto &nativeSender : nativeSenders) {
    RTC_OBJC_TYPE(RTCRtpSender) *sender =
        [[RTC_OBJC_TYPE(RTCRtpSender) alloc] initWithFactory:self.factory
                                             nativeRtpSender:nativeSender];
    [senders addObject:sender];
  }
  return senders;
}

- (NSArray<RTC_OBJC_TYPE(RTCRtpReceiver) *> *)receivers {
  std::vector<rtc::scoped_refptr<webrtc_mac_capturer::RtpReceiverInterface>> nativeReceivers(
      _peerConnection->GetReceivers());
  NSMutableArray *receivers = [[NSMutableArray alloc] init];
  for (const auto &nativeReceiver : nativeReceivers) {
    RTC_OBJC_TYPE(RTCRtpReceiver) *receiver =
        [[RTC_OBJC_TYPE(RTCRtpReceiver) alloc] initWithFactory:self.factory
                                             nativeRtpReceiver:nativeReceiver];
    [receivers addObject:receiver];
  }
  return receivers;
}

- (NSArray<RTC_OBJC_TYPE(RTCRtpTransceiver) *> *)transceivers {
  std::vector<rtc::scoped_refptr<webrtc_mac_capturer::RtpTransceiverInterface>> nativeTransceivers(
      _peerConnection->GetTransceivers());
  NSMutableArray *transceivers = [[NSMutableArray alloc] init];
  for (const auto &nativeTransceiver : nativeTransceivers) {
    RTC_OBJC_TYPE(RTCRtpTransceiver) *transceiver =
        [[RTC_OBJC_TYPE(RTCRtpTransceiver) alloc] initWithFactory:self.factory
                                             nativeRtpTransceiver:nativeTransceiver];
    [transceivers addObject:transceiver];
  }
  return transceivers;
}

#pragma mark - Private

+ (webrtc_mac_capturer::PeerConnectionInterface::SignalingState)nativeSignalingStateForState:
    (RTCSignalingState)state {
  switch (state) {
    case RTCSignalingStateStable:
      return webrtc_mac_capturer::PeerConnectionInterface::kStable;
    case RTCSignalingStateHaveLocalOffer:
      return webrtc_mac_capturer::PeerConnectionInterface::kHaveLocalOffer;
    case RTCSignalingStateHaveLocalPrAnswer:
      return webrtc_mac_capturer::PeerConnectionInterface::kHaveLocalPrAnswer;
    case RTCSignalingStateHaveRemoteOffer:
      return webrtc_mac_capturer::PeerConnectionInterface::kHaveRemoteOffer;
    case RTCSignalingStateHaveRemotePrAnswer:
      return webrtc_mac_capturer::PeerConnectionInterface::kHaveRemotePrAnswer;
    case RTCSignalingStateClosed:
      return webrtc_mac_capturer::PeerConnectionInterface::kClosed;
  }
}

+ (RTCSignalingState)signalingStateForNativeState:
    (webrtc_mac_capturer::PeerConnectionInterface::SignalingState)nativeState {
  switch (nativeState) {
    case webrtc_mac_capturer::PeerConnectionInterface::kStable:
      return RTCSignalingStateStable;
    case webrtc_mac_capturer::PeerConnectionInterface::kHaveLocalOffer:
      return RTCSignalingStateHaveLocalOffer;
    case webrtc_mac_capturer::PeerConnectionInterface::kHaveLocalPrAnswer:
      return RTCSignalingStateHaveLocalPrAnswer;
    case webrtc_mac_capturer::PeerConnectionInterface::kHaveRemoteOffer:
      return RTCSignalingStateHaveRemoteOffer;
    case webrtc_mac_capturer::PeerConnectionInterface::kHaveRemotePrAnswer:
      return RTCSignalingStateHaveRemotePrAnswer;
    case webrtc_mac_capturer::PeerConnectionInterface::kClosed:
      return RTCSignalingStateClosed;
  }
}

+ (NSString *)stringForSignalingState:(RTCSignalingState)state {
  switch (state) {
    case RTCSignalingStateStable:
      return @"STABLE";
    case RTCSignalingStateHaveLocalOffer:
      return @"HAVE_LOCAL_OFFER";
    case RTCSignalingStateHaveLocalPrAnswer:
      return @"HAVE_LOCAL_PRANSWER";
    case RTCSignalingStateHaveRemoteOffer:
      return @"HAVE_REMOTE_OFFER";
    case RTCSignalingStateHaveRemotePrAnswer:
      return @"HAVE_REMOTE_PRANSWER";
    case RTCSignalingStateClosed:
      return @"CLOSED";
  }
}

+ (webrtc_mac_capturer::PeerConnectionInterface::PeerConnectionState)nativeConnectionStateForState:
        (RTCPeerConnectionState)state {
  switch (state) {
    case RTCPeerConnectionStateNew:
      return webrtc_mac_capturer::PeerConnectionInterface::PeerConnectionState::kNew;
    case RTCPeerConnectionStateConnecting:
      return webrtc_mac_capturer::PeerConnectionInterface::PeerConnectionState::kConnecting;
    case RTCPeerConnectionStateConnected:
      return webrtc_mac_capturer::PeerConnectionInterface::PeerConnectionState::kConnected;
    case RTCPeerConnectionStateFailed:
      return webrtc_mac_capturer::PeerConnectionInterface::PeerConnectionState::kFailed;
    case RTCPeerConnectionStateDisconnected:
      return webrtc_mac_capturer::PeerConnectionInterface::PeerConnectionState::kDisconnected;
    case RTCPeerConnectionStateClosed:
      return webrtc_mac_capturer::PeerConnectionInterface::PeerConnectionState::kClosed;
  }
}

+ (RTCPeerConnectionState)connectionStateForNativeState:
        (webrtc_mac_capturer::PeerConnectionInterface::PeerConnectionState)nativeState {
  switch (nativeState) {
    case webrtc_mac_capturer::PeerConnectionInterface::PeerConnectionState::kNew:
      return RTCPeerConnectionStateNew;
    case webrtc_mac_capturer::PeerConnectionInterface::PeerConnectionState::kConnecting:
      return RTCPeerConnectionStateConnecting;
    case webrtc_mac_capturer::PeerConnectionInterface::PeerConnectionState::kConnected:
      return RTCPeerConnectionStateConnected;
    case webrtc_mac_capturer::PeerConnectionInterface::PeerConnectionState::kFailed:
      return RTCPeerConnectionStateFailed;
    case webrtc_mac_capturer::PeerConnectionInterface::PeerConnectionState::kDisconnected:
      return RTCPeerConnectionStateDisconnected;
    case webrtc_mac_capturer::PeerConnectionInterface::PeerConnectionState::kClosed:
      return RTCPeerConnectionStateClosed;
  }
}

+ (NSString *)stringForConnectionState:(RTCPeerConnectionState)state {
  switch (state) {
    case RTCPeerConnectionStateNew:
      return @"NEW";
    case RTCPeerConnectionStateConnecting:
      return @"CONNECTING";
    case RTCPeerConnectionStateConnected:
      return @"CONNECTED";
    case RTCPeerConnectionStateFailed:
      return @"FAILED";
    case RTCPeerConnectionStateDisconnected:
      return @"DISCONNECTED";
    case RTCPeerConnectionStateClosed:
      return @"CLOSED";
  }
}

+ (webrtc_mac_capturer::PeerConnectionInterface::IceConnectionState)
    nativeIceConnectionStateForState:(RTCIceConnectionState)state {
  switch (state) {
    case RTCIceConnectionStateNew:
      return webrtc_mac_capturer::PeerConnectionInterface::kIceConnectionNew;
    case RTCIceConnectionStateChecking:
      return webrtc_mac_capturer::PeerConnectionInterface::kIceConnectionChecking;
    case RTCIceConnectionStateConnected:
      return webrtc_mac_capturer::PeerConnectionInterface::kIceConnectionConnected;
    case RTCIceConnectionStateCompleted:
      return webrtc_mac_capturer::PeerConnectionInterface::kIceConnectionCompleted;
    case RTCIceConnectionStateFailed:
      return webrtc_mac_capturer::PeerConnectionInterface::kIceConnectionFailed;
    case RTCIceConnectionStateDisconnected:
      return webrtc_mac_capturer::PeerConnectionInterface::kIceConnectionDisconnected;
    case RTCIceConnectionStateClosed:
      return webrtc_mac_capturer::PeerConnectionInterface::kIceConnectionClosed;
    case RTCIceConnectionStateCount:
      return webrtc_mac_capturer::PeerConnectionInterface::kIceConnectionMax;
  }
}

+ (RTCIceConnectionState)iceConnectionStateForNativeState:
    (webrtc_mac_capturer::PeerConnectionInterface::IceConnectionState)nativeState {
  switch (nativeState) {
    case webrtc_mac_capturer::PeerConnectionInterface::kIceConnectionNew:
      return RTCIceConnectionStateNew;
    case webrtc_mac_capturer::PeerConnectionInterface::kIceConnectionChecking:
      return RTCIceConnectionStateChecking;
    case webrtc_mac_capturer::PeerConnectionInterface::kIceConnectionConnected:
      return RTCIceConnectionStateConnected;
    case webrtc_mac_capturer::PeerConnectionInterface::kIceConnectionCompleted:
      return RTCIceConnectionStateCompleted;
    case webrtc_mac_capturer::PeerConnectionInterface::kIceConnectionFailed:
      return RTCIceConnectionStateFailed;
    case webrtc_mac_capturer::PeerConnectionInterface::kIceConnectionDisconnected:
      return RTCIceConnectionStateDisconnected;
    case webrtc_mac_capturer::PeerConnectionInterface::kIceConnectionClosed:
      return RTCIceConnectionStateClosed;
    case webrtc_mac_capturer::PeerConnectionInterface::kIceConnectionMax:
      return RTCIceConnectionStateCount;
  }
}

+ (NSString *)stringForIceConnectionState:(RTCIceConnectionState)state {
  switch (state) {
    case RTCIceConnectionStateNew:
      return @"NEW";
    case RTCIceConnectionStateChecking:
      return @"CHECKING";
    case RTCIceConnectionStateConnected:
      return @"CONNECTED";
    case RTCIceConnectionStateCompleted:
      return @"COMPLETED";
    case RTCIceConnectionStateFailed:
      return @"FAILED";
    case RTCIceConnectionStateDisconnected:
      return @"DISCONNECTED";
    case RTCIceConnectionStateClosed:
      return @"CLOSED";
    case RTCIceConnectionStateCount:
      return @"COUNT";
  }
}

+ (webrtc_mac_capturer::PeerConnectionInterface::IceGatheringState)
    nativeIceGatheringStateForState:(RTCIceGatheringState)state {
  switch (state) {
    case RTCIceGatheringStateNew:
      return webrtc_mac_capturer::PeerConnectionInterface::kIceGatheringNew;
    case RTCIceGatheringStateGathering:
      return webrtc_mac_capturer::PeerConnectionInterface::kIceGatheringGathering;
    case RTCIceGatheringStateComplete:
      return webrtc_mac_capturer::PeerConnectionInterface::kIceGatheringComplete;
  }
}

+ (RTCIceGatheringState)iceGatheringStateForNativeState:
    (webrtc_mac_capturer::PeerConnectionInterface::IceGatheringState)nativeState {
  switch (nativeState) {
    case webrtc_mac_capturer::PeerConnectionInterface::kIceGatheringNew:
      return RTCIceGatheringStateNew;
    case webrtc_mac_capturer::PeerConnectionInterface::kIceGatheringGathering:
      return RTCIceGatheringStateGathering;
    case webrtc_mac_capturer::PeerConnectionInterface::kIceGatheringComplete:
      return RTCIceGatheringStateComplete;
  }
}

+ (NSString *)stringForIceGatheringState:(RTCIceGatheringState)state {
  switch (state) {
    case RTCIceGatheringStateNew:
      return @"NEW";
    case RTCIceGatheringStateGathering:
      return @"GATHERING";
    case RTCIceGatheringStateComplete:
      return @"COMPLETE";
  }
}

+ (webrtc_mac_capturer::PeerConnectionInterface::StatsOutputLevel)
    nativeStatsOutputLevelForLevel:(RTCStatsOutputLevel)level {
  switch (level) {
    case RTCStatsOutputLevelStandard:
      return webrtc_mac_capturer::PeerConnectionInterface::kStatsOutputLevelStandard;
    case RTCStatsOutputLevelDebug:
      return webrtc_mac_capturer::PeerConnectionInterface::kStatsOutputLevelDebug;
  }
}

- (rtc::scoped_refptr<webrtc_mac_capturer::PeerConnectionInterface>)nativePeerConnection {
  return _peerConnection;
}

@end
