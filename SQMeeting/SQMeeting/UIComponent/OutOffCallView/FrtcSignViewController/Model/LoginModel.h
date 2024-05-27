#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginModel : NSObject

@property (nonatomic, copy) NSString *department;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *firstname;

@property (nonatomic, copy) NSString *lastname;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSArray<NSString *> *role;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *user_token;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *realName;

@property (nonatomic, copy) NSString *passwordExpiredTime;

@property (nonatomic, copy) NSString *securityLevel;

@end

NS_ASSUME_NONNULL_END
