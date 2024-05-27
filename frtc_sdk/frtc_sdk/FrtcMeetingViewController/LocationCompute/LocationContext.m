#import "LocationContext.h"
#import "PresenterLocation.h"
#import "GalleryLocation.h"

@implementation LocationContext

- (CGRect)computeUserLocationWithLayout:(LocationStrategy)strategy withUserInfo:(MeetingUserInformation *)userInfo withMeetingNumber:(MeetingLayoutNumber)number withIndex:(NSInteger)index {
    if(strategy == LOCATION_PRESENTER) {
        self.location = [[PresenterLocation alloc] init];
    } else if(strategy == LOCATION_GALLERY) {
        self.location = [[GalleryLocation alloc] init];
    }
    
    self.location.fullScreenView    = self.isFullScreenView;
    self.location.currentScreenSize = self.currentScreenSize;
    self.location.resolutionSize    = self.resolutionSize;
    self.location.fullScreenSize    = self.fullScreenSize;

    CGRect rect = CGRectMake(0, 0, 0, 0);

    if(userInfo.userType == USER_TYPE_LOCAL) {
        if(self.layoutUserCount == 1) {
            if(self.isReadySharingContent) {
                rect = CGRectMake(0, 0, BASE_WIDTH * self.scacleProportion, BASE_HEIGHT * self.scacleProportion);
            } else {
                if(self.isFullScreenView) {
                    rect = CGRectMake((self.currentScreenSize.width - self.fullScreenSize.width) / 2, (self.currentScreenSize.height - self.fullScreenSize.height) / 2, self.fullScreenSize.width, self.fullScreenSize.height);
                } else {
                    rect = CGRectMake(0, self.resolutionSize.height / 12, self.resolutionSize.width, self.resolutionSize.height * 0.8);
                }
            }
        } else {
            rect = [self.location computeMeetingUserLocationWithUserInfo:userInfo withMeetingNumber:number withIndex:index];
        }
    } else if(userInfo.userType == USER_TYPE_REMOTE) {
        if(self.isReadySharingContent) {
            rect = CGRectMake(0, 0, BASE_WIDTH * self.scacleProportion, BASE_HEIGHT * self.scacleProportion);
        } else {
            rect = [self.location computeMeetingUserLocationWithUserInfo:userInfo withMeetingNumber:number withIndex:index];
        }
    } else {
        rect = [self.location computeMeetingUserLocationWithUserInfo:userInfo withMeetingNumber:number withIndex:index];
    }
    
    return rect;
}
@end
