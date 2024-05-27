#import <Cocoa/Cocoa.h>
#import "SecureImageView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PasswordTextFieldDelegate <NSObject>

- (void)switchPasswordView:(NSInteger)tag;

@end

@interface PasswordTextField : NSTextField

@property (nonatomic, strong) SecureImageView *secureImageView;

@property (nonatomic, weak) id<PasswordTextFieldDelegate> passwordDelegate;

@end

NS_ASSUME_NONNULL_END
