#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface FrtcInCallSettingWindow : NSWindow

- (instancetype)initWithSize:(NSSize)size;
- (void)updataSettingComboxWithUserSelectMenuButtonGridMode:(BOOL)isGridMode;

@end

NS_ASSUME_NONNULL_END
