#import <Cocoa/Cocoa.h>
#import "FrtcCallInterface.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcCallWindowDelegate <NSObject>

- (void)closeWindow;

- (void)makeCall:(FRTCMeetingParameters)callParam;

@end

@interface FrtcCallWindow : NSWindow

- (instancetype)initWithSize:(NSSize)size;

- (void)showWindow;

- (void)adjustToSize:(NSSize)size;

@property (nonatomic, weak) id<FrtcCallWindowDelegate> frtcCallWindowdelegate;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, getter=isLogin) BOOL login;

@end

NS_ASSUME_NONNULL_END
