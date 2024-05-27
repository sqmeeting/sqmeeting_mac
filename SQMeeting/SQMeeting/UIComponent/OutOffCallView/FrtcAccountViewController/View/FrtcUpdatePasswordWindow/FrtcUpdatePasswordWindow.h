#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcUpdatePasswordWindowDelegate <NSObject>

- (void)modifyPassWord:(NSString *)oldPasssword newPassword:(NSString *)newPassword;

@end

@interface FrtcUpdatePasswordWindow : NSWindow

@property (nonatomic, weak) id<FrtcUpdatePasswordWindowDelegate> modifyDelegate;

- (instancetype)initWithSize:(NSSize)size;

- (void)showWindow;

- (void)adjustToSize:(NSSize)size;

- (void)showReminderView:(NSString *)reminderValue;

- (void)setupPasswordSecurityLevel;

- (void)showWindowWithWindow:(NSWindow *)window;

@property (nonatomic, assign, getter=isNormalUser) BOOL normalUser;

@end

NS_ASSUME_NONNULL_END
