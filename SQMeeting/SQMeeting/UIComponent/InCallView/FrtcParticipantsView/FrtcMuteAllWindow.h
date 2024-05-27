#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FrtcMuteAllWindowDelegate <NSObject>

- (void)muteAll:(BOOL)allowUserUnmuteSelf;

@end

@interface FrtcMuteAllWindow : NSWindow

- (instancetype)initWithSize:(NSSize)size;

@property (nonatomic, weak) id<FrtcMuteAllWindowDelegate> muteAllDelegate;

@end

NS_ASSUME_NONNULL_END
