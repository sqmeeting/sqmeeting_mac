#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcRtfViewControllerDelegate <NSObject>

- (void)userProtocolAlreadRead;

@end

@interface FrtcRtfViewController : NSViewController

@property (nonatomic, weak) id<FrtcRtfViewControllerDelegate> rtfViewDelegate;

@end

NS_ASSUME_NONNULL_END
