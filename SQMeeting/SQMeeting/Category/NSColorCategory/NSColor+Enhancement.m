#import "NSColor+Enhancement.h"

@implementation NSColor (Enhancement)

+ (NSColor *)colorWithString:(NSString *)string andAlpha:(CGFloat)alpha {
    //remove whitespace from string
    NSString* cString = [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    //string should be 6 or 8 characters
    if (cString.length < 6) {
        return [NSColor clearColor];
    }
    //strip 0X if it appers
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    //strip # if it appers
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if (cString.length != 6) {
        return [NSColor clearColor];
    }
    //seperate into r,g,b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString* rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString* gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString* bString = [cString substringWithRange:range];
    
    unsigned int r,g,b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [NSColor colorWithRed:((CGFloat)r / 255.0f) green:((CGFloat)g / 255.0f) blue:((CGFloat)b / 255.0f) alpha:alpha];
}

@end
