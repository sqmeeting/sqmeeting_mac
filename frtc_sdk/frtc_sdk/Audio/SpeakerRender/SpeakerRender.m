#import "SpeakerRender.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioConverter.h>

#define BYTES_PER_SAMPLE 2

OSStatus SpeakerRenderCallBack(void                       *inRefCon,
                               AudioUnitRenderActionFlags *ioActionFlags,
                               const AudioTimeStamp       *inTimeStamp,
                               UInt32                     inBusNumber,
                               UInt32                     inNumberFrames,
                               AudioBufferList            *ioData) {
    SpeakerRender *SELF = (__bridge SpeakerRender *)inRefCon;
    memset(ioData->mBuffers[0].mData, 0, inNumberFrames*2);
        
    if(!SELF.isMuted) {
        if(inNumberFrames % 512 != 0) {
            [SELF gainRemoteUserAudioData:ioData->mBuffers[0].mData audioDataLength:inNumberFrames * 2 sampleRate:48000];
        }
        else {
            for(int i = 0; i < inNumberFrames * 2 / 1024; i++) {
                [SELF gainRemoteUserAudioData:ioData->mBuffers[0].mData + i * 1024 audioDataLength:1024 sampleRate:48000];
            }
        }
    }
   
    return noErr;
}

@implementation SpeakerRender

- (id)init {
    self = [super init];
    if(self) {
        [self setupRenderStreamDescription];
    }
    
    return self;
}


- (OSStatus)setupSpeakerUnit {
    AudioComponent component;
    AudioComponentDescription description;
    OSStatus errorStatus = noErr;
    UInt32 param;

    description.componentType         = kAudioUnitType_Output;
    description.componentSubType      = kAudioUnitSubType_HALOutput;//'vpio';
    description.componentManufacturer = kAudioUnitManufacturer_Apple;
    description.componentFlags        = 0;
    description.componentFlagsMask    = 0;
    component = AudioComponentFindNext(NULL, &description);
    
    if(component) {
        errorStatus = AudioComponentInstanceNew(component, &speakerUnit);
        if(errorStatus != noErr) {
            speakerUnit = NULL;
            return errorStatus;
        }
    } else {
        return errorStatus;
    }
    
    if(!self.speakerDeviceID) {
        param = sizeof(AudioDeviceID);
        
        UInt32 defaultSize = sizeof(AudioDeviceID);

        const AudioObjectPropertyAddress defaultAddr = {
            kAudioHardwarePropertyDefaultOutputDevice,
            kAudioObjectPropertyScopeGlobal,
            kAudioObjectPropertyElementMaster
        };
        
        errorStatus = AudioObjectGetPropertyData(kAudioObjectSystemObject, 
                                                 &defaultAddr,
                                                 0,
                                                 NULL,
                                                 &defaultSize,
                                                 &_speakerDeviceID);
        if(errorStatus != noErr) {
            return errorStatus;
        }
    }

    errorStatus = AudioUnitSetProperty(speakerUnit,
                                       kAudioOutputUnitProperty_CurrentDevice,
                                       kAudioUnitScope_Global,
                                       0,
                                       &_speakerDeviceID,
                                       sizeof(AudioDeviceID));
    if(errorStatus != noErr) {
        param = sizeof(AudioDeviceID);
        UInt32 defaultSize = sizeof(AudioDeviceID);

        const AudioObjectPropertyAddress defaultAddr = {
            kAudioHardwarePropertyDefaultOutputDevice,
            kAudioObjectPropertyScopeGlobal,
            kAudioObjectPropertyElementMaster
        };
        
        errorStatus = AudioObjectGetPropertyData(kAudioObjectSystemObject, 
                                                 &defaultAddr,
                                                 0,
                                                 NULL,
                                                 &defaultSize,
                                                 &_speakerDeviceID);
        if(errorStatus != noErr) {
            return errorStatus;
        }

        errorStatus = AudioUnitSetProperty(speakerUnit,
                                           kAudioOutputUnitProperty_CurrentDevice,
                                           kAudioUnitScope_Global,
                                           0,
                                           &_speakerDeviceID,
                                           sizeof(AudioDeviceID));
        if(errorStatus != noErr) {
            return errorStatus;
        }
    }
    
    AURenderCallbackStruct render_callback;
    render_callback.inputProc = SpeakerRenderCallBack;
    render_callback.inputProcRefCon = (__bridge void*)self;
    
    errorStatus = AudioUnitSetProperty(speakerUnit,
                                       kAudioUnitProperty_SetRenderCallback,
                                       kAudioUnitScope_Input,
                                       0,
                                       &render_callback,
                                       sizeof(render_callback));
    if(errorStatus != noErr) {
        return errorStatus;
    }
    
    CGFloat sampleRate = 48000;
    AudioStreamBasicDescription streamFormat = [self setAudioStreamBasicDescriptionBySampleRate:sampleRate];
    errorStatus = AudioUnitSetProperty(speakerUnit,
                                       kAudioUnitProperty_StreamFormat,
                                       kAudioUnitScope_Input,
                                       0,
                                       &streamFormat,
                                       sizeof(streamFormat));
    if (errorStatus != noErr) {
        return errorStatus;
    }

    errorStatus = AudioUnitInitialize(speakerUnit);
    if(errorStatus != noErr) {
        return errorStatus;
    }

    UInt32 fAudioSamples = 124472;
    param = sizeof(UInt32);
    errorStatus = AudioUnitSetProperty(speakerUnit,
                                       kAudioUnitProperty_MaximumFramesPerSlice,
                                       kAudioUnitScope_Global,
                                       0,
                                       &fAudioSamples,
                                       param);
    if(errorStatus != noErr) {
        return errorStatus;
    }
    
    return  noErr;
}

- (OSStatus)disableAudioOutputSpeakerUnit {
    OSStatus status = noErr;
    if(speakerUnit != NULL) {
        status = AudioOutputUnitStop(speakerUnit);
        speakerUnit = NULL;
    }
    
    return  status;
}

- (OSStatus)enableAudioOutputSpeakerUnit {
    OSStatus status = noErr;
    
    if(speakerUnit != NULL) {
        status = AudioOutputUnitStart(speakerUnit);
    }
    
    return status;
}

- (void)removeAudioOutputSpeakerUnit {
    if(speakerUnit) {
        AudioOutputUnitStop(speakerUnit);
        AudioUnitUninitialize(speakerUnit);
        AudioComponentInstanceDispose(speakerUnit) ;
    }
    
    speakerUnit = NULL;
}

-(AudioStreamBasicDescription)setAudioStreamBasicDescriptionBySampleRate:(CGFloat)sampleRate {
    AudioStreamBasicDescription format;
    format.mSampleRate = sampleRate;
    format.mFormatID = kAudioFormatLinearPCM;
    format.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    format.mBytesPerPacket   = BYTES_PER_SAMPLE;
    format.mFramesPerPacket  = 1;  // uncompressed.
    format.mBytesPerFrame    = BYTES_PER_SAMPLE;
    format.mChannelsPerFrame = 1;
    format.mBitsPerChannel   = 8 * BYTES_PER_SAMPLE;
    
    return format;
}

- (void)setupRenderStreamDescription {
    memset((void *)&audioStreamRenderDescription, 0, sizeof(AudioStreamBasicDescription));
 
    audioStreamRenderDescription.mFormatID    = kAudioFormatLinearPCM;
    audioStreamRenderDescription.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    
    audioStreamRenderDescription.mSampleRate       = 48000;
    audioStreamRenderDescription.mChannelsPerFrame = 1;
    audioStreamRenderDescription.mBitsPerChannel   = 16;
    audioStreamRenderDescription.mBytesPerFrame    = 16/8;
    audioStreamRenderDescription.mFramesPerPacket  = 1;
    audioStreamRenderDescription.mBytesPerPacket   = audioStreamRenderDescription.mBytesPerFrame;
}

- (void)gainRemoteUserAudioData:(void *)audioBuffer audioDataLength:(unsigned int)audioDatalength sampleRate:(unsigned int )sampleRate {
    if(self.speakerDelegate && [self.speakerDelegate respondsToSelector:@selector(gainRemoteUserAudioData:audioDataLength:sampleRate:)]) {
        [self.speakerDelegate gainRemoteUserAudioData:audioBuffer audioDataLength:audioDatalength sampleRate:sampleRate];
    }
}

@end
