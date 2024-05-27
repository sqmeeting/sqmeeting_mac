#import "PresenterLocation.h"

@implementation PresenterLocation

extern SDKMeetingLayout sdkMeetingLayoutDescription[MEETING_LAYOUT_NUMBER];

- (CGRect)computeMeetingUserLocationWithUserInfo:(MeetingUserInformation *)userInfo withMeetingNumber:(MeetingLayoutNumber)number withIndex:(NSInteger)index {
    CGRect rect ;
    CGFloat x, y;
    CGFloat width, height;
    rect = CGRectMake(0, 0, 0, 0);
    
    if(self.isFullScreenView && index == 0) {
            x       = (self.currentScreenSize.width - self.fullScreenSize.width) / 2;
            y       = (self.currentScreenSize.height - self.fullScreenSize.height) / 2;
            width   = self.fullScreenSize.width;
            height  = self.fullScreenSize.height;
    } else {
        if(self.isFullScreenView) {
            x      = sdkMeetingLayoutDescription[number].peopleViewDetail[index][0] * self.resolutionSize.width + (self.currentScreenSize.width - self.resolutionSize.width)/2;
            y      = 0;
            width  = sdkMeetingLayoutDescription[number].peopleViewDetail[index][2] * (self.resolutionSize.width);
            height = sdkMeetingLayoutDescription[number].peopleViewDetail[index][3] * (self.resolutionSize.height);
        } else {
            x       = sdkMeetingLayoutDescription[number].peopleViewDetail[index][0] * (self.resolutionSize.width);
            y       = sdkMeetingLayoutDescription[number].peopleViewDetail[index][1] * (self.resolutionSize.height);
            width   = sdkMeetingLayoutDescription[number].peopleViewDetail[index][2] * (self.resolutionSize.width);
            height  = sdkMeetingLayoutDescription[number].peopleViewDetail[index][3] * (self.resolutionSize.height);
        }
    }
    
    rect = CGRectMake(x, y, width, height);
    
   
    return rect;
}

@end
