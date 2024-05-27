#import <Cocoa/Cocoa.h>
#import "LoginModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcPersonViewDelegate <NSObject>

- (void)frtcPersonalLogout;

- (void)frtcPersonalupdatePassword;

- (void)frtcPopupModifyNameWindow;

//- (void)frtcGotoMyRecording;

@end

@interface FrtcPersonView : NSView

@property (nonatomic, strong) LoginModel *model;

@property (nonatomic, weak) id<FrtcPersonViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
