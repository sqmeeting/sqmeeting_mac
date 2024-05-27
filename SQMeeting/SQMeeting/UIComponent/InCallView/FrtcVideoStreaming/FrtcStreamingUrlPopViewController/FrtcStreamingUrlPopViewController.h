#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcStreamingUrlPopViewControllerDelegate <NSObject>

- (void)popupStreamingWindow;

@end

@interface FrtcStreamingUrlPopViewController : NSViewController

@property (nonatomic, weak) id<FrtcStreamingUrlPopViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
