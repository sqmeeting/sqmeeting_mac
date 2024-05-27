#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcExceptionWindowDelegate <NSObject>

- (void)endReconnectProcess;

- (void)onInCallWindowInitializedState:(NSInteger)state;

@end

@interface FrtcExceptionWindow : NSWindow

- (instancetype)initWithSize:(NSSize)size;

@property (nonatomic, weak) id<FrtcExceptionWindowDelegate> exceptionWindowDelegate;

@end

NS_ASSUME_NONNULL_END
