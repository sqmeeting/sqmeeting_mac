/*
 *  Copyright 2019 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */
#ifndef API_TASK_QUEUE_DEFAULT_TASK_QUEUE_FACTORY_H_
#define API_TASK_QUEUE_DEFAULT_TASK_QUEUE_FACTORY_H_

#include <memory>

#include "api/task_queue/task_queue_factory.h"

namespace webrtc_mac_capturer {

std::unique_ptr<TaskQueueFactory> CreateDefaultTaskQueueFactory();

}  // namespace webrtc_mac_capturer

#endif  // API_TASK_QUEUE_DEFAULT_TASK_QUEUE_FACTORY_H_
