#import <MetalKit/MetalKit.h>
#import "object_impl.h"
#import "FrtcMeetingUserView.h"
#import "FrtcUserMuteView.h"

NS_ASSUME_NONNULL_BEGIN

@class FrtcMTKRender;

@interface FrtcMTKView : MTKView

@property (nonatomic, strong) NSTextField *siteNameTextField;

@property (nonatomic, strong) FrtcMeetingUserView *userNameView;

@property (nonatomic, strong) FrtcUserMuteView *userMuteView;

@property (nonatomic, copy) NSString *mediaID;

@property (nonatomic, copy) NSString *userUUID;

- (void)initiateVideoRendering;

- (void)endupVideoRendering;

- (void)displayMuteViews:(BOOL)isDisplay;

- (void)setVideoRenderMediaID:(NSString *)renderMeidaID;

- (void)configVideoColorFormat:(RTC::VideoColorFormat)format;

- (NSString *)mediaID;

- (BOOL)acceptsFirstResponder;

- (BOOL)acceptsFirstMouse:(nullable NSEvent *)event;

- (instancetype)initWithFrame:(NSRect)frameRect mediaID:(NSString *)mediaID;

- (void)setRemoteUserActivitySpeakerStatus:(BOOL)isActivity;

- (void)updateSiteNameView:(BOOL)userMute;

- (void)renewWaterPrinting;

- (void)setupWaterMark:(NSString *)waterMarkInfomation;

@end


NS_ASSUME_NONNULL_END
