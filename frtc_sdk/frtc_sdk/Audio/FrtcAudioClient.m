#import "FrtcAudioClient.h"
#import "ObjectInterface.h"

//https://zhuanlan.zhihu.com/p/462669092
static void logMessage(NSString *format, ...)
{
    va_list args;
    va_start(args, format);
    NSMutableString *formattedString = [[NSMutableString alloc] initWithFormat:format
                                                                     arguments:args];
    va_end(args);
    
    NSLog(@"%@", formattedString);
}

/*
 * Format a 32-bit code (for instance OSStatus) into a string.
 */
static char *codeToString(UInt32 code)
{
    static char str[5] = { '\0' };
    UInt32 swapped = CFSwapInt32HostToBig(code);
    memcpy(str, &swapped, sizeof(swapped));
    return str;
}

static NSString *formatStatusError(OSStatus ossStat)
{
    if (ossStat == noErr) {
        return [NSString stringWithFormat:@"No error (%d)", ossStat];
    }

    return [NSString stringWithFormat:@"Error \"%s\" (%d)",
            codeToString(ossStat),
            ossStat];
}

static void assertStatusSuccess(OSStatus ossStat)
{
    if (ossStat != noErr) {
        logMessage(@"Got error %u: '%s'\n", ossStat, codeToString(ossStat));
        abort();
    }

}

static AudioObjectPropertyAddress makePropertyAddress(AudioObjectPropertySelector selector, 
                                                      AudioObjectPropertyScope scope) {
    AudioObjectPropertyAddress address = { selector,
                                           scope,
                                           kAudioObjectPropertyElementMaster };
    return address;
}

static NSString *getStringProperty(AudioDeviceID deviceID,
                                   AudioObjectPropertySelector selector,
                                   AudioObjectPropertyScope scope)
{
    AudioObjectPropertyAddress address = makePropertyAddress(selector, scope);
    CFStringRef prop;
    UInt32 propSize = sizeof(prop);
    OSStatus ossStat = AudioObjectGetPropertyData(deviceID,
                                                 &address,
                                                 0,
                                                 NULL,
                                                 &propSize,
                                                 &prop);
    if (ossStat != noErr) {
        return formatStatusError(ossStat);
    }
    
    return (__bridge_transfer NSString *)prop;
}

static NSString *getURLProperty(AudioDeviceID deviceID,
                                AudioObjectPropertySelector selector,
                                AudioObjectPropertyScope scope)
{
    AudioObjectPropertyAddress address = makePropertyAddress(selector, scope);
    CFURLRef prop;
    UInt32 propSize = sizeof(prop);
    OSStatus ossStat = AudioObjectGetPropertyData(deviceID,
                                                 &address,
                                                 0,
                                                 NULL,
                                                 &propSize,
                                                 &prop);
    if (ossStat != noErr) {
        return formatStatusError(ossStat);
    }

    NSURL *url = (__bridge_transfer NSURL *)prop;
    return url.absoluteString;
}

static NSString *getCodeProperty(AudioDeviceID deviceID,
                                 AudioObjectPropertySelector selector,
                                 AudioObjectPropertyScope scope)
{
    AudioObjectPropertyAddress address = makePropertyAddress(selector, scope);
    UInt32 prop;
    UInt32 propSize = sizeof(prop);
    OSStatus ossStat = AudioObjectGetPropertyData(deviceID,
                                                 &address,
                                                 0,
                                                 NULL,
                                                 &propSize,
                                                 &prop);
    if (ossStat != noErr) {
        return formatStatusError(ossStat);
    }
    
    NSString *audioTransType = @"";
    if(ossStat == noErr) {
        char* p =(char*) &prop;
        audioTransType = [audioTransType stringByAppendingFormat:@"%c%c%c%c",*(p+3) ,*(p+2) ,*(p+1), *p];
    }

    return audioTransType;
}

static AudioBufferList * getChannelCount(AudioDeviceID deviceID,
                                         AudioObjectPropertyScope scope,
                                         UInt32 dataSize,
                                         OSStatus *ossStat)
{
    AudioObjectPropertyAddress address = { kAudioDevicePropertyStreamConfiguration,
                                           scope,
                                           kAudioObjectPropertyElementMaster };

    AudioBufferList *audioBufList = (AudioBufferList *)(malloc(dataSize));
    *ossStat = AudioObjectGetPropertyData(deviceID,
                                         &address,
                                         0,
                                         NULL,
                                         &dataSize,
                                         audioBufList);
    
    return audioBufList;
}

static OSStatus getBasicPropertySize(AudioDeviceID deviceID,
                                     AudioObjectPropertySelector selector,
                                     AudioObjectPropertyScope scope,
                                     UInt32 *devicesDataSize)
{
    AudioObjectPropertyAddress address = makePropertyAddress(selector, scope);
    
    return AudioObjectGetPropertyDataSize(deviceID,
                                          &address,
                                          0,
                                          NULL,
                                          devicesDataSize);
}

static OSStatus getDefaultPropertySize(AudioDeviceID deviceID,
                                       AudioObjectPropertySelector selector,
                                       AudioObjectPropertyScope scope,
                                       UInt32 *devicesDataSize)
{
    AudioObjectPropertyAddress address = makePropertyAddress(selector, scope);
    UInt32 param = sizeof(AudioDeviceID);
    
    return AudioObjectGetPropertyData(deviceID,
                                      &address,
                                      0,
                                      NULL,
                                      &param,
                                      devicesDataSize);
}

static NSString *getSourceName(AudioDeviceID deviceID,
                               AudioObjectPropertyScope scope)
{
    AudioObjectPropertyAddress address = { kAudioDevicePropertyDataSource,
                                           scope,
                                           kAudioObjectPropertyElementMaster };
    UInt32 sourceCode;
    UInt32 propSize = sizeof(sourceCode);

    OSStatus ossStat = AudioObjectGetPropertyData(deviceID,
                                                 &address,
                                                 0,
                                                 NULL,
                                                 &propSize,
                                                 &sourceCode);
    if (ossStat != noErr) {
        return formatStatusError(ossStat);
    }

    return [NSString stringWithFormat:@"%s (%d)",
            codeToString(sourceCode),
            sourceCode];
}

static void inspectDevice(AudioDeviceID deviceID, AudioObjectPropertyScope scope)
{
    logMessage(@"Device %d", deviceID);
    logMessage(@" - UID:             %@", getStringProperty(deviceID, kAudioDevicePropertyDeviceUID, scope));
    logMessage(@" - Model UID:       %@", getStringProperty(deviceID, kAudioDevicePropertyModelUID, scope));
    logMessage(@" - Name:            %@", getStringProperty(deviceID, kAudioDevicePropertyDeviceNameCFString, scope));
    logMessage(@" - Manufacturer:    %@", getStringProperty(deviceID, kAudioDevicePropertyDeviceManufacturerCFString, scope));
//    logMessage(@" - Input channels:  %@", @(getChannelCount(deviceID, kAudioObjectPropertyScopeInput)));
//    logMessage(@" - Output channels: %@", @(getChannelCount(deviceID, kAudioObjectPropertyScopeOutput)));
    logMessage(@" - Input source:    %@", getSourceName(deviceID, kAudioObjectPropertyScopeInput));
    logMessage(@" - Output source:   %@", getSourceName(deviceID, kAudioObjectPropertyScopeOutput));
    logMessage(@" - Transport type:  %@", getCodeProperty(deviceID, kAudioDevicePropertyTransportType, scope));
    logMessage(@" - Icon:            %@", getURLProperty(deviceID, kAudioDevicePropertyIcon,scope));
}

static AudioDeviceID * inspectAllDevices(int *count, AudioObjectPropertyScope scope)
{
    AudioObjectPropertyAddress address = makePropertyAddress(kAudioHardwarePropertyDevices, scope);
    UInt32 devicesDataSize;
    OSStatus ossStat = AudioObjectGetPropertyDataSize(kAudioObjectSystemObject,
                                                     &address,
                                                     0,
                                                     NULL,
                                                     &devicesDataSize);
    assertStatusSuccess(ossStat);

    *count = devicesDataSize / sizeof(AudioDeviceID);
    AudioDeviceID *audioDevs = (AudioDeviceID *)(malloc(devicesDataSize));
    ossStat = AudioObjectGetPropertyData(kAudioObjectSystemObject,
                                        &address,
                                        0,
                                        NULL,
                                        &devicesDataSize,
                                        audioDevs);
    assertStatusSuccess(ossStat);

    for (UInt32 i = 0; i < *count; i++) {
        inspectDevice(audioDevs[i], scope);
    }
    
    return audioDevs;
}

static FrtcAudioClient *audioClientSingleton = nil;

@interface FrtcAudioClient ()<MicphoneCaptureDelegate, SpeakerRenderDelegate>

@end

@implementation FrtcAudioClient

+ (FrtcAudioClient *)audioClientSingleton 
{
    if (audioClientSingleton == nil) {
        @synchronized(self) {
            if (audioClientSingleton == nil) {
                audioClientSingleton = [[FrtcAudioClient alloc] init];
               
            }
        }
    }
    return audioClientSingleton;
}

- (instancetype) init 
{
    self = [super init];
    if(self) {
        self.micphoneDeviceList = [[NSMutableArray alloc] init];
        self.speakerDeviceList = [[NSMutableArray alloc] init];
        self.nowUsedMicphoneDevice = @"";
        self.nowUsedSpeakerDevice = @"";
        self.audioUnitRunning = NO;
        [self updateMicphones];
        [self updateSpeakers];
    }
    return self;
}

- (OSStatus)removeAudioUnitCoreGraph 
{
    [self.speakerRender removeAudioOutputSpeakerUnit];
    [self.micphoneDeviceCapture removeAudioInputMicphoneUnit];
    return noErr;
}

- (void)testAudioMicphone:(BOOL)enable withHandler:(void (^)(float meter, BOOL testing))testMicHandler 
{
    [self.micphoneDeviceCapture testAudioUnitSourceMicphone:enable withHandler:testMicHandler];
}

- (OSStatus)enableAudioUnitCoreGraph 
{
    [self disableAudioUnitCoreGraph];
    
    if (noErr != [self setupSpeakerRender]) {
        NSLog(@"failed");
    }
    
    if(noErr != [self setupMicphoneDeviceCapture]) {
        NSLog(@"failed");
    }
    
    [self.speakerRender enableAudioOutputSpeakerUnit];
    [self.micphoneDeviceCapture enableAudioInputMicphoneUnit];
    
    self.audioUnitRunning = YES;
    
    return  noErr;
}

- (void)startAudioUnitInputDevice 
{
    [self.micphoneDeviceCapture enableAudioInputMicphoneUnit];
}

- (void)startAudioUnitOutputDevice 
{
    if (noErr != [self setupSpeakerRender]) {
        return;
    }
    
    self.audioUnitRunning = YES;
    [self.speakerRender enableAudioOutputSpeakerUnit];
}

- (OSStatus)disableAudioUnitCoreGraph 
{
    [self.speakerRender disableAudioOutputSpeakerUnit];
    [self.micphoneDeviceCapture disableAudioInputMicphoneUnit];
    
    self.audioUnitRunning = NO;
    return  noErr;
}

- (OSStatus)reRunAudioInputDeviceUnit 
{
    [self.micphoneDeviceCapture disableAudioInputMicphoneUnit];
    
    if(noErr != [self setupMicphoneDeviceCapture]) {
        return -1;
    }
    
    [self.micphoneDeviceCapture enableAudioInputMicphoneUnit];
    
    return  noErr;
}

- (OSStatus)restartSpeakerDev 
{
    [self.speakerRender disableAudioOutputSpeakerUnit];
    
    if(noErr != [self setupSpeakerRender]) {
        return -1;
    }
    
    return [self.speakerRender enableAudioOutputSpeakerUnit];
}

- (OSStatus)setupSpeakerRender 
{
    self.speakerRender = [[SpeakerRender alloc] init];
    self.speakerRender.muted = NO;
    self.speakerRender.speakerDelegate = self;
    
    AudioDeviceID deviceID = [self obtainSpeakerIDByDeviceName:self.nowUsedSpeakerDevice];
    if(deviceID == 0) {
        self.nowUsedSpeakerDevice = [self systemSelectDefaultSpeaker];
        deviceID = [self obtainSpeakerIDByDeviceName:self.nowUsedSpeakerDevice];
    }
    
    self.speakerRender.speakerDeviceID = deviceID;
    
    return [self.speakerRender setupSpeakerUnit];
}

- (OSStatus)setupMicphoneDeviceCapture 
{
    self.micphoneDeviceCapture = [[MicphoneCapture alloc] init];
    self.micphoneDeviceCapture.muted = NO;
    self.micphoneDeviceCapture.is2ndMic = NO;
    self.micphoneDeviceCapture.delegate = self;
    
    AudioDeviceID id =[self obtainMicphoneIDByDeviceName:self.nowUsedMicphoneDevice];
    if(id == 0) {
        self.nowUsedMicphoneDevice = [self systemSelectDefaultMicphone];
        id = [self obtainMicphoneIDByDeviceName:self.nowUsedMicphoneDevice];
    }
    self.micphoneDeviceCapture.micphoneDevice = id;
    
    return [self.micphoneDeviceCapture setupMicphoneCaptureUnit];
}

- (AudioDeviceID)obtainMicphoneIDByDeviceName:(NSString *)deviceName 
{
    int idx = 0;
    AudioDeviceID devId = 0;
    
    for (; idx < [self.micphoneDeviceList count]; idx++) {
        NSMutableDictionary *device = [self.micphoneDeviceList objectAtIndex:idx];
        NSString *devName = [device objectForKey:@"name"];
        
        if([devName isEqualToString:deviceName]) {
            NSNumber *micphoneId = [device objectForKey:@"audioDeviceID"];
            unsigned int audioId = [micphoneId unsignedIntValue];
            devId = (AudioDeviceID)audioId;
            break;
        }
    }
    
    return devId;
}

- (AudioDeviceID)obtainSpeakerIDByDeviceName:(NSString *)deviceName 
{
    int idx = 0;
    AudioDeviceID devId = 0;
    
    for (; idx < [self.speakerDeviceList count]; idx++) {
        NSMutableDictionary *speaker = [self.speakerDeviceList objectAtIndex:idx];
        NSString *spkName = [speaker objectForKey:@"name"];
        
        if([spkName isEqualToString:deviceName]) {
            NSNumber *speakerId = [speaker objectForKey:@"audioDeviceID"];
            unsigned int audioId = [speakerId unsignedIntValue];
            devId = (AudioDeviceID)audioId;
            break;
        }
    }
    
    return devId;
}

- (NSString*) getNowUsedSpeakerDevice 
{
    return self.nowUsedSpeakerDevice;
}

- (NSString*) getNowUsedMicphoneDevice 
{
    return self.nowUsedMicphoneDevice;
}

- (void)switchMicphoneByDeviceID:(NSString *)id 
{
    int idx = 0;
    NSString *previousMicphone = self.nowUsedMicphoneDevice;
    self.nowUsedMicphoneDevice = @"";
    for (; idx < [self.micphoneDeviceList count]; idx++) {
        NSMutableDictionary *micphone = [self.micphoneDeviceList objectAtIndex:idx];
        NSString *micName = [micphone objectForKey:@"name"];
        if([micName isEqualToString:id]) {
            self.nowUsedMicphoneDevice = id;
            
            break;
        }
    }

    if( [previousMicphone isEqualToString:self.nowUsedMicphoneDevice] == false && self.isAudioUnitRunning) {
        [self reRunAudioInputDeviceUnit];
    }
    
    if([self.micphoneDeviceList count] < 2) {
        return;
    }
}

- (void)switchSpeakerByDeviceID:(NSString *)id 
{
    int idx = 0;
    NSString *previousSpeaker = self.nowUsedSpeakerDevice;
    self.nowUsedSpeakerDevice = @"";
    
    for (; idx < [self.speakerDeviceList count]; idx++) {
        NSMutableDictionary *speaker = [self.speakerDeviceList objectAtIndex:idx];
        NSString *speakerName = [speaker objectForKey:@"name"];
        if([speakerName isEqualToString:id]) {
            self.nowUsedSpeakerDevice = id;
            break;
        }
    }
    
    if([previousSpeaker isEqualToString:self.nowUsedSpeakerDevice] == false && self.isAudioUnitRunning) {
        [self.speakerRender disableAudioOutputSpeakerUnit];
        
        if(noErr != [self setupSpeakerRender]) {
            NSLog(@"setupSpeakerRender failed");
        }
        
        [self.speakerRender enableAudioOutputSpeakerUnit];
    }
}

- (NSString *)systemSelectDefaultMicphone 
{
    OSStatus ossStat = noErr;
    AudioDeviceID defDev = 0;
    
    ossStat = getDefaultPropertySize(kAudioObjectSystemObject,
                                    kAudioHardwarePropertyDefaultInputDevice,
                                    kAudioObjectPropertyScopeGlobal,
                                    &defDev);
    if(ossStat != noErr) {
        NSLog(@"get default input device failed\n");
        return @"";
    }
    
    NSString *deviceName = getStringProperty(defDev,
                                             kAudioDevicePropertyDeviceNameCFString,
                                             kAudioObjectPropertyScopeGlobal);
    return deviceName;
}

- (NSString *)systemSelectDefaultSpeaker 
{
    AudioDeviceID defDev = 0;
    
    OSStatus ossStat = getDefaultPropertySize(kAudioObjectSystemObject,
                                             kAudioHardwarePropertyDefaultOutputDevice,
                                             kAudioObjectPropertyScopeGlobal,
                                             &defDev);
    if(ossStat != noErr) {
        NSLog(@"get default output device failed\n");
        return @"";
    }
    
    NSString *deviceName = getStringProperty(defDev,
                                             kAudioDevicePropertyDeviceNameCFString,
                                             kAudioObjectPropertyScopeGlobal);
    if([deviceName isEqualToString:@"FRMeeting Audio Device"] || deviceName == nil) {
        for(int i = 0; i < [self.speakerDeviceList count]; i++) {
            NSMutableDictionary *devInfo = self.speakerDeviceList[i];
            NSString *audioTransType = devInfo[@"transportType"];
            
            if([audioTransType isEqualToString:@"bltn"]) {
                deviceName = devInfo[@"name"];
                break;
            }
        }

        return deviceName;
    }
    
    return deviceName;
}

- (NSArray *)getAudioInputDevices 
{
    [self updateMicphones];
    
    return self.micphoneDeviceList;
}

- (NSArray *)getAudioOutputDevices 
{
    [self updateSpeakers];

    return self.speakerDeviceList;
}

- (int)updateSpeakers 
{
    [self.speakerDeviceList removeAllObjects];
    
    int outputDeviceCount = 0;
    AudioDeviceID *outputAudioDevices = inspectAllDevices(&outputDeviceCount,
                                                          kAudioObjectPropertyScopeGlobal);
    
    UInt32 propertySize = 0;
    OSStatus ossStat;
    for(UInt32 i = 0; i < outputDeviceCount; ++i) {
        AudioDeviceID audioDevId = outputAudioDevices[i];
        NSString *deviceName = getStringProperty(audioDevId,
                                                 kAudioDevicePropertyDeviceNameCFString,
                                                 kAudioDevicePropertyScopeOutput);
        
        if([deviceName containsString:@"Error"]) {
            continue;
        }
        
        propertySize = 0;
        ossStat = getBasicPropertySize(outputAudioDevices[i],
                                      kAudioDevicePropertyStreams,
                                      kAudioDevicePropertyScopeOutput,
                                      &propertySize);
        if(kAudioHardwareNoError != ossStat) {
            continue;
        }
        
        if(propertySize / sizeof(AudioDeviceID) <= 0) {
            continue;
        }
        
        NSString *audioTransType = getCodeProperty(outputAudioDevices[i],
                                                  kAudioDevicePropertyTransportType,
                                                  kAudioDevicePropertyScopeOutput);

        if([audioTransType isEqualToString:@"virt"]) {
            continue;
        }
        
        NSMutableDictionary *devInfo = [NSMutableDictionary dictionaryWithCapacity:2];
        [devInfo setObject:deviceName forKey:@"name"];
        
        NSNumber *audioDev = [NSNumber numberWithUnsignedInt:audioDevId];
        [devInfo setObject: audioDev forKey:@"audioDeviceID"];
        [devInfo setObject: audioTransType forKey:@"transportType"];
      
        [self.speakerDeviceList addObject:devInfo];
    }
    free(outputAudioDevices);
    
    outputAudioDevices = NULL;
    
    return 0;
}

- (int)updateMicphones 
{
    [self.micphoneDeviceList removeAllObjects];
    
    int count = 0;
    AudioDeviceID *audioDevs = inspectAllDevices(&count,
                                                 kAudioObjectPropertyScopeInput);
    
    UInt32 deviceDataSize = 0;
    OSStatus ossStat;
    for(UInt32 i = 0; i < count; ++i) {
        AudioDeviceID audioDevId = audioDevs[i];
        NSString *deviceName = getStringProperty(audioDevId,
                                                 kAudioDevicePropertyDeviceNameCFString,
                                                 kAudioDevicePropertyScopeInput);
        if([deviceName containsString:@"Error"]) {
            continue;
        }

        ossStat = getBasicPropertySize(audioDevId,
                                      kAudioDevicePropertyStreamConfiguration,
                                      kAudioDevicePropertyScopeInput,
                                      &deviceDataSize);
        if(kAudioHardwareNoError != ossStat) {
            continue;
        }
        
        AudioBufferList *audioBufList = getChannelCount(audioDevs[i],
                                                      kAudioDevicePropertyScopeInput,
                                                      deviceDataSize,
                                                      &ossStat);
        if(kAudioHardwareNoError != ossStat || 0 == audioBufList->mNumberBuffers) {
            free(audioBufList);
            audioBufList = NULL;
            continue;
        }
       
        NSString *audioTransType = getCodeProperty(audioDevId,
                                                  kAudioDevicePropertyTransportType,
                                                  kAudioDevicePropertyScopeInput);
        free(audioBufList);
        audioBufList = NULL;
        
        if([audioTransType isEqualToString:@"virt"]) {
            continue;
        }
        
        NSMutableDictionary *devInfo = [NSMutableDictionary dictionaryWithCapacity:2];
        [devInfo setObject:deviceName forKey:@"name"];
        
        NSNumber *audioDev = [NSNumber numberWithUnsignedInt:audioDevId];
        [devInfo setObject: audioDev forKey:@"audioDeviceID"];
        [devInfo setObject: audioTransType forKey:@"transportType"];
        
        NSLog(@"add mic to list, name =%@,audioDevId =%d,audioTransType=%@",
               deviceName,audioDevId, audioTransType);
        
        [self.micphoneDeviceList addObject:devInfo];
    }
    
    free(audioDevs);
    audioDevs = NULL;
    
    return 0;
}

- (void)getDeviceInputMicArray:(NSMutableArray *)inputDeviceListArray 
{
    [self getAudioInputDevices];
    
    int idx = 0;
    for (; idx < [self.micphoneDeviceList count]; idx++) {
        NSMutableDictionary *micphone = [self.micphoneDeviceList objectAtIndex:idx];
        [inputDeviceListArray addObject:micphone];
    }
}

- (void)getDeviceOutputSpeakerList:(NSMutableArray *)outputDeviceListArray 
{
    [self getAudioOutputDevices];

    int idx = 0;
    for (; idx < [self.speakerDeviceList count]; idx++) {
        NSMutableDictionary *speaker = [self.speakerDeviceList objectAtIndex:idx];
        [outputDeviceListArray addObject:speaker];
    }
}

#pragma mark - MicphoneCaptureDelegate
- (void)sendMicphoneCaptureData:(unsigned char *)audioDataBuffer dataLength:(int)length captureSampleRate:(int)sampleRate 
{
    [[ObjectInterface sharedObjectInterface] sendAudioFrameObject:audioDataBuffer length:length sampleRatge:sampleRate];
}

#pragma mark - SpeakerRenderDelegate
-  (void)gainRemoteUserAudioData:(void *)audioBuffer audioDataLength:(unsigned int)audioDatalength sampleRate:(unsigned int )sampleRate 
{
    [[ObjectInterface sharedObjectInterface] receiveAudioFrameObject:audioBuffer dataLength:audioDatalength sampleRate:sampleRate];
}

- (void)makeMicMute:(BOOL)mute
{
    self.micphoneDeviceCapture.muted = mute;
}

- (void)newAudioDeviceNotification:(NSNotification *)notice 
{
    if (![(AVCaptureDevice*)notice.object hasMediaType:AVMediaTypeAudio]
        &&![(AVCaptureDevice*)notice.object hasMediaType:AVMediaTypeMuxed]) {

        return;
    }
    
    [self updateMicphones];
    [self updateSpeakers];
}

- (void)unpluggingAudioDeviceNotification:(NSNotification *)notice 
{
    if(![(AVCaptureDevice *)notice.object hasMediaType:AVMediaTypeAudio] &&
       ![(AVCaptureDevice *)notice.object hasMediaType:AVMediaTypeMuxed]) {
        return;
    }
    
    NSString *devLocalizedName = ((AVCaptureDevice*)notice.object).localizedName;
    
    [self updateMicphones];
    [self updateSpeakers];
    
    if ([devLocalizedName isEqualToString:self.nowUsedMicphoneDevice]) {
        self.nowUsedMicphoneDevice = [self systemSelectDefaultMicphone];
        
        if (self.isAudioUnitRunning) {
            [self reRunAudioInputDeviceUnit];
        }
    }
    
    if ([devLocalizedName isEqualToString:self.nowUsedSpeakerDevice]) {
        self.nowUsedSpeakerDevice = [self systemSelectDefaultSpeaker];
        
        if (self.isAudioUnitRunning) {
            [self restartSpeakerDev];
        }
    }
}

@end
