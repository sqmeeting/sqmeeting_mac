#import "CallBarBackGroundView.h"

@implementation CallBarBackGroundView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if(self) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
        NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited;
        
        NSRect rect = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height);
        NSTrackingArea *focusTrackingArea = [[NSTrackingArea alloc] initWithRect:rect
                                                                         options:focusTrackingAreaOptions owner:self userInfo:nil];
        [self addTrackingArea:focusTrackingArea];
    }
    
    return self;
}

- (void)updateBKColor:(BOOL)flag {
    if (flag) {
        self.layer.backgroundColor = [NSColor colorWithString:@"#F0F0F5" andAlpha:0.7].CGColor;
    } else {
        self.layer.backgroundColor = [NSColor colorWithString:@"#FFFFFF" andAlpha:1.0].CGColor;
    }
}

- (void)mouseEntered:(NSEvent *)event {
    [self updateBKColor:YES];
}

- (void)mouseExited:(NSEvent *)event {
    [self updateBKColor:NO];
}

@end
