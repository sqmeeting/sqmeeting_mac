#import <Cocoa/Cocoa.h>
#import "FrtcBaseViewController.h"
#import "FrtcMainWindow.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcSignViewControllerDelegate <NSObject>

- (void)popupSettingWindow;

@end

@interface FrtcSignViewController : FrtcBaseViewController

@property (nonatomic, strong) FrtcMainWindow *settingWindow;

@property (nonatomic, weak) id<FrtcSignViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
