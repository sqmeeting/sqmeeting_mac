#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UploadLogStatusModel : JSONModel

@property (nonatomic, strong) NSNumber *progress;

@property (nonatomic, strong) NSNumber *bitrate;
@end

NS_ASSUME_NONNULL_END
