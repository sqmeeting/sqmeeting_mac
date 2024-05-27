/*
 *  Copyright (c) 2019 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#include "modules/desktop_capture/mac/full_screen_mac_application_handler.h"
#include <libproc.h>
#include <algorithm>
#include <functional>
#include <string>
#include "absl/strings/match.h"
#include "api/function_view.h"
#include "modules/desktop_capture/mac/window_list_utils.h"

namespace webrtc_mac_capturer {
namespace {

static constexpr const char* kPowerPointSlideShowTitles[] = {
    u8"PowerPoint-Bildschirmpräsentation",
    u8"Προβολή παρουσίασης PowerPoint",
    u8"PowerPoint スライド ショー",
    u8"PowerPoint Slide Show",
    u8"PowerPoint 幻灯片放映",
    u8"Presentación de PowerPoint",
    u8"PowerPoint-slideshow",
    u8"Presentazione di PowerPoint",
    u8"Prezentácia programu PowerPoint",
    u8"Apresentação do PowerPoint",
    u8"PowerPoint-bildspel",
    u8"Prezentace v aplikaci PowerPoint",
    u8"PowerPoint 슬라이드 쇼",
    u8"PowerPoint-lysbildefremvisning",
    u8"PowerPoint-vetítés",
    u8"PowerPoint Slayt Gösterisi",
    u8"Pokaz slajdów programu PowerPoint",
    u8"PowerPoint 投影片放映",
    u8"Демонстрация PowerPoint",
    u8"Diaporama PowerPoint",
    u8"PowerPoint-diaesitys",
    u8"Peragaan Slide PowerPoint",
    u8"PowerPoint-diavoorstelling",
    u8"การนำเสนอสไลด์ PowerPoint",
    u8"Apresentação de slides do PowerPoint",
    u8"הצגת שקופיות של PowerPoint",
    u8"عرض شرائح في PowerPoint"};

class FullScreenMacApplicationHandler : public FullScreenApplicationHandler {
 public:
  using TitlePredicate =
      std::function<bool(const std::string&, const std::string&)>;

  FullScreenMacApplicationHandler(DesktopCapturer::SourceId sourceId,
                                  TitlePredicate title_predicate)
      : FullScreenApplicationHandler(sourceId),
        title_predicate_(title_predicate),
        owner_pid_(GetWindowOwnerPid((CGWindowID)sourceId)) {}

 protected:
  using CachePredicate =
      rtc::FunctionView<bool(const DesktopCapturer::Source&)>;

  void InvalidateCacheIfNeeded(const DesktopCapturer::SourceList& source_list,
                               int64_t timestamp,
                               CachePredicate predicate) const {
    if (timestamp != cache_timestamp_) {
      cache_sources_.clear();
      std::copy_if(source_list.begin(), source_list.end(),
                   std::back_inserter(cache_sources_), predicate);
      cache_timestamp_ = timestamp;
    }
  }

  WindowId FindFullScreenWindowWithSamePid(
      const DesktopCapturer::SourceList& source_list,
      int64_t timestamp) const {
          
//    InvalidateCacheIfNeeded(source_list, timestamp,
//                            [&](const DesktopCapturer::Source& src) {
//                              return src.id != GetSourceId() &&
//                                     GetWindowOwnerPid(src.id) == owner_pid_;
//                            });
      InvalidateCacheIfNeeded(source_list, timestamp,
                              [&](const DesktopCapturer::Source& src) {
          
                                DesktopCapturer::SourceId windowID = src.id;
                                CGWindowID convertedWindowID = (CGWindowID)(uintptr_t)windowID;
                                return windowID != GetSourceId() &&
                                       GetWindowOwnerPid(convertedWindowID) == owner_pid_;
                              });
          
    if (cache_sources_.empty())
      return kCGNullWindowID;

    const auto original_window = GetSourceId();
    //const std::string title = GetWindowTitle(original_window);
    DesktopCapturer::SourceId original_windowID = original_window;
    CGWindowID original_convertedWindowID = (CGWindowID)(uintptr_t)original_windowID;
    std::string title = GetWindowTitle(original_convertedWindowID);
          
    const std::string owner_name = GetWindowOwnerName(original_convertedWindowID);
    
    // We can ignore any windows with empty titles cause regardless type of
    // application it's impossible to verify that full screen window and
    // original window are related to the same document.
    if (title.empty()) {
      return kCGNullWindowID;
    }
    
    MacDesktopConfiguration desktop_config =
        MacDesktopConfiguration::GetCurrent(
            MacDesktopConfiguration::TopLeftOrigin);

    const auto it = std::find_if(
        cache_sources_.begin(), cache_sources_.end(),
        [&](const DesktopCapturer::Source& src) {

            //const std::string window_title = GetWindowTitle(src.id);            
            DesktopCapturer::SourceId windowID = src.id;
            CGWindowID convertedWindowID = (CGWindowID)(uintptr_t)windowID;
            const std::string window_title = GetWindowTitle(convertedWindowID);
            const std::string owner_name = GetWindowOwnerName(convertedWindowID);
            if (window_title.empty()) {
                //printf("[%s][%d]: window_title is empty: convertedWindowID: %d, window_title: %s. \n", __func__, __LINE__, convertedWindowID, window_title.c_str());
                return false;
            }

            if (title_predicate_ && !title_predicate_(title, window_title)) {
                return false;
            }
            
            bool isFullScreen = IsWindowFullScreen(desktop_config, convertedWindowID);
            //printf("[%s][%d]: convertedWindowID: %d, isFullScreen: %s. \n", __func__, __LINE__, convertedWindowID, isFullScreen?"true":"false");
            return isFullScreen;
            //return IsWindowFullScreen(desktop_config, convertedWindowID);
          //return IsWindowFullScreen(desktop_config, src.id);
        });

    return it != cache_sources_.end() ? it->id : 0;
  }

  DesktopCapturer::SourceId FindFullScreenWindow(
      const DesktopCapturer::SourceList& source_list,
      int64_t timestamp) const override {
          
      DesktopCapturer::SourceId sourceId = GetSourceId();
      //bool bWindowOnScreen = IsWindowOnScreen(sourceId);
      DesktopCapturer::SourceId windowID = sourceId;
      CGWindowID convertedWindowID = (CGWindowID)(uintptr_t)windowID;
      bool bWindowOnScreen = IsWindowOnScreen(convertedWindowID);
          
      intptr_t windowId = 0;
      if (bWindowOnScreen) {
          windowId = FindFullScreenWindowWithSamePid(source_list, timestamp);
      }
      
      //intptr_t windwoId_new = IsWindowOnScreen(GetSourceId()) ? 0 : FindFullScreenWindowWithSamePid(source_list, timestamp);
    
      return windowId;
          
//    return IsWindowOnScreen(GetSourceId())
//               ? 0
//               : FindFullScreenWindowWithSamePid(source_list, timestamp);
  }

 protected:
  const TitlePredicate title_predicate_;
  const int owner_pid_;
  mutable int64_t cache_timestamp_ = 0;
  mutable DesktopCapturer::SourceList cache_sources_;
};

bool equal_title_predicate(const std::string& original_title,
                           const std::string& title) {
  return original_title == title;
}

bool slide_show_title_predicate(const std::string& original_title,
                                const std::string& title) {
  if (title.find(original_title) == std::string::npos)
    return false;

  for (const char* pp_slide_title : kPowerPointSlideShowTitles) {
    if (absl::StartsWith(title, pp_slide_title))
      return true;
  }
  return false;
}

class OpenOfficeApplicationHandler : public FullScreenMacApplicationHandler {
 public:
  OpenOfficeApplicationHandler(DesktopCapturer::SourceId sourceId)
      : FullScreenMacApplicationHandler(sourceId, nullptr) {}

  DesktopCapturer::SourceId FindFullScreenWindow(
      const DesktopCapturer::SourceList& source_list,
      int64_t timestamp) const override {
    InvalidateCacheIfNeeded(source_list, timestamp,
                            [&](const DesktopCapturer::Source& src) {
        					  //return GetWindowOwnerPid(src.id) == owner_pid_;
                              DesktopCapturer::SourceId windowID = src.id;
                              CGWindowID convertedWindowID = (CGWindowID)(uintptr_t)windowID;
                              return GetWindowOwnerPid(convertedWindowID) == owner_pid_;
                            });

    const auto original_window = GetSourceId();
	
	//[Note]: WPS's window title are empty, for fullscreen-detect, add those titles as WPS's ProcessName.
    //const std::string original_title = GetWindowTitle(original_window);
    DesktopCapturer::SourceId windowID = original_window;
    CGWindowID convertedWindowID = (CGWindowID)(uintptr_t)windowID;
    const std::string original_title = GetWindowTitle(convertedWindowID);
//    std::string owner_name = GetWindowOwnerName(convertedWindowID);
//    if (original_title.empty() && !(owner_name.empty()) && 0 == owner_name.compare("WPS Office")) {
//        original_title = owner_name;
//    }
          
    // Check if we have only one document window, otherwise it's not possible
    // to securely match a document window and a slide show window which has
    // empty title.
    if (std::any_of(cache_sources_.begin(), cache_sources_.end(),
                    [&original_title](const DesktopCapturer::Source& src) {
                      return src.title.length() && src.title != original_title;
                    })) {
      return kCGNullWindowID;
    }

    MacDesktopConfiguration desktop_config =
        MacDesktopConfiguration::GetCurrent(
            MacDesktopConfiguration::TopLeftOrigin);

    // Looking for slide show window,
    // it must be a full screen window with empty title
    const auto slide_show_window = std::find_if(
        cache_sources_.begin(), cache_sources_.end(), [&](const auto& src) {
            DesktopCapturer::SourceId windowID = src.id;
            CGWindowID convertedWindowID = (CGWindowID)(uintptr_t)windowID;
            return src.title.empty() &&
                   IsWindowFullScreen(desktop_config, convertedWindowID);
            
          //return src.title.empty() &&
          //       IsWindowFullScreen(desktop_config, src.id);
        });

    if (slide_show_window == cache_sources_.end()) {
      return kCGNullWindowID;
    }

    return slide_show_window->id;
  }
};


class WPSOfficeApplicationHandler : public FullScreenMacApplicationHandler {
 public:
  WPSOfficeApplicationHandler(DesktopCapturer::SourceId sourceId)
      : FullScreenMacApplicationHandler(sourceId, nullptr) {}

  DesktopCapturer::SourceId FindFullScreenWindow(
      const DesktopCapturer::SourceList& source_list,
      int64_t timestamp) const override {
          
    if (source_list.empty()) {
      return 0;
    }
          
    const auto original_window = GetSourceId();
    DesktopCapturer::SourceId windowID = original_window;
    CGWindowID convertedWindowID = (CGWindowID)(uintptr_t)windowID;
    std::string original_title = GetWindowTitle(convertedWindowID);
    const std::string owner_name = GetWindowOwnerName(convertedWindowID);
    if (original_title.empty() && !(owner_name.empty()) && 0 == owner_name.compare("WPS Office")) {
      original_title = owner_name;
    }
          
    //printf("[%s][%d]: owner_pid_: %d, original_title: %s, windowID: %ld \n", __func__, __LINE__, owner_pid_, original_title.c_str(), windowID);

    //Add WPS's window data (window's id and title) to wpp_windows list:
    //DesktopCapturer::SourceList wpp_windows = GetProcessWindows(source_list, owner_pid_, original_window);
    DesktopCapturer::SourceList wpp_windows;
    for (const DesktopCapturer::Source& source : source_list) {
        // Perform operations on each 'source' object
        //NSLog(@"[%s][%d]: --- --- source_list: source.id : %ld, title: %s", __func__, __LINE__, source.id, source.title.c_str());
        CGWindowID convertedWindowID = (CGWindowID)(uintptr_t)source.id;
        int pid = GetWindowOwnerPid(convertedWindowID);
        if (owner_pid_ == pid) {
          //NSLog(@"[%s][%d]: --- --- wpp_windows.push_back(source.id : %ld, title: %s)", __func__, __LINE__, source.id, source.title.c_str());
          wpp_windows.push_back(DesktopCapturer::Source{source.id, source.title});
        }
    }
          
    /*
    //show wpp_windows:
    for (const DesktopCapturer::Source& source : wpp_windows) {
      // Perform operations on each 'source' object
      NSLog(@"[%s][%d]: --- --- wpp_windows: source.id : %ld, title: %s", __func__, __LINE__, source.id, source.title.c_str());
    }
    */
    
    if (wpp_windows.empty()) {
        return 0;
    }

    MacDesktopConfiguration desktop_config = MacDesktopConfiguration::GetCurrent(MacDesktopConfiguration::TopLeftOrigin);

    // Looking for slide show window,
    // it must be a full screen window with empty title
    const auto slide_show_window = std::find_if(wpp_windows.begin(), wpp_windows.end(), [&](const auto& src) {
      
      if (src.title.empty()) {
        return false;
      }
      
      DesktopCapturer::SourceId windowID = src.id;
      CGWindowID convertedWindowID = (CGWindowID)(uintptr_t)windowID;
      bool isWindowFullScreen = IsWPSWindowFullScreen(desktop_config, convertedWindowID);
      //if (isWindowFullScreen) {
      //  NSLog(@"[%s][%d]: --- --- isWindowFullScreen: true ->return true", __func__, __LINE__);
      //}
      //NSLog(@"[%s][%d]: --- --- wpp_windows(source.id : %ld, title: %s): isWindowFullScreen: %@", __func__, __LINE__, src.id, src.title.c_str(), isWindowFullScreen? @"YES": @"NO");
      return isWindowFullScreen;
      //return src.title.empty() && IsWindowFullScreen(desktop_config, convertedWindowID);
    });

    if (slide_show_window == wpp_windows.end()) {
      //NSLog(@"[%s][%d]: --- --- return kCGNullWindowID: %u", __func__, __LINE__, kCGNullWindowID);
      return kCGNullWindowID;
    }
          
    //NSLog(@"[%s][%d]: --- --- return slide_show_window->id: %ld", __func__, __LINE__, slide_show_window->id);
    return slide_show_window->id;
  }
    
};

}  // namespace

std::unique_ptr<FullScreenApplicationHandler>
CreateFullScreenMacApplicationHandler(DesktopCapturer::SourceId sourceId) {
  std::unique_ptr<FullScreenApplicationHandler> result;
    
  //int pid = GetWindowOwnerPid(sourceId);
  CGWindowID convertedWindowID = (CGWindowID)(uintptr_t)sourceId;
  int pid = GetWindowOwnerPid(convertedWindowID);
    
  char buffer[PROC_PIDPATHINFO_MAXSIZE];
  int path_length = proc_pidpath(pid, buffer, sizeof(buffer));
  if (path_length > 0) {
    const char* last_slash = strrchr(buffer, '/');
    const std::string name{last_slash ? last_slash + 1 : buffer};
    
    //const std::string owner_name = GetWindowOwnerName(sourceId);
    DesktopCapturer::SourceId windowID = sourceId;
    CGWindowID convertedWindowID = (CGWindowID)(uintptr_t)windowID;
    const std::string owner_name = GetWindowOwnerName(convertedWindowID);
      
    FullScreenMacApplicationHandler::TitlePredicate predicate = nullptr;
    if (name.find("Google Chrome") == 0 || name == "Chromium") {
      predicate = equal_title_predicate;
    } else if (name == "Microsoft PowerPoint") {
      predicate = slide_show_title_predicate;
    } else if (name == "Keynote") {
      predicate = equal_title_predicate;
    } else if (owner_name == "OpenOffice") {
      return std::make_unique<OpenOfficeApplicationHandler>(sourceId);
    } else if (owner_name == "WPS Office") {
      return std::make_unique<WPSOfficeApplicationHandler>(sourceId);
    }

    if (predicate) {
      result.reset(new FullScreenMacApplicationHandler(sourceId, predicate));
    }
  }

  return result;
}

}  // namespace webrtc_mac_capturer_mac_capturer
