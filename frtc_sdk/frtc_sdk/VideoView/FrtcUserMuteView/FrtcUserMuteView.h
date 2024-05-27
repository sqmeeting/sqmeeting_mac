#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface FrtcUserMuteView : NSView

@property (nonatomic, strong) NSImageView *muteView;

@property (nonatomic, strong) NSImageView *pinView;

- (void)updateMuteView:(BOOL)userMute;

- (void)updatePin:(BOOL)pin;

@end

NS_ASSUME_NONNULL_END
