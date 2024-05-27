#import "FrtcMultiTypesButtonCell.h"

@implementation FrtcMultiTypesButtonCell

- (void)highlight:(BOOL)flag withFrame:(NSRect)cellFrame inView:(NSView *)controlView{
    [super highlight:flag withFrame:cellFrame inView:controlView];
    [self.delegate highlitCallBack:flag];
}

@end
