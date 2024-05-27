#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PersonalMeetingModel;
@interface PersonalMeetingModel : JSONModel

@property (nonatomic, copy) NSString *meeting_number;
@property (nonatomic, copy) NSString *meetingroom_name;
@property (nonatomic, copy) NSString *meeting_room_id;
@property (nonatomic, copy) NSString<Optional>  *meeting_password;
@property (nonatomic, copy) NSString *owner_id;
@property (nonatomic, copy) NSString *owner_name;
@property (nonatomic, copy) NSString *creator_id;
@property (nonatomic, copy) NSString *creator_name;
@property (nonatomic, copy) NSString *created_time;

@end

NS_ASSUME_NONNULL_END
