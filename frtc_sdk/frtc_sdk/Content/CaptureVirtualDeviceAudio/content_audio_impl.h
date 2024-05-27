#pragma once

#include <iostream>
#include <CoreAudio/AudioHardware.h>
#include <AudioToolbox/AudioToolbox.h>

#define CAPTURE_BUFFER_SIZE_EVERY_20_MS_FRAMES            50

typedef void(*CaptureAudioDataCallBack)(void *interface, short *audio_data, unsigned int sample_rate);

typedef enum {
    audioHardwarePropertyUnknown = 0,
    audioHardwarePropertyInput = 1,
    audioHardwarePropertyOutput = 2,
    audioHardwarePropertyDefaultOutput = 3
} AudioHardwareProperty;


typedef struct {
    AudioHardwareProperty inputProperty;
    AudioDeviceID inputIdentifier;
    char inputAudioDeviceName[256];
    
    AudioHardwareProperty outputProperty;
    AudioDeviceID outputIdentifier;
    char outputAudioDeviceName[256];
    
    AudioHardwareProperty defaultSystemProperty;
    AudioDeviceID defaultOutputIdentifier;
    char outputDefaultAudioDeviceName[256];
} AudioDevice;


class ContentAudioImpl {
public:
    ContentAudioImpl(void *audio_inter,CaptureAudioDataCallBack callBack);
    ~ContentAudioImpl();
    
    bool Configuration(AudioDeviceID device_Id, void *audio_data_callback, void **audio_capture_buffer, void *interface);
    
    void StartContentAudio(void);
    void StopContentAudio(void);
    
    void SelectDevice(const char * device_name);
    void ReSelectDevice();
        
    AudioDeviceID GetDeviceIdentifier(const char * dev_name, AudioHardwareProperty type_property);
    void Stereo2Mono(short *output_buffer, short *input_buffer, int channels, unsigned int sample_rate);
        
private:
    AudioBufferList *MallocAudioBuffer(UInt32 num_channels, UInt32 buffer_size);
    void FreeAudioDataBuffer(AudioBufferList *buffer_list);
    
    void HandleAudioDevice(AudioDevice audio_device);
    int ConfigDeviceWithProperty(AudioHardwareProperty property, char *device_name);
    void GetDeviceName(AudioDeviceID device_ID, AudioHardwareProperty property, char * device_name, UInt32* max_length);
    AudioDeviceID GetSelectedDeviceID(AudioHardwareProperty property);
    AudioHardwareProperty GetDeviceProperty(AudioDeviceID audio_deviceID);
    
    bool InputDevice(AudioDeviceID audio_deviceID);
    bool OutputDevice(AudioDeviceID audio_deviceID);
    bool InputOrOutputDevice(AudioDeviceID audio_deviceID,AudioObjectPropertyScope property_scope);
    void SetDeviceProperty(AudioDeviceID device_ID, AudioHardwareProperty property);
    
    void SetDeviceMute(AudioDeviceID device_ID, AudioHardwareProperty property, bool device_mute);
    void SetDeviceByMuteValue(AudioHardwareProperty property, char *device_name, bool mute_state);
    void InitAudioDevice(AudioDevice device);
    bool getCurrentOutputDeviceMuteStatus();
    
    
public:
    AudioComponentInstance _audio_unit;
    AudioStreamBasicDescription _basic_format;
    AudioBufferList *_audio_buffer_list;
    AudioDeviceID _audio_device_id;
    
    pthread_mutex_t _audio_mutex;
    
    int _audio_buffer_size_samples;
    short *_audio_buffer;
    int _audio_size;
    
    CaptureAudioDataCallBack _impl_callBack;
    
    void  *_audio_interface;
    short *_audio_temp_buffer;
   
private:
    AudioDevice _original_device;
    AudioDevice _store_device;
    AudioDevice _current_device;
    
    void *_audio_data_callback;
    bool _configure_completed;
    bool _impl_running;
    int _frame_size_samples;
    int _sample_rate;
    bool _original_device_mute;
    
public:
    int _handle_data;
};

