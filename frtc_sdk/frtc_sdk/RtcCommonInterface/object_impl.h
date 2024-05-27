#ifndef ObjectImpl_h
#define ObjectImpl_h

#include "common_interface.h"

class ObjectImpl : public ICommonInterfaceCallback
{
public:
    ObjectImpl(void);
    ~ObjectImpl(void);
    
public:
    bool Init(void *ocObject, const std::string uuid);
    const char* GetSDKVersion();

public:
    virtual void OnMeetingJoinInfoCallBack(const std::string &meeting_name,
                                           const std::string &meeting_id,
                                           const std::string &display_name,
                                           const std::string &owner_id,
                                           const std::string &owner_name,
                                           const std::string &meeting_url,
                                           const std::string &group_meeting_url,
                                           long long start_time,
                                           long long end_time);
    
    virtual void OnMeetingStatusChangeCallBack(RTC::MeetingStatus status,
                                               int reason,
                                               const std::string &call_id);
    
    virtual void OnMeetingJoinFailCallBack(RTC::MeetingStatusChangeReason reason);
    
    virtual void OnParticipantCountCallBack(int parti_count);
    
    virtual void OnParticipantListCallBack(const std::set<std::string> &uuid_list);
    
    virtual void OnParticipantStatusChangeCallBack(std::map<std::string,
                                                   RTC::ParticipantStatus> &roster_list,
                                                   bool is_full);
    
    virtual void OnRequestVideoStreamCallBack(const std::string &msid,
                                              int width,
                                              int height,
                                              float frame_rate);
    
    virtual void OnStopVideoStreamCallBack(const std::string &msid) {};
    
    virtual void OnAddVideoStreamCallBack(const std::string &msid,
                                          int width,
                                          int height,
                                          uint32_t ssrc);
    
    virtual void OnDeleteVideoStreamCallBack(const std::string &msid);
    
    virtual void OnRequestAudioStreamCallBack(const std::string &msid);
    
    virtual void OnStopAudioStreamCallBack(const std::string &msid){};
  
    virtual void OnAddAudioStreamCallBack(const std::string &msid);
    
    virtual void OnDeleteAudioStreamCallBack(const std::string &msid){};
    
    virtual void OnDetectAudioMuteCallBack();
    
    virtual void OnTextOverlayCallBack(RTC::TextOverlay *text_overly);
    
    virtual void OnMeetingSessionStatusCallBack(const std::string &watermark_msg,
                                                const std::string &recording_status = "NOT_STARTED",
                                                const std::string &streaming_status = "NOT_STARTED",
                                                const std::string &streaming_url = "",
                                                const std::string &streaming_pwd = "");
    
    virtual void OnUnmuteRequestCallBack(const std::map<std::string, std::string> &parti_list);
    
    virtual void OnUnmuteAllowCallBack();
    
    virtual void OnMuteLockCallBack(bool muted, bool allow_self_unmute);
    
    virtual void OnContentStatusChangeCallBack(RTC::ContentStatus status);
    
    virtual void OnContentTokenResponseCallBack(bool rejected);
    
    virtual void OnLayoutChangeCallBack(const RTC::LayoutDescription &layout);
    
    virtual void OnLayoutSettingCallBack(int max_cell_count,
                                 const std::vector<std::string> &lectures);
    
    virtual void OnPasscodeRequestCallBack();
    
    void JoinMeetingNoLoginImpl(const std::string& server_address,
                                const std::string& meeting_alias,
                                const std::string& display_name,
                                const std::string& meeting_password,
                                int call_rate);
    
    void JoinMeetingLoginImpl(const std::string& server_address,
                              const std::string& meeting_alias,
                              const std::string& display_name,
                              const std::string& user_token,
                              const std::string& meeting_password,
                              int call_rate,
                              const std::string& user_id);
    
    void EndMeetingImpl(int call_index);

    void SendVideoFrameImpl(std::string media_id,
                            void* buffer,
                            unsigned int length,
                            unsigned int width,
                            unsigned int height,
                            RTC::VideoColorFormat format,
                            bool is_content = false,
                            unsigned int stride = 0);
    
    void ReceiveVideoFrameImpl(std::string& media_id,
                               void **buffer,
                               unsigned int* length,
                               unsigned int* width,
                               unsigned int* height);
    
    void ResetVideoFrameImpl(std::string& media_id);
    
    void SendAudioFrameImpl(void* buffer, unsigned int length, unsigned int sample_rate);
    
    void ReceiveAudioFrameImpl(void* buffer, unsigned int length, unsigned int sample_rate);
    
    void StartSendContentImpl();
    
    void StopSendContentImpl();
    
    void SetContentAudioImpl(bool enable, bool isSameDevice);
    
    void SendContentAudioFrameImpl(std::string media_id,
                                   void* buffer,
                                   unsigned int length,
                                   unsigned int sample_rate);
    
    void MuteLocalVideoImpl(bool muted);
    
    void MuteLocalAudioImpl(bool isMuted);
    
    void SetLayoutGridModeImpl(bool grid_mode);
    
    void SetIntelligentNoiseReductionImpl(bool enable);
    
    void SetCameraStreamMirrorImpl(bool is_mirror);
    
    void SetCameraCapabilityImpl(std::string resolution_str);
    
    void VerifyPasscodeImpl(const std::string& passcode);
    
    std::string GetMediaStatisticsImpl();
    
    uint64_t StartUploadLogsImpl(std::string meta_data,
                                 std::string file_name,
                                 int file_count);
    
    std::string GetUploadStatusImpl(uint64_t traction_id);
    
    void CancelUploadLogsImpl(uint64_t traction_id);\
    
    int  GetCPULevelImpl();
    
private:
    CommonInterface *          _common_interface;
    bool _is_sending_video;
    std::string _peopel_media_id;
    bool _is_receive_video;
    std::string _remote_media_id;
    std::string _audio_media_id;
    std::string _audio_receive_id;
    
    void * _impl_oc_object;
    bool _intelligent_noise_reduction_enabled;
    std::string _sdk_version;
};
#endif
