#pragma once

#include "rtc_callback_interface.h"

namespace RTC
{

    // Forward declarations
    class RTCEventObserverInterface;

    struct RTCInitParam
    {
        std::string uuid;
        std::string log_path;
        CPULevel cpu_level = kCPUUndefined;
    };

    class RTC_API RTCInterface
    {
    public:
        static RTCInterface *InitRTC(RTCEventObserverInterface *observer, 
                                     const RTCInitParam &param);
        static void FreeRTC(RTCInterface *instance);

        virtual const std::string &GetVersion() = 0;

        virtual void JoinMeetingNoLogin(const std::string &server_address, 
                                        const std::string &meeting_alias,
                                        const std::string &join_name, 
                                        int call_rate,
                                        const std::string &meeting_pwd = "", 
                                        const std::string &user_id = "guest") = 0;
        virtual void JoinMeetingLogin(const std::string &server_address, 
                                      const std::string &meeting_alias,
                                      const std::string &join_name, 
                                      const std::string &user_token,
                                      const std::string &meeting_pwd, 
                                      int call_rate, 
                                      const std::string &user_id = "") = 0;
        virtual void EndMeeting(int call_idx) = 0;

        virtual void SendVideoFrame(const std::string &msid, 
                                    void *buffer, 
                                    unsigned int length,
                                    unsigned int width, 
                                    unsigned int height, 
                                    VideoColorFormat type,
                                    unsigned int stride = 0) = 0;
        virtual void ReceiveVideoFrame(const std::string &msid, 
                                     void **buffer, 
                                     unsigned int *length,
                                     unsigned int *width, 
                                     unsigned int *height) = 0;
        virtual void ResetVideoFrame(const std::string &msid) = 0;

        virtual void SendAudioFrame(const std::string &msid, 
                                    void *buffer, 
                                    unsigned int length,
                                    unsigned int sample_rate) = 0;
        virtual void ReceiveAudioFrame(const std::string &msid, 
                                     void *buffer, 
                                     unsigned int length,
                                     unsigned int sample_rate) = 0;

        virtual void StartSendContent() = 0;
        virtual void StopSendContent() = 0;

        virtual void SetContentAudio(bool enable, 
                                     bool is_same_device) = 0;
        virtual void SendContentAudioFrame(const std::string &msid, 
                                           void *buffer, 
                                           unsigned int length,
                                           unsigned int sample_rate) = 0;

        virtual void MuteLocalVideo(bool mute) = 0;
        virtual void MuteLocalAudio(bool mute) = 0;
        virtual bool GetLocalAudioMute() = 0;
        virtual void ReportMuteStatus(bool audio_mute, 
                                      bool video_mute, 
                                      bool allow_self_unmute) = 0;

        virtual void GetLocalPreviewID(std::string &preview_id) = 0;
        virtual void ChangeAudioDevice(AudioDeviceType type) = 0;
        virtual void SetLayoutGridMode(bool grid_mode) = 0;
        virtual void SetFeatureEnable(FeatureId feature_id, 
                                      bool enable) = 0;
        virtual void SetNoiseBlock(bool enable) = 0;
        virtual void SetCameraMirror(bool is_mirror) = 0;
        virtual void SetCameraCapability(const std::string &resolution) = 0;
        virtual void DecreaseCapability(BatteryTemperatureLevel level) = 0;
        virtual void VerifyPasscode(const std::string &passcode) = 0;

        virtual unsigned int GetCPULoad() = 0;
        virtual CPULevel GetCPULevel() = 0;
        virtual std::string GetMediaStatistics() = 0;

        virtual uint64_t StartUploadLogs(const std::string &meta_data, 
                                         const std::string &file_name = "",
                                         int file_count = 0, 
                                         const std::string &core_dump_name = "") = 0;
        virtual std::string GetUploadStatus(uint64_t traction_id, 
                                            int file_type = 0) = 0;
        virtual void CancelUploadLogs(uint64_t traction_id) = 0;

#if defined(IOS)
        virtual void SetPeopleOnlyFlag(bool is_people_only) = 0;
#endif

#ifdef WIN32
        virtual int ScaleI420(unsigned char *src, 
                              int src_w, 
                              int src_h, 
                              unsigned char *dst, 
                              int dst_w, 
                              int dst_h) = 0;
#endif

    protected:
        virtual ~RTCInterface() {}
    };

}
