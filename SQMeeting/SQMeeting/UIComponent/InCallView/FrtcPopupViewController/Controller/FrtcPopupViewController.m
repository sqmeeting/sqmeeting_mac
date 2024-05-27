#import "FrtcPopupViewController.h"
#import "FrtcPopupCell.h"
#import "FrtcPopupView.h"

#define    POP_CELL_HEIGHT    24

@interface FrtcPopupViewController ()<FrtcPopupViewDelegate>

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) FrtcPopupView *popView;

@property (nonatomic, copy) NSArray *array;

@end

@implementation FrtcPopupViewController

- (instancetype)initWithSection:(NSInteger)section withMeidaType:(NSInteger)type {
    self = [super init];
    
    if(self) {
        self.section = section;
        self.type    = type;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
    [self getDeviceList];
    self.popView.popViewdelegate = self;
    [self.view addSubview:self.popView];
    [self.popView reloadPopViewData];
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(onDeviceListChaned:) name:FMeetingDeviceListChangedNotification object:nil];
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
    [[FrtcUserDefault defaultSingleton] setObject:inuseMic forKey:DEFAULT_MICROPHONE];
    [[FrtcUserDefault defaultSingleton] setObject:inuseSpk forKey:DEFAULT_SPEAKER];
    
    [[FrtcUserDefault defaultSingleton] setObject:defaultMicName forKey:DEFAULT_MICROPHONE];
    [[FrtcUserDefault defaultSingleton] setObject:defaultSpeakerName forKey:DEFAULT_SPEAKER];
    
    
    NSInteger height;
    if(self.type == 1) {
        NSMutableArray* camList = [[NSMutableArray alloc] init];
        [[FrtcCall sharedFrtcCall] frtcCameraList:camList];
        self.array = @[camList];
        height = POP_CELL_HEIGHT * ([camList count] + 1) + 5;
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
        
        self.array = @[micNameArray, speakerNameArray];
        
        height = POP_CELL_HEIGHT * ([micNameArray count] + 1) + 5 + POP_CELL_HEIGHT * ([speakerNameArray count] + 1) + 5 ;
    }
    
    self.view.frame.size = NSMakeSize(166, height);
    [self.popView setFrame:CGRectMake(0, 0, 166, height)];

    
    [self.popView reloadPopViewData];
}


- (void)getDeviceList {
    NSInteger height;
    if(self.type == 1) {
        NSMutableArray* camList = [[NSMutableArray alloc] init];
        [[FrtcCall sharedFrtcCall] frtcCameraList:camList];
        self.array = @[camList];
        height = POP_CELL_HEIGHT * ([camList count] + 1) + 5;
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
        
        self.array = @[micNameArray, speakerNameArray];
        
        height = POP_CELL_HEIGHT * ([micNameArray count] + 1) + 5 + POP_CELL_HEIGHT * ([speakerNameArray count] + 1) + 5 ;
    }
    
    [self.view setFrame:CGRectMake(0, 0, 166, height)];
    self.popView = [[FrtcPopupView alloc] initWithFrame:CGRectMake(0, 0, 166, height)];
}

#pragma mark --FrtcPopupViewDelegate--
- (NSInteger)popupViewSectionCount {
    return [self.array count];
}

- (NSInteger)popupViewItemCountWithSection:(NSInteger)section {
    return [((NSMutableArray *)self.array[section]) count] + 1;
}

- (FrtcPopupCell *)frtcPopupViewWithSection:(NSInteger)section withRow:(NSInteger)row {
    FrtcPopupCell *cell = [[FrtcPopupCell alloc] init];
    
    if(row == 0) {
        cell.hover = NO;
    } else {
        cell.hover = YES;
    }
    
    if(self.type == 1) {
        if(row == 0) {
            cell.imageView.image = [NSImage imageNamed:@"icon_pop_camera"];
            cell.titleView.stringValue = NSLocalizedString(@"FM_SELECT_CAMERA", @"Select Camer");
            cell.titleView.textColor = [NSColor colorWithString:@"#666666" andAlpha:1];
        } else {
            NSMutableArray * array = ((NSMutableArray *)(self.array[section]));
            NSMutableDictionary *deviceInfo  = (NSMutableDictionary *)array[row-1];
            NSString *devName = [deviceInfo valueForKey:@"name"];
            
            cell.titleView.stringValue = devName;
            NSString *defaultCamera = [[FrtcUserDefault defaultSingleton] objectForKey:DEFAULT_CAMERA];
            if([devName isEqualToString:defaultCamera]) {
                cell.imageView.hidden = NO;
            } else {
                cell.imageView.hidden = YES;
            }
        }
    } else if(self.type == 0) {
        //NSLog(@"The section i is %ld, the row is %ld", section, row);
        if(row == 0 && section == 0) {
            //NSLog(@"row == 0 && section == 0");
            cell.imageView.image = [NSImage imageNamed:@"icon_pop_select_mic"];
            cell.titleView.stringValue = NSLocalizedString(@"FM_SEKECT_MICPHONE", @"Select Microphone");
            cell.titleView.textColor = [NSColor colorWithString:@"#666666" andAlpha:1];
        } else if(row == 0 && section == 1) {
            cell.imageView.image = [NSImage imageNamed:@"icon_pop_section"];
            cell.titleView.stringValue = NSLocalizedString(@"FM_SELECT_SPEAKER", @"Select Speaker");
            cell.titleView.textColor = [NSColor colorWithString:@"#666666" andAlpha:1];
        } else  {
            NSArray * array = ((NSMutableArray *)(self.array[section]));
            NSString *devName  = (NSString *)array[row-1];
            
            if(section == 0) {
                NSString *defaultMic = [[FrtcUserDefault defaultSingleton] objectForKey:DEFAULT_MICROPHONE];
                if([defaultMic isEqualToString:devName]) {
                    cell.imageView.hidden = NO;
                } else {
                    cell.imageView.hidden = YES;
                }
            }
            
            if(section == 1) {
                NSString *defaultSpk = [[FrtcUserDefault defaultSingleton] objectForKey:DEFAULT_SPEAKER];
                
                if([defaultSpk isEqualToString:devName]) {
                    cell.imageView.hidden = NO;
                } else {
                    cell.imageView.hidden = YES;
                }
            }
            
            cell.titleView.stringValue = devName;
        }
    }

    return cell;
}

- (void)shouldDidSelectedPopCell:(NSInteger)section withRow:(NSInteger)row {
    NSLog(@"The section is %ld, the row is %ld", section, row);
    NSString *devName;
    if(self.type == 1) {
        NSMutableArray * array = ((NSMutableArray *)(self.array[section]));
        NSMutableDictionary *deviceInfo  = (NSMutableDictionary *)array[row-1];
        devName = [deviceInfo valueForKey:@"name"];
    } else {
        NSArray * array = ((NSMutableArray *)(self.array[section]));
        devName  = (NSString *)array[row-1];
    }
    
    NSLog(@"---------------");
    
    NSLog(@"The select name is %@", devName);
    NSLog(@"---------------");
    
    if(self.type == 0) {
        if(section == 0) {//mic
            [[FrtcCall sharedFrtcCall] frtcSelectMic:devName];
            [[FrtcUserDefault defaultSingleton] setObject:devName forKey:DEFAULT_MICROPHONE];
        } else {
            [[FrtcCall sharedFrtcCall] frtcSelectSpeaker:devName];
            [[FrtcUserDefault defaultSingleton] setObject:devName forKey:DEFAULT_SPEAKER];
        }
    } else {
        [[FrtcUserDefault defaultSingleton] setObject:devName forKey:DEFAULT_CAMERA];
        [[FrtcCall sharedFrtcCall] frtcSelectCamera:devName];
    }
    
    [self.popView reloadPopViewData];
}

@end
