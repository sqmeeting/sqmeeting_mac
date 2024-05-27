#import "GalleryLayout.h"

@implementation GalleryLayout

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
                sdkMeetingLayoutDescription[number] = (SDKMeetingLayout){{{0, 0.085, 1.0, 0.83},
                    {0.8, 0, 0.2, 0.17}}};
                number = MEETING_LAYOUT_NUMBER_2;
                break;
            case MEETING_LAYOUT_NUMBER_2:
                sdkMeetingLayoutDescription[number] = (SDKMeetingLayout){{{0, 0.2925, 0.5, 0.415},
                    {0.5, 0.2925, 0.5, 0.415},
                    {0.8, 0, 0.2, 0.17}} };
                number = MEETING_LAYOUT_NUMBER_3;
                break;
           
            case MEETING_LAYOUT_NUMBER_3:
                sdkMeetingLayoutDescription[number] = (SDKMeetingLayout){{{0.25, 0.085, 0.5, 0.415},
                    {0, 0.5, 0.5, 0.415},
                    {0.5, 0.5, 0.5, 0.415},
                    {0.8, 0, 0.2, 0.17}}};
                number = MEETING_LAYOUT_NUMBER_4;
                break;
            
            case MEETING_LAYOUT_NUMBER_4:
                sdkMeetingLayoutDescription[number] = (SDKMeetingLayout){{{0, 0.085, 0.5, 0.415},
                    {0.5, 0.085, 0.5, 0.415},
                    {0, 0.5, 0.5, 0.415},
                    {0.5, 0.5, 0.5, 0.415},
                    {0.8, 0, 0.2, 0.17}} };
                number = MEETING_LAYOUT_NUMBER_5;
                break;
                
            case MEETING_LAYOUT_NUMBER_5:
                sdkMeetingLayoutDescription[number] = (SDKMeetingLayout){{{0, 0.085, 0.333, 0.2767},
                    {0.333, 0.085, 0.333, 0.2767},
                    {0.666, 0.085, 0.333, 0.2767},
                    {0.0, 0.3617, 0.333, 0.2767},
                    {0.333, 0.3617, 0.333, 0.2767},
                    {0.8, 0, 0.2, 0.17}
                } };
                number = MEETING_LAYOUT_NUMBER_6;
                break;
            case MEETING_LAYOUT_NUMBER_6:
                sdkMeetingLayoutDescription[number] = (SDKMeetingLayout){{{0, 0.085, 0.333, 0.2767},
                    {0.333, 0.085, 0.333, 0.2767},
                    {0.666, 0.085, 0.333, 0.2767},
                    {0.0, 0.3617, 0.333, 0.2767},
                    {0.333, 0.3617, 0.333, 0.2767},
                    {0.666, 0.3617, 0.333, 0.2767},
                    {0.8, 0, 0.2, 0.17}
                } };
                number = MEETING_LAYOUT_NUMBER_7;
                break;
            case MEETING_LAYOUT_NUMBER_7:
                sdkMeetingLayoutDescription[number] = (SDKMeetingLayout){{{0, 0.085, 0.333, 0.2767},
                    {0.333, 0.085, 0.333, 0.2767},
                    {0.666, 0.085, 0.333, 0.2767},
                    {0.0, 0.3617, 0.333, 0.2767},
                    {0.333, 0.3617, 0.333, 0.2767},
                    {0.666, 0.3617, 0.333, 0.2767},
                    {0.0, 0.6384, 0.333, 0.2767},
                    
                    {0.8, 0, 0.2, 0.17}
                } };
                number = MEETING_LAYOUT_NUMBER_8;
                break;
            case MEETING_LAYOUT_NUMBER_8:
                sdkMeetingLayoutDescription[number] = (SDKMeetingLayout){{{0, 0.085, 0.333, 0.2767},
                    {0.333, 0.085, 0.333, 0.2767},
                    {0.666, 0.085, 0.333, 0.2767},
                    {0.0, 0.3617, 0.333, 0.2767},
                    {0.333, 0.3617, 0.333, 0.2767},
                    {0.666, 0.3617, 0.333, 0.2767},
                    {0.0, 0.6384, 0.333, 0.2767},
                    {0.333, 0.6384, 0.333, 0.2767},
                    {0.8, 0, 0.2, 0.17}
                } };
                number = MEETING_LAYOUT_NUMBER_9;
                break;
            case MEETING_LAYOUT_NUMBER_9:
                sdkMeetingLayoutDescription[number] = (SDKMeetingLayout){{{0, 0.085, 0.333, 0.2767},
                    {0.333, 0.085, 0.333, 0.2767},
                    {0.666, 0.085, 0.333, 0.2767},
                    {0.0, 0.3617, 0.333, 0.2767},
                    {0.333, 0.3617, 0.333, 0.2767},
                    {0.666, 0.3617, 0.333, 0.2767},
                    {0.0, 0.6384, 0.333, 0.2767},
                    {0.333, 0.6384, 0.333, 0.2767},
                    {0.666, 0.6384, 0.333, 0.2767},
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
