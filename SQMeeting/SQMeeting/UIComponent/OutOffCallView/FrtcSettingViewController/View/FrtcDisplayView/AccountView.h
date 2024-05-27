#import <Cocoa/Cocoa.h>
#import "FrtcPersonalTabCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AccountViewDelegate <NSObject>

- (void)frtcPersonalLogout;

- (void)frtcPersonalupdatePassword;

@end

@interface AccountView : NSView

@property (nonatomic, strong) FrtcPersonalTabCell *nameTabCell;

@property (nonatomic, strong) FrtcPersonalTabCell *accountTabCell;

@property (nonatomic, strong) FrtcPersonalTabCell *passwordTabCell;

@property (nonatomic, strong) FrtcPersonalTabCell *logoutTabCell;

@property (nonatomic, strong) NSView *line;

@property (nonatomic, weak) id<AccountViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
