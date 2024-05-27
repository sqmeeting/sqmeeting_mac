#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"
#import "Masonry.h"
#import "FrtcCall.h"
#import "FrtcMeetingManagement.h"
#import "FrtcUserDefault.h"
#import "FrtcCallInterface.h"
#import "FrtcMainViewController.h"
#import "FrtcAccountViewController.h"
#import "CommonNotification.h"
#import "FrtcUpdateMediaDevice.h"


@interface AppDelegate ()

@property (nonatomic, copy) NSString *meetingLink;

@property (nonatomic, strong) NSViewController *currentController;

@end

void displayReconfigurationCallBack (CGDirectDisplayID display, CGDisplayChangeSummaryFlags flags, void *userInfo) {
    if (flags & kCGDisplayAddFlag || flags & kCGDisplayRemoveFlag){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSNumber * numberAddRemoveDisplayID = [NSNumber numberWithUnsignedInt:display];
            NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys: numberAddRemoveDisplayID, FMeetingDisplayAddRemoveKey, nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:FMeetingDisplayAddRemoveNotification object:nil userInfo:userInfo];
        });
    }
}

@implementation AppDelegate

- (void)meetingStatus:(BOOL)isInMeeting {
    if (isInMeeting) {
        self.completedInitialization = YES;
        [self.window orderOut:self];
    } else {
        self.completedInitialization = NO;
        [self.window makeKeyAndOrderFront:self];
        [NSApp activateIgnoringOtherApps:YES];
    }
}

- (BOOL)windowShouldClose:(id)sender {
    [[self window] orderOut:nil];
    return  NO;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupMenu];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    CGDisplayRegisterReconfigurationCallback(displayReconfigurationCallBack, NULL);
    
    [FrtcCallInterface singletonFrtcCall];
    self.window.delegate = self;
    NSApp.appearance = [NSAppearance appearanceNamed:@"NSAppearanceNameAqua"];
    
    NSString *server = [[FrtcUserDefault defaultSingleton] objectForKey:STORAGE_SERVER_ADDRESS];
    server = [server isEqualToString:@""] ? @"" :server;
    
    BOOL mirrored = [[FrtcUserDefault defaultSingleton] boolObjectForKey:ENABLE_CAMREA_MIRROR];
    [[FrtcCall sharedFrtcCall] setCameraStreamMirror:mirrored];
    
    [[FrtcManagement sharedManagement] frtcSetSDKConfig:FRTCSDK_SERVER_ADDRESS withSDKConfigValue:server];
    
    [self registerNotification];
    
    self.window.title = @"";
    [NSThread detachNewThreadSelector:@selector(makeConfiguration:) toTarget:self withObject:nil];

    self.completedInitialization = NO;
    self.appInitialized = NO;
    
    [self.window setMovableByWindowBackground:YES];
    self.window.titlebarAppearsTransparent = YES;
    self.window.titleVisibility = NSWindowTitleHidden;
    
    NSString *userToken = [[FrtcUserDefault defaultSingleton] objectForKey:USER_TOKEN];
    
    BOOL autoSign = [[FrtcUserDefault defaultSingleton] boolObjectForKey:STORAGE_PASSWORD];
    if(!autoSign) {
        NSWindow *window = [NSApplication sharedApplication].windows.firstObject;
        window.contentMaxSize = NSMakeSize(640, 480);
        window.contentMinSize = NSMakeSize(640, 480);
        [window setContentSize:NSMakeSize(640, 480)];
        window.showsResizeIndicator = NO;
        self.currentController = [[FrtcMainViewController alloc] init];;
        window.contentView.frame.size = NSMakeSize(640, 480);//380, 660
        [window setContentView:self.currentController.view];
        [window standardWindowButton:NSWindowZoomButton].enabled = NO;
        
        [window makeKeyAndOrderFront:self];
        [NSApp activateIgnoringOtherApps:YES];
        self.appInitialized = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:FMeetingInitializedNotification object:nil userInfo:nil];
    } else {
        
        NSLog(@"The user token is %@", userToken);
        [[FrtcMeetingManagement sharedFrtcMeetingManagement] frtcGetLoginUserInfomation:userToken getInfoSuccess:^(LoginModel *model) {
            NSWindow *window = [NSApplication sharedApplication].windows.firstObject;
            window.title = NSLocalizedString(@"FM_APP_NAME", @"SQ Meeting CE ");
            window.contentMaxSize = NSMakeSize(380, 660);
            window.contentMinSize = NSMakeSize(380, 660);
            [window setContentSize:NSMakeSize(380, 660)];
            window.showsResizeIndicator = NO;
            self.currentController = [[FrtcAccountViewController alloc] init];
            ((FrtcAccountViewController *)(self.currentController)).model = model;
            window.contentView.frame.size = NSMakeSize(380, 660);//380, 660
            [window setContentView:self.currentController.view];
            [window standardWindowButton:NSWindowZoomButton].enabled = NO;
            
            [window makeKeyAndOrderFront:self];
            [NSApp activateIgnoringOtherApps:YES];
            
            self.appInitialized = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:FMeetingInitializedNotification object:nil userInfo:nil];
            });
            
        } getInfoFailure:^(NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSWindow *window = [NSApplication sharedApplication].windows.firstObject;
                window.contentMaxSize = NSMakeSize(640, 480);
                window.contentMinSize = NSMakeSize(640, 480);
                [window setContentSize:NSMakeSize(640, 480)];
                window.showsResizeIndicator = NO;
                self.currentController = [[FrtcMainViewController alloc] init];;
                window.contentView.frame.size = NSMakeSize(640, 480);//380, 660
                [window setContentView:self.currentController.view];
                [window standardWindowButton:NSWindowZoomButton].enabled = NO;
            
                [window makeKeyAndOrderFront:self];
                [NSApp activateIgnoringOtherApps:YES];
                
                self.appInitialized = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:FMeetingInitializedNotification object:nil userInfo:nil];
                });
            });
        }];
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [[FrtcCall sharedFrtcCall] frtcEndMeeting];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {
    if (self.isCompletedInitialization) {
        [[FrtcCallInterface singletonFrtcCall] rePopupApp];
        return YES;
    } else {
        [NSApp activateIgnoringOtherApps:NO];
        [self.window makeKeyAndOrderFront:self];
        return YES;
    }
}

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
    NSAppleEventManager *appleEventManager = [NSAppleEventManager sharedAppleEventManager];
    [appleEventManager setEventHandler:self
                           andSelector:@selector(processMeetingLinkEvent:withResponseEvent:)
                         forEventClass:kInternetEventClass
                            andEventID:kAEGetURL];
}

- (void)callMeetingByLink:(NSString *)meetingLink {
    NSArray *array = [meetingLink componentsSeparatedByString:@"://"];
    
    if([self parseUrl:array[1]]) {
        if([self.currentController isKindOfClass:[FrtcMainViewController class]]) {
            [((FrtcMainViewController *)self.currentController) makeUrlCall:array[1]];
        } else {
            [((FrtcAccountViewController *)self.currentController) makeUrlCall:array[1]];
        }
    }
}

- (BOOL)parseUrl:(NSString *)url {
    NSDictionary *dictionary = [[FrtcCall sharedFrtcCall] parseWebUrl:url];
    
    if([dictionary.allKeys containsObject:@"operation"]) {
        if(self.isCompletedInitialization) {
            [[FrtcCallInterface singletonFrtcCall] toastInfomation];
            
            return NO;
        }
        BOOL agreeProtocol = [[FrtcUserDefault defaultSingleton] boolObjectForKey:AGREE_PROTOCOL];
        if(!agreeProtocol) {
            return NO;
        }
        
        NSString *server = [[FrtcUserDefault defaultSingleton] objectForKey:STORAGE_SERVER_ADDRESS];
        if(![((NSString *)dictionary[@"meeting_url"]) containsString:server]) {
            if([self.currentController isKindOfClass:[FrtcMainViewController class]]) {
                [((FrtcMainViewController *)self.currentController) showServerErrorInfo];
            } else {
                [((FrtcAccountViewController *)self.currentController) showServerErrorInfo];
            }
            
            return NO;
        }
        if([self.currentController isKindOfClass:[FrtcMainViewController class]]) {
            [((FrtcMainViewController *)self.currentController) showLoginInfo];
            
            return NO;
        }
        
        [((FrtcAccountViewController *)self.currentController) addMeeing:dictionary[@"meeting_url"]];
        
        return NO;
    } else {
        return YES;
    }
}

- (void)replayToCompletedInitialization:(NSNotification *)notification {
    [self callMeetingByLink:self.meetingLink];
}

- (void)processMeetingLinkEvent:(NSAppleEventDescriptor *)event
           withResponseEvent:(NSAppleEventDescriptor *)descriptor {
    NSString    *meetingLink = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
    
    if(!self.isAppInitialized) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replayToCompletedInitialization:) name:FMeetingInitializedNotification object:nil];
        
        self.meetingLink = meetingLink;
        
        return;
    }
    

    [self callMeetingByLink:meetingLink];
}

#pragma mark -- reigister notification
- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMainViewNotification:) name:FrtcMeetingMainViewShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLoginViewNotification:) name:FrtcMeetingLoginViewShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceListChaned:) name:FMeetingDeviceListChangedNotification object:nil];
}

#pragma mark -- implement notification
- (void)onDeviceListChaned:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSDictionary *inUseDev = [userInfo valueForKey:FMeetingDeviceListInUseKey];

    
    NSString *defaultMicName = [inUseDev valueForKey:@"defaultMicName"];
    NSString *defaultSpeakerName = [inUseDev valueForKey:@"defaultSpeakerName"];
    
    [[FrtcUserDefault defaultSingleton] setObject:defaultMicName forKey:DEFAULT_MICROPHONE];;
  
    if(defaultMicName == nil || defaultSpeakerName == nil) {
        return;
    }
    

    [[FrtcCall sharedFrtcCall] frtcSelectMic:defaultMicName];
    [[FrtcUserDefault defaultSingleton] setObject:defaultSpeakerName forKey:DEFAULT_SPEAKER];
    [[FrtcCall sharedFrtcCall] frtcSelectSpeaker:defaultSpeakerName];
}

- (void)receiveMainViewNotification:(NSNotification*)noti {
    [[FrtcCall sharedFrtcCall] frtcLogout];
    NSLog(@"received device match notification:%@",noti.userInfo);
    NSWindow *window = [NSApplication sharedApplication].windows.firstObject;
    window.contentMaxSize = NSMakeSize(640, 480);
    window.contentMinSize = NSMakeSize(640, 480);
    [window setContentSize:NSMakeSize(640, 480)];
    
    window.showsResizeIndicator = NO;
    self.currentController = [[FrtcMainViewController alloc] init];
    
    NSLog(@"%@", window);
    window.contentView.frame.size = NSMakeSize(640, 480);
    [window setContentView:self.currentController.view];
    [window standardWindowButton:NSWindowZoomButton].enabled = NO;
    
    [window makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)receiveLoginViewNotification:(NSNotification*)noti {
    NSWindow *window = [NSApplication sharedApplication].windows.firstObject;
    window.contentMaxSize = NSMakeSize(380, 660);
    window.contentMinSize = NSMakeSize(380, 660);
    [window setContentSize:NSMakeSize(380, 660)];
    
    window.showsResizeIndicator = NO;
    self.currentController = [[FrtcAccountViewController alloc] init];
    ((FrtcAccountViewController *)(self.currentController)).model = noti.userInfo[@"loginmodel"];
    
    NSLog(@"%@", window);
    window.contentView.frame.size = NSMakeSize(380, 660);
    [window setContentView:self.currentController.view];
    [window standardWindowButton:NSWindowZoomButton].enabled = NO;
    
    [window makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
}

#pragma mark- -- view control
- (void)showDeviceController:(NSViewController *)controller {
    [self showController:controller];
}

- (void)showMainController:(NSViewController *)controller {
    [self showController:controller];
}

- (void)showController:(NSViewController *)controller {
    [[NSApplication sharedApplication].windows.firstObject setContentView:controller.view];
    [[NSApplication sharedApplication].windows.firstObject standardWindowButton:NSWindowZoomButton].enabled = NO;
    
    [[NSApplication sharedApplication].windows.firstObject makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)makeConfiguration:(NSObject *)object {
    NSString *serverAddress = [[FrtcUserDefault defaultSingleton] objectForKey:STORAGE_SERVER_ADDRESS];
    if(serverAddress != nil || ![serverAddress isEqualToString:@""]) {
        [[FrtcCall sharedFrtcCall] frtcSetConfig:FRTC_SAVE_SERVER_ADDRESS withSDKConfigValue:serverAddress];
    }
    
    BOOL intelligengNoiseReduction = [[FrtcUserDefault defaultSingleton] boolObjectForKey:INTELLIGENG_NOISE_REDUCTION];
    
    if(intelligengNoiseReduction) {
        [[FrtcCall sharedFrtcCall] frtcSetConfig:FRTC_ENABLE_NOISE_REDUCTIION withSDKConfigValue:ENABLE];
    } else {
        [[FrtcCall sharedFrtcCall] frtcSetConfig:FRTC_ENABLE_NOISE_REDUCTIION withSDKConfigValue:DISABLE];
    }
    
    [[FrtcUpdateMediaDevice mediaDeviceSingleton] updateMediaDevice];
}

- (void)setupMenu {
    NSMenu *frtcMainMenu = [[NSApplication sharedApplication] mainMenu];
    
    NSMenu *menu = [[frtcMainMenu itemAtIndex:0] submenu];
    NSMenuItem *Item1 = [[menu itemArray] objectAtIndex:0];
    [Item1 setHidden:YES];

    NSMenuItem *Item2 = [[menu itemArray] objectAtIndex:2];
    [Item2 setHidden:YES];
 
    NSMenuItem *Item6 = [[menu itemArray] objectAtIndex:6];
    [Item6 setHidden:YES];
    
    NSMenuItem *Item7 = [[menu itemArray] objectAtIndex:7];
    [Item7 setHidden:YES];
    
    NSMenuItem *Item8 = [[menu itemArray] objectAtIndex:8];
    [Item8 setHidden:YES];

    NSMenuItem *Itme10 = [[menu itemArray] objectAtIndex:10];
    [Itme10 setTitle:NSLocalizedString(@"FM_MENU_QUIT", @"Quit FMeeting")];
    
    NSMenu *secondMenu = [[frtcMainMenu itemAtIndex:6] submenu];
    [secondMenu setTitle:NSLocalizedString(@"FM_MENU_HELP", @"Help")];
 
    NSMenuItem *secondItem = [[secondMenu itemArray] objectAtIndex:0];
    [secondItem setTitle:NSLocalizedString(@"FM_MENU_HELP", @"Help")];
}

@end
