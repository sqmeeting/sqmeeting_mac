#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserDetailModel : JSONModel

@property (nonatomic, copy) NSString *reservation_id;
@property (nonatomic, copy) NSString *meeting_type;
@property (nonatomic, copy) NSString *meeting_name;
@property (nonatomic, copy) NSString *call_rate_type;
@property (nonatomic, copy) NSString<Optional> *recurrence_gid;
@property (nonatomic, copy) NSString *schedule_start_time;
@property (nonatomic, copy) NSString *schedule_end_time;
@property (nonatomic, copy) NSString *recurrence_type;
@property (nonatomic, copy) NSString<Optional> *meeting_room_id;
@property (nonatomic, copy) NSString<Optional> *meeting_password;
@property (nonatomic, copy) NSArray<Optional> *invited_users_details;
@property (nonatomic, copy) NSString *mute_upon_entry;
@property (nonatomic, copy) NSNumber *guest_dial_in;
@property (nonatomic, copy) NSNumber *watermark;
@property (nonatomic, copy) NSString *watermark_type;
@property (nonatomic, copy) NSString *owner_id;
@property (nonatomic, copy) NSString *owner_name;
@property (nonatomic, copy) NSString<Optional> *qrcode_string;
@property (nonatomic, copy) NSString<Optional> *meeting_description;

@end

NS_ASSUME_NONNULL_END
