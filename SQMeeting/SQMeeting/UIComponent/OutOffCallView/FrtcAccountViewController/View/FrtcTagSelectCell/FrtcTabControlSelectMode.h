#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FrtcTabControlSelectMode : NSObject

+ (FrtcTabControlSelectMode *)modelWithSelectedTitleColor:(NSColor *)selectedColor
                                 andDisSelectedTitleColor:(NSColor *)disSelectedColor
                                     andSelectedTitleFont:(NSFont *)selectTitleFont
                                   andUnSelectedTitleFont:(NSFont *)unSelectTitleFont;

@property (nonatomic, strong) NSColor *selectedColor;

@property (nonatomic, strong) NSColor *disSelectedColor;

@property (nonatomic, strong) NSFont  *selectTitleFont;

@property (nonatomic, strong) NSFont  *unSelectTitleFont;

@end

NS_ASSUME_NONNULL_END
