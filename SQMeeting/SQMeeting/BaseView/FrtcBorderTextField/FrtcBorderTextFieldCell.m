#import "FrtcBorderTextFieldCell.h"

@implementation FrtcBorderTextFieldCell

- (NSRect)adjustedFrameToVerticallyCenterText:(NSRect)frame {
    CGFloat fontSize = self.font.boundingRectForFont.size.height;
    NSInteger offset = floor((NSHeight(frame) - ceilf(fontSize))/2);
    NSRect centeredRect = NSInsetRect(frame, 2, offset);
    return centeredRect;
}

- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView
               editor:(NSText *)editor delegate:(id)delegate event:(NSEvent *)event {
    [super editWithFrame:[self adjustedFrameToVerticallyCenterText:aRect]
                  inView:controlView editor:editor delegate:delegate event:event];
}

- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView
                 editor:(NSText *)editor delegate:(id)delegate
                  start:(NSInteger)start length:(NSInteger)length {
    
    [super selectWithFrame:[self adjustedFrameToVerticallyCenterText:aRect]
                    inView:controlView editor:editor delegate:delegate
                     start:start length:length];
}

- (void)drawInteriorWithFrame:(NSRect)frame inView:(NSView *)view {
    [[NSColor whiteColor] setFill];
    NSRectFill(frame);
    [super drawInteriorWithFrame:
     [self adjustedFrameToVerticallyCenterText:frame] inView:view];
}

@end
