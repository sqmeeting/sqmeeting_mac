/*
 *  Copyright 2015 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "RTCDataChannel.h"

#include "api/data_channel_interface.h"
#include "api/scoped_refptr.h"

NS_ASSUME_NONNULL_BEGIN

@class RTC_OBJC_TYPE(RTCPeerConnectionFactory);

@interface RTC_OBJC_TYPE (RTCDataBuffer)
()

    /**
     * The native DataBuffer representation of this RTCDatabuffer object. This is
     * needed to pass to the underlying C++ APIs.
     */
    @property(nonatomic, readonly) const webrtc_mac_capturer::DataBuffer *nativeDataBuffer;

/** Initialize an RTCDataBuffer from a native DataBuffer. */
- (instancetype)initWithNativeBuffer:(const webrtc_mac_capturer::DataBuffer &)nativeBuffer;

@end

@interface RTC_OBJC_TYPE (RTCDataChannel)
()

    /** Initialize an RTCDataChannel from a native DataChannelInterface. */
    - (instancetype)initWithFactory
    : (RTC_OBJC_TYPE(RTCPeerConnectionFactory) *)factory nativeDataChannel
    : (rtc::scoped_refptr<webrtc_mac_capturer::DataChannelInterface>)nativeDataChannel NS_DESIGNATED_INITIALIZER;

+ (webrtc_mac_capturer::DataChannelInterface::DataState)nativeDataChannelStateForState:
        (RTCDataChannelState)state;

+ (RTCDataChannelState)dataChannelStateForNativeState:
        (webrtc_mac_capturer::DataChannelInterface::DataState)nativeState;

+ (NSString *)stringForState:(RTCDataChannelState)state;

@end

NS_ASSUME_NONNULL_END
