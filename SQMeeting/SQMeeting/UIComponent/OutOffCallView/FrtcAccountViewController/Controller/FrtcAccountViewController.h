#import <Cocoa/Cocoa.h>
#import "LoginModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FrtcAccountViewController : NSViewController

@property (nonatomic, strong) LoginModel *model;

- (void)makeUrlCall:(NSString *)url;

- (void)showServerErrorInfo;

- (void)addMeeing:(NSString *)url;


@end

NS_ASSUME_NONNULL_END
