#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FrtcMeetingStreamingModel : NSObject

@property (nonatomic, copy) NSString *conferenceName;

@property (nonatomic, copy) NSString *clientName;

@property (nonatomic, copy) NSString *streamingUrl;

@property (nonatomic, copy) NSString *streamingPassword;

@end

NS_ASSUME_NONNULL_END
