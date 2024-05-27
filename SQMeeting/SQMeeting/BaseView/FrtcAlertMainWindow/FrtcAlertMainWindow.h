#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FrtcWindowAlertActionStyle) {
    FrtcWindowAlertActionStyleOK = 0,
    FrtcWindowAlertActionStyleCancle,
    FrtcWindowAlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, FrtcWindowAlertStyle) {
    FrtcWindowAlertStyleDefault = 0,
    FrtcWindowAlertStyleOnly,
    FrtcWindowAlertStyleNoTitle
} API_AVAILABLE(ios(8.0));

typedef void (^FrtcAlertActionHandler)();

@interface FrtcAlertAction : NSObject

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(FrtcWindowAlertActionStyle)style handler:(void (^ __nullable)())handler;

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) FrtcWindowAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;
@property (nonatomic, copy) FrtcAlertActionHandler alertActionHandler;

@end

@interface FrtcAlertMainWindow : NSWindow

+ (FrtcAlertMainWindow *)showAlertWindowWithTitle:(NSString *)title withMessage:(NSString *)message preferredStyle:(FrtcWindowAlertStyle)style withCurrentWindow:(NSWindow *)window;

+ (FrtcAlertMainWindow *)showAlertWindowWithTitle:(NSString *)title withMessage:(NSString *)message preferredStyle:(FrtcWindowAlertStyle)style withCurrentWindow:(NSWindow *)window withWindowSize:(NSSize)size;

- (void)addAction:(FrtcAlertAction *)action;

- (void)addAction:(FrtcAlertAction *)action withTitleColor:(NSColor *)titleColor;

@end

NS_ASSUME_NONNULL_END
