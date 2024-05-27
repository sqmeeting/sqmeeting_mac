#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FrtcSDKBundle : NSObject

+ (NSString *)bundlePath:(NSString *)path;

+ (NSBundle *)bundle;

@end

NS_ASSUME_NONNULL_END
