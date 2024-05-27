#import "FrtcUserDefault.h"

static FrtcUserDefault *userDefaultSingleton = nil;

@implementation FrtcUserDefault

+ (FrtcUserDefault *)defaultSingleton {
    if (userDefaultSingleton == nil) {
        @synchronized(self) {
            if (userDefaultSingleton == nil) {
                userDefaultSingleton = [[FrtcUserDefault alloc] init];
            }
        }
    }
    
    return userDefaultSingleton;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:@YES, INTELLIGENG_NOISE_REDUCTION, @YES, ENABLE_CAMREA_MIRROR ,@NO, CALL_MEETING_MICPHONE_ON_OFF, @NO, CALL_MEETING_CAMERA_ON_OFF , @YES, ENABLE_STREAM_PASSWORD, @YES, ENABLE_LAB_FEATURE,@"", STORAGE_SERVER_ADDRESS, @YES, NEW_FEATURE, nil]];
    }
    return self;
}

- (void)setObject:(NSString *)object forKey:(NSString *)objectKey {
    NSString *path = NSHomeDirectory();
    NSLog(@"path : %@", path);

    NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
    [userDefault setObject:object forKey:objectKey];
    [userDefault synchronize];
}

- (NSString *)objectForKey:(NSString *)defaultKey {
    NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
    NSString *value = [userDefault objectForKey:defaultKey];

    if(value == nil) {
        value = @"";
    }
    
    return value;
}

- (void)setBoolObject:(BOOL)object forKey:(NSString *)objectKey {
    NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
    [userDefault setBool:object forKey:objectKey];
    [userDefault synchronize];
}

- (BOOL)boolObjectForKey:(NSString *)defaultKey {
    NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
    BOOL value = [userDefault boolForKey:defaultKey];
    
    return value;
}

@end
