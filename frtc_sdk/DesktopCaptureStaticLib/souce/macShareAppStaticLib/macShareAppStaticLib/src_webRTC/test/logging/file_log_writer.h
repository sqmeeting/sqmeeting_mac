/*
 *  Copyright 2019 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */
#ifndef TEST_LOGGING_FILE_LOG_WRITER_H_
#define TEST_LOGGING_FILE_LOG_WRITER_H_

#include <cstdio>
#include <memory>
#include <string>
#include <vector>

#include "test/logging/log_writer.h"

namespace webrtc_mac_capturer {
namespace webrtc_impl {
class FileLogWriter final : public RtcEventLogOutput {
 public:
  explicit FileLogWriter(std::string file_path);
  ~FileLogWriter() final;
  bool IsActive() const override;
  bool Write(const std::string& value) override;
  void Flush() override;

 private:
  std::FILE* const out_;
};
}  // namespace webrtc_mac_capturer_impl
class FileLogWriterFactory final : public LogWriterFactoryInterface {
 public:
  explicit FileLogWriterFactory(std::string base_path);
  ~FileLogWriterFactory() final;

  std::unique_ptr<RtcEventLogOutput> Create(std::string filename) override;

 private:
  const std::string base_path_;
  std::vector<std::unique_ptr<webrtc_impl::FileLogWriter>> writers_;
};

}  // namespace webrtc_mac_capturer

#endif  // TEST_LOGGING_FILE_LOG_WRITER_H_
