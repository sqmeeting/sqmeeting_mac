#import <Foundation/Foundation.h>

#define PEOPLE_VIDEO_AND_CONTENT_NUMBER 11

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MeetingLayoutNumber) {
    MEETING_LAYOUT_NUMBER_1,
    MEETING_LAYOUT_NUMBER_2,
    MEETING_LAYOUT_NUMBER_3,
    MEETING_LAYOUT_NUMBER_4,
    MEETING_LAYOUT_NUMBER_5,
    MEETING_LAYOUT_NUMBER_6,
    MEETING_LAYOUT_NUMBER_7,
    MEETING_LAYOUT_NUMBER_8,
    MEETING_LAYOUT_NUMBER_9,
    MEETING_LAYOUT_NUMBER
};

typedef struct MeetingLayoutDescription {
    float peopleViewDetail[PEOPLE_VIDEO_AND_CONTENT_NUMBER][4];
} SDKMeetingLayout;


@interface BaseLayout : NSObject

- (void)layoutStrategy;

@end

NS_ASSUME_NONNULL_END
