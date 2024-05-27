#import <Foundation/Foundation.h>
#import "BaseLayout.h"

NS_ASSUME_NONNULL_BEGIN

#define REMOTE_PEOPLE_VIDEO_NUMBER 9

typedef NS_ENUM(NSInteger, MeetingLayoutStrategy) {
    MEETING_LAYOUT_PRESENTER_LAYOUT,
    MEETING_LAYOUT_GALLERY_LAYOUT,
    MEETING_LAYOUT_FULL_SCREEN_GALLERY_LAYOUT
};

@protocol MeetingLayoutContextDelegate

@optional

- (void)updateRemoteUserNumber:(MeetingLayoutNumber)number withUserArray:(NSMutableArray *)userArray;

@end

@interface MeetingLayoutContext : NSObject

+ (MeetingLayoutContext *)shareIstance;

@property (nonatomic, copy) NSMutableArray *participantsList;

@property (nonatomic, assign) MeetingLayoutNumber meetingNumber;

@property (nonatomic, weak) id<MeetingLayoutContextDelegate> delegate;

@property (nonatomic, assign, getter=isGalleryLayout) BOOL galleryLayout;

- (void)updateMeetingUserList:(NSMutableArray *)meetingUserList;

- (void)refreshParticipants;

- (void)switchLayoutByStrategy:(MeetingLayoutStrategy)strategy;

@end

NS_ASSUME_NONNULL_END
