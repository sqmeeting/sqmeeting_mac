#import "FrtcBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FrtcMainViewController : FrtcBaseViewController

@property (nonatomic, assign, getter=isInitialized) BOOL initialized;

- (void)makeUrlCall:(NSString *)url;

- (void)showServerErrorInfo;

- (void)showLoginInfo;

@end

NS_ASSUME_NONNULL_END
