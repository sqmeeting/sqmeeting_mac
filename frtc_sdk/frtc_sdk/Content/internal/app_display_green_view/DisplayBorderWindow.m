#import "DisplayBorderWindow.h"
#import "DisplayBorderView.h"

@implementation DisplayBorderWindow

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)windowStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)deferCreation {
    
    self = [super initWithContentRect:contentRect
                                 styleMask:windowStyle
                                   backing:bufferingType
                                     defer:deferCreation];
    
    if(self) {
        DisplayBorderView* backgroundView = [[DisplayBorderView alloc] initWithFrame:contentRect];
        [self.contentView setAutoresizesSubviews:YES];
        [backgroundView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        [self.contentView addSubview:backgroundView];
        [self setAlphaValue:0.7f];
        self.releasedWhenClosed = NO;
    }
 
    return self;
}

@end
