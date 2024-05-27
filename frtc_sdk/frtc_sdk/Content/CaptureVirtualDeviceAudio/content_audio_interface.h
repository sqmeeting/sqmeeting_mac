#ifndef ContentAudioInterface_hpp
#define ContentAudioInterface_hpp

#import <objc/runtime.h>

class ContentAudioImpl;

class ContentAudioInterface
{
public:
    ContentAudioInterface();
	~ContentAudioInterface();

	bool Initialize(void *client_object);
	void StartContentAudio(void);
	void StopContentAudio(void);
    void SendCaptureVirtualAudioData(short *audio_data, unsigned int sample_rate);
private:
    ContentAudioImpl   *_audio_impl;
    void * _client_object;
};

#endif

