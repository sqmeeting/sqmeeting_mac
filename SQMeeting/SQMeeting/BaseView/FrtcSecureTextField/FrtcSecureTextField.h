#import <Cocoa/Cocoa.h>
#import "SecureImageView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PMSecureTextFieldDelegate <NSObject>

- (void)switchPasswordView:(NSInteger)tag;

@end

@interface FrtcSecureTextField : NSSecureTextField<NSTextFieldDelegate>

@property (nonatomic, strong) SecureImageView *secureImageView;

@property (nonatomic, weak) id<PMSecureTextFieldDelegate> secureTextFieldDelegate;

@end

NS_ASSUME_NONNULL_END
