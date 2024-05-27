#import "FrtcReplaceButton.h"

@implementation FrtcReplaceButton

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    NSTrackingAreaOptions options = NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
}

- (void)mouseEntered:(NSEvent *)event {
    [[NSCursor pointingHandCursor] set];
}

- (void)mouseExited:(NSEvent *)event {
    [[NSCursor arrowCursor] set];
}

@end
