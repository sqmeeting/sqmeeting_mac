/*
 *  Copyright 2018 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include <memory>

#include "modules/desktop_capture/desktop_capture_options.h"
#include "modules/desktop_capture/desktop_capturer.h"

#if defined(WEBRTC_USE_PIPEWIRE)
#include "modules/desktop_capture/linux/base_capturer_pipewire.h"
#endif  // defined(WEBRTC_USE_PIPEWIRE)

#if defined(WEBRTC_USE_X11)
#include "modules/desktop_capture/linux/screen_capturer_x11.h"
#endif  // defined(WEBRTC_USE_X11)

namespace webrtc_mac_capturer {

// static
std::unique_ptr<DesktopCapturer> DesktopCapturer::CreateRawScreenCapturer(
    const DesktopCaptureOptions& options) {
#if defined(WEBRTC_USE_PIPEWIRE)
  if (options.allow_pipewire() && DesktopCapturer::IsRunningUnderWayland()) {
    return BaseCapturerPipeWire::CreateRawCapturer(options);
  }
#endif  // defined(WEBRTC_USE_PIPEWIRE)

#if defined(WEBRTC_USE_X11)
  return ScreenCapturerX11::CreateRawScreenCapturer(options);
#endif  // defined(WEBRTC_USE_X11)

  return nullptr;
}

}  // namespace webrtc_mac_capturer
