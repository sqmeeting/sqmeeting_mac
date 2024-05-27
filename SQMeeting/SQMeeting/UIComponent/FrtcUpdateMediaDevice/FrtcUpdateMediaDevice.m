#import "FrtcUpdateMediaDevice.h"

static FrtcUpdateMediaDevice *updateMediaDeviceSigleton = nil;

@implementation FrtcUpdateMediaDevice

+ (FrtcUpdateMediaDevice *)mediaDeviceSingleton{
    if (updateMediaDeviceSigleton == nil) {
        @synchronized(self) {
            if (updateMediaDeviceSigleton == nil) {
                updateMediaDeviceSigleton = [[FrtcUpdateMediaDevice alloc] init];
            }
        }
    }
    
    return updateMediaDeviceSigleton;
}

- (instancetype)init {
    self = [super init];
  
    return self;
}

- (void)updateMediaDevice {
    [self updateMic];
    [self updateSpeaker];
    [self updateCamere];
}

- (void)updateCamere {
    NSMutableArray* camList = [[NSMutableArray alloc ] init];
    [[FrtcCall sharedFrtcCall] frtcCameraList:camList];
    
    //2: set the default Camere for the MediaSettingView.
    if ([camList count] > 0) {
    
        //2.1. get the first Mic from the macOS settings.
        NSString *camName = [[FrtcUserDefault defaultSingleton] objectForKey:DEFAULT_CAMERA];
        
        //2.2. set the default Mic for the MediaSettingView.
        if (camName.length == 0) {
            NSString *cameraTitle = [camList[0] valueForKey:@"name"];
            [[FrtcUserDefault defaultSingleton] setObject:cameraTitle forKey:DEFAULT_CAMERA];
            [[FrtcCall sharedFrtcCall] frtcSelectCamera:cameraTitle];
        } else {
            BOOL found = NO;
            for (NSInteger camIndex = 0; camIndex < [camList count]; camIndex++) {
                NSString *cameraTitle = [camList[camIndex] valueForKey:@"name"];
                if ([camName isEqualToString:cameraTitle]) {
                    [[FrtcCall sharedFrtcCall] frtcSelectCamera:cameraTitle];
                    found = YES;
                    break;
                }
            }
            
            if (!found) {
                NSString *cameraTitle = [camList[0] valueForKey:@"name"];
                [[FrtcUserDefault defaultSingleton] setObject:cameraTitle forKey:DEFAULT_CAMERA];
                [[FrtcCall sharedFrtcCall] frtcSelectCamera:cameraTitle];
            }
        }
    }
}

- (void)updateMic {
    NSMutableArray* micList = [[NSMutableArray alloc ] init];
    [[FrtcCall sharedFrtcCall] frtcMicphoneList:micList];
    if ([micList count] > 0) {
        NSString *defaultMicName = [[FrtcCall sharedFrtcCall] frtcGetDefaultMicName];
        [[FrtcUserDefault defaultSingleton] setObject:defaultMicName forKey:DEFAULT_MICROPHONE];
        
        NSString *micName = [[FrtcUserDefault defaultSingleton] objectForKey:DEFAULT_MICROPHONE];
        if (micName.length == 0) {
            NSString *micTitle = [micList[0] valueForKey:@"name"];
            [[FrtcUserDefault defaultSingleton] setObject:micTitle forKey:DEFAULT_MICROPHONE];
            [[FrtcCall sharedFrtcCall] frtcSelectMic:micTitle];
        } else {
            BOOL found = NO;
            for (NSInteger micIndex = 0; micIndex < [micList count]; micIndex ++) {
                NSString *micTitle = [micList[micIndex] valueForKey:@"name"];
                if ([micName isEqualToString:micTitle]) {
                    [[FrtcCall sharedFrtcCall] frtcSelectMic:micTitle];
                    found = YES;
                    break;
                }
            }
            if (!found) {
                for (NSInteger index = 0; index < [micList  count]; index ++) {
                    if (![[micList[index] valueForKey:@"transportType"] isEqualToString:FMeetingAudioDeviceTransportTypeUnknown] &&
                        ![[micList[index] valueForKey:@"transportType"] isEqualToString:FMeetingAudioDeviceTransportTypeBuiltIn]){
                        NSString *micTitle = [micList[index] valueForKey:@"name"];
                        [[FrtcUserDefault defaultSingleton] setObject:micTitle forKey:DEFAULT_MICROPHONE];
                        [[FrtcCall sharedFrtcCall] frtcSelectMic:micTitle];
                        break;
                    }
                }
            }
        }
    }
}

- (void)updateSpeaker {
    NSMutableArray* spkList = [[NSMutableArray alloc ] init];
    [[FrtcCall sharedFrtcCall] frtcSpeakerList:spkList];

    if ([spkList count] > 0) {
        NSString *defaultSpeakerName = [[FrtcCall sharedFrtcCall] frtcGetDefaultSpeakerName];
        [[FrtcUserDefault defaultSingleton] setObject:defaultSpeakerName forKey:DEFAULT_SPEAKER];
       
        NSString *spkName = [[FrtcUserDefault defaultSingleton] objectForKey:DEFAULT_SPEAKER];
        if (spkName.length == 0) {
            NSString *spkTitle = defaultSpeakerName;
            [[FrtcUserDefault defaultSingleton] setObject:spkTitle forKey:DEFAULT_SPEAKER];
            [[FrtcCall sharedFrtcCall] frtcSelectSpeaker:spkTitle];
        } else {
            BOOL found = NO;
            for (NSInteger spkIndex =0; spkIndex < [spkList count]; spkIndex++) {
                NSString *spkTitle = [spkList[spkIndex] valueForKey:@"name"];
                if ([spkName isEqualToString:spkTitle]) {
                    [[FrtcCall sharedFrtcCall] frtcSelectSpeaker:spkTitle];
                    found = YES;
                    break;
                }
            }
            if (!found) {
                for (NSInteger index = 0; index < [spkList count]; index++) {
                    if (![[spkList[index] valueForKey:@"transportType"] isEqualToString:FMeetingAudioDeviceTransportTypeUnknown] &&
                        ![[spkList[index] valueForKey:@"transportType"] isEqualToString:FMeetingAudioDeviceTransportTypeBuiltIn]) {
                        
                        NSString *spkTitle = [spkList[index] valueForKey:@"name"];
                        [[FrtcUserDefault defaultSingleton] setObject:spkTitle forKey:DEFAULT_SPEAKER];
                        [[FrtcCall sharedFrtcCall] frtcSelectSpeaker:spkTitle];
                        break;
                    }
                }
            }
        }
    }
}
    
@end
