#import "AudioDevice.h"

static AudioDevice *sharedAudioDevice = nil;

@interface AudioDevice ()

@property (nonatomic, strong) NSMutableArray    *_audioOutputDevice;

@property (nonatomic, strong) NSMutableArray    *_audioInputDevice;

@end

@implementation AudioDevice

+ (AudioDevice *)sharedAudioDevice {
    if (sharedAudioDevice == nil) {
        @synchronized(self) {
            if (sharedAudioDevice == nil) {
                sharedAudioDevice = [[AudioDevice alloc] init];
               
            }
        }
    }
    
    return sharedAudioDevice;
}

- (instancetype)init {
    self = [super init];
    
    if(self) {
        self._audioOutputDevice = [[NSMutableArray alloc] init];
        self._audioInputDevice  = [[NSMutableArray alloc] init];
        [self updateSpeakers];
        [self updateMicphones];
    }
    
    return self;
}

- (AudioDeviceID)getMicIDByName:(NSString *)name {
    int index = 0;
    AudioDeviceID id = 0;
    
    for (; index < [self._audioInputDevice count]; index++) {
        NSMutableDictionary *device = [self._audioInputDevice objectAtIndex:index];
        NSString *devicename = [device objectForKey:@"name"];
        
        if([devicename isEqualToString:name]) {
            NSNumber *micID = [device objectForKey:@"audioDeviceID"];
            unsigned int audioid = [micID unsignedIntValue];
            id = (AudioDeviceID)audioid;
            break;
        }
    }
    
    return id;
}

- (AudioDeviceID)getSpeakerIDByName:(NSString*)name {
    int index = 0;
    AudioDeviceID id = 0;
    
    for (; index < [self._audioOutputDevice count]; index++) {
        NSMutableDictionary *device = [self._audioOutputDevice objectAtIndex:index];
        NSString *devicename = [device objectForKey:@"name"];
        
        if([devicename isEqualToString:name]) {
            NSNumber *speakerID = [device objectForKey:@"audioDeviceID"];
            unsigned int audioid = [speakerID unsignedIntValue];
            id = (AudioDeviceID)audioid;
            break;
        }
    }
    
    return id;
}

- (Float32)getVolumeForDevice:(AudioDeviceID)deviceID withDirection:(int)direction {
    if (deviceID == kAudioDeviceUnknown) {
        return 0;
    }
    
    OSStatus ossStat = noErr;
    Float32 volume;
    UInt32 sizeOfVol = sizeof(volume);
    
#ifndef MAC_OS_X_VERSION_10_6
    ossStat = AudioDeviceGetProperty(deviceID, 
                                 0, 
                                 direction,
                                 kAudioDevicePropertyVolumeScalar,
                                 &sizeOfVol, 
                                 &volume);
#else
    AudioObjectPropertyAddress propertyAddress = {
        kAudioDevicePropertyVolumeScalar,
        direction ? kAudioDevicePropertyScopeInput : kAudioDevicePropertyScopeOutput,
        kAudioObjectPropertyElementMaster
    };

    ossStat = AudioObjectGetPropertyData(deviceID,
                                     &propertyAddress,
                                     0,
                                     NULL,
                                     &sizeOfVol,
                                     &volume);
#endif
    
    if (ossStat != kAudioHardwareNoError) {
        sizeOfVol = sizeof(volume);

#ifndef MAC_OS_X_VERSION_10_6
        ossStat = AudioDeviceGetProperty(deviceID, 
                                     1, 
                                     direction,
                                     kAudioDevicePropertyVolumeScalar,
                                     &sizeOfVol, 
                                     &volume);
#else
        AudioObjectPropertyAddress propertyAddress = {
            kAudioDevicePropertyVolumeScalar,
            direction ? kAudioDevicePropertyScopeInput : kAudioDevicePropertyScopeOutput,
            1
        };

        ossStat = AudioObjectGetPropertyData(deviceID,
                                         &propertyAddress,
                                         0,
                                         NULL,
                                         &sizeOfVol,
                                         &volume);
#endif
    }
    
    if (ossStat == kAudioHardwareNoError) {
        return volume ;
  }
    
  return 0;
}

- (void)updateMicphones {
    [self._audioInputDevice removeAllObjects];
    AudioObjectPropertyAddress propertyAddress = {
        kAudioHardwarePropertyDevices,
        kAudioObjectPropertyScopeInput,
        kAudioObjectPropertyElementMaster
    };
    
    UInt32 dataSize = 0;
    OSStatus status = AudioObjectGetPropertyDataSize(kAudioObjectSystemObject,
                                                     &propertyAddress,
                                                     0,
                                                     NULL,
                                                     &dataSize);
    if(kAudioHardwareNoError != status) {
        return ;
    }
    
    UInt32 deviceCount = (UInt32)(dataSize / sizeof(AudioDeviceID));
    AudioDeviceID *audioDevices = (AudioDeviceID *)(malloc(dataSize));
    if(NULL == audioDevices) {
        return ;
    }
    
    status = AudioObjectGetPropertyData(kAudioObjectSystemObject, 
                                        &propertyAddress,
                                        0,
                                        NULL,
                                        &dataSize,
                                        audioDevices);
    if(kAudioHardwareNoError != status) {
        free(audioDevices);
        audioDevices = NULL;
        return ;
    }
    
    // Iterate through all the devices and determine which are input-capable
    propertyAddress.mScope = kAudioDevicePropertyScopeInput;
    for(UInt32 i = 0; i < deviceCount; ++i) {
        AudioDeviceID audioDeviceId = audioDevices[i];
        CFStringRef deviceName = NULL;
        
        dataSize = sizeof(deviceName);
        propertyAddress.mSelector = kAudioDevicePropertyDeviceNameCFString;
        status = AudioObjectGetPropertyData(audioDevices[i], 
                                            &propertyAddress,
                                            0,
                                            NULL,
                                            &dataSize,
                                            &deviceName);
        if(kAudioHardwareNoError != status) {
            NSLog(@"AudioObjectGetPropertyData (kAudioDevicePropertyDeviceNameCFString) failed: %d\n", (int)status);
            continue;
        }
        
        // Determine if the device is an input device (it is an input device if it has input channels)
        dataSize = 0;
        propertyAddress.mSelector = kAudioDevicePropertyStreamConfiguration;
        status = AudioObjectGetPropertyDataSize(audioDevices[i], 
                                                &propertyAddress,
                                                0,
                                                NULL,
                                                &dataSize);
        if(kAudioHardwareNoError != status) {
            fprintf(stderr, "AudioObjectGetPropertyDataSize (kAudioDevicePropertyStreamConfiguration) failed: %i\n", (int)status);
            continue;
        }
        
        AudioBufferList *bufferList = (AudioBufferList *)(malloc(dataSize));
        if(NULL == bufferList) {
            fputs("Unable to allocate memory", stderr);
            break;
        }
        
        status = AudioObjectGetPropertyData(audioDevices[i], 
                                            &propertyAddress,
                                            0,
                                            NULL,
                                            &dataSize,
                                            bufferList);
        if(kAudioHardwareNoError != status || 0 == bufferList->mNumberBuffers) {
            if(kAudioHardwareNoError != status)
                fprintf(stderr, "AudioObjectGetPropertyData (kAudioDevicePropertyStreamConfiguration) failed: %i\n", (int)status);
            free(bufferList);
            bufferList = NULL;
            continue;
        }
        
        UInt32 deviceType = kAudioDeviceTransportTypeUnknown;
        UInt32 outSize = sizeof(deviceType);
       
        status = AudioDeviceGetProperty(audioDevices[i], 
                                        0,
                                        YES,
                                        kAudioDevicePropertyTransportType,
                                        &outSize,
                                        &deviceType);
        NSString *transportType = @"";
        if(status == noErr)
        {
            char* p =(char*) &deviceType;
            transportType = [transportType stringByAppendingFormat:@"%c%c%c%c",*(p+3) ,*(p+2) ,*(p+1), *p];
        }
        
        free(bufferList);
        bufferList = NULL;
        if([transportType isEqualToString:@"virt"]) {
            continue;
        }
        
        NSMutableDictionary *deviceInfo = [NSMutableDictionary dictionaryWithCapacity:2];
        NSString *devName = (__bridge NSString *)(deviceName);
        [deviceInfo setObject:devName forKey:@"name"];
        
        NSNumber *audioDevId= [NSNumber numberWithUnsignedInt:audioDeviceId];
        [deviceInfo setObject:audioDevId forKey:@"audioDeviceID"];
        [deviceInfo setObject: transportType forKey:@"transportType"];
     
        [self._audioInputDevice addObject:deviceInfo];
    }
    
    free(audioDevices);
    audioDevices = NULL;
    
    return ;
}

- (void)updateSpeakers {
    [self._audioOutputDevice removeAllObjects];
    
    AudioObjectPropertyAddress propertyAddress = {
        kAudioHardwarePropertyDevices,
        kAudioObjectPropertyScopeGlobal,
        kAudioObjectPropertyElementMaster
    };
    
    UInt32 dataSize = 0;
    OSStatus status = AudioObjectGetPropertyDataSize(kAudioObjectSystemObject,
                                                     &propertyAddress,
                                                     0,
                                                     NULL,
                                                     &dataSize);
    if(kAudioHardwareNoError != status) {
        return ;
    }
    
    UInt32 deviceCount = (UInt32)(dataSize / sizeof(AudioDeviceID));
    AudioDeviceID *audioDevices = (AudioDeviceID *)(malloc(dataSize));
    if(NULL == audioDevices) {
        return ;
    }
    
    status = AudioObjectGetPropertyData(kAudioObjectSystemObject, 
                                        &propertyAddress,
                                        0,
                                        NULL,
                                        &dataSize,
                                        audioDevices);
    if(kAudioHardwareNoError != status) {
        free(audioDevices);
        audioDevices = NULL;
        return ;
    }
    
    // Iterate through all the devices and determine which are input-capable
    propertyAddress.mScope = kAudioDevicePropertyScopeOutput;
    for(UInt32 i = 0; i < deviceCount; ++i) {
        AudioDeviceID audioDeviceId = audioDevices[i];
        CFStringRef deviceName = NULL;
        
        dataSize = sizeof(deviceName);
        propertyAddress.mSelector = kAudioDevicePropertyDeviceNameCFString;
        status = AudioObjectGetPropertyData(audioDevices[i], 
                                            &propertyAddress,
                                            0,
                                            NULL,
                                            &dataSize,
                                            &deviceName);
        
        if(kAudioHardwareNoError != status) {
            NSLog(@"AudioObjectGetPropertyData (kAudioDevicePropertyDeviceNameCFString) failed: %d\n", (int)status);
            continue;
        }
        
        // Determine if the device is an output device
        dataSize = 0;
        propertyAddress.mSelector = kAudioDevicePropertyStreams;
        status = AudioObjectGetPropertyDataSize(audioDevices[i], 
                                                &propertyAddress,
                                                0,
                                                NULL,
                                                &dataSize);
        if(kAudioHardwareNoError != status) {
            fprintf(stderr, "AudioObjectGetPropertyDataSize (kAudioDevicePropertyStreamConfiguration) failed: %i\n", (int)status);
            continue;
        }
        
        UInt32 streamCnt = dataSize /sizeof(AudioDeviceID);
        if(streamCnt <=0)
            continue;

        UInt32 deviceType = kAudioDeviceTransportTypeUnknown;
        UInt32 outSize = sizeof(deviceType);
       
        status = AudioDeviceGetProperty(audioDevices[i], 
                                        0,
                                        YES,
                                        kAudioDevicePropertyTransportType,
                                        &outSize,
                                        &deviceType);
        NSString *transportType = @"";
        
        if(status == noErr) {
            char* p =(char*) &deviceType;
            
            transportType = [transportType stringByAppendingFormat:@"%c%c%c%c",*(p+3) ,*(p+2) ,*(p+1), *p];
        }
        
        if([transportType isEqualToString:@"virt"]) {
            continue;
        }
        
        NSMutableDictionary *deviceInfo = [NSMutableDictionary dictionaryWithCapacity:2];
        NSString *devName = (__bridge NSString *)(deviceName);
        [deviceInfo setObject:devName forKey:@"name"];
        
        NSNumber *audioDevId= [NSNumber numberWithUnsignedInt:audioDeviceId];
        [deviceInfo setObject:audioDevId forKey:@"audioDeviceID"];
        [deviceInfo setObject: transportType forKey:@"transportType"];

        [self._audioOutputDevice addObject:deviceInfo];
    }
    
    free(audioDevices);
    audioDevices = NULL;
    
    return;
}




@end
