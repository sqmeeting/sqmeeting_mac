#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate ,NSWindowDelegate>

@property (weak) IBOutlet NSWindow *window;

- (void)meetingStatus:(BOOL)isInMeeting;

@property (nonatomic, assign, getter=isCompletedInitialization) BOOL completedInitialization;

@property (nonatomic, getter=isAppInitialized) BOOL appInitialized;

@end

