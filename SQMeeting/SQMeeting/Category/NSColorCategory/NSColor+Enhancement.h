#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSColor (Enhancement)

+ (NSColor*)colorWithString:(NSString*)string andAlpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
