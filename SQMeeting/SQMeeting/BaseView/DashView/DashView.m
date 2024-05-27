#import "DashView.h"

@implementation DashView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    CGFloat dashHeight = 2.0;
    CGContextRef contextRef = [NSGraphicsContext currentContext].CGContext;

    CGContextSetLineWidth(contextRef, dashHeight);
    CGFloat lengths[] = {1,2};
    
    CGContextSetLineDash(contextRef, 0, lengths, 2);

    CGContextSetStrokeColorWithColor(contextRef, [NSColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0].CGColor);
    
    CGContextAddRect(contextRef, CGRectInset(self.bounds, dashHeight, dashHeight));
    CGContextStrokePath(contextRef);
}

@end
