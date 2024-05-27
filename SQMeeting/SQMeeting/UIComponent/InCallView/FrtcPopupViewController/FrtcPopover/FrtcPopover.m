#import "FrtcPopover.h"

@interface FrtcPopover ()

@property (nonatomic, assign) NSInteger type;

@end

@implementation FrtcPopover

- (instancetype)init {
    self = [super init];
    
    if(self) {
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(onDeviceListChaned:) name:FMeetingDeviceListChangedNotification object:nil];
    }
    
    return self;
}

-(instancetype)initWithPopoverType:(NSInteger)type {
    self = [super init];
    
    if(self) {
        self.type = type;
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(onDeviceListChaned:) name:FMeetingDeviceListChangedNotification object:nil];
    }
    
    return self;
}

- (void)dealloc {

}

- (void)onDeviceListChaned:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSDictionary *inUseDev = [userInfo valueForKey:FMeetingDeviceListInUseKey];
    NSString *inuseCamera = [inUseDev valueForKey:@"camera"];
    NSString *inuseMic = [inUseDev valueForKey:@"micphone"];
    NSString *inuseSpk = [inUseDev valueForKey:@"speaker"];
    
    NSString *defaultMicName = [inUseDev valueForKey:@"defaultMicName"];
    NSString *defaultSpeakerName = [inUseDev valueForKey:@"defaultSpeakerName"];
    
    [[FrtcUserDefault defaultSingleton] setObject:inuseCamera forKey:DEFAULT_CAMERA];
//    [[FrtcUserDefault defaultSingleton] setObject:inuseMic forKey:DEFAULT_MICROPHONE];
//    [[FrtcUserDefault defaultSingleton] setObject:inuseSpk forKey:DEFAULT_SPEAKER];
    
    [[FrtcUserDefault defaultSingleton] setObject:defaultMicName forKey:DEFAULT_MICROPHONE];
    [[FrtcUserDefault defaultSingleton] setObject:defaultSpeakerName forKey:DEFAULT_SPEAKER];
    
   // [self getDeviceList];
    
    NSInteger height;
    if(self.type == 1) {
        NSMutableArray* camList = [[NSMutableArray alloc] init];
        [[FrtcCall sharedFrtcCall] frtcCameraList:camList];
     
        height = 24 * ([camList count] + 1) + 5;
    } else {
        NSMutableArray* micList = [[NSMutableArray alloc] init];
        [[FrtcCall sharedFrtcCall] frtcMicphoneList:micList];

        NSMutableDictionary<NSString *, NSString *> *micDictionary = [NSMutableDictionary dictionary];
        for(NSDictionary *dic in micList) {
            NSString *devName = [dic valueForKey:@"name"];
            [micDictionary setObject:devName forKey:devName];
            
        }
        NSArray<NSString *> *micNameArray = [micDictionary allValues];
        
        
        NSMutableArray* getSpeakerArray = [[NSMutableArray alloc] init];
        [[FrtcCall sharedFrtcCall] frtcSpeakerList:getSpeakerArray];
        
        NSMutableDictionary<NSString *, NSString *> *speakerDictionary = [NSMutableDictionary dictionary];
        for(NSDictionary *dic in getSpeakerArray) {
            NSString *devName = [dic valueForKey:@"name"];
            [speakerDictionary setObject:devName forKey:devName];
        }
        
        NSArray<NSString *> *speakerNameArray = [speakerDictionary allValues];
        
        height = 24 * ([micNameArray count] + 1) + 5 + 24 * ([speakerNameArray count] + 1) + 5 ;
    }
    
    self.contentSize = NSMakeSize(166, height);
}
@end
