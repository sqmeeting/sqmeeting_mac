#import <Foundation/Foundation.h>
#import "BaseLocation.h"

NS_ASSUME_NONNULL_BEGIN

#define    BASE_WIDTH        320
#define    BASE_HEIGHT       180

@interface LocationContext : NSObject

@property (nonatomic, assign, getter=isFullScreenView) BOOL fullScreenView;

@property (nonatomic, assign) NSSize currentScreenSize;

@property (nonatomic, assign) NSSize resolutionSize;

@property (nonatomic, assign) NSSize fullScreenSize;

@property (nonatomic, strong) BaseLocation *location;

@property (nonatomic, assign) CGFloat scacleProportion;

@property (nonatomic, assign) NSUInteger layoutUserCount;

@property (nonatomic, assign, getter=isReadySharingContent) BOOL readySharingContent;

- (CGRect)computeUserLocationWithLayout:(LocationStrategy)strategy withUserInfo:(MeetingUserInformation *)userInfo withMeetingNumber:(MeetingLayoutNumber)number withIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
