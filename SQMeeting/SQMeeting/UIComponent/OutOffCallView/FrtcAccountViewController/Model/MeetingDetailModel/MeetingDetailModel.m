#import "MeetingDetailModel.h"

@implementation MeetingDetailModel

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.meetingNumber forKey:@"meetingNumber"];
    [aCoder encodeObject:self.meetingStartTime forKey:@"meetingStartTime"];
    [aCoder encodeObject:self.meetingEndTime forKey:@"meetingEndTime"];
    [aCoder encodeObject:self.meetingName forKey:@"meetingName"];
    [aCoder encodeObject:self.meetingDuration forKey:@"meetingDuration"];
    [aCoder encodeObject:self.meetingPassword forKey:@"meetingPassword"];
    [aCoder encodeObject:self.ownerName forKey:@"ownerName"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]) {
        self.meetingNumber      = [aDecoder decodeObjectForKey:@"meetingNumber"];
        self.meetingStartTime   = [aDecoder decodeObjectForKey:@"meetingStartTime"];
        self.meetingEndTime     = [aDecoder decodeObjectForKey:@"meetingEndTime"];
        self.meetingName        = [aDecoder decodeObjectForKey:@"meetingName"];
        self.meetingDuration    = [aDecoder decodeObjectForKey:@"meetingDuration"];
        self.meetingPassword    = [aDecoder decodeObjectForKey:@"meetingPassword"];
        self.ownerName          = [aDecoder decodeObjectForKey:@"ownerName"];
    }
    
    return self;
}


@end
