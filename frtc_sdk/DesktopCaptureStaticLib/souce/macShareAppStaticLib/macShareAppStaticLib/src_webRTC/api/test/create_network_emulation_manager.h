/*
 *  Copyright (c) 2019 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef API_TEST_CREATE_NETWORK_EMULATION_MANAGER_H_
#define API_TEST_CREATE_NETWORK_EMULATION_MANAGER_H_

#include <memory>

#include "api/test/network_emulation_manager.h"

namespace webrtc_mac_capturer {

// Returns a non-null NetworkEmulationManager instance.
std::unique_ptr<NetworkEmulationManager> CreateNetworkEmulationManager(
    TimeMode mode = TimeMode::kRealTime);

}  // namespace webrtc_mac_capturer

#endif  // API_TEST_CREATE_NETWORK_EMULATION_MANAGER_H_
