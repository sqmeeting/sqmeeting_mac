#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContentAudioBridge : NSObject

+ (ContentAudioBridge *) getInstance;

- (void)sendAudioDataContent:(void *)buffer
                      length:(unsigned int)length
                  sampleRate:(unsigned int)sample_rate;

@end

NS_ASSUME_NONNULL_END
