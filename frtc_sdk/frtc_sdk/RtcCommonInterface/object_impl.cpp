#include "object_impl.h"
#import "ObjectInterface.h"
#include "frtc_sdk_version.h"

ObjectImpl::ObjectImpl( void )
    : _common_interface(NULL),
      _is_sending_video(false),
      _is_receive_video(false),
      _intelligent_noise_reduction_enabled(false),
      _sdk_version(FRTC_SDK_VERSION)
{
}

ObjectImpl::~ObjectImpl()
{   
}

bool ObjectImpl::Init(void *ocObject, const std::string uuid)
{
    _impl_oc_object = ocObject;
    
    if (!_common_interface)
    {
        _common_interface = new CommonInterface(this, uuid);
    }

    return true;
}

const char* ObjectImpl::GetSDKVersion()
{
    return _sdk_version.c_str();
}

void ObjectImpl::JoinMeetingNoLoginImpl(const std::string& server_address,
                                        const std::string& meeting_alias,
                                        const std::string& display_name,
                                        const std::string& meeting_password,
                                        int call_rate)
{
    _common_interface->JoinMeetingNoLogin(server_address,
                                         meeting_alias,
                                         display_name,
                                         meeting_password,
                                         call_rate);
}

void ObjectImpl::JoinMeetingLoginImpl(const std::string& server_address,
                                      const std::string& meeting_alias,
                                      const std::string& display_name,
                                      const std::string& user_token,
                                      const std::string& meeting_password,
                                      int call_rate,
                                      const std::string& user_id)
{
    _common_interface->JoinMeetingLogin(server_address,
                                       meeting_alias,
                                       display_name,
                                       user_token,
                                       meeting_password,
                                       call_rate,
                                       user_id);
}

void ObjectImpl::EndMeetingImpl(int call_index)
{
    _common_interface->EndMeeting(call_index);
}

void ObjectImpl::SendVideoFrameImpl(std::string media_id,
                                         void* buffer,
                                         unsigned int length,
                                         unsigned int width,
                                         unsigned int height,
                                         RTC::VideoColorFormat format,
                                         bool is_content,
                                         unsigned int stride)
{
    _common_interface->SendVideoFrame(media_id, buffer, length, width, height, format, stride);
    
    if(_is_sending_video && !is_content)
    {
        _common_interface->SendVideoFrame(_peopel_media_id, buffer, length, width, height, format);
    }
}

void ObjectImpl::ReceiveVideoFrameImpl(std::string& media_id,
                                       void **buffer,
                                       unsigned int* length,
                                       unsigned int* width,
                                       unsigned int* height)
{
    _common_interface->ReceiveVideoFrame(media_id, buffer, length, width, height);
}

void ObjectImpl::ResetVideoFrameImpl(std::string& media_id)
{
    _common_interface->ResetVideoFrame(media_id);
}

void ObjectImpl::SendAudioFrameImpl(void* buffer, unsigned int length, unsigned int sample_rate)
{
    _common_interface->SendAudioFrame(_audio_media_id, buffer, length, sample_rate);
}

void ObjectImpl::ReceiveAudioFrameImpl(void* buffer, unsigned int length, unsigned int sample_rate)
{
    _common_interface->ReceiveAudioFrame(_audio_receive_id, buffer, length, sample_rate);
}

void ObjectImpl::StartSendContentImpl()
{
 
    _common_interface->StartSendContent();
}

void ObjectImpl::StopSendContentImpl()
{
    _common_interface->StopSendContent();
}

void ObjectImpl::SetContentAudioImpl(bool enable, bool isSameDevice)
{
    _common_interface->SetContentAudio(enable, isSameDevice);
}

void ObjectImpl::SendContentAudioFrameImpl(std::string meida_id, 
                                           void* buffer,
                                           unsigned int length,
                                           unsigned int sample_rate)
{
    _common_interface->SendContentAudioFrame(_audio_receive_id, buffer, length, sample_rate);
}

void ObjectImpl::MuteLocalVideoImpl(bool muted)
{
    _common_interface->MuteLocalVideo(muted);
}

void ObjectImpl::MuteLocalAudioImpl(bool isMuted)
{
    _common_interface->MuteLocalAudio(isMuted);
}

void ObjectImpl::SetLayoutGridModeImpl(bool grid_mode)
{
    _common_interface->SetLayoutGridMode(grid_mode);
}

void ObjectImpl::SetIntelligentNoiseReductionImpl(bool enable)
{
    _common_interface->SetIntelligentNoiseReduction(enable);
    _intelligent_noise_reduction_enabled = enable;
}

void ObjectImpl::SetCameraCapabilityImpl(std::string resolution_str)
{
    return _common_interface->SetCameraCapability(resolution_str);
}

void ObjectImpl::SetCameraStreamMirrorImpl(bool is_mirror)
{
    _common_interface->SetCameraStreamMirror(is_mirror);
}

std::string ObjectImpl::GetMediaStatisticsImpl()
{
    return _common_interface->GetMediaStatistics();
}

void ObjectImpl::VerifyPasscodeImpl(const std::string& passcode)
{
    _common_interface->VerifyPasscode(passcode);
}

uint64_t ObjectImpl::StartUploadLogsImpl(std::string meta_data,
                                         std::string file_name,
                                         int file_count)
{
    return _common_interface->StartUploadLogs(meta_data, file_name, file_count);
}

std::string ObjectImpl::GetUploadStatusImpl(uint64_t traction_id)
{
    return _common_interface->GetUploadStatus(traction_id);
}

void ObjectImpl::CancelUploadLogsImpl(uint64_t traction_id)
{
    _common_interface->CancelUploadLogs(traction_id);
}

void ObjectImpl::OnMeetingJoinInfoCallBack(const std::string &meeting_name,
                                    const std::string &meeting_id,
                                    const std::string &display_name,
                                    const std::string &owner_id,
                                    const std::string &owner_name,
                                    const std::string &meeting_url,
                                    const std::string &group_meeting_url,
                                    long long start_time,
                                    long long end_time)
{
    [(__bridge id)(_impl_oc_object) OnObjectMeetingJoinInfoCallBack:meeting_name
                                                         meeting_id:meeting_id
                                                       display_name:display_name
                                                           owner_id:owner_id
                                                         owner_name:owner_name
                                                        meeting_url:meeting_url
                                                  group_meeting_url:group_meeting_url
                                                         start_time:start_time
                                                           end_time:end_time];
}

void ObjectImpl::OnMeetingStatusChangeCallBack(RTC::MeetingStatus status,
                                               int reason,
                                               const std::string &call_id)
{
    [(__bridge id)(_impl_oc_object) OnObjectMeetingStatusChangeCallBack:status reason:reason];
}

void ObjectImpl::OnMeetingJoinFailCallBack(RTC::MeetingStatusChangeReason reason)
{
    RTC::MeetingStatus status = RTC::kDisconnected;
    
    [(__bridge id)(_impl_oc_object) OnObjectMeetingStatusChangeCallBack:status reason:reason];
}

void ObjectImpl::OnParticipantCountCallBack(int parti_count)
{
    [(__bridge id)(_impl_oc_object) OnObjectParticipantCountCallBack:parti_count];
}

void ObjectImpl::OnParticipantListCallBack(const std::set<std::string> &uuid_list)
{
    [(__bridge id)(_impl_oc_object) OnObjectParticipantListCallBack:uuid_list];
}

void ObjectImpl::OnParticipantStatusChangeCallBack(std::map<std::string, RTC::ParticipantStatus> &roster_list,
                                                   bool is_full)
{
    [(__bridge id)(_impl_oc_object) OnObjectParticipantStatusChangeCallBack:roster_list isFulllist:is_full];
}

void ObjectImpl::OnRequestVideoStreamCallBack(const std::string &msid,
                                              int width,
                                              int height,
                                              float frame_rate)
{
    if(msid.rfind("VCS", 0) == std::string::npos)
    {
        _is_sending_video = true;
        _peopel_media_id = msid;
    }
    else
    {
        [(__bridge id)(_impl_oc_object) OnObjectRequestVideoStreamCallBack:msid width:width height:height framerate:frame_rate];
    }
}

void ObjectImpl::OnAddVideoStreamCallBack(const std::string &msid,
                                      int width,
                                      int height,
                                      uint32_t ssrc)
{
    _is_receive_video = true;
    _remote_media_id = msid;
    
    [(__bridge id)(_impl_oc_object) OnObjectAddVideoStreamCallBack:msid];
}

void ObjectImpl::OnRequestAudioStreamCallBack(const std::string &msid)
{
    _audio_media_id = msid;
}

void ObjectImpl::OnAddAudioStreamCallBack(const std::string &msid)
{
    _audio_receive_id = msid;
}

void ObjectImpl::OnDetectAudioMuteCallBack()
{
    [(__bridge id)(_impl_oc_object) OnObjectDetectAudioMuteCallBack];
}

void ObjectImpl::OnTextOverlayCallBack(RTC::TextOverlay *text_overly)
{
    [(__bridge id)(_impl_oc_object) OnObjectTextOverlayCallBack:text_overly];
}

void ObjectImpl::OnMeetingSessionStatusCallBack(const std::string &watermark_msg,
                                                const std::string &recording_status,
                                                const std::string &streaming_status,
                                                const std::string &streaming_url,
                                                const std::string &streaming_pwd )
{
    [(__bridge id)(_impl_oc_object) OnObjectMeetingSessionStatusCallBack:watermark_msg
                                                   recording_status:recording_status
                                                   streaming_status:streaming_status
                                                      streaming_url:streaming_url
                                                      streaming_pwd:streaming_pwd] ;
}

void ObjectImpl::OnUnmuteRequestCallBack(const std::map<std::string, std::string> &parti_list)
{
    [(__bridge id)(_impl_oc_object) OnObjectUnmuteRequestCallBack:parti_list];
}

void ObjectImpl::OnUnmuteAllowCallBack()
{
    [(__bridge id)(_impl_oc_object) OnObjectUnmuteAllowCallBack];
}

void ObjectImpl::OnMuteLockCallBack(bool muted, bool allow_self_unmute)
{
    [(__bridge id)(_impl_oc_object) OnObjectMuteLockCallBack:muted allow_self_unmute:allow_self_unmute];
}

void ObjectImpl::OnContentStatusChangeCallBack(RTC::ContentStatus status)
{
    if (status == RTC::ContentStatus::kContentSending)
    {
        [(__bridge id)(_impl_oc_object) OnObjectContentStatusChangeCallBack:YES];
    }
    else
    {
        [(__bridge id)(_impl_oc_object) OnObjectContentStatusChangeCallBack:NO];
    }
}

void ObjectImpl::OnContentTokenResponseCallBack(bool rejected)
{
   // [(__bridge id)(_impl_oc_object) onContentPriorityChangeResponse:status withKey:transactionKey];
}

void ObjectImpl::OnLayoutChangeCallBack(const RTC::LayoutDescription &layout)
{
    [(__bridge id)(_impl_oc_object) OnObjectLayoutChangeCallBack:layout];
}

void ObjectImpl::OnLayoutSettingCallBack(int max_cell_count,
                             const std::vector<std::string> &lectures)
{
    [(__bridge id)(_impl_oc_object) OnObjectLayoutSettingCallBack:max_cell_count lectures:lectures];
}

void ObjectImpl::OnPasscodeRequestCallBack()
{
    [(__bridge id)(_impl_oc_object) OnObjectPasscodeRequestCallBack];
}

void ObjectImpl::OnDeleteVideoStreamCallBack(const std::string &msid)
{
    if(msid.rfind("VCS", 0) == std::string::npos)
    {
        [(__bridge id)(_impl_oc_object) OnObjectDeleteVideoStreamCallBack:msid];
    }
}

int ObjectImpl::GetCPULevelImpl()
{
    return _common_interface->GetCPULevel();
}




