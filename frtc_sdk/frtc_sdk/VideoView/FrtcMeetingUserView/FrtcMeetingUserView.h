#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface FrtcMeetingUserView : NSView

@property (nonatomic, strong) NSImageView *backGroundView;

@property (nonatomic, strong) NSTextField * nameLabel;

@property (nonatomic, strong) NSImageView *pinView;

@property (nonatomic, strong) NSImageView *muteView;

@property (nonatomic, assign, getter=isPin) BOOL pin;

@property (nonatomic, assign, getter=isUserMute) BOOL userMute;

- (void)configNewUserNameView:(BOOL)pin;

- (void)updateMuteView:(BOOL)userMute;

- (void)configContentWidth;

@end

NS_ASSUME_NONNULL_END
