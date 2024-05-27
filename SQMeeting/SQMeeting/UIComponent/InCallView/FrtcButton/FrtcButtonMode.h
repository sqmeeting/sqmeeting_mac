#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FrtcButtonMode : NSObject

+ (FrtcButtonMode *)modelWithTileColor:(NSColor *)titleColor
                        andborderColor:(NSColor *)borderColor
                 andbackgroundacaColor:(NSColor *)backgroudColor
                        andButtonTitle:(NSString *)title
                    andButtonTitleFont:(NSFont *)font;

@property (nonatomic, strong) NSColor *titleColor;

@property (nonatomic, strong) NSColor *borderColor;

@property (nonatomic, strong) NSColor *backgroudColor;

@property (nonatomic, copy)   NSString *title;

@property (nonatomic, strong) NSFont  *font;

@end

NS_ASSUME_NONNULL_END
