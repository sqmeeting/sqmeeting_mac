#import "FrtcRequestUnMuteListWindow.h"

@interface FrtcRequestUnMuteListWindow ()

@end

@implementation FrtcRequestUnMuteListWindow

- (instancetype)initWithSize:(NSSize)size {
    self = [super init];
    
    if(self) {
        self.releasedWhenClosed = NO;
        self.styleMask = self.styleMask | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskClosable;
        self.titlebarAppearsTransparent = YES;
        self.backgroundColor = [NSColor whiteColor];
        [self standardWindowButton:NSWindowZoomButton].enabled = NO;
        [self standardWindowButton:NSWindowCloseButton].enabled = YES;
        [self standardWindowButton:NSWindowMiniaturizeButton].enabled = NO;
        [[self standardWindowButton:NSWindowZoomButton] setHidden:YES];
        [[self standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
        [[self standardWindowButton:NSWindowCloseButton] setHidden:NO];
        self.contentMaxSize = size;
        self.contentMinSize = size;
        [self setContentSize:size];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWindow:) name:FMeetingCallCloseNotification object:nil];
    }
    
    return self;
}

- (void)closeWindow:(NSNotification*)notification {
    [self close];
}



@end
