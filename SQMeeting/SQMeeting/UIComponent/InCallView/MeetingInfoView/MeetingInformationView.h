#import <Cocoa/Cocoa.h>
#import <QuartzCore/CAAnimation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MeetingInformationViewDelegate <NSObject>

- (void)repeateUpdateView;

@end


@interface MeetingInformationView : NSView<CAAnimationDelegate>

@property (nonatomic, strong) NSTextField *infomationTextField;
@property (nonatomic, assign) CGFloat    cycleNumbers;
@property (nonatomic, getter = isStillnessInfo) BOOL stillnessInfo;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, weak) id<MeetingInformationViewDelegate> delegate;

@property(nonatomic, assign) double duration;

- (void)configMessageViewAnimation:(double)duration;

- (void)setupViewSize:(CGSize)size;

- (void)stop;

- (void)restart;

- (void)reSetupStilnessLayout;

@end

NS_ASSUME_NONNULL_END
