#import <Cocoa/Cocoa.h>
#import "SecureImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginSecureTextField : NSSecureTextField<NSTextFieldDelegate>

@property (nonatomic, strong) NSImageView  *imageView;

@property (nonatomic, strong) SecureImageView *secureImageView;

@end

NS_ASSUME_NONNULL_END
