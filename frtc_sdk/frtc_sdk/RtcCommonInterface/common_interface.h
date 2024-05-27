#pragma once

#include <vector>
#include "rtc_interface.h"
#include "rtc_definitions.h"
#include "rtc_callback_interface.h"
#include "rtc_log.h"

class ICommonInterfaceCallback
{
public:
    ICommonInterfaceCallback() {}
    virtual ~ICommonInterfaceCallback() {}
    
    virtual void OnMeetingJoinInfoCallBack(const std::string &meeting_name,
                                           const std::string &meeting_id,
                                           const std::string &display_name,
                                           const std::string &owner_id,
                                           const std::string &owner_name,
                                           const std::string &meeting_url,
                                           const std::string &group_meeting_url,
                                           long long start_time,
                                           long long end_time) = 0;
    
    virtual void OnMeetingStatusChangeCallBack(RTC::MeetingStatus status,
                                               int reason,
                                               const std::string &call_id) = 0;
    
    virtual void OnMeetingJoinFailCallBack(RTC::MeetingStatusChangeReason reason) = 0;
    
    virtual void OnParticipantCountCallBack(int parti_count) = 0;
    
    virtual void OnParticipantListCallBack(const std::set<std::string> &uuid_list) = 0;
    
    virtual void OnParticipantStatusChangeCallBack(std::map<std::string, RTC::ParticipantStatus> &roster_list, bool is_full) = 0;
    
    virtual void OnRequestVideoStreamCallBack(const std::string &msid,
                                              int width,
                                              int height,
                                              float frame_rate) = 0;
    
    virtual void OnStopVideoStreamCallBack(const std::string &msid) = 0;
    
    virtual void OnAddVideoStreamCallBack(const std::string &msid,
                                          int width,
                                          int height,
                                          uint32_t ssrc) = 0;
    
    virtual void OnDeleteVideoStreamCallBack(const std::string &msid) = 0;

    virtual void OnRequestAudioStreamCallBack(const std::string &msid) = 0;

    virtual void OnStopAudioStreamCallBack(const std::string &msid) = 0;
    
    virtual void OnAddAudioStreamCallBack(const std::string &msid) = 0;
    
    virtual void OnDeleteAudioStreamCallBack(const std::string &msid) = 0;
    
    virtual void OnDetectAudioMuteCallBack() = 0;
    
    virtual void OnTextOverlayCallBack(RTC::TextOverlay *text_overly) = 0;
    
    virtual void OnMeetingSessionStatusCallBack(const std::string &watermark_msg,
                                                const std::string &recording_status = "NOT_STARTED",
                                                const std::string &streaming_status = "NOT_STARTED",
                                                const std::string &streaming_url = "",
                                                const std::string &streaming_pwd = "") = 0;
    
    virtual void OnUnmuteRequestCallBack(const std::map<std::string, std::string> &parti_list) = 0;
    
    virtual void OnUnmuteAllowCallBack() = 0;
    
    virtual void OnMuteLockCallBack(bool muted, bool allow_self_unmute) = 0;
    
    virtual void OnContentStatusChangeCallBack(RTC::ContentStatus status) = 0;
    
    virtual void OnContentTokenResponseCallBack(bool rejected) = 0;
    
    virtual void OnLayoutChangeCallBack(const RTC::LayoutDescription &layout) = 0;
    
    virtual void OnLayoutSettingCallBack(int max_cell_count,
                                 const std::vector<std::string> &lectures) = 0;
    
    virtual void OnPasscodeRequestCallBack() = 0;
};

class CommonInterface : public RTC::RTCEventObserverInterface
{
public:
    CommonInterface(ICommonInterfaceCallback *callback, 
                    const std::string uuid,
                    const std::string path = std::string(""));

    virtual ~CommonInterface();
    
    void JoinMeetingNoLogin(const std::string& server_address,
                            const std::string& meeting_alias,
                            const std::string& display_name,
                            const std::string& meeting_password,
                            int call_rate);
    
    void JoinMeetingLogin(const std::string& server_address,
                         const std::string& meeting_alias,
                         const std::string& display_name,
                         const std::string& user_token,
                         const std::string& meeting_password,
                         int call_rate,
                         const std::string& user_id);
    
    void EndMeeting(int call_index);
    
    void SendVideoFrame(std::string media_id,
                        void *buffer,
                        unsigned int length,
                        unsigned int width,
                        unsigned int height,
                        RTC::VideoColorFormat format,
                        unsigned int stride = 0);
    
    void ReceiveVideoFrame(std::string& mediaID,
                           void **buffer,
                           unsigned int *length,
                           unsigned int *width,
                           unsigned int *height);
    
    void ResetVideoFrame(std::string& media_id);
    
    void SendAudioFrame(std::string media_id,
                        void* buffer,
                        unsigned int length,
                        unsigned int sample_rate);
    
    void ReceiveAudioFrame(std::string media_id,
                           void* buffer,
                           unsigned int length,
                           unsigned int sample_rate);
    
    void StartSendContent();
    
    void StopSendContent();
    
    void SetContentAudio(bool enable, bool is_same_device);
    
    void SendContentAudioFrame(std::string media_id,
                               void *buffer,
                               unsigned int length,
                               unsigned int sample_rate);
    
    void MuteLocalVideo(bool mute);
    
    void MuteLocalAudio(bool mute);
    
    void GetLocalPreviewID(std::string& media_id);
    
    void SetLayoutGridMode(bool grid_mode);
    
    void SetIntelligentNoiseReduction(bool enable);
    
    void SetCameraStreamMirror(bool is_mirror);
    
    void SetCameraCapability(std::string resolution_str);
    
    void VerifyPasscode(const std::string passcode);
    
    std::string GetMediaStatistics();
    
    uint64_t StartUploadLogs(std::string& meta_data,
                             std::string& file_name,
                             int file_count);
    
    std::string GetUploadStatus(uint64_t traction_id);
    
    void CancelUploadLogs(uint64_t traction_id);
    
    int GetCPULevel();
    
    int  getProcessCPUUsage();
    
    int  getProcessMemoryUsage();
    
    void getStatisticsReport(std::string *report);

    void OnMeetingJoinInfo(const std::string &meeting_name,
                           const std::string &meeting_id,
                           const std::string &display_name,
                           const std::string &owner_id,
                           const std::string &owner_name,
                           const std::string &meeting_url,
                           const std::string &group_meeting_url,
                           long long start_time,
                           long long end_time);
    
    void OnMeetingStatusChange(RTC::MeetingStatus status,
                                       int reason,
                                       const std::string &call_id);
    
    void OnMeetingJoinFail(RTC::MeetingStatusChangeReason reason);
    
    void OnParticipantCount(int parti_count);
   
    void OnParticipantList(const std::set<std::string> &uuid_list);
    
    void OnParticipantStatusChange(const std::map<std::string, RTC::ParticipantStatus> &status_list,
                                   bool is_full);
 
    
    void OnRequestVideoStream(const std::string &msid,
                              int width,
                              int height,
                              float frame_rate);
    
    void OnStopVideoStream(const std::string &msid);
    
    void OnAddVideoStream(const std::string &msid,
                          int width,
                          int height,
                          uint32_t ssrc);
    
    void OnDeleteVideoStream(const std::string &msid);
    
    void OnDetectVideoFreeze(const std::string &msid, bool frozen){};
    
    void OnRequestAudioStream(const std::string &msid);
    
    void OnStopAudioStream(const std::string &msid);
    
    void OnAddAudioStream(const std::string &msid);
    
    void OnDeleteAudioStream(const std::string &msid);
    
    void OnDetectAudioMute();
    
    void OnTextOverlay(RTC::TextOverlay *text_overly);
    
    void OnMeetingSessionStatus(const std::string &watermark_msg,
                                const std::string &recording_status = "NOT_STARTED",
                                const std::string &streaming_status = "NOT_STARTED",
                                const std::string &streaming_url = "",
                                const std::string &streaming_pwd = "");
    
    void OnUnmuteRequest(const std::map<std::string, std::string> &parti_list);
    
    void OnUnmuteAllow();
    
    void OnMuteLock(bool muted, bool allow_self_unmute);
    
    void OnContentStatusChange(RTC::ContentStatus status);
    
    void OnContentFailForLowBandwidth() {};
    
    void OnContentTokenResponse(bool rejected);
    
    void OnLayoutChange(const RTC::LayoutDescription &layout);
    
    void OnLayoutSetting(int max_cell_count,
                                 const std::vector<std::string> &lectures);
    
    void OnPasscodeRequest();

    void OnPasscodeReject(RTC::MeetingStatusChangeReason reason);

    void stopCommonInterface();

private:
    ICommonInterfaceCallback *_callback;
    RTC::RTCInterface *_rtc_interface;

    std::vector<RTC::ParticipantStatus> _roster_list;
    std::map<std::string, RTC::ParticipantStatus> _participants_mute_status_list;
};

