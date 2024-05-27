#import "IntegerFormatter.h"

@implementation IntegerFormatter

- (BOOL)isPartialStringValid:(NSString *)partialString newEditingString:(NSString **)newString errorDescription:(NSString **)error {
    if([partialString length] == 0) {
        return YES;
    }

    NSScanner* scanner = [NSScanner scannerWithString:partialString];

    if(!([scanner scanInt:0] && [scanner isAtEnd])) {
        return NO;
    }

    return YES;
}


@end
