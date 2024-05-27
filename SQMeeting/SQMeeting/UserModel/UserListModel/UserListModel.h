#import "JSONModel.h"
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserListModel : JSONModel

@property (nonatomic, copy) NSArray<UserModel > *users;
@property (nonatomic, strong) NSNumber *total_page_num;
@property (nonatomic, strong) NSNumber *total_size;

@end

NS_ASSUME_NONNULL_END
