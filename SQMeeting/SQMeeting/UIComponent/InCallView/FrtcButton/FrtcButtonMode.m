#import "FrtcButtonMode.h"

@implementation FrtcButtonMode

+ (FrtcButtonMode *)modelWithTileColor:(NSColor *)titleColor
                        andborderColor:(NSColor *)borderColor
                 andbackgroundacaColor:(NSColor *)backgroudColor
                        andButtonTitle:(NSString *)title
                    andButtonTitleFont:(NSFont *)font {
    FrtcButtonMode* mode = [[FrtcButtonMode alloc] init];
    
    mode.titleColor     = titleColor;
    mode.borderColor    = borderColor;
    mode.backgroudColor = backgroudColor;
    mode.title          = title;
    mode.font           = font;
    
    return mode;
}

@end
