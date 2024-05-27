#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FrtcContentAudioSettingViewControllerDelegate <NSObject>

@optional
- (void)sendContentAudio:(BOOL)contentAudio;

@end

@interface FrtcContentAudioSettingViewController : NSViewController

@property (nonatomic, weak) id<FrtcContentAudioSettingViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
