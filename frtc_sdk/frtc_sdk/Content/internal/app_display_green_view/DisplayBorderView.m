#import "DisplayBorderView.h"

@implementation DisplayBorderView

- (void)drawRect: (NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSColor *strokeColor = [NSColor colorWithCalibratedRed:60/255.0 green:210/255.0 blue:60/255.0 alpha:1.0f];
    [strokeColor set];
    NSBezierPath* path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:1 yRadius:1];
    [path setLineWidth:10];
    [path stroke];
}


@end
