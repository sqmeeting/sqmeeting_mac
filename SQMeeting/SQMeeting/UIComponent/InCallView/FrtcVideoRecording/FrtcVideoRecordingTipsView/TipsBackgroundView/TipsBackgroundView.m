#import "TipsBackgroundView.h"

@implementation TipsBackgroundView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.wantsLayer = YES;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.0;
        self.layer.backgroundColor = [NSColor colorWithString:@"#000000" andAlpha:0.8].CGColor;
       // self.window.isOpaque = NO;
    }
    
    return self;
}

@end
