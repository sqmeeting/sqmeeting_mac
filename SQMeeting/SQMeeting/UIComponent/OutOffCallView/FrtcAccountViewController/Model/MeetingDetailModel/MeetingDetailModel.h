#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeetingDetailModel : NSObject <NSCoding,NSSecureCoding>

@property (nonatomic, copy) NSString *meetingNumber;
@property (nonatomic, copy) NSString *meetingStartTime;
@property (nonatomic, copy) NSString *meetingEndTime;
@property (nonatomic, copy) NSString *meetingName;
@property (nonatomic, copy) NSString *meetingDuration;
@property (nonatomic, copy) NSString *meetingPassword;
@property (nonatomic, copy) NSString *meetingType;
@property (nonatomic, copy) NSString *ownerName;

@end

NS_ASSUME_NONNULL_END
