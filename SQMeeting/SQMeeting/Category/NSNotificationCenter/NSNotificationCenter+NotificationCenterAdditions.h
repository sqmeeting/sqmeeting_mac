#import <Foundation/Foundation.h>

@interface NSNotificationCenter (NotificationCenterAdditions)

- (void)postNotificationNameOnMainThread:(NSString *)aName object:(id)anObject;
- (void)postNotificationNameOnMainThread:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;

@end
