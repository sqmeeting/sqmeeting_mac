#import "FrtcBackGroundView.h"

@implementation FrtcBackGroundView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited;
        
        NSTrackingArea *focusTrackingArea = [[NSTrackingArea alloc] initWithRect:frameRect
                                                                         options:focusTrackingAreaOptions owner:self userInfo:nil];
        [self addTrackingArea:focusTrackingArea];
        
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor whiteColor].CGColor;
    }
    
    return self;
}

- (void)updateBKColor:(BOOL)flag {
    if (flag) {
        self.layer.backgroundColor = [NSColor colorWithString:@"#F8F9FA" andAlpha:1.0].CGColor;
    } else {
        self.layer.backgroundColor = [NSColor whiteColor].CGColor;
    }
}


#pragma mark  -- mouse evetn--
- (void)mouseEntered:(NSEvent *)event {
    [self updateBKColor:YES];
}

- (void)mouseExited:(NSEvent *)event {
    [self updateBKColor:NO];
}

@end
