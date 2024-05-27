#import "FrtcMeetingStatusMachineTransition.h"

@implementation FrtcMeetingStatusMachineTransition

- (id)initWithCurrentCallState:(FRTCMeetingStatus)currentStatus
                  newCallState:(FRTCMeetingStatus)newstatus
                     andAction:(SDKCallStateAction)selectorAction {
    self = [super init];
    
    if (self) {
        self.currentStatus      = currentStatus;
        self.newMeetingStatus   = newstatus;
        self.action             = selectorAction;
    }
    
    return self;
}

@end
