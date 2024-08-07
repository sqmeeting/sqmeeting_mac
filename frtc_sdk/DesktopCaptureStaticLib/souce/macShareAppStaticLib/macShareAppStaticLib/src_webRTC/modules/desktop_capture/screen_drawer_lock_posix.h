/*
 *  Copyright (c) 2017 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef MODULES_DESKTOP_CAPTURE_SCREEN_DRAWER_LOCK_POSIX_H_
#define MODULES_DESKTOP_CAPTURE_SCREEN_DRAWER_LOCK_POSIX_H_

#include <semaphore.h>

#include "modules/desktop_capture/screen_drawer.h"

namespace webrtc_mac_capturer {

class ScreenDrawerLockPosix final : public ScreenDrawerLock {
 public:
  ScreenDrawerLockPosix();
  // Provides a name other than the default one for test only.
  explicit ScreenDrawerLockPosix(const char* name);
  ~ScreenDrawerLockPosix() override;

  // Unlinks the named semaphore actively. This will remove the sem_t object in
  // the system and allow others to create a different sem_t object with the
  // same/ name.
  static void Unlink(const char* name);

 private:
  sem_t* semaphore_;
};

}  // namespace webrtc_mac_capturer

#endif  // MODULES_DESKTOP_CAPTURE_SCREEN_DRAWER_LOCK_POSIX_H_
