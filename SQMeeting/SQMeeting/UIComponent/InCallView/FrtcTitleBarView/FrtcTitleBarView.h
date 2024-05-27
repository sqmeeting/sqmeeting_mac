#import <Cocoa/Cocoa.h>
#import "TitleBarButton.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FrtcTitleBarViewDelegate <NSObject>

- (void)popupMeetingInfo:(BOOL)show;

- (void)popupStaticsInfo:(BOOL)show;

- (void)enterFullScreen:(BOOL)isFullScreen;

- (void)openGridModeView;

@end

@interface FrtcTitleBarView : NSView

@property (nonatomic, weak) id<FrtcTitleBarViewDelegate> titleBarViewDelegate;

@property (strong, nonatomic) TitleBarButton    *infoButton;
@property (strong, nonatomic) TitleBarButton    *networkButton;
@property (strong, nonatomic) TitleBarButton    *fullScreenButton;
@property (strong, nonatomic) TitleBarButton    *gridModeButton;
@property (strong, nonatomic) TitleBarButton    *exitModeButton;

- (void)updateGridModeButtonLayout:(NSString *)str;

- (void)fullScreenState:(NSInteger)state;

@end

NS_ASSUME_NONNULL_END
