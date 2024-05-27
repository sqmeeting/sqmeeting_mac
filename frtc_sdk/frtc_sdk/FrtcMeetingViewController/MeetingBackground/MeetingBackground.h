#import <Cocoa/Cocoa.h>
#import "ObjectInterface.h"
#import "FrtcMTKView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MeetingBackground : NSImageView

@property (nonatomic, assign) NSSize currentSize;

@property (nonatomic, assign) NSSize screenSize;

@property (nonatomic, assign) NSSize fullScreenSize;

@property (nonatomic, assign) CGFloat ratio;

@property (nonatomic, assign, getter=isFullScreen) BOOL fullScreen;

@property (nonatomic, assign, getter = isVideoMute) BOOL videoMute;

@property (nonatomic, assign, getter = isAudioMute) BOOL audioMute;

@property (nonatomic, assign, getter = isPresenterLayout) BOOL presenterLayout;

@property (nonatomic, assign, getter = isGallery) BOOL gallery;

@property (nonatomic, assign, getter=isContentLayoutReady) BOOL contentLayoutReady;

@property (nonatomic, assign, getter = isSendingContent) BOOL sendingContent;

@property (nonatomic, assign, getter=isRemoteViewHidden) BOOL remoteViewHidden;

@property (nonatomic, strong) FrtcMTKView *contentVideoView;

@property (nonatomic, copy) NSString *displayName;

- (void)remoteMediaID:(NSString *)mediaID;

- (void)layoutUpdate:(SDKLayoutInfo)buffer;

- (void)stopLocalRender:(BOOL)stop;

- (void)refreshCurrentLayout;

- (void)switchLayout:(BOOL)isGallery;

- (void)muteStateChanged:(NSMutableArray *)array;

- (void)onVideoFrozen:(NSString *)mediaId videoFrozen:(BOOL)bFrozen;

- (void)stopVideoRender;

- (void)disappearLocal:(BOOL)disapper;

- (void)onWaterPrint:(NSString *)waterPrint;

@end

NS_ASSUME_NONNULL_END
