/*
 *  Copyright (c) 2020 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef RTC_BASE_WIN_HSTRING_H_
#define RTC_BASE_WIN_HSTRING_H_

#include <hstring.h>
#include <stdint.h>
#include <winerror.h>

namespace webrtc_mac_capturer {

// Callers must check the return value of ResolveCoreWinRTStringDelayLoad()
// before using these functions.
bool ResolveCoreWinRTStringDelayload();

HRESULT CreateHstring(const wchar_t* src, uint32_t len, HSTRING* out_hstr);

HRESULT DeleteHstring(HSTRING hstr);

}  // namespace webrtc_mac_capturer

#endif  // RTC_BASE_WIN_HSTRING_H_
