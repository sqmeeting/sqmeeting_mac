#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FrtcUUID : NSObject

+ (FrtcUUID *)sharedUUID;

- (NSString *)getAplicationUUID;

@end

NS_ASSUME_NONNULL_END
