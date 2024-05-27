#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN


@protocol FrtcContentWindowDelegate <NSObject>

@optional
- (void)onRleaseSelectContentWindow;

@end


@interface FrtcContentWindowController : NSWindowController <NSWindowDelegate>

@property (nonatomic, weak) id<FrtcContentWindowDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
