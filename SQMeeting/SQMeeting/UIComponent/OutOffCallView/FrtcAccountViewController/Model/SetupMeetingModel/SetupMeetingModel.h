#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SetupMeetingModel : NSObject

@property (nonatomic, copy) NSString *meetingName;
@property (nonatomic, copy) NSString *meetingNumber;
@property (nonatomic, copy) NSString *meetingPassword;
@property (nonatomic, copy) NSString *meetingType;
@property (nonatomic, copy) NSString *ownerID;
@property (nonatomic, copy) NSString *ownerName;

@end

NS_ASSUME_NONNULL_END
