#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define SKD_SERVER_ADDRESS @"skdServerAddress"
#define SKD_LOGIN_VALUE    @"skdLoginValue"
#define SKD_IF_URL_CALL    @"skdifurlcall"
#define SKD_URL_VALUE      @"skdurlvalue"

@interface SDKUserDefault : NSObject

+ (SDKUserDefault *)sharedSDKUserDefault;

- (void)setSDKObject:(NSString *)object forKey:(NSString *)objectKey;

- (NSString *)sdkObjectForKey:(NSString *)defaultKey;

- (void)setSDKBoolObject:(BOOL)object forKey:(NSString *)objectKey;

- (BOOL)sdkBoolObjectForKey:(NSString *)defaultKey;

@end

NS_ASSUME_NONNULL_END
