/*
 *  Copyright 2015 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import <Foundation/Foundation.h>

#include <vector>

#include "rtc_base/gunit.h"

#import "api/peerconnection/RTCIceServer+Private.h"
#import "api/peerconnection/RTCIceServer.h"
#import "helpers/NSString+StdString.h"

@interface RTCIceServerTest : NSObject
- (void)testOneURLServer;
- (void)testTwoURLServer;
- (void)testPasswordCredential;
- (void)testInitFromNativeServer;
@end

@implementation RTCIceServerTest

- (void)testOneURLServer {
  RTC_OBJC_TYPE(RTCIceServer) *server =
      [[RTC_OBJC_TYPE(RTCIceServer) alloc] initWithURLStrings:@[ @"stun:stun1.example.net" ]];

  webrtc_mac_capturer::PeerConnectionInterface::IceServer iceStruct = server.nativeServer;
  EXPECT_EQ(1u, iceStruct.urls.size());
  EXPECT_EQ("stun:stun1.example.net", iceStruct.urls.front());
  EXPECT_EQ("", iceStruct.username);
  EXPECT_EQ("", iceStruct.password);
}

- (void)testTwoURLServer {
  RTC_OBJC_TYPE(RTCIceServer) *server = [[RTC_OBJC_TYPE(RTCIceServer) alloc]
      initWithURLStrings:@[ @"turn1:turn1.example.net", @"turn2:turn2.example.net" ]];

  webrtc_mac_capturer::PeerConnectionInterface::IceServer iceStruct = server.nativeServer;
  EXPECT_EQ(2u, iceStruct.urls.size());
  EXPECT_EQ("turn1:turn1.example.net", iceStruct.urls.front());
  EXPECT_EQ("turn2:turn2.example.net", iceStruct.urls.back());
  EXPECT_EQ("", iceStruct.username);
  EXPECT_EQ("", iceStruct.password);
}

- (void)testPasswordCredential {
  RTC_OBJC_TYPE(RTCIceServer) *server =
      [[RTC_OBJC_TYPE(RTCIceServer) alloc] initWithURLStrings:@[ @"turn1:turn1.example.net" ]
                                                     username:@"username"
                                                   credential:@"credential"];
  webrtc_mac_capturer::PeerConnectionInterface::IceServer iceStruct = server.nativeServer;
  EXPECT_EQ(1u, iceStruct.urls.size());
  EXPECT_EQ("turn1:turn1.example.net", iceStruct.urls.front());
  EXPECT_EQ("username", iceStruct.username);
  EXPECT_EQ("credential", iceStruct.password);
}

- (void)testHostname {
  RTC_OBJC_TYPE(RTCIceServer) *server =
      [[RTC_OBJC_TYPE(RTCIceServer) alloc] initWithURLStrings:@[ @"turn1:turn1.example.net" ]
                                                     username:@"username"
                                                   credential:@"credential"
                                                tlsCertPolicy:RTCTlsCertPolicySecure
                                                     hostname:@"hostname"];
  webrtc_mac_capturer::PeerConnectionInterface::IceServer iceStruct = server.nativeServer;
  EXPECT_EQ(1u, iceStruct.urls.size());
  EXPECT_EQ("turn1:turn1.example.net", iceStruct.urls.front());
  EXPECT_EQ("username", iceStruct.username);
  EXPECT_EQ("credential", iceStruct.password);
  EXPECT_EQ("hostname", iceStruct.hostname);
}

- (void)testTlsAlpnProtocols {
  RTC_OBJC_TYPE(RTCIceServer) *server =
      [[RTC_OBJC_TYPE(RTCIceServer) alloc] initWithURLStrings:@[ @"turn1:turn1.example.net" ]
                                                     username:@"username"
                                                   credential:@"credential"
                                                tlsCertPolicy:RTCTlsCertPolicySecure
                                                     hostname:@"hostname"
                                             tlsAlpnProtocols:@[ @"proto1", @"proto2" ]];
  webrtc_mac_capturer::PeerConnectionInterface::IceServer iceStruct = server.nativeServer;
  EXPECT_EQ(1u, iceStruct.urls.size());
  EXPECT_EQ("turn1:turn1.example.net", iceStruct.urls.front());
  EXPECT_EQ("username", iceStruct.username);
  EXPECT_EQ("credential", iceStruct.password);
  EXPECT_EQ("hostname", iceStruct.hostname);
  EXPECT_EQ(2u, iceStruct.tls_alpn_protocols.size());
}

- (void)testTlsEllipticCurves {
  RTC_OBJC_TYPE(RTCIceServer) *server =
      [[RTC_OBJC_TYPE(RTCIceServer) alloc] initWithURLStrings:@[ @"turn1:turn1.example.net" ]
                                                     username:@"username"
                                                   credential:@"credential"
                                                tlsCertPolicy:RTCTlsCertPolicySecure
                                                     hostname:@"hostname"
                                             tlsAlpnProtocols:@[ @"proto1", @"proto2" ]
                                            tlsEllipticCurves:@[ @"curve1", @"curve2" ]];
  webrtc_mac_capturer::PeerConnectionInterface::IceServer iceStruct = server.nativeServer;
  EXPECT_EQ(1u, iceStruct.urls.size());
  EXPECT_EQ("turn1:turn1.example.net", iceStruct.urls.front());
  EXPECT_EQ("username", iceStruct.username);
  EXPECT_EQ("credential", iceStruct.password);
  EXPECT_EQ("hostname", iceStruct.hostname);
  EXPECT_EQ(2u, iceStruct.tls_alpn_protocols.size());
  EXPECT_EQ(2u, iceStruct.tls_elliptic_curves.size());
}

- (void)testInitFromNativeServer {
  webrtc_mac_capturer::PeerConnectionInterface::IceServer nativeServer;
  nativeServer.username = "username";
  nativeServer.password = "password";
  nativeServer.urls.push_back("stun:stun.example.net");
  nativeServer.hostname = "hostname";
  nativeServer.tls_alpn_protocols.push_back("proto1");
  nativeServer.tls_alpn_protocols.push_back("proto2");
  nativeServer.tls_elliptic_curves.push_back("curve1");
  nativeServer.tls_elliptic_curves.push_back("curve2");

  RTC_OBJC_TYPE(RTCIceServer) *iceServer =
      [[RTC_OBJC_TYPE(RTCIceServer) alloc] initWithNativeServer:nativeServer];
  EXPECT_EQ(1u, iceServer.urlStrings.count);
  EXPECT_EQ("stun:stun.example.net",
      [NSString stdStringForString:iceServer.urlStrings.firstObject]);
  EXPECT_EQ("username", [NSString stdStringForString:iceServer.username]);
  EXPECT_EQ("password", [NSString stdStringForString:iceServer.credential]);
  EXPECT_EQ("hostname", [NSString stdStringForString:iceServer.hostname]);
  EXPECT_EQ(2u, iceServer.tlsAlpnProtocols.count);
  EXPECT_EQ(2u, iceServer.tlsEllipticCurves.count);
}

@end

TEST(RTCIceServerTest, OneURLTest) {
  @autoreleasepool {
    RTCIceServerTest *test = [[RTCIceServerTest alloc] init];
    [test testOneURLServer];
  }
}

TEST(RTCIceServerTest, TwoURLTest) {
  @autoreleasepool {
    RTCIceServerTest *test = [[RTCIceServerTest alloc] init];
    [test testTwoURLServer];
  }
}

TEST(RTCIceServerTest, PasswordCredentialTest) {
  @autoreleasepool {
    RTCIceServerTest *test = [[RTCIceServerTest alloc] init];
    [test testPasswordCredential];
  }
}

TEST(RTCIceServerTest, HostnameTest) {
  @autoreleasepool {
    RTCIceServerTest *test = [[RTCIceServerTest alloc] init];
    [test testHostname];
  }
}

TEST(RTCIceServerTest, InitFromNativeServerTest) {
  @autoreleasepool {
    RTCIceServerTest *test = [[RTCIceServerTest alloc] init];
    [test testInitFromNativeServer];
  }
}
