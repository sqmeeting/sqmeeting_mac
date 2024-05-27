#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcChangeNameWindowDelegate <NSObject>

- (void)changeName:(NSString *)name;

@end

@interface FrtcChangeNameWindow : NSWindow

- (instancetype)initWithSize:(NSSize)size;

- (void)showWindowWithWindow:(NSWindow *)window;

- (void)adjustToSize:(NSSize)size;

- (void)displayToast;

- (void)setOldName:(NSString *)oldName;

@property (nonatomic, weak) id<FrtcChangeNameWindowDelegate> changeNameDelegate;

@end

NS_ASSUME_NONNULL_END
