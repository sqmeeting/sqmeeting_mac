#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoSettingView : NSView

- (void)showLocalVideoView;

- (void)stop;

- (void)updataSettingComboxWithUserSelectMenuButtonGridMode:(BOOL)isGridMode;

@end

NS_ASSUME_NONNULL_END
