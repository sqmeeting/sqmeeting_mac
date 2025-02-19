/*
 *  Copyright 2019 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef RTC_BASE_TASK_QUEUE_GCD_H_
#define RTC_BASE_TASK_QUEUE_GCD_H_

#include <memory>

#include "api/task_queue/task_queue_factory.h"

namespace webrtc_mac_capturer {

std::unique_ptr<TaskQueueFactory> CreateTaskQueueGcdFactory();

}  // namespace webrtc_mac_capturer

#endif  // RTC_BASE_TASK_QUEUE_GCD_H_
