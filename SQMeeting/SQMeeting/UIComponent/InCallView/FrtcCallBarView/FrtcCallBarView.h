#import <Cocoa/Cocoa.h>
#import "CallBarBackGroundView.h"
#import "HoverImageView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcCallBarViewtDelegate <NSObject>

- (void)showSettingWindow;

- (void)endMeeting;

- (void)showNameList;

- (void)showMeetingInfo;

- (void)poverContentAudio;

- (void)showContentWindow;

- (void)muteAudioByUser:(BOOL)isMute;

- (void)enableMesage:(BOOL)enable;

- (void)showVideoRecordingWindow:(BOOL)show;

- (void)showVideoStreamingWindow:(BOOL)show;

- (void)showVideoStreamUrlWindow;

- (void)quickSelectAudioDevice;

- (void)quickSelectVideoDevice;

@end

@interface FrtcCallBarView : NSView

@property (nonatomic, weak) id<FrtcCallBarViewtDelegate> callBarViewDelegate;

@property (nonatomic, strong) NSTextField           *rosterNumberTextField;

@property (nonatomic, strong) FrtcHoverButton  *videoMuteButton;
@property (nonatomic, strong) NSTextField           *videoMuteLabel;
@property (nonatomic, strong) CallBarBackGroundView *videoMuteBackGroundView;

@property (nonatomic, strong) FrtcHoverButton  *muteAudioButton;
@property (nonatomic, strong) NSTextField           *muteAudioLabel;
@property (nonatomic, strong) CallBarBackGroundView *muteAudioBackGroundView;
@property (nonatomic, strong) CallBarBackGroundView *selectAudioDeviceBackGroundView;
@property (nonatomic, strong) FrtcHoverButton  *selectAudioDeviceButton;

@property (nonatomic, strong) HoverImageView        *contentAudioImageView;
@property (nonatomic, strong) CallBarBackGroundView *contentAudioBackGroundView;

@property (nonatomic, strong) FrtcHoverButton  *localMuteButton;
@property (nonatomic, strong) NSTextField           *localMuteLabel;
@property (nonatomic, strong) CallBarBackGroundView *selectVideoDeviceBackGroundView;
@property (nonatomic, strong) FrtcHoverButton  *selectVideoDeviceButton;

@property (nonatomic, strong) FrtcHoverButton  *enableTextButton;
@property (nonatomic, strong) NSTextField           *enableTexttLabel;
@property (nonatomic, strong) CallBarBackGroundView *enableTextBackGroundView;

@property (nonatomic, strong) FrtcHoverButton  *disableTextButton;
@property (nonatomic, strong) NSTextField           *disableTexttLabel;
@property (nonatomic, strong) CallBarBackGroundView *disableTextBackGroundView;

@property (nonatomic, strong) FrtcHoverButton  *videoRecordingButton;
@property (nonatomic, strong) NSTextField           *videoRecordingLabel;
@property (nonatomic, strong) CallBarBackGroundView *videoRecordingBackGroundView;

@property (nonatomic, strong) FrtcHoverButton  *videoStreamingButton;
@property (nonatomic, strong) NSTextField           *videoStreamingLabel;
@property (nonatomic, strong) CallBarBackGroundView *videoStreamingBackGroundView;

@property (nonatomic, strong) CallBarBackGroundView *inviteStreamingBackGroundView;
@property (nonatomic, strong) FrtcHoverButton  *inviteStreamingButton;

@property (nonatomic, strong) NSImageView *showNewComingView;

@property (nonatomic, assign, getter=isAudioCall) BOOL audioCall;

- (void)setButtonState:(NSControlStateValue)stateValue;

- (void)setVideoButtonState:(NSControlStateValue)stateValue;

- (instancetype)initWithAudoStatus:(BOOL)audioCall withAuthority:(BOOL)authority withMeetingOwner:(BOOL)meetingOwner;

@end

NS_ASSUME_NONNULL_END
