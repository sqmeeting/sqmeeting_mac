#import "GalleryLocation.h"

@implementation GalleryLocation

extern SDKMeetingLayout sdkMeetingLayoutDescription[MEETING_LAYOUT_NUMBER];

- (CGRect)computeMeetingUserLocationWithUserInfo:(MeetingUserInformation *)userInfo withMeetingNumber:(MeetingLayoutNumber)number withIndex:(NSInteger)index {
    CGRect rect ;
    CGFloat x, y;
    CGFloat width, height;
    
    if(self.isFullScreenView && index == 0) {
        x       = sdkMeetingLayoutDescription[number].peopleViewDetail[index][0] * (self.fullScreenSize.width) + (self.currentScreenSize.width - self.fullScreenSize.width)/2;
        y       = sdkMeetingLayoutDescription[number].peopleViewDetail[index][1] * (self.fullScreenSize.height) + (self.currentScreenSize.height - self.fullScreenSize.height) / 2;

        width   = sdkMeetingLayoutDescription[number].peopleViewDetail[index][2] * (self.fullScreenSize.width);
        height  = sdkMeetingLayoutDescription[number].peopleViewDetail[index][3] * (self.fullScreenSize.height);
        
    } else {
        if(self.isFullScreenView) {
            if(userInfo.userType == USER_TYPE_LOCAL) {
                x      = self.currentScreenSize.width -sdkMeetingLayoutDescription[number].peopleViewDetail[index][2] * self.resolutionSize.width;
                y      = 0;
                
                width  = sdkMeetingLayoutDescription[number].peopleViewDetail[index][2] * self.resolutionSize.width;
                height = sdkMeetingLayoutDescription[number].peopleViewDetail[index][3] * (self.resolutionSize.height);
            } else {
                x       = sdkMeetingLayoutDescription[number].peopleViewDetail[index][0] * (self.fullScreenSize.width) + (self.currentScreenSize.width - self.fullScreenSize.width)/2;
                y       = sdkMeetingLayoutDescription[number].peopleViewDetail[index][1] * (self.fullScreenSize.height) + (self.currentScreenSize.height - self.fullScreenSize.height) / 2;
                width   = sdkMeetingLayoutDescription[number].peopleViewDetail[index][2] * (self.fullScreenSize.width);
                height  = sdkMeetingLayoutDescription[number].peopleViewDetail[index][3] * (self.fullScreenSize.height);
            }
        } else {
            x       = sdkMeetingLayoutDescription[number].peopleViewDetail[index][0] * self.resolutionSize.width;
            y       = sdkMeetingLayoutDescription[number].peopleViewDetail[index][1] * self.resolutionSize.height;
            width   = sdkMeetingLayoutDescription[number].peopleViewDetail[index][2] * self.resolutionSize.width;
            height  = sdkMeetingLayoutDescription[number].peopleViewDetail[index][3] * self.resolutionSize.height;
        }
    }
    
    rect = CGRectMake(x, y, width, height);
    
    return rect;
}

@end
