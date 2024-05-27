#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioEngine : NSObject

+ (AudioEngine *)sharedAudioEngine;

@property (nonatomic, copy) NSString *currentDeviceName;

@property (nonatomic, copy) NSString *currentMicphoneName;

- (void)playWithHandler:(void (^)(float meter, BOOL testing))testSpeakerHandler;

- (void)stopPlay;

- (void)startRecord:(void (^)(float meter, BOOL testing))testMicphoneHandler;

- (void)stopRecord;

@end

NS_ASSUME_NONNULL_END
