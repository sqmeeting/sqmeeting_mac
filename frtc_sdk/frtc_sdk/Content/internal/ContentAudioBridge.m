#import "ContentAudioBridge.h"
#import "ObjectInterface.h"

@implementation ContentAudioBridge

+ (ContentAudioBridge *) getInstance {
    static ContentAudioBridge *kSingleInstance = nil;
    static dispatch_once_t once_taken = 0;
    dispatch_once(&once_taken, ^{
        kSingleInstance = [[ContentAudioBridge alloc] init];
    });
    
    return kSingleInstance;
}

- (void)sendAudioDataContent:(void *)buffer
                      length:(unsigned int)length
                  sampleRate:(unsigned int)sample_rate {
    NSString *mediaID = @"_parxSourceID";
    
    [[ObjectInterface sharedObjectInterface] sendContentAudioFrameObject:mediaID videoBuffer:buffer length:1920 sampleRate:48000];
}

@end
