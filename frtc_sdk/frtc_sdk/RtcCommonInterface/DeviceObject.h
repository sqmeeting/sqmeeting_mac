#import <Foundation/Foundation.h>
#import <CoreGraphics/CGDirectDisplay.h> ////for CGDirectDisplayID
#include "object_impl.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark- DeviceObjectClient

@interface DeviceObjectClient : NSObject

+ (DeviceObjectClient *)sharedDeviceObject;
+ (void)releaseInstance;


#pragma mark- Audio -
- (void)enableAudioUnitCoreGraph;

- (void)disableAudioUnitCoreGraph;

- (void)getMicphoneArray:(NSMutableArray *)array;

- (void)switchMicphoneByDeviceID:(NSString *)id;

- (void)getSpeakerArray:(NSMutableArray *)array;

- (void)switchSpeakerByDeviceID:(NSString*) id;

- (NSString *)getDefaultMicName;

- (NSString *)getDefaultSpeakerName;

- (void)startUnitSourceChan;

- (void)startUnitSinkChan;

#pragma mark- CaptureCameraStream -
-(void)enableCameraWork;

-(void)disableCameraWork;

-(void)getCameraArray:(NSMutableArray *)array;

-(void)switchCameraByDeviceID:(NSString *)id;

-(void)setCameraMediaId:(NSString *)mediaId;

#pragma mark- ContentCapture -
- (void)startDesktopScreenCapture:(BOOL)enableContentAudio;

- (void)startAppContentAudioWithWindowID:(uint32_t)windowID;

- (void)stopAppContentAudio;

- (void)startAppWindowCapture;

- (void)stopDesktopScreenCapture;

- (void)stopAppWindowCapture;

- (void)configContentMediaId:(std::string)mediaId;

- (void)configDirectDisplayID:(CGDirectDisplayID)displayID;

- (BOOL)configApplicationWindowID:(NSString*)windowID;

- (void)configContentCapbilityLevel:(int)width height:(int) height framerate:(float)framerate;

- (BOOL)configApplicationName:(NSString *)sourceAppContentName;

- (void)showShareIndicatorAndPrepareForAppShare;

- (void)stopShowShareIndicator;

- (NSArray *)getDisplayScreenArray;

- (void)enableCapture;

- (void)disableCapture;

- (void)testMic:(BOOL)enable withHandler:(void (^)(float meter, BOOL testing))testMicHandler;

- (NSString *)getDefaultCameraName;

@end

NS_ASSUME_NONNULL_END
