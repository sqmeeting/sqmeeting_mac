#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TitleBarButtonType) {
    TitleBarButtonInfo = 201,
    TitleBarButtonNetWork,
    TitleBarButtonExitFullScreen,
    TitleBarButtonEnterFullScreen,
    TitleBarButtonGirdMode
};

@protocol TitleBarButtonDelegate <NSObject>

- (void)titleBarButtonClicked:(TitleBarButtonType)type;

- (void)didIntoArea:(BOOL)isInTitleButtonViewArea withSenderType:(TitleBarButtonType)type;

@end

@interface TitleBarButton : NSView

@property (nonatomic, strong) NSImageView *imageView;

@property (nonatomic, strong) NSTextField *title;

@property (nonatomic, assign) TitleBarButtonType buttonType;

@property (nonatomic, weak) id<TitleBarButtonDelegate> titleBarButtonDelegate;

@end

NS_ASSUME_NONNULL_END
