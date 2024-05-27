#import <Cocoa/Cocoa.h>

@interface NSColor (Utils)

//iOS
//+ (UIColor *)colorWithString:(NSString *)string;

//macOS
+ (NSColor*)colorWithRGBString:(NSString *)string withAlpha:(CGFloat)alpha;
+ (NSColor *)colorWithRGBAString:(NSString *)string;

@end
