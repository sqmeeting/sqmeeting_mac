#import "FrtcButtonCell.h"

@implementation FrtcButtonCell

- (void)highlight:(BOOL)flag withFrame:(NSRect)cellFrame inView:(NSView *)controlView{
    [super highlight:flag withFrame:cellFrame inView:controlView];
    [self.delegate highlitCallBack:flag];
}

- (BOOL)_textDimsWhenDisabled {
    return NO;
}

- (BOOL)_shouldDrawTextWithDisabledAppearance {
    return NO;
}

@end
