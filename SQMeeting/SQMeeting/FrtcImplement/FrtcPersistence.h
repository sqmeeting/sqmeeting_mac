#import <Foundation/Foundation.h>
#import "MeetingDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FrtcPersistence : NSObject

+ (FrtcPersistence *)sharedUserPersistence;

- (BOOL)saveMeeting:(MeetingDetailModel *)model;

- (NSArray <MeetingDetailModel *> *)getMeetingList;

- (void)deleteCurrentUserHistoryMeeting;

- (BOOL)deleteHistoryMeetingWithMeetingStartTime:(NSString *)meetingStartTime;

@end

NS_ASSUME_NONNULL_END
