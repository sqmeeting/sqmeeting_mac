#pragma once

#include <map>
#include <set>
#include <string>

#include "rtc_definitions.h"

#if defined(_WINDLL)
#define RTC_API __declspec(dllexport)
#else
#define RTC_API
#endif

namespace RTC
{

    class RTC_API RTCEventObserverInterface
    {
    public:
        virtual ~RTCEventObserverInterface() = default;

        virtual void OnMeetingJoinInfo(const std::string &meeting_name,
                                       const std::string &meeting_id,
                                       const std::string &display_name,
                                       const std::string &owner_id,
                                       const std::string &owner_name,
                                       const std::string &meeting_url,
                                       const std::string &group_meeting_url,
                                       long long start_time,
                                       long long end_time) = 0;

        virtual void OnMeetingJoinFail(MeetingStatusChangeReason reason) = 0;

        virtual void OnMeetingStatusChange(MeetingStatus status,
                                           int reason,
                                           const std::string &call_id) = 0;

        virtual void OnParticipantCount(int parti_count) = 0;

        virtual void OnParticipantList(const std::set<std::string> &uuid_list) = 0;

        virtual void OnParticipantStatusChange(const std::map<std::string, RTC::ParticipantStatus> &status_list,
                                               bool is_full) = 0;

        virtual void OnRequestVideoStream(const std::string &msid,
                                          int width,
                                          int height,
                                          float frame_rate) = 0;

        virtual void OnStopVideoStream(const std::string &msid) = 0;

        virtual void OnAddVideoStream(const std::string &msid,
                                      int width,
                                      int height,
                                      uint32_t ssrc) = 0;

        virtual void OnDeleteVideoStream(const std::string &msid) = 0;

        virtual void OnDetectVideoFreeze(const std::string &msid, bool frozen) = 0;

        virtual void OnRequestAudioStream(const std::string &msid) = 0;

        virtual void OnStopAudioStream(const std::string &msid) = 0;

        virtual void OnAddAudioStream(const std::string &msid) = 0;

        virtual void OnDeleteAudioStream(const std::string &msid) = 0;

        virtual void OnDetectAudioMute() = 0;

        virtual void OnTextOverlay(TextOverlay *text_overly) = 0;

        virtual void OnMeetingSessionStatus(const std::string &watermark_msg,
                                            const std::string &recording_status = "NOT_STARTED",
                                            const std::string &streaming_status = "NOT_STARTED",
                                            const std::string &streaming_url = "",
                                            const std::string &streaming_pwd = "") = 0;

        virtual void OnUnmuteRequest(const std::map<std::string, std::string> &parti_list) = 0;

        virtual void OnUnmuteAllow() = 0;

        virtual void OnMuteLock(bool muted, bool allow_self_unmute) = 0;

        virtual void OnContentStatusChange(RTC::ContentStatus status) = 0;

        virtual void OnContentFailForLowBandwidth() = 0;

        virtual void OnContentTokenResponse(bool rejected) = 0;

        virtual void OnLayoutChange(const RTC::LayoutDescription &layout) = 0;

        virtual void OnLayoutSetting(int max_cell_count,
                                     const std::vector<std::string> &lectures) = 0;

        virtual void OnPasscodeRequest() = 0;

        virtual void OnPasscodeReject(RTC::MeetingStatusChangeReason reason) = 0;

#if defined(ANDROID) || defined(IOS)
        virtual void OnNetworkStatusChange(NetworkStatus network_status) = 0;
#endif
    };
}
