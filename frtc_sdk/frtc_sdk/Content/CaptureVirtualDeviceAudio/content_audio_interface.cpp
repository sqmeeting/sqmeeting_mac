#include "content_audio_interface.h"
#include "content_audio_impl.h"
#import "FrtcMeetingViewController.h"

void CaptureDataCallBack(void *SELF, short *audio_data, unsigned int sample_rate);

ContentAudioInterface::ContentAudioInterface()
{
    _audio_impl = new ContentAudioImpl((void *)this, CaptureDataCallBack);
}

ContentAudioInterface::~ContentAudioInterface()
{
    if (_audio_impl)
    {
        delete _audio_impl;
    }
}

bool ContentAudioInterface::Initialize(void *client_object)
{
    _client_object = client_object;
    return true;
}

void ContentAudioInterface::StartContentAudio(void)
{
    _audio_impl->StartContentAudio();
    
    return ;
}

void ContentAudioInterface::StopContentAudio(void)
{
    _audio_impl->StopContentAudio();
}

void ContentAudioInterface::SendCaptureVirtualAudioData(short *audio_data, unsigned int sample_rate)
{
    [(__bridge id)(_client_object) sendContentAudioFrame:audio_data sampleRate:sample_rate];
}

void CaptureDataCallBack(void *SELF, short *audio_data, unsigned int sample_rate)
{
    ContentAudioInterface* interface = (ContentAudioInterface *)SELF;
    interface->SendCaptureVirtualAudioData(audio_data, sample_rate);
}



