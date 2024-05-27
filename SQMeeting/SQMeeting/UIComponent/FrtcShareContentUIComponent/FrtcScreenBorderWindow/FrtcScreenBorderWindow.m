#import "FrtcScreenBorderWindow.h"
#import "CallResultReminderView.h"

#define WIDTH  640
#define HEIGHT 360

@implementation FrtcScreenBorderWindow

- (instancetype)init {
    self = [super init];
    
    if(self) {
        self.border = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 0, 0)
                                                  styleMask:NSWindowStyleMaskResizable
                                                    backing:NSBackingStoreBuffered
                                                      defer:YES];
        
        self.border.backgroundColor = [NSColor clearColor];
        self.border.opaque = NO;
        self.border.releasedWhenClosed = NO;
        self.border.hasShadow = NO;
        self.border.alphaValue = 1.0f;
        
        self.screenBorderView       = [[FrtcScreenBorderView alloc] initWithFrame:self.border.frame];
        self.screenAppBorderView    = [[FrtcScreenBorderAppView alloc] initWithFrame:self.border.frame];
        [self.border setContentView:self.screenBorderView];
        
        [self.border setDelegate:self];
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"- - - - - - [FrtcScreenBorderWindow] dealloc");
}

- (void)setBorderWindowFrameByScreenID:(NSUInteger)screenID {
    NSArray *screenArray = [NSScreen screens];
    
    for (NSInteger i = 0; i < [screenArray count]; i++) {
        NSScreen  *screen               = [screenArray objectAtIndex:i];
        NSDictionary  *dictionary       = [screen deviceDescription];
        NSNumber    *screenNumber       = [dictionary objectForKey:@"NSScreenNumber"];
        CGDirectDisplayID displayID     = [screenNumber unsignedIntValue];
        
        if (displayID == screenID) {
            NSRect rect = CGRectMake(screen.frame.origin.x, screen.frame.origin.x, screen.frame.size.width, screen.frame.size.height);
            [self.border setFrame:rect display:YES];
            
            break;
        }
    }
}

- (void)updateBackGroundView:(NSInteger)type {
    self.type = type;
    
    if(type == 0) {
        [self.border setContentView:self.screenBorderView];
    } else {
        [self.border setContentView:self.screenAppBorderView];
    }
}

- (void)borderWindowRect:(NSRect)rect {
    [self.border setFrame:rect display:NO];
}

- (void)showReminderView:(NSString *)stringValue {
    if(self.type == 0) {
        [self.screenBorderView showReminderView:stringValue];
    } else {
        [self.screenAppBorderView showReminderView:stringValue];
    }
}

- (void)displayBorderWindow:(BOOL)isDisplay {
    NSRect rect;
    
    if (NO == isDisplay) {
        rect = NSMakeRect(0, 0, 0, 0);
        
        [self borderWindowRect:rect];
        [self.border orderOut:self.border];
        return;
    } else {
        rect = NSMakeRect(0, 0, WIDTH, HEIGHT);
        
        [self borderWindowRect:rect];
        [self setBorderWindowFrameByScreenID:self.screenID];
        
        [self.border makeKeyAndOrderFront:NSApp];
        [self.border setLevel:NSStatusWindowLevel];
        [self.border setMovableByWindowBackground:NO];
        
        if ([self.border isVisible] == NO) {
            [self.border makeKeyAndOrderFront:NSApp];
            [self.border resignMainWindow];
        }
        [self.border setIgnoresMouseEvents:YES];
    }
}

@end
