#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcReConnectCallWindowDelegate <NSObject>

- (void)reConnectMeeting;

- (void)endReConnectCall;

@end

@interface FrtcReConnectCallWindow : NSWindow

- (instancetype)initWithSize:(NSSize)size;

@property (nonatomic, weak) id<FrtcReConnectCallWindowDelegate> reConnectDelegate;

@end

NS_ASSUME_NONNULL_END
