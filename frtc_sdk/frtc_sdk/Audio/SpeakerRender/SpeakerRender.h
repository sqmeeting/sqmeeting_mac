#import <Foundation/Foundation.h>
#include <AudioToolbox/AudioToolbox.h>
#include <AudioUnit/AudioUnit.h>

NS_ASSUME_NONNULL_BEGIN

extern OSStatus SpeakerRenderCallBack( void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags,const AudioTimeStamp *inTimeStamp,UInt32 inBusNumber,UInt32 inNumberFrames,AudioBufferList *ioData);

@protocol SpeakerRenderDelegate <NSObject>

- (void)gainRemoteUserAudioData:(void *)audioBuffer audioDataLength:(unsigned int)audioDatalength sampleRate:(unsigned int)sampleRate;

@end

@interface SpeakerRender : NSObject {
@public
    AudioStreamBasicDescription audioStreamRenderDescription;
    AudioUnit speakerUnit;
}

@property (nonatomic) AudioDeviceID speakerDeviceID;;
@property (nonatomic, weak) id<SpeakerRenderDelegate> speakerDelegate;
@property (nonatomic, assign, getter=isMuted) BOOL muted;
 

- (OSStatus)setupSpeakerUnit;
- (OSStatus)disableAudioOutputSpeakerUnit;
- (OSStatus)enableAudioOutputSpeakerUnit;
- (void)removeAudioOutputSpeakerUnit;

- (void)gainRemoteUserAudioData:(void *)audioBuffer audioDataLength:(unsigned int)audioDatalength sampleRate:(unsigned int )sampleRate;

@end

NS_ASSUME_NONNULL_END
