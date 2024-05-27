#import <Cocoa/Cocoa.h>
#import "object_impl.h"
#import "ObjectInterface.h"
#import <MetalKit/MetalKit.h>
#import "FrtcCall.h"
#import "common.h"

NS_ASSUME_NONNULL_BEGIN

@interface FrtcMeetingViewController : NSViewController

@property (nonatomic, assign, getter = isVideoMute)       BOOL videoMute;
@property (nonatomic, assign, getter = isAudioMute)       BOOL audioMute;
@property (nonatomic, assign, getter = isPresenterLayout) BOOL presenterLayout;
@property (nonatomic, assign, getter = isGallery)         BOOL gallery;


@property (nonatomic, copy) NSString *displayName;

@property (nonatomic, assign, getter = isSharingWithAudio) BOOL sharingWithAudio;

@property (nonatomic, assign, getter = shareContentType) int shareContentType;

@property (nonatomic, weak) id<FrtcCallDelegate> callDelegate;

- (void)stopLocalRender:(BOOL)stop;

- (void)disappearLocal:(BOOL)disapper;

- (void)switchLayout:(BOOL)isGallery;

- (void)layoutUpdate:(SDKLayoutInfo)buffer;

- (void)onWaterPrint:(NSString *)waterPrint;

- (void)remoteVideoReceived:(NSString *)mediaID;

- (void)remoteAudioReceived:(NSString *)mediaID;

- (void)onVideoFrozen:(NSString *)mediaId videoFrozen:(BOOL)bFrozen;

- (void)stopVideoRender;

@end

NS_ASSUME_NONNULL_END

