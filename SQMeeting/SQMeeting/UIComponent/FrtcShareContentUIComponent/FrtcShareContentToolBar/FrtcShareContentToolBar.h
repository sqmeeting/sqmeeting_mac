#import <Cocoa/Cocoa.h>
#import "HoverImageView.h"
#import "CallBarBackGroundView.h"

#define TOOL_BAR_WIDTH 832
#define TOOL_BAR_HEIGHT 92
#define TOOL_BAR_BORDER_WIDTH 1.5f

@protocol ContentToolBarDelegate <NSObject>

- (void)showRosterWindow;

- (void)showSettingWindow;

- (void)showMeetingInfo;

- (void)stopShareContent;

- (void)showStatics;

- (void)showStartOverLayMessage:(BOOL)show;

- (void)showVideoRecordingWindow:(BOOL)show;

- (void)showVideoStreamingWindow:(BOOL)show;

- (void)showVideoStreamUrlWindow;

- (void)quickSelectAudioDevice;

- (void)quickSelectVideoDevice;

@end

@interface FrtcShareContentToolBar : NSWindow

@property (nonatomic, strong) HoverImageView        *imageView;
@property (nonatomic, strong) NSTextField           *timeTextField;
@property (nonatomic, strong) NSTextField           *nameTextField;

@property (nonatomic, strong) NSTextField           *rosterNumberTextField;

@property (nonatomic, strong) FrtcHoverButton  *videoMuteButton;
@property (nonatomic, strong) NSTextField           *videoMuteLabel;
@property (nonatomic, strong) CallBarBackGroundView *selectVideoDeviceBackGroundView;
@property (nonatomic, strong) FrtcHoverButton  *selectVideoDeviceButton;

@property (nonatomic, strong) FrtcHoverButton  *muteAudioButton;
@property (nonatomic, strong) NSTextField           *muteAudioLabel;
@property (nonatomic, strong) CallBarBackGroundView *selectAudioDeviceBackGroundView;
@property (nonatomic, strong) FrtcHoverButton  *selectAudioDeviceButton;

@property (nonatomic, strong) FrtcHoverButton  *dropCallButton;
@property (nonatomic, strong) NSTextField           *dropCallLabel;


@property (nonatomic, strong) FrtcHoverButton  *inviteButton;
@property (nonatomic, strong) NSTextField           *inviteLabel;


@property (nonatomic, strong) FrtcHoverButton  *nameListButton;
@property (nonatomic, strong) NSTextField           *nameListLabel;


@property (nonatomic, strong) FrtcHoverButton  *callSettingButton;
@property (nonatomic, strong) NSTextField           *callSettingLabel;


@property (nonatomic, strong) FrtcHoverButton  *localMuteButton;
@property (nonatomic, strong) NSTextField           *localMuteLabel;

@property (nonatomic, strong) FrtcHoverButton  *shareContentButton;
@property (nonatomic, strong) NSTextField           *shareContentLabel;

@property (nonatomic, strong) FrtcHoverButton  *enableTextButton;
@property (nonatomic, strong) NSTextField           *enableTexttLabel;

@property (nonatomic, strong) FrtcHoverButton  *disableTextButton;
@property (nonatomic, strong) NSTextField           *disableTexttLabel;

@property (nonatomic, strong) FrtcHoverButton  *videoRecordingButton;
@property (nonatomic, strong) NSTextField           *videoRecordingLabel;

@property (nonatomic, strong) FrtcHoverButton  *videoStreamingButton;
@property (nonatomic, strong) NSTextField           *videoStreamingLabel;

@property (nonatomic, strong) CallBarBackGroundView *inviteStreamingBackGroundView;
@property (nonatomic, strong) FrtcHoverButton  *inviteStreamingButton;

@property (nonatomic, weak) id<ContentToolBarDelegate> shareBarDelegate;

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)windowStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)deferCreation;


- (void)reLayout;

- (void)reBackLayout;

- (void)updateLayout:(BOOL)isAuthority meetingOwner:(BOOL)isMeetingOwner;

@end
