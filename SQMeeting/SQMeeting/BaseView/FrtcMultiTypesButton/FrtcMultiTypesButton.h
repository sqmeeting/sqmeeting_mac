
#import <Cocoa/Cocoa.h>
#import "FrtcMultiTypesButtonCell.h"

NS_ASSUME_NONNULL_BEGIN

/**
Enum for button style.
*/
typedef NS_ENUM(NSInteger, PMButtonStyle) {
    FR_BTN_PRIMARY,
    FR_BTN_SECONDARY,
    FR_BTN_THIRD,
    FR_BTN_FORTH,
    FR_BTN_FIFTH,
    FR_BTN_ITEM,
    FR_BTN_SIX,
    FR_BTN_SEVEN,
    FR_BTN_EIGHT,
    FR_BTN_NINE,
    FR_BTN_TEN
};

@interface FrtcMultiTypesButton : NSButton

- (instancetype)initFirstWithFrame:(NSRect)frame withTitle:(NSString *)title;
- (instancetype)initSecondaryWithFrame:(NSRect)frame withTitle:(NSString *)title;
- (instancetype)initThirdWithFrame:(NSRect)frame withTitle:(NSString *)title;
- (instancetype)initForthWithFrame:(NSRect)frame withTitle:(NSString *)title;
- (instancetype)initFifthWithFrame:(NSRect)frame withTitle:(NSString *)title;
- (instancetype)initSixWithFrame:(NSRect)frame withTitle:(NSString *)title;
- (instancetype)initEightWithFrame:(NSRect)frame withTitle:(NSString *)title;
- (instancetype)initNineWithFrame:(NSRect)frame
                         withTitle:(NSString *)title
                      withFontSize:(CGFloat)fontSize
                  withCornerRadius:(CGFloat)cornerRadius;
- (instancetype)initTenWithFrame:(NSRect)frame
                        withTitle:(NSString *)title
                     withFontSize:(CGFloat)fontSize
                   withTitleColor:(NSColor *)titleColor
                 withCornerRadius:(CGFloat)cornerRadius
              withBackgroundColor:(NSColor *)backgroundColor
                       withBorder:(BOOL)isBorder
                  withBorderColor:(NSColor *)borderColor
                  withBorderWidth:(CGFloat)borderWidth;

@property (nonatomic, strong) FrtcMultiTypesButtonCell * btnCell;
@property (nonatomic, assign) PMButtonStyle btnStyle;

@property (nonatomic, getter=isHover) BOOL hover;

@end

NS_ASSUME_NONNULL_END
