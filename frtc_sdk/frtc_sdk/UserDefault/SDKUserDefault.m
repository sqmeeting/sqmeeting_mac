#import "SDKUserDefault.h"

static SDKUserDefault *sharedSDKUserDefault = nil;

@implementation SDKUserDefault

+ (SDKUserDefault *)sharedSDKUserDefault {
    if (sharedSDKUserDefault == nil) {
        @synchronized(self) {
            if (sharedSDKUserDefault == nil) {
                sharedSDKUserDefault = [[SDKUserDefault alloc] init];
            }
        }
    }
    
    return sharedSDKUserDefault;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:@NO, SKD_IF_URL_CALL, nil]];
    }
    return self;
}

- (void)setSDKObject:(NSString *)object forKey:(NSString *)objectKey {
    NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
    [userDefault setObject:object forKey:objectKey];
    [userDefault synchronize];
}

- (NSString *)sdkObjectForKey:(NSString *)defaultKey {
    NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
    NSString *value = [userDefault objectForKey:defaultKey];
    
    return value;
}

- (void)setSDKBoolObject:(BOOL)object forKey:(NSString *)objectKey {
    NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
    [userDefault setBool:object forKey:objectKey];
    [userDefault synchronize];
}

- (BOOL)sdkBoolObjectForKey:(NSString *)defaultKey {
    NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
    BOOL value = [userDefault boolForKey:defaultKey];
    
    return value;
}

@end
