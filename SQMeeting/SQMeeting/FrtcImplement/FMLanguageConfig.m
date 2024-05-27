static NSString *const FMUserLanguageKey = @"FMUserLanguageKey";

#import "FMLanguageConfig.h"

@implementation FMLanguageConfig

+ (void)setUserLanguage:(NSString *)userLanguage {
    [[NSUserDefaults standardUserDefaults] setValue:userLanguage forKey:FMUserLanguageKey];
    [[NSUserDefaults standardUserDefaults] setValue:@[userLanguage] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)userLanguage {
    return [[NSUserDefaults standardUserDefaults] valueForKey:FMUserLanguageKey];
}

@end
