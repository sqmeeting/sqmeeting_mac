#import "PresenterLayout.h"

@implementation PresenterLayout

- (instancetype)init {
    self = [super init];
    
    if(self) {
        [self layoutStrategy];
    }
    
    return self;
}

- (void)layoutStrategy {
    extern SDKMeetingLayout sdkMeetingLayoutDescription[MEETING_LAYOUT_NUMBER];
    
    for (MeetingLayoutNumber number = MEETING_LAYOUT_NUMBER_1; number < MEETING_LAYOUT_NUMBER;) {
        switch (number) {
            case MEETING_LAYOUT_NUMBER_1:
                sdkMeetingLayoutDescription[number] = (SDKMeetingLayout){{{0, 0.17, 1.0, 0.83},
                    {0.4, 0, 0.2, 0.17}}};
                number = MEETING_LAYOUT_NUMBER_2;
                break;
                
            case MEETING_LAYOUT_NUMBER_2:
                sdkMeetingLayoutDescription[number]  = (SDKMeetingLayout){{{0, 0.17, 1.0, 0.83},
                    {0.3, 0, 0.2, 0.17},
                    {0.5, 0, 0.2, 0.17}} };
                number = MEETING_LAYOUT_NUMBER_3;
                break;
           
            case MEETING_LAYOUT_NUMBER_3:
                sdkMeetingLayoutDescription[number] = (SDKMeetingLayout){{{0, 0.17, 1.0, 0.83},
                    {0.2, 0, 0.2, 0.17},
                    {0.4, 0, 0.2, 0.17},
                    {0.6, 0, 0.2, 0.17}}};
                number = MEETING_LAYOUT_NUMBER_4;
                break;
            
            case MEETING_LAYOUT_NUMBER_4:
                sdkMeetingLayoutDescription[number] = (SDKMeetingLayout){{{0, 0.17, 1.0, 0.83},
                    {0.1, 0, 0.2, 0.17},
                    {0.3, 0, 0.2, 0.17},
                    {0.5, 0, 0.2, 0.17},
                    {0.7, 0, 0.2, 0.17}} };
                number = MEETING_LAYOUT_NUMBER_5;
                break;
                
            case MEETING_LAYOUT_NUMBER_5:
                sdkMeetingLayoutDescription[number] = (SDKMeetingLayout){{{0, 0.17, 1.0, 0.83},
                    {0.0, 0, 0.2, 0.17},
                    {0.2, 0, 0.2, 0.17},
                    {0.4, 0, 0.2, 0.17},
                    {0.6, 0, 0.2, 0.17},
                    {0.8, 0, 0.2, 0.17}
                } };
                number = MEETING_LAYOUT_NUMBER;
                break;
            
       
            default:
                break;
        }
    }
}

@end
