#import <Cocoa/Cocoa.h>
@class ViewControllerManagerClient;

typedef enum : NSUInteger {
    START_FLAG_STANDARD,
    START_FLAG_SINGLE_TASK,
} StartFlag;

@interface BaseViewController : NSViewController {
    StartFlag startFlag;
}

@property (nonatomic, strong) NSImageView               *background;
@property (nonatomic, strong) NSView                    *titleView;
@property (nonatomic, strong) NSTextField               *titleText;

@property (nonatomic)  BOOL isURLCall;

@property int ResRatio;

@property (assign) StartFlag startFlag;

- (void)setPageTitleText:(NSString *) titleText;

- (void)startWaitingProgress;

- (void)stopWaitingProgress;

- (void)showCallStateTipMessage:(NSString *)tipMsg;

@end
