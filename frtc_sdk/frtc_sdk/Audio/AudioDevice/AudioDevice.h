#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioDevice : NSObject

+ (AudioDevice *)sharedAudioDevice;

- (AudioDeviceID)getMicIDByName:(NSString *)name;

- (AudioDeviceID)getSpeakerIDByName:(NSString*)name;

- (Float32)getVolumeForDevice:(AudioDeviceID)deviceID withDirection:(int)direction;

@property (nonatomic, copy) NSString *currentSpeakerName;

@end

NS_ASSUME_NONNULL_END
