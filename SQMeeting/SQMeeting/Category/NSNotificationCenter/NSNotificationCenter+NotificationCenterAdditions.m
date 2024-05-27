#import "NSNotificationCenter+NotificationCenterAdditions.h"
#include <pthread.h>

@implementation NSNotificationCenter (NotificationCenterAdditions)

#pragma mark - private method

+ (void)doPostNotification:(NSDictionary *)info {
    NSString* aName = info[@"name"];
    id anObject = info[@"object"];
    NSDictionary* aUserInfo = info[@"userInfo"];
    [[NSNotificationCenter defaultCenter] postNotificationName:aName object:anObject userInfo:aUserInfo];
}

#pragma mark - public method

- (void)postNotificationNameOnMainThread:(NSString *)aName object:(id)anObject {
    [self postNotificationNameOnMainThread:aName object:anObject userInfo:nil];
}

- (void)postNotificationNameOnMainThread:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo {
    if (pthread_main_np()) {
        return [self postNotificationName:aName object:anObject userInfo:aUserInfo];
    }
    
    NSMutableDictionary* info = [[NSMutableDictionary alloc] init];
    if (aName != nil) {
        info[@"name"] = aName;
    }
    
    if (anObject != nil) {
        info[@"object"] = anObject;
    }
    
    if (aUserInfo != nil) {
        info[@"userInfo"] = aUserInfo;
    }
    
    [[self class] performSelectorOnMainThread:@selector(doPostNotification:) withObject:info waitUntilDone:NO];
}

@end
