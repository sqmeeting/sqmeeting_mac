#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginFailureModel : JSONModel

@property (nonatomic, copy) NSString *error;

@property (nonatomic, copy) NSString *errorCode;

@end

NS_ASSUME_NONNULL_END
