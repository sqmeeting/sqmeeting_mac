#import "NSBundle+FMLanguage.h"
#import "FMLanguageConfig.h"
#import <objc/runtime.h>

@implementation NSBundle (FMLanguage)

+ (void)load {
    Method ori = class_getInstanceMethod(self, @selector(localizedStringForKey:value:table:));
    Method cur = class_getInstanceMethod(self, @selector(f_localizedStringForKey:value:table:));
    method_exchangeImplementations(ori, cur);
}

- (NSString *)f_localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName {
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSBundle currentLanguage] ofType:@"lproj"];
    if (path.length > 0) {
        NSBundle *bundle = [NSBundle bundleWithPath:path];
        return [bundle f_localizedStringForKey:key value:value table:tableName];
    }
    return [self f_localizedStringForKey:key value:value table:tableName];
}

+ (NSString *)currentLanguage {
    return [FMLanguageConfig userLanguage] ? : [NSLocale preferredLanguages].firstObject;
}

+ (NSString *)currentLanguageDes {
    NSString *language = [self currentLanguage];
    
    if ([language hasPrefix:@"en"]) {
        return @"English";
    } else if ([language hasPrefix:@"zh-Hans"]) {
        return @"简体中文";
    } else if ([language hasPrefix:@"zh-HK"] || [language hasPrefix:@"zh-Hant"]) {
        return @"繁體中文";
    }
    
    return @"";
}

@end
