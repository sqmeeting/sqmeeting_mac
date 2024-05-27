#import <Foundation/Foundation.h>
#import "MicphoneCapture.h"
#import "SpeakerRender.h"
#import "DeviceObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface FrtcAudioClient : NSObject

+ (FrtcAudioClient *)audioClientSingleton;

- (OSStatus)removeAudioUnitCoreGraph;

- (OSStatus)enableAudioUnitCoreGraph;

- (OSStatus)disableAudioUnitCoreGraph;

- (void)makeMicMute:(BOOL)mute;

- (void)getDeviceInputMicArray:(NSMutableArray *)inputDeviceListArray;

- (void)getDeviceOutputSpeakerList:(NSMutableArray *)outputDeviceListArray;

- (void)switchMicphoneByDeviceID:(NSString *)id;

- (void)switchSpeakerByDeviceID:(NSString *)id;

- (void)testAudioMicphone:(BOOL)enable withHandler:(void (^)(float meter, BOOL testing))testMicHandler;

@property (nonatomic, strong) MicphoneCapture *micphoneDeviceCapture;

@property (nonatomic, strong) SpeakerRender     *speakerRender;

@property (nonatomic, strong) NSMutableArray    *micphoneDeviceList;

@property (nonatomic, strong) NSMutableArray    *speakerDeviceList;

@property (nonatomic, strong) NSString *nowUsedMicphoneDevice;

@property (nonatomic, strong) NSString *nowUsedSpeakerDevice;

@property (nonatomic, assign, getter=isAudioUnitRunning) BOOL audioUnitRunning;

@property (nonatomic, assign, getter=isDeviceDefaultBuiltMicphone) BOOL deviceDefaultBuiltMicphone;

- (void)newAudioDeviceNotification:(NSNotification *)notification;

- (void)unpluggingAudioDeviceNotification:(NSNotification *)notification;

- (AudioDeviceID)obtainMicphoneIDByDeviceName:(NSString *)deviceName;

- (AudioDeviceID)obtainSpeakerIDByDeviceName:(NSString *)deviceName;

- (NSString *)getNowUsedMicphoneDevice;

- (NSString *)getNowUsedSpeakerDevice;

- (NSString *)systemSelectDefaultMicphone;

- (NSString *)systemSelectDefaultSpeaker;

- (void)startAudioUnitInputDevice;

- (void)startAudioUnitOutputDevice;


@end

NS_ASSUME_NONNULL_END
