#import "FrtcTabControlSelectMode.h"

@implementation FrtcTabControlSelectMode

+ (FrtcTabControlSelectMode *)modelWithSelectedTitleColor:(NSColor *)selectedColor
                                 andDisSelectedTitleColor:(NSColor *)disSelectedColor
                                     andSelectedTitleFont:(NSFont *)selectTitleFont
                                   andUnSelectedTitleFont:(NSFont *)unSelectTitleFont{
    FrtcTabControlSelectMode    *model = [[FrtcTabControlSelectMode alloc] init];
    
    model.selectedColor     = selectedColor;
    model.disSelectedColor  = disSelectedColor;
    model.selectTitleFont   = selectTitleFont;
    model.unSelectTitleFont = unSelectTitleFont;
    
    return model;
}

@end
