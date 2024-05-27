#pragma once

#include <string>
#include <vector>

namespace RTC {

enum MeetingStatus {
    kIdle = 0,
    kConnected,
    kDisconnected
};

enum MeetingStatusChangeReason {
    kStatusOk = 0,
    kUnsecure,
    kAborted,
    kMeetingEndAbnormal,
    kMeetingExpired,
    kMeetingFull,
    kMeetingInterrupt,
    kMeetingLocked,
    kMeetingNoExist,
    kMeetingNoStarted,
    kMeetingStop,
    kAuthenticationFail,
    kPasscodeFailed,
    kPasscodeTimeout,
    kPasscodeTooManyRetries,
    kGuestUnallowed,
    kIgnore,
    kLicenseLimitReached,
    kLicenseNoFound,
    kRemovedFromMeeting,
    kServerError,
    kServerReject,
    kUnknownReason
};

enum ContentStatus {
    kContentIdle = 0,
    kContentSending,
    kContentReceving
};

enum LogLevel {
    kError = 0,
    kWarn,
    kInfo,
    kDebug,
};

enum FeatureId {
    kAEC = 0,
};

enum VideoColorFormat {
    kNoType = 0,
    kARGB = 1,
    kBGRA = 2,
    kABGR = 3,
    kRGBA = 4,
    kYUY2 = 5,
    kUYVY = 6,
    kI420 = 7,
    kYV12 = 8,
    kNV12 = 9,
    kNV21 = 10,
};

enum AudioDeviceType {
    kCapture = 0,
    kSpeaker
};

enum CPULevel {
    kCPUUndefined = 0,
    kCPU1080P,
    kCPU720P,
    kCPU540P,
    kCPU180P
};

enum BatteryTemperatureLevel {
    kTemperatureUndefined = 0,
    kOverheatBad,
    kOverheatVeryBad
};

enum LayoutMode {
    kLayoutUnknown = 1,
    k1X1 = 2,
    k2X2 = 3,
    k3X3 = 4,
    k4X4 = 5,
    k1P5 = 6,
    kContentRecv = 7,
    kContentSend = 8,
};

enum NetworkStatus {
    kNetworkGood = 0,
    kNetworkBad,
    kNetworkVeryBad
};

struct LayoutCell {
    std::string display_name;
    std::string uuid;
    std::string msid;
    unsigned int ssrc;
    int width;
    int height;
    float frame_rate;
    unsigned int bit_rate;
};

struct LayoutDescription {
    LayoutMode mode;
    bool has_content = false;
    std::string active_speaker_msid;
    std::string active_speaker_uuid;
    std::string pin_speaker_uuid;
    std::vector<LayoutCell> layout_cells;
};

struct ParticipantStatus {
    std::string display_name;
    std::string user_id;
    bool audio_mute = true;
    bool video_mute = true;
};

struct TextOverlay {
    bool enabled;
    std::string text;
    std::string font;
    int font_size;
    std::string color;
    int vertical_position;
    int background_transparency;
    int display_repetition;
    std::string display_speed;
    std::string text_overlay_type;
};

struct UserBasicInfo {
    std::string uuid;
    std::string display_name;
};

}
