#import <Foundation/Foundation.h>
#include <AudioToolbox/AudioToolbox.h>
#include <AudioUnit/AudioUnit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

extern OSStatus AudioInputProc(void* inRefCon, AudioUnitRenderActionFlags* ioActionFlags, const AudioTimeStamp* inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList* ioData);

@protocol MicphoneCaptureDelegate <NSObject>

- (void)sendMicphoneCaptureData:(unsigned char *)audioDataBuffer dataLength:(int)length captureSampleRate:(int)sampleRate ;

@end

@interface MicphoneCapture : NSObject {
@public
    AudioBufferList *audioBufferList;
    AudioUnit myAudioUnit;
    AudioStreamBasicDescription asbdAec;
    AudioStreamBasicDescription asbdHw;
    AudioConverterRef audioConvert;
    AudioStreamBasicDescription outputStreamBasicformat;
    
    int outputStreamSampleRate;
    int outputAudioFrameSize;
    int outputAudioBufferSize;
    int outputAudioPerFrameSize;
    int outputAudioCaptureMicphoneFrameSize;
    int index;
    short *dataTempBuffer;
    
}

@property (nonatomic, weak) id<MicphoneCaptureDelegate> delegate;
@property (nonatomic, assign, getter=isMuted) BOOL muted;
@property (nonatomic) BOOL is2ndMic;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic) AudioDeviceID micphoneDevice;;

- (OSStatus)setupMicphoneCaptureUnit;
- (OSStatus)disableAudioInputMicphoneUnit;
- (OSStatus)enableAudioInputMicphoneUnit;
- (OSStatus)removeAudioInputMicphoneUnit;

- (void)testAudioUnitSourceMicphone:(BOOL)enable withHandler:(void (^)(float meter, BOOL testing))testMicHandler;

- (void)sendMicphoneCaptureData:(unsigned char *)audioDataBuffer dataLength:(int)length;


@end

NS_ASSUME_NONNULL_END
