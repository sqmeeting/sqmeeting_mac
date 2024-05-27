#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "FrtcMaskView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FrtcBaseViewController : NSViewController 

@property (nonatomic, strong) NSImageView               *background;

@property (nonatomic, strong) FrtcMaskView              *maskView;

@property (nonatomic, assign) BOOL isURLCall;

- (void)startWaitingProgress;

- (void)stopWaitingProgress;

- (void)showCallStateTipMessage:(NSString *)tipMsg;

- (void)showMaskView:(BOOL)show;

- (void)showMaskViewWithProgress:(BOOL)show;

- (void)showInvisibleMaskView:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
