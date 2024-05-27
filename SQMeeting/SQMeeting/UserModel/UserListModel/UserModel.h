#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol UserModel;
@interface UserModel : JSONModel

//@property (nonatomic, copy) NSString *first_name;
//@property (nonatomic, copy) NSString *last_name;、
@property (nonatomic, copy) NSString *real_name;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *username;
@end

NS_ASSUME_NONNULL_END
