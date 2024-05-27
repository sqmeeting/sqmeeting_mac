#import "NSColor+Utils.h"

@implementation NSColor (Utils)

//iOS
/*
+ (UIColor *) colorWithString:(NSString *)string {
    
    if ([string isKindOfClass:[NSString class]]) {
        
        string = [string stringByReplacingOccurrencesOfString:@"'" withString:@""];
        if ([string hasPrefix:@"#"]) {
            
            const char *s = [string cStringUsingEncoding:NSASCIIStringEncoding];
            if (*s == '#') {
                ++s;
            }
            
            unsigned long long value = strtoll(s, nil, 16);
            int r, g, b, a;
            switch (strlen(s)) {
                case 2:
                    // xx
                    r = g = b = (int)value;
                    a = 255;
                    break;
                case 3:
                    // RGB
                    r = ((value & 0xf00) >> 8);
                    g = ((value & 0x0f0) >> 4);
                    b = ((value & 0x00f) >> 0);
                    r = r * 16 + r;
                    g = g * 16 + g;
                    b = b * 16 + b;
                    a = 255;
                    break;
                case 6:
                    // RRGGBB
                    r = (value & 0xff0000) >> 16;
                    g = (value & 0x00ff00) >>  8;
                    b = (value & 0x0000ff) >>  0;
                    a = 255;
                    break;
                default:
                    // RRGGBBAA
                    r = (value & 0xff000000) >> 24;
                    g = (value & 0x00ff0000) >> 16;
                    b = (value & 0x0000ff00) >>  8;
                    a = (value & 0x000000ff) >>  0;
                    break;
            }
            return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/255.0f];
        } else {
            string = [string stringByAppendingString:@"Color"];
            SEL colorSel = NSSelectorFromString(string);
            if ([UIColor respondsToSelector:colorSel]) {
                return [UIColor performSelector:colorSel];
            }
            return nil;
        }
    } else if ([string isKindOfClass:[UIColor class]]) {
        return (UIColor *)string;
    }
    return nil;
}
*/

//macOS
+ (NSColor*)colorWithRGBString:(NSString *)string withAlpha:(CGFloat)alpha {
    
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

+ (NSColor *)colorWithRGBAString:(NSString *)string {
    
    if ([string isKindOfClass:[NSString class]]) {
        
        string = [string stringByReplacingOccurrencesOfString:@"'" withString:@""];
        if ([string hasPrefix:@"#"]) {
            
            const char *s = [string cStringUsingEncoding:NSASCIIStringEncoding];
            if (*s == '#') {
                ++s;
            }
            
            unsigned long long value = strtoll(s, nil, 16);
            int r, g, b, a;
            switch (strlen(s)) {
                case 2:
                    // xx
                    r = g = b = (int)value;
                    a = 255;
                    break;
                case 3:
                    // RGB
                    r = ((value & 0xf00) >> 8);
                    g = ((value & 0x0f0) >> 4);
                    b = ((value & 0x00f) >> 0);
                    r = r * 16 + r;
                    g = g * 16 + g;
                    b = b * 16 + b;
                    a = 255;
                    break;
                case 6:
                    // RRGGBB
                    r = (value & 0xff0000) >> 16;
                    g = (value & 0x00ff00) >>  8;
                    b = (value & 0x0000ff) >>  0;
                    a = 255;
                    break;
                default:
                    // RRGGBBAA
                    r = (value & 0xff000000) >> 24;
                    g = (value & 0x00ff0000) >> 16;
                    b = (value & 0x0000ff00) >>  8;
                    a = (value & 0x000000ff) >>  0;
                    break;
            }
            return [NSColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/255.0f];
        } else {
            string = [string stringByAppendingString:@"Color"];
            SEL colorSel = NSSelectorFromString(string);
            if ([NSColor respondsToSelector:colorSel]) {
                return [NSColor performSelector:colorSel];
            }
            return nil;
        }
    } else if ([string isKindOfClass:[NSColor class]]) {
        return (NSColor *)string;
    }
    return nil;
}

@end
