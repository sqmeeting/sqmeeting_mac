/*
 *  Copyright (c) 2018 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef MODULES_DESKTOP_CAPTURE_MAC_DESKTOP_FRAME_CGIMAGE_H_
#define MODULES_DESKTOP_CAPTURE_MAC_DESKTOP_FRAME_CGIMAGE_H_

#include <CoreGraphics/CoreGraphics.h>

#include <memory>

#include "modules/desktop_capture/desktop_frame.h"
#include "sdk/objc/helpers/scoped_cftyperef.h"

namespace webrtc_mac_capturer {

class DesktopFrameCGImage final : public DesktopFrame {
 public:
  // Create an image containing a snapshot of the display at the time this is
  // being called.
  static std::unique_ptr<DesktopFrameCGImage> CreateForDisplay(
      CGDirectDisplayID display_id);

  // Create an image containing a snaphot of the given window at the time this
  // is being called. This also works when the window is overlapped or in
  // another workspace.
  static std::unique_ptr<DesktopFrameCGImage> CreateForWindow(
      CGWindowID window_id);

  ~DesktopFrameCGImage() override;

 private:
  static std::unique_ptr<DesktopFrameCGImage> CreateFromCGImage(
      rtc::ScopedCFTypeRef<CGImageRef> cg_image);

  // This constructor expects `cg_image` to hold a non-null CGImageRef.
  DesktopFrameCGImage(DesktopSize size,
                      int stride,
                      uint8_t* data,
                      rtc::ScopedCFTypeRef<CGImageRef> cg_image,
                      rtc::ScopedCFTypeRef<CFDataRef> cg_data);

  const rtc::ScopedCFTypeRef<CGImageRef> cg_image_;
  const rtc::ScopedCFTypeRef<CFDataRef> cg_data_;

  RTC_DISALLOW_COPY_AND_ASSIGN(DesktopFrameCGImage);
};

}  // namespace webrtc_mac_capturer_mac_capturer

#endif  // MODULES_DESKTOP_CAPTURE_MAC_DESKTOP_FRAME_CGIMAGE_H_
