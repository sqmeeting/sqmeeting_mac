#import <Cocoa/Cocoa.h>
#import "FrtcEnableMessageBackgroundView.h"
#import "MessageButton.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcEnableMessageViewDelegate <NSObject>

- (void)enableScroll:(BOOL)scroll;

- (void)startOverlayMessage:(NSString *)message withRepeat:(NSInteger)repeat withPosition:(NSInteger)position withScroll:(BOOL)isScroll;

- (void)cancelMessage;

@end

@interface FrtcEnableMessageView : NSView

@property (nonatomic, strong) FrtcEnableMessageBackgroundView *topBackgroundView;

@property (nonatomic, strong) FrtcEnableMessageBackgroundView *middleBackgroundView;

@property (nonatomic, strong) FrtcEnableMessageBackgroundView *bottomBackgroundView;

@property (nonatomic, weak) id<FrtcEnableMessageViewDelegate> delegate;

@property (nonatomic, strong) MessageButton *upButton;

@property (nonatomic, strong) MessageButton *downButton;

@end

NS_ASSUME_NONNULL_END
