#
# Copyright 2017 The Abseil Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

absl_cc_library(
  NAME
    graphcycles_internal
  HDRS
    "internal/graphcycles.h"
  SRCS
    "internal/graphcycles.cc"
  COPTS
    ${ABSL_DEFAULT_COPTS}
  DEPS
    absl::base
    absl::base_internal
    absl::config
    absl::core_headers
    absl::malloc_internal
    absl::raw_logging_internal
)

absl_cc_library(
  NAME
    kernel_timeout_internal
  HDRS
    "internal/kernel_timeout.h"
  COPTS
    ${ABSL_DEFAULT_COPTS}
  DEPS
    absl::core_headers
    absl::raw_logging_internal
    absl::time
)

absl_cc_library(
  NAME
    synchronization
  HDRS
    "barrier.h"
    "blocking_counter.h"
    "internal/create_thread_identity.h"
    "internal/futex.h"
    "internal/per_thread_sem.h"
    "internal/waiter.h"
    "mutex.h"
    "notification.h"
  SRCS
    "barrier.cc"
    "blocking_counter.cc"
    "internal/create_thread_identity.cc"
    "internal/per_thread_sem.cc"
    "internal/waiter.cc"
    "notification.cc"
    "mutex.cc"
  COPTS
    ${ABSL_DEFAULT_COPTS}
  DEPS
    absl::graphcycles_internal
    absl::kernel_timeout_internal
    absl::atomic_hook
    absl::base
    absl::base_internal
    absl::config
    absl::core_headers
    absl::dynamic_annotations
    absl::malloc_internal
    absl::raw_logging_internal
    absl::stacktrace
    absl::symbolize
    absl::time
    Threads::Threads
  PUBLIC
)

absl_cc_test(
  NAME
    barrier_test
  SRCS
    "barrier_test.cc"
  COPTS
    ${ABSL_TEST_COPTS}
  DEPS
    absl::synchronization
    absl::time
    GTest::gmock_main
)

absl_cc_test(
  NAME
    blocking_counter_test
  SRCS
    "blocking_counter_test.cc"
  COPTS
    ${ABSL_TEST_COPTS}
  DEPS
    absl::synchronization
    absl::time
    GTest::gmock_main
)

absl_cc_test(
  NAME
    graphcycles_test
  SRCS
    "internal/graphcycles_test.cc"
  COPTS
    ${ABSL_TEST_COPTS}
  DEPS
    absl::graphcycles_internal
    absl::core_headers
    absl::raw_logging_internal
    GTest::gmock_main
)

absl_cc_library(
  NAME
    thread_pool
  HDRS
    "internal/thread_pool.h"
  COPTS
    ${ABSL_DEFAULT_COPTS}
  DEPS
    absl::synchronization
    absl::core_headers
  TESTONLY
)

absl_cc_test(
  NAME
    mutex_test
  SRCS
    "mutex_test.cc"
  COPTS
    ${ABSL_TEST_COPTS}
  DEPS
    absl::synchronization
    absl::thread_pool
    absl::base
    absl::config
    absl::core_headers
    absl::memory
    absl::raw_logging_internal
    absl::time
    GTest::gmock_main
)

absl_cc_test(
  NAME
    notification_test
  SRCS
    "notification_test.cc"
  COPTS
    ${ABSL_TEST_COPTS}
  DEPS
    absl::synchronization
    absl::time
    GTest::gmock_main
)

absl_cc_library(
  NAME
    per_thread_sem_test_common
  SRCS
    "internal/per_thread_sem_test.cc"
  COPTS
    ${ABSL_TEST_COPTS}
  DEPS
    absl::synchronization
    absl::base
    absl::config
    absl::strings
    absl::time
    GTest::gmock
  TESTONLY
)

absl_cc_test(
  NAME
    per_thread_sem_test
  SRCS
    "internal/per_thread_sem_test.cc"
  COPTS
    ${ABSL_TEST_COPTS}
  DEPS
    absl::per_thread_sem_test_common
    absl::synchronization
    absl::strings
    absl::time
    GTest::gmock_main
)

absl_cc_test(
  NAME
    lifetime_test
  SRCS
    "lifetime_test.cc"
  COPTS
    ${ABSL_TEST_COPTS}
  DEPS
    absl::synchronization
    absl::core_headers
    absl::raw_logging_internal
)
