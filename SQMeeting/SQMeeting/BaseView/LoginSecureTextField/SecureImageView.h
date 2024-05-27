#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SecureImageViewDelegate <NSObject>

- (void)changePasswordView;

- (void)lost;

@end

@interface SecureImageView : NSImageView

@property (nonatomic, weak) id<SecureImageViewDelegate> secureImageViewDelegate;

@end

NS_ASSUME_NONNULL_END
