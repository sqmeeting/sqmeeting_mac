#import "MicphoneCapture.h"
#import "FrtcCall.h"
#include <mach/mach_time.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioConverter.h>

#define OUTPUT_AUDIO_BUFFER_SIZE_PER_20_FRAMES           50

// Convenience function to dispose of our audio buffers
static void DestroyAudioBufferList(AudioBufferList* list)
{
    UInt32 i;
    if(list)
    {
        for(i = 0; i < list->mNumberBuffers; i++)
        {
            if(list->mBuffers[i].mData)
                free(list->mBuffers[i].mData);
        }
        free(list);
    }
}
 
// Convenience function to allocate our audio buffers
static AudioBufferList * allocateAudioBufferList(UInt32 numChannels, UInt32 size)
{
    AudioBufferList* list;
    UInt32 i;
     
    list = (AudioBufferList*)malloc(sizeof(AudioBufferList) + numChannels * sizeof(AudioBuffer));
    if(list == NULL)
        return NULL;
     
    list->mNumberBuffers = numChannels;
    for(i = 0; i < numChannels; ++i)
    {
        list->mBuffers[i].mNumberChannels = 1;
        list->mBuffers[i].mDataByteSize = size;
        list->mBuffers[i].mData = malloc(size);
        if(list->mBuffers[i].mData == NULL)
        {
            DestroyAudioBufferList(list);
            return NULL;
        }
    }
    return list;
}

OSStatus AudioInputProc(void* inRefCon, 
                        AudioUnitRenderActionFlags* ioActionFlags,
                        const AudioTimeStamp* inTimeStamp,
                        UInt32 inBusNumber,
                        UInt32 inNumberFrames,
                        AudioBufferList* ioData)
{
    OSStatus err = noErr;
         
    mach_timebase_info_data_t theTimeBaseInfo;
    mach_timebase_info(&theTimeBaseInfo);
    
    if(inNumberFrames > 4096)
    {
        return err;
    }
         
    MicphoneCapture *SELF = (__bridge MicphoneCapture*)inRefCon;
    if(SELF->audioBufferList->mBuffers[0].mDataByteSize != inNumberFrames*sizeof(short))
    {
        SELF->audioBufferList->mBuffers[0].mDataByteSize = inNumberFrames*sizeof(short);
        free(SELF->audioBufferList->mBuffers[0].mData);
        SELF->audioBufferList->mBuffers[0].mData = malloc(inNumberFrames*sizeof(short));
    }
        
    err = AudioUnitRender(SELF->myAudioUnit, 
                          ioActionFlags,
                          inTimeStamp,
                          inBusNumber,
                          inNumberFrames,
                          SELF->audioBufferList);
    if (err != noErr)
    {
        return err;
    }
    else
    {
        int offset = SELF->index;
 
        memcpy(SELF->dataTempBuffer + offset, 
               SELF->audioBufferList->mBuffers[0].mData,
               inNumberFrames * sizeof(short));
        
        SELF->index += inNumberFrames;
        if(SELF->index < SELF->outputAudioCaptureMicphoneFrameSize)
            return  noErr;
        
        [SELF sendMicphoneCaptureData:(unsigned char*) SELF->dataTempBuffer dataLength:SELF->outputAudioCaptureMicphoneFrameSize * sizeof(short)];

        if(SELF->index > SELF ->outputAudioCaptureMicphoneFrameSize)
        {
            memcpy(&SELF->dataTempBuffer[0], &SELF->dataTempBuffer[SELF->outputAudioCaptureMicphoneFrameSize], (SELF->index - SELF->outputAudioCaptureMicphoneFrameSize) * sizeof(short));
        }
        
        SELF->index -= SELF -> outputAudioCaptureMicphoneFrameSize;
        
        return noErr;
    }
}

typedef void (^TestMicphoneHandler)(float meter, BOOL testing);

@interface MicphoneCapture()

@property (nonatomic, assign, getter=isEnable) BOOL enable;

@property (nonatomic, copy) TestMicphoneHandler testHandler;

@end

@implementation MicphoneCapture



- (id)init {
    self = [super init];
   
    return self;
}

- (OSStatus)setupMicphoneCaptureUnit {
    OSStatus errorCodestatus = noErr;
    AudioComponent            component;
    AudioComponentDescription description;
    
    AudioObjectPropertyAddress theAddress =  {
        kAudioHardwarePropertyDefaultInputDevice,
        kAudioObjectPropertyScopeGlobal,
        kAudioObjectPropertyElementMaster
    };

    description.componentType = kAudioUnitType_Output;
    description.componentSubType = kAudioUnitSubType_HALOutput;
    description.componentManufacturer = kAudioUnitManufacturer_Apple;
    description.componentFlags = 0;
    description.componentFlagsMask = 0;
    component = AudioComponentFindNext(NULL, &description);
    
    if(component) {
        errorCodestatus = AudioComponentInstanceNew(component, &myAudioUnit);
        if(errorCodestatus != noErr) {
            myAudioUnit = NULL;
            return errorCodestatus;
        }
    } else {
        return errorCodestatus;
    }
    
    if(!_micphoneDevice) {
        UInt32 param = sizeof(AudioDeviceID);
        errorCodestatus = AudioObjectGetPropertyData(
                                                     kAudioObjectSystemObject,
                                                     &theAddress,
                                                     0,
                                                     NULL,
                                                     &param,
                                                     &_micphoneDevice
                                                     );
    
         if(errorCodestatus != noErr) {
             return errorCodestatus;
         }
     }
    
    
    UInt32 enableIO;
    enableIO = 1;
    errorCodestatus = AudioUnitSetProperty(
                                           myAudioUnit,
                                           kAudioOutputUnitProperty_EnableIO,
                                           kAudioUnitScope_Input,
                                           1,
                                           &enableIO,
                                           sizeof(enableIO)
                                           );
    if(errorCodestatus != 0) {
        return errorCodestatus;
    }
    
    enableIO = 0; // Disable output
    errorCodestatus = AudioUnitSetProperty(
                                           myAudioUnit,
                                           kAudioOutputUnitProperty_EnableIO,
                                           kAudioUnitScope_Output,
                                           0,
                                           &enableIO,
                                           sizeof(enableIO)
                                           );
    if(errorCodestatus != 0) {
        return errorCodestatus;
    }
    
    // Set the input to our mic
    errorCodestatus = AudioUnitSetProperty(
                                           myAudioUnit,
                                           kAudioOutputUnitProperty_CurrentDevice,
                                           kAudioUnitScope_Global,
                                           0, 
                                           &_micphoneDevice,
                                           sizeof(AudioDeviceID)
                                           );
    if(errorCodestatus != 0) {
        return errorCodestatus;
    }
 
    [self setupAudioStreamDescirptionFormat];
    
    AURenderCallbackStruct audioInputRender;
    audioInputRender.inputProc = AudioInputProc;
    audioInputRender.inputProcRefCon = (__bridge void *)self;
    

    errorCodestatus = AudioUnitSetProperty (
                                            myAudioUnit,
                                            kAudioOutputUnitProperty_SetInputCallback,
                                            kAudioUnitScope_Global,
                                            0,
                                            &audioInputRender,
                                            sizeof(audioInputRender)
                                            );
    if(errorCodestatus != noErr) {
        return errorCodestatus;
    }
       
    errorCodestatus = AudioUnitInitialize(myAudioUnit);
    if(errorCodestatus != 0) {
        return errorCodestatus;
    }
    
    return noErr;
}

- (OSStatus)setupAudioStreamDescirptionFormat {
    AudioStreamBasicDescription format;
    AudioObjectPropertyAddress theAddress = {kAudioHardwarePropertyDefaultInputDevice,
                                             kAudioObjectPropertyScopeGlobal,
                                             kAudioObjectPropertyElementMaster};
    
    UInt32 size = sizeof(AudioStreamBasicDescription);
    OSStatus status = AudioUnitGetProperty(myAudioUnit, 
                                           kAudioUnitProperty_StreamFormat,
                                           kAudioUnitScope_Input,
                                           1,
                                           &format,
                                           &size);
    if(status != noErr) {
        return status;
    }
    
    outputStreamBasicformat.mSampleRate      = format.mSampleRate;
    outputStreamBasicformat.mFormatID        = kAudioFormatLinearPCM;
    outputStreamBasicformat.mFormatFlags     = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    outputStreamBasicformat.mBitsPerChannel  = sizeof(short)*8;
    outputStreamBasicformat.mBytesPerFrame   = outputStreamBasicformat.mBitsPerChannel/8;
    outputStreamBasicformat.mBytesPerPacket  = outputStreamBasicformat.mBytesPerFrame;
    outputStreamBasicformat.mFramesPerPacket = 1;
    outputStreamBasicformat.mChannelsPerFrame= 1;
    outputStreamBasicformat.mReserved        = 0;

    status = AudioUnitSetProperty(
                                  myAudioUnit,
                                  kAudioUnitProperty_StreamFormat,
                                  kAudioUnitScope_Output,
                                  1,
                                  &outputStreamBasicformat,
                                  sizeof(AudioStreamBasicDescription)
                                  );
    if(status != 0) {
        return status;
    }
    
    outputStreamSampleRate = (int)outputStreamBasicformat.mSampleRate;
    size = sizeof(UInt32);
    
    //10 ms
    UInt32 frameSize = (outputStreamSampleRate == 16000 || outputStreamSampleRate == 8000) ? 128 : outputStreamSampleRate/100;
    frameSize = (outputStreamSampleRate == 192000) ? 512 : frameSize;
    
    status = AudioUnitSetProperty(
                                  myAudioUnit,
                                  kAudioDevicePropertyBufferFrameSize,
                                  kAudioUnitScope_Global,
                                  0,
                                  &frameSize,
                                  size
                                  );
    if(status != noErr) {
        NSLog(@"Configure: warning: failed to set audio sample size\n");
        return status;
    }

    AudioValueRange    valueRange;
    size = sizeof(AudioValueRange);
    theAddress.mSelector = kAudioDevicePropertyBufferFrameSizeRange;
    status = AudioObjectGetPropertyData(_micphoneDevice, 
                                        &theAddress,
                                        0,
                                        NULL,
                                        &size,
                                        &valueRange);
    if(status != noErr) {
        return status;
    }
 
    if(frameSize < (int)valueRange.mMinimum) {
        frameSize = (int)valueRange.mMinimum;
    }
    
    if(frameSize > (int)valueRange.mMaximum) {
        frameSize = (int)valueRange.mMaximum;
    }

    size = sizeof(UInt32);
    status = AudioUnitGetProperty(
                                  myAudioUnit,
                                  kAudioDevicePropertyBufferFrameSize,
                                  kAudioUnitScope_Global,
                                  0,
                                  &frameSize,
                                  &size
                                  );
    
    if(status != noErr) {
        return status;
    }
    
    outputAudioPerFrameSize = frameSize;
    
    //20 ms
    outputAudioFrameSize = (outputStreamSampleRate / 100) * 2;
    outputAudioBufferSize =  OUTPUT_AUDIO_BUFFER_SIZE_PER_20_FRAMES * outputAudioFrameSize;
    
    [self initAudioBuffer];

    return noErr;
}

- (void)initAudioBuffer {
    if(audioBufferList) {
        DestroyAudioBufferList(audioBufferList);
        audioBufferList = NULL;
    }
    
    audioBufferList = allocateAudioBufferList(outputStreamBasicformat.mChannelsPerFrame, outputAudioPerFrameSize * outputStreamBasicformat.mBytesPerFrame);
    
    outputAudioCaptureMicphoneFrameSize = (int)((outputStreamSampleRate * 20.f) / 1000.f);
    index = 0;
    dataTempBuffer = (short*) malloc(3840 * 2 * sizeof(short));
}

- (OSStatus)disableAudioInputMicphoneUnit {
    OSStatus errorStatus = noErr;
    if(myAudioUnit != NULL) {
        errorStatus = AudioOutputUnitStop(myAudioUnit);
        
        if(errorStatus != noErr) {
            NSLog(@"failed to disableAudioInputMicphoneUnit");
        }

        myAudioUnit = NULL;
        
        if(self.testHandler) {
            self.testHandler(-1, NO);
        }
    }
    
    return errorStatus;
}

- (OSStatus)enableAudioInputMicphoneUnit {
    OSStatus errorStatus = noErr;
    
    if(myAudioUnit != NULL) {
        errorStatus = AudioOutputUnitStart(myAudioUnit);
        if(errorStatus != noErr)
            NSLog(@"failed to enableAudioInputMicphoneUnit");
    }
    
    return  errorStatus;
}

- (void)testAudioUnitSourceMicphone:(BOOL)enable withHandler:(void (^)(float meter, BOOL testing))testMicHandler {
    self.enable = enable;
    if(enable) {
        self.testHandler = testMicHandler;
    }
    
    if(self.enable) {
        [self enableAudioInputMicphoneUnit];
    } else {
        if(![[FrtcCall sharedFrtcCall] isInCall]) {
            [self disableAudioInputMicphoneUnit];
        } else {
            if(self.testHandler) {
                self.testHandler(-1, NO);
            }
        }
    }
}

- (OSStatus)removeAudioInputMicphoneUnit {
    OSStatus err = noErr;
    
    if(myAudioUnit) {
        AudioOutputUnitStop(myAudioUnit);
        AudioUnitUninitialize(myAudioUnit);
        AudioComponentInstanceDispose (myAudioUnit);
        myAudioUnit = NULL;
    }
    
    return  err;
}

- (void)initSampleRateConvert {
    if(audioConvert)
        AudioConverterDispose(audioConvert);
    
    audioConvert = 0;
    
    asbdAec.mFormatID          = kAudioFormatLinearPCM;
    asbdAec.mFormatFlags       = kLinearPCMFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    asbdAec.mSampleRate        = 48000;
    asbdAec.mChannelsPerFrame  = 1;
    asbdAec.mBitsPerChannel    = 16;
    asbdAec.mBytesPerFrame     = 16/8;
    asbdAec.mFramesPerPacket   = 1;
    asbdAec.mBytesPerPacket    = asbdAec.mBytesPerFrame;
        
    asbdHw.mFormatID          = kAudioFormatLinearPCM;
    asbdHw.mFormatFlags       = kLinearPCMFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    
    asbdHw.mSampleRate        = outputStreamBasicformat.mSampleRate;
    asbdHw.mChannelsPerFrame  = 1;
    asbdHw.mBitsPerChannel    = 16;
    asbdHw.mBytesPerFrame     = 2;
    asbdHw.mFramesPerPacket   = 1;
    asbdHw.mBytesPerPacket    = asbdHw.mBytesPerFrame;
    
    OSStatus err = AudioConverterNew(&asbdHw, &asbdAec, &audioConvert);
    if(err)
        NSLog(@"AudioConverterNew failed! ");
        
    UInt32 quality = kAudioConverterQuality_Medium;//kAudioConverterQuality_Max
    // trying compute number of requested data more predictably also
    // for the first request
    UInt32 primeMethod = kConverterPrimeMethod_None;
    err = AudioConverterSetProperty(audioConvert,
                                    kAudioConverterSampleRateConverterQuality,
                                    sizeof(UInt32),
                                    &quality);
    if(err)
        NSLog(@"AudioConverterSetProperty(kAudioConverterSampleRateConverterQuality) failed!");
    err = AudioConverterSetProperty(audioConvert,
                                    kAudioConverterPrimeMethod,
                                    sizeof(UInt32),
                                    &primeMethod);
    if(err)
        NSLog(@"AudioConverterSetProperty(kAudioConverterPrimeMethod) failed!");
}

- (void)sendMicphoneCaptureData:(unsigned char *)audioDataBuffer dataLength:(int)length; {
    if(self.enable) {
        float meter = 0;
        [self parseMicAudio:audioDataBuffer numFrames:length / 2 enegry:&meter];
        self.testHandler(meter * 6, YES);
    }
    
    if([[FrtcCall sharedFrtcCall] isInCall]) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(sendMicphoneCaptureData:dataLength:captureSampleRate:)]) {
            [self.delegate sendMicphoneCaptureData:audioDataBuffer dataLength:length captureSampleRate:outputStreamBasicformat.mSampleRate];
        }
    }
}

- (bool)parseMicAudio:(unsigned char* )pData numFrames:(int)nNumFrames enegry:(float*)meter {
    int nNumChannels = 1;
    float temp_energy = 0.0f;

    if (nNumChannels == 1 ) {
        short* pF = (short*)pData;
        for (int i = 0; i < nNumFrames; ++i) {
            float e = (float)pF[i];
            if (e < 0) e = -e;
            if (e > 32767) e = 32767;
            temp_energy += e;
        }
    }
    
    temp_energy *= (1. / nNumFrames);
    temp_energy /= 32767.0f;

    if (meter) {
        *meter = temp_energy;
    }

    return true;
}

@end
