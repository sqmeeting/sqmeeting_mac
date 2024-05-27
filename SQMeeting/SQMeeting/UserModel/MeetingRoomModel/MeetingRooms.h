#import "JSONModel.h"
#import "PersonalMeetingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MeetingRooms : JSONModel

@property (nonatomic, copy) NSArray<PersonalMeetingModel > *meeting_rooms;

@end

NS_ASSUME_NONNULL_END
