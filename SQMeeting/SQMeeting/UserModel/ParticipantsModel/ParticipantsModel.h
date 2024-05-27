#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ParticipantsModel : JSONModel

@property (nonatomic, copy) NSString *UUID;

@property (nonatomic, copy) NSString *muteAudio;

@property (nonatomic, copy) NSString<Optional>  *muteVideo;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSNumber *pin;

@property (nonatomic, strong) NSNumber *lecture;

@end

NS_ASSUME_NONNULL_END
