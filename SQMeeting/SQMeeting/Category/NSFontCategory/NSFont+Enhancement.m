#import "NSFont+Enhancement.h"

@implementation NSFont (Enhancement)

+ (NSFont *)fontWithSFProDisplay:(CGFloat)size andType:(SFProDisplay)type {
    if (type == SFProDisplayLight) {
        return [NSFont fontWithName:@".SFNSText-Light" size:size];
    } else if (type == SFProDisplayRegular) {
        return [NSFont fontWithName:@".SFNSText-Regular" size:size];
    } else if (type == SFProDisplayMedium) {
        return [NSFont fontWithName:@".SFNSText-Medium" size:size];
    } else if (type == SFProDisplayBold) {
        return [NSFont fontWithName:@".SFNSText-Bold" size:size];
    } else if (type == SFProDisplaySemibold) {
        return [NSFont fontWithName:@".SFNSText-Semibold" size:size];
    } else {
        return [NSFont fontWithName:@"ArialMT" size:size];
    }
}

@end
