#include "content_audio_impl.h"
#include <string.h>

const std::string VIRTUAL_AUDIO_DEVICE_NAME = "FRMeeting Audio Device";
#include <mach/mach_time.h>

OSStatus AudioRenderCallback(void *inRefCon,
                            AudioUnitRenderActionFlags *ioActionFlags,
                            const AudioTimeStamp       *inTimeStamp,
                            UInt32                     inBusNumber,
                            UInt32                     inNumberFrames,
                            AudioBufferList            *ioData)
{
    OSStatus status = noErr;
    
    ContentAudioImpl *impl_self = (ContentAudioImpl *)inRefCon;
    if (!impl_self || !impl_self->_audio_buffer_list)
    {
        return status;
    }
    
    if (!impl_self->_handle_data)
    {
        return noErr;
    }
    

    impl_self->_audio_buffer_list->mBuffers[0].mDataByteSize = inNumberFrames * sizeof(Float32) * 2;
    
    status = AudioUnitRender(impl_self->_audio_unit, ioActionFlags, inTimeStamp, inBusNumber, inNumberFrames, impl_self->_audio_buffer_list);
    if (status != 0)
    {
        return status;
    }
    
    pthread_mutex_lock(&impl_self->_audio_mutex);
    
    int number_channel_output = 2;
    for (int i = 0; i < impl_self->_audio_buffer_list->mNumberBuffers ; i++)
    {
        short audio_temp_buffer[48000 * 2] = {0};
        int number_samples = ((impl_self->_audio_buffer_list->mBuffers[i].mDataByteSize) >> 3);
        
        Float32 *float_temp_buffer = (Float32 *)(impl_self->_audio_buffer_list->mBuffers[i].mData);
        
        for (int j = 0; j < number_samples * number_channel_output; j++)
        {
            impl_self->_audio_buffer[impl_self->_audio_size] = (short)(float_temp_buffer[j] * 32767.5f);
            audio_temp_buffer[j] = impl_self->_audio_buffer[impl_self->_audio_size];
            impl_self->_audio_size++;
            
            if (impl_self->_audio_size >= impl_self->_audio_buffer_size_samples)
            {
                impl_self->_audio_size = 0;
            }
        }
        
        short momo_audio_buffer[4096];
        memset(momo_audio_buffer, 0, 4096 * sizeof(short));
        
        impl_self->Stereo2Mono(momo_audio_buffer, audio_temp_buffer, 2, 480);
        
        impl_self->_impl_callBack(impl_self->_audio_interface, momo_audio_buffer, 48000);
    }
    
    pthread_mutex_unlock(&impl_self->_audio_mutex);
    return 0;
}

ContentAudioImpl::ContentAudioImpl(void *audio_inter, CaptureAudioDataCallBack callBack):_audio_interface(audio_inter), _impl_callBack(callBack), _handle_data(false)
{
    pthread_mutex_init(&_audio_mutex, NULL);
    
    _configure_completed = false;
    _impl_running = false;
    _audio_unit = NULL;
    
    _audio_buffer_size_samples = 0;
    _audio_buffer = NULL;
    _audio_size = 0;
    _frame_size_samples = 0;
    _sample_rate = 0;
    
    _audio_buffer_list = NULL;
    
    _audio_temp_buffer = (short *)malloc(3840 * 2 * sizeof(short));
    
    InitAudioDevice(_current_device);
    InitAudioDevice(_store_device);
    InitAudioDevice(_original_device);
}

ContentAudioImpl::~ContentAudioImpl()
{
    pthread_mutex_destroy(&_audio_mutex);
}

void ContentAudioImpl::InitAudioDevice(AudioDevice device)
{
    memset(device.inputAudioDeviceName, 0, sizeof(device.inputAudioDeviceName));
    memset(device.outputAudioDeviceName, 0, sizeof(device.outputAudioDeviceName));
    memset(device.outputDefaultAudioDeviceName, 0, sizeof(device.outputDefaultAudioDeviceName));
}

bool ContentAudioImpl::Configuration(AudioDeviceID device_Id, void *audio_data_callback, void **audio_capture_buffer, void *interface)
{
    OSStatus status;
    UInt32 data_size;
    UInt32 un_frame_size;
    AudioComponentDescription desc;
    AudioObjectPropertyAddress theAddress = 
    {
        kAudioHardwarePropertyDefaultInputDevice,
        kAudioObjectPropertyScopeGlobal,
        kAudioObjectPropertyElementMaster
    };
    
    _audio_device_id = device_Id;
    _audio_data_callback = audio_data_callback;
    
    _configure_completed = false;
    _impl_running = false;
    _audio_unit = NULL;
    
    _sample_rate = 0;
    
    _audio_buffer_size_samples = 0;
    _audio_buffer = NULL;
  
    _audio_size = 0;
    _frame_size_samples = 0;
    _sample_rate = 0;
    _audio_buffer_list = NULL;
    
    desc.componentType          = kAudioUnitType_Output;
    desc.componentSubType       = kAudioUnitSubType_HALOutput;
    desc.componentFlags         = 0;
    desc.componentFlagsMask     = 0;
    desc.componentManufacturer  = kAudioUnitManufacturer_Apple;
    
    AudioComponent component = AudioComponentFindNext(NULL, &desc);
    status = AudioComponentInstanceNew(component, &_audio_unit);
    
    if (status != 0) 
    {
        return false;
    }
    
    UInt32 enable_IO;
    
    enable_IO = 1; // Enable input
    
    status = AudioUnitSetProperty(_audio_unit, 
                                  kAudioOutputUnitProperty_EnableIO,
                                  kAudioUnitScope_Input,
                                  1,
                                  &enable_IO,
                                  sizeof(enable_IO)
                                  );
    if (status != 0) 
    {
        return false;
    }
    
    enable_IO = 0;
    
    status = AudioUnitSetProperty(_audio_unit,
                                  kAudioOutputUnitProperty_EnableIO,
                                  kAudioUnitScope_Output,
                                  0,
                                  &enable_IO,
                                  sizeof(enable_IO)
                                  );
    if (status != 0) 
    {
        return false;
    }
    
    status = AudioUnitSetProperty(_audio_unit, 
                                  kAudioOutputUnitProperty_CurrentDevice,
                                  kAudioUnitScope_Global, 
                                  0,
                                  &_audio_device_id,
                                  sizeof(AudioDeviceID)
                                  );
    if (status != 0) 
    {
        return false;
    }
    
    AudioStreamBasicDescription format;
    data_size = sizeof(AudioStreamBasicDescription);
    status = AudioUnitGetProperty(_audio_unit,
                                  kAudioUnitProperty_StreamFormat, 
                                  kAudioUnitScope_Input,
                                  1, 
                                  &format,
                                  &data_size);
    if (status != noErr)
    {
        return false;
    }
    
    _basic_format.mSampleRate       = format.mSampleRate;
    _basic_format.mFormatID         = kAudioFormatLinearPCM;
    _basic_format.mFormatFlags      = format.mFormatFlags;
    _basic_format.mBitsPerChannel   = sizeof(float) * 8;
    _basic_format.mBytesPerFrame    = _basic_format.mBitsPerChannel * 2 / 8;
    _basic_format.mBytesPerPacket   = _basic_format.mBytesPerFrame;
    _basic_format.mFramesPerPacket  = 1;
    _basic_format.mChannelsPerFrame = 2;
    _basic_format.mReserved         = 0;
    
#if __BIG_ENDIAN__
    _basic_format.mFormatFlags |= kAudioFormatFlagIsBigEndian;
#endif
    
    status = AudioUnitSetProperty(_audio_unit, 
                                  kAudioUnitProperty_StreamFormat,
                                  kAudioUnitScope_Output,
                                  1,
                                  &_basic_format,
                                  sizeof(AudioStreamBasicDescription)
                                  );
    if (status != 0)
    {
        return false;
    }
    
    _sample_rate = (int)_basic_format.mSampleRate;

    switch (_sample_rate) {
        case 192000:
        case 96000:
        case 48000:
        case 44100:
        case 32000:
        case 16000:
        case 8000:
            break;
        default:
            _sample_rate = 16000;
            break;
    }
   
    data_size = sizeof(UInt32);
    if(_sample_rate == 16000 || _sample_rate == 8000) 
    {
        un_frame_size = 128;
    } 
    else
    {
        un_frame_size =  _sample_rate / 100;
    }
    
    if(_sample_rate == 192000) 
    {
        un_frame_size = 512;
    } 
    else
    {
        un_frame_size =  un_frame_size;
    }
        
    status = AudioUnitSetProperty(_audio_unit, 
                                  kAudioDevicePropertyBufferFrameSize,
                                  kAudioUnitScope_Global,
                                  0,
                                  &un_frame_size,
                                  data_size
                                  );
    
    if (status != noErr) 
    {
        return false;
    }
    
    AudioValueRange	BufFrameSizeRange;
    data_size = sizeof(AudioValueRange);
    theAddress.mSelector = kAudioDevicePropertyBufferFrameSizeRange;
    
    status = AudioObjectGetPropertyData(_audio_device_id, 
                                        &theAddress,
                                        0,
                                        NULL,
                                        &data_size,
                                        &BufFrameSizeRange
                                        );
    if (status != 0)
    {
        return false;
    }
   
    
    if (un_frame_size > (int)BufFrameSizeRange.mMinimum) 
        un_frame_size = (int)BufFrameSizeRange.mMinimum;
    
    if (un_frame_size > (int)BufFrameSizeRange.mMaximum) 
        un_frame_size = (int)BufFrameSizeRange.mMaximum;
    
    data_size = sizeof(UInt32);
    status = AudioUnitGetProperty(_audio_unit,
                                  kAudioDevicePropertyBufferFrameSize,
                                  kAudioUnitScope_Global,
                                  0,
                                  &un_frame_size,
                                  &data_size
                                  );

    if (status != noErr)
    {
        return false;
    }
    
    _audio_buffer_list = MallocAudioBuffer(_basic_format.mChannelsPerFrame, un_frame_size * _basic_format.mBytesPerFrame);
    if (_audio_buffer_list == NULL)
    {
        *audio_capture_buffer = NULL;
        return false;
    }
    *audio_capture_buffer = (void *)_audio_buffer_list;
    
    _frame_size_samples = (_sample_rate / 100) * 2; // 20 ms frame
    _audio_buffer_size_samples = CAPTURE_BUFFER_SIZE_EVERY_20_MS_FRAMES * _frame_size_samples;
    
    _audio_buffer = new short[_audio_buffer_size_samples];
    
    if (_audio_buffer == NULL)
    {
        return false;
    }
    
    AURenderCallbackStruct callback_struct;
    callback_struct.inputProc = (AURenderCallback)_audio_data_callback;
    callback_struct.inputProcRefCon = interface;
    
    status = AudioUnitSetProperty(_audio_unit, 
                                  kAudioOutputUnitProperty_SetInputCallback,
                                  kAudioUnitScope_Global,
                                  0,
                                  &callback_struct,
                                  sizeof(callback_struct)
                                  );
    if (status != 0)
    {
        return false;
    }
    
    status = AudioUnitInitialize(_audio_unit);
    if (status != 0)
    {
        return false;
    }
    
    _configure_completed = true;

    return true;
}


void ContentAudioImpl::StartContentAudio(void)
{
    SelectDevice(VIRTUAL_AUDIO_DEVICE_NAME.c_str());
    
    AudioDeviceID device_id = GetDeviceIdentifier(VIRTUAL_AUDIO_DEVICE_NAME.c_str(), audioHardwarePropertyInput);
    
    if (device_id == kAudioDeviceUnknown)
    {
        return;
    }
    
    void *audio_buffer_list;
    Configuration(device_id, (void *)AudioRenderCallback, &audio_buffer_list, (void *)this);
    
    if (!_configure_completed) {
        return;
    }
    
    OSStatus status = AudioOutputUnitStart(_audio_unit);
    if (status != 0) {
        return;
    }
    
    _impl_running = true;
    _handle_data = true;
}

void ContentAudioImpl::StopContentAudio(void)
{
    if (_impl_running)
    {
        _handle_data = false;
        
        AudioOutputUnitStop(_audio_unit);
        AudioUnitUninitialize(_audio_unit);
        AudioComponentInstanceDispose(_audio_unit);
    }
    
    if (_audio_buffer_list)
    {
        FreeAudioDataBuffer(_audio_buffer_list);
    }
    
    _audio_buffer_list = NULL;
 
    
    if (_audio_buffer) 
    {
        delete[] _audio_buffer;
    }
    _audio_buffer = NULL;
    
    _impl_running = false;
    ReSelectDevice();
}

void ContentAudioImpl::SelectDevice(const char * device_name)
{
    HandleAudioDevice(_original_device);
    _original_device_mute = getCurrentOutputDeviceMuteStatus();

    bool could_found_output_device = false;
    
    AudioDeviceID devive_array[64] = {0};
    int device_number = 0;
    char temp_device_name[256] = {0};
    UInt32 out_data_size;
    
    AudioObjectPropertyAddress theAddress = 
    {
        kAudioHardwarePropertyDevices,
        kAudioObjectPropertyScopeGlobal,
        kAudioObjectPropertyElementMaster
    };
    
    AudioObjectGetPropertyDataSize(kAudioObjectSystemObject, 
                                   &theAddress,
                                   0,
                                   NULL,
                                   &out_data_size
                                   );
    
    AudioObjectGetPropertyData(kAudioObjectSystemObject, 
                               &theAddress,
                               0,
                               NULL,
                               &out_data_size,
                               devive_array
                               );
    
    device_number = (out_data_size / sizeof(AudioDeviceID));
    
    for (int i = 0; i < device_number; ++i) {
        if (!OutputDevice(devive_array[i]))
        {
            continue;
        } 
        else
        {
            UInt32 maxLen = sizeof(temp_device_name);
            
            GetDeviceName(devive_array[i],
                          audioHardwarePropertyOutput,
                          temp_device_name,
                          &maxLen
                          );
            
            if (std::string(temp_device_name) == std::string(device_name)) 
            {
                could_found_output_device = true;
                _store_device.outputProperty = audioHardwarePropertyOutput;
                _store_device.outputIdentifier = devive_array[i];
                memcpy(_store_device.outputAudioDeviceName, device_name, strlen(device_name));
                
                break;
            }
        }
    }
    
    if (could_found_output_device) 
    {
        ConfigDeviceWithProperty(_store_device.outputProperty, _store_device.outputAudioDeviceName);
        SetDeviceByMuteValue(_store_device.outputProperty, _store_device.outputAudioDeviceName, _original_device_mute);
    }
}

void ContentAudioImpl::ReSelectDevice() {
    bool is_beginning_output = true;
    
    AudioDeviceID outputIdentifier = GetDeviceIdentifier(_original_device.outputAudioDeviceName, audioHardwarePropertyOutput);
    if (outputIdentifier == kAudioObjectUnknown) 
    {
        is_beginning_output = false;
    }
  
    if (std::string(_original_device.outputAudioDeviceName) == std::string(VIRTUAL_AUDIO_DEVICE_NAME) ||
        !is_beginning_output)
    {
        HandleAudioDevice(_current_device);
      
        ConfigDeviceWithProperty(_current_device.outputProperty, _current_device.outputDefaultAudioDeviceName);
        SetDeviceByMuteValue(_current_device.defaultSystemProperty, _current_device.outputDefaultAudioDeviceName, _original_device_mute);
    }
    else
    {
        ConfigDeviceWithProperty(_original_device.outputProperty, _original_device.outputAudioDeviceName);
        SetDeviceByMuteValue(_original_device.outputProperty, _original_device.outputAudioDeviceName, _original_device_mute);
    }
}

AudioDeviceID ContentAudioImpl::GetDeviceIdentifier(const char * dev_name, AudioHardwareProperty type_property) 
{
    AudioDeviceID device_array[64];
    int devices_num = 0;
    char audio_device_name[256];
    UInt32 out_data_size;
    
    AudioObjectPropertyAddress property_Address =
    {
        kAudioHardwarePropertyDevices,
        kAudioObjectPropertyScopeGlobal,
        kAudioObjectPropertyElementMaster
    };
    
    AudioObjectGetPropertyDataSize(kAudioObjectSystemObject, 
                                   &property_Address,
                                   0,
                                   NULL,
                                   &out_data_size
                                   );
    
    AudioObjectGetPropertyData(kAudioObjectSystemObject, 
                               &property_Address,
                               0,
                               NULL,
                               &out_data_size,
                               device_array
                               );
    
    devices_num = (out_data_size / sizeof(AudioDeviceID));
    
    for (int i = 0; i < devices_num; ++i) {
        if(type_property == audioHardwarePropertyInput) 
        {
            if (!InputDevice(device_array[i]))
                continue;
        } 
        else if(type_property == audioHardwarePropertyOutput)
        {
            if (!OutputDevice(device_array[i]))
                continue;
        }
        else if (type_property == audioHardwarePropertyDefaultOutput)
        {
            if (GetDeviceProperty(device_array[i]) != audioHardwarePropertyOutput)
                continue;

        }
        
        UInt32 max_length = sizeof(audio_device_name);
        GetDeviceName(device_array[i], type_property, audio_device_name, &max_length);
        
        if (std::string(dev_name) == std::string(audio_device_name))
        {
            return device_array[i];
        }
    }
    
    return kAudioDeviceUnknown;
}

AudioBufferList *ContentAudioImpl::MallocAudioBuffer(UInt32 num_channels, UInt32 buffer_size) 
{
    AudioBufferList             *buffer_list;
    UInt32						i;
    
    buffer_list = (AudioBufferList*)calloc(1, sizeof(AudioBufferList) + num_channels * sizeof(AudioBuffer));
    if (buffer_list == NULL) {
        return NULL;
    }
    
    buffer_list->mNumberBuffers = 1;
    
    for (i = 0; i < num_channels; ++i) {
        buffer_list->mBuffers[i].mNumberChannels = num_channels;
        buffer_list->mBuffers[i].mDataByteSize = buffer_size;
        buffer_list->mBuffers[i].mData = malloc(buffer_size);
        
        if (buffer_list->mBuffers[i].mData == NULL) {
            FreeAudioDataBuffer(buffer_list);
            return NULL;
        }
    }
    
    return buffer_list;
}

void ContentAudioImpl::FreeAudioDataBuffer(AudioBufferList *buffer_list) 
{
    UInt32 i;
    
    if (buffer_list) 
    {
        for (i = 0; i < buffer_list->mNumberBuffers; i++) 
        {
            if (buffer_list->mBuffers[i].mData)
                free(buffer_list->mBuffers[i].mData);
        }
        
        free(buffer_list);
    }
}

void ContentAudioImpl::HandleAudioDevice(AudioDevice audio_device)
{
    UInt32 max_length = sizeof(audio_device.inputAudioDeviceName);
    audio_device.inputProperty = audioHardwarePropertyInput;
    audio_device.inputIdentifier = GetSelectedDeviceID(audioHardwarePropertyInput);
    GetDeviceName(audio_device.inputIdentifier,
               audioHardwarePropertyInput,
               audio_device.inputAudioDeviceName,
               &max_length);
    
    max_length = sizeof(audio_device.outputAudioDeviceName);
    audio_device.outputProperty = audioHardwarePropertyOutput;
    audio_device.outputIdentifier = GetSelectedDeviceID(audioHardwarePropertyOutput);
    GetDeviceName(audio_device.outputIdentifier,
               audioHardwarePropertyOutput,
               audio_device.outputAudioDeviceName,
               &max_length);
    
    max_length = sizeof(audio_device.outputDefaultAudioDeviceName);
    audio_device.defaultSystemProperty = audioHardwarePropertyDefaultOutput;
    audio_device.defaultOutputIdentifier = GetSelectedDeviceID(audioHardwarePropertyDefaultOutput);
    GetDeviceName(audio_device.defaultOutputIdentifier,
               audioHardwarePropertyDefaultOutput,
               audio_device.outputDefaultAudioDeviceName,
               &max_length);
}

bool ContentAudioImpl::getCurrentOutputDeviceMuteStatus() 
{
    AudioDeviceID outputIdentifier = GetSelectedDeviceID(audioHardwarePropertyOutput);;
    if (outputIdentifier == kAudioObjectUnknown)
    {
        return 0.0;
    }
    
    bool bMute = false;
    AudioDevice currentOutputDev;
    currentOutputDev.outputProperty = audioHardwarePropertyOutput;
    currentOutputDev.outputIdentifier = outputIdentifier;
    
    UInt32 maxLen = sizeof(currentOutputDev.outputAudioDeviceName);
    GetDeviceName(currentOutputDev.outputIdentifier, audioHardwarePropertyOutput, currentOutputDev.outputAudioDeviceName, &maxLen);
    
    UInt32 mute; //0: unmute; 1: mute.
    UInt32 propertySize = 0;
    OSStatus status = noErr;
    AudioObjectPropertyAddress propertyAOPA;
    propertyAOPA.mElement = kAudioObjectPropertyElementMaster;
    propertyAOPA.mSelector = kAudioDevicePropertyMute;
    propertyAOPA.mScope = kAudioDevicePropertyScopeOutput;
    
    if (!AudioHardwareServiceHasProperty(outputIdentifier, &propertyAOPA)) {
        return 0.0;
    }
    
    propertySize = sizeof(UInt32);
    status = AudioHardwareServiceGetPropertyData(outputIdentifier, &propertyAOPA, 0, NULL, &propertySize, &mute);
    if (status) {
        return 0.0;
    }
    
    if (1 == mute) {
        bMute = true;
    } else {
        bMute = false;
    }
  
    return bMute;
}

int ContentAudioImpl::ConfigDeviceWithProperty(AudioHardwareProperty property, char *device_name)
{
    AudioDeviceID select_deviceID = kAudioDeviceUnknown;
    select_deviceID = GetDeviceIdentifier(device_name, property);
    
    if (select_deviceID == kAudioDeviceUnknown) {
        return 1;
    }
    
    SetDeviceProperty(select_deviceID, property);

    return 0;
}

void ContentAudioImpl::SetDeviceByMuteValue(AudioHardwareProperty property, char *device_name, bool mute_state)
{
    AudioDeviceID select_deviceID = kAudioDeviceUnknown;
    select_deviceID = GetDeviceIdentifier(device_name, property);

    if (select_deviceID != kAudioDeviceUnknown)
    {
        SetDeviceMute(select_deviceID, property, mute_state);
    }
}

void ContentAudioImpl::GetDeviceName(AudioDeviceID device_ID, AudioHardwareProperty property, char * device_name, UInt32* max_length)
{
    AudioObjectPropertyScope theScope = kAudioDeviceUnknown;
    if (property == audioHardwarePropertyInput)
    {
        theScope = kAudioDevicePropertyScopeInput;
    } 
    else if (property == audioHardwarePropertyOutput)
    {
        theScope = kAudioDevicePropertyScopeOutput;
    }
    
    AudioObjectPropertyAddress theAddress =
    {
        kAudioDevicePropertyDeviceName,
        theScope,
        0
    };
    
    AudioObjectGetPropertyData(device_ID, &theAddress, 0, NULL, max_length, device_name);
}

AudioDeviceID ContentAudioImpl::GetSelectedDeviceID(AudioHardwareProperty property)
{
    AudioDeviceID audio_deviceID = kAudioDeviceUnknown;
    AudioObjectPropertyAddress theAddress = 
    { 
        kAudioHardwarePropertyDefaultInputDevice,
        kAudioObjectPropertyScopeGlobal,
        kAudioObjectPropertyElementMaster
    };
    
    UInt32 prop_size = sizeof(AudioDeviceID);
    
    if(property == audioHardwarePropertyInput) {
        theAddress.mSelector = kAudioHardwarePropertyDefaultInputDevice;
    } else if(property == audioHardwarePropertyOutput) {
        theAddress.mSelector = kAudioHardwarePropertyDefaultOutputDevice;
    } else {
        theAddress.mSelector = kAudioHardwarePropertyDefaultSystemOutputDevice;
    }
    
    AudioObjectGetPropertyData(kAudioObjectSystemObject,
                               &theAddress,
                               0,
                               NULL,
                               &prop_size,
                               &audio_deviceID);
    
    return audio_deviceID;
}

AudioHardwareProperty ContentAudioImpl::GetDeviceProperty(AudioDeviceID audio_deviceID)
{
    UInt32 property_size = 256;
    char buffer[256] = { 0 };
    
    AudioObjectPropertyScope theScope = kAudioDevicePropertyScopeInput;
    
    AudioObjectPropertyAddress theAddress =
    {
        kAudioDevicePropertyStreams,
        theScope,
        0
    };
    
    AudioObjectGetPropertyData(audio_deviceID,
                               &theAddress,
                               0,
                               NULL,
                               &property_size,
                               buffer);
    if (property_size > 0)
    {
        return audioHardwarePropertyOutput;
    }
    
    theAddress.mScope = kAudioDevicePropertyScopeOutput;
    
    AudioObjectGetPropertyData(audio_deviceID,
                               &theAddress,
                               0,
                               NULL,
                               &property_size,
                               buffer);
    if (property_size > 0) 
    {
        return audioHardwarePropertyInput;
    }
    
    return audioHardwarePropertyUnknown;
}

bool ContentAudioImpl::InputOrOutputDevice(AudioDeviceID audio_deviceID,AudioObjectPropertyScope property_scope)
{
    UInt32 property_size = 256;
    char buffer[256] = { 0 };
    
    AudioObjectPropertyAddress theAddress =
    {
        kAudioDevicePropertyStreams,
        property_scope,
        0
    };
    
    AudioObjectGetPropertyData(audio_deviceID,
                               &theAddress,
                               0,
                               NULL,
                               &property_size,
                               buffer);
    
  
    if (property_size > 0)
    {
        return true;
    }
    
    return false;
}

bool ContentAudioImpl::InputDevice(AudioDeviceID audio_deviceID)
{
    return InputOrOutputDevice(audio_deviceID, kAudioDevicePropertyScopeInput);
}

bool ContentAudioImpl::OutputDevice(AudioDeviceID audio_deviceID)
{
    return InputOrOutputDevice(audio_deviceID, kAudioDevicePropertyScopeOutput);
}

void ContentAudioImpl::SetDeviceProperty(AudioDeviceID device_ID, AudioHardwareProperty property)
{
    AudioObjectPropertySelector selector;
    if(property == audioHardwarePropertyInput) {
        selector = kAudioHardwarePropertyDefaultInputDevice;
    } else if(property == audioHardwarePropertyOutput) {
        selector = kAudioHardwarePropertyDefaultOutputDevice;
    } else {
        selector = kAudioHardwarePropertyDefaultSystemOutputDevice;
    }
    
    AudioObjectPropertyAddress property_address =
    {
        selector,
        kAudioObjectPropertyScopeGlobal,
        kAudioObjectPropertyElementMaster
    };
    
    UInt32 prop_size = sizeof(AudioDeviceID);
    
    AudioObjectSetPropertyData(kAudioObjectSystemObject,
                               &property_address,
                               0,
                               NULL,
                               prop_size,
                               &device_ID);
}

void ContentAudioImpl::SetDeviceMute(AudioDeviceID device_ID, AudioHardwareProperty property, bool device_mute)
{
    if (device_ID == kAudioObjectUnknown)
    {
        return;
    }
    
    UInt32 property_size = sizeof(UInt32);
    
    if(property == audioHardwarePropertyOutput)
    {
        OSStatus status = noErr;
        
        AudioObjectPropertyAddress property_address =
        {
            kAudioDevicePropertyMute,
            kAudioDevicePropertyScopeOutput,
            kAudioObjectPropertyElementMaster
        };
        
        if (!AudioHardwareServiceHasProperty(device_ID, &property_address))
        {
            return;
        }
        
        Boolean canSetMute = false;
        status = AudioHardwareServiceIsPropertySettable(device_ID, &property_address, &canSetMute);
        if (status || canSetMute == false) {
            return;
        }
        
        UInt32 mute = 1;
        if (device_mute) 
        {
            mute = 1;
        } else {
            mute = 0;
        }
        
        AudioHardwareServiceSetPropertyData(device_ID, &property_address, 0, NULL, property_size, &mute);
    }
}

 void ContentAudioImpl::Stereo2Mono(short *output_buffer, short *input_buffer, int channels, unsigned int sample_rate)
{
    int i = 0;
     
    if (channels == 2)
    {
        for (i = 0; i < sample_rate; i++) 
        {
            output_buffer[i] = (((short *)input_buffer)[2 * i]);
        }
    } 
    else 
    {
        for (i = 0; i < sample_rate * channels; i++) 
        {
            output_buffer[i] = (((short *)input_buffer)[i]);
        }
    }
}

