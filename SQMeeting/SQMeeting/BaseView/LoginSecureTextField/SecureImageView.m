#import "SecureImageView.h"

@implementation SecureImageView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if (self) {
        NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited;
        
        NSRect rect = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height);
        NSTrackingArea *focusTrackingArea = [[NSTrackingArea alloc] initWithRect:rect
                                                                         options:focusTrackingAreaOptions owner:self userInfo:nil];
        [self addTrackingArea:focusTrackingArea];
    }
    
    return self;
}

- (void)mouseEntered:(NSEvent *)event {
    [[NSCursor pointingHandCursor] set];
    if(self.secureImageViewDelegate && [self.secureImageViewDelegate respondsToSelector:@selector(lost)]) {
        [self.secureImageViewDelegate lost];
    }
    
    [self addCursorRect:[self bounds] cursor:[NSCursor pointingHandCursor]];
}

- (void)mouseExited:(NSEvent *)event {
    [[NSCursor arrowCursor] set];
    NSLog(@"789012e2w34");
}

- (void)mouseDown:(NSEvent *)event {
    [super mouseDown:event];
    [NSApp sendAction:@selector(clicked:) to:self from:self];
}

- (void)clicked:(id)sender {
    if(self.secureImageViewDelegate && [self.secureImageViewDelegate respondsToSelector:@selector(changePasswordView)]) {
        [self.secureImageViewDelegate changePasswordView];
    }
}


@end
