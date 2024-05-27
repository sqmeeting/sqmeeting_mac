#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NormalSettingViewDelegate <NSObject>

- (void)updateServerAddress;

- (void)wrongServerAddress;

@end

@interface NormalSettingView : NSView

@property (nonatomic, weak) id<NormalSettingViewDelegate> delegate;

- (void)setResponder;

@end

NS_ASSUME_NONNULL_END
