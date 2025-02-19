#import "HoverImageView.h"

@implementation HoverImageView

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
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didIntoArea:withSenderTag:)]) {
        [self.delegate didIntoArea:YES withSenderTag:self.tag];
    }
}

- (void)mouseExited:(NSEvent *)event {
    [[NSCursor arrowCursor] set];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didIntoArea:withSenderTag:)]) {
        [self.delegate didIntoArea:NO withSenderTag:self.tag];
    }
}

- (void)mouseDown:(NSEvent *)event {
    [self becomeFirstResponder];
    //[super mouseDown:event];
    [NSApp sendAction:@selector(clicked:) to:self from:self];
}

- (void)clicked:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(hoverImageViewClickedwithSenderTag:)]) {
        [self.delegate hoverImageViewClickedwithSenderTag:self.tag];
    }
}

@end
