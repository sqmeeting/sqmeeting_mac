#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ReminderImageButtonType) {
    ReminderImageButtonInfo = 201,
    ReminderImageButtonNetWork,
    ReminderImageButtonExitFullScreen,
    ReminderImageButtonEnterFullScreen,
    ReminderImageButtonGirdMode
};

@protocol FrtcReminderImageButtonDelegate <NSObject>

- (void)reminderImageButtonClicked:(ReminderImageButtonType)type;

- (void)didIntoArea:(BOOL)isInTitleButtonViewArea withSenderType:(ReminderImageButtonType)type;

@end

@interface FrtcReminderImageButton : NSView

@property (nonatomic, strong) NSImageView *imageView;

@property (nonatomic, strong) NSTextField *title;

@property (nonatomic, assign) ReminderImageButtonType buttonType;

@property (nonatomic, weak) id<FrtcReminderImageButtonDelegate> reminderImageButtonDelegate;

@end

NS_ASSUME_NONNULL_END
