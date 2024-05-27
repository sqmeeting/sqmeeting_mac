#import <Cocoa/Cocoa.h>
#import "LoginModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcPersonalViewControllerDelegate <NSObject>

- (void)frtcPersonalViewLogout;

- (void)frtcPersonalViewUpdatePassword;

- (void)frtcPersonalPopupModifyNameWindow;

@end

@interface FrtcPersonalViewController : NSViewController

@property (nonatomic, strong) LoginModel *model;

@property (nonatomic, weak) id<FrtcPersonalViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
