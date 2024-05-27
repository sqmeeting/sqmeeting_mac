#import "FrtcMainWindow.h"
#import "FrtcSettingViewController.h"
#import "AppDelegate.h"

@interface FrtcMainWindow ()

@property (nonatomic, assign) NSSize        windowSize;

@property (nonatomic, assign) NSRect        windowFrame;

@property (nonatomic, strong) NSView        *parentView;

@property (nonatomic, assign) BOOL          defaultCenter;

@property (nonatomic, weak)   AppDelegate   *appDelegate;

@end
@implementation FrtcMainWindow

- (instancetype)initWithSize:(NSSize)size {
    self = [super init];
    
    if(self) {
        self.defaultCenter = YES;
        self.windowSize = size;
        self.releasedWhenClosed = NO;
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
    }
    
    return self;
}

- (void)showWindowWithWindow:(NSWindow *)window {
    NSView* view = window.contentView;
    NSRect frameRelativeToWindow = [view convertRect:view.bounds toView:nil];
    NSPoint pointRelativeToScreen = [view.window convertRectToScreen:frameRelativeToWindow].origin;
    NSPoint pos = NSZeroPoint;
    if (self.defaultCenter) {
        pos.x = pointRelativeToScreen.x + (view.bounds.size.width-self.windowSize.width-view.frame.origin.x)/2;
        pos.y = pointRelativeToScreen.y + (view.bounds.size.height-self.windowSize.height-view.frame.origin.y)/2;
    } else {
        pos = self.frame.origin;
    }
    [self setFrame:NSMakeRect(0, 0, self.windowSize.width, self.windowSize.height) display:YES];
    [self setFrameOrigin:pos];
    [view.window addChildWindow:self ordered:NSWindowAbove];
    
    [self setParentView:view];
    [self makeKeyAndOrderFront:self.parentWindow];
}

- (void)showWindow {
    self.appDelegate = (AppDelegate*)[NSApplication sharedApplication].delegate;
    NSWindow* window = [NSApplication sharedApplication].windows.firstObject;
    NSView* view = window.contentView;
    NSRect frameRelativeToWindow = [view convertRect:view.bounds toView:nil];
    NSPoint pointRelativeToScreen = [view.window convertRectToScreen:frameRelativeToWindow].origin;
    NSPoint pos = NSZeroPoint;
    if (self.defaultCenter) {
        pos.x = pointRelativeToScreen.x + (view.bounds.size.width-self.windowSize.width-view.frame.origin.x)/2;
        pos.y = pointRelativeToScreen.y + (view.bounds.size.height-self.windowSize.height-view.frame.origin.y)/2;
    } else {
        pos = self.frame.origin;
    }
    [self setFrame:NSMakeRect(0, 0, self.windowSize.width, self.windowSize.height) display:YES];
    [self setFrameOrigin:pos];
    [view.window addChildWindow:self ordered:NSWindowAbove];
    self.parentView = view;
    [self makeKeyAndOrderFront:self.parentWindow];
}

- (void)adjustToSize:(NSSize)size {
    NSRect frameRelativeToWindow = [self.parentView convertRect:self.parentView.bounds toView:nil];
    NSPoint pointRelativeToScreen = [self.parentView.window convertRectToScreen:frameRelativeToWindow].origin;
    NSPoint pos = NSZeroPoint;
    pos.x = pointRelativeToScreen.x + (self.parentView.bounds.size.width-size.width-self.parentView.frame.origin.x)/2;
    pos.y = pointRelativeToScreen.y + (self.parentView.bounds.size.height-size.height-self.parentView.frame.origin.y)/2;
    [self setFrame:NSMakeRect(0, 0, size.width, size.height) display:YES];
    [self setFrameOrigin:pos];
}


- (void)dealloc {
    NSLog(@"FrtcMainWindow dealloc");
}

- (void)updataSettingComboxWithUserSelectMenuButtonGridMode:(BOOL)isGridMode {
    if([self.contentViewController isKindOfClass:[FrtcSettingViewController class]]) {
        [((FrtcSettingViewController *)(self.contentViewController)) updataSettingComboxWithUserSelectMenuButtonGridMode:isGridMode];
    }
}

- (void)close {
    [super close];
    
    if([self.contentViewController isKindOfClass:[FrtcSettingViewController class]]) {
        [((FrtcSettingViewController *)(self.contentViewController)) stopLocalViewRender];
        [[NSNotificationCenter defaultCenter] postNotificationName:FMeetingSettingViewCloseNotification object:nil userInfo:nil];
    }
    
   
}
@end
