#include "common_interface.h"
#include "log.h"
#include "util_mac.h"
#include <unistd.h>

CommonInterface::CommonInterface(ICommonInterfaceCallback* callback, 
                                 const std::string uuid, 
                                 const std::string path) 
    : _callback(callback),
      _rtc_interface(NULL)
{
    RTC::RTCInitParam param;

    std::string dir = ShareAPP::SystemUtilMac::MacGetApplicationDocumentDirectory();
    dir = dir + "/";
    param.log_path = dir + "frtc_call.log";
    param.uuid = uuid;

    if (!_rtc_interface)
    {
        _rtc_interface = RTC::RTCInterface::InitRTC(this, param);
        _rtc_interface->SetFeatureEnable(RTC::kAEC, true);
        
        InitLog(_rtc_interface);
    }
}

CommonInterface::~CommonInterface()
{
    if(_callback) 
    { 
        delete _callback;
        _callback = NULL;
    }
}

void CommonInterface::JoinMeetingNoLogin(const std::string& server_address,
                                         const std::string& meeting_alias,
                                         const std::string& display_name,
                                         const std::string& meeting_password,
                                         int call_rate)
{
    InfoLog("---------------------------------");
    InfoLog("The server address is %s", server_address.c_str());
    _rtc_interface->JoinMeetingNoLogin(server_address, meeting_alias, display_name, call_rate);
}

void CommonInterface::JoinMeetingLogin(const std::string& server_address,
                                       const std::string& meeting_alias,
                                       const std::string& display_name,
                                       const std::string& user_token,
                                       const std::string& meeting_password,
                                       int call_rate,
                                       const std::string& user_id)
{
    _rtc_interface->JoinMeetingLogin(server_address, meeting_alias, display_name, user_token, meeting_password, call_rate, user_id);
}

void CommonInterface::EndMeeting(int call_index)
{
    _rtc_interface->EndMeeting(call_index);
}

void CommonInterface::SendVideoFrame(std::string media_id,
                                     void *buffer,
                                     unsigned int length,
                                     unsigned int width,
                                     unsigned int height,
                                     RTC::VideoColorFormat format,
                                     unsigned int stride)
{
    _rtc_interface->SendVideoFrame(media_id, buffer, length, width, height, format, stride);
}

void CommonInterface::ReceiveVideoFrame(std::string& mediaID,
                                        void **buffebuffer,
                                        unsigned int *length,
                                        unsigned int *width,
                                        unsigned int *height)
{
    _rtc_interface->ReceiveVideoFrame(mediaID, buffebuffer, length, width, height);
}

void CommonInterface::ResetVideoFrame(std::string& media_id)
{
    _rtc_interface->ResetVideoFrame(media_id);
}

void CommonInterface::SendAudioFrame(std::string media_id,
                                     void *buffer,
                                     unsigned int length,
                                     unsigned int sample_rate)
{
    _rtc_interface->SendAudioFrame(media_id, buffer, length, sample_rate);
}

void CommonInterface::ReceiveAudioFrame(std::string media_id,
                                        void *buffer,
                                        unsigned int length,
                                        unsigned int sample_rate)
{
    _rtc_interface->ReceiveAudioFrame(media_id, buffer, length, sample_rate);
}

void CommonInterface::StartSendContent()
{
    _rtc_interface->StartSendContent();
}

void CommonInterface::StopSendContent()
{
    _rtc_interface->StopSendContent();
}

void CommonInterface::SetContentAudio(bool enable, bool is_same_device)
{
    _rtc_interface->SetContentAudio(enable, is_same_device);
}

void CommonInterface::SendContentAudioFrame(std::string media_id,
                                            void *buffer,
                                            unsigned int length,
                                            unsigned int sample_rate)
{
    _rtc_interface->SendContentAudioFrame(media_id, buffer, length, sample_rate);
}

void CommonInterface::MuteLocalVideo(bool mute)
{
    _rtc_interface->MuteLocalVideo(mute);
}

void CommonInterface::MuteLocalAudio(bool mute)
{
    _rtc_interface->MuteLocalAudio(mute);
    _rtc_interface->ReportMuteStatus(mute, true, true);
}

void CommonInterface::GetLocalPreviewID(std::string& media_id)
{
    _rtc_interface->GetLocalPreviewID(media_id);
}

void CommonInterface::SetLayoutGridMode(bool grid_mode)
{
    _rtc_interface->SetLayoutGridMode(grid_mode);
}

void CommonInterface::SetIntelligentNoiseReduction(bool enable)
{
    _rtc_interface->SetNoiseBlock(enable);
}

void CommonInterface::SetCameraStreamMirror(bool is_mirror)
{
    _rtc_interface->SetCameraMirror(!is_mirror);
}

void CommonInterface::SetCameraCapability(std::string resolution_str)
{
    _rtc_interface->SetCameraCapability(resolution_str);
}

void CommonInterface::VerifyPasscode(const std::string passcode)
{
    _rtc_interface->VerifyPasscode(passcode);
}

std::string CommonInterface::GetMediaStatistics()
{
    return _rtc_interface->GetMediaStatistics();
}

uint64_t CommonInterface::StartUploadLogs(std::string& meta_data,
                                          std::string& file_name,
                                          int file_count)
{
    return _rtc_interface->StartUploadLogs(meta_data, file_name, file_count);
}

std::string CommonInterface::GetUploadStatus(uint64_t traction_id)
{
    return _rtc_interface->GetUploadStatus(traction_id);
}

void CommonInterface::CancelUploadLogs(uint64_t traction_id)
{
    _rtc_interface->CancelUploadLogs(traction_id);
}

int CommonInterface::GetCPULevel()
{
    return _rtc_interface->GetCPULevel();
}

void CommonInterface::OnMeetingJoinInfo(const std::string &meeting_name,
                       const std::string &meeting_id,
                       const std::string &display_name,
                       const std::string &owner_id,
                       const std::string &owner_name,
                       const std::string &meeting_url,
                       const std::string &group_meeting_url,
                       long long start_time,
                       long long end_time)
{
    if(_callback)
    {
        _callback->OnMeetingJoinInfoCallBack(meeting_name,
                                      meeting_id,
                                      display_name,
                                      owner_id,
                                      owner_name,
                                      meeting_url,
                                      group_meeting_url,
                                      start_time,
                                      end_time);
    }
}

void CommonInterface::OnMeetingStatusChange(RTC::MeetingStatus status,
                                            int reason,
                                            const std::string &call_id)
{
    if(_callback)
    {
        _callback->OnMeetingStatusChangeCallBack(status, reason, call_id);
    }
}

void CommonInterface::OnMeetingJoinFail(RTC::MeetingStatusChangeReason reason)
{
    if(_callback)
    {
        _callback->OnMeetingJoinFailCallBack(reason);
    }
}

void CommonInterface::OnParticipantCount(int parti_count)
{
    if(_callback)
    {
        _callback->OnParticipantCountCallBack(parti_count);
    }
}

void CommonInterface::OnParticipantList(const std::set<std::string> &uuid_list)
{
    if(_callback)
    {
        _callback->OnParticipantListCallBack(uuid_list);
    }
}

void CommonInterface::OnParticipantStatusChange(const std::map<std::string,
                                                RTC::ParticipantStatus> &status_list,
                                                bool is_full)
{
    if(is_full)
    {
        _participants_mute_status_list.clear();
        _participants_mute_status_list = status_list;
    }
    else
    {
        for(std::map<std::string, RTC::ParticipantStatus>::const_iterator item = status_list.begin(); item != status_list.end(); item++)
        {
            std::string key = item->first;
            if(_participants_mute_status_list.find(key) != _participants_mute_status_list.end())
            {
                _participants_mute_status_list[key] = item->second;
            }
            else
            {
                _participants_mute_status_list.insert({item->first, item->second});
            }
        }
    }
    
    _roster_list.clear();
    
    for (std::map<std::string, RTC::ParticipantStatus>::iterator item = _participants_mute_status_list.begin(); item != _participants_mute_status_list.end(); item++)
    {
        _roster_list.push_back(item->second);
    }
    
    if(_callback)
    {
        _callback->OnParticipantStatusChangeCallBack(_participants_mute_status_list, is_full);
    }
}

void CommonInterface::OnRequestVideoStream(const std::string &msid,
                                           int width,
                                           int height,
                                           float frame_rate)
{
    if (_callback)
    {
        _callback->OnRequestVideoStreamCallBack(msid, width, height, frame_rate);
    }
}

void CommonInterface::OnStopVideoStream(const std::string &msid) 
{
    if(_callback)
    {
        _callback->OnStopVideoStreamCallBack(msid);
    }
}

void CommonInterface::OnAddVideoStream(const std::string &msid,
                              int width,
                              int height,
                              uint32_t ssrc)
{
    if(_callback)
    {
        _callback->OnAddVideoStreamCallBack(msid, width, height, ssrc);
    }
}

void CommonInterface::OnDeleteVideoStream(const std::string &msid)
{
    if(_callback)
    {
        _callback->OnDeleteVideoStreamCallBack(msid);
    }
}

void CommonInterface::OnRequestAudioStream(const std::string &msid)
{
    if(_callback)
    {
        _callback->OnRequestAudioStreamCallBack(msid);
    }
}

void CommonInterface::OnStopAudioStream(const std::string &msid)
{
    if(_callback)
    {
        _callback->OnStopAudioStreamCallBack(msid);
    }
}

void CommonInterface::OnAddAudioStream(const std::string &msid)
{
    if(_callback)
    {
        _callback->OnAddAudioStreamCallBack(msid);
    }
}

void CommonInterface::OnDeleteAudioStream(const std::string &msid)
{
    if(_callback)
    {
        _callback->OnDeleteAudioStreamCallBack(msid);
    }
}

void CommonInterface::OnDetectAudioMute()
{
    if(_callback)
    {
        _callback->OnDetectAudioMuteCallBack();
    }
}

void CommonInterface::OnTextOverlay(RTC::TextOverlay *text_overly)
{
    if(_callback)
    {
        _callback->OnTextOverlayCallBack(text_overly);
    }
}

void CommonInterface::OnMeetingSessionStatus(const std::string &watermark_msg,
                                             const std::string &recording_status,
                                             const std::string &streaming_status,
                                             const std::string &streaming_url,
                                             const std::string &streaming_pwd)
{
    if(_callback)
    {
        _callback->OnMeetingSessionStatusCallBack(watermark_msg,
                                                  recording_status,
                                                  streaming_status,
                                                  streaming_url,
                                                  streaming_pwd);
    }
}

void CommonInterface::OnUnmuteRequest(const std::map<std::string, std::string> &parti_list)
{
    if(_callback)
    {
        _callback->OnUnmuteRequestCallBack(parti_list);
    }
}

void CommonInterface::OnUnmuteAllow()
{
    if(_callback)
    {
        _callback->OnUnmuteAllowCallBack();
    }
}

void CommonInterface::OnMuteLock(bool muted, bool allow_self_unmute)
{
    if(_callback)
    {
        _callback->OnMuteLockCallBack(muted, allow_self_unmute);
    }
}

void CommonInterface::OnContentStatusChange(RTC::ContentStatus status)
{
    if(_callback)
    {
        _callback->OnContentStatusChangeCallBack(status);
    }
}

void CommonInterface::OnContentTokenResponse(bool rejected)
{
    if(_callback)
    {
        _callback->OnContentTokenResponseCallBack(rejected);
    }
}

void CommonInterface::OnLayoutChange(const RTC::LayoutDescription &layout)
{
    if(_callback)
    {
        _callback->OnLayoutChangeCallBack(layout);
    }
}

void CommonInterface::OnLayoutSetting(int max_cell_count,
                                      const std::vector<std::string> &lectures)
{
    if(_callback)
    {
        _callback->OnLayoutSettingCallBack(max_cell_count, lectures);
    }
}

void CommonInterface::OnPasscodeRequest()
{
    if(_callback)
    {
        _callback->OnPasscodeRequestCallBack();
    }
}

void CommonInterface::OnPasscodeReject(RTC::MeetingStatusChangeReason reason)
{
    if(reason == RTC::kPasscodeTooManyRetries)
    {
        if(_callback) 
        {
            _callback->OnMeetingStatusChangeCallBack(RTC::kDisconnected, 41, "");
        }
    }
}

void CommonInterface::stopCommonInterface()
{
    delete this;
}

