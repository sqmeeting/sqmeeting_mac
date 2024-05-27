#import "FrtcUUID.h"

static FrtcUUID *applicationUUID = nil;

@implementation FrtcUUID

+ (FrtcUUID *)sharedUUID {
    @synchronized(self) {
        if (applicationUUID == nil) {
            applicationUUID = [[FrtcUUID alloc] init];
        }
    }
    
    return applicationUUID;
}

- (NSString *)getAplicationUUID {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [userDefaults objectForKey:@"UUID"];
    
    if(uuid == nil) {
        uuid = [[NSUUID UUID] UUIDString];
        [userDefaults setObject:uuid forKey:@"UUID"];
        [userDefaults synchronize];
    }
 
    return [uuid lowercaseString];
}

@end
