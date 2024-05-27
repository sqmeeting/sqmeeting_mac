#import "FrtcBaseViewController.h"
#import "LoginModel.h"
#import "FrtcTabControlView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FrtcSettingViewController : FrtcBaseViewController

@property (nonatomic, getter=isLogin) BOOL login;

@property (nonatomic, strong) LoginModel *model;

@property (nonatomic, assign) FrtcSettingType settingType;

- (instancetype)initWithloginStatus:(BOOL)loginStatus;

- (void)stopLocalViewRender;

- (void)updataSettingComboxWithUserSelectMenuButtonGridMode:(BOOL)isGridMode;

@end

NS_ASSUME_NONNULL_END
