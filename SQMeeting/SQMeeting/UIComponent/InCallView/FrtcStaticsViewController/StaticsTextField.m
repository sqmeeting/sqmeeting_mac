#import "StaticsTextField.h"
#import "FrtcVerticalCenterTextFieldCell.h"

@implementation StaticsTextField

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)init {
    self = [super init];
    
    if(self) {
        self.cell = [[FrtcVerticalCenterTextFieldCell alloc] init];
    }
    
    return self;
}

@end
