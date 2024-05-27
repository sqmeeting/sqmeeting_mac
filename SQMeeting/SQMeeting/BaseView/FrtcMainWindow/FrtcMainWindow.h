#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface FrtcMainWindow : NSWindow

- (instancetype)initWithSize:(NSSize)size;

- (void)updataSettingComboxWithUserSelectMenuButtonGridMode:(BOOL)isGridMode;

- (void)showWindow;

- (void)adjustToSize:(NSSize)size;

@end

NS_ASSUME_NONNULL_END
