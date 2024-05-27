#import <Foundation/Foundation.h>
#import "BaseLayout.h"
#import "MeetingUserInformation.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LocationStrategy) {
    LOCATION_PRESENTER,
    LOCATION_GALLERY
};

@interface BaseLocation : NSObject

@property (nonatomic, assign, getter=isFullScreenView) BOOL fullScreenView;

@property (nonatomic, assign) NSSize currentScreenSize;

@property (nonatomic, assign) NSSize resolutionSize;

@property (nonatomic, assign) NSSize fullScreenSize;

- (CGRect)computeMeetingUserLocationWithUserInfo:(MeetingUserInformation *)userInfo withMeetingNumber:(MeetingLayoutNumber)number withIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
