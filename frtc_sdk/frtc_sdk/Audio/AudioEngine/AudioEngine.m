#import "AudioEngine.h"
#import "FrtcSDKBundle.h"
#import <AVFoundation/AVFoundation.h>
#import <Accelerate/Accelerate.h>
#import "AudioDevice.h"

#define LEVEL_LOWPASS_TRIG 0.3

typedef void (^TestSpeakerHandler)(float meter, BOOL testing);

typedef void (^TestMicphoneHandler)(float meter, BOOL testing);

static AudioEngine *sharedAudioEngine = nil;

@interface AudioEngine ()

@property (nonatomic, strong) AVAudioEngine     *audioEngine;
@property (nonatomic, strong) AVAudioUnitReverb *reverbNode;
@property (nonatomic, strong) AVAudioPlayerNode *playerNode;
@property (nonatomic, strong) AVAudioFile       *audioFile;
@property (nonatomic, strong) AVAudioPCMBuffer  *buffer;

@property (nonatomic, assign) float averagePowerForChannel0;
@property (nonatomic, assign) float averagePowerForChannel1;

@property (nonatomic, strong) NSMutableArray    *_audioOutputDevice;
@property (nonatomic, assign) AudioDeviceID deviceID;
@property (nonatomic, assign) AudioDeviceID inputIdentifier;

@property (strong, nonatomic) NSTimer *timer;

@property (nonatomic, assign, getter=isTesting) BOOL testing;

@property (nonatomic, copy) TestSpeakerHandler speakerTestHandler;

@property (nonatomic, copy) TestMicphoneHandler micphoneTestHandler;

@end


@implementation AudioEngine

+ (AudioEngine *)sharedAudioEngine {
    if (sharedAudioEngine == nil) {
        @synchronized(self) {
            if (sharedAudioEngine == nil) {
                sharedAudioEngine = [[AudioEngine alloc] init];
                
            }
        }
    }
    return sharedAudioEngine;
}


- (instancetype)init {
    self = [super init];
    
    if(self) {
        self.audioEngine = [[AVAudioEngine alloc] init];
        self.playerNode = [[AVAudioPlayerNode alloc] init];
        
        NSError *error;
        NSString *soundPath = [FrtcSDKBundle bundlePath:@"audio_test.wav"];
        NSURL *soudUrl =  [NSURL fileURLWithPath:soundPath];
        
        self.audioFile = [[AVAudioFile alloc] initForReading:soudUrl error:&error];
        if(error) {
            NSLog(@"AVAudioFile error");
            //return;
        }
        
        AVAudioFormat *format = self.audioFile.processingFormat;
        AVAudioFrameCount capacity = (AVAudioFrameCount)self.audioFile.length;
        
        self.buffer = [[AVAudioPCMBuffer alloc] initWithPCMFormat:format frameCapacity:capacity];
        // Read AVAudioFile -> AVAudioPCMBuffer
        [self.audioFile readIntoBuffer:self.buffer error:nil];
    }
    
    return self;
}

- (void)setupPlaynode {
    NSError *error = nil;
    AudioUnit outputUnit = self.audioEngine.outputNode.audioUnit;
    self.deviceID = [[AudioDevice sharedAudioDevice] getSpeakerIDByName:self.currentDeviceName];
    AudioDeviceID outputIdentifier = self.deviceID;
    
    AudioComponent                   component;
    AudioComponentDescription        description;
    OSStatus    err = noErr;
    UInt32 param;
    
    description.componentType = kAudioUnitType_Output;
    description.componentSubType = kAudioUnitSubType_HALOutput;//'vpio';
    description.componentManufacturer = kAudioUnitManufacturer_Apple;
    description.componentFlags = 0;
    description.componentFlagsMask = 0;
    component = AudioComponentFindNext(NULL, &description);
    
    if(component) {
        err = AudioComponentInstanceNew(component, &outputUnit);
        if(err != noErr) {
            NSLog(@"InitAudioUnit::AudioComponentInstanceNew failed!");
            outputUnit = NULL;
            return ;
        }
    } else {
        NSLog(@"InitAudioUnit::AudioComponentFindNext failed!");
        return ;
    }
    
    
    if(!outputIdentifier) {
        // Select the default output device
        param = sizeof(AudioDeviceID);
        err = AudioHardwareGetProperty(kAudioHardwarePropertyDefaultOutputDevice,
                                       &param,
                                       &outputIdentifier);
        if(err != noErr)
        {
            NSLog(@"failed to get default input device\n");
            return ;
        }
    }
    
    
    // Set the current device to the default output unit.
    err = AudioUnitSetProperty(self.audioEngine.outputNode.audioUnit,
                               kAudioOutputUnitProperty_CurrentDevice,
                               kAudioUnitScope_Global,
                               0,
                               &outputIdentifier,
                               sizeof(AudioDeviceID));
    if(err != noErr) {
        NSLog(@"failed to set AU output device, try default output device\n");
        // Select the default output device
        param = sizeof(AudioDeviceID);
        err = AudioHardwareGetProperty(kAudioHardwarePropertyDefaultOutputDevice,
                                       &param,
                                       &outputIdentifier);
        if(err != noErr) {
            NSLog(@"failed to get default input device\n");
            return ;
        }
        
        err = AudioUnitSetProperty(self.audioEngine.outputNode.audioUnit,
                                   kAudioOutputUnitProperty_CurrentDevice,
                                   kAudioUnitScope_Global,
                                   0,
                                   &outputIdentifier,
                                   sizeof(AudioDeviceID));
        if(err != noErr) {
            NSLog(@"failed to set AU default output device, end!\n");
            return ;
        }
    }
    
    [self.audioEngine attachNode:self.playerNode];
    [self.audioEngine connect:self.playerNode
                           to:self.audioEngine.mainMixerNode
                       format:self.audioFile.processingFormat];
    
    AVAudioFormat *format = [self.audioEngine.outputNode outputFormatForBus:0];
    [self.audioEngine connect:self.audioEngine.mainMixerNode
                           to:self.audioEngine.outputNode
                       format:format];
    [self.audioEngine prepare];
    
    if (![self.audioEngine startAndReturnError:&error]) {
        NSLog(@"Error");
        return;
    }
}

- (void)playWithHandler:(void (^)(float meter, BOOL testing))testSpeakerHandler {
    self.speakerTestHandler = testSpeakerHandler;
    [self setupPlaynode];
    [self.playerNode play];
    
    [self.playerNode scheduleBuffer:self.buffer atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];

    __weak __typeof(self)weakSelf = self;
    [self.audioEngine.mainMixerNode installTapOnBus:0 bufferSize:1024 format:[self.audioEngine.mainMixerNode outputFormatForBus:0]  block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {

        [buffer setFrameLength:1024];
        UInt32 inNumberFrames = buffer.frameLength;
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.testing = YES;
        if(buffer.format.channelCount > 0) {

            Float32* samples = (Float32*)buffer.floatChannelData[0];
            Float32 avgValue = 0;
            
            vDSP_meamgv((Float32*)samples, 1, &avgValue, inNumberFrames);
            strongSelf.averagePowerForChannel0 = (LEVEL_LOWPASS_TRIG*((avgValue==0)?-100:20.0*log10f(avgValue))) + ((1-LEVEL_LOWPASS_TRIG)*self.averagePowerForChannel0) ;
            strongSelf.averagePowerForChannel1 = self.averagePowerForChannel0;
        }
        
        if(buffer.format.channelCount > 1) {
            Float32* samples = (Float32*)buffer.floatChannelData[1];
            Float32 avgValue = 0;
            
            vDSP_meamgv((Float32*)samples, 1, &avgValue, inNumberFrames);
            strongSelf.averagePowerForChannel1 = (LEVEL_LOWPASS_TRIG * ((avgValue == 0) ? -100 : 20.0 * log10f(avgValue))) + ((1-LEVEL_LOWPASS_TRIG) * strongSelf.averagePowerForChannel1) ;
        }
        
        double percentage = pow(10, (0.05 * self.averagePowerForChannel0));
        Float32 volume = self.audioEngine.mainMixerNode.outputVolume;
        if(volume > 0.5 && volume <= 0.7) {
            volume = 1.6;
        } else if(volume > 0.7 && volume <= 1.0) {
            volume = 1.9;
        } else if(volume > 0.3 && volume <= 0.5) {
            volume = 1.5;
        } else if(volume > 0.2 && volume <= 0.3) {
            volume = 1.2;
        }
        
        CGFloat test = 8 * percentage;
        strongSelf.speakerTestHandler(test, YES);
    }];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(successfullTest)
                                                userInfo:nil
                                                 repeats:NO];
}

- (void)successfullTest {
    if(self.isTesting) {
        NSLog(@"----------------successs--------------------");
    } else {
        NSLog(@"----------------failure---------------------");
        [self stopPlay];
        [self playWithHandler:self.speakerTestHandler];
    }
}

- (void)stopPlay {
    NSLog(@"------stopPlay------------");
    [self.timer invalidate];
    self.timer = nil;
    [self.audioEngine.mainMixerNode removeTapOnBus:0];
    self.testing = NO;
    [self.playerNode stop];
    [self.audioEngine stop];
    self.speakerTestHandler(-1, NO);
}

- (void)startRecord:(void (^)(float meter, BOOL testing))testMicphoneHandler {
    self.micphoneTestHandler = testMicphoneHandler;
    
    AVAudioInputNode *inputNode = self.audioEngine.inputNode;
    AudioUnit inputUnit = self.audioEngine.inputNode.audioUnit;
    
    self.inputIdentifier = [[AudioDevice sharedAudioDevice] getMicIDByName:self.currentMicphoneName];
    
    AudioDeviceID inputIdentifier = self.inputIdentifier;
    OSStatus status = noErr;
    AudioComponent component;
    AudioComponentDescription description;
    AudioObjectPropertyAddress theAddress = {kAudioHardwarePropertyDefaultInputDevice,
                                             kAudioObjectPropertyScopeGlobal,
                                             kAudioObjectPropertyElementMaster};

    description.componentType = kAudioUnitType_Output;
    description.componentSubType = kAudioUnitSubType_HALOutput;//'vpio';
    description.componentManufacturer = kAudioUnitManufacturer_Apple;
    description.componentFlags = 0;
    description.componentFlagsMask = 0;
    component = AudioComponentFindNext(NULL, &description);
    
    if(component) {
        status = AudioComponentInstanceNew(component, &inputUnit);
        if(status != noErr) {
            NSLog(@"InitAudioUnit::AudioComponentInstanceNew failed!");
            inputUnit = NULL;
            return ;
        }
    } else {
        NSLog(@"InitAudioUnit::AudioComponentFindNext failed!");
        return ;
    }
    
    if(!inputIdentifier)
     {
         // Select the default input device
         UInt32 param = sizeof(AudioDeviceID);
         status = AudioObjectGetPropertyData(kAudioObjectSystemObject, 
                                             &theAddress,
                                             0,
                                             NULL,
                                             &param,
                                             &inputIdentifier);
         
         NSLog(@"[%s] after AudioHardwareGetProperty, err = %ld", __FUNCTION__, (long)status);
         if(status != noErr)
         {
             NSLog(@"failed to get default input device\n");
             return ;
         }
     }
    
    UInt32 enableIO;
    enableIO = 1; // Enable input
    status = AudioUnitSetProperty(self.audioEngine.inputNode.audioUnit,
                                  kAudioOutputUnitProperty_EnableIO,
                                  kAudioUnitScope_Input,
                                  1,
                                  &enableIO,
                                  sizeof(enableIO));
    if(status != 0)
    {
        NSLog(@"Configure: kAudioOutputUnitProperty_EnableIO: enable input failed: status = %ld\n", (long)status);
        return ;
    }
    
    enableIO = 1; // Disable output
    status = AudioUnitSetProperty(self.audioEngine.inputNode.audioUnit,
                                  kAudioOutputUnitProperty_EnableIO,
                                  kAudioUnitScope_Output,
                                  0,
                                  &enableIO,
                                  sizeof(enableIO));
    if(status != 0)
    {
        NSLog(@"Configure: kAudioOutputUnitProperty_EnableIO: disable output failed: status = %ld\n", (long)status);
        return ;
    }
    
    // Set the input to our mic
    status = AudioUnitSetProperty(self.audioEngine.inputNode.audioUnit,
                                  kAudioOutputUnitProperty_CurrentDevice,
                                  kAudioUnitScope_Global,
                                  0,
                                  &inputIdentifier,
                                  sizeof(AudioDeviceID));
    if(status != 0)
    {
        NSLog(@"Configure: AudioHardwareGetProperty: failed: status = %ld\n", (long)status);
        return ;
    }
    
    AVAudioFormat *formate = [inputNode inputFormatForBus:0];
    
    __weak __typeof(self)weakSelf = self;
    [inputNode installTapOnBus:0 bufferSize:1024 format:formate block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        
        [buffer setFrameLength:1024];
        UInt32 inNumberFrames = buffer.frameLength;
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if(buffer.format.channelCount > 0) {
            Float32* samples = (Float32*)buffer.floatChannelData[0];
            Float32 avgValue = 0;

            vDSP_meamgv((Float32*)samples, 1, &avgValue, inNumberFrames);
            strongSelf.averagePowerForChannel0 = (LEVEL_LOWPASS_TRIG * ((avgValue == 0) ? -100 : 20.0 * log10f(avgValue))) + ((1 - LEVEL_LOWPASS_TRIG) * strongSelf.averagePowerForChannel0) ;
            strongSelf.averagePowerForChannel1 = strongSelf.averagePowerForChannel0;
            
            NSLog(@"The averagePowerFor chanel is %f", self.averagePowerForChannel0);
        }

        if(buffer.format.channelCount > 1) {
            Float32* samples = (Float32*)buffer.floatChannelData[1];
            Float32 avgValue = 0;

            vDSP_meamgv((Float32*)samples, 1, &avgValue, inNumberFrames);
            strongSelf.averagePowerForChannel1 = (LEVEL_LOWPASS_TRIG*((avgValue == 0) ? -100:20.0 * log10f(avgValue))) + ((1-LEVEL_LOWPASS_TRIG) * strongSelf.averagePowerForChannel1) ;
        }
    
        double percentage = pow (10, (0.05 * self.averagePowerForChannel0));

        CGFloat test = 10 * percentage;
        strongSelf.micphoneTestHandler(test, YES);
    }];
    
    [self.audioEngine prepare];
    [self.audioEngine startAndReturnError:nil];
}

- (void)stopRecord {
    [self.audioEngine.inputNode removeTapOnBus:0];
    [self.audioEngine stop];
    self.micphoneTestHandler(-1, NO);
}

@end
