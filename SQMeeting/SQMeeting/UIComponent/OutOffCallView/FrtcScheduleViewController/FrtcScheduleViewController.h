#import <Cocoa/Cocoa.h>
#import "MeetingRooms.h"

NS_ASSUME_NONNULL_BEGIN


@interface FrtcScheduleViewController : NSViewController

@property (nonatomic, assign, getter=isEnablePersonalMeetingNumber) BOOL enablePersonalMeetingNumber;
@property (nonatomic, strong) MeetingRooms *meetingRooms;

@property (nonatomic, assign, getter=isPersonalNumber) BOOL personalNumber;
@property (nonatomic, copy) NSString *personaConferencelNumber;
@property (nonatomic, copy) NSString *personalConferencePassword;

@end

NS_ASSUME_NONNULL_END
