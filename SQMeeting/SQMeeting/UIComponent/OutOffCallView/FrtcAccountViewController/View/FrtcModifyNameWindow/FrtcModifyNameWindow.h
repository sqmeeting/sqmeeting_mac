#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcModifyNameWindowDelegate <NSObject>

- (void)saveDisplayName:(NSString *)displayName;

@end

@interface FrtcModifyNameWindow : NSWindow

- (instancetype)initWithSize:(NSSize)size;

- (void)showWindow;

- (void)adjustToSize:(NSSize)size;

- (void)setDisplayName:(NSString *)userName;

@property (nonatomic, weak) id<FrtcModifyNameWindowDelegate> modifyNameDelegate;

@end

NS_ASSUME_NONNULL_END
